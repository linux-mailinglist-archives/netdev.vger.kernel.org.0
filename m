Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E55A1B2B
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 15:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfH2NPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 09:15:46 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:60130 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726985AbfH2NPq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 09:15:46 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: LVVPYNRxoXDMkjsyYYima6lNDU5014Lyucej41eTWz1ChCuuVdtKMR++Bys9CK6oG2xLmivLI4
 F+h+9LIRvE4HTH04qLTZnNfj47nl7EfNwPulVgIdhTkjrAslsbaNmLzuTLp7HB+WAM0C9lYV4N
 1nqLCVUgGkuQJx2+yqNAd97s/3RKll+vGGDhmZqUgMonbTY3TZhmFbEXcGjY5u/Oc9Jm6QtJhR
 Iu5j7zvib2ZWVjFwXEQlGX2EkYarPm1yFbLJ3xB7ljiNR0lQ85ZuyMhLOLsXjGdxGJmcBd1AxE
 jJI=
X-IronPort-AV: E=Sophos;i="5.64,443,1559545200"; 
   d="scan'208";a="46080980"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Aug 2019 06:15:45 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 29 Aug 2019 06:15:45 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 29 Aug 2019 06:15:42 -0700
Date:   Thu, 29 Aug 2019 15:15:43 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Ivan Vecera <ivecera@redhat.com>
CC:     Jiri Pirko <jiri@resnulli.us>, <alexandre.belloni@bootlin.com>,
        <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <andrew@lunn.ch>, <allan.nielsen@microchip.com>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] net: core: Notify on changes to dev->promiscuity.
Message-ID: <20190829131541.4ptg5bf3ew7iczpm@soft-dev3.microsemi.net>
References: <1567070549-29255-1-git-send-email-horatiu.vultur@microchip.com>
 <1567070549-29255-2-git-send-email-horatiu.vultur@microchip.com>
 <20190829095100.GH2312@nanopsycho>
 <20190829105650.btgvytgja63sx6wx@soft-dev3.microsemi.net>
 <20190829121811.GI2312@nanopsycho>
 <20190829124412.nrlpz5tzx3fkdoiw@soft-dev3.microsemi.net>
 <20190829145518.393fb99d@ceranb>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190829145518.393fb99d@ceranb>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 08/29/2019 14:55, Ivan Vecera wrote:
> External E-Mail
> 
> 
> On Thu, 29 Aug 2019 14:44:14 +0200
> Horatiu Vultur <horatiu.vultur@microchip.com> wrote:
> 
> > When a port is added to a bridge, then the port gets in promisc mode.
> > But in our case the HW has bridge capabilities so it is not required
> > to set the port in promisc mode.
> > But if someone else requires the port to be in promisc mode (tcpdump
> > or any other application) then I would like to set the port in promisc
> > mode.
> > In previous emails Andrew came with the suggestion to look at
> > dev->promiscuity and check if the port is a bridge port. Using this
> > information I could see when to add the port in promisc mode. He also
> > suggested to add a new switchdev call(maybe I missunderstood him, or I
> > have done it at the wrong place) in case there are no callbacks in the
> > driver to get this information.
> 
Hi Ivan,

> I would use the 1st suggestion.
> 
> for/in your driver:
> if (dev->promiscuity > 0) {
> 	if (dev->promiscuity == 1 && netif_is_bridge_port(dev)) {
> 		/* no need to set promisc mode because promiscuity
> 		 * was requested by bridge
> 		 */
> 		...
> 	} else {
> 		/* need to set promisc mode as someone else requested
> 		 * promiscuity
> 		 */
> 	}
> }

Yes that was my first try. It worked for many cases but there was one
which it didn't work.
If first add the port to the bridge, then you get callbacks and
notifications in the driver where you can use the code that you
suggested. But if next you enable promisc mode on the port (ip link set
dev eth0 promisc on), then the driver will not get any callbacks or
notifications. Therefore it could not see the new value of
dev->promiscuity to update the HW.
The code that updates the promisc mode it would not notify in case
the promiscuity is changed and because the port has already the flag
IFF_PROMISC it would not notify any listeners because the flags are not
changed.
Here [1] is the code that I refer to.

[1] https://elixir.bootlin.com/linux/latest/source/net/core/dev.c#L7592

> 
> Thanks,
> Ivan
> 

-- 
/Horatiu
