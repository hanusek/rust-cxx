fn main() {
    let _build = cxx_build::bridge("src/bindings.rs");
    println!("cargo:rerun-if-changed=src/bindings.rs");
}
