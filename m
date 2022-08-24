Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F395459F9E4
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbiHXMXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233796AbiHXMXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:23:14 -0400
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E807962C;
        Wed, 24 Aug 2022 05:23:11 -0700 (PDT)
Received: from [2a02:8108:963f:de38:eca4:7d19:f9a2:22c5]; authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1oQpPa-0002yI-0X; Wed, 24 Aug 2022 14:23:10 +0200
Message-ID: <02d7e4ac-f7f0-0597-7ab0-4f916194f7b9@leemhuis.info>
Date:   Wed, 24 Aug 2022 14:23:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Content-Language: en-US
From:   Thorsten Leemhuis <regressions@leemhuis.info>
To:     Oliver Neukum <oliver@neukum.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: [Regression] Bug 216336 - 3G USB Modem Huawei k4203 stop working on
 kernel > 4.X
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1661343792;c4cf87e8;
X-HE-SMSGID: 1oQpPa-0002yI-0X
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, this is your Linux kernel regression tracker.

I noticed a regression report in bugzilla.kernel.org that afaics nobody
acted upon since it was reported. That's why I decided to forward it by
mail to those that afaics should handle this.

To quote from https://bugzilla.kernel.org/show_bug.cgi?id=216336 :

>  S.Bonomar 2022-08-08 05:28:54 UTC
> 
> i am new on kernel development,
> i can successfully use my Huawei vodafone k4203 usb modem with kernel version 4.15(I test it on ubuntu-18.04.1 LTS with kernel 4.15 (i donwlaod this iso on 2018)) but when i try to use it with the newer 5.x.x kernel i get the error "kernel: cdc_mbim 2-1.5:2.0: SET_NTB_FORMAT failed
> kernel: cdc_mbim 2-1.5:2.0: bind() failure"
> 
> when I want to use I enter on ubuntu-18.04.1LTS, insert the device and reboot and enter on fedora-36
> but when I enter the fedora-36 and insert the device,  reboot and enter the ubuntu-18.04.1 LTS, the device fails on ubuntu-18.04.1 LTS, just remove and insert again and it works
> 
> Now i'm use (Fedora_36 kernel 5.18.13-200.x86_64)
> I compiled the kernel-{5.4,4.19} longterm and the problem persist
> But when I access the 4.x.x kernel then reboot the PC and access the 5.x.x kernel it works, do you have any idea how I can solve this problem ? :)
> 
> Note: the modem has a dhcp server and web server.
> 
> My log on fedora-36:
> [  115.571291] usb 2-1.4: new high-speed USB device number 7 using ehci-pci
> [  115.652037] usb 2-1.4: New USB device found, idVendor=12d1, idProduct=1f1c, bcdDevice= 1.02
> [  115.652045] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [  115.652049] usb 2-1.4: Product: HUAWEI Mobile
> [  115.652052] usb 2-1.4: Manufacturer: Vodafone(Huawei)
> [  115.652054] usb 2-1.4: SerialNumber: FFFFFFFFFFFFFFFF
> [  115.779381] usb-storage 2-1.4:1.0: USB Mass Storage device detected
> [  115.779821] scsi host4: usb-storage 2-1.4:1.0
> [  115.779917] usbcore: registered new interface driver usb-storage
> [  115.787770] usbcore: registered new interface driver uas
> [  116.646327] usbcore: registered new interface driver cdc_ether
> [  116.655897] usbcore: registered new interface driver cdc_ncm
> [  116.665733] usbcore: registered new interface driver cdc_wdm
> [  116.706710] cdc_mbim 2-1.4:2.0: SET_NTB_FORMAT failed
> [  116.730917] cdc_mbim 2-1.4:2.0: bind() failure
> [  116.730987] usbcore: registered new interface driver cdc_mbim
> [  116.935660] usb 2-1.4: USB disconnect, device number 7
> [  121.459317] usb 2-1.4: new high-speed USB device number 8 using ehci-pci
> [  121.539511] usb 2-1.4: New USB device found, idVendor=12d1, idProduct=1f1c, bcdDevice= 1.02
> [  121.539520] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [  121.539525] usb 2-1.4: Product: HUAWEI Mobile
> [  121.539528] usb 2-1.4: Manufacturer: Vodafone(Huawei)
> [  121.539531] usb 2-1.4: SerialNumber: FFFFFFFFFFFFFFFF
> [  121.594546] usb-storage 2-1.4:1.0: USB Mass Storage device detected
> [  121.594911] scsi host4: usb-storage 2-1.4:1.0
> [  122.466808] cdc_mbim 2-1.4:2.0: SET_NTB_FORMAT failed
> [  122.490514] cdc_mbim 2-1.4:2.0: bind() failure
> [  122.567541] usb 2-1.4: USB disconnect, device number 8
> [  127.091345] usb 2-1.4: new high-speed USB device number 9 using ehci-pci
> [  127.172930] usb 2-1.4: New USB device found, idVendor=12d1, idProduct=1f1c, bcdDevice= 1.02
> [  127.172939] usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [  127.172943] usb 2-1.4: Product: HUAWEI Mobile
> [  127.172947] usb 2-1.4: Manufacturer: Vodafone(Huawei)
> [  127.172949] usb 2-1.4: SerialNumber: FFFFFFFFFFFFFFFF
> [  127.226234] usb-storage 2-1.4:1.0: USB Mass Storage device detected
> [  127.226706] scsi host4: usb-storage 2-1.4:1.0
> [  128.090497] cdc_mbim 2-1.4:2.0: SET_NTB_FORMAT failed
> [  128.114422] cdc_mbim 2-1.4:2.0: bind() failure
> [  128.199565] usb 2-1.4: USB disconnect, device number 9
> 
> /var/lib/messages:
> Aug  7 17:59:49 localhost kernel: usb 2-1.4: Product: HUAWEI Mobile
> Aug  7 17:59:49 localhost kernel: usb 2-1.4: Manufacturer: Vodafone(Huawei)
> Aug  7 17:59:49 localhost kernel: usb 2-1.4: SerialNumber: FFFFFFFFFFFFFFFF
> Aug  7 17:59:49 localhost mtp-probe[1531]: checking bus 2, device 7: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
> Aug  7 17:59:49 localhost mtp-probe[1531]: bus: 2, device: 7 was not an MTP device
> Aug  7 17:59:49 localhost systemd[1]: Created slice system-usb_modeswitch.slice - Slice /system/usb_modeswitch.
> Aug  7 17:59:49 localhost systemd[1]: Starting usb_modeswitch@2-1.4:1.0.service - USB_ModeSwitch_2-1.4:1.0...
> Aug  7 17:59:49 localhost kernel: usb-storage 2-1.4:1.0: USB Mass Storage device detected
> Aug  7 17:59:49 localhost kernel: scsi host4: usb-storage 2-1.4:1.0
> Aug  7 17:59:49 localhost kernel: usbcore: registered new interface driver usb-storage
> Aug  7 17:59:49 localhost kernel: usbcore: registered new interface driver uas
> Aug  7 17:59:49 localhost mtp-probe[1546]: checking bus 2, device 7: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
> Aug  7 17:59:49 localhost mtp-probe[1546]: bus: 2, device: 7 was not an MTP device
> Aug  7 17:59:50 localhost usb_modeswitch[1551]: switch device 12d1:1f1c on 002/007
> Aug  7 17:59:50 localhost kernel: usbcore: registered new interface driver cdc_ether
> Aug  7 17:59:50 localhost kernel: usbcore: registered new interface driver cdc_ncm
> Aug  7 17:59:50 localhost kernel: usbcore: registered new interface driver cdc_wdm
> Aug  7 17:59:50 localhost kernel: cdc_mbim 2-1.4:2.0: SET_NTB_FORMAT failed
> Aug  7 17:59:50 localhost kernel: cdc_mbim 2-1.4:2.0: bind() failure
> Aug  7 17:59:50 localhost kernel: usbcore: registered new interface driver cdc_mbim
> Aug  7 17:59:50 localhost kernel: usb 2-1.4: USB disconnect, device number 7
> Aug  7 17:59:55 localhost kernel: usb 2-1.4: new high-speed USB device number 8 using ehci-pci
> Aug  7 17:59:55 localhost kernel: usb 2-1.4: New USB device found, idVendor=12d1, idProduct=1f1c, bcdDevice= 1.02
> Aug  7 17:59:55 localhost kernel: usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> Aug  7 17:59:55 localhost kernel: usb 2-1.4: Product: HUAWEI Mobile
> Aug  7 17:59:55 localhost kernel: usb 2-1.4: Manufacturer: Vodafone(Huawei)
> Aug  7 17:59:55 localhost kernel: usb 2-1.4: SerialNumber: FFFFFFFFFFFFFFFF
> Aug  7 17:59:55 localhost kernel: usb-storage 2-1.4:1.0: USB Mass Storage device detected
> Aug  7 17:59:55 localhost kernel: scsi host4: usb-storage 2-1.4:1.0
> Aug  7 17:59:55 localhost mtp-probe[1565]: checking bus 2, device 8: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
> Aug  7 17:59:55 localhost mtp-probe[1565]: bus: 2, device: 8 was not an MTP device
> Aug  7 17:59:55 localhost systemd[1]: usb_modeswitch@2-1.4:1.0.service: Main process exited, code=killed, status=15/TERM
> Aug  7 17:59:55 localhost systemd[1]: usb_modeswitch@2-1.4:1.0.service: Failed with result 'signal'.
> Aug  7 17:59:55 localhost systemd[1]: Stopped usb_modeswitch@2-1.4:1.0.service - USB_ModeSwitch_2-1.4:1.0.
> Aug  7 17:59:55 localhost audit[1]: SERVICE_START pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=usb_modeswitch@2-1.4:1.0 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=failed'
> Aug  7 17:59:55 localhost systemd[1]: Starting usb_modeswitch@2-1.4:1.0.service - USB_ModeSwitch_2-1.4:1.0...
> Aug  7 17:59:55 localhost mtp-probe[1575]: checking bus 2, device 8: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
> Aug  7 17:59:55 localhost mtp-probe[1575]: bus: 2, device: 8 was not an MTP device
> Aug  7 17:59:55 localhost usb_modeswitch[1579]: switch device 12d1:1f1c on 002/008
> Aug  7 17:59:56 localhost kernel: cdc_mbim 2-1.4:2.0: SET_NTB_FORMAT failed
> Aug  7 17:59:56 localhost kernel: cdc_mbim 2-1.4:2.0: bind() failure
> Aug  7 17:59:56 localhost kernel: usb 2-1.4: USB disconnect, device number 8
> Aug  7 18:00:00 localhost kernel: usb 2-1.4: new high-speed USB device number 9 using ehci-pci
> Aug  7 18:00:00 localhost kernel: usb 2-1.4: New USB device found, idVendor=12d1, idProduct=1f1c, bcdDevice= 1.02
> Aug  7 18:00:00 localhost kernel: usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> Aug  7 18:00:00 localhost kernel: usb 2-1.4: Product: HUAWEI Mobile
> Aug  7 18:00:00 localhost kernel: usb 2-1.4: Manufacturer: Vodafone(Huawei)
> Aug  7 18:00:00 localhost kernel: usb 2-1.4: SerialNumber: FFFFFFFFFFFFFFFF
> Aug  7 18:00:01 localhost kernel: usb-storage 2-1.4:1.0: USB Mass Storage device detected
> Aug  7 18:00:01 localhost kernel: scsi host4: usb-storage 2-1.4:1.0
> Aug  7 18:00:01 localhost mtp-probe[1586]: checking bus 2, device 9: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
> Aug  7 18:00:01 localhost mtp-probe[1586]: bus: 2, device: 9 was not an MTP device
> Aug  7 18:00:01 localhost systemd[1]: usb_modeswitch@2-1.4:1.0.service: Main process exited, code=killed, status=15/TERM
> Aug  7 18:00:01 localhost systemd[1]: usb_modeswitch@2-1.4:1.0.service: Failed with result 'signal'.
> Aug  7 18:00:01 localhost systemd[1]: Stopped usb_modeswitch@2-1.4:1.0.service - USB_ModeSwitch_2-1.4:1.0.
> Aug  7 18:00:01 localhost audit[1]: SERVICE_START pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=usb_modeswitch@2-1.4:1.0 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=failed'
> Aug  7 18:00:01 localhost mtp-probe[1594]: checking bus 2, device 9: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
> Aug  7 18:00:01 localhost systemd[1]: Starting usb_modeswitch@2-1.4:1.0.service - USB_ModeSwitch_2-1.4:1.0...
> Aug  7 18:00:01 localhost mtp-probe[1594]: bus: 2, device: 9 was not an MTP device
> Aug  7 18:00:01 localhost usb_modeswitch[1601]: switch device 12d1:1f1c on 002/009
> Aug  7 18:00:01 localhost kernel: cdc_mbim 2-1.4:2.0: SET_NTB_FORMAT failed
> Aug  7 18:00:01 localhost kernel: cdc_mbim 2-1.4:2.0: bind() failure
> Aug  7 18:00:01 localhost kernel: usb 2-1.4: USB disconnect, device number 9
> Aug  7 18:00:06 localhost kernel: usb 2-1.4: new high-speed USB device number 10 using ehci-pci
> Aug  7 18:00:06 localhost kernel: usb 2-1.4: New USB device found, idVendor=12d1, idProduct=1f1c, bcdDevice= 1.02
> Aug  7 18:00:06 localhost kernel: usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> Aug  7 18:00:06 localhost kernel: usb 2-1.4: Product: HUAWEI Mobile
> Aug  7 18:00:06 localhost kernel: usb 2-1.4: Manufacturer: Vodafone(Huawei)
> Aug  7 18:00:06 localhost kernel: usb 2-1.4: SerialNumber: FFFFFFFFFFFFFFFF
> Aug  7 18:00:06 localhost kernel: usb-storage 2-1.4:1.0: USB Mass Storage device detected
> Aug  7 18:00:06 localhost kernel: scsi host4: usb-storage 2-1.4:1.0
> Aug  7 18:00:06 localhost mtp-probe[1611]: checking bus 2, device 10: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
> Aug  7 18:00:06 localhost mtp-probe[1611]: bus: 2, device: 10 was not an MTP device
> Aug  7 18:00:06 localhost systemd[1]: usb_modeswitch@2-1.4:1.0.service: Main process exited, code=killed, status=15/TERM
> Aug  7 18:00:06 localhost systemd[1]: usb_modeswitch@2-1.4:1.0.service: Failed with result 'signal'.
> Aug  7 18:00:06 localhost systemd[1]: Stopped usb_modeswitch@2-1.4:1.0.service - USB_ModeSwitch_2-1.4:1.0.
> Aug  7 18:00:06 localhost audit[1]: SERVICE_START pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=usb_modeswitch@2-1.4:1.0 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=failed'
> Aug  7 18:00:06 localhost systemd[1]: Starting usb_modeswitch@2-1.4:1.0.service - USB_ModeSwitch_2-1.4:1.0...
> Aug  7 18:00:06 localhost mtp-probe[1620]: checking bus 2, device 10: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
> Aug  7 18:00:06 localhost mtp-probe[1620]: bus: 2, device: 10 was not an MTP device
> Aug  7 18:00:07 localhost usb_modeswitch[1625]: switch device 12d1:1f1c on 002/010
> Aug  7 18:00:07 localhost kernel: cdc_mbim 2-1.4:2.0: SET_NTB_FORMAT failed
> Aug  7 18:00:07 localhost kernel: cdc_mbim 2-1.4:2.0: bind() failure
> Aug  7 18:00:07 localhost kernel: usb 2-1.4: USB disconnect, device number 10
> Aug  7 18:00:12 localhost kernel: usb 2-1.4: new high-speed USB device number 11 using ehci-pci
> Aug  7 18:00:12 localhost kernel: usb 2-1.4: New USB device found, idVendor=12d1, idProduct=1f1c, bcdDevice= 1.02
> Aug  7 18:00:12 localhost kernel: usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> Aug  7 18:00:12 localhost kernel: usb 2-1.4: Product: HUAWEI Mobile
> Aug  7 18:00:12 localhost kernel: usb 2-1.4: Manufacturer: Vodafone(Huawei)
> Aug  7 18:00:12 localhost kernel: usb 2-1.4: SerialNumber: FFFFFFFFFFFFFFFF
> Aug  7 18:00:12 localhost kernel: usb-storage 2-1.4:1.0: USB Mass Storage device detected
> Aug  7 18:00:12 localhost kernel: scsi host4: usb-storage 2-1.4:1.0
> Aug  7 18:00:12 localhost mtp-probe[1633]: checking bus 2, device 11: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
> Aug  7 18:00:12 localhost mtp-probe[1633]: bus: 2, device: 11 was not an MTP device
> Aug  7 18:00:12 localhost systemd[1]: usb_modeswitch@2-1.4:1.0.service: Main process exited, code=killed, status=15/TERM
> Aug  7 18:00:12 localhost systemd[1]: usb_modeswitch@2-1.4:1.0.service: Failed with result 'signal'.
> Aug  7 18:00:12 localhost systemd[1]: Stopped usb_modeswitch@2-1.4:1.0.service - USB_ModeSwitch_2-1.4:1.0.
> Aug  7 18:00:12 localhost audit[1]: SERVICE_START pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=usb_modeswitch@2-1.4:1.0 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=failed'
> Aug  7 18:00:12 localhost systemd[1]: Starting usb_modeswitch@2-1.4:1.0.service - USB_ModeSwitch_2-1.4:1.0...
> Aug  7 18:00:12 localhost mtp-probe[1643]: checking bus 2, device 11: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
> Aug  7 18:00:12 localhost mtp-probe[1643]: bus: 2, device: 11 was not an MTP device
> Aug  7 18:00:12 localhost usb_modeswitch[1647]: switch device 12d1:1f1c on 002/011
> Aug  7 18:00:13 localhost kernel: cdc_mbim 2-1.4:2.0: SET_NTB_FORMAT failed
> Aug  7 18:00:13 localhost kernel: cdc_mbim 2-1.4:2.0: bind() failure
> Aug  7 18:00:13 localhost kernel: usb 2-1.4: USB disconnect, device number 11
> Aug  7 18:00:17 localhost kernel: usb 2-1.4: new high-speed USB device number 12 using ehci-pci
> Aug  7 18:00:17 localhost kernel: usb 2-1.4: New USB device found, idVendor=12d1, idProduct=1f1c, bcdDevice= 1.02
> Aug  7 18:00:17 localhost kernel: usb 2-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> Aug  7 18:00:17 localhost kernel: usb 2-1.4: Product: HUAWEI Mobile
> Aug  7 18:00:17 localhost kernel: usb 2-1.4: Manufacturer: Vodafone(Huawei)
> Aug  7 18:00:17 localhost kernel: usb 2-1.4: SerialNumber: FFFFFFFFFFFFFFFF
> Aug  7 18:00:17 localhost kernel: usb-storage 2-1.4:1.0: USB Mass Storage device detected
> Aug  7 18:00:17 localhost kernel: scsi host4: usb-storage 2-1.4:1.0
> Aug  7 18:00:17 localhost mtp-probe[1654]: checking bus 2, device 12: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
> Aug  7 18:00:17 localhost mtp-probe[1654]: bus: 2, device: 12 was not an MTP device
> Aug  7 18:00:17 localhost systemd[1]: usb_modeswitch@2-1.4:1.0.service: Main process exited, code=killed, status=15/TERM
> Aug  7 18:00:17 localhost systemd[1]: usb_modeswitch@2-1.4:1.0.service: Failed with result 'signal'.
> Aug  7 18:00:17 localhost systemd[1]: Stopped usb_modeswitch@2-1.4:1.0.service - USB_ModeSwitch_2-1.4:1.0.
> Aug  7 18:00:17 localhost audit[1]: SERVICE_START pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=usb_modeswitch@2-1.4:1.0 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=failed'
> Aug  7 18:00:17 localhost systemd[1]: Starting usb_modeswitch@2-1.4:1.0.service - USB_ModeSwitch_2-1.4:1.0...
> Aug  7 18:00:17 localhost mtp-probe[1663]: checking bus 2, device 12: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
> Aug  7 18:00:17 localhost mtp-probe[1663]: bus: 2, device: 12 was not an MTP device
> Aug  7 18:00:18 localhost usb_modeswitch[1668]: switch device 12d1:1f1c on 002/012
> Aug  7 18:00:18 localhost kernel: cdc_mbim 2-1.4:2.0: SET_NTB_FORMAT failed
> Aug  7 18:00:18 localhost kernel: cdc_mbim 2-1.4:2.0: bind() failure
> Aug  7 18:00:18 localhost kernel: usb 2-1.4: USB disconnect, device number 12
> Aug  7 18:00:25 localhost kernel: usb 2-1.4: new high-speed USB device number 13 using ehci-pci
> Aug  7 18:00:25 localhost kernel: usb 2-1.4: New USB device found, idVendor=12d1, idProduct=14fb, bcdDevice= 1.02
> Aug  7 18:00:25 localhost kernel: usb 2-1.4: New USB device strings: Mfr=2, Product=1, SerialNumber=0
> Aug  7 18:00:25 localhost kernel: usb 2-1.4: Product: HUAWEI Mobile
> Aug  7 18:00:25 localhost kernel: usb 2-1.4: Manufacturer: HUAWEI Technology
> Aug  7 18:00:25 localhost mtp-probe[1672]: checking bus 2, device 13: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
> Aug  7 18:00:25 localhost mtp-probe[1672]: bus: 2, device: 13 was not an MTP device
> Aug  7 18:00:25 localhost kernel: usbcore: registered new interface driver option
> Aug  7 18:00:25 localhost kernel: usbserial: USB Serial support registered for GSM modem (1-port)
> Aug  7 18:00:25 localhost kernel: option 2-1.4:1.0: GSM modem (1-port) converter detected
> Aug  7 18:00:25 localhost kernel: usb 2-1.4: GSM modem (1-port) converter now attached to ttyUSB0
> Aug  7 18:00:25 localhost kernel: option 2-1.4:1.1: GSM modem (1-port) converter detected
> Aug  7 18:00:25 localhost kernel: usb 2-1.4: GSM modem (1-port) converter now attached to ttyUSB1
> Aug  7 18:00:25 localhost mtp-probe[1679]: checking bus 2, device 13: "/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4"
> Aug  7 18:00:25 localhost mtp-probe[1679]: bus: 2, device: 13 was not an MTP device
> Aug  7 18:00:38 localhost systemd[1]: usb_modeswitch@2-1.4:1.0.service: Deactivated successfully.
> Aug  7 18:00:38 localhost systemd[1]: Finished usb_modeswitch@2-1.4:1.0.service - USB_ModeSwitch_2-1.4:1.0.
> Aug  7 18:00:38 localhost audit[1]: SERVICE_START pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=usb_modeswitch@2-1.4:1.0 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> Aug  7 18:00:38 localhost audit[1]: SERVICE_STOP pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=usb_modeswitch@2-1.4:1.0 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
> Aug  7 18:00:48 localhost systemd[1149]: Starting grub-boot-success.service - Mark boot as successful...
> Aug  7 18:00:48 localhost systemd[1149]: Finished grub-boot-success.service - Mark boot as successful.
> Aug  7 18:00:57 localhost ModemManager[936]: <info>  [device /sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4] creating modem with plugin 'huawei' and '2' ports
> Aug  7 18:00:57 localhost ModemManager[936]: <warn>  [plugin/huawei] could not grab port ttyUSB0: Cannot add port 'tty/ttyUSB0', unhandled port type
> Aug  7 18:00:57 localhost ModemManager[936]: <warn>  [plugin/huawei] could not grab port ttyUSB1: Cannot add port 'tty/ttyUSB1', unhandled port type
> Aug  7 18:00:57 localhost ModemManager[936]: <warn>  [base-manager] couldn't create modem for device '/sys/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.4': Failed to find primary AT port

See the ticket for details and further comments.

@S.Bonomar FYI: you might need to bisect this issue to get us to the
root of the problem. I also wonder if you used a vanilla 4.15 version or
Ubuntu's kernel (which might include a patch to make your device work).
But well, maybe the developers have a idea what's wrong here without
further debugging. They will know, I have no idea about this driver or
how it works.

Moving on:

If you're among the main recipients of this mail and not just CCed,
could you please look into the issue to get it fixed as per
https://docs.kernel.org/process/handling-regressions.html ? tia!

Anyway, to ensure this is not forgotten lets get this tracked by the the
Linux kernel regression tracking bot:

#regzbot introduced: v4.15..v4.19
https://bugzilla.kernel.org/show_bug.cgi?id=216336
#regzbot ignore-activity

This isn't a regression? This issue or a fix for it are already
discussed somewhere else? It was fixed already? You want to clarify when
the regression started to happen? Or point out I got the title or
something else totally wrong? Then just reply -- ideally with also
telling regzbot about it, as explained here:
https://linux-regtracking.leemhuis.info/tracked-regression/

Reminder for developers: When fixing the issue, add 'Link:' tags
pointing to the report in bugzilla, as the kernel's documentation calls
for; above page explains why this is important for tracked regressions.

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

P.S.: As the Linux kernel's regression tracker I deal with a lot of
reports and sometimes miss something important when writing mails like
this. If that's the case here, don't hesitate to tell me in a public
reply, it's in everyone's interest to set the public record straight.
