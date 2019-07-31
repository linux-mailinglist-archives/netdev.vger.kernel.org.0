Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 192807CCED
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 21:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727084AbfGaTjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 15:39:00 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:39089 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfGaTi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 15:38:59 -0400
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: QItxWUjXxfmU58bkTu20RlW73WJdjALj2MyPDaIJfYsdwd0l/DoJQ2Z5SZzQ643YJ01xgLQGcg
 Pwd2koZ/Qv3uLxEtxpflj3G9gcFAXEFTkmVj6CtaqWU+TlVISaJz7exB7XXhELQBW9LHO9zLnk
 7D7il3cB1U6fX8IJ6wHFT9Txf2gdw9CYqdlkSLjY3LUIQmJK9RHZUg5J9BwN09EOi10zYR6G0m
 ZxiTgcXeIVbAcjpEe7JKVpOGWhrUMRWXzTrzpVa0zSonlMVTcTfqLZnP7EFDXOu5XC4Wha9Scq
 TNQ=
X-IronPort-AV: E=Sophos;i="5.64,331,1559545200"; 
   d="scan'208";a="43512647"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jul 2019 12:38:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 12:38:57 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 31 Jul 2019 12:38:56 -0700
Date:   Wed, 31 Jul 2019 21:38:57 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        <roopa@cumulusnetworks.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190731193855.sgpbvam5v2a5gkia@lx-anielsen.microsemi.net>
References: <20190729135205.oiuthcyesal4b4ct@lx-anielsen.microsemi.net>
 <e4cd0db9-695a-82a7-7dc0-623ded66a4e5@cumulusnetworks.com>
 <20190729143508.tcyebbvleppa242d@lx-anielsen.microsemi.net>
 <20190729175136.GA28572@splinter>
 <20190730062721.p4vrxo5sxbtulkrx@lx-anielsen.microsemi.net>
 <20190730143400.GO28552@lunn.ch>
 <20190730190000.diacyjw6owqkf7uf@lx-anielsen.microsemi.net>
 <20190731033156.GE9523@lunn.ch>
 <20190731080149.oyqcrw42utxjizsx@lx-anielsen.microsemi.net>
 <20190731134550.GA23028@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190731134550.GA23028@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 07/31/2019 15:45, Andrew Lunn wrote:
> > Here is how I see it:
> > 
> > Teach the SW bridge about non-IP multicast addresses. Initially the switch
> > should forward all MAC multicast frames to the CPU. Today MDB rules can be
> > installed (either static or dynamic by IGMP), which limit the flooding of IPv4/6
> > multicast streams. In the same way, we should have a way to install a rule
> > (FDM/ or MDB) to limit the flooding of L2 multicast frames.
> > 
> > If foreign interfaces (or br0 it self) is part of the destination list, then
> > traffic also needs to go to the CPU.
> > 
> > By doing this, we can for explicitly configured dst mac address:
> > - limit the flooding on the on the SW bridge interfaces
> > - limit the flooding on the on the HW bridge interfaces
> > - prevent them to go to the CPU if they are not needed
> This is all very complex because of all the different corner cases. So
> i don't think we want a user API to do the CPU part, we want the
> network stack to do it. Otherwise the user is going to get is wrong,
> break their network, and then come running to the list for help.
Not sure I really understand what to conclude from this... Their are already
many ways the user can break it (tc has great hooks for that), and I not think
we can really prevent the user in configuring something that break stuff (but
we should not make it too easy either).

Anyway, Horatiu has come a long way in creating a (surprising simple) patch
which allow us to limit the flooding of L2-multicast. It is following the
guidance from Nikolay, it is using the MDB database, and I beleive it is well
aligned with the existing sw-bridge design.

I hope it will be ready tomorrow, then we can have a look at it and see if it is
any good.

> This also fits with how we do things in DSA. There is deliberately no
> user space concept for configuring the DSA CPU port. To user space,
> the switch is just a bunch of Linux interfaces. Everything to do with
> the CPU port is hidden away in the DSA core layer, the DSA drivers,
> and a little bit in the bridge.

Understood, but as far as I understand, in DSA you still have the br0 interface,
which kind-of represent the traffic going to the CPU (like in pure SW bridge,
and SwitchDev offloaded SW-bridge).

/Allan

