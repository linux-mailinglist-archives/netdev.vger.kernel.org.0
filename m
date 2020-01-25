Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F6414943D
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 10:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgAYJop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 04:44:45 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:28090 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgAYJop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 04:44:45 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: Lh8yQdurjZs3o4O+e1/dtVa3BU0CKjyydNPB9yKjf1W8sczquG1tAKVRK4NEVTHAg9xZpFyfVZ
 1kWOVQ/R4AvqpBwmRBiXRp8aZ8YMC52EQnCeVzlploxuH4d6AMpucNDD4wT6Om8JPlPXrfhref
 976JLtYHUUpDzBaKv8eri0e5ik21ncAlgEP95gwSCvLxnDAQn9cvO9ZY0dRWGjZUSDyRIx1ky2
 WGwtVA4T/SyLNZn+x2bhgafjr9WwQLpcNPQNZ6l1oPaFWb3tgqxCor66MU/cH30AFPJ3In9N0E
 ADQ=
X-IronPort-AV: E=Sophos;i="5.70,361,1574146800"; 
   d="scan'208";a="65983634"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jan 2020 02:44:42 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 25 Jan 2020 02:44:43 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sat, 25 Jan 2020 02:44:42 -0700
Date:   Sat, 25 Jan 2020 10:44:41 +0100
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <andrew@lunn.ch>, <jeffrey.t.kirsher@intel.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 00/10]  net: bridge: mrp: Add support for Media
 Redundancy Protocol (MRP)
Message-ID: <20200125094441.kgbw7rdkuleqn23a@lx-anielsen.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124203406.2ci7w3w6zzj6yibz@lx-anielsen.microsemi.net>
 <87zhecimza.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <87zhecimza.fsf@linux.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On 24.01.2020 13:05, Vinicius Costa Gomes wrote:
>I have one idea and one question.

Let me answer the question before dicussing the idea.

>The question that I have is: what's the relation of IEC 62439-2 to IEEE
>802.1CB?
HSR and 802.1CB (often called FRER - Frame Replication and Elimination
for Reliability) shares a lot of functionallity. It is a while since I
read the 802.1CB standard, and I have only skimmed the HSR standard, but
as far as I understand 802.1CB is a super set of HSR. Also, I have not
studdied the HSR implementation.

Both HSR and 802.1CB replicate the frame and eliminate the additional
copies. If just 1 of the replicated fraems arrives, then higher layer
applications will not see any traffic lose.

MRP is different, it is a ring protocol, much more like ERPS defined in
G.8032 by ITU. Also, MRP only make sense in switches, it does not make
sense in a host (like HSR does).

In MRP, the higher layer application frames are not replicated. They are
send on either 1 port or the other.

Consider this exaple, with 3 nodes creating a ring. All notes has a br0
device which includes the 2 NICs.

     +------------------------------------------+
     |                                          |
     +-->|H1|<---------->|H2|<---------->|H3|<--+
     eth0    eth1    eth0    eth1    eth0    eth1

Lets say that H1 is the manager (MRM), and H2 + H3 is the client (MRC).

The MRM will now block one of the ports, lets say eth0, to prevent a
loop:

     +------------------------------------------+
     |                                          |
     +-->|H1|<---------->|H2|<---------->|H3|<--+
     eth0    eth1    eth0    eth1    eth0    eth1
      ^
      |
   Blocked


This mean that H1 can reach H2 and H3 via eth1
This mean that H2 can reach H1 eth0
This mean that H2 can reach H3 eth1
This mean that H3 can reach H1 and H2 via eth0

This is normal forwarding, doen by the MAC table.

Lets say that the link between H1 and H2 goes down:

     +------------------------------------------+
     |                                          |
     +-->|H1|<---  / --->|H2|<---------->|H3|<--+
     eth0    eth1    eth0    eth1    eth0    eth1

H1 will now observe that the test packets it sends on eth1, is not
received in eth0, meaninf that the ring is open, and it will unblock the
eth0 device, and send a message to all the nodes that they need to flush
the mac-table.

This mean that H1 can reach H2 and H3 via eth0
This mean that H2 can reach H1 and H3 via eth1
This mean that H3 can reach H2 eth0
This mean that H3 can reach H1 eth1

In all cases, higher layer application will use the br0 device to send
and receive frames. These higher layer applications will not see any
interruption (except during the few milliseconds it takes to unblock, and
flush the mac tables).

Sorry for the long explanation, but it is important to understand this
when discussion the design.

>The idea is:
>
>'net/hsr' already has a software implementation of the HSR replication
>tag (and some of the handling necessary). So what came to mind is to
>add the necessary switchdev functions to the master HSR device. If
>that's done, then it sounds that the rest will mostly work.
Maybe something could be done here, but it will not help MRP, as they do
not really share any functionality ;-)

>For the user the flow would be something like:
> - User takes two (or more interfaces) and set them as slaves of the HSR
>   master device, say 'hsr0';
> - 'hsr0' implements some of the switchdev functionality so we can use
>   the MRP userspace components on it;
For MRP to work, it really need the bridge interface, and the higher
layer applications needs to use the br0 device.

>Does it look like something that could work?
It would make much more sense if we discussed implementing 802.1CB in
some form (which we might get to).

/Allan

