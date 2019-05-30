Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4102F795
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 08:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbfE3GvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 02:51:17 -0400
Received: from mail-ed1-f53.google.com ([209.85.208.53]:39239 "EHLO
        mail-ed1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbfE3GvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 02:51:16 -0400
Received: by mail-ed1-f53.google.com with SMTP id e24so7593293edq.6;
        Wed, 29 May 2019 23:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=i8ltfB85nHYsiVuZ6k3XMvLLOh2sD6G9hmuIHQ0Z3bE=;
        b=LJbSOTDaufGQqQ+eA131yhXmkeKYznoB8UduwVh6EeJd8hXX+/A1RTiWTHafdGIXPH
         ieNv34O0w6PcmPcCM9A4V6OqV5oHWbOpfbL1RWSyqiHXTeAcCXJIOpR10yDeF1scWYid
         mlM147E9mNMURZHDnaQsXUSHZX6jlpE/tI45It7ZxuL9e4kXktcUCTxeTe5IoXEaofz3
         EftePTDM/K2VPMSWjBa+bLjWCK2K/iff/tuOytYbBKEuJnPgpWKvA14EA67FaXlJz3MZ
         StavO5mu5aXeonUT4tKR3Qx2z6j2r59d8Los1gQNusbeqhWf8OfS2+xAeoBYVWQFNya8
         w0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=i8ltfB85nHYsiVuZ6k3XMvLLOh2sD6G9hmuIHQ0Z3bE=;
        b=bDbJ0zNvYqYUN4TdBoF6PVpF5xODtNt/zgCTING5Bk9uYxkAlaC1Y/0WOj/q84/i3g
         JlozUvBSzIRBHB2tVfJ6jG0RB45dpbAVQFI168bQMT+o7D4KuW62Rj+HtaHfGGuNj0Df
         9vknp7RGu23cIo6rK49WJaZggjY/paLud7ZYQBPoKg2v0ClBr3wsOhD/vBQVaBkRdoYJ
         lyLllEpFAJ1vawpI9qOs/DfM6DkITmRYO2tUHBIFNsi0tJYFwYgE4L2MkrbmkEIT7Clm
         /XoNyfwhL/Tc9yrpA8/a3nGhNUfl3A3xeT1OPIr4/35VnccW+dDuccm8pMso9vkb+9lj
         v8pA==
X-Gm-Message-State: APjAAAViU+LNBWlaInujTL2JEfnwWgjjPfXVVmctx1TCg9P3XZRmMWXK
        dRTaj+JAinllMKybtY5gdKFBchusKXW+55W3mbg=
X-Google-Smtp-Source: APXvYqx14Dml+qJcLJ5hjIGGxPhchNXlfCS3u/hSeZh5waTRt4/qbVGKgmudAfLrWix4k7fI8jCYXHqNgUCMfLLo648=
X-Received: by 2002:a50:a51c:: with SMTP id y28mr2651199edb.280.1559199074629;
 Wed, 29 May 2019 23:51:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190530095632.34685e5b@canb.auug.org.au>
In-Reply-To: <20190530095632.34685e5b@canb.auug.org.au>
From:   Maxim Uvarov <muvarov@gmail.com>
Date:   Thu, 30 May 2019 09:51:03 +0300
Message-ID: <CAJGZr0KLtXeJ6uKWqFcqFY=25XbjAfJ_LUSjM8waXHsFpRZVMQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Trent Piepho <tpiepho@impinj.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge fix looks like correct. Might be my fault I sent dp83867 patches
against linux.git, not linux-next.git. If you want I can resend
updated version for linux-next.

Max.

=D1=87=D1=82, 30 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 02:56, Stephen Roth=
well <sfr@canb.auug.org.au>:
>
> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>   drivers/net/phy/dp83867.c
>
> between commits:
>
>   2b892649254f ("net: phy: dp83867: Set up RGMII TX delay")
>   333061b92453 ("net: phy: dp83867: fix speed 10 in sgmii mode")
>
> from the net tree and commits:
>
>   c11669a2757e ("net: phy: dp83867: Rework delay rgmii delay handling")
>   27708eb5481b ("net: phy: dp83867: IO impedance is not dependent on RGMI=
I delay")
>
> from the net-next tree.
>
> I fixed it up (I took a guess - see below) and can carry the fix as
> necessary. This is now fixed as far as linux-next is concerned, but any
> non trivial conflicts should be mentioned to your upstream maintainer
> when your tree is submitted for merging.  You may also want to consider
> cooperating with the maintainer of the conflicting tree to minimise any
> particularly complex conflicts.
>
> --
> Cheers,
> Stephen Rothwell
>
> diff --cc drivers/net/phy/dp83867.c
> index c71c7d0f53f0,3bdf94043693..000000000000
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@@ -26,18 -26,11 +26,19 @@@
>
>   /* Extended Registers */
>   #define DP83867_CFG4            0x0031
>  +#define DP83867_CFG4_SGMII_ANEG_MASK (BIT(5) | BIT(6))
>  +#define DP83867_CFG4_SGMII_ANEG_TIMER_11MS   (3 << 5)
>  +#define DP83867_CFG4_SGMII_ANEG_TIMER_800US  (2 << 5)
>  +#define DP83867_CFG4_SGMII_ANEG_TIMER_2US    (1 << 5)
>  +#define DP83867_CFG4_SGMII_ANEG_TIMER_16MS   (0 << 5)
>  +
>   #define DP83867_RGMIICTL      0x0032
>   #define DP83867_STRAP_STS1    0x006E
> + #define DP83867_STRAP_STS2    0x006f
>   #define DP83867_RGMIIDCTL     0x0086
>   #define DP83867_IO_MUX_CFG    0x0170
>  +#define DP83867_10M_SGMII_CFG   0x016F
>  +#define DP83867_10M_SGMII_RATE_ADAPT_MASK BIT(7)
>
>   #define DP83867_SW_RESET      BIT(15)
>   #define DP83867_SW_RESTART    BIT(14)
> @@@ -255,10 -321,18 +329,17 @@@ static int dp83867_config_init(struct p
>                 ret =3D phy_write(phydev, MII_DP83867_PHYCTRL, val);
>                 if (ret)
>                         return ret;
>  -      }
>
>  -      /* If rgmii mode with no internal delay is selected, we do NOT us=
e
>  -       * aligned mode as one might expect.  Instead we use the PHY's de=
fault
>  -       * based on pin strapping.  And the "mode 0" default is to *use*
>  -       * internal delay with a value of 7 (2.00 ns).
>  -       */
>  -      if ((phydev->interface >=3D PHY_INTERFACE_MODE_RGMII_ID) &&
>  -          (phydev->interface <=3D PHY_INTERFACE_MODE_RGMII_RXID)) {
>  +              /* Set up RGMII delays */
> ++              /* If rgmii mode with no internal delay is selected,
> ++               * we do NOT use aligned mode as one might expect.  Inste=
ad
> ++               * we use the PHY's default based on pin strapping.  And =
the
> ++               * "mode 0" default is to *use* * internal delay with a
> ++               * value of 7 (2.00 ns).
> ++              */
>                 val =3D phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RGM=
IICTL);
>
> +               val &=3D ~(DP83867_RGMII_TX_CLK_DELAY_EN | DP83867_RGMII_=
RX_CLK_DELAY_EN);
>                 if (phydev->interface =3D=3D PHY_INTERFACE_MODE_RGMII_ID)
>                         val |=3D (DP83867_RGMII_TX_CLK_DELAY_EN | DP83867=
_RGMII_RX_CLK_DELAY_EN);
>
> @@@ -275,41 -349,14 +356,41 @@@
>
>                 phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RGMIIDCTL,
>                               delay);
> -
> -               if (dp83867->io_impedance >=3D 0)
> -                       phy_modify_mmd(phydev, DP83867_DEVADDR, DP83867_I=
O_MUX_CFG,
> -                                      DP83867_IO_MUX_CFG_IO_IMPEDANCE_CT=
RL,
> -                                      dp83867->io_impedance &
> -                                      DP83867_IO_MUX_CFG_IO_IMPEDANCE_CT=
RL);
>         }
>
> +       /* If specified, set io impedance */
> +       if (dp83867->io_impedance >=3D 0)
> +               phy_modify_mmd(phydev, DP83867_DEVADDR, DP83867_IO_MUX_CF=
G,
> +                              DP83867_IO_MUX_CFG_IO_IMPEDANCE_MASK,
> +                              dp83867->io_impedance);
> +
>  +      if (phydev->interface =3D=3D PHY_INTERFACE_MODE_SGMII) {
>  +              /* For support SPEED_10 in SGMII mode
>  +               * DP83867_10M_SGMII_RATE_ADAPT bit
>  +               * has to be cleared by software. That
>  +               * does not affect SPEED_100 and
>  +               * SPEED_1000.
>  +               */
>  +              ret =3D phy_modify_mmd(phydev, DP83867_DEVADDR,
>  +                                   DP83867_10M_SGMII_CFG,
>  +                                   DP83867_10M_SGMII_RATE_ADAPT_MASK,
>  +                                   0);
>  +              if (ret)
>  +                      return ret;
>  +
>  +              /* After reset SGMII Autoneg timer is set to 2us (bits 6 =
and 5
>  +               * are 01). That is not enough to finalize autoneg on som=
e
>  +               * devices. Increase this timer duration to maximum 16ms.
>  +               */
>  +              ret =3D phy_modify_mmd(phydev, DP83867_DEVADDR,
>  +                                   DP83867_CFG4,
>  +                                   DP83867_CFG4_SGMII_ANEG_MASK,
>  +                                   DP83867_CFG4_SGMII_ANEG_TIMER_16MS);
>  +
>  +              if (ret)
>  +                      return ret;
>  +      }
>  +
>         /* Enable Interrupt output INT_OE in CFG3 register */
>         if (phy_interrupt_is_valid(phydev)) {
>                 val =3D phy_read(phydev, DP83867_CFG3);



--=20
Best regards,
Maxim Uvarov
