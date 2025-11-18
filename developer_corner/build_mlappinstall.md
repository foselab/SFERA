# Building the `.mlappinstall` Package

This document explains how to regenerate the `.mlappinstall` file after modifying the MATLAB code or App Designer components. The resulting package can be installed directly through MATLAB's App tool.

---

## 1. Open the App in App Designer
1. Launch MATLAB.
2. Open the main `.mlapp` file of the project.
3. Ensure the app runs without errors using the **Run** button.

---

## 2. Verify Included Files
Make sure all required `.m`, `.mlapp`, class files, and auxiliary functions are:
- in the same folder as the app, or
- included in the MATLAB path, or
- part of the MATLAB Project (`.prj`) if the repository uses one.

If using a Project file:
- Open the `.prj` project
- Check that all necessary files appear in the project tree

---

## 3. Package the App (`.mlappinstall`)
MATLAB provides a built-in utility to package apps.

1. In App Designer, open the **Designer** tab.
2. Select **Share → Package App**.
3. In the packaging interface:
   - Review the app information (name, description, version)
   - Confirm all required files are included in the *Files* list
   - Choose the output folder for the final package
4. Click **Package** to generate the `.mlappinstall` file.

---

## 4. Test the Installation Package
1. Double-click the newly generated `.mlappinstall` file.
2. MATLAB should open the installation dialog.
3. Install the app.
4. Validate that the installed app behaves as expected.

---

By following these steps, developers can reliably regenerate an installation-ready `.mlappinstall` file after modifying the app's code or structure.

