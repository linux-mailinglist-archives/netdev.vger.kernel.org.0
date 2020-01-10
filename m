Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 168FD1377E4
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 21:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgAJUZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 15:25:05 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:55555 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgAJUZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 15:25:05 -0500
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: rsu/XetFyvWK7mxD9x59OkwZl1lD/XF7oQMUNOHCU5uG9Bx4QJ5mRDNRhUIkxMSD8AeTk55ifw
 T7sB/kqBQ576Lnxg0ilNvndgT9R3hXSyxzQlOPQPiq7cPnJ4O01NZgY8BU2jWOO7It2RwzkmD6
 m51OL9I4ZroytPvlRILbTE8272a2Z11ncBR26JDerz1ZYXCviop3x5vIXODSKrncrS2rRww+yz
 woSq5eQ/pVS0kG+wITBoSuxd1k5ntZN36aJkF0OvGejv+bEk58VurCRNWiSQDtdC8YmqvT1pcr
 35g=
X-IronPort-AV: E=Sophos;i="5.69,418,1571727600"; 
   d="scan'208";a="62274303"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jan 2020 13:25:01 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 10 Jan 2020 13:24:56 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 10 Jan 2020 13:24:56 -0700
Date:   Fri, 10 Jan 2020 21:24:55 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>
CC:     David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        <roopa@cumulusnetworks.com>, <jakub.kicinski@netronome.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <jeffrey.t.kirsher@intel.com>, <olteanv@gmail.com>,
        <anirudh.venkataramanan@intel.com>, <dsahern@gmail.com>,
        <jiri@mellanox.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next Patch 0/3] net: bridge: mrp: Add support for Media
 Redundancy Protocol(MRP)
Message-ID: <20200110202455.vku455ioa7vaj4dn@soft-dev3.microsemi.net>
References: <20200109150640.532-1-horatiu.vultur@microchip.com>
 <6f1936e9-97e5-9502-f062-f2925c9652c9@cumulusnetworks.com>
 <20200110.112736.1849382588448237535.davem@davemloft.net>
 <3CD4F75F-C462-4CF2-B31A-C2E023D3F065@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <3CD4F75F-C462-4CF2-B31A-C2E023D3F065@cumulusnetworks.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >With a userland implementation, what approach do you suggest for
> >DSA/switchdev offload
> >of this stuff?
> 
> Good question, there was no mention of that initially, or I missed it at least.
> There aren't many details about what/how will be offloaded right now.
> We need more information about what will be offloaded and how it will fit.
I think we should do a new version of the RFC-Patch with the hooks to
offload included. Just the signatures and the invocations should give
the context we are missing in the discussion.

Depending on how the discussion goes from there, we can then either work
on putting this in user-space or fix the issues pointed out in the
original attempt.

/Horatiu
