Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8B42F8064
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:16:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730304AbhAOQPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:15:22 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:47205 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbhAOQPW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:15:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610727321; x=1642263321;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=U6Yns/fScwCLTy8KUEUsiROmPYCAVzDaghvDoJYoAwI=;
  b=iNsIHdaUgAwjgujsvvNFXS46V6NUkbh+jFNx8e6soWMiF93urasXs0Dg
   Ut6j/jiFUZJdxkPSSjzKDSO/AeNrUbpsWIGdc+kdQNLYc1wXWqp8JL/Al
   5TfxoUFQpD5rbPA1Q4GkRsqoWnV6LVdIBMwSLM1IBUNYsLKo+hnaXVkNa
   rOHR/UWZdScQPKD75wMW7NrCZc/tVPsZ6RBPjdxZb0AbOUvaZcyqiU534
   /gz5NWw2udceWjZfEvouhvttZYfpcfMvLtkE/Tjk9n3G5G6o0ByF19gW3
   tTfRM8V9Jf34NaF6FVEExxBlnaPdKqEf65+I/DghkU2cficQt3aC5V7DJ
   w==;
IronPort-SDR: cd78FlAEDaZ2Fw8OdlabZqG5BMVwsRjVhQ5IupxFe7QQz6ozLpAKAR8LfDv4qepB0lH3c0i26v
 peHUhZf/yYb9+Js8i+em3l8OmbccUR8D0kpGYwumlkednBdwMEt1SeUbt1Dtt3R48ygN7q+FPF
 MlTD/eZEWUkUm8UeqH4LowT+DEn2Xq0A7ZrF/TNw5MlA7bQUVxc0e97nV6uoef5ukPBsFEM/U5
 de3fCa3TTFLDByjAgMOT+ApzUpfVVEJ1wB70CVNShonyt99V6cHAxyRGkFgR1YgidNpn5x3vwt
 g64=
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="100226554"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jan 2021 09:14:03 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 09:14:03 -0700
Received: from tyr.hegelund-hansen.dk (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 15 Jan 2021 09:14:01 -0700
Message-ID: <f35e3c33f011b6aabd96d3b6de3750bf3d04b699.camel@microchip.com>
Subject: Re: [PATCH v12 2/4] phy: Add ethernet serdes configuration option
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Date:   Fri, 15 Jan 2021 17:14:00 +0100
In-Reply-To: <92a943cc-b332-4ac6-42a8-bb3cdae13bc0@ti.com>
References: <20210107091924.1569575-1-steen.hegelund@microchip.com>
         <20210107091924.1569575-3-steen.hegelund@microchip.com>
         <92a943cc-b332-4ac6-42a8-bb3cdae13bc0@ti.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kishon,

On Fri, 2021-01-15 at 21:22 +0530, Kishon Vijay Abraham I wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> Hi,
> 
> On 07/01/21 2:49 pm, Steen Hegelund wrote:
> > Provide a new ethernet phy configuration structure, that
> > allow PHYs used for ethernet to be configured with
> > speed, media type and clock information.
> > 
> > Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  include/linux/phy/phy-ethernet-serdes.h | 30
> > +++++++++++++++++++++++++
> >  include/linux/phy/phy.h                 |  4 ++++
> >  2 files changed, 34 insertions(+)
> >  create mode 100644 include/linux/phy/phy-ethernet-serdes.h
> > 
> > diff --git a/include/linux/phy/phy-ethernet-serdes.h
> > b/include/linux/phy/phy-ethernet-serdes.h
> > new file mode 100644
> > index 000000000000..d2462fadf179
> > --- /dev/null
> > +++ b/include/linux/phy/phy-ethernet-serdes.h
> > @@ -0,0 +1,30 @@
> > +/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
> > +/*
> > + * Microchip Sparx5 Ethernet SerDes driver
> > + *
> > + * Copyright (c) 2020 Microschip Inc
> > + */
> > +#ifndef __PHY_ETHERNET_SERDES_H_
> > +#define __PHY_ETHERNET_SERDES_H_
> > +
> > +#include <linux/types.h>
> > +
> > +enum ethernet_media_type {
> > +     ETH_MEDIA_DEFAULT,
> > +     ETH_MEDIA_SR,
> > +     ETH_MEDIA_DAC,
> > +};
> 
> I'm not familiar with Ethernet. Are these generic media types? what
> does
> SR or DAC refer to? 

The SR stands for Short Reach and is a fiber type connection used by
SFPs.  There also other "reach" variants.

DAC stands for Direct Attach Copper and is a type of cable that plugs
into an SFP cage and provides information back to the user via its
EEPROM regarding supported speed and capabilities in general.  These
typically supports speed of 5G or more.

The SFP/Phylink is the "out-of-band" method that provides the type of
connection: speed and media type that allows the client to adapt the
SerDes configuration to the type of media selected by the user.

> Are there other media types? What is the out-of-band
> mechanism by which the controller gets the media type? Why was this
> not
> required for other existing Ethernet SERDES? 

This is probably a matter of the interface speed are now getting higher
and the amount of configuration needed for the SerDes have increased,
at the same time as this is not being a static setup, because the user
an plug and unplug media to the SFP cage.

> Are you aware of any other
> vendors who might require this?

I suspect that going forward it will become more widespread, at least
we have more chips in the pipeline that need this SerDes for high speed
connectivity.


> 
> Thanks
> Kishon
> > +
> > +/**
> > + * struct phy_configure_opts_eth_serdes - Ethernet SerDes This
> > structure is used
> > + * to represent the configuration state of a Ethernet Serdes PHY.
> > + * @speed: Speed of the serdes interface in Mbps
> > + * @media_type: Specifies which media the serdes will be using
> > + */
> > +struct phy_configure_opts_eth_serdes {
> > +     u32                        speed;
> > +     enum ethernet_media_type   media_type;
> > +};
> > +
> > +#endif
> > +
> > diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> > index e435bdb0bab3..78ecb375cede 100644
> > --- a/include/linux/phy/phy.h
> > +++ b/include/linux/phy/phy.h
> > @@ -18,6 +18,7 @@
> > 
> >  #include <linux/phy/phy-dp.h>
> >  #include <linux/phy/phy-mipi-dphy.h>
> > +#include <linux/phy/phy-ethernet-serdes.h>
> > 
> >  struct phy;
> > 
> > @@ -49,11 +50,14 @@ enum phy_mode {
> >   *
> >   * @mipi_dphy:       Configuration set applicable for phys
> > supporting
> >   *           the MIPI_DPHY phy mode.
> > + * @eth_serdes: Configuration set applicable for phys supporting
> > + *           the ethernet serdes.
> >   * @dp:              Configuration set applicable for phys
> > supporting
> >   *           the DisplayPort protocol.
> >   */
> >  union phy_configure_opts {
> >       struct phy_configure_opts_mipi_dphy     mipi_dphy;
> > +     struct phy_configure_opts_eth_serdes    eth_serdes;
> >       struct phy_configure_opts_dp            dp;
> >  };
> > 
> > 

Best Regards
Steen

