Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCC24056D3
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355167AbhIINYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:24:01 -0400
Received: from mout.gmx.net ([212.227.15.18]:44605 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356904AbhIINVQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 09:21:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1631193592;
        bh=o+A1F6vlfY468csskwnPLRPnkzv0cU7vnY/8TAvErM8=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Don1CUG18Fxw6csFAaHkTgtC1MMlK3t+/1Dc+zpR530/vug44JCW+H0LXwbwYR0g9
         8tIRejHMxywERlLtqTv94/E0GTX3MxwafT5ZG5C1bJdCUg94lYhLGEyR1RiBVtRnWM
         8g9M/IoAPvs186sMtxO2W/hcTxjO15K9H8OkrqOQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [46.223.119.124] ([46.223.119.124]) by web-mail.gmx.net
 (3c-app-gmx-bs01.server.lan [172.19.170.50]) (via HTTP); Thu, 9 Sep 2021
 15:19:52 +0200
MIME-Version: 1.0
Message-ID: <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Aw: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 9 Sep 2021 15:19:52 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210909125606.giiqvil56jse4bjk@skbuf>
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:Ja0lCbndn8thG0GnPuWLbYn3jwlS8EOt++u4dL6T6Mzm1vVgPqAGCvttqJf+qO4Lc4PEJ
 UYN7mebC6AcA8QVcGlhaAXPSeJ7cl/M57vKBxRmhf/OijfzN/xZhIOanhdif8L0tPePE7WLayBy/
 yGxuofax5MGhsFS40MKU2fFy/Za5oLiMS/D2fLmI4ZI0wqkBEvPh87cEXHd+BJYqy+DkoQzUAlSw
 L1Ux1+mOw1PKyA9RvpT7H3acSqyThShAlmcKGCx71s7XIUZkwZasb2DrS3WC9DxYo3Qh14xXKLqk
 mc=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:hEcVDS4m76Y=:GQR00fTgpndLoJNgnbAU4V
 s9YbrFCQPu3PVWdSmQlaglKc30HtPnWR/lO2SE4K87Gyi7VAKj/8VYpBk6iBLZKzCX40jiXfb
 yfZyxoK9mHDURvLFY6GiFIHXYHtZpBLKVkVCsmVCk9h6APscq3NcYxXxRzvML/Jvy21TNOeMU
 4T5zd7fIUW4Wl+ABmkqz6aVW1lCSA7tcGVsTvmU6XZOkTuWnx7E1UHEzfvF1nONyAylKIm8CG
 YKSxCuC/d/A6uvMcSQUiBS0ZV+5qb6joRcCha5Hn9htXPtYsq9BSMdqYTL8KX6eNtYCxyjZj3
 r2Vv5tHU8VQd3WsH4OBdGWW7J2PKdDGg1uXkkkchgZRhyE3UsfwSXk45BOR+p3EPsMg1yGHJE
 JhHdRE6yeCiflX1YX5ftumAVj4xoepHzc749MXLmDCNFYWLP7TGHLuN+vZGs5tQZnE84sB3OY
 0APSRjd3OAhlf0KpmeM2YspqDcBfGnVHMG+2cpwZiUAwxdW6ByMYDc1x6Are3GE5HjPjtsh07
 Izcr1/utJZ2OK/RA1hFpYSM0bXwyzFE30vNSP/0jlnY7Fxm92ruNSrYxeP9nzP50WVIuYxmtw
 ckl01RLRBiMgpIUpyG1hWak13xNIQGMs3E76Kl72B574KJuk3W+jGa3UvSxh4AjdbJyc3aSco
 LpfLeeCYXhXVgtShVFxD/IiQXHn4BQprZU+/FGJlovIRjhzQLvCT1uWRQelh+Xwcox3lvtJ7E
 LMk6M8upzE6oMSna9+9T86ClLR7sHHG7N38LHPDsSEU6KmA/wS/Ahc8dR7GBWLxZWMSLP5rxs
 EdQwdPjwqG+nCZ1rSbhJyJpGXmAWRk2r8Ts1SNQn2zbSQvi+zY=
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir, Andrew,

sorry for the late response.

> Gesendet: Donnerstag, 09. September 2021 um 14:56 Uhr
> Von: "Vladimir Oltean" <olteanv@gmail.com>
> An: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>
> Cc: p.rosenberger@kunbus.com, woojung.huh@microchip.com, UNGLinuxDriver@=
microchip.com, andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.=
com, davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org, linux-k=
ernel@vger.kernel.org
> Betreff: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
>
> On Thu, Sep 09, 2021 at 02:42:48PM +0300, Vladimir Oltean wrote:
> > I feel that something is missing in your system. Is the device link
> > created? Is it deleted before going into effect on shutdown?
>
> So in case my questions were confusing, you can check the presence of
> the device links via sysfs.
>
> On my board, eno2 is the top-level DSA master, there is a switch which
> is PCIe PF 0000:00:00.5 which is its consumer:
>
> ls -la /sys/class/net/eno2/device/consumer\:pci\:0000\:00\:00.5
> lrwxrwxrwx    1 root     root             0 Jan  1 00:00 /sys/class/net/=
eno2/device/consumer:pci:0000:00:00.5 -> ../../../../../virtual/devlink/pc=
i:0000:00:00.2--pci:0000:00:00.5
>
> In turn, that switch is a DSA master on two ports for SPI-attached switc=
hes:
>
> ls -la /sys/class/net/swp0/device/consumer\:spi\:spi2.*
> lrwxrwxrwx    1 root     root             0 Jan  1 00:04 /sys/class/net/=
swp0/device/consumer:spi:spi2.0 -> ../../../../../virtual/devlink/pci:0000=
:00:00.5--spi:spi2.0
> lrwxrwxrwx    1 root     root             0 Jan  1 00:04 /sys/class/net/=
swp0/device/consumer:spi:spi2.1 -> ../../../../../virtual/devlink/pci:0000=
:00:00.5--spi:spi2.1
>
> Do you see similar things on your 5.10 kernel?

For the master device is see

lrwxrwxrwx 1 root root 0 Sep  9 14:10 /sys/class/net/eth0/device/consumer:=
spi:spi3.0 -> ../../../virtual/devlink/platform:fd580000.ethernet--spi:spi=
3.0


>
> Please note that I don't think that particular patch with device links
> was backported to v5.10, at least I don't see it when I run:


> git tag --contains  07b90056cb15f
>
> So how did it reach your tree?
>

The kernel I use is the Raspberry Pi 5.10 kernel. The commit number in thi=
s kernel is d0b97c8cd63e37e6d4dc9fefd6381b09f6c31a67

Andrew: the switch is not on a hat, the device tree part I use is:



       spi@7e204c00 {
            cs-gpios =3D <0x0000000f 0x00000010 0x00000001 0x0000000f 0x00=
000012 0x00000001>;
            pinctrl-0 =3D <0x000000e5 0x000000e6>;
            pinctrl-names =3D "default";
            compatible =3D "brcm,bcm2835-spi";
            reg =3D <0x7e204c00 0x00000200>;
            interrupts =3D <0x00000000 0x00000076 0x00000004>;
            clocks =3D <0x00000007 0x00000014>;
            #address-cells =3D <0x00000001>;
            #size-cells =3D <0x00000000>;
            status =3D "okay";
            phandle =3D <0x000000be>;
            tpm@1 {
                phandle =3D <0x000000ed>;
                status =3D "okay";
                interrupts =3D <0x0000000a 0x00000008>;
                #interrupt-cells =3D <0x00000002>;
                interrupt-parent =3D <0x0000000f>;
                spi-max-frequency =3D <0x000f4240>;
                reg =3D <0x00000001>;
                pinctrl-0 =3D <0x000000e7>;
                pinctrl-names =3D "default";
                compatible =3D "infineon,slb9670";
            };
            ksz9897@0 {
                phandle =3D <0x000000ec>;
                status =3D "okay";
                reset-gpios =3D <0x000000e1 0x0000000d 0x00000001>;
                spi-cpol;
                spi-cpha;
                spi-max-frequency =3D <0x01f78a40>;
                reg =3D <0x00000000>;
                compatible =3D "microchip,ksz9897";
                ports {
                    #size-cells =3D <0x00000000>;
                    #address-cells =3D <0x00000001>;
                    port@2 {
                        label =3D "piright";
                        reg =3D <0x00000002>;
                    };
                    port@1 {
                        label =3D "pileft";
                        reg =3D <0x00000001>;
                    };
                    port@0 {
                        ethernet =3D <0x000000d7>;
                        label =3D "cpu";
                        reg =3D <0x00000000>;
                    };
                };
            };

Regards,
Lino

