Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A36DC029
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 10:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395236AbfJRIml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 04:42:41 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:40148 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbfJRIml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 04:42:41 -0400
Received: by mail-ed1-f65.google.com with SMTP id v38so3939964edm.7
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 01:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=u/nAHlZF8MVbCU1ACELdIioO5Bm8fOQ9Oe64BTU18i8=;
        b=Ohos5Rzn5XClpO4yU/2peyXCB3O5RTX5BWaII13DT+7xv/jacZBLzFJ5/kKWkBeuq5
         eJf3sVCD0keiPqN/Uf+CS0IIahXgjt1h0l2VQPlTJX3ddXkKWe6C/g52HQ4DSJOHOcjX
         9amBgsunkLL6hx2z/50GYLn2c7KpuB4Oab6U8y7B7q2yZoxQOTTJWM+GoavtdMe1F54R
         fjEq/X16F+MsAMXtn5huAaCKy0GhHsgK5TL0nWjBjcRnqcTtsx7Z1ldguZBDwKa8ycGq
         0dyx+B8Z8vI2KYEnciRbfd8s+aPR5N+Z/At+SLLdourHnrEbHXgGox/3y3KXIT4IilM5
         vBGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=u/nAHlZF8MVbCU1ACELdIioO5Bm8fOQ9Oe64BTU18i8=;
        b=U9ACdc5VkXhn+y+SX9dzHZmcf5qC2tcHsxmwwY5zAtiJeDmU1c0rszohaEOXTL73of
         mRk9AoXRs1NTg9yLlcAZ1dyxX4fU3vUwutnNw/lWIqLMwGfYQ7TcCxsYvKriWX5je5sy
         zFDHSqStuoj4zDMnf2KNwUMpKOUfLiLVaU811uVbdMNHPpswOSNqs6YiuIC9w3Youe3C
         BOGULHeDsvNmVI+nNzhr1/Q6Aa359evhEDsR/9yIFgZNQGan4gs82aLkL9j4vdAGeto5
         QdspWK1VJ/1rDC9fdT7lGqFa+dVHr/+DxS+P3k077k/LdM/Br0ur5CpZbxbGgs0pzhfL
         Nfxg==
X-Gm-Message-State: APjAAAUIdiyIZReelCSzs3smlGTTp0w/U5oiiIwSLDn+M5L8PhPm5Ge6
        g8+6otT4Vpiti2iCmFOCuB1UCCy8PTsow6rF82bUQpBT
X-Google-Smtp-Source: APXvYqyedUwXLmloN2WP3/bNV/g5JepghZYBnAZ6HFNiJx9OrBPOJSBGauDC+rq8VVzIlLSNsupDnyOMNPY/uaHDv50=
X-Received: by 2002:a50:eb4d:: with SMTP id z13mr8197945edp.175.1571388159249;
 Fri, 18 Oct 2019 01:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <20191016120158.718e4c25@hermes.lan>
In-Reply-To: <20191016120158.718e4c25@hermes.lan>
From:   Maxim Uvarov <muvarov@gmail.com>
Date:   Fri, 18 Oct 2019 11:42:28 +0300
Message-ID: <CAJGZr0JFY9ene2iW8CGhWUwARC_TvJg9NCxy7MHdH+moVOjz0g@mail.gmail.com>
Subject: Re: Fw: [Bug 205215] New: Amiga X5000 Cyrus board DPAA network driver issue
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=D1=87=D1=82, 17 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 20:27, Stephen Hem=
minger <stephen@networkplumber.org>:
>
>
>
> Begin forwarded message:
>
> Date: Wed, 16 Oct 2019 18:57:44 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 205215] New: Amiga X5000 Cyrus board DPAA network driver is=
sue
>
>
> https://bugzilla.kernel.org/show_bug.cgi?id=3D205215
>
>             Bug ID: 205215
>            Summary: Amiga X5000 Cyrus board DPAA network driver issue
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.4
>           Hardware: PPC-32
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: IPV4
>           Assignee: stephen@networkplumber.org
>           Reporter: madskateman@gmail.com
>         Regression: No
>
> Hi all,
>
> It might or might not be a bug, but help would be very welcome.
>
> Me and all other AmigaOne X5000 users (Cyrus mainboard with Freescale P50=
20
> cpu) are not able to use the DPAA onboard Ethernet adapter with the linux
> kernels since the last two years (AFAIK)
> (link to the board: http://wiki.amiga.org/index.php?title=3DX5000 )
>
> So what is happening,
>
> First of all the hardware is functional. When using AmigaOS4.1FE the Ethe=
rnet
> adapter is fine. When using the adapter within U-boot (ping for example) =
it is
> also working as expected.
>
> When booted into linux the ethernet adapter does not get up.
> The output of DMESG is:
>
> skateman@X5000LNX:~$ dmesg | grep eth
> [ 4.740603] fsl_dpaa_mac ffe4e6000.ethernet: FMan dTSEC version: 0x082401=
01
> [ 4.741026] fsl_dpaa_mac ffe4e6000.ethernet: FMan MAC address:
> 00:04:a3:6b:41:7c
> [ 4.741387] fsl_dpaa_mac ffe4e8000.ethernet: FMan dTSEC version: 0x082401=
01
> [ 4.741740] fsl_dpaa_mac ffe4e8000.ethernet: FMan MAC address:
> 00:1e:c0:f8:31:b5
> [ 4.742001] fsl_dpaa_mac ffe4e0000.ethernet:
> of_get_mac_address(/soc@ffe000000/fman@400000/ethernet@e0000) failed

sound like mac is missing in dt.

> [ 4.742203] fsl_dpaa_mac: probe of ffe4e0000.ethernet failed with error -=
22
> [ 4.742382] fsl_dpaa_mac ffe4e2000.ethernet:
> of_get_mac_address(/soc@ffe000000/fman@400000/ethernet@e2000) failed
> [ 4.742568] fsl_dpaa_mac: probe of ffe4e2000.ethernet failed with error -=
22
> [ 4.742749] fsl_dpaa_mac ffe4e4000.ethernet:
> of_get_mac_address(/soc@ffe000000/fman@400000/ethernet@e4000) failed
> [ 4.747328] fsl_dpaa_mac: probe of ffe4e4000.ethernet failed with error -=
22
> [ 4.751918] fsl_dpaa_mac ffe4f0000.ethernet:
> of_get_mac_address(/soc@ffe000000/fman@400000/ethernet@f0000) failed
> [ 4.756660] fsl_dpaa_mac: probe of ffe4f0000.ethernet failed with error -=
22
> [ 4.763988] fsl_dpaa_mac ffe4e6000.ethernet eth0: Probed interface eth0
> [ 4.771622] fsl_dpaa_mac ffe4e8000.ethernet eth1: Probed interface eth1
>
> There has been already spend time and effort but the issues still remains=
..
> (
> http://linuxppc.10917.n7.nabble.com/DPAA-Ethernet-traffice-troubles-with-=
Linux-kernel-td132277.html
> )
>
> I might have found something that could point into the right direction.
>
> The last few days regarding another issue i stumbled upon this post from =
Russel
> King. It had to do with coherent DMA
> (http://forum.hyperion-entertainment.com/viewtopic.php?f=3D58&t=3D4349&st=
art=3D70)
>
> "Hmm, so it looks like PowerPC doesn't mark devices that are dma
> coherent with a property that describes them as such.
>
> I think this opens a wider question - what should of_dma_is_coherent()
> return for PowerPC? It seems right now that it returns false for
> devices that are DMA coherent, which seems to me to be a recipe for
> future mistakes.
>
> Any ideas from the PPC maintainers?"
>
> I started to dig around regarding DPAA ethernet and Coherent DMA and stum=
bled
> upon this document.
>
> http://cache.freescale.com/files/training/doc/ftf/2014/FTF-NET-F0246.pdf
>
> In this troubleshooting document similar issues and errors are being show=
n with
> possible troubleshooting steps.
>
> It would be great if someone could point us into the right direction and =
has a
> clue what could be changed within the kernel to get the Ethernet adapter
> working.
>
> Dave
>
> --
> You are receiving this mail because:
> You are the assignee for the bug.



--=20
Best regards,
Maxim Uvarov
