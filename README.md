# nuBuilder4-cloner

## Features:

- Clone Forms with all PHP events, select, select clause, browse, tabs
- Clone Objects with their events etc.
- Include only certain form tabs
- Copy objects to a new or existing form
- Dump the sql statements instead of executing them

## Use cases:

-	Clone a form to test changes before they are integrated into the productive system 
-	You created a form and want to duplicate it because you need a similar form (Instead of recreating it from scratch)
-	You want to copy a bunch of controls from one form to another
- You want other users than globeadmin (e.g. supervisors/managers) to manage the nubuilder users. Clone nuBuilder's user form, customize it and give access to any users.


## Setting up the 'cloner'

Create a [Procedure](https://wiki.nubuilder.net/nubuilderforte/index.php/Procedures): *Tab Builders -> Procedure -> Add* 

Fill in the form with:

1. **Code**: cloner

2. **Description**: Clone Forms, Objects, Events, PHP etc.

3. **Run**: Hidden

4. **PHP**: Paste the code from the file [nubuilder_cloner.php](https://github.com/smalos/nuBuilder4-cloner/blob/main/nubuilder_cloner.php)

Hit Save


## Usage Examples:

To test/run the examples, use the Developer Console (F12).

### 1. Clone the current Form:

-> Open any form first. 

```php
nuRunPHPHidden('cloner', 0);
```

Result: The current form has been cloned. (A _clone postifx has been added to the form code)

### 2. Clone any Form

```php
nuSetProperty('cloner_f1','5f53ade2954fe21'); // The form to clone. Replace 5f53ade2954fe21 with any existing form id
nuRunPHPHidden('cloner', 0);
```

### 3. Clone the objects of a form and insert them in another existing form

```php
nuSetProperty('cloner_f1','5f53ade2954fe21'); // Source form: Replace  5f53ade2954fe21 with any existing form id
nuSetProperty('cloner_f2','5f53ade2954fe22'); // Destination form: Replace  5f53ade2954fe22 with any existing form id
nuRunPHPHidden('cloner', 0);
```

### 4: Include only certain tabs

E.g. to include only the controls of the first two tabs:

```php
nuSetProperty('cloner_tabs',JSON.stringify([1,2]));
nuRunPHPHidden('cloner', 0);
```

Note: To include all tabs (again), call nuSetProperty('cloner_tabs','');

### 5: Copy all object in the 1st tab of a form to another form

```php
nuSetProperty('cloner_tabs',JSON.stringify([1]));
nuSetProperty('cloner_f1','5f53ade2954fe21'); // Source form: Replace  5f53ade2954fe21 with any existing form id
nuSetProperty('cloner_f2','5f53ade2954fe22'); // Destination form: Replace  5f53ade2954fe22 with any existing form id
nuRunPHPHidden('cloner', 0);
```

### 6: Clone the current form without objects 

```php
nuSetProperty('cloner_without_objects', "1");
nuSetProperty('cloner_tabs','');
nuSetProperty('cloner_f1','');
nuSetProperty('cloner_f2','');
nuRunPHPHidden('cloner', 0);
```

### 7: Do not show the new form after cloning

```php
nuSetProperty('cloner_open_new_form', "0");
nuRunPHPHidden('cloner', 0);
```

### 8: Dump the SQL statements instead of executing them

```php
nuSetProperty('cloner_dump','1');
nuSetProperty('cloner_without_objects', "0");
nuSetProperty('cloner_tabs','');
nuSetProperty('cloner_f1','');
nuSetProperty('cloner_f2','');
nuRunPHP('cloner', '',1);
```
