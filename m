Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28EAD77267
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 21:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfGZTuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 15:50:23 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:32274 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727912AbfGZTuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 15:50:23 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: +KgnELVI3VWS1EIgZ9BGwphHFdbnaInuQdcN8tLGHVjVbcn/LYoPKgk7pJD4kRQHnzTAmeRFYh
 M0aOlGD4+8FSVo0a/74awb1VxzhntF7D6vLEuC8wM/RqJGAXOGfGvI5NnJkXN0c0oIcsNaWxZz
 AR5Z0ly0n7zC1s8HTEDDGG1ya2qXY9w3GRUC3BWrVq2lgLMjgNDdKt6pCfNR4Y2yhmYCUi05qX
 JkFNo3KhTPuZsoddTsHUiiyS62gd0XfYMawqu51Q9Ko8LWKplXY/vZjwoM1i/Vrji2tpGv3CGG
 iXY=
X-IronPort-AV: E=Sophos;i="5.64,312,1559545200"; 
   d="scan'208";a="39884861"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jul 2019 12:50:22 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 26 Jul 2019 12:50:12 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 26 Jul 2019 12:50:12 -0700
Date:   Fri, 26 Jul 2019 21:50:12 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        <roopa@cumulusnetworks.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190726195010.7x75rr74v7ph3m6m@lx-anielsen.microsemi.net>
References: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
 <7e7a7015-6072-d884-b2ba-0a51177245ab@cumulusnetworks.com>
 <eef063fe-fd3a-7e02-89c2-e40728a17578@cumulusnetworks.com>
 <20190725142101.65tusauc6fzxb2yp@soft-dev3.microsemi.net>
 <b9ce433a-3ef7-fe15-642a-659c5715d992@cumulusnetworks.com>
 <e6ad982f-4706-46f9-b8f0-1337b09de350@cumulusnetworks.com>
 <20190726120214.c26oj5vks7g5ntwu@soft-dev3.microsemi.net>
 <20190726134613.GD18223@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190726134613.GD18223@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

I'm working on the same project as Horatiu.

The 07/26/2019 15:46, Andrew Lunn wrote:
> My default, multicast should be flooded, and that includes the CPU
> port for a DSA driver. Adding an MDB entry allows for optimisations,
> limiting which ports a multicast frame goes out of. But it is just an
> optimisation.

Do you do this for all VLANs, or is there a way to only do this for VLANs that
the CPU is suppose to take part of?

I assume we could limit the behavioral to only do this for VLANs which the
Bridge interface is part of - but I'm not sure if this is what you suggest.

As you properly guessed, this model is quite different from what we are used to.
Just for the context: The ethernet switches done by Vitesse, which was acquired
by Microsemi, and now become Microchip, has until now been supported by a MIT
licensed API (running in user-space) and a protocol stack running on top of the
API. In this model we have been used to explicitly configure what packets should
go to the CPU. Typically this would be the MAC addresses of the interface it
self, multicast addresses required by the IP stack (4 and 6), and the broadcast
address. In this model, will only do this on VLANs which is configured as L3
interfaces.

We may be able to make it work by flood all multicast traffic by default, and
use a low priority CPU queue. But I'm having a hard time getting used to this
model (maybe time will help).

Is it considered required to include the CPU in all multicast flood masks? Or do
you know if this is different from driver to driver?

Alternative would it make sense to make this behavioral configurable?

/Allan
