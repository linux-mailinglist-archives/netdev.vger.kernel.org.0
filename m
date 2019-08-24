Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DAA89BE74
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 17:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfHXPVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 11:21:47 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41584 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727684AbfHXPVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Aug 2019 11:21:47 -0400
Received: by mail-ed1-f68.google.com with SMTP id w5so18724170edl.8
        for <netdev@vger.kernel.org>; Sat, 24 Aug 2019 08:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IwpnK04ze76jMcdc6ODq/ZlKJqk3HqnnIaX7oeW+ozI=;
        b=tLs9CqY2SimKgDFtilnoGZ1FU4TrkjJcdow70g1ppHryzi+XS8W4+VitivrCzQ70w/
         8SwouK5ROrgU/ClNtoy+OVh6cUs+It34/0b9wPomX1DDdOtkHohZ79lvHu4CCmRYv1YA
         +shsg0fyhX6wSWHpT3aMPVPBNr00zxXANXWKyQEueXDvwWGcKdstiYO6bwYHHZrM5CTX
         YZ8JjgN2gnMqxFmBUqt3F9tgTLOqDBRv1BRxMzzN/5HlPBdrSntWGWYmY3YaEaOfuYMW
         ppD47jMPO+YvFYahz0Z22cAH6Dfq3shP73rTDyh2bNMbtJllCSmrbTrWnB2HtumkceXR
         27iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IwpnK04ze76jMcdc6ODq/ZlKJqk3HqnnIaX7oeW+ozI=;
        b=uh6yiNWjEN42b8S61XGr0M3ZNRWcfkGZN0qwDgtbVX2QDqXkIURtYwZvbCeOrNrPFl
         M3m2Bs/TCUlZeUoNCOdFbSUUgwvupe3wMT8WRh0t8bvJgKGMBduZJY07uZ6vKZ0k5oKV
         pWxS8cbZKo7c1++Boo8e1DyN1dy8Wp/6sKN1EgkN/ygDwgnVmAPUb3T2J45vNMTfLENW
         NdnWVHtZmdRknmkdu+I/wboZIH+CHvmeVzit0LP/vsW8aMH6lI2BymOyJY3ly8PvOwFe
         b2D56NKG92nksm8DA+HwZALom/s3XiabSKUKXNJHSRs86tBOhMrR5seHupztnqNsBTZl
         gZcw==
X-Gm-Message-State: APjAAAWhGpOYQxx2MC5CDkgQN+4Iutk7u9xnSDODwNmYbwI643JITaA4
        Tf1sjk3EOrzzqdlv8d2w5kXsfxVV+gcP8rPRWrI=
X-Google-Smtp-Source: APXvYqzW+ViSlIQRKp9VvoUTKClxfL5awptBhz6EIshs8KhSdrY3Lm0wC9+MVkwa6LEq0rfkbaLLhMmseIEeezK1ZVs=
X-Received: by 2002:a17:906:1484:: with SMTP id x4mr9135122ejc.204.1566660104596;
 Sat, 24 Aug 2019 08:21:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190723151702.14430-1-asolokha@kb.kras.ru> <20190723151702.14430-2-asolokha@kb.kras.ru>
 <CA+h21hpacLmKzoeKrdE-frZSTsiYCi4rKCObJ4LfAmfrCJ6H9g@mail.gmail.com> <87lfwfio13.fsf@eldim>
In-Reply-To: <87lfwfio13.fsf@eldim>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 24 Aug 2019 18:21:33 +0300
Message-ID: <CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] gianfar: convert to phylink
To:     Arseny Solokha <asolokha@kb.kras.ru>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arseny.

On Tue, 30 Jul 2019 at 17:40, Arseny Solokha <asolokha@kb.kras.ru> wrote:
>
> > Hi Arseny,
> >
> > Nice project!
>
> Vladimir, Russell, thanks for your review. I'm on vacation now, so won't =
fully
> address your comments in a few weeks: while I can build the code, I won't=
 have
> access to hardware to test.
>
> So it seems this patch will turn into a series where we'll have some clea=
nup
> patches preceding the actual conversion (and the latter will also contain=
 a
> documentation change in Documentation/devicetree/bindings/net/fsl-tsec-ph=
y.txt
> which I've overlooked in the first submission). I'll try to post trivial
> cleanups independently while still on vacation.
>

Yes, ideally the cleanup would be separate from the conversion.

>
> >> @@ -891,11 +912,21 @@ static int gfar_of_init(struct platform_device *=
ofdev, struct net_device **pdev)
> >>
> >>         err =3D of_property_read_string(np, "phy-connection-type", &ct=
ype);
> >>
> >> -       /* We only care about rgmii-id.  The rest are autodetected */
> >> -       if (err =3D=3D 0 && !strcmp(ctype, "rgmii-id"))
> >> -               priv->interface =3D PHY_INTERFACE_MODE_RGMII_ID;
> >> -       else
> >> +       /* We only care about rgmii-id and sgmii - the former
> >> +        * is indistinguishable from rgmii in hardware, and phylink ne=
eds
> >> +        * the latter to be set appropriately for correct phy configur=
ation.
> >> +        * The rest are autodetected
> >> +        */
> >> +       if (err =3D=3D 0) {
> >> +               if (!strcmp(ctype, "rgmii-id"))
> >> +                       priv->interface =3D PHY_INTERFACE_MODE_RGMII_I=
D;
> >> +               else if (!strcmp(ctype, "sgmii"))
> >> +                       priv->interface =3D PHY_INTERFACE_MODE_SGMII;
> >> +               else
> >> +                       priv->interface =3D PHY_INTERFACE_MODE_MII;
> >> +       } else {
> >>                 priv->interface =3D PHY_INTERFACE_MODE_MII;
> >> +       }
> >>
> >
> > No. Don't do this. Just do:
> >
> >     err =3D of_get_phy_mode(np);
> >     if (err < 0)
> >         goto err_grp_init;
> >
> >     priv->interface =3D err;
> >
> >>         if (of_find_property(np, "fsl,magic-packet", NULL))
> >>                 priv->device_flags |=3D FSL_GIANFAR_DEV_HAS_MAGIC_PACK=
ET;
> >> @@ -903,19 +934,21 @@ static int gfar_of_init(struct platform_device *=
ofdev, struct net_device **pdev)
> >>         if (of_get_property(np, "fsl,wake-on-filer", NULL))
> >>                 priv->device_flags |=3D FSL_GIANFAR_DEV_HAS_WAKE_ON_FI=
LER;
> >>
> >> -       priv->phy_node =3D of_parse_phandle(np, "phy-handle", 0);
> >> +       priv->device_node =3D np;
> >> +       priv->speed =3D SPEED_UNKNOWN;
> >>
> >> -       /* In the case of a fixed PHY, the DT node associated
> >> -        * to the PHY is the Ethernet MAC DT node.
> >> -        */
> >> -       if (!priv->phy_node && of_phy_is_fixed_link(np)) {
> >> -               err =3D of_phy_register_fixed_link(np);
> >> -               if (err)
> >> -                       goto err_grp_init;
> >> +       priv->phylink_config.dev =3D &priv->ndev->dev;
> >> +       priv->phylink_config.type =3D PHYLINK_NETDEV;
> >>
> >> -               priv->phy_node =3D of_node_get(np);
> >> +       phylink =3D phylink_create(&priv->phylink_config, of_fwnode_ha=
ndle(np),
> >> +                                priv->interface, &gfar_phylink_ops);
> >
> > You introduced a bug here.
> > of_phy_connect used to take the PHY interface type (for good or bad)
> > from gfar_get_interface() (which is reconstructing it from the MAC
> > registers).
> > You are now passing the PHY interface type to phylink_create from the
> > "phy-connection-type" DT property.
> > At the very least, you are breaking LS1021A which uses phy-mode
> > instead of phy-connection-type (hence my comment above to use the
> > generic OF helper).
> > Actually I think you just uncovered a latent bug, in that the DT
> > bindings for phy-mode didn't mean much at all to the driver - it would
> > rely on what the bootloader had set up.
> > Actually DT bindings for phy-connection-type were most likely simply
> > bolt on on top of gianfar when they figured they couldn't just
> > auto-detect the various species of required RGMII delays.
> > But gfar_get_interface is a piece of history that was introduced in
> > the same commit as the enum phy_interface_t itself: e8a2b6a42073
> > ("[PATCH] PHY: Add support for configuring the PHY connection
> > interface"). Its time has come.
>
> <=E2=80=A6>
>
> >>         }
> >>
> >> +       priv->tbi_phy =3D NULL;
> >> +       interface =3D gfar_get_interface(dev);
> >
> > Be consistent and just go for priv->interface. Nobody's changing it any=
way.
>
> So if I get you right, I'm supposed to drop gfar_get_interface() and rely=
 on DT
> bindings entirely?
>

Oof, I checked arch/powerpc/boot/dts/fsl and the following boards
using the gianfar driver are guilty of populating phy-handle but not
phy-connection-type:
mpc8540ads
mpc8541cds
mpc8548cds_32b
mpc8548cds_36b
mpc8555cds
mpc8560ads
mpc8568mds
ppa8548

I think a sane logic for populating priv->interface would be:
- Attempt of_get_phy_mode
- If phy-mode or phy-connection-type properties are not found, revert
to gfar_get_interface for the legacy blobs above.

>
> >> @@ -3387,23 +3384,6 @@ static irqreturn_t gfar_interrupt(int irq, void=
 *grp_id)
> >>         return IRQ_HANDLED;
> >>  }
> >>
> >> -/* Called every time the controller might need to be made
> >> - * aware of new link state.  The PHY code conveys this
> >> - * information through variables in the phydev structure, and this
> >> - * function converts those variables into the appropriate
> >> - * register values, and can bring down the device if needed.
> >> - */
> >> -static void adjust_link(struct net_device *dev)
> >> -{
> >> -       struct gfar_private *priv =3D netdev_priv(dev);
> >> -       struct phy_device *phydev =3D dev->phydev;
> >> -
> >> -       if (unlikely(phydev->link !=3D priv->oldlink ||
> >> -                    (phydev->link && (phydev->duplex !=3D priv->olddu=
plex ||
> >> -                                      phydev->speed !=3D priv->oldspe=
ed))))
> >> -               gfar_update_link_state(priv);
> >> -}
> >
> > Getting rid of the cruft from this function deserves its own patch.
>
> How am I supposed to remove it without breaking the PHYLIB-based driver? =
Or do
> you mean making it call gfar_update_link_state() just before the conversi=
on
> which will then remove adjust_link() altogether?
>

I don't know, if you can't refactor without breaking anything then ok.

>
> >>
> >>         if (unlikely(test_bit(GFAR_RESETTING, &priv->state)))
> >>                 return;
> >>
> >> -       if (phydev->link) {
> >> -               u32 tempval1 =3D gfar_read(&regs->maccfg1);
> >> -               u32 tempval =3D gfar_read(&regs->maccfg2);
> >> -               u32 ecntrl =3D gfar_read(&regs->ecntrl);
> >> -               u32 tx_flow_oldval =3D (tempval1 & MACCFG1_TX_FLOW);
> >> +       if (unlikely(phylink_autoneg_inband(mode)))
> >> +               return;
> >>
> >> -               if (phydev->duplex !=3D priv->oldduplex) {
> >> -                       if (!(phydev->duplex))
> >> -                               tempval &=3D ~(MACCFG2_FULL_DUPLEX);
> >> -                       else
> >> -                               tempval |=3D MACCFG2_FULL_DUPLEX;
> >> +       maccfg1 =3D gfar_read(&regs->maccfg1);
> >> +       maccfg2 =3D gfar_read(&regs->maccfg2);
> >> +       ecntrl =3D gfar_read(&regs->ecntrl);
> >>
> >> -                       priv->oldduplex =3D phydev->duplex;
> >> -               }
> >> +       new_maccfg2 =3D maccfg2 & ~(MACCFG2_FULL_DUPLEX | MACCFG2_IF);
> >> +       new_ecntrl =3D ecntrl & ~ECNTRL_R100;
> >>
> >> -               if (phydev->speed !=3D priv->oldspeed) {
> >> -                       switch (phydev->speed) {
> >> -                       case 1000:
> >> -                               tempval =3D
> >> -                                   ((tempval & ~(MACCFG2_IF)) | MACCF=
G2_GMII);
> >> +       if (state->duplex)
> >> +               new_maccfg2 |=3D MACCFG2_FULL_DUPLEX;
> >>
> >> -                               ecntrl &=3D ~(ECNTRL_R100);
> >> -                               break;
> >> -                       case 100:
> >> -                       case 10:
> >> -                               tempval =3D
> >> -                                   ((tempval & ~(MACCFG2_IF)) | MACCF=
G2_MII);
> >> -
> >> -                               /* Reduced mode distinguishes
> >> -                                * between 10 and 100
> >> -                                */
> >> -                               if (phydev->speed =3D=3D SPEED_100)
> >> -                                       ecntrl |=3D ECNTRL_R100;
> >> -                               else
> >> -                                       ecntrl &=3D ~(ECNTRL_R100);
> >> -                               break;
> >> -                       default:
> >> -                               netif_warn(priv, link, priv->ndev,
> >> -                                          "Ack!  Speed (%d) is not 10=
/100/1000!\n",
> >> -                                          phydev->speed);
> >
> > Please 1. remove "Ack!" 2. treat SPEED_UNKNOWN here by setting the MAC
> > into a low-power state (e.g. 10 Mbps - the power savings are real).
> > Don't print that Speed -1 is not 10/100/1000, we know that.
>
> In my first conversion attempt I see "Ack!" when changing link speed on w=
hen
> shutting it down, so switching to 10 Mbps doesn't seem right for me=E2=80=
=94hence early
> return in this case. Maybe I'm doing something wrong here.
>

When mac_config calls with SPEED_UNKNOWN, the link is down, and you
can put the MAC in the lowest energy state it can go to (10 Mbps, in
this case). Or so I've been told. Maybe Russell can chime in. Anyway,
you don't need to print anything, there's lots of prints from PHYLINK
already.

>
> >> diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/driver=
s/net/ethernet/freescale/gianfar_ethtool.c
> >> index 3433b46b90c1..146b30d07789 100644
> >> --- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
> >> +++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
> >> @@ -35,7 +35,7 @@
> >>  #include <asm/types.h>
> >>  #include <linux/ethtool.h>
> >>  #include <linux/mii.h>
> >> -#include <linux/phy.h>
> >> +#include <linux/phylink.h>
> >>  #include <linux/sort.h>
> >>  #include <linux/if_vlan.h>
> >>  #include <linux/of_platform.h>
> >> @@ -207,12 +207,10 @@ static void gfar_get_regs(struct net_device *dev=
, struct ethtool_regs *regs,
> >>  static unsigned int gfar_usecs2ticks(struct gfar_private *priv,
> >>                                      unsigned int usecs)
> >>  {
> >> -       struct net_device *ndev =3D priv->ndev;
> >> -       struct phy_device *phydev =3D ndev->phydev;
> >
> > Are you sure this still works? You missed a ndev->phydev check from
> > gfar_gcoalesce, where this is called from. Technically you can still
> > check ndev->phydev, it's just that PHYLINK doesn't guarantee you'll
> > have one (e.g. fixed-link interfaces).
>
> It still works for RGMII PHYs, SGMII and 1000Base-X in my testing. I didn=
't
> check it with fixed-link, though.
>
>
> >> @@ -1519,6 +1472,24 @@ static int gfar_get_ts_info(struct net_device *=
dev,
> >>         return 0;
> >>  }
> >>
> >> +/* Set link ksettings (phy address, speed) for ethtools */
> >
> > ethtool, not ethtools. Also, I'm not quite sure what you mean by
> > setting the "phy address" with ethtool.
>
> Well, I know where I've copied it from=E2=80=A6 Thanks for pointing it ou=
t.

Regards,
-Vladimir
