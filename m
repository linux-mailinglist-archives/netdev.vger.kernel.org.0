Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71F7E8F77D
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 01:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387676AbfHOXPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 19:15:31 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35946 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731810AbfHOXPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 19:15:31 -0400
Received: by mail-ed1-f65.google.com with SMTP id p28so3598622edi.3;
        Thu, 15 Aug 2019 16:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YlE34G3kQuj5+jZiXSzKZatzaIh4Rjcw5uEtH8Rdjw8=;
        b=EvL+/9N4p0XYQftxPqT0s9XdqZOyuE8dOtYuXcJr6sLGobcsg5w4gvlYQy6NiQSaFJ
         QOAqlgk2ULc3zt+jFSpmJSjQ1FjoKJ9TMx98Nmzsvqt7Cm8jcE5Oe4oK3Q3UceGQPMtp
         iVeOCqTFGG2/rAAlQqhih70qqdoRRjb5TwBy2+mp7ipBoALI4K41Sc/6W1aslujvAHHk
         J5Ha5ofdDQoKUTrUmEHhszsPE+12BltSTXjqZMnKXX4932qA0bjMxRbrfZYBLRzFhSNc
         7PpHJ4GkN4nmivbwcXfU3HRhrlqbrcHJqG/sH3h0FSI81gGCHC1fpXHu7JaanncWnFc+
         /6NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YlE34G3kQuj5+jZiXSzKZatzaIh4Rjcw5uEtH8Rdjw8=;
        b=p/COxgRm4wqRIpbz2RW3nlWWpCDxsSD79KvcgqPXuPWxwDMW4q+kDp2ZeQp5ZBP2UT
         rpnEnwc4XvWAfxX3YoYLZQYtDOgLMbvUJYTyOJJgxcmWzX037OTpQ1IcS4a8JDRDrzmT
         UL06WhrZCdMDmj9ZNqInHvPAHJztG0UNXSYGGW/ti4vWXIEqyQHGQryFKiwPjPqAWoiL
         ErGPb9NgB97AmJpLKZL63VKWTsggjbSWTiPN2sfv7zAz4RRb/P7Lff8VMuuMtgApi9WY
         x25PosGvPnyn00y3UQ5SL2Ocsv9HZ/nuKNfG/oiqucEsUE2KpcpMPjcPCkd005O6PJ/z
         o8zg==
X-Gm-Message-State: APjAAAXhih0O4QrsHoIJ54unxBfx50arJyXnPenzQ0jveJ9TYVFC+6iA
        Kgg5UUZT3yksZHb/KDGmhPG/UFGfl6qxqM68ID8=
X-Google-Smtp-Source: APXvYqzw+DZxHwd3wNMl4NNcAjzsJb9REBjS4vWovXXMjsQRNlm3q1k7UDM0FSvjnDDNbxz/SQPEqezh9O7ktLNu1IM=
X-Received: by 2002:a05:6402:1285:: with SMTP id w5mr8106386edv.36.1565910928546;
 Thu, 15 Aug 2019 16:15:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190811234016.3674056-1-taoren@fb.com> <fee3faa1-2de1-b480-983e-07f4587f2f79@fb.com>
In-Reply-To: <fee3faa1-2de1-b480-983e-07f4587f2f79@fb.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 16 Aug 2019 02:15:17 +0300
Message-ID: <CA+h21hr-uiCAQTXerg8ScKhnVhT15pM70m_Jw_f=gZrt1DCRkw@mail.gmail.com>
Subject: Re: [PATCH net-next v7 3/3] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
To:     Tao Ren <taoren@fb.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tao,

On Fri, 16 Aug 2019 at 02:13, Tao Ren <taoren@fb.com> wrote:
>
> Hi Andrew / Florian / Heiner / Vladimir,
>
> Any further suggestions on the patch series?
>
>
> Thanks,
>
> Tao
>
> On 8/11/19 4:40 PM, Tao Ren wrote:
> > The BCM54616S PHY cannot work properly in RGMII->1000Base-X mode, mainly
> > because genphy functions are designed for copper links, and 1000Base-X
> > (clause 37) auto negotiation needs to be handled differently.
> >
> > This patch enables 1000Base-X support for BCM54616S by customizing 3
> > driver callbacks, and it's verified to be working on Facebook CMM BMC
> > platform (RGMII->1000Base-KX):
> >
> >   - probe: probe callback detects PHY's operation mode based on
> >     INTERF_SEL[1:0] pins and 1000X/100FX selection bit in SerDES 100-FX
> >     Control register.
> >
> >   - config_aneg: calls genphy_c37_config_aneg when the PHY is running in
> >     1000Base-X mode; otherwise, genphy_config_aneg will be called.
> >
> >   - read_status: calls genphy_c37_read_status when the PHY is running in
> >     1000Base-X mode; otherwise, genphy_read_status will be called.
> >
> > Note: BCM54616S PHY can also be configured in RGMII->100Base-FX mode, and
> > 100Base-FX support is not available as of now.
> >
> > Signed-off-by: Tao Ren <taoren@fb.com>
> > ---

The patchset looks good to me. However I am not a maintainer.
If it helps,

Acked-by: Vladimir Oltean <olteanv@gmail.com>

> >  Changes in v7:
> >   - Add comment "BCM54616S 100Base-FX is not supported".
> >  Changes in v6:
> >   - nothing changed.
> >  Changes in v5:
> >   - include Heiner's patch "net: phy: add support for clause 37
> >     auto-negotiation" into the series.
> >   - use genphy_c37_config_aneg and genphy_c37_read_status in BCM54616S
> >     PHY driver's callback when the PHY is running in 1000Base-X mode.
> >  Changes in v4:
> >   - add bcm54616s_config_aneg_1000bx() to deal with auto negotiation in
> >     1000Base-X mode.
> >  Changes in v3:
> >   - rename bcm5482_read_status to bcm54xx_read_status so the callback can
> >     be shared by BCM5482 and BCM54616S.
> >  Changes in v2:
> >   - Auto-detect PHY operation mode instead of passing DT node.
> >   - move PHY mode auto-detect logic from config_init to probe callback.
> >   - only set speed (not including duplex) in read_status callback.
> >   - update patch description with more background to avoid confusion.
> >   - patch #1 in the series ("net: phy: broadcom: set features explicitly
> >     for BCM54616") is dropped.
> >
> >  drivers/net/phy/broadcom.c | 57 +++++++++++++++++++++++++++++++++++---
> >  include/linux/brcmphy.h    | 10 +++++--
> >  2 files changed, 61 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
> > index 937d0059e8ac..5fd9293513d8 100644
> > --- a/drivers/net/phy/broadcom.c
> > +++ b/drivers/net/phy/broadcom.c
> > @@ -383,9 +383,9 @@ static int bcm5482_config_init(struct phy_device *phydev)
> >               /*
> >                * Select 1000BASE-X register set (primary SerDes)
> >                */
> > -             reg = bcm_phy_read_shadow(phydev, BCM5482_SHD_MODE);
> > -             bcm_phy_write_shadow(phydev, BCM5482_SHD_MODE,
> > -                                  reg | BCM5482_SHD_MODE_1000BX);
> > +             reg = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
> > +             bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE,
> > +                                  reg | BCM54XX_SHD_MODE_1000BX);
> >
> >               /*
> >                * LED1=ACTIVITYLED, LED3=LINKSPD[2]
> > @@ -451,12 +451,47 @@ static int bcm5481_config_aneg(struct phy_device *phydev)
> >       return ret;
> >  }
> >
> > +static int bcm54616s_probe(struct phy_device *phydev)
> > +{
> > +     int val, intf_sel;
> > +
> > +     val = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
> > +     if (val < 0)
> > +             return val;
> > +
> > +     /* The PHY is strapped in RGMII-fiber mode when INTERF_SEL[1:0]
> > +      * is 01b, and the link between PHY and its link partner can be
> > +      * either 1000Base-X or 100Base-FX.
> > +      * RGMII-1000Base-X is properly supported, but RGMII-100Base-FX
> > +      * support is still missing as of now.
> > +      */
> > +     intf_sel = (val & BCM54XX_SHD_INTF_SEL_MASK) >> 1;
> > +     if (intf_sel == 1) {
> > +             val = bcm_phy_read_shadow(phydev, BCM54616S_SHD_100FX_CTRL);
> > +             if (val < 0)
> > +                     return val;
> > +
> > +             /* Bit 0 of the SerDes 100-FX Control register, when set
> > +              * to 1, sets the MII/RGMII -> 100BASE-FX configuration.
> > +              * When this bit is set to 0, it sets the GMII/RGMII ->
> > +              * 1000BASE-X configuration.
> > +              */
> > +             if (!(val & BCM54616S_100FX_MODE))
> > +                     phydev->dev_flags |= PHY_BCM_FLAGS_MODE_1000BX;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  static int bcm54616s_config_aneg(struct phy_device *phydev)
> >  {
> >       int ret;
> >
> >       /* Aneg firsly. */
> > -     ret = genphy_config_aneg(phydev);
> > +     if (phydev->dev_flags & PHY_BCM_FLAGS_MODE_1000BX)
> > +             ret = genphy_c37_config_aneg(phydev);
> > +     else
> > +             ret = genphy_config_aneg(phydev);
> >
> >       /* Then we can set up the delay. */
> >       bcm54xx_config_clock_delay(phydev);
> > @@ -464,6 +499,18 @@ static int bcm54616s_config_aneg(struct phy_device *phydev)
> >       return ret;
> >  }
> >
> > +static int bcm54616s_read_status(struct phy_device *phydev)
> > +{
> > +     int err;
> > +
> > +     if (phydev->dev_flags & PHY_BCM_FLAGS_MODE_1000BX)
> > +             err = genphy_c37_read_status(phydev);
> > +     else
> > +             err = genphy_read_status(phydev);
> > +
> > +     return err;
> > +}
> > +
> >  static int brcm_phy_setbits(struct phy_device *phydev, int reg, int set)
> >  {
> >       int val;
> > @@ -655,6 +702,8 @@ static struct phy_driver broadcom_drivers[] = {
> >       .config_aneg    = bcm54616s_config_aneg,
> >       .ack_interrupt  = bcm_phy_ack_intr,
> >       .config_intr    = bcm_phy_config_intr,
> > +     .read_status    = bcm54616s_read_status,
> > +     .probe          = bcm54616s_probe,
> >  }, {
> >       .phy_id         = PHY_ID_BCM5464,
> >       .phy_id_mask    = 0xfffffff0,
> > diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
> > index 6db2d9a6e503..b475e7f20d28 100644
> > --- a/include/linux/brcmphy.h
> > +++ b/include/linux/brcmphy.h
> > @@ -200,9 +200,15 @@
> >  #define BCM5482_SHD_SSD              0x14    /* 10100: Secondary SerDes control */
> >  #define BCM5482_SHD_SSD_LEDM 0x0008  /* SSD LED Mode enable */
> >  #define BCM5482_SHD_SSD_EN   0x0001  /* SSD enable */
> > -#define BCM5482_SHD_MODE     0x1f    /* 11111: Mode Control Register */
> > -#define BCM5482_SHD_MODE_1000BX      0x0001  /* Enable 1000BASE-X registers */
> >
> > +/* 10011: SerDes 100-FX Control Register */
> > +#define BCM54616S_SHD_100FX_CTRL     0x13
> > +#define      BCM54616S_100FX_MODE            BIT(0)  /* 100-FX SerDes Enable */
> > +
> > +/* 11111: Mode Control Register */
> > +#define BCM54XX_SHD_MODE             0x1f
> > +#define BCM54XX_SHD_INTF_SEL_MASK    GENMASK(2, 1)   /* INTERF_SEL[1:0] */
> > +#define BCM54XX_SHD_MODE_1000BX              BIT(0)  /* Enable 1000-X registers */
> >
> >  /*
> >   * EXPANSION SHADOW ACCESS REGISTERS.  (PHY REG 0x15, 0x16, and 0x17)
> >

Regards,
-Vladimir
