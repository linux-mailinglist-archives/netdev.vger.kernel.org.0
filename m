Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7815AD7A
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 23:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfF2VTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 17:19:16 -0400
Received: from mout.web.de ([212.227.17.12]:57761 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbfF2VTQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 17:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1561843146;
        bh=xaggUqCsDJd30q9shhyOFMb4p8ptUSBp2j5ld5uzmoo=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:References:Date:In-Reply-To;
        b=cVxj0RkcTUDC7fzr51OK5O3FBqzIuHx74smw4MZUWlTTsns3pCziQxl7zHe5s3G5m
         BXwC/DAsU2juH4JrjE+j2mkDNUCWuwysmrvPVi0SBBc6Z8rYETpXGWeMuWvRgxGhDI
         gjKGRSElVncZohdf51WkQbhY89LZSmv48obKeZGo=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.3.100] ([134.101.168.76]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LkPnr-1iHmID09cp-00cU49; Sat, 29
 Jun 2019 23:19:06 +0200
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
From:   Karsten Wiborg <karsten.wiborg@web.de>
To:     nic_swsd@realtek.com, romieu@fr.zoreil.com
Cc:     netdev@vger.kernel.org
References: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
Openpgp: preference=signencrypt
Message-ID: <98cc1046-3736-12ae-79c1-84736af68d99@web.de>
Date:   Sat, 29 Jun 2019 23:19:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:VvBwZEjKpcKkEHy4KIAsCj1IAE3/WNd5PGmDjwybOzFtN1834bZ
 OF7yyQmJTeqL4vqIjpMlCXvpDTyqDPQOK9Ez3Sp3dRrSCCEHofhBzWItXTLu6b9tgyGbav1
 hdtFOT8ZfG3oWppj0uiL6odI/jMS4bf/xE5xVtyQtmJEueEzWVECapEJZ2VbN8cu7nui0K0
 fQfZ38ahjVlJ9lZa/sI4A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:WnejyFnK8ho=:E3FKcqre1jw7RKr9Xu7Zvq
 ABwmrNgln33QSaZCTc1wM97/b0587nFK0lfvi96PuwkMenxGlGl/Y/gD0RLe8/QTx5Ulz22Zt
 uXGTL7e4rArgklZabBA2hzqWUcpzdX14Qn3CPzvEnqcaocDj49Gnd3HHjIbs4vyGkbSR6dXSQ
 vD9rkhM3TJ7iIfnMie6HdkBONbjLTftBWKpj2VsaO5d2w17WDP5YZeE86AzD1brYIvS8BCIbn
 VpZF60Eoz/ThCqdBAgmC0YymxvN2NqihRrTIv/dVsu1nBUheksK3PVc5CiQERRCytPsxXGvSe
 v3xCyVIpf3cFjqyE3/dd0fJKnXAM4ZOaBs+f4k4K/Hly+JLuk/w6ZOy21diAJs7aClIRLs0Ge
 GyKpNCeMQ2zqeNI4oiWkqzeIc/EkUAbDsUNHL76dmQLqrGUFrWCmtlPZw06FVxpBIhIyXneYT
 7eOUeJdbM8aLRbAupLdvaGzsKrTinFIHeDEs1vMncZFWPEesIb14DsB5iDBFtJ31j/PJihZrc
 FJzsBLcn0TF+UHFFvgHkPza2d0ajQXPVC0dtR9kV3m+BdDbL13PH8sZL2rCZtkHDrVBw1DQWn
 VHKMY/CQ7QIOD3hb0PV+Q3auQZ5P+yg432j6/v6ELU1R5jiGfXZAgGKc/DtO4q7/JXoZI/yzh
 VUVmgvlbdZ+4ldQU8/cwtu618+tS0mS5zQTElfXGpuSnbQylWLTUYARs/4QkidVeVqaA4RhZ+
 7gKFI0SkWpvGM2S4o3YmeGytXjbe9EzymuGdds14dHrcHVkbNjDRqQyyobXj1Y+alF6Y+KEfY
 MBvRkb6X08eqYlMJEmoZcck00vOCfRzYdbpSUNycoUdhylXalFSMZaecWWsBuLzIqAnf5T4YI
 8toh4CKMe9X/6H8fFFvgtQTzEatpj+caBL0jGOw/bJrcA8/2mjsUmvGOm+T9aUWtOuw6zkI7Z
 dRhXi8ELTkEYwBY7NmSSynZT/+LpopLqtavr8P/3FgGG1nE4F/TulMBuTn91e8kRRmWgj2lFc
 UtMf0HfsnXTSusAcqF8IYH93w0W4GvXZe13CdZUf6Chn4JfsF7h8C+gQGLSc6Kq33cpfL+HO0
 a/6wXGlICCPIzRzs50CG4p3FC8Zo6P2K4rr
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

short update with some more data:

# more /var/lib/dkms/r8168/8.046.00/build/make.log
DKMS make.log for r8168-8.046.00 for kernel 5.2.0-050200rc6-generic (x86_6=
4)
Sat 29 Jun 2019 10:11:15 PM CEST
make: Entering directory '/usr/src/linux-headers-5.2.0-050200rc6-generic'
  CC [M]  /var/lib/dkms/r8168/8.046.00/build/r8168_n.o
  CC [M]  /var/lib/dkms/r8168/8.046.00/build/r8168_asf.o
  CC [M]  /var/lib/dkms/r8168/8.046.00/build/rtl_eeprom.o
  CC [M]  /var/lib/dkms/r8168/8.046.00/build/rtltool.o
/var/lib/dkms/r8168/8.046.00/build/r8168_n.c: In function =E2=80=98rtl8168=
_down=E2=80=99:
/var/lib/dkms/r8168/8.046.00/build/r8168_n.c:28376:9: error: implicit
declaration of function =E2=80=98synch
ronize_sched=E2=80=99; did you mean =E2=80=98synchronize_net=E2=80=99?
[-Werror=3Dimplicit-function-declaration]
         synchronize_sched();  /* FIXME: should this be
synchronize_irq()? */
         ^~~~~~~~~~~~~~~~~
         synchronize_net
cc1: some warnings being treated as errors
make[1]: *** [scripts/Makefile.build:278:
/var/lib/dkms/r8168/8.046.00/build/r8168_n.o] Error 1
make: *** [Makefile:1595: _module_/var/lib/dkms/r8168/8.046.00/build]
Error 2
make: Leaving directory '/usr/src/linux-headers-5.2.0-050200rc6-generic'


# gcc -v
Using built-in specs.
COLLECT_GCC=3Dgcc
COLLECT_LTO_WRAPPER=3D/usr/lib/gcc/x86_64-linux-gnu/8/lto-wrapper
OFFLOAD_TARGET_NAMES=3Dnvptx-none
OFFLOAD_TARGET_DEFAULT=3D1
Target: x86_64-linux-gnu
Configured with: ../src/configure -v --with-pkgversion=3D'Debian 8.3.0-6'
=2D-with-bugurl=3Dfile:///usr/share/doc/gcc-8/README.Bugs
=2D-enable-languages=3Dc,ada,c++,go,brig,d,fortran,objc,obj-c++
=2D-prefix=3D/usr --with-gcc-major-version-only --program-suffix=3D-8
=2D-program-prefix=3Dx86_64-linux-gnu- --enable-shared
=2D-enable-linker-build-id --libexecdir=3D/usr/lib
=2D-without-included-gettext --enable-threads=3Dposix --libdir=3D/usr/lib
=2D-enable-nls --enable-bootstrap --enable-clocale=3Dgnu
=2D-enable-libstdcxx-debug --enable-libstdcxx-time=3Dyes
=2D-with-default-libstdcxx-abi=3Dnew --enable-gnu-unique-object
=2D-disable-vtable-verify --enable-libmpx --enable-plugin
=2D-enable-default-pie --with-system-zlib --with-target-system-zlib
=2D-enable-objc-gc=3Dauto --enable-multiarch --disable-werror
=2D-with-arch-32=3Di686 --with-abi=3Dm64 --with-multilib-list=3Dm32,m64,mx=
32
=2D-enable-multilib --with-tune=3Dgeneric
=2D-enable-offload-targets=3Dnvptx-none --without-cuda-driver
=2D-enable-checking=3Drelease --build=3Dx86_64-linux-gnu
=2D-host=3Dx86_64-linux-gnu --target=3Dx86_64-linux-gnu
Thread model: posix
gcc version 8.3.0 (Debian 8.3.0-6)


Regards,
Karsten Wiborg

On 6/29/19 10:34 PM, Karsten Wiborg wrote:
> Hello,
>
> writing to you because of the r8168-dkms-README.Debian.
>
> I am using a GPD MicroPC running Debian Buster with Kernel:
> Linux praktifix 5.2.0-050200rc6-generic #201906222033 SMP Sun Jun 23
> 00:36:46 UTC 2019 x86_64 GNU/Linux
>
>
> Got the Kernel from:
> https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.2-rc6/
> Reason for the Kernel: it includes Hans DeGoedes necessary fixes for the
> GPD MicroPC, see:
> https://github.com/jwrdegoede/linux-sunxi
> (btw. I also tried Hans' 5.2.0rc5-kernel which also did not work with
> respect to Ethernet). Googling of course didn't help out either.
>
>
> My GPD MicroPC with running r8169 gives the following lines in dmesg:
> ...
> [    2.839485] libphy: r8169: probed
> [    2.839776] r8169 0000:02:00.0 eth0: RTL8168h/8111h,
> 00:00:00:00:00:00, XID 541, IRQ 126
> [    2.839779] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200
> bytes, tx checksumming: ko]
> ...
> [    2.897924] r8169 0000:02:00.0 eno1: renamed from eth0
>
>
> ip addr show gives me:
> # ip addr show
> ...
> 2: eno1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group
> default qlen 1000
>     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
> ...
>
>
> ethtool gives me:
> # ethtool -i eno1
> driver: r8169
> version:
> firmware-version:
> expansion-rom-version:
> bus-info: 0000:02:00.0
> supports-statistics: yes
> supports-test: no
> supports-eeprom-access: no
> supports-register-dump: yes
> supports-priv-flags: no
>
>
> lspci shows me:
> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 15)
>
>
> Installing r8168-dkms fails with the following errors:
> Setting up r8168-dkms (8.046.00-1) ...
> Removing old r8168-8.046.00 DKMS files...
>
> ------------------------------
> Deleting module version: 8.046.00
> completely from the DKMS tree.
> ------------------------------
> Done.
> Loading new r8168-8.046.00 DKMS files...
> Building for 5.2.0-050200rc6-generic 5.2.0-rc5-gpd-custom
> Building initial module for 5.2.0-050200rc6-generic
> Error! Bad return status for module build on kernel:
> 5.2.0-050200rc6-generic (x86_64)
> Consult /var/lib/dkms/r8168/8.046.00/build/make.log for more information=
.
> dpkg: error processing package r8168-dkms (--configure):
>  installed r8168-dkms package post-installation script subprocess
> returned error exit status 10
> Errors were encountered while processing:
>  r8168-dkms
> E: Sub-process /usr/bin/dpkg returned an error code (1)
>
>
> Does that help you?
> Do you need more data?
> Thank you very much in advance for hopefully looking into this matter.
>
> Regards,
> Karsten Wiborg
>
