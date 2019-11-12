---
Title: Continuous Delivery in Wikimedia
Subtitle: The Future of the Deployment Pipeline
---
# Continuous Delivery in Wikimedia
**The Future of the Deployment Pipeline**

<aside class="notes"> 
Quick check in on the state of affairs in the Pipeline work, and more interestingly what are the plans, upcoming challanges and expected timelines

What do we want out of this session?
I think the main things are: increase familiarity + collect feedback/usecases to see where this falls short
                                                                                                                                                       
* Walkthrough                                                                                                                                          
** What can the pipeline do for you currently?                                                                                                         
** Increase adoption/familiarity                                                                                                                       
* Where does this fallshort?                                                                                                                           
* New CI                                                                                                                                               
** Improving backend of the service                                                                                                                    
** Self-serve                                                                                                                                          
** Argo                                                                                                                                                                                                                                                
</aside>                                                                                                                                               
                                                                                                                                                       
## Session Goals                                                                                                                                       
                                                                                                                                                       
* Show off what we've done so far, show you what the current pipeline can do for you                                                                   
* Get feedback on our current implementation to help inform future iterations                                                                          
* Point more folks to the design work we've done for future iterations                                                                                 
                                                                                                                                                       
# Walkthrough                                                                                                                                         
                                                                                                                                                       
* There are quite a few moving pieces                                                                                                                  
* To understand how they fit together, let's look at how to run `npm test`                                                                             

## Define a test entrypoint                                                                                                                             
                                                                                                                                                       
`.pipeline/blubber.yaml`                                                                                                                               
                                                                                                                                                       
```{.yaml}                                                                                                                                             
version: v4                                                                                                                                            
base: docker-registry.wikimedia.org/nodejs-devel                                                                                                       
                                                                                                                                                       
variants:                                                                                                                                              
    test:                                                                                                                                              
      copies: [local]                                                                                                                                  
      node: {requirements: [package.json]}                                                                                                             
      entrypoint: [npm, test]                                                                                                                          
```                                                                                                                                                    
                                                                                                                                                       
## Tell the pipeline to run the test entrypoint                                                                                                         
                                                                                                                                                       
`.pipeline/config.yaml`                                                                                                                                
                                                                                                                                                       
```{.yaml}                                                                                                                                             
pipelines:                                                                                                                                             
  test:                                                                                                                                                
    blubberfile: blubber.yaml                                                                                                                          
    stages:                                                                                                                                            
      - name: test                                                                                                                                     
```             
## Let's add linting as well                                                                                                                            
                                                                                                                                                       
`.pipeline/blubber.yaml`                                                                                                                               
                                                                                                                                                       
```{.yaml}                                                                                                                                             
version: v4                                                                                                                                            
base: docker-registry.wikimedia.org/nodejs-devel                                                                                                       
                                                                                                                                                       
variants:                                                                                                                                              
    build:                                                                                                                                             
      copies: [local]                                                                                                                                  
      node: {requirements: [package.json]}                                                                                                             
    test: {includes: [build], entrypoint: [npm, test]}                                                                                                 
    lint: {includes: [build], entrypoint: [npm, lint]}                                                                                                 
```                                                                                                                                                    
                                                                                                                                                       
## ...run in parallel                                                                                                                                   
                                                                                                                                                       
`.pipeline/config.yaml`                                                                                                                                
                                                                                                                                                       
```{.yaml}                                                                                                                                             
pipelines:                                                                                                                                             
  test:                                                                                                                                                
    blubberfile: blubber.yaml                                                                                                                          
    stages: [{name: test}, {name: lint}]                                                                                                               
    execution: [[test],[lint]]                                                                                                                         
```            

# Current Status

## Today
* Everything you've seen so far works right now
* Getting it into CI involves poking RelEng

## Future
* Self-serve CI
* Argo Project

# Shortcomings

## Known unknowns
* Integration tests
* Language support


## Unknown unknowns
* ???








