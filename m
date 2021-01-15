Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD97B2F74EE
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:11:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbhAOJJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:09:24 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:12475 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbhAOJJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:09:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610701761; x=1642237761;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qyhhzoX7sec/GQhphB69vK1LJzQTApmmA0nBYYV6v34=;
  b=KyAmOsr3wJnlPq6IrpWS69D7huM7cosgBXQyL9UWQU3pe3L50QZUuR1G
   bFqh48XGI5ueAzcLDjt/v54CnxWDYRLpVUpaN4cx02iRWt2yQA/TZSASz
   0yyhLs4zHhR2+Jx2TAlQyXxap6C2pLgyF9Gdw1jElrlbXDeaHVBKcSRIt
   dPo5eRQA3gKfr1obmDT/VNjiscSNSSgBQqE/T2Va36H+v5LioIzWjQdLU
   c4yyxA4nCuShi3K/n5cm2LHFqp8w0cH06hzI8EtG6AozvkvxwhemvNSwN
   zvSwTxvtzh6XU2Jb0esZiazJn59gEnNYm1APKV4d7aFfyP2Z6DbTc0jEr
   w==;
IronPort-SDR: OXOTmseRT1TfBELjd6oT+u1DrgbP2SoU7Jw3lS+PKddb8G3NmInZmZUHwNcxItT1MrfVI+OItk
 A7k1fr9ul/7SaZs73rGS80vc/DcXx8+LEphAkiwxzQcD21CVAe9Y4lbjerZBjKbxULTNEdnucb
 Hq5EgDzHNNiNXHKmzQEbIURCHSlZVhkQGu43/9rXgYFPDPmqfKOxt1WPI0dxrqD6LF+f9oKXVb
 XE+LNvnATt+Ni1HqAvwx6gI1nTK8VUrnreho+MtLKaNZiMxNvLNgBEoMBElYjhD+4GAluMmevg
 jlY=
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="111152968"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jan 2021 02:08:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 02:08:05 -0700
Received: from tyr.hegelund-hansen.dk (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 15 Jan 2021 02:08:03 -0700
Message-ID: <fdcb9765ccd6190271ee17f3a262ccede6af8563.camel@microchip.com>
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
Date:   Fri, 15 Jan 2021 10:08:02 +0100
In-Reply-To: <41e40e7b-6a3a-cdb9-adfc-e42f6627ea7b@ti.com>
References: <20210107091924.1569575-1-steen.hegelund@microchip.com>
         <20210107091924.1569575-3-steen.hegelund@microchip.com>
         <41e40e7b-6a3a-cdb9-adfc-e42f6627ea7b@ti.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Kishon,


On Fri, 2021-01-15 at 14:14 +0530, Kishon Vijay Abraham I wrote:
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
> 
> Is media type going to be determined dynamically by the Ethernet
> controller. If it's not determined dynamically, it shouldn't be in
> PHY
> ops but rather as a DT parameter.

Yes the media type is dynamic, as it will be determined by the feedback
from the attached SFP or DAC attached, which can be changed at any
time, so it is not static in a way that allows it to be part of the DT.

> 
> phy_configure_opts is mostly used with things like DP where the
> controller probes the configurations supported by SERDES using the
> configure and validate ops. I don't think for Ethernet it is
> required.

From what you explained I think the situation is very similar with the
Ethernet SerDes in that the actual media (and speed) is not known in
advance, but will be obtained "out-of-band" by the client and may
change at any point in time when the user changes the physical setup
(e.g cables).

> 
> Thanks
> Kishon
> 
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

BR
Steen

