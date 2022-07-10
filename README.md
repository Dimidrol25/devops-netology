# devops-netology

Domashnee Zadanie
Modified

В папке /terraform будут проигнорированы следующие объекты:
1. Локальная скрытая папка .terraform  с ее содержимым;
2. Файлы с расширением .tfstate и файлы содержашие в имени любые значения до и после .tfstate.;
3. Файл crash.log и файлы, содержащие в имени любые значения между crash. и .log;
4. Файлы с расширением .tfvars;
5. Файлы override.tf, override.tf.json и файлы, содержащие в имени любые значения до _override.tf и до _override.tf.json;
6. файлы .terraformrc и terraform.rc.

---------------------------------------

2.4. Инструменты Git

1. git log --pretty=oneline |  grep ^aefea

aefead2207ef7e2aa5dc81a34aedf0cad4c32545 Update CHANGELOG.md

2. git show --tags --pretty=oneline | grep 85024d3

85024d3100126de36331c6982bfaac02cdab9e76 v0.12.23

3. У коммита b8d720 2 родителя. 

 - git show b8d72

Merge: 56cd7859e 9ea88f22f

 - git cat-file -p b8d720

parent 56cd7859e05c36c06b56d013b55a252d0bb7e158

parent 9ea88f22fc6269854151c571162c5bcf958bee2b

4. git log --oneline v0.12.23...v0.12.24

33ff1c03b (tag: v0.12.24) v0.12.24

b14b74c49 [Website] vmc provider links

3f235065b Update CHANGELOG.md

6ae64e247 registry: Fix panic when server is unreachable

5c619ca1b website: Remove links to the getting started guide's old location

06275647e Update CHANGELOG.md

d5f9411f5 command: Fix bug when using terraform login on Windows

4b6d06cc5 Update CHANGELOG.md

dd01a3507 Update CHANGELOG.md

225466bc3 Cleanup after v0.12.23 release

5. git log -S'func providerSource' --oneline

8c928e835 main: Consult local directories as potential mirrors of providers

6. git log --oneline -G'globalPluginDirs'

22a2580e9 main: Use the new cliconfig package credentials source

35a058fb3 main: configure credentials from the CLI config file

c0b176109 prevent log output during init

8364383c3 Push plugin discovery down into command package

7. Отследить автора можно также как и в 5 задании, отслеживая создание функции с подробным результатом.

git log -S'synchronizedWriters'

Author: Martin Atkins
