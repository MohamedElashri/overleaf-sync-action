# Overleaf Git Sync
Github action to sync my local overleaf instance projects with github

## Fork for you own instance? 
If you want to adapt it to your selfhosted instance you can make necessary changes in `source/entrypoint.sh` file for url of your instance. 
Then you will need to draft a release and publish the github action to the store. You will need to change `action.yml`with unique action name as martketplace requires that. 

## Usage 
Action need to connect to your account through cookies. so you need to add those two environment variables to github secrets. 

`OVERLEAF_COOKIE` > Cookies path

`OVERLEAF_PROJECT_ID`> The id of the project you want to sync it with current repository 

Then create an action (i.e `.github/workflows/overleaf-sync.yml`) with the contents 

```
name: Overleaf Git Sync
on:
  schedule:
    - cron: "5 * * * *"
  push:
  workflow_dispatch:
      
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - name: Fetch the latest version from overleaf server
      uses: MohamedElashri/overleaf-sync-action@v1
      with:
        OVERLEAF_PROJECT_ID: ${{ secrets.OVERLEAF_PROJECT_ID }}
        OVERLEAF_COOKIE: ${{ secrets.OVERLEAF_COOKIE }}

    - name: Upload to Project Artifacts
      uses: actions/upload-artifact@v2
      with:
        name: project
        path: ./artifacts/

    - uses: actions/checkout@v2
      with:
        path: repo/
    
    - run: |
        cd repo/
        mkdir -p overleaf_remote_src
        cp -r ../artifacts/* ./overleaf_remote_src
        git config user.name "Overleaf Sync Bot"
        git config user.email "actions@github.com"
        git add .
        if [[ $(git diff HEAD --stat) == '' ]]; then (echo 'Working tree is clean') 
        else (git commit -m "Sync with overleaf remote"  && git push) fi




```
