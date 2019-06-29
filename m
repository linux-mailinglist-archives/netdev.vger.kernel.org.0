Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C6DF5AD5C
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 22:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfF2Uet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 16:34:49 -0400
Received: from mout.web.de ([217.72.192.78]:34885 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbfF2Uet (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 16:34:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561840480;
        bh=b+WpiWxr3gMlpNwr2fvkqizuYkSPHk32c4aPLIck5oU=;
        h=X-UI-Sender-Class:To:Cc:From:Subject:Date;
        b=U2gMCezQDorlGVbnA7xkJaTyWUPtRfWQwtEQF7mAZ41CF9f8pKpTooztA0RwcsuZ9
         gMrDEzOwRFgnj2US6cw0jC7cJk3b3EIz8+q91Sal+kbJA25XMd5XtwxxAn0+NGljJb
         lZQQs3Z7DPFH0RcmPJjvvf9dJIe2YhycSktgeOUw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.3.100] ([134.101.168.76]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0Lo0ZA-1iEByK1teK-00fxlW; Sat, 29
 Jun 2019 22:34:40 +0200
To:     nic_swsd@realtek.com, romieu@fr.zoreil.com
Cc:     netdev@vger.kernel.org
From:   Karsten Wiborg <karsten.wiborg@web.de>
Subject: r8169 not working on 5.2.0rc6 with GPD MicroPC
Openpgp: preference=signencrypt
Message-ID: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
Date:   Sat, 29 Jun 2019 22:34:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
X-Provags-ID: V03:K1:amBdsH7LvMqsflbL1s8NQ5gv5OfAcwmzFvZ2YOUBQUdFx3qIf63
 w61uubdFtrbRNq7yhvlQd9hjwwKQ59BVGXBco8M6SUHgaiWlZBNKa2njezlg7v47KjayQWx
 fQeddZbusA0U+ABG7MjSMvxGVJnJN5Ir9ZyYSlVTMkt0C0rWOmabcVO08ga7DFTmeXW9ut0
 TQvF/p7LBS9bya/DVAVrQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:fh5OExd32Fg=:wUyz+aqJz4lUyoypt7Mv/z
 0xL5f7CNFsxU58FgbjI/sGIxP+OHWnDmEWi8d4Aes7TaS89s8aCf+4XfRjXlmjGjcyllU5hcL
 RSKQil1vEije/WojsKGxArRR7N4STFaYg2OzxtOeiaQZgDCuFTuvgal6Op/kP+4ISa16OVoTx
 X2klzuA0rGgrzf6fNCirA5v8f6zckWdeFic2mqhtS98Lmo61jqoronGVckAcW/toe4P4DwKDc
 gwemyPdnvVPvfU/b3b6BYKWN9vRbQDa4dI/Jvm297VtPMTovykqZ5aNZ9OrGk+I2Amx3R7tUi
 Sbr/cJW3h60FzPlVcC0CBcuE+uVyj8Vl6FIIyy+CUE8nkSSmmHG62P+zk2OF3TZKqJAG4L1Md
 epaXA8oH0/bhqfeJRliCB0aEsHSeuXWhlWA7KxPzlg4rj6qoO3dEBpZzReNH77Gf8al7lWog8
 C+cY4ennFMJxmTN1X2R40zPI0C0v/kP0riuaeZ1z6gwa11mYtIIgJfy1X3U1PwnoaYd7H4vTd
 DroriFEPIpLaR3l4dZhRLLSeiKnZwuH4NTt4f9DtU1plolZuXqzeuluQ/zgKuVE+/ZitxlKze
 I1SahZdWiMwVutC75a/cfXO4lz5yZSGTHJVgr+NUL4Dyx4/o040UXM8F9NESg8WUW67e5gAVd
 kZwgeAYBbQOYuuS8e19MaVgVvJvzdpM5PrZZuzb4ODVUlvvWo7RDlpKmr32ktQ46LmQBDRqh6
 eSBn0kR4ovtTuQJ8Ip7zeIUu99gMOHKkNMDTw5pwn6y+96PD2eJILtTBXXV6pNgDadd6zoK8K
 rf0KJfklYlaq76dBcvZHF1uIIDuo3qlel0H6mA5gBlahdRB0IiJ2aKiqMBJDjPF0Sb3/XkFd6
 O5lNmwTnwQB/vq4cKnQN+JVcvp8USapimsAhJmRjCoXTAcAtf8KMfbTeI7t5BI9V9pYf6bF3T
 OPzhEPqyi8xceimSwV1PIHSvDH+PsuRU28H+Tt2DD4jepZcdU1q8YqqzoSygN3To0fCsF9TgO
 Rn9wndfUS8paWsiY8xRBeZSw/LCE8UWFF+NZXHplDWpu1R9LkgYZ1GiFTDcrwf63tX4CKAE58
 JSkK9BJ36FiPPp4VW8V30GCdZJ5gY293JuU
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

writing to you because of the r8168-dkms-README.Debian.

I am using a GPD MicroPC running Debian Buster with Kernel:
Linux praktifix 5.2.0-050200rc6-generic #201906222033 SMP Sun Jun 23
00:36:46 UTC 2019 x86_64 GNU/Linux


Got the Kernel from:
https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.2-rc6/
Reason for the Kernel: it includes Hans DeGoedes necessary fixes for the
GPD MicroPC, see:
https://github.com/jwrdegoede/linux-sunxi
(btw. I also tried Hans' 5.2.0rc5-kernel which also did not work with
respect to Ethernet). Googling of course didn't help out either.


My GPD MicroPC with running r8169 gives the following lines in dmesg:
...
[    2.839485] libphy: r8169: probed
[    2.839776] r8169 0000:02:00.0 eth0: RTL8168h/8111h,
00:00:00:00:00:00, XID 541, IRQ 126
[    2.839779] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200
bytes, tx checksumming: ko]
...
[    2.897924] r8169 0000:02:00.0 eno1: renamed from eth0


ip addr show gives me:
# ip addr show
...
2: eno1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group
default qlen 1000
    link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
...


ethtool gives me:
# ethtool -i eno1
driver: r8169
version:
firmware-version:
expansion-rom-version:
bus-info: 0000:02:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: yes
supports-priv-flags: no


lspci shows me:
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 15)


Installing r8168-dkms fails with the following errors:
Setting up r8168-dkms (8.046.00-1) ...
Removing old r8168-8.046.00 DKMS files...

------------------------------
Deleting module version: 8.046.00
completely from the DKMS tree.
------------------------------
Done.
Loading new r8168-8.046.00 DKMS files...
Building for 5.2.0-050200rc6-generic 5.2.0-rc5-gpd-custom
Building initial module for 5.2.0-050200rc6-generic
Error! Bad return status for module build on kernel:
5.2.0-050200rc6-generic (x86_64)
Consult /var/lib/dkms/r8168/8.046.00/build/make.log for more information.
dpkg: error processing package r8168-dkms (--configure):
 installed r8168-dkms package post-installation script subprocess
returned error exit status 10
Errors were encountered while processing:
 r8168-dkms
E: Sub-process /usr/bin/dpkg returned an error code (1)


Does that help you?
Do you need more data?
Thank you very much in advance for hopefully looking into this matter.

Regards,
Karsten Wiborg
