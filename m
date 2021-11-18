Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980A6455862
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243969AbhKRJ7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 04:59:18 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:47697 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245329AbhKRJ6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 04:58:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1637229317; x=1668765317;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IEdv4oCs78UF+a2B4VJ1pWOAAeTD3DooZgB7/gLExrw=;
  b=wopihMaZNA+DshbkFxDi/1oUpYrtfmcKjmAbK/ur3dNF9NotbAlpN6sf
   MO6ESZPuZh50UVYbhIKzdIO7aLYuTkIg2X+mC5qdoupXgIDpGrg7YHmZ8
   UqcB89EiuCSR5UaX0PAY3lCD1KmOMMJgSTKbm0cYWAdWFVzJY7mgnjKe8
   sA/Bnze06yxPfvArNfJvvS5Y8VU5gXaBfUQXN9Y6Yof6JWHV5G54BOnFz
   /PfO7sSu/bDkw5cTLjU0jgxnDPq2Kae5tSP4RIPpq7cuMycTOp3LMlKMr
   sJ70fu32enpW4pRVIYGJnySOojCBK6Y+a8KW9e+FLRbPTRLNLTpSBqw7+
   Q==;
IronPort-SDR: gMEfGbO0w+9X2i5IEe/1YkeSb6qT/bzz2E6r1pHmdiZnXGFefzxhp6zy3tS56sUae7Njmtfk2v
 MEdFLe2zr5v0iex15F7umsSO1v0URPpslluG90kd06KEa3o+EUgYdCQxl0bpxQlMQ3Iw6X3Osc
 N8zR2wTp6fHirZs8N/BwtdenkittlJ54DWck+jreNDTotwTyhrSXx2mWSr7fRLVJfmICZU96nW
 KlLzkx3/+BEcBEYVJZY4ag9sw0qYUOCwkClFCldUtBJVOTuTG3+xWOvRW/0gjsr/dejoNakkcL
 Abqb2WR9BjstzQsfkXckvhNH
X-IronPort-AV: E=Sophos;i="5.87,244,1631602800"; 
   d="scan'208";a="152384821"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Nov 2021 02:55:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 18 Nov 2021 02:55:16 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Thu, 18 Nov 2021 02:55:16 -0700
Date:   Thu, 18 Nov 2021 10:57:03 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <p.zabel@pengutronix.de>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/5] net: lan966x: add port module support
Message-ID: <20211118095703.owsb2nen5hb5vjz2@soft-dev3-1.localhost>
References: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
 <20211117091858.1971414-4-horatiu.vultur@microchip.com>
 <YZTRUfvPPu5qf7mE@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YZTRUfvPPu5qf7mE@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/17/2021 09:54, Russell King (Oracle) wrote:
> 
> Hi,

Hi Russell,

> 
> On Wed, Nov 17, 2021 at 10:18:56AM +0100, Horatiu Vultur wrote:
> > +static void lan966x_phylink_mac_link_state(struct phylink_config *config,
> > +                                        struct phylink_link_state *state)
> > +{
> > +}
> > +
> > +static void lan966x_phylink_mac_aneg_restart(struct phylink_config *config)
> > +{
> > +}
> 
> Since you always attach a PCS, it is not necessary to provide stubs
> for these functions.

Pefect, I will remove these ones.

> 
> > +static int lan966x_pcs_config(struct phylink_pcs *pcs,
> > +                           unsigned int mode,
> > +                           phy_interface_t interface,
> > +                           const unsigned long *advertising,
> > +                           bool permit_pause_to_mac)
> > +{
> > +     struct lan966x_port *port = lan966x_pcs_to_port(pcs);
> > +     struct lan966x_port_config config;
> > +     int ret;
> > +
> > +     memset(&config, 0, sizeof(config));
> > +
> > +     config = port->config;
> > +     config.portmode = interface;
> > +     config.inband = phylink_autoneg_inband(mode);
> > +     config.autoneg = phylink_test(advertising, Autoneg);
> > +     if (phylink_test(advertising, Pause))
> > +             config.pause_adv |= ADVERTISE_1000XPAUSE;
> > +     if (phylink_test(advertising, Asym_Pause))
> > +             config.pause_adv |= ADVERTISE_1000XPSE_ASYM;
> 
> There are patches around that add
> phylink_mii_c22_pcs_encode_advertisement() which will create the C22
> advertisement for you. It would be good to get that patch merged so
> people can use it. That should also eliminate lan966x_get_aneg_word(),
> although I notice you need to set ADVERTISE_LPACK as well (can you
> check that please? Hardware should be managing that bit as it should
> only be set once the hardware has received the link partner's
> advertisement.)

Yes, I will keep an eye for phylink_mii_c22_pcs_encode_advertisement.
Also I have also tried to remove ADVERTISE_LPACK and that seems to work
fine.

> 
> > +static void decode_cl37_word(u16 lp_abil, uint16_t ld_abil,
> > +                          struct lan966x_port_status *status)
> > +{
> > +     status->link = !(lp_abil & ADVERTISE_RFAULT) && status->link;
> > +     status->an_complete = true;
> > +     status->duplex = (ADVERTISE_1000XFULL & lp_abil) ?
> > +             DUPLEX_FULL : DUPLEX_UNKNOWN;
> > +
> > +     if ((ld_abil & ADVERTISE_1000XPAUSE) &&
> > +         (lp_abil & ADVERTISE_1000XPAUSE)) {
> > +             status->pause = MLO_PAUSE_RX | MLO_PAUSE_TX;
> > +     } else if ((ld_abil & ADVERTISE_1000XPSE_ASYM) &&
> > +                (lp_abil & ADVERTISE_1000XPSE_ASYM)) {
> > +             status->pause |= (lp_abil & ADVERTISE_1000XPAUSE) ?
> > +                     MLO_PAUSE_TX : 0;
> > +             status->pause |= (ld_abil & ADVERTISE_1000XPAUSE) ?
> > +                     MLO_PAUSE_RX : 0;
> > +     } else {
> > +             status->pause = MLO_PAUSE_NONE;
> > +     }
> > +}
> 
> We already have phylink_decode_c37_word() which will decode this for
> you, although it would need to be exported. Please re-use this code.

Yes, I will do that.

> 
> > +
> > +static void decode_sgmii_word(u16 lp_abil, struct lan966x_port_status *status)
> > +{
> > +     status->an_complete = true;
> > +     if (!(lp_abil & LPA_SGMII_LINK)) {
> > +             status->link = false;
> > +             return;
> > +     }
> > +
> > +     switch (lp_abil & LPA_SGMII_SPD_MASK) {
> > +     case LPA_SGMII_10:
> > +             status->speed = SPEED_10;
> > +             break;
> > +     case LPA_SGMII_100:
> > +             status->speed = SPEED_100;
> > +             break;
> > +     case LPA_SGMII_1000:
> > +             status->speed = SPEED_1000;
> > +             break;
> > +     default:
> > +             status->link = false;
> > +             return;
> > +     }
> > +     if (lp_abil & LPA_SGMII_FULL_DUPLEX)
> > +             status->duplex = DUPLEX_FULL;
> > +     else
> > +             status->duplex = DUPLEX_HALF;
> > +}
> 
> The above mentioned function will also handle SGMII as well.

I noticed that you have phylink_decode_sgmii_work(), so I will try to
export it also.

> 
> > +int lan966x_port_pcs_set(struct lan966x_port *port,
> > +                      struct lan966x_port_config *config)
> > +{
> > +     struct lan966x *lan966x = port->lan966x;
> > +     bool sgmii = false, inband_aneg = false;
> > +     int err;
> > +
> > +     lan966x_port_link_down(port);
> > +
> > +     if (config->inband) {
> > +             if (config->portmode == PHY_INTERFACE_MODE_SGMII ||
> > +                 config->portmode == PHY_INTERFACE_MODE_QSGMII)
> > +                     inband_aneg = true; /* Cisco-SGMII in-band-aneg */
> > +             else if (config->portmode == PHY_INTERFACE_MODE_1000BASEX &&
> > +                      config->autoneg)
> > +                     inband_aneg = true; /* Clause-37 in-band-aneg */
> > +
> > +             if (config->speed > 0) {
> > +                     err = phy_set_speed(port->serdes, config->speed);
> > +                     if (err)
> > +                             return err;
> > +             }
> > +
> > +     } else {
> > +             sgmii = true; /* Phy is connnected to the MAC */
> 
> This looks weird. SGMII can be in-band as well (and technically is
> in-band in its as-specified form.)

I think the names are a little bit misleading.
We cover the case where SGMII is inbind in the code

if (config->inband) {
    if (config->portmode == PHY_INTERFACE_MODE_SGMII ||
        config->portmode == PHY_INTERFACE_MODE_QSGMII)
}

I think we can remove the sgmii variable and use directly the
config->inband.

> 
> > +     }
> > +
> > +     /* Choose SGMII or 1000BaseX/2500BaseX PCS mode */
> > +     lan_rmw(DEV_PCS1G_MODE_CFG_SGMII_MODE_ENA_SET(sgmii),
> > +             DEV_PCS1G_MODE_CFG_SGMII_MODE_ENA,
> > +             lan966x, DEV_PCS1G_MODE_CFG(port->chip_port));
> 
> With the code as you have it, what this means is if we specify
> SGMII + in-band, we end up configuring the port to be in 1000BaseX
> mode, so it's incapable of 10 and 100M speeds. This seems incorrect.

Actually I think the comment is misleading, that bit will just choose to
enable or not the control word for inbound.

> 
> Thanks.
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
/Horatiu
