Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5F2136404
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 00:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729558AbgAIXuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 18:50:17 -0500
Received: from mout.gmx.net ([212.227.17.20]:40549 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728277AbgAIXuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 18:50:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1578613812;
        bh=jbqNfvp4GAqDjXTt+yDfy3nbF0VzdYkcOPLz1XHqEjc=;
        h=X-UI-Sender-Class:Reply-To:Subject:To:Cc:References:From:Date:
         In-Reply-To;
        b=Kk44yGd+Za9rytA+ZPFuAcZ7VareHbw/U3yrr2HpBCC0fucRxCk1zTFpM0v8k3y9v
         HuJDwn9pe4Xn+9ICgjYUosPnu/WSi3QYDiGwRxoHjIoApWWhCt/c345qFxGBiC26oM
         T2ez6ZO0HvnJNOOfvRM9tQr4jQLMPr5CngF0MoNQ=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([81.25.174.156]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MiJVG-1jIh3S0IUA-00fSVk; Fri, 10
 Jan 2020 00:50:12 +0100
Reply-To: vtol@gmx.net
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
References: <d8d595ff-ec35-3426-ec43-9afd67c15e3d@gmx.net>
 <20200109144106.GA24459@lunn.ch>
 <513d6fe7-65b2-733b-1d17-b3a40b8161cf@gmx.net>
 <20200109155809.GQ25745@shell.armlinux.org.uk>
 <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
 <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
 <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
 <20200109215903.GV25745@shell.armlinux.org.uk>
 <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
 <20200109231034.GW25745@shell.armlinux.org.uk>
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
Message-ID: <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
Date:   Thu, 9 Jan 2020 23:50:14 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <20200109231034.GW25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:8ge9Ytp1H76CgBxwvKspoQKxPi/m//9AJ7lpDCJJTVVBrZAyIlQ
 POiyLMgzY2uoE8rI5W5okF1OB/migLyWOa79U9uy5lBdf1fqW09JYttZKf2W0HzNNN5KB6G
 IpenoTBK0EJxZIXnhGrAO3b5W35m+Kb1DufgLtoa1yxe8BhTnYveMywWTJ99w3HzZJSEPv6
 ULvHT2v4x0sdnUH6Jroww==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:7TUkOTf1bRU=:ks3kfUb/BQxNpy0M/MAoVp
 nxreqpXQSrQNeE+J7ecICByJmf6WCHhog8PnE7i/72Va1DoW60K6jtUQMU+RRj0NsGqTw8C9J
 tb+/BJWgv0euNuV9TzncR9R/MfBPwV/UWMQiGbmJ46s3ppv8NfK2dW2UVCqHcfJ7BYgyXiSan
 ArVf7DMeIFiO59VvV0WDFN+38Gv1+d/+GF6boRoiNNZ+ghNrGEUg06RmwhuGvxUFLsgZIB1/a
 PWJjcpKKegvcsitEmY4OkRyvT/UaZ7y915aCJkSKZq+PoJuokEXKTTHsvOjg9Ro7XeDV2aWGn
 ZvLWoMdWJInyq3BOSRC8zDD13RJDbP+i/LjOAqRjvcuAAljo1zCL3Gt5UaTTTsM69nmLUOQhp
 SL+gzd4kXj0e3ZV0Sfi1ueNYEKlO3GCUmyxAA46wvJPu/Hv/eGVnlfMM+KGGPqqzEmZO01Ydx
 MZ52iMNBpipeVEPqXurbMeyRQSdVDwCo6QehQYGfyroF+gWCbtDfT359AGneqLTVu1jrGbvQJ
 WFX+mAv+yNg+Tb+vJWHYMw0JoCnB9NimRPSxAHPFY3vmyEe+HGRMPN76JYz7WqJRepDHWEzEB
 5jLSJ+50lkqGkDGANMDgJZLImwzSDOc/D0aEZyv5Ghh3zh5hOBGEJTmozvsTUen5BnvtfCTdn
 T2qPQfOQfVeK4hixTY1Q/E51wuraaMSVTHT8HQkKYKzJRPF2wrN4dGSw8ocmwTjG4qML64RiN
 Ph7PrP139Aakf4b+TTtSxYmLgrEy3crboG8Ti1uXX8UFPXKRSAU/t8hASeC5jaqR9Efo9T+j9
 eZO/axryJngemiixSDDYz8rwhFhhY3asY60d8xQtwQsNRDu4N2AKZeAJufxlsoUGLgw6CrywL
 oHGyD8CsMVOg30pzLbaYGbz2TiA0++ulNtLH4n7SPiCCmnQ9X5K5OWc/64khKP1R8pAqX4x8Q
 8UkGoQpQiiUc3LjpEWiZQMvA90TISUMsKtVl+sVscAEx2nyj3dCOkyGQ1xJQcINWuccl+DULX
 aCuVIl7X5FMrRXWHcqZIxrgk1Ouvb4RKOACXg7Zr89CCoM9zaKznX60IUPkpqMeZUwFr2nWVB
 wror9AHpYuFMGTE5hJyOg/J1VLoS/Arh+YOqoteRoDJiQguOgKUpYJUX/X/ipwRZwBf61sVsB
 THms2g6U5Z64TERQwiGOAMaWUQEUy3nBhAz37BVrUaPMjbtGY/x+ASl5bDZDjyjE7vVlMHpss
 wRU1g2V8AOQv+D8cB9hLrCj3Wbmk4uvpPXI3PEw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09/01/2020 23:10, Russell King - ARM Linux admin wrote:
>
> Please don't use mii-tool with SFPs that do not have a PHY; the "PHY"
> registers are emulated, and are there just for compatibility. Please
> use ethtool in preference, especially for SFPs.

Sure, just ethtool is not much of help for this particular matter, all=20
there is ethtool -m and according to you the EEPROM dump is not to be=20
relied on.

>
> CONFIG_DEBUG_GPIO is not the same as having debugfs support enabled.
> If debugfs is enabled, then gpiolib will provide the current state
> of gpios through debugfs.  debugfs is normally mounted on
> /sys/kernel/debug, but may not be mounted by default depending on
> policy.  Looking in /proc/filesystems will tell you definitively
> whether debugfs is enabled or not in the kernel.
debugsfs is mounted but ls -af /sys/kernel/debug/gpio only producing=20
(oddly):

/sys/kernel/debug/gpio

>
> So, if that is correct...
>
> Current OpenWRT is derived from 4.19-stable kernels, which include
> experimental patches picked at some point from my "phy" branch, and
> TOS is derived from OpenWRT.

This may not be correct since there are not many device targets in=20
OpenWrt that feature a SFP cage (least as of today), the Turris Omnia=20
might even be the sole one.
I did not check whether that the code was/is available in OpenWrt, and=20
likely it is not, but it was in an earlier TOS version since their=20
platforms apparently feature a SFP cage.
> That makes it very difficult for anyone in the mainline kernel
> community to do anything about this; sending you a patch is likely
> useless since you're not going to be able to test it.

I understand, I just reached out all the way upstream since other=20
available avenues, and started all the way downstream, did not produce=20
anything tangible or even a response.
I am grateful that finally at least you obliged and shed some light on=20
the matter. Maybe I should just try finding a module that is declared=20
SPF MSA conform...

>
> You think the state machines are doing something clever. They don't.
> They are all very simple and quite dumb.

Not really, I assume it just does what it is supposed to do in line with =

current (industry) standards and best practices.

>
> The only real way to get to the bottom of it is to manually enable
> debug in sfp.c so its possible to watch what happens, not only with
> the hardware signals but also what the state machines are doing.
> However, I'm very certain that there is no problem with the state
> machines, and it is that the Allnet module is raising TX_FAULT.

I am sure it does and I am pursuing Allnet for a response, albeit not=20
looking promising at the moment. Once there is however I shall pick up=20
the thread again.

> I also think from what you've said above that rebuilding a kernel
> to enable debug in sfp.c is going to not be possible for you.

No, I might be able to get this done for amd64 but with this ARM SoC=20
there is all kind of other stuff (SPI, MTD, I2C, u-boot and whatnot)=20
involved and I am afraid it will go sideways if I attempt compiling.

