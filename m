Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F53C2EFEC1
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 10:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbhAIJTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 04:19:16 -0500
Received: from mout.gmx.net ([212.227.15.15]:60539 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726744AbhAIJTP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 04:19:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1610183860;
        bh=gKvG2+ALBkDOoHXulzfunmugQqhd8nKyqM1ol+u8ESQ=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
        b=EaSN3h+vdzq4wiHHN7Re4/0SMoH6odLRTCCOk6U4PJ5hEWQqn3xSYlNKxcq8ueb2H
         7kRmZ/C1ZRhFcVSjHnbMNflRqOeRsQnF2YiOpDk2vvvniDKolNXVz3LLMKXDXt7dTv
         occ9Nar9m5I0i+3Ng070RcQhOea9wYobmmGijrJk=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from E480.localdomain ([84.61.118.33]) by mail.gmx.com (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N3KPg-1jz9l82BBS-010OK0; Sat, 09
 Jan 2021 10:17:40 +0100
Date:   Sat, 9 Jan 2021 10:17:38 +0100
From:   Zhi Han <z.han@gmx.net>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] Incorrect filename in drivers/net/phy/Makefile
Message-ID: <20210109091738.GB25@E480.localdomain>
References: <20210106101712.6360-1-z.han@gmx.net>
 <0d9094e9-5562-8535-98c3-993161aea355@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d9094e9-5562-8535-98c3-993161aea355@gmail.com>
X-Provags-ID: V03:K1:73/ujKTpAvj98tLknscTCFGJW4DjJe9gqJMPeKSl0JwlevlW2pw
 vyvJ8L3Ckebt+iXbAtuAYfaHFYTrFP0RiQdrPsrRky4FgRwZHoCyyxq81O1ExFZ7xQxzdWd
 GJqNcHjbJRzbbHx+Tt6R+wmt0BVa70QzhUhj//Ruxg7rXtO9Z2wRZamnz0RotDmw6XzWgi7
 E3OSL00LidC9us23AEXGg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:IIAIzUE5P1A=:dCPU0jSxFSMPLjPidHcDeg
 h/Zq+6UxjjRdWps3Yx2zDStmB+9pyDhH+sO52e1nbUp+PmlwKZ7N+/fZqPaznT/+ZiTIX7JVu
 PPwyg9LHpHKj7vItCF+8Nlo6SKfYwvXOt6wTBimCzzonCq5VbDGoFkYW0c3Y/Ty8F3LaEw1kl
 71vF4IXgko7Em1dcg1JqmSD/uXEjzlAPgh4HdtgJ/V0XzJjswT544+l/dkoZU7iFWJ6aW2XCL
 NDxLwlNKh+9/yFZ0eOVrtZnfpTnvnTh0TchcTS/1OFr1WNxhVNhGoj8v378VlCiO84SBlthGs
 dj3GzvNHS/eQzvv6kbyzTaG0S9tUreLKRTjL5crL4ATiINM1MQz3w6phSFWlr+lwdbQgmfwrs
 zUSZsRWUyWU8bSy+9gTkLx/0duJunpgsDf3V6r/h3GkRtCuXjP2O12AfEJO1Lr5i5XxVlyM7M
 yrRVgD59A3vcpjlOU7Squx44Sfz492eAautVoKnThkY90x1EcH/BWgG+sLtRPPX28IOkJAzt0
 SEIqEkkCykNgigoiB/97+QLnypl+Skf3QQ87yubpiAv2UiRQAYEhqInbveZanp5FvdRYtlpMz
 Tjk18W2F3Jt0JT6v1Da9yP7Su6PTBcsVYs389nwI4dvbxrAsP1K6sNPcTmeycV+f/zOkdItRn
 bX3uQdmIfFEG4OAkzxjZVtDJlOWXEXGxVhXLHkCxXcQDhP02Fz6WB9xagS3QTXzVyisqW6mHb
 tkw30wOF+2qoUb2HEHLUc1KzIwpwL/9iMD9l7IqmSR/V93JXFV2k4dxVQFzX7iIVfHZ8r1vF2
 xfjWIsT15fj1EM51S9FE/ud/z1vbAQKiwfOECLCaSEXRH7GpHwFtCi7XYXDfR1AnIn4IyTx+C
 /daswWbOW2oaW5T2aKeA==
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks a lot for the .config file.
I also tested it, with mdio-bus.o in the Makefile, glad to got that there =
is
no problem of that, although I don't know the reason/trick yet.

On Wed, Jan 06, 2021 at 04:13:56PM -0800, Florian Fainelli wrote:
> The change was done on purpose, and your patch does not build with the
> attached .config which only enables CONFIG_MDIO_DEVICE but not
> CONFIG_PHYLIB, it causes the following linking failure:
>
>   MODPOST Module.symvers
> ERROR: modpost: "mdio_device_free" [drivers/net/phy/mdio_bus.ko] undefin=
ed!
> ERROR: modpost: "mdio_device_reset" [drivers/net/phy/mdio_bus.ko] undefi=
ned!
> ERROR: modpost: "mdio_device_create" [drivers/net/phy/mdio_bus.ko]
> undefined!
> ERROR: modpost: "mdio_device_register" [drivers/net/phy/mdio_bus.ko]
> undefined!
> ERROR: modpost: "mdio_device_bus_match" [drivers/net/phy/mdio_bus.ko]
> undefined!
> make[1]: *** [scripts/Makefile.modpost:111: Module.symvers] Error 1
> make[1]: *** Deleting file 'Module.symvers'
> make: *** [Makefile:1396: modules] Error 2
> zsh: exit 2     make modules -j33
>
> if you look at the build products you will that mdio_bus.c actually gets
> built into mdio-bus.o:
>
>  ls drivers/net/phy/mdio-bus.*
> drivers/net/phy/mdio-bus.ko   drivers/net/phy/mdio-bus.mod.c
> drivers/net/phy/mdio-bus.o
> drivers/net/phy/mdio-bus.mod  drivers/net/phy/mdio-bus.mod.o
>
> --
> Florian

