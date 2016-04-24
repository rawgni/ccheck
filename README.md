# ccheck

Bash script for doing compatibility check using docker.

Inspired by autochecker (https://github.com/VictorBjelkholm/autochecker/)

## Usage

You will need to have Docker (https://www.docker.com) installed.

- Create a custom Dockerfile template for your project.
- invoke `ccheck.sh <template> [version]*`

`$ ccheck.sh Dockerfile.tmpl 4.4.2 5.10.1 latest`

## Example Dockerfile template

```
FROM node:$VERSION
COPY package.json /tmp/package.json
WORKDIR /tmp
RUN npm install
COPY test.js /tmp/.
CMD node test.js
```

## Output

The script produces TAP 13 output (https://testanything.org/tap-version-13-specification.html)

Example:

```
TAP version 13
1..3
not ok 1 - ver. 0.10.44
 ---
	
	/tmp/test.js:3
	test('simple test', (t) => {
	                         ^
	SyntaxError: Unexpected token >
	    at Module._compile (module.js:439:25)
	    at Object.Module._extensions..js (module.js:474:10)
	    at Module.load (module.js:356:32)
	    at Function.Module._load (module.js:312:12)
	    at Function.Module.runMain (module.js:497:10)
	    at startup (node.js:119:16)
	    at node.js:945:3

 ...
ok 2 - ver. 4.4.2
ok 3 - ver. 5.10.1

#tests 3
#pass  2
#fail  1
```
