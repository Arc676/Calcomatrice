# Calcomatrice

A simple matrix calculator for Ubuntu Touch using the [Matrix Library](https://github.com/Arc676/Matrix-Library) as a backend.

# Compilation/Dependencies

Calcomatrice is built using `clickable`. Header and library files for the dependencies are located in `plugins/MatrixBackend/lib`.

Aside from the Matrix Library, Calcomatrice also uses [ExprFix](https://github.com/arc676/exprfix); matrix calculations are represented and evaluated internally using prefix notation; only user input uses infix notation.

Both dependencies are included as submodules in this repository. Note that the submodules must also be cloned to compile Calcomatrice, as the header files and compiled libraries are symbolic links into the submodules and not actual copies of those files. The exceptions are the `armhf` builds, which *are* included as real files in this repository. The `amd64` builds are not provided. In order to compile Calcomatrice, the libraries `libexprfix.a` and `libmatrix.a` must be present in `lib/`. This can be done by renaming the library matching the desired architecture or by creating a symbolic link `ln -s libmatrix.a libmatrix_amd64.a`.

# Licensing

Project and backend library available under GPLv3. See `LICENSE` for full license text. Application design and components inspired by the Ubuntu Touch [Calculator app](https://gitlab.com/ubports/apps/calculator-app/), also available under GPLv3. The virtual keyboard in Calcomatrice and some of the text processing for formula building reuse code from UBports' app.

Thanks to [@theberzi](https://twitter.com/theberzi) for the app icon (released into the public domain) and the app name.
