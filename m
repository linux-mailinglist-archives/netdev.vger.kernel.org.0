Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63052DF640
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 18:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbgLTRJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 12:09:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgLTRJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Dec 2020 12:09:16 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109C0C061282
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 09:08:33 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id g24so5103027qtq.12
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 09:08:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=d6i41u5qop6J0rX2ZasNEBHniIXG6ZeMKP3xoQK5BJ8=;
        b=nBUxAD/kRdvEfbBp/+hN1RFOn/KFysq1z/ULZRimWX1X9UeZFthEF6P2hMwKGNqxiD
         Aw+24W/8JeMAuWmYlsQgQA7lGfrjJLEIy255kWPmT4uhBZTjlXzgjsj2bWN1qzRx763/
         mTwdNMKPGBtOnj5wCh5OOmNU1KPtTAynPeNO8fYmEpOOx7h4KyqlKXUUQuxpDRz8l5UT
         ruVkrpi8qXk80O4NLX8L4ndv5xRYQDTiXAvj60/BiRKVDZhdB41u7IYNHL+reT/b5pC5
         T7K4bp92UOLJUrbM/53illdgHPIzaiI2sBb4y3ZxiYqtkgGhfbKv8lF1Lc8Dw9PFoujJ
         3Ifw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=d6i41u5qop6J0rX2ZasNEBHniIXG6ZeMKP3xoQK5BJ8=;
        b=bGUAIxboSFgdf8C+sHHEUvJYvexsYKYIzVSCB0ozdaGk4yioov6f5xmILTqQKkN3QY
         03dlE6tl5zVw4aJXPqRrVZgM9E/C5ouDfd55F/Jr4wg+obo3R4cmUM8v3lL8AC7v+1fJ
         it8uuMg2XWYx6IUqd51FdEfzO8a6SeUkvLR9MN/2v6qSy5OKnCJ0Vtl+w3ctJ489zf6m
         QaeiiQJudTtzvpQzJ/1j7Bt2F3mo6S3yEdd5JRN5zaAzvc1qt4Ggl+vllH9EuRUkevuJ
         loPaHdP8SowlTOGWD5SkayIRcSeZts9qjlnwPscKvE7PDwzuBhSLX/3bFE66WtccT1jo
         KdRw==
X-Gm-Message-State: AOAM532fxkWXusFElLYrhSHwZNJqIJ63IJgTiA2DCYkbcaV4HAtYSz+S
        KgfdJt1Q4A0LLHiNvYKoxoR1Sr0UDJe5UlGtPviCqg==
X-Google-Smtp-Source: ABdhPJwq8QvrsHxwVJG96yMLoqevjil3F37xVgVWMOQ9OPAHjvvt4xFZtyIpEmnmf4ioQWEEK1LJy/0zG9xEQaBeR3s=
X-Received: by 2002:a05:622a:18d:: with SMTP id s13mr13535142qtw.306.1608484111850;
 Sun, 20 Dec 2020 09:08:31 -0800 (PST)
MIME-Version: 1.0
References: <20200620092047.GR1551@shell.armlinux.org.uk> <E1jmZgq-0001UG-1c@rmk-PC.armlinux.org.uk>
 <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
 <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com>
 <20201102180326.GA2416734@kroah.com> <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
 <20201208133532.GH643756@sasha-vm> <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
 <X9CuTjdgD3tDKWwo@kroah.com> <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
In-Reply-To: <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Sun, 20 Dec 2020 18:08:19 +0100
Message-ID: <CAPv3WKfCfECmwjtXLAMbNe-vuGkws_icoQ+MrgJhZJqFcgGDyw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port() helper
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

czw., 10 gru 2020 o 15:35 Marcin Wojtas <mw@semihalf.com> napisa=C5=82(a):
>
> Hi Greg,
>
> =C5=9Br., 9 gru 2020 o 11:59 Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> napisa=C5=82(a):
> >
> > On Tue, Dec 08, 2020 at 04:02:50PM +0100, Marcin Wojtas wrote:
> > > Hi Sasha,
> > >
> > > wt., 8 gru 2020 o 14:35 Sasha Levin <sashal@kernel.org> napisa=C5=82(=
a):
> > > >
> > > > On Tue, Dec 08, 2020 at 01:03:38PM +0100, Marcin Wojtas wrote:
> > > > >Hi Greg,
> > > > >
> > > > >Apologies for delayed response:.
> > > > >
> > > > >
> > > > >pon., 2 lis 2020 o 19:02 Greg Kroah-Hartman
> > > > ><gregkh@linuxfoundation.org> napisa=C5=82(a):
> > > > >>
> > > > >> On Mon, Nov 02, 2020 at 06:38:54PM +0100, Marcin Wojtas wrote:
> > > > >> > Hi Greg and Sasha,
> > > > >> >
> > > > >> > pt., 9 pa=C5=BA 2020 o 05:43 Marcin Wojtas <mw@semihalf.com> n=
apisa=C5=82(a):
> > > > >> > >
> > > > >> > > Hi,
> > > > >> > >
> > > > >> > > sob., 20 cze 2020 o 11:21 Russell King <rmk+kernel@armlinux.=
org.uk> napisa=C5=82(a):
> > > > >> > > >
> > > > >> > > > Add a helper to convert the struct phylink_config pointer =
passed in
> > > > >> > > > from phylink to the drivers internal struct mvpp2_port.
> > > > >> > > >
> > > > >> > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > > >> > > > ---
> > > > >> > > >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 29 ++++++=
+++----------
> > > > >> > > >  1 file changed, 14 insertions(+), 15 deletions(-)
> > > > >> > > >
> > > > >> > > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main=
.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > >> > > > index 7653277d03b7..313f5a60a605 100644
> > > > >> > > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > >> > > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > > >> > > > @@ -4767,12 +4767,16 @@ static void mvpp2_port_copy_mac_ad=
dr(struct net_device *dev, struct mvpp2 *priv,
> > > > >> > > >         eth_hw_addr_random(dev);
> > > > >> > > >  }
> > > > >> > > >
> > > > >> > > > +static struct mvpp2_port *mvpp2_phylink_to_port(struct ph=
ylink_config *config)
> > > > >> > > > +{
> > > > >> > > > +       return container_of(config, struct mvpp2_port, phy=
link_config);
> > > > >> > > > +}
> > > > >> > > > +
> > > > >> > > >  static void mvpp2_phylink_validate(struct phylink_config =
*config,
> > > > >> > > >                                    unsigned long *supporte=
d,
> > > > >> > > >                                    struct phylink_link_sta=
te *state)
> > > > >> > > >  {
> > > > >> > > > -       struct mvpp2_port *port =3D container_of(config, s=
truct mvpp2_port,
> > > > >> > > > -                                              phylink_con=
fig);
> > > > >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(=
config);
> > > > >> > > >         __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> > > > >> > > >
> > > > >> > > >         /* Invalid combinations */
> > > > >> > > > @@ -4913,8 +4917,7 @@ static void mvpp2_gmac_pcs_get_state=
(struct mvpp2_port *port,
> > > > >> > > >  static void mvpp2_phylink_mac_pcs_get_state(struct phylin=
k_config *config,
> > > > >> > > >                                             struct phylink=
_link_state *state)
> > > > >> > > >  {
> > > > >> > > > -       struct mvpp2_port *port =3D container_of(config, s=
truct mvpp2_port,
> > > > >> > > > -                                              phylink_con=
fig);
> > > > >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(=
config);
> > > > >> > > >
> > > > >> > > >         if (port->priv->hw_version =3D=3D MVPP22 && port->=
gop_id =3D=3D 0) {
> > > > >> > > >                 u32 mode =3D readl(port->base + MVPP22_XLG=
_CTRL3_REG);
> > > > >> > > > @@ -4931,8 +4934,7 @@ static void mvpp2_phylink_mac_pcs_ge=
t_state(struct phylink_config *config,
> > > > >> > > >
> > > > >> > > >  static void mvpp2_mac_an_restart(struct phylink_config *c=
onfig)
> > > > >> > > >  {
> > > > >> > > > -       struct mvpp2_port *port =3D container_of(config, s=
truct mvpp2_port,
> > > > >> > > > -                                              phylink_con=
fig);
> > > > >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(=
config);
> > > > >> > > >         u32 val =3D readl(port->base + MVPP2_GMAC_AUTONEG_=
CONFIG);
> > > > >> > > >
> > > > >> > > >         writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
> > > > >> > > > @@ -5105,13 +5107,12 @@ static void mvpp2_gmac_config(stru=
ct mvpp2_port *port, unsigned int mode,
> > > > >> > > >  static void mvpp2_mac_config(struct phylink_config *confi=
g, unsigned int mode,
> > > > >> > > >                              const struct phylink_link_sta=
te *state)
> > > > >> > > >  {
> > > > >> > > > -       struct net_device *dev =3D to_net_dev(config->dev)=
;
> > > > >> > > > -       struct mvpp2_port *port =3D netdev_priv(dev);
> > > > >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(=
config);
> > > > >> > > >         bool change_interface =3D port->phy_interface !=3D=
 state->interface;
> > > > >> > > >
> > > > >> > > >         /* Check for invalid configuration */
> > > > >> > > >         if (mvpp2_is_xlg(state->interface) && port->gop_id=
 !=3D 0) {
> > > > >> > > > -               netdev_err(dev, "Invalid mode on %s\n", de=
v->name);
> > > > >> > > > +               netdev_err(port->dev, "Invalid mode on %s\=
n", port->dev->name);
> > > > >> > > >                 return;
> > > > >> > > >         }
> > > > >> > > >
> > > > >> > > > @@ -5151,8 +5152,7 @@ static void mvpp2_mac_link_up(struct=
 phylink_config *config,
> > > > >> > > >                               int speed, int duplex,
> > > > >> > > >                               bool tx_pause, bool rx_pause=
)
> > > > >> > > >  {
> > > > >> > > > -       struct net_device *dev =3D to_net_dev(config->dev)=
;
> > > > >> > > > -       struct mvpp2_port *port =3D netdev_priv(dev);
> > > > >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(=
config);
> > > > >> > > >         u32 val;
> > > > >> > > >
> > > > >> > > >         if (mvpp2_is_xlg(interface)) {
> > > > >> > > > @@ -5199,14 +5199,13 @@ static void mvpp2_mac_link_up(stru=
ct phylink_config *config,
> > > > >> > > >
> > > > >> > > >         mvpp2_egress_enable(port);
> > > > >> > > >         mvpp2_ingress_enable(port);
> > > > >> > > > -       netif_tx_wake_all_queues(dev);
> > > > >> > > > +       netif_tx_wake_all_queues(port->dev);
> > > > >> > > >  }
> > > > >> > > >
> > > > >> > > >  static void mvpp2_mac_link_down(struct phylink_config *co=
nfig,
> > > > >> > > >                                 unsigned int mode, phy_int=
erface_t interface)
> > > > >> > > >  {
> > > > >> > > > -       struct net_device *dev =3D to_net_dev(config->dev)=
;
> > > > >> > > > -       struct mvpp2_port *port =3D netdev_priv(dev);
> > > > >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(=
config);
> > > > >> > > >         u32 val;
> > > > >> > > >
> > > > >> > > >         if (!phylink_autoneg_inband(mode)) {
> > > > >> > > > @@ -5223,7 +5222,7 @@ static void mvpp2_mac_link_down(stru=
ct phylink_config *config,
> > > > >> > > >                 }
> > > > >> > > >         }
> > > > >> > > >
> > > > >> > > > -       netif_tx_stop_all_queues(dev);
> > > > >> > > > +       netif_tx_stop_all_queues(port->dev);
> > > > >> > > >         mvpp2_egress_disable(port);
> > > > >> > > >         mvpp2_ingress_disable(port);
> > > > >> > > >
> > > > >> > > > --
> > > > >> > > > 2.20.1
> > > > >> > > >
> > > > >> > >
> > > > >> > > This patch fixes a regression that was introduced in v5.3:
> > > > >> > > Commit 44cc27e43fa3 ("net: phylink: Add struct phylink_confi=
g to PHYLINK API")
> > > > >> > >
> > > > >> > > Above results in a NULL pointer dereference when booting the
> > > > >> > > Armada7k8k/CN913x with ACPI between 5.3 and 5.8, which will =
be
> > > > >> > > problematic especially for the distros using LTSv5.4 and abo=
ve (the
> > > > >> > > issue was reported on Fedora 32).
> > > > >> > >
> > > > >> > > Please help with backporting to the stable v5.3+ branches (i=
t applies
> > > > >> > > smoothly on v5.4/v5.6/v5.8).
> > > > >> > >
> > > > >> >
> > > > >> > Any chances to backport this patch to relevant v5.3+ stable br=
anches?
> > > > >>
> > > > >> What patch?  What git commit id needs to be backported?
> > > > >>
> > > > >
> > > > >The actual patch is:
> > > > >Commit 6c2b49eb9671  ("net: mvpp2: add mvpp2_phylink_to_port() hel=
per").
> > > > >
> > > > >URL for reference:
> > > > >https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git=
/commit/drivers/net/ethernet/marvell/mvpp2?h=3Dv5.10-rc7&id=3D6c2b49eb96716=
e91f202756bfbd3f5fea3b2b172
> > > > >
> > > > >Do you think it would be possible to get it merged to v5.3+ stable=
 branches?
> > > >
> > > > Could you explain how that patch fixes anything? It reads like a
> > > > cleanup.
> > > >
> > >
> > > Indeed, I am aware of it, but I'm not sure about the best way to fix
> > > it. In fact the mentioned patch is an unintentional fix. Commit
> > > 44cc27e43fa3 ("net: phylink: Add struct phylink_config to PHYLINK
> > > API") reworked an argument list of mvpp2_mac_config() routine in a wa=
y
> > > that resulted in a NULL pointer dereference when booting the
> > > Armada7k8k/CN913x with ACPI between 5.3 and 5.8. Part of Russell's
> > > patch resolves this issue.
> >
> > What part fixes the issue?  I can't see it...
> >
>
> I re-checked in my setup and here's the smallest part of the original
> patch, that fixes previously described issue:
> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index e98be8372780..9d71a4fe1750 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -4767,6 +4767,11 @@ static void mvpp2_port_copy_mac_addr(struct
> net_device *dev, struct mvpp2 *priv,
>         eth_hw_addr_random(dev);
>  }
>
> +static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config *c=
onfig)
> +{
> +       return container_of(config, struct mvpp2_port, phylink_config);
> +}
> +
>  static void mvpp2_phylink_validate(struct phylink_config *config,
>                                    unsigned long *supported,
>                                    struct phylink_link_state *state)
> @@ -5105,13 +5110,12 @@ static void mvpp2_gmac_config(struct
> mvpp2_port *port, unsigned int mode,
>  static void mvpp2_mac_config(struct phylink_config *config, unsigned int=
 mode,
>                              const struct phylink_link_state *state)
>  {
> -       struct net_device *dev =3D to_net_dev(config->dev);
> -       struct mvpp2_port *port =3D netdev_priv(dev);
> +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
>         bool change_interface =3D port->phy_interface !=3D state->interfa=
ce;
>
>         /* Check for invalid configuration */
>         if (mvpp2_is_xlg(state->interface) && port->gop_id !=3D 0) {
> -               netdev_err(dev, "Invalid mode on %s\n", dev->name);
> +               netdev_err(port->dev, "Invalid mode on %s\n", port->dev->=
name);
>                 return;
>         }
>
> @@ -5151,8 +5155,7 @@ static void mvpp2_mac_link_up(struct
> phylink_config *config,
>                               int speed, int duplex,
>                               bool tx_pause, bool rx_pause)
>  {
> -       struct net_device *dev =3D to_net_dev(config->dev);
> -       struct mvpp2_port *port =3D netdev_priv(dev);
> +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
>         u32 val;
>
>         if (mvpp2_is_xlg(interface)) {
> @@ -5199,7 +5202,7 @@ static void mvpp2_mac_link_up(struct
> phylink_config *config,
>
>         mvpp2_egress_enable(port);
>         mvpp2_ingress_enable(port);
> -       netif_tx_wake_all_queues(dev);
> +       netif_tx_wake_all_queues(port->dev);
>  }
>
>  static void mvpp2_mac_link_down(struct phylink_config *config,
> --
>
> Do you think there is a point of slicing the original patch or rather
> cherry-pick as-is?
>

Do you think there is a chance to get the above fix merged to stable (v5.3+=
)?

Best regards,
Marcin
