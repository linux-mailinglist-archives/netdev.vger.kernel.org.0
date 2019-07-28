Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE58978105
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 21:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbfG1TQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 15:16:03 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:21211 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfG1TQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 15:16:02 -0400
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: nfVslRGlBP3jSD2/UOVCrH3bTtjdhYH/82SxjIu63midTzY8YUXbqMoj7viNJdGHsF1KVVaz3Q
 +gEMNrJC+OpQKMOmYTapnlPiEoc+e3uaix2PLhUn2hVnfwwJkhht3lYDMfMWRouDlsAK0kX6yJ
 OLKhlE+N3jh8Tj74ADcIq8JPQknNlypNwFwE/U0d5cZahCPmoWRrblPGqCbhSG4RUMY6XUrbNB
 ntoqk2QOt5bkSdwDAZ850QOcGc1O1zeLoCqvAvooYREQvFFR692Ynie+kq1l+9qThVSphe1JzR
 YaE=
X-IronPort-AV: E=Sophos;i="5.64,319,1559545200"; 
   d="scan'208";a="41428814"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Jul 2019 12:16:01 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.87.152) by
 chn-vm-ex04.mchp-main.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 28 Jul 2019 12:16:00 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sun, 28 Jul 2019 12:16:00 -0700
Date:   Sun, 28 Jul 2019 21:15:59 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        <roopa@cumulusnetworks.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190728191558.zuopgfqza2iz5d5b@lx-anielsen.microsemi.net>
References: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
 <7e7a7015-6072-d884-b2ba-0a51177245ab@cumulusnetworks.com>
 <eef063fe-fd3a-7e02-89c2-e40728a17578@cumulusnetworks.com>
 <20190725142101.65tusauc6fzxb2yp@soft-dev3.microsemi.net>
 <b9ce433a-3ef7-fe15-642a-659c5715d992@cumulusnetworks.com>
 <e6ad982f-4706-46f9-b8f0-1337b09de350@cumulusnetworks.com>
 <20190726120214.c26oj5vks7g5ntwu@soft-dev3.microsemi.net>
 <20190726134613.GD18223@lunn.ch>
 <20190726195010.7x75rr74v7ph3m6m@lx-anielsen.microsemi.net>
 <20190727030223.GA29731@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190727030223.GA29731@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 07/27/2019 05:02, Andrew Lunn wrote:
> > As you properly guessed, this model is quite different from what we are used to.
> 
> Yes, it takes a while to get the idea that the hardware is just an
> accelerator for what the Linux stack can already do. And if the switch
> cannot do some feature, pass the frame to Linux so it can handle it.
This is understood, and not that different from what we are used to.

The surprise was to make all multicast traffic to go to the CPU.

> You need to keep in mind that there could be other ports in the bridge
> than switch ports, and those ports might be interested in the
> multicast traffic. Hence the CPU needs to see the traffic.
This is a good argument, but I was under the impression that not all HW/drivers
supports foreign interfaces (see ocelot_netdevice_dev_check and
mlxsw_sp_port_dev_check).

> But IGMP snooping can be used to optimise this.
Yes, IGMP snooping can limit the multicast storm of multicast IP traffic, but
not for L2 non-IP multicast traffic.

We could really use something similar for non-IP multicast MAC addresses.

Trying to get back to the original problem:

We have a network which implements the ODVA/DLR ring protocol. This protocol
sends out a beacon frame as often as every 3 us (as far as I recall, default I
believe is 400 us) to this MAC address: 01:21:6C:00:00:01.

Try take a quick look at slide 10 in [1].

If we assume that the SwitchDev driver implemented such that all multicast
traffic goes to the CPU, then we should really have a way to install a HW
offload path in the silicon, such that these packets does not go to the CPU (as
they are known not to be use full, and a frame every 3 us is a significant load
on small DMA connections and CPU resources).

If we assume that the SwitchDev driver implemented such that only "needed"
multicast packets goes to the CPU, then we need a way to get these packets in
case we want to implement the DLR protocol.

I'm sure that both models can work, and I do not think that this is the main
issue here.

Our initial attempt was to allow install static L2-MAC entries and append
multiple ports to such an entry in the MAC table. This was rejected, for several
good reasons it seems. But I'm not sure it was clear what we wanted to achieve,
and why we find it to be important. Hopefully this is clear with a real world
use-case.

Any hints or ideas on what would be a better way to solve this problems will be
much appreciated.

/Allan

[1] https://www.odva.org/Portals/0/Library/Conference/2017-ODVA-Conference_Woods_High%20Availability_Guidelines%20for%20Use%20of%20DLR%20in%20EtherNetIP%20Networks_FINAL%20PPT.pdf
