# nuBuilder 4 "cloner"

## Features:

- Clone/duplicate a form with all its (PHP) events.
- Clone form objects 
- Clone embedded subforms
- Clone embedded iframe (run) forms
- Include only certain form tabs
- Copy objects to a new or existing form
- Dump the SQL INSERT statements to the browser window instead of executing them

## Use cases:

- Clone a form to test changes before they are integrated into the productive system
- Export a form from one database and import it into another one
- You created a form and want to duplicate it because you need a similar form (Instead of recreating it from scratch)
- You want to copy a bunch of controls from one form to another
- You want other users than globeadmin (e.g. supervisors/managers) to manage the nubuilder users. Clone nuBuilder's user form, customize it and give access to any users.

## Setting up the "cloner"

Create a [Procedure](https://wiki.nubuilder.net/nubuilderforte/index.php/Procedures): *Tab Builders -> Procedure -> Add* 

Fill in the form with:

1. **Code**: cloner
2. **Description**: Clone Forms, Objects, Events, PHP etc.
3. **Run**: Hidden
4. **PHP**: Paste the code from the file [nubuilder_cloner.php](https://github.com/smalos/nuBuilder4-cloner/blob/main/nubuilder_cloner.php)

Click "Save"

## Usage

There are two different ways to use the "cloner". 

1. Either run it directly from the Developer Console (see Usage Examples below) 
2. or use the [form (GUI)](/form)


## Cloner settings:

nuRunPHPHidden() is used to set Hash Cookies and pass arguments from JavaScript to the cloner script.

- **cloner_source**
  - (Optional) The form ID (primary key) of the source form to clone. The current form is used if empty/not set.
- **cloner_dest**
  - (Optional) The form ID (primary key) of the destination form. A new form is created if empty/not set.
- **cloner_tabs**
  - (Optional) Specify the tabs to include. By default, all tabs are included.
- **cloner_objects**
  - (Optional, default: 1) If set to "0", only the form is cloned, without its objects.
- **cloner_subforms**
  - (Optional, default: 0) If set to "1", also clone the embedded subforms.
- **cloner_iframe_forms**
  - (Optional, default: 0) If set to "1", also clone the embedded iframe (run) forms.
- **cloner_new_pks**
  - (Optional: default: 0) If set to "0", no new primary keys are generated. This option is only available in dump mode.
- **cloner_dump**
  - (Optional, default: 0) If set to "1", dump the SQL INSERT statements to the browser window instead of executing them.

Use nuRunPHP() if the dump modus, nuSetProperty('cloner_dump','1'), is used.


## Usage Examples:

To test/run the examples, use the Developer Console (F12).

### 1. Clone the current Form:

Open any form first. Then run this JavaScript:

```php
nuRunPHPHidden('cloner', 0);
```

Result: The current form has been cloned. (A "_clone" postifx has been added to the form code)

### 2. Clone any Form

```php
nuSetProperty('cloner_source','5f53ade2954fe21'); // The form to clone. Replace 5f53ade2954fe21 with any existing form id
nuRunPHPHidden('cloner', 0);
```

### 3. Clone the objects of a form and insert them in another existing form

```php
nuSetProperty('cloner_source','5f53ade2954fe21'); // Source form: Replace 5f53ade2954fe21 with any existing form id
nuSetProperty('cloner_dest','5f53ade2954fe22'); // Destination form: Replace 5f53ade2954fe22 with any existing form id
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
nuSetProperty('cloner_source','5f53ade2954fe21'); // Source form: Replace  5f53ade2954fe21 with any existing form id
nuSetProperty('cloner_dest','5f53ade2954fe22'); // Destination form: Replace  5f53ade2954fe22 with any existing form id
nuRunPHPHidden('cloner', 0);
```

### 6: Clone the current form without its objects 

```php
nuSetProperty('cloner_objects', "1");
nuSetProperty('cloner_tabs','');
nuSetProperty('cloner_source','');
nuSetProperty('cloner_dest','');
nuRunPHPHidden('cloner', 0);
```

### 7: Dump the SQL statements instead of executing them

```php
nuSetProperty('cloner_dump','1');
nuSetProperty('cloner_objects', "0");
nuSetProperty('cloner_tabs','');
nuSetProperty('cloner_source','');
nuSetProperty('cloner_dest','');
nuRunPHP('cloner', '',1);
```

### 8: Do not generate new primary keys.

```php
nuSetProperty('cloner_dump','1');
nuSetProperty('cloner_new_pks', "0");
nuSetProperty('cloner_source','');
nuSetProperty('cloner_dest','');
nuRunPHP('cloner', '',1);
```

### 9: Include (all) subforms

```php

nuSetProperty('cloner_subforms','1');
nuRunPHPHidden('cloner', 0);
```

### 10: Include (all) embedded iframe forms

```php

nuSetProperty('cloner_iframe_forms','1');
nuRunPHPHidden('cloner', 0);
```
