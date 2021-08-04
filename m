Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9E53E0334
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 16:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237275AbhHDObG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 10:31:06 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:42934 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237013AbhHDO24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 10:28:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628087325; x=1659623325;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=D6ii/u0govjCm682RH3I0wZetDpJcPbhqh6iE1CrIu0=;
  b=w+ZubufUYvMKa2RCuvKaAXRYDbmWcSv+eEIuX4Yx1+vnfqFhQYLMPtQo
   UyvjJoyjLlq9N0nr56JdSOhe6uv966eT4x/qmwEY5kAG36OmtCUL4B8pP
   O8EstomcliWcPGjvGFc0CCO+eB4euyuqYREF1Hm5Wd593nmrv9QXy+p1Z
   EYCuk90imx9wuDiLbf1pyRCofDWYMQKT4diHlPxHyH9cfmpXzG605hgGN
   ISq4AipCo+jaYtj39wymQmocgCKB9JAze5VhvQw2npC1zMv+Wbs7wrNZL
   LFnO6ltM5as3xlV2sqmAx5R1uD/21CAoZ4C5S+X5ZpVTYQY5+PE9tSIiU
   g==;
IronPort-SDR: cMNhvWe1d11Uf+9EPoYLCd7JXMqm4xUU7aPt7KVrSMPCBy/lOVjPWpx5vpHj4KaiPPFTqLvLqb
 bv49YdtaLPQoO6SpuOCFAaNx2agMPZluq0KNB2nzvsGZv3oKCuvVpPSxEbrxirEHxdMGQIse5y
 iRGCxxh7x50fZx0Zy47oiK0moexBeTG04zA0cghGBQomFSyJlqogGNLiSJsMx+41G4JTenkl30
 NpkL7wFZzgmQ8G/aGDu2cY20P8l4xNclMPBgmRBbJlxMInuAoDytpQL3ZaIp8pBdCYWXMog9Ul
 3Th+Aw1gnsE8OhCLPpPcrrqy
X-IronPort-AV: E=Sophos;i="5.84,294,1620716400"; 
   d="scan'208";a="131030110"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Aug 2021 07:28:24 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 07:28:22 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Wed, 4 Aug 2021 07:28:17 -0700
Message-ID: <d10aa31f1258aa2975e3837acb09f26265da91eb.camel@microchip.com>
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Woojung.Huh@microchip.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Wed, 4 Aug 2021 19:58:15 +0530
In-Reply-To: <20210804104625.d2qw3gr7algzppz5@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
         <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
         <20210731150416.upe5nwkwvwajhwgg@skbuf>
         <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
         <20210802121550.gqgbipqdvp5x76ii@skbuf> <YQfvXTEbyYFMLH5u@lunn.ch>
         <20210802135911.inpu6khavvwsfjsp@skbuf>
         <50eb24a1e407b651eda7aeeff26d82d3805a6a41.camel@microchip.com>
         <20210803235401.rctfylazg47cjah5@skbuf>
         <20210804095954.GN22278@shell.armlinux.org.uk>
         <20210804104625.d2qw3gr7algzppz5@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-08-04 at 13:46 +0300, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> The problem is that I have no clear migration path for the drivers I
> maintain, like sja1105, and I suspect that others might be in the exact
> same situation.
> 
> Currently, if the sja1105 needs to add internal delays in a MAC-to-MAC
> (fixed-link) setup, it does that based on the phy-mode string. So
> "rgmii-id" + "fixed-link" means for sja1105 "add RX and TX RGMII
> internal delays", even though the documentation now says "the MAC should
> not add the RX or TX delays in this case".
> 
> There are 2 cases to think about, old driver with new DT blob and new
> driver with old DT blob. If breakage is involved, I am not actually very
> interested in doing the migration, because even though the interpretation
> of the phy-mode string is inconsistent between the phy-handle and fixed-link
> case (which was deliberate), at least it currently does all that I need it to.
> 
> I am not even clear what is the expected canonical behavior for a MAC
> driver. It parses rx-internal-delay-ps and tx-internal-delay-ps, and
> then what? It treats all "rgmii*" phy-mode strings identically? Or is it
> an error to have "rgmii-rxid" for phy-mode and non-zero rx-internal-delay-ps?
> If it is an error, should all MAC drivers check for it? And if it is an
> error, does it not make migration even more difficult (adding an
> rx-internal-delay-ps property to a MAC OF node which already uses
> "rgmii-id" would be preferable to also having to change the "rgmii-id"
> to "rgmii", because an old kernel might also need to work with that DT
> blob, and that will ignore the new rx-internal-delay-ps property).


Considering the PHY is responsible to add internal delays w.r.to phy-mode, "*-
tx-internal-delay-ps" approach that i was applying to different connections as
shown below by bringing up different examples.

1) Fixed-link MAC-MAC: 
       port@4 {
            .....
            phy-mode = "rgmii";
            rx-internal-delay-ps = <xxx>;
            tx-internal-delay-ps = <xxx>;
            ethernet = <&ethernet>;
            fixed-link {
           	......
            };
          };

2) Fixed-link MAC-Unknown:
        port@5 {
            ......
            phy-mode = "rgmii-id";
            rx-internal-delay-ps = <xxx>;
            tx-internal-delay-ps = <xxx>;
            fixed-link {
           .	....
            };
          };

3) Fixed-link :
        port@5 {
            ......
            phy-mode = "rgmii-id";
            fixed-link {
              .....
            };
          };

From above examples,
	a) MAC node is responsible to add RGMII delay by parsing "*-internal-
delay-ps" for (1) & (2). Its a known item in this discussion.
	b) Is rgmii-* to be ignored by the MAC in (2) and just apply the delays
from MAC side? Because if its forced to have "rgmii", would it become just -
>interface=*_MODE_RGMII and affects legacy?
	c) if MAC follows standard delay, then it needs to be validated against
"*-internal-delay-ps", may be validating against single value and throw an
error. Might be okay.
	d) For 3), Neither MAC nor other side will apply delays. Expected.


3) MAC-PHY

	i) &test3 {
		phy-handle = <&phy0>;
		phy-mode = "rgmii-id";
		phy0: ethernet-phy@xx {
			.....
			rx-internal-delay = <xxx>;
			tx-internal-delay = <xxx>;
		};
	  };

	ii) &test4 {
		phy-handle = <&phy0>;
		phy-mode = "rgmii";
        	rx-internal-delay-ps = <xxx>;
        	tx-internal-delay-ps = <xxx>;
		phy0: ethernet-phy@xx {
			reg = <x>;
	        };
	     };


For 3(i), I assume phy would apply internal delay values by checking its phydev-
>interface.
For 3(ii), MAC would apply the delays.

Overall, only (b) need a right decision? or any other items are missed?


Prasanna V

