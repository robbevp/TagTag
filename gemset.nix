{
  cli-kit = {
    dependencies = ["cli-ui"];
    groups = ["default"];
    platforms = [];
    source = {
      fetchSubmodules = false;
      rev = "aeeb58b05ee920f324106fc7ebfce7949dfb6f02";
      sha256 = "1s6yhh6nm1jpfji8802k143awpd89ncbr67b7xmj0pdnp4kmr806";
      type = "git";
      url = "https://github.com/Shopify/cli-kit.git";
    };
    version = "4.0.0";
  };
  cli-ui = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1aghiy4qrh6y6q421lcpal81c98zypj8jki4wymqnc8vjvqsyiv4";
      type = "gem";
    };
    version = "1.5.1";
  };
  wahwah = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1kg7jfhr1qphpzxf5dk4ll5gm2h789xkir59zlkwz2pvwfzin02b";
      type = "gem";
    };
    version = "1.3.0";
  };
}
