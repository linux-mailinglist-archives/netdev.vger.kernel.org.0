Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3812F3DD427
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 12:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbhHBKpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 06:45:25 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:47448 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233167AbhHBKpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 06:45:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1627901115; x=1659437115;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EEwPONufhL25fB2V+5qBq+1fXifp8TxhPLMCs/6oDdI=;
  b=fDDWFH/ikoYXs9og9C5GKInutvnVKHvTqUHYIZyL7m//0SCNMiB24otk
   5t1a4mQsDm911Z5UkTkYJ3yhMLhHmcqsYHm0gVuLZGL+bbjJj8aMKX7mf
   TFVDbX5smeWULLR0W1R6RaL93eqVQN7tat/FqnVUeHnmPZrWFv7Me71l3
   fp4eIDAKE5dNf/cl53/6n9qn8hbkF4qFU+2WPRxtszXhefSs2PdESxk5k
   JSnHvXOoOwvnrkDhK+stGfUoOseB5qhI5drCVSFEyARLggY2S6dumEnLm
   9XdXQZI+85cQBoyzjolhStoHxGgVIbvsLImeXxvYelMy2lIK3DdrT/ZVe
   A==;
IronPort-SDR: CxiUi0mRRP5lEJwDFT7WjTTQ4nTVF85J9Xq6ujRM7pWz8S2NJ+akKeD1/wZedIRwmlmDOfT7G2
 pLpC5LFKNon/lNOPCsfirY3EDTJCaFK7wRfpIIAU59pAOuck+oNDNmchCLpD4okoKvNmDk2zY6
 oIMcIL7uMe+2/oAgaKiO3iwG12LrGZb/MuVbpiGRTzHZDl4xRwRzCgRWgaa+qRpvtbuuoatx6T
 W0I+zm+JISTW6MwrHsRA5dmIqAMNDmPCOuu+5ss/sONTmH/A37ozqKukJoeQoFyyQQQqoYgzBv
 o70n2XJyUXk6HI0OqStxZ3KN
X-IronPort-AV: E=Sophos;i="5.84,288,1620716400"; 
   d="scan'208";a="64382098"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Aug 2021 03:45:14 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 2 Aug 2021 03:45:14 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Mon, 2 Aug 2021 03:45:09 -0700
Message-ID: <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Mon, 2 Aug 2021 16:15:08 +0530
In-Reply-To: <20210731150416.upe5nwkwvwajhwgg@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
         <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
         <20210731150416.upe5nwkwvwajhwgg@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-07-31 at 18:04 +0300, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> > 
> > +void lan937x_mac_config(struct ksz_device *dev, int port,
> > +                     phy_interface_t interface)
> > +{
> > +     u8 data8;
> > +
> > +     lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
> > +
> > +     /* clear MII selection & set it based on interface later */
> > +     data8 &= ~PORT_MII_SEL_M;
> > +
> > +     /* configure MAC based on interface */
> > +     switch (interface) {
> > +     case PHY_INTERFACE_MODE_MII:
> > +             lan937x_config_gbit(dev, false, &data8);
> > +             data8 |= PORT_MII_SEL;
> > +             break;
> > +     case PHY_INTERFACE_MODE_RMII:
> > +             lan937x_config_gbit(dev, false, &data8);
> > +             data8 |= PORT_RMII_SEL;
> > +             break;
> > +     case PHY_INTERFACE_MODE_RGMII:
> > +     case PHY_INTERFACE_MODE_RGMII_ID:
> > +     case PHY_INTERFACE_MODE_RGMII_TXID:
> > +     case PHY_INTERFACE_MODE_RGMII_RXID:
> > +             lan937x_config_gbit(dev, true, &data8);
> > +             data8 |= PORT_RGMII_SEL;
> > +
> > +             /* Add RGMII internal delay for cpu port*/
> > +             if (dsa_is_cpu_port(dev->ds, port)) {
> 
> Why only for the CPU port? I would like Andrew/Florian to have a look
> here, I guess the assumption is that if the port has a phy-handle, the
> RGMII delays should be dealt with by the PHY, but the logic seems to be
> "is a CPU port <=> has a phy-handle / isn't a CPU port <=> doesn't have
> a phy-handle"? What if it's a fixed-link port connected to a downstream
> switch, for which this one is a DSA master?
> > 


Thanks for reviewing the patches. My earlier proposal here was to check if there
is no phydev (dp->slave->phydev) or if PHY is genphy, then apply RGMII delays
assuming delays should be dealt with the phy driver if available. What do you
think of that?

