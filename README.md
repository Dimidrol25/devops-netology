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
