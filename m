Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5EE7A5CB
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 12:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732487AbfG3KPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 06:15:14 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:39528 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfG3KPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 06:15:14 -0400
Received: by mail-ed1-f66.google.com with SMTP id m10so62051695edv.6;
        Tue, 30 Jul 2019 03:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qH2NmvoDjYLEyvJyGu0UBwT8A48d4in6G9tvqwnTNu8=;
        b=lkIO9VOxfLRNVvkMRA07ahhhWbqmJVGI/DJF4j7ffJ98lZRm4LcUWz0CfP4G6NeSbU
         cuemzbyrHaY+te0W84bXgkiIWqC/+rltRaRuxASwbNFSnSLvtlhJ2QMoJZoj2rQJrui8
         ebFeROimcrkiJosCxJ8OPmmrj8YooLwicMs4iJ4NpD91urG3JZQiB0umRX3zorki0SUy
         ZsDUDI0Wd5aUdtYATyqOXow0lgwtzOluMcRt+PPt/KJZUGBjxBqeUL+uwdUBGtcCrz0L
         qwEyQYXl0HIB9f5Erzr0be2vjn3WcVRpRS3fPaa6P8GlJk2ydJDiZA008EgyRVQgr+n+
         Lp8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qH2NmvoDjYLEyvJyGu0UBwT8A48d4in6G9tvqwnTNu8=;
        b=r85asf5C5BL7Ix59Xx3PPwo9HHkV2FgiueYaGIHSB+KEsD1VI2vZQMMt8lKCunfHRk
         Si8gIIrDPbI08cmkezIOGunKtuhx5rzBoy9BQSJ2UFdXmmQ426PTS+ag5mClqKEkS8ZG
         aEJCtRJPe+zGiOO0PHM+8qqoCZhfvrfB1hmfsOtKSn/8C40eFCnqTPmHx4sUuWn8/Kmc
         PIL80wKGNL13TegkBRAYl9tCQEjgyITQorC3P4XurMlVNA/QV7rg8rWMeIOhkoudTiEp
         NCcYG0nwUAlY+IAQ5la3zuQjnlf2MX1RJpom2H9Tb45gXb06DLj4FBW5Q0es0ePySeh+
         /iag==
X-Gm-Message-State: APjAAAULN/tuE3g8CNw872l4qIF9hEexG0VYYEAQ9uPASXYkx1xfEeso
        2WD51FzJqrYmXmNdntj4O05Pz+2mZY6GbfsF7xM=
X-Google-Smtp-Source: APXvYqz8veL3EUs2DsiVKzCrDj5Y2kCbkqgZ+bjaBjAL1gRW2xHQQmM3gNdYA66YY44vlKsaZeErYwQvLWE0K4Y+mkE=
X-Received: by 2002:aa7:cdc2:: with SMTP id h2mr16768863edw.108.1564481711773;
 Tue, 30 Jul 2019 03:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190730002549.86824-1-taoren@fb.com> <CA+h21hq1+E6-ScFx425hXwTPTZHTVZbBuAm7RROFZTBOFvD8vQ@mail.gmail.com>
 <3987251b-9679-dfbe-6e15-f991c2893bac@fb.com>
In-Reply-To: <3987251b-9679-dfbe-6e15-f991c2893bac@fb.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 30 Jul 2019 13:15:00 +0300
Message-ID: <CA+h21ho1KOGS3WsNBHzfHkpSyE4k5HTE1tV9wUtnkZhjUZGeUw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
To:     Tao Ren <taoren@fb.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jul 2019 at 07:52, Tao Ren <taoren@fb.com> wrote:
>
> On 7/29/19 6:32 PM, Vladimir Oltean wrote:
> > Hi Tao,
> >
> > On Tue, 30 Jul 2019 at 03:31, Tao Ren <taoren@fb.com> wrote:
> >>
> >> Configure the BCM54616S for 1000Base-X mode when "brcm-phy-mode-1000bx=
"
> >> is set in device tree. This is needed when the PHY is used for fiber a=
nd
> >> backplane connections.
> >>
> >> The patch is inspired by commit cd9af3dac6d1 ("PHYLIB: Add 1000Base-X
> >> support for Broadcom bcm5482").
> >
> > As far as I can see, for the commit you referenced,
> > PHY_BCM_FLAGS_MODE_1000BX is referenced from nowhere in the entire
> > mainline kernel:
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__elixir.bootlin.c=
om_linux_latest_ident_PHY-5FBCM-5FFLAGS-5FMODE-5F1000BX&d=3DDwIBaQ&c=3D5VD0=
RTtNlTh3ycd41b3MUw&r=3DiYElT7HC77pRZ3byVvW8ng&m=3Dgy6Y-3Ylme-_GQcGF4fvOX10i=
rgAT4xh253Weo0np38&s=3DKL__E2bvsmvUL-hBL9hUmOS5vyPQ92EMj6fEfByn8t8&e=3D
> > (it is supposed to be put by the MAC driver in phydev->dev_flags prior
> > to calling phy_connect). But I don't see the point to this - can't you
> > check for phydev->interface =3D=3D PHY_INTERFACE_MODE_1000BASEX?
> > This has the advantage that no MAC driver will need to know that it's
> > talking to a Broadcom PHY. Additionally, no custom DT bindings are
> > needed.
> > Also, for backplane connections you probably want 1000Base-KX which
> > has its own AN/LT, not plain 1000Base-X.
>
> Thank you Vladimir for the quick review!
> Perhaps I misunderstood the purpose of phydev->interface, and I thought i=
t was usually used to defined the interface between MAC and PHY. For exampl=
e, if I need to pass both "rgmii-id" and "1000base-x" from MAC to PHY drive=
r, what would be the preferred way?
>

Ohhhhhh, now I understand what you're trying to do, sorry, somehow I
was too tired and I thought of something totally unrelated.
Let me see if I can explain: you've got the INTF_SEL pin strapping
configured for something else (like RGMII to copper mode) and then
you're changing the operating mode at runtime through MDIO? Is this
intended to be for production code, or is it just some quick hack to
fix a bad board design?
I think what's supposed to happen (Heiner can comment) is that
genphy_config_init will automatically read the out-of-reset PHY
registers and figure out which link modes are supported. This includes
the 1000Base-X media type, *if* the PHY is strapped correctly.
But you are changing the strapping configuration too late (again, in
.config_init), so phylib doesn't pick up the new Base-X modes. What
happens if you do the switchover from the .probe callback of the
driver, instead of .config_init?
I think what got me confused was your "add support for 1000Base-X"
commit message. If I understand correctly, you're not adding support,
you're just forcing it.
Again, I don't think Linux has generic support for overwriting (or
even describing) the operating mode of a PHY, although maybe that's a
direction we would want to push the discussion towards. RGMII to
copper, RGMII to fiber, SGMII to copper, copper to fiber (media
converter), even RGMII to SGMII (RTL8211FS supports this) - lots of
modes, and this is only for gigabit PHYs...

> >> Signed-off-by: Tao Ren <taoren@fb.com>
> >> ---
> >>  drivers/net/phy/broadcom.c | 58 +++++++++++++++++++++++++++++++++++--=
-
> >>  include/linux/brcmphy.h    |  4 +--
> >>  2 files changed, 56 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
> >> index 2b4e41a9d35a..6c22ac3a844b 100644
> >> --- a/drivers/net/phy/broadcom.c
> >> +++ b/drivers/net/phy/broadcom.c
> >> @@ -383,9 +383,9 @@ static int bcm5482_config_init(struct phy_device *=
phydev)
> >>                 /*
> >>                  * Select 1000BASE-X register set (primary SerDes)
> >>                  */
> >> -               reg =3D bcm_phy_read_shadow(phydev, BCM5482_SHD_MODE);
> >> -               bcm_phy_write_shadow(phydev, BCM5482_SHD_MODE,
> >> -                                    reg | BCM5482_SHD_MODE_1000BX);
> >> +               reg =3D bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
> >> +               bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE,
> >> +                                    reg | BCM54XX_SHD_MODE_1000BX);
> >>
> >>                 /*
> >>                  * LED1=3DACTIVITYLED, LED3=3DLINKSPD[2]
> >> @@ -451,6 +451,34 @@ static int bcm5481_config_aneg(struct phy_device =
*phydev)
> >>         return ret;
> >>  }
> >>
> >> +static int bcm54616s_config_init(struct phy_device *phydev)
> >> +{
> >> +       int err, reg;
> >> +       struct device_node *np =3D phydev->mdio.dev.of_node;
> >> +
> >> +       err =3D bcm54xx_config_init(phydev);
> >> +
> >> +       if (of_property_read_bool(np, "brcm-phy-mode-1000bx")) {
> >> +               /* Select 1000BASE-X register set. */
> >> +               reg =3D bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
> >> +               bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE,
> >> +                                    reg | BCM54XX_SHD_MODE_1000BX);
> >> +
> >> +               /* Auto-negotiation doesn't seem to work quite right
> >> +                * in this mode, so we disable it and force it to the
> >> +                * right speed/duplex setting.  Only 'link status'
> >> +                * is important.
> >> +                */
> >> +               phydev->autoneg =3D AUTONEG_DISABLE;
> >> +               phydev->speed =3D SPEED_1000;
> >> +               phydev->duplex =3D DUPLEX_FULL;
> >> +
> >
> > 1000Base-X AN does not include speed negotiation, so hardcoding
> > SPEED_1000 is probably correct.
> > What is wrong with the AN of duplex settings?
>
> FULL_DUPLEX bit is set on my platform by default. Let me enable AN and te=
st it out; will share you results tomorrow.
>
> >> +               phydev->dev_flags |=3D PHY_BCM_FLAGS_MODE_1000BX;
> >> +       }
> >> +
> >> +       return err;
> >> +}
> >> +
> >>  static int bcm54616s_config_aneg(struct phy_device *phydev)
> >>  {
> >>         int ret;
> >> @@ -464,6 +492,27 @@ static int bcm54616s_config_aneg(struct phy_devic=
e *phydev)
> >>         return ret;
> >>  }
> >>
> >> +static int bcm54616s_read_status(struct phy_device *phydev)
> >> +{
> >> +       int ret;
> >> +
> >> +       ret =3D genphy_read_status(phydev);
> >> +       if (ret < 0)
> >> +               return ret;
> >> +
> >> +       if (phydev->dev_flags & PHY_BCM_FLAGS_MODE_1000BX) {
> >> +               /* Only link status matters for 1000Base-X mode, so fo=
rce
> >> +                * 1000 Mbit/s full-duplex status.
> >> +                */
> >> +               if (phydev->link) {
> >> +                       phydev->speed =3D SPEED_1000;
> >> +                       phydev->duplex =3D DUPLEX_FULL;
> >> +               }
> >> +       }
> >> +
> >> +       return 0;
> >> +}
> >> +
> >>  static int brcm_phy_setbits(struct phy_device *phydev, int reg, int s=
et)
> >>  {
> >>         int val;
> >> @@ -651,8 +700,9 @@ static struct phy_driver broadcom_drivers[] =3D {
> >>         .phy_id_mask    =3D 0xfffffff0,
> >>         .name           =3D "Broadcom BCM54616S",
> >>         .features       =3D PHY_GBIT_FEATURES,
> >> -       .config_init    =3D bcm54xx_config_init,
> >> +       .config_init    =3D bcm54616s_config_init,
> >>         .config_aneg    =3D bcm54616s_config_aneg,
> >> +       .read_status    =3D bcm54616s_read_status,
> >>         .ack_interrupt  =3D bcm_phy_ack_intr,
> >>         .config_intr    =3D bcm_phy_config_intr,
> >>  }, {
> >> diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
> >> index 6db2d9a6e503..82030155558c 100644
> >> --- a/include/linux/brcmphy.h
> >> +++ b/include/linux/brcmphy.h
> >> @@ -200,8 +200,8 @@
> >>  #define BCM5482_SHD_SSD                0x14    /* 10100: Secondary Se=
rDes control */
> >>  #define BCM5482_SHD_SSD_LEDM   0x0008  /* SSD LED Mode enable */
> >>  #define BCM5482_SHD_SSD_EN     0x0001  /* SSD enable */
> >> -#define BCM5482_SHD_MODE       0x1f    /* 11111: Mode Control Registe=
r */
> >> -#define BCM5482_SHD_MODE_1000BX        0x0001  /* Enable 1000BASE-X r=
egisters */
> >> +#define BCM54XX_SHD_MODE       0x1f    /* 11111: Mode Control Registe=
r */
> >> +#define BCM54XX_SHD_MODE_1000BX        0x0001  /* Enable 1000BASE-X r=
egisters */
> >
> > These registers are also present on my BCM5464, probably safe to
> > assume they're generic for the entire family.
> > So if you make the registers definitions common, you can probably make
> > the 1000Base-X configuration common as well.
>
> If I understand correctly, your recommendation is to add a common functio=
n (such as "bcm54xx_config_1000bx") so it can be used by other BCM chips? S=
ure, I will take care of it.
>
>
> Thanks,
>
> Tao

Regards,
-Vladimir
