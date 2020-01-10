Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DFA21374C4
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 18:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgAJRZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 12:25:39 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:59833 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgAJRZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 12:25:38 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: pvcClhOlqaI0EMVWXM/DKN4Vp1ybNbncbeoZfVLwSYsn1My5lvN0gAOR/D86Vk2jFrj9WCFGuM
 GTO6IvJnVUjfLy7MoAS/NhTdYwhRWs+Z18d1kFE+NxEKZxWenKULWNmLrKnUSbEhN17ERiFPQk
 KyRxZIcNFrv0/b7gkMD+slgicuZ3ucW+bV6BTkT+XYwAnO54gZy/bfFIolJk5w//yhCCu75JKS
 swpEkV8EnOasrSxeO1FTTZetjdQ5bBxBn2nbwHdf+dmzH8bdgPeFL76fCfXyYtfiDSwFn9Ebh2
 XXs=
X-IronPort-AV: E=Sophos;i="5.69,417,1571727600"; 
   d="scan'208";a="64340904"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jan 2020 10:25:37 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 10 Jan 2020 10:25:36 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 10 Jan 2020 10:25:35 -0700
Date:   Fri, 10 Jan 2020 18:25:36 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        <anirudh.venkataramanan@intel.com>,
        David Ahern <dsahern@gmail.com>,
        "Jiri Pirko" <jiri@mellanox.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next Patch 0/3] net: bridge: mrp: Add support for Media
 Redundancy Protocol(MRP)
Message-ID: <20200110172536.42rdfwdc6eiwsw7m@soft-dev3.microsemi.net>
References: <20200109150640.532-1-horatiu.vultur@microchip.com>
 <6f1936e9-97e5-9502-f062-f2925c9652c9@cumulusnetworks.com>
 <20200110160456.enzomhfsce7bptu3@soft-dev3.microsemi.net>
 <CA+h21hrq7U4EdqSgpYQRjK8rkcJdvD5jXCSOH_peA-R4xCocTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CA+h21hrq7U4EdqSgpYQRjK8rkcJdvD5jXCSOH_peA-R4xCocTg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Valdimir and Andrew

The 01/10/2020 18:21, Vladimir Oltean wrote:
> I think it would help your case if you explained a bit more about the
> hw offload primitives you have implemented internally. I believe you
> are talking about the frame generation engine in the Ocelot switch
> which has 1024 frame slots that are periodically sent based on one of
> 8 timers. For receive, I believe that the functionality is to offload
> the consumption of these periodic frames, and just raise an interrupt
> if frames were expected but not received.
Yes something like this. But it is worth mention that it is not just about
injecting frames, sequence number needs to be incremented (by HW) etc.

> For your use case of MRP, it makes perfect sense to have this. I am
> just not sure (and not knowledgeable enough in Linux) what this engine
> is offloading from the operating system's perspective.
We will try to make that more clear.

> Your justification for implementing MRP in the kernel seems to be that
> it's better to make MRP part of the kernel uapi than a configuration
> interface for your periodic engine, which in principle I agree with.
> I'm just not sure if the offload that you propose will have a trivial
> path into the kernel either, so it would make sense for reviewers to
> see everything put together first.
You are right. The decision of start by publishing a pure SW implementation with
no HW offload was not the best.

I can do a new RFC that does including the HW offload hooks, and
describe what configurations we do when these hooks are called. The
actual HW which implements these hooks is still not released (and the
SwitchDev driver for this device is still not submitted).

> Horatiu, could you also give some references to the frames that need
> to be sent. I've no idea what information they need to contain, if the
> contents is dynamic, or static, etc.
It is dynamic - but trivial... Here is a dump from WireShark with
annotation on what our HW can update:

Ethernet II, Src: 7a:8b:b1:35:96:e1 (7a:8b:b1:35:96:e1), Dst: Iec_00:00:01 (01:15:4e:00:00:01)
    Destination: Iec_00:00:01 (01:15:4e:00:00:01)
    Source: 7a:8b:b1:35:96:e1 (7a:8b:b1:35:96:e1)
    Type: MRP (0x88e3)
PROFINET MRP MRP_Test, MRP_Common, MRP_End
    MRP_Version: 1
    MRP_TLVHeader.Type: MRP_Test (0x02)
        MRP_TLVHeader.Type: MRP_Test (0x02)
        MRP_TLVHeader.Length: 18
        MRP_Prio: 0x1f40 High priorities
        MRP_SA: 7a:8b:b1:35:96:e1 (7a:8b:b1:35:96:e1)
        MRP_PortRole: Primary ring port (0x0000)
        MRP_RingState: Ring closed (0x0001)
        MRP_Transition: 0x0001
        MRP_TimeStamp [ms]: 0x000cf574             <---------- Updated automatic
    MRP_TLVHeader.Type: MRP_Common (0x01)
        MRP_TLVHeader.Type: MRP_Common (0x01)
        MRP_TLVHeader.Length: 18
        MRP_SequenceID: 0x00e9                     <---------- Updated automatic
        MRP_DomainUUID: ffffffff-ffff-ffff-ffff-ffffffffffff
    MRP_TLVHeader.Type: MRP_End (0x00)
        MRP_TLVHeader.Type: MRP_End (0x00)
        MRP_TLVHeader.Length: 0

But all the fields can change, but to change the other fields we need to
interact with the HW. Other SoC may have other capabilities in their
offload. As an example, if the ring becomes open then the fields
MRP_RingState and MRP_Transition need to change and in our case this
requires SW interference.

Would you like a PCAP file as an example? Or do you want a better
description of the frame format.

/Horatiu
