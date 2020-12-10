Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E886D2D62D1
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 18:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392375AbgLJQ77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 11:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390995AbgLJOgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 09:36:22 -0500
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319E8C0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 06:35:42 -0800 (PST)
Received: by mail-qv1-xf44.google.com with SMTP id 4so2451871qvh.1
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 06:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U24d37d8MZarY1ZSzRRRNEmZbTlCIw80zN9VJBAL4EI=;
        b=NX4ki20WGiuiu1O+ep7MUXCNmQ7VO/NTruzI+JxceO1aMiitD7kiTmaXGl/En/6ell
         b22w/r+T2oASAV4iz9A63ysO8GVMc9O7JUoTMam672CSpCNUWuRF/jR3fdIeSJFhN+aZ
         2hll3a8kQaUCL+slZr1bcMIr3YvIusa33uLzvE2i+Igg117rUeUDHzYRXAVxmKSFlu5D
         eNwh/v1Eq7gud7HRNDwp/jWylzAIgvNQMXFs7iNfvMmOapFnI21sVw7N6WZduqeFzLFQ
         2+wqcEQpARfKUlBA9MrkWTNPTs4G6eVfJUvZU+FQs/xDYFwl8qhOZFFvTb9UOuBNy7gC
         es4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U24d37d8MZarY1ZSzRRRNEmZbTlCIw80zN9VJBAL4EI=;
        b=RnJiDlSWzRfvdhpEw3g9+7A9Lr10Ui3FZtJO6MXHqS+sX+E1cDug1ao5xYno2d0gOd
         UqZ/k0DOywPa/EQTIe1zu5YQV2UJ8Zo9q5v47rWDWE/sI2K/lcYsz1oI750ortWwp2Vg
         YDERgwzvjtuXIumoDyj7GbN2I/iKLZm4nh9nG/6jpP2D2lnVMi+YYfJW8yVdrku+tZG0
         lqeJmYfMnX9C/53wZigW+oc956tytk7JScMwqNOpfP3kcFdSG8AvsxhmjKRSmKr4NpWv
         Av1fjec+VP9XvBOf8Odsv11HqHzjOz7EJRpeVCSet40BrPJdqmlPBRz+V+vA0q7JLzuP
         R04Q==
X-Gm-Message-State: AOAM531c/ED1Qw7VaXNin+KMDn8K2zNh+frBRFZrAqIwYG+t1b8nS9h3
        /LiOarbRnAY/Bs2nD+PczNVgITbE5IeyJ1L0w94XWQ==
X-Google-Smtp-Source: ABdhPJzPVqGzCu4SNXHL8k5HiVS3d0On+CNH5FoB0aULH1VkkgojOgyELS529qevnxAQt0zSoO1DYvGcUCVrVugD+bo=
X-Received: by 2002:a05:6214:14ae:: with SMTP id bo14mr9356245qvb.16.1607610941238;
 Thu, 10 Dec 2020 06:35:41 -0800 (PST)
MIME-Version: 1.0
References: <20200620092047.GR1551@shell.armlinux.org.uk> <E1jmZgq-0001UG-1c@rmk-PC.armlinux.org.uk>
 <CAPv3WKdJKAEwCoj5z6NzP2xRFfT1HG+2o0wigt=Czi4bG7EQcg@mail.gmail.com>
 <CAPv3WKfEN22cKbM8=+qDANefQE67KQ1zwURrCqAsrbo1+gBCDA@mail.gmail.com>
 <20201102180326.GA2416734@kroah.com> <CAPv3WKf0fNOOovq9UzoxoAXwGLMe_MHdfCZ6U9sjgKxarUKA+Q@mail.gmail.com>
 <20201208133532.GH643756@sasha-vm> <CAPv3WKed9zhe0q2noGKiKdzd=jBNLtN6vRW0fnQddJhhiD=rkg@mail.gmail.com>
 <X9CuTjdgD3tDKWwo@kroah.com>
In-Reply-To: <X9CuTjdgD3tDKWwo@kroah.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Thu, 10 Dec 2020 15:35:29 +0100
Message-ID: <CAPv3WKdKOnd+iBkfcVkoOZkHj16jOpBprY3A01ERJeq6ZQCkVQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] net: mvpp2: add mvpp2_phylink_to_port() helper
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        stable@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Gabor Samu <samu_gabor@yahoo.ca>,
        Jon Nettleton <jon@solid-run.com>,
        Andrew Elwell <andrew.elwell@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

=C5=9Br., 9 gru 2020 o 11:59 Greg Kroah-Hartman
<gregkh@linuxfoundation.org> napisa=C5=82(a):
>
> On Tue, Dec 08, 2020 at 04:02:50PM +0100, Marcin Wojtas wrote:
> > Hi Sasha,
> >
> > wt., 8 gru 2020 o 14:35 Sasha Levin <sashal@kernel.org> napisa=C5=82(a)=
:
> > >
> > > On Tue, Dec 08, 2020 at 01:03:38PM +0100, Marcin Wojtas wrote:
> > > >Hi Greg,
> > > >
> > > >Apologies for delayed response:.
> > > >
> > > >
> > > >pon., 2 lis 2020 o 19:02 Greg Kroah-Hartman
> > > ><gregkh@linuxfoundation.org> napisa=C5=82(a):
> > > >>
> > > >> On Mon, Nov 02, 2020 at 06:38:54PM +0100, Marcin Wojtas wrote:
> > > >> > Hi Greg and Sasha,
> > > >> >
> > > >> > pt., 9 pa=C5=BA 2020 o 05:43 Marcin Wojtas <mw@semihalf.com> nap=
isa=C5=82(a):
> > > >> > >
> > > >> > > Hi,
> > > >> > >
> > > >> > > sob., 20 cze 2020 o 11:21 Russell King <rmk+kernel@armlinux.or=
g.uk> napisa=C5=82(a):
> > > >> > > >
> > > >> > > > Add a helper to convert the struct phylink_config pointer pa=
ssed in
> > > >> > > > from phylink to the drivers internal struct mvpp2_port.
> > > >> > > >
> > > >> > > > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > > >> > > > ---
> > > >> > > >  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 29 ++++++++=
+----------
> > > >> > > >  1 file changed, 14 insertions(+), 15 deletions(-)
> > > >> > > >
> > > >> > > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c=
 b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > >> > > > index 7653277d03b7..313f5a60a605 100644
> > > >> > > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > >> > > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > >> > > > @@ -4767,12 +4767,16 @@ static void mvpp2_port_copy_mac_addr=
(struct net_device *dev, struct mvpp2 *priv,
> > > >> > > >         eth_hw_addr_random(dev);
> > > >> > > >  }
> > > >> > > >
> > > >> > > > +static struct mvpp2_port *mvpp2_phylink_to_port(struct phyl=
ink_config *config)
> > > >> > > > +{
> > > >> > > > +       return container_of(config, struct mvpp2_port, phyli=
nk_config);
> > > >> > > > +}
> > > >> > > > +
> > > >> > > >  static void mvpp2_phylink_validate(struct phylink_config *c=
onfig,
> > > >> > > >                                    unsigned long *supported,
> > > >> > > >                                    struct phylink_link_state=
 *state)
> > > >> > > >  {
> > > >> > > > -       struct mvpp2_port *port =3D container_of(config, str=
uct mvpp2_port,
> > > >> > > > -                                              phylink_confi=
g);
> > > >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(co=
nfig);
> > > >> > > >         __ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D { 0, };
> > > >> > > >
> > > >> > > >         /* Invalid combinations */
> > > >> > > > @@ -4913,8 +4917,7 @@ static void mvpp2_gmac_pcs_get_state(s=
truct mvpp2_port *port,
> > > >> > > >  static void mvpp2_phylink_mac_pcs_get_state(struct phylink_=
config *config,
> > > >> > > >                                             struct phylink_l=
ink_state *state)
> > > >> > > >  {
> > > >> > > > -       struct mvpp2_port *port =3D container_of(config, str=
uct mvpp2_port,
> > > >> > > > -                                              phylink_confi=
g);
> > > >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(co=
nfig);
> > > >> > > >
> > > >> > > >         if (port->priv->hw_version =3D=3D MVPP22 && port->go=
p_id =3D=3D 0) {
> > > >> > > >                 u32 mode =3D readl(port->base + MVPP22_XLG_C=
TRL3_REG);
> > > >> > > > @@ -4931,8 +4934,7 @@ static void mvpp2_phylink_mac_pcs_get_=
state(struct phylink_config *config,
> > > >> > > >
> > > >> > > >  static void mvpp2_mac_an_restart(struct phylink_config *con=
fig)
> > > >> > > >  {
> > > >> > > > -       struct mvpp2_port *port =3D container_of(config, str=
uct mvpp2_port,
> > > >> > > > -                                              phylink_confi=
g);
> > > >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(co=
nfig);
> > > >> > > >         u32 val =3D readl(port->base + MVPP2_GMAC_AUTONEG_CO=
NFIG);
> > > >> > > >
> > > >> > > >         writel(val | MVPP2_GMAC_IN_BAND_RESTART_AN,
> > > >> > > > @@ -5105,13 +5107,12 @@ static void mvpp2_gmac_config(struct=
 mvpp2_port *port, unsigned int mode,
> > > >> > > >  static void mvpp2_mac_config(struct phylink_config *config,=
 unsigned int mode,
> > > >> > > >                              const struct phylink_link_state=
 *state)
> > > >> > > >  {
> > > >> > > > -       struct net_device *dev =3D to_net_dev(config->dev);
> > > >> > > > -       struct mvpp2_port *port =3D netdev_priv(dev);
> > > >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(co=
nfig);
> > > >> > > >         bool change_interface =3D port->phy_interface !=3D s=
tate->interface;
> > > >> > > >
> > > >> > > >         /* Check for invalid configuration */
> > > >> > > >         if (mvpp2_is_xlg(state->interface) && port->gop_id !=
=3D 0) {
> > > >> > > > -               netdev_err(dev, "Invalid mode on %s\n", dev-=
>name);
> > > >> > > > +               netdev_err(port->dev, "Invalid mode on %s\n"=
, port->dev->name);
> > > >> > > >                 return;
> > > >> > > >         }
> > > >> > > >
> > > >> > > > @@ -5151,8 +5152,7 @@ static void mvpp2_mac_link_up(struct p=
hylink_config *config,
> > > >> > > >                               int speed, int duplex,
> > > >> > > >                               bool tx_pause, bool rx_pause)
> > > >> > > >  {
> > > >> > > > -       struct net_device *dev =3D to_net_dev(config->dev);
> > > >> > > > -       struct mvpp2_port *port =3D netdev_priv(dev);
> > > >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(co=
nfig);
> > > >> > > >         u32 val;
> > > >> > > >
> > > >> > > >         if (mvpp2_is_xlg(interface)) {
> > > >> > > > @@ -5199,14 +5199,13 @@ static void mvpp2_mac_link_up(struct=
 phylink_config *config,
> > > >> > > >
> > > >> > > >         mvpp2_egress_enable(port);
> > > >> > > >         mvpp2_ingress_enable(port);
> > > >> > > > -       netif_tx_wake_all_queues(dev);
> > > >> > > > +       netif_tx_wake_all_queues(port->dev);
> > > >> > > >  }
> > > >> > > >
> > > >> > > >  static void mvpp2_mac_link_down(struct phylink_config *conf=
ig,
> > > >> > > >                                 unsigned int mode, phy_inter=
face_t interface)
> > > >> > > >  {
> > > >> > > > -       struct net_device *dev =3D to_net_dev(config->dev);
> > > >> > > > -       struct mvpp2_port *port =3D netdev_priv(dev);
> > > >> > > > +       struct mvpp2_port *port =3D mvpp2_phylink_to_port(co=
nfig);
> > > >> > > >         u32 val;
> > > >> > > >
> > > >> > > >         if (!phylink_autoneg_inband(mode)) {
> > > >> > > > @@ -5223,7 +5222,7 @@ static void mvpp2_mac_link_down(struct=
 phylink_config *config,
> > > >> > > >                 }
> > > >> > > >         }
> > > >> > > >
> > > >> > > > -       netif_tx_stop_all_queues(dev);
> > > >> > > > +       netif_tx_stop_all_queues(port->dev);
> > > >> > > >         mvpp2_egress_disable(port);
> > > >> > > >         mvpp2_ingress_disable(port);
> > > >> > > >
> > > >> > > > --
> > > >> > > > 2.20.1
> > > >> > > >
> > > >> > >
> > > >> > > This patch fixes a regression that was introduced in v5.3:
> > > >> > > Commit 44cc27e43fa3 ("net: phylink: Add struct phylink_config =
to PHYLINK API")
> > > >> > >
> > > >> > > Above results in a NULL pointer dereference when booting the
> > > >> > > Armada7k8k/CN913x with ACPI between 5.3 and 5.8, which will be
> > > >> > > problematic especially for the distros using LTSv5.4 and above=
 (the
> > > >> > > issue was reported on Fedora 32).
> > > >> > >
> > > >> > > Please help with backporting to the stable v5.3+ branches (it =
applies
> > > >> > > smoothly on v5.4/v5.6/v5.8).
> > > >> > >
> > > >> >
> > > >> > Any chances to backport this patch to relevant v5.3+ stable bran=
ches?
> > > >>
> > > >> What patch?  What git commit id needs to be backported?
> > > >>
> > > >
> > > >The actual patch is:
> > > >Commit 6c2b49eb9671  ("net: mvpp2: add mvpp2_phylink_to_port() helpe=
r").
> > > >
> > > >URL for reference:
> > > >https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/c=
ommit/drivers/net/ethernet/marvell/mvpp2?h=3Dv5.10-rc7&id=3D6c2b49eb96716e9=
1f202756bfbd3f5fea3b2b172
> > > >
> > > >Do you think it would be possible to get it merged to v5.3+ stable b=
ranches?
> > >
> > > Could you explain how that patch fixes anything? It reads like a
> > > cleanup.
> > >
> >
> > Indeed, I am aware of it, but I'm not sure about the best way to fix
> > it. In fact the mentioned patch is an unintentional fix. Commit
> > 44cc27e43fa3 ("net: phylink: Add struct phylink_config to PHYLINK
> > API") reworked an argument list of mvpp2_mac_config() routine in a way
> > that resulted in a NULL pointer dereference when booting the
> > Armada7k8k/CN913x with ACPI between 5.3 and 5.8. Part of Russell's
> > patch resolves this issue.
>
> What part fixes the issue?  I can't see it...
>

I re-checked in my setup and here's the smallest part of the original
patch, that fixes previously described issue:
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index e98be8372780..9d71a4fe1750 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4767,6 +4767,11 @@ static void mvpp2_port_copy_mac_addr(struct
net_device *dev, struct mvpp2 *priv,
        eth_hw_addr_random(dev);
 }

+static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config *con=
fig)
+{
+       return container_of(config, struct mvpp2_port, phylink_config);
+}
+
 static void mvpp2_phylink_validate(struct phylink_config *config,
                                   unsigned long *supported,
                                   struct phylink_link_state *state)
@@ -5105,13 +5110,12 @@ static void mvpp2_gmac_config(struct
mvpp2_port *port, unsigned int mode,
 static void mvpp2_mac_config(struct phylink_config *config, unsigned int m=
ode,
                             const struct phylink_link_state *state)
 {
-       struct net_device *dev =3D to_net_dev(config->dev);
-       struct mvpp2_port *port =3D netdev_priv(dev);
+       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
        bool change_interface =3D port->phy_interface !=3D state->interface=
;

        /* Check for invalid configuration */
        if (mvpp2_is_xlg(state->interface) && port->gop_id !=3D 0) {
-               netdev_err(dev, "Invalid mode on %s\n", dev->name);
+               netdev_err(port->dev, "Invalid mode on %s\n", port->dev->na=
me);
                return;
        }

@@ -5151,8 +5155,7 @@ static void mvpp2_mac_link_up(struct
phylink_config *config,
                              int speed, int duplex,
                              bool tx_pause, bool rx_pause)
 {
-       struct net_device *dev =3D to_net_dev(config->dev);
-       struct mvpp2_port *port =3D netdev_priv(dev);
+       struct mvpp2_port *port =3D mvpp2_phylink_to_port(config);
        u32 val;

        if (mvpp2_is_xlg(interface)) {
@@ -5199,7 +5202,7 @@ static void mvpp2_mac_link_up(struct
phylink_config *config,

        mvpp2_egress_enable(port);
        mvpp2_ingress_enable(port);
-       netif_tx_wake_all_queues(dev);
+       netif_tx_wake_all_queues(port->dev);
 }

 static void mvpp2_mac_link_down(struct phylink_config *config,
--=20

Do you think there is a point of slicing the original patch or rather
cherry-pick as-is?

Best regards,
Marcin
