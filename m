Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DD72F47F6
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 10:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbhAMJqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 04:46:49 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:27494 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbhAMJqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 04:46:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610531204; x=1642067204;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version;
  bh=MYTUvUaZSSufYVWhL7QL+MCBgAX7jJ8n0mq3WxiP2d4=;
  b=H4Wz0LeUsCLqJaNwFCY7u9FH7JUB4GJ9YWt1wHg41PIecLUO/LjuwuL8
   VKHx6tlp8vkWJQ75dmsp0qp5qUFIVcukRw5m4mprSzbj9GVunhvewnpQ1
   I9hh2oztdHGpWg7R3fxTG3yiTWZLyCpHfOeeBzHOau/++o13xHZjfpFuB
   +7qFHTFHmpNMwyXM/2X5/w0DHk6keEldtJlMqMd1eeeGQAqElMfVlJl6j
   Kz7LmQrbM+KWDE2FUFuhVv6pyL1GhkkCMII/FXDKi0bdPL94yYwT49IGM
   wtiB+19AKlKdaZ/89Xa+SmnvkRfJWMT+7spcMYjQosZYsf0NGwkq0DfR3
   A==;
IronPort-SDR: h2bLZrfjdZU9VoWnmOu3hgoPhofU0AIGIln+C/foxUkUCq4UKthRwBjpq7+G9MryBUbvbEXXOv
 Oh7aFf/nWRmLTCseW1jiT1KRjs5RZjEDwIqkp6DiYLOlrFYprVaKM07QwoE990srwl3gqXDSow
 JP5KU7STEIIyfMF7iLFAfIV6g9YBWHnMYttuHrvzJdzM2rCGt9WA1GCSE9lyMe7aC4bxwcJnuG
 /rvgu9PEwQItnKfpvJ0s2ZIpU8Q2iW28oeaiYPo7vYJA9tdZqajlhoEw7bqGSlBabSHf5WdBw7
 KE4=
X-IronPort-AV: E=Sophos;i="5.79,344,1602572400"; 
   d="bin'?scan'208";a="110865346"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2021 02:45:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 02:45:27 -0700
Received: from soft-dev2 (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 13 Jan 2021 02:45:26 -0700
Message-ID: <2488993f2ee8182bc9003c77a27ab9b3267ebf6e.camel@microchip.com>
Subject: Re: [PATCH v1 0/2] Add 100 base-x mode
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Date:   Wed, 13 Jan 2021 10:45:25 +0100
In-Reply-To: <20210112160532.GC1551@shell.armlinux.org.uk>
References: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
         <20210111141847.GU1551@shell.armlinux.org.uk>
         <a727ddabfed0dbd0cf75a045076df7a66d4d6a67.camel@microchip.com>
         <20210112160532.GC1551@shell.armlinux.org.uk>
Content-Type: multipart/mixed; boundary="=-9au1ZU887VM6z4O/ljs0"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-9au1ZU887VM6z4O/ljs0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Tue, 2021-01-12 at 16:05 +0000, Russell King - ARM Linux admin
wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> On Tue, Jan 12, 2021 at 03:33:34PM +0100, Bjarni Jonasson wrote:
> > On Mon, 2021-01-11 at 14:18 +0000, Russell King - ARM Linux admin
> > wrote:
> > > EXTERNAL EMAIL: Do not click links or open attachments unless you
> > > know the content is safe
> > > 
> > > On Mon, Jan 11, 2021 at 02:06:55PM +0100, Bjarni Jonasson wrote:
> > > > Adding support for 100 base-x in phylink.
> > > > The Sparx5 switch supports 100 base-x pcs (IEEE 802.3 Clause
> > > > 24)
> > > > 4b5b encoded.
> > > > These patches adds phylink support for that mode.
> > > > 
> > > > Tested in Sparx5, using sfp modules:
> > > > Axcen 100fx AXFE-1314-0521
> > > > Cisco GLC-FE-100LX
> > > > HP SFP 100FX J9054C
> > > > Excom SFP-SX-M1002
> > > 
> > > For each of these modules, please send me:
> > > 
> > > ethtool -m ethx raw on > module.bin
> > > 
> > > so I can validate future changes with these modules. Thanks.
> > > 
> > > --
> > > RMK's Patch system: 
> > > https://www.armlinux.org.uk/developer/patches/
> > > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
> > 
> > I've included the dump from ethtool for:
> > Axcen 100fx AXFE-1314-0521
> > Axcen 100lx AXFE-1314-0551
> > Excom SFP-SX-M1002
> > HP SFP 100FX J9054C
> > The "ethtool raw" output seems a bit garbled so I added the hex
> > output
> > as well.
> 
> It is exactly the command that I quoted above that I require. Yes,
> the output will be "garbled" as it is a raw binary dump of the EEPROM
> contents - it's not meant to be displayed directly on the console.
> 
> Please resend.
> 
> Thanks.
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Resending the raw format for the 4 modules.
Rgds
--
Bjarni Jonasson
Microchip

--=-9au1ZU887VM6z4O/ljs0
Content-Type: application/octet-stream;
	name="axcen_100fx_axfe_1314_0521.bin"
Content-Disposition: attachment; filename="axcen_100fx_axfe_1314_0521.bin"
Content-Transfer-Encoding: base64

AwQHAAABIAAAAAACAQAAAMjIAABBeGNlbiBQaG90b25pY3MgAAAXLUFYRkUtMTMxNC0wNTIxICBW
MS4wBR4AQwAaAABBWDEwMTkwMDAxOTU0ICAgMTAwNTEyICAAAACqRVhUUkVNRUxZIENPTVBBVElC
TEUgICAgICAgICAgICBBMDkwOTAzMDAxODUgICAg////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////w==


--=-9au1ZU887VM6z4O/ljs0
Content-Type: application/octet-stream;
	name="axcen_100lx_axfe_1314_0551.bin"
Content-Disposition: attachment; filename="axcen_100lx_axfe_1314_0551.bin"
Content-Transfer-Encoding: base64

AwQHABACEAAAAAACAQAe/wAAAABBeGNlbiBQaG90b25pY3MgAAAXLUFYRkUtMTMxNC0wNTUxICBW
MS4wBR4A1AAaAABBWDE0MDkxNzAyMjYwICAgMDkwNDIwICAAAACyRVhUUkVNRUxZIENPTVBBVElC
TEUgICAgICAgICAgICBBMDkwMzAwMDMxMDAxNTU3////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////w==


--=-9au1ZU887VM6z4O/ljs0
Content-Type: application/octet-stream; name="excom_sfp_sx_m1002.bin"
Content-Disposition: attachment; filename="excom_sfp_sx_m1002.bin"
Content-Transfer-Encoding: base64

AwQHAAABEAAAAAACAQAAAMjIAABFeGNvbSAgICAgICAgICAgAAAAAFNGUC1TWC1NMTAwMiAgICBB
ICAgBR4AUAASAABFWDE2MDMxNDAzNiAgICAgMTYwMzE0ICBokAF/KwAROJfOCRkeacrr5RdqXoms
zgAAAAAAAAAAABp9jbT/////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////1oA0wBVANgAlHBpeJCIbWDDUAAAr8gAMgxaAPsJ
0AE8GKYAAxOUAAT/////////////////////AAAAAAAAAAAAAAAAP4AAAAAAAAABAAAAAQAAAAEA
AAABAAAA////cxWqhBIqVQPVAAD/////AgAAQAD/AED//wAA/wAAAAAAQ05VSUFEWUFBQTEwLTIw
NzctMDFWMDEgAQBGAAAAAL8AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACqqkdMQy1GRS0x
MDBGWCAgICAgICAgMTYAAAAAAAAAAAA3HiguLjE0KTYAAAAAAAAAAAAAAAAAZgAA/8D////A//8=


--=-9au1ZU887VM6z4O/ljs0
Content-Type: application/octet-stream; name="hp_100fx_j9054c.bin"
Content-Disposition: attachment; filename="hp_100fx_j9054c.bin"
Content-Transfer-Encoding: base64

AwQHAAAAQAAAAAACAQAAAMjIAABPUE5FWFQgSU5DICAgICAgAAALQFRSRjUzMjZBTkxCNDA0ICBB
MkEgAAAASQAaAABDTjE5RFk5MDBIICAgICAgMTEwOTMwICBo8AEaAAAAAAAAAABKOTA1NEMgMTk5
MC00MTEyRv3WgEXxhuI+SFAgUHJvQ3VydmUgUHJvcHJpZXRhcnkgVGVjaG5vbG9neSAtIFVzZSBp
bXBsaWVzIGFjY2VwdGFuY2Ugb2YgbGljZW5zaW5nIHRlcm1zLkhQMTAwLUZYICAgIAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFUA9gBQAPsAjKB1MIi4eRh1MAH0YagD6P//AAr/
/wAKAnYABQH1AAYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAP4AAAAAAAAABAAAAAQAAAAEA
AAABAAAAAAAAEhYAggAdbQDQAAAAAAAAEgAAQAAAAEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACA=


--=-9au1ZU887VM6z4O/ljs0--
