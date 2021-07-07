Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C903BE0C1
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 04:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhGGCDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 22:03:14 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:34375 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbhGGCDN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 22:03:13 -0400
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id C85B0806B7;
        Wed,  7 Jul 2021 14:00:30 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1625623230;
        bh=wbNUmW5Ow/K4QAgFRW8QpAkGSlNHX8Qm9KlkXp2gcjk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=IR/srLTGnmCt24o2dxOW6Fk9kQB1NRxsZT40/lbzrTGB++b2itthdzKa5DW19XPyh
         /h06GnQgpaxSHrjuBwNcWc2XZWJJW+wz13M5et/2qjVU5S40YOQjTq8GSRRGzNCWOM
         iTASILHgiOw0aweOhdyGQaOIb0O3AEfOmFfc5Cr3diHXoSYmDpcOM0q7kMjJbJCRvp
         Q4S9ocUioVxXX8yl1QVEzkqlZ8xSbIpsk8Lgnz2vp2BL8CV3PcVftRrgccCwUupGh4
         /ONlG/8KMOTr4quqxtEvg0EbVrpqN+2NbMCjT7XB97bp+sFxFUsLI+9C9mf/HYsnMP
         kEXUWN1Qgs/5w==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60e50abe0001>; Wed, 07 Jul 2021 14:00:30 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.18; Wed, 7 Jul 2021 14:00:30 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.018; Wed, 7 Jul 2021 14:00:30 +1200
From:   Callum Sinclair <Callum.Sinclair@alliedtelesis.co.nz>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.luessing@c0d3.blue" <linus.luessing@c0d3.blue>
Subject: Re: [PATCH] net: Allow any address multicast join for IP sockets
Thread-Topic: [PATCH] net: Allow any address multicast join for IP sockets
Thread-Index: AQHXcgR3BnwxqirtmESI1bbFp3V9F6s1KEqAgAGaTzw=
Date:   Wed, 7 Jul 2021 02:00:29 +0000
Message-ID: <1625623229789.98509@alliedtelesis.co.nz>
References: <20210706011548.2201-1-callum.sinclair@alliedtelesis.co.nz>,<YORaY83GiD56/su0@lunn.ch>
In-Reply-To: <YORaY83GiD56/su0@lunn.ch>
Accept-Language: en-US, en-NZ
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=IOh89TnG c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=8nJEP1OIZ-IA:10 a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=7e5MesHCkfqdYGZJdl8A:9 a=wPNLvfGTeEIA:10 a=AjGcO6oz07-iQ99wixmX:22
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew=0A=
=0A=
Yes I want to receive all multicast frames.This is to configure=0A=
a userspace switch driver to prevent unknown multicast=0A=
routes being flooded unexpectedly to all switch ports.=0A=
=0A=
The advantage of using IP sockets over a pcap on raw sockets=0A=
is I can still use the Linux routing stack for sending and receiving=0A=
packets.=0A=
=0A=
Cheers=0A=
Callum=0A=
________________________________________=0A=
From: Andrew Lunn <andrew@lunn.ch>=0A=
Sent: Wednesday, July 7, 2021 1:28 AM=0A=
To: Callum Sinclair=0A=
Cc: dsahern@kernel.org; nikolay@nvidia.com; netdev@vger.kernel.org; linux-k=
ernel@vger.kernel.org; linus.luessing@c0d3.blue=0A=
Subject: Re: [PATCH] net: Allow any address multicast join for IP sockets=
=0A=
=0A=
On Tue, Jul 06, 2021 at 01:15:47PM +1200, Callum Sinclair wrote:=0A=
> For an application to receive all multicast packets in a range such as=0A=
> 224.0.0.1 - 239.255.255.255 each multicast IP address has to be joined=0A=
> explicitly one at a time.=0A=
>=0A=
> Allow the any address to be passed to the IP_ADD_MEMBERSHIP and=0A=
> IPV6_ADD_MEMBERSHIP socket option per interface. By joining the any=0A=
> address the socket will receive all multicast packets that are received=
=0A=
> on the interface.=0A=
>=0A=
> This allows any IP socket to be used for IGMP or MLD snooping.=0A=
=0A=
Do you really want all multicast frames, or just IGMP and MLD=0A=
messages?=0A=
=0A=
What is the advantage of this solution over using pcap with a filter=0A=
which matches on multicast?=0A=
=0A=
      Andrew=0A=
