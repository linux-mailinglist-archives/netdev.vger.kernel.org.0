Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7284270A0
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 20:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239820AbhJHST1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 14:19:27 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:17949 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhJHST0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 14:19:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633717051; x=1665253051;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q9/ahXNq/PgdATbzGy+xoEIbgIaM2veRvp5PDNlmIoY=;
  b=P9ThCOEAGY/5l8kHq9ikCU1C32OWESpyx7Ba/HnHkmpoGj7WZuYK6Fo9
   bnS6KrFEDpAn9BPT6IdcTTyKRnuTIOKbJ2uSl7oSJDPMgS7TAoe3nVaSm
   rQvjrtfxjJHN8ENxUSYh1nVuknsGAbgOh/E4q9XGR/tnO+xN6/xZ/Bhru
   EIp2BIiEXTt0sYw8gK0v/vRpgLiIWkPTxr0JfRtIY6Zwh2aC2n0S+Eg5X
   N4M+x+rXe+m/BZqhudjFIVO63Gmd7PMBOraxXkzTmxu1aj/EKvzVJeOeU
   ZdFhBlhq4RY2qhEheSOSpz/FuPJ+4+qyFz69Bxx4TB8O4Cj3IG+XATG/R
   g==;
IronPort-SDR: NddQFQ0MBAWdspcSQkJTNxp/19E1+KDc3U9xW3VC4JvNB03MwbtPhd3mhY/deI3EwWNboEKMS/
 4R49vL5BH4EiIaoOveMCuTohg9+/raHrliS1y+wFl14LAAfB4P5n91nwYssFnD44hhjFzrOATB
 Xdg/YgqHDNxDXfif1h/4D5fXhC+yUa+CDunvXyFsXA8II2JQa1hF4QwUPb7XjIbzax0Mmx7g6t
 PM9cSsekrHzxJSetEUoxhBq8gPiv51aXnEtwxTIig47H+SNggTZ/cpLO3p/709yy1wpBNAgvCn
 GnDlRE5qGgP0avH1uiQmA2s8
X-IronPort-AV: E=Sophos;i="5.85,358,1624345200"; 
   d="scan'208";a="139568962"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Oct 2021 11:17:29 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 8 Oct 2021 11:17:29 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Fri, 8 Oct 2021 11:17:24 -0700
Message-ID: <0c4264ca6f859b6ce53e59f1565563f8dc29a2c6.camel@microchip.com>
Subject: Re: [PATCH v4 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Fri, 8 Oct 2021 23:47:23 +0530
In-Reply-To: <20211007200005.3ze43py7ma4omn7r@skbuf>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
         <20211007151200.748944-6-prasanna.vengateshan@microchip.com>
         <20211007200005.3ze43py7ma4omn7r@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-10-07 at 23:00 +0300, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On Thu, Oct 07, 2021 at 08:41:55PM +0530, Prasanna Vengateshan wrote:
> > +static int lan937x_mdio_register(struct dsa_switch *ds)
> > 
> > +
> > +     ret = of_mdiobus_register(ds->slave_mii_bus, mdio_np);
> 
> Please use devm_of_mdiobus_register if you're going to use
> devm_mdiobus_alloc, or no devres at all.
> https://patchwork.kernel.org/project/netdevbpf/patch/20210920214209.1733768-3-vladimir.oltean@nxp.com/

Sure, Will change it to devm_of_mdiobus_register.

> > 
> > +
> > +                     /* Check if the device tree have specific interface
> > +                      * setting otherwise read & assign from XMII register
> > +                      * for host port interface
> > +                      */
> > +                     interface = lan937x_get_interface(dev, i);
> 
> What does the CPU port have so special that you override it here?
> Again some compatibility with out-of-tree DT bindings?
> > 
> 
Device strapping method cannot be used since the phy-mode is expected
to be present in the DT. So above assignment have to be removed along
with lan937x_get_interface function.


> > +
> > +     /* maximum delay is 4ns */
> > +     if (val > 4000)
> > +             val = 4000;
> 
> These bindings are new. Given that you also document their min and max
> values, why don't you just error out on out-of-range values instead of
> silently doing what you think is going to be fine?

Sure, i think the driver can also notify rx/tx internal delay applied
message using dev_info.


