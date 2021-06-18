Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4689D3ABFF8
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 02:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233160AbhFRAJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 20:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhFRAJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 20:09:44 -0400
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBBBC06175F
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 17:07:35 -0700 (PDT)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 59EFD83640;
        Fri, 18 Jun 2021 12:07:32 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1623974852;
        bh=+07IlSklUmPcgzKduXHVzbGqBXwvqB3Nv5171K+zRY8=;
        h=From:To:CC:Subject:Date:References:In-Reply-To;
        b=kiGZSQyJP1RxEROwEwKTfkxaiMaHkpc1niDeV0dyyT0ZdVwvBk9R1utPWt1jm/ACY
         xDyFKtokMMqHel+Lp8KHvNzATkKHy7MiYDkLFUOVhT8GHTFuVM2gIM4zeDE8Bmq5sE
         UW9fV8gGQE9uLhnvY1Nle+GVAuBIGngrNsP79HpcdO7gr1Jl8VBYL/G9iJPrFl1Tl1
         hulgn3PR59VFP8siO9XCF9fEp+cjKa9yDenU3sUKtzSmpqtI/xb/oR/4CZIOAK5jSe
         oQmndfRIyjLgO12YVI6ZDxGd0rAA36XBMOXatyVFHmkPrRY0aBEs2SIaDLbV35L7zh
         9a5QPF2PjGWKw==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B60cbe3c40001>; Fri, 18 Jun 2021 12:07:32 +1200
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.18; Fri, 18 Jun 2021 12:07:32 +1200
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.018; Fri, 18 Jun 2021 12:07:32 +1200
From:   Callum Sinclair <Callum.Sinclair@alliedtelesis.co.nz>
To:     =?iso-8859-1?Q?Linus_L=FCssing?= <linus.luessing@c0d3.blue>
CC:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "troglobit@gmail.com" <troglobit@gmail.com>
Subject: Re: [PATCH 1/1] net: Allow all multicast packets to be received on a
 interface.
Thread-Topic: [PATCH 1/1] net: Allow all multicast packets to be received on a
 interface.
Thread-Index: AQHXY15AjPZKD1gBPUW680Mm+Pg7t6sXWfSAgAGJCPo=
Date:   Fri, 18 Jun 2021 00:07:31 +0000
Message-ID: <1623974851907.12252@alliedtelesis.co.nz>
References: <20210617095020.28628-1-callum.sinclair@alliedtelesis.co.nz>
 <20210617095020.28628-2-callum.sinclair@alliedtelesis.co.nz>,<20210617123309.GB2262@otheros>
In-Reply-To: <20210617123309.GB2262@otheros>
Accept-Language: en-US, en-NZ
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=IOh89TnG c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=8nJEP1OIZ-IA:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=pGLkceISAAAA:8 a=62ntRvTiAAAA:8 a=yN1wWpkmAAAA:20 a=GcyzOjIWAAAA:8 a=un4XpZGWLvRxKXY6vKIA:9 a=wPNLvfGTeEIA:10 a=AjGcO6oz07-iQ99wixmX:22 a=pToNdpNmrtiFLRE6bQ9Z:22 a=hQL3dl6oAZ8NdCsdz28n:22
X-SEG-SpamProfiler-Score: 0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus =0A=
=0A=
> I'm also wondering if it could be useful to configure it via=0A=
> setsockopt() per application instead of per device via sysctl. Either by=
=0A=
> adding a new socket option. Or by allowing the any IP address=0A=
> 0.0.0.0 / :: with IP_ADD_MEMBERSHIP/IPV6_JOIN_GROUP. So that you=0A=
> could use this for instance:=0A=
=0A=
Yes perhaps this would be a better way to get multicast snooping working wi=
th the existing=0A=
options. I can see that using a multicast routing IP socket I will receive =
all IGMP and MLD=0A=
data from that. I was just not creating the socket as a multicast routing s=
ocket.=0A=
=0A=
> Or would you prefer to be able to use a layer 3 IP instead of=0A=
> a layer 2 packet socket?=0A=
=0A=
Yes I was preferring to use a L3 IP socket instead of a L2 packet socket. T=
his was to have=0A=
access to additional data from IP_PKTINFO.=0A=
=0A=
Cheers=0A=
Callum=0A=
________________________________________=0A=
From: Linus L=FCssing <linus.luessing@c0d3.blue>=0A=
Sent: Friday, June 18, 2021 12:33 AM=0A=
To: Callum Sinclair=0A=
Cc: dsahern@kernel.org; nikolay@nvidia.com; netdev@vger.kernel.org; linux-k=
ernel@vger.kernel.org; troglobit@gmail.com=0A=
Subject: Re: [PATCH 1/1] net: Allow all multicast packets to be received on=
 a interface.=0A=
=0A=
Hi Callum,=0A=
=0A=
On Thu, Jun 17, 2021 at 09:50:20PM +1200, Callum Sinclair wrote:=0A=
> +mc_snooping - BOOLEAN=0A=
> +     Enable multicast snooping on the interface. This allows any given=
=0A=
> +     multicast group to be received without explicitly being joined.=0A=
> +     The kernel needs to be compiled with CONFIG_MROUTE and/or=0A=
> +     CONFIG_IPV6_MROUTE.=0A=
> +     conf/all/mc_snooping must also be set to TRUE to enable multicast=
=0A=
> +     snooping for the interface.=0A=
> +=0A=
=0A=
Generally this sounds like a useful feature. One note: When there=0A=
are snooping bridges/switches involved, you might run into issues=0A=
in receiving all multicast packets, as due to the missing IGMP/MLD=0A=
reports the snooping switches won't forward to you.=0A=
=0A=
In that case, to conform to RFC4541 you would also need to become=0A=
the selected IGMP/MLD querier and send IGMP/MLD query messages. Or=0A=
better, you'd need to send Multicast Router Advertisements=0A=
(RFC4286). The latter is the recommended, more flexible way but=0A=
might not be supported by all multicast snooping switches yet.=0A=
The Linux bridge supports this.=0A=
=0A=
There is a userspace tool called mrdisc you can use for MRD-Adv.=0A=
though: https://scanmail.trustwave.com/?c=3D20988&d=3Dn8HL4MpWu6CIvz405pawl=
YFbPjGsj-TvRIl7ADnUOg&u=3Dhttps%3a%2f%2fgithub%2ecom%2ftroglobit%2fmrdisc S=
o no need to=0A=
implement MRD Advertisements in the kernel with this patch (though=0A=
I could imagine that it might be a useful feature to have, having=0A=
MRD support out-of-the-box with this option). Just a note that some=0A=
IGMP/MLD Querier or MRD Adv. would be needed when IGMP/MLD snooping=0A=
switches are invoved might be nice to have in the mc_snooping=0A=
description for now, to avoid potential confusion later.=0A=
=0A=
=0A=
I'm also wondering if it could be useful to configure it via=0A=
setsockopt() per application instead of per device via sysctl. Either by=0A=
adding a new socket option. Or by allowing the any IP address=0A=
0.0.0.0 / :: with IP_ADD_MEMBERSHIP/IPV6_JOIN_GROUP. So that you=0A=
could use this for instance:=0A=
=0A=
$ socat -u UDP6-RECV:1234,reuseaddr,ipv6-join-group=3D"[::]:eth0" -=0A=
(currently :: fails with "Invalid argument")=0A=
=0A=
I'm not sure however what the requirements for adding or extending=0A=
socket options are, if there are some POSIX standards that'd need=0A=
to be followed for compatibility with other OSes, for instance.=0A=
=0A=
=0A=
Hm, actually, I just noticed that there seem to be some multicast=0A=
related setsockopt()s already:=0A=
=0A=
- PACKET_MR_PROMISC=0A=
- PACKET_MR_MULTICAST=0A=
- PACKET_MR_ALLMULTI=0A=
=0A=
The last one seems to be what you are looking for, I think, the=0A=
manpage here says:=0A=
=0A=
"PACKET_MR_ALLMULTI sets the socket up to receive all multicast=0A=
packets arriving at the interface"=0A=
https://scanmail.trustwave.com/?c=3D20988&d=3Dn8HL4MpWu6CIvz405pawlYFbPjGsj=
-TvRI4qVzmDbA&u=3Dhttps%3a%2f%2fwww%2eman7%2eorg%2flinux%2fman-pages%2fman7=
%2fpacket%2e7%2ehtml=0A=
=0A=
Or would you prefer to be able to use a layer 3 IP instead of=0A=
a layer 2 packet socket?=0A=
=0A=
Regards, Linus=0A=
