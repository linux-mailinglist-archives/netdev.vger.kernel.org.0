Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4F12DA401
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 00:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441167AbgLNXN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 18:13:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:47424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408952AbgLNXNV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 18:13:21 -0500
Date:   Mon, 14 Dec 2020 15:12:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607987560;
        bh=TY+cKO1oKjT9ODEoq4IxpqVCBd03on5wRLLEyrOgYPM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=WQVjm1PxdcXHJfBgiwociK3nlr/UZtEil5u7yyGKAriyBqmBAL4WGlKwag0qf6Ihj
         LP1lo4oLv6W4ZKRHUknRiwWMHZ45H+jAZPgJql+hxZPwBC6zFqOjsieC9SKFFQ5ZTZ
         Ebj4psY1uVya2OUOLKh0qmSb9h4THS9JkXWmyEGxTtIV1l/cjUWUE0E08SsBuE4caw
         KAlO7+mk+n65818IZqY0kVGeoG7Hpcsueum/ZQ8jccT4VWvUNHVspE7zIgoNyrwkNc
         Cnohss7hgN0/66sIGlsx4jhhUUmbb23b8qZDL0CofKBu08pT057Fo1+prz8q6TQwgJ
         Me9ZJ3PsY387A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <marex@denx.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v2 net-next] net: phy: mchp: Add 1588 support for
 LAN8814 Quad PHY
Message-ID: <20201214151239.1e4d9653@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201214175658.11138-1-Divya.Koppera@microchip.com>
References: <20201214175658.11138-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 23:26:58 +0530 Divya Koppera wrote:
> This patch add supports for 1588 Hardware Timestamping support
> to LAN8814 Quad Phy. It supports L2 and Ipv4 encapsulations.
>=20
> Signed-off-by: Divya Koppera<divya.koppera@microchip.com>
> ---
> v1 -> v2
> * Fixed warnings
>   Reported-by: kernel test robot <lkp@intel.com>

Still doesn't build here:

In file included from ../arch/x86/include/asm/page_32.h:35,
                 from ../arch/x86/include/asm/page.h:14,
                 from ../arch/x86/include/asm/processor.h:19,
                 from ../arch/x86/include/asm/timex.h:5,
                 from ../include/linux/timex.h:65,
                 from ../include/linux/time32.h:13,
                 from ../include/linux/time.h:73,
                 from ../include/linux/stat.h:19,
                 from ../include/linux/module.h:13,
                 from ../drivers/net/phy/micrel.c:24:
In function =E2=80=98memcmp=E2=80=99,
    inlined from =E2=80=98lan8814_dequeue_skb=E2=80=99 at ../drivers/net/ph=
y/micrel.c:460:7:
../include/linux/string.h:436:4: error: call to =E2=80=98__read_overflow2=
=E2=80=99 declared with attribute error: detected read beyond size of objec=
t passed as 2nd parameter
  436 |    __read_overflow2();
      |    ^~~~~~~~~~~~~~~~~~
make[4]: *** [drivers/net/phy/micrel.o] Error 1
make[3]: *** [drivers/net/phy] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/net] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [__sub-make] Error 2
In file included from ../arch/x86/include/asm/page_32.h:35,
                 from ../arch/x86/include/asm/page.h:14,
                 from ../arch/x86/include/asm/processor.h:19,
                 from ../arch/x86/include/asm/timex.h:5,
                 from ../include/linux/timex.h:65,
                 from ../include/linux/time32.h:13,
                 from ../include/linux/time.h:73,
                 from ../include/linux/stat.h:19,
                 from ../include/linux/module.h:13,
                 from ../drivers/net/phy/micrel.c:24:
In function =E2=80=98memcmp=E2=80=99,
    inlined from =E2=80=98lan8814_dequeue_skb=E2=80=99 at ../drivers/net/ph=
y/micrel.c:460:7:
../include/linux/string.h:436:4: error: call to =E2=80=98__read_overflow2=
=E2=80=99 declared with attribute error: detected read beyond size of objec=
t passed as 2nd parameter
  436 |    __read_overflow2();
      |    ^~~~~~~~~~~~~~~~~~
make[4]: *** [drivers/net/phy/micrel.o] Error 1
make[3]: *** [drivers/net/phy] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/net] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers] Error 2
make: *** [__sub-make] Error 2
