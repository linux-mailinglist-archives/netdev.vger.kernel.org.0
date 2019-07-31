Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975AD7BB13
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfGaICA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:02:00 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:27027 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbfGaICA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 04:02:00 -0400
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
IronPort-SDR: ZmzbOwhaPBVbLZswT2Jc1Vae4Beu3VKX+zS8VdTydZyunLWLeh5/Vc5jpOeEDyc/NgslxUzFSy
 pfvUOHkg+IJMqVRW8vWUEmPJU60zDvk0ZEN8ZullWRBuu9O+ciAAhApxQbf+x01HF78madlCEi
 RFpYAsn4oGjyl0GYGfSHM4Ov4BIO65iz3IAv2RGopSJs4sUUDO/hVEmHDtw8xpnolT6bXYgsrA
 9yA3w+qrV63f7nf4nbjqX+dgScxzH7jBMxpZNeyYIpaxavefDPOO3BmL8X/8+NwPGJ1buFoY6Y
 7Es=
X-IronPort-AV: E=Sophos;i="5.64,329,1559545200"; 
   d="scan'208";a="43414617"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jul 2019 01:01:58 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 01:01:51 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 31 Jul 2019 01:01:50 -0700
Date:   Wed, 31 Jul 2019 10:01:50 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Ido Schimmel <idosch@idosch.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        <roopa@cumulusnetworks.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190731080149.oyqcrw42utxjizsx@lx-anielsen.microsemi.net>
References: <20190729131420.tqukz55tz26jkg73@lx-anielsen.microsemi.net>
 <3cc69103-d194-2eca-e7dd-e2fa6a730223@cumulusnetworks.com>
 <20190729135205.oiuthcyesal4b4ct@lx-anielsen.microsemi.net>
 <e4cd0db9-695a-82a7-7dc0-623ded66a4e5@cumulusnetworks.com>
 <20190729143508.tcyebbvleppa242d@lx-anielsen.microsemi.net>
 <20190729175136.GA28572@splinter>
 <20190730062721.p4vrxo5sxbtulkrx@lx-anielsen.microsemi.net>
 <20190730143400.GO28552@lunn.ch>
 <20190730190000.diacyjw6owqkf7uf@lx-anielsen.microsemi.net>
 <20190731033156.GE9523@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20190731033156.GE9523@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 07/31/2019 05:31, Andrew Lunn wrote:
> The PDF you linked to suggests this as well. But i think you will need
> to make some core changes to the bridge. At the moment, STP is a
> bridge level property. But you are going to need it to be a per-port
> option. You can then use DLR on the ring ports, and optionally STP on
> the other ports.
I think you are right. I have not looked into the details of this. Our plan was
to not implement this to begin with. This will mean that it cannot act as a
gateway until this is done. But it still has good value to be able to implement
a DLR ring node.

> > But what we are looking at here, is to offload a
> > non-aware-(DLR|MRP)-switch which happens to be placed in a network
> > with these protocols running.
> 
> So we need to think about why we are passing traffic to the CPU port,
> and under what conditions can it be blocked.
> 
> 1) The interface is not part of a bridge. In this case, we only need
> the switch to pass to the CPU port MC addresses which have been set
> via set_rx_mode().
Yes. In our HW we are using the MAC table to do this, but this is an
implementation detail.

> I think this case does not apply for what you want. You have two ports
> bridges together as part of the ring.
Correct.

> 2) The interface is part of a bridge. There are a few sub-cases
> 
> a) IGMP snooping is being performed. We can block multicast where
> there is no interest in the group. But this is limited to IP
> multicast.
Agree. And this is done today by installing an explicit offload rule to limit
the flooding of a specific group.

> b) IGMP snooping is not being used and all interfaces in the bridge
> are ports of the switch. IP Multicast can be blocked to the CPU.
Does it matter if IGMP snooping is used or not? A more general statement could
be:

- "All interfaces in the bridge are ports of the switch. IP Multicast can be
  blocked to the CPU."

This assumes that if br0 joins a IP multicast group, then the needed MAC
addresses is added via the set_rx_mode (which I'm pretty sure is the case.

Or much more aggressive (which is where we started this entire discussion):

- "All interfaces in the bridge are ports of the switch. All Multicast (except
  ff:ff:ff:ff:ff:ff, 33:33:xx:xx:xx:xx, 01:80:C2:xx:xx:xx) can be blocked to the
  CPU."

But then we are back to having the need of requesting additional L2-multicast
mac addresses to the CPU. This has been discussed, and I do not want to re-start
the discussion, just wanted to mention it to have the complete picture.

> c) IGMP snooping is not being used and there is a non-switch interface
> in the bridge. Multicast needed is needed, so it can be flooded out
> this port.
Yes. And L2-multicast also always needs to go to the CPU regardless of IGMP.

> d) set_rx_mode() has been called on the br0 interface, indicating
> there is interest in the packets on the host. They must be sent to the
> CPU so they can be delivered locally.
Yes - but today set_rx_mode is not doing anything on br0. This was one problem
we had a few days ago, when we did not forward all traffic to the CPU by
default.

When looking at these cases, I'm not sure it matters if IGMP snooping is running
or not.

Here is how I understand what you say:

              || Foreign interfaces   |  No Foreign interfaces
==============||======================|=========================
IGMP Snoop on || IP-Multicast must    |  IP-Multicast is not needed
              || go to CPU by default |  in the CPU (by default*)
--------------||----------------------|-------------------------
IGMP Snoop off|| IP-Multicast must    |  IP-Multicast is not needed 
              || go to CPU by default |  in the CPU (by default*)

* This assumes that set_rx_mode starts to do something for the br0 interface
  (which does not seem to be the case right now - see br_dev_set_multicast_list).


> e) ????
e) Another case to consider is similar to d), but with VLANs. Assume that
br0.100 joins a IP-Multicast group, which will cause set_rx_mode() to be called.
As I read the code (I have not tried it, so I might have gotten this wrong),
then we loose the VLAN information, because the mc list is not VLAN aware.

This means that if br0.100 joins a group, then we will get that group for all
VLANs.

Maybe it is better (for now) to hold on to the exiting behavioral and let all
multicast go to the CPU by default, leave br_dev_set_multicast_list empty, use
IGMP snooping to optimize the flooding, and hopefully we will have a way to
limit the L2-multicast flooding as an optimization which can be applied to
"noisy" l2 multicast streams.

> Does the Multicast MAC address being used by DLR also map to an IP
> mmulticast address?
No.

> 01:21:6C:00:00:0[123] appear to be the MAC addresses used by DLR.
Yes.

> IPv4 multicast MAC addresses are 01:00:5E:XX:XX:XX. IPv6 multicast MAC
> addresses are 33:33:XX:XX:XX:XX.
Yes, and there are no overlap.

> So one possibility here is to teach the SW bridge about non-IP
> multicast addresses. Initially the switch should forward all MAC
> multicast frames to the CPU. If the frame is not an IPv4 or IPv6
> frame, and there has not been a call to set_rx_mode() for the MAC
> address on the br0 interface, and the bridge only contains switch
> ports, switchdev could be used to block the multicast to the CPU
> frame, but forward it out all other ports of the bridge.
Close, but not exactly (due to the arguments above).

Here is how I see it:

Teach the SW bridge about non-IP multicast addresses. Initially the switch
should forward all MAC multicast frames to the CPU. Today MDB rules can be
installed (either static or dynamic by IGMP), which limit the flooding of IPv4/6
multicast streams. In the same way, we should have a way to install a rule
(FDM/ or MDB) to limit the flooding of L2 multicast frames.

If foreign interfaces (or br0 it self) is part of the destination list, then
traffic also needs to go to the CPU.

By doing this, we can for explicitly configured dst mac address:
- limit the flooding on the on the SW bridge interfaces
- limit the flooding on the on the HW bridge interfaces
- prevent them to go to the CPU if they are not needed


-- 
/Allan
