# -*- coding: utf-8 -*-
Veewee::Session.declare({
    # one of `vagrant basebox ostypes`
    # what it should be... :os_type_id => 'Windows2012_64',
    # what it might be... :os_type_id => 'Windows8_64',
    # what it was in 2008... :os_type_id => 'Windows2008_64',
    :os_type_id => 'Windows8_64',
    # Download and install full featured software for 180-day trial
    :iso_file => "en_windows_server_2012_x64_dvd_915478.iso",
    :iso_md5 => "da91135483e24689bfdaf05d40301506",

    # :iso_file => "9200.16384.WIN8_RTM.120725-1247_X64FRE_SERVER_EVAL_EN-US-HRM_SSS_X64FREE_EN-US_DV5.ISO",
    # :iso_md5 => "8503997171f731d9bd1cb0b0edc31f3d",
    # :iso_src => "http://care.dlservice.microsoft.com//dl/download/6/D/A/6DAB58BA-F939-451D-9101-7DE07DC09C03/9200.16384.WIN8_RTM.120725-1247_X64FRE_SERVER_EVAL_EN-US-HRM_SSS_X64FREE_EN-US_DV5.ISO?lcid=1033&cprod=winsvr2012rtmisotn",
    :iso_download_timeout => "1000",

    :cpu_count => '1',
    :memory_size=> '1024', 
    :disk_size => '20280', :disk_format => 'VDI', :hostiocache => 'off',

    :floppy_files => [
      "Autounattend.xml",
      "oracle-cert.cer"
    ],

    :boot_wait => "1",
    :boot_cmd_sequence => [''],
    :winrm_user => "vagrant", :winrm_password => "vagrant",
    :kickstart_port => "7100",
    :postinstall_timeout => "10000",
    :postinstall_files => [
      "install-chef.bat",
      "install-vbox.bat"
    ],
    :sudo_cmd => "%f",
    :shutdown_cmd => "shutdown /s /t 10  /f /d p:4:1 /c \"Vagrant Shutdown\"" ,
    # :shutdown_cmd => "shutdown /s /t 60 /d p:4:1 /c \"Vagrant Shutdown\"",
})


