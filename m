Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D007FBF6
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 16:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392281AbfHBOV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 10:21:26 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:31347 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbfHBOVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 10:21:25 -0400
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
IronPort-SDR: GCbs4HhKendHnRbMGJAONbk3N3gVm+0wZSpYIe+2WLnfq3h+QPj0augdmikggvzmmaZ0rKXWjX
 pq17vcenZQUHG0iUTqQpJ5au8EGXjKUlGrivcSiYeYzRAk/pvVdkovnv24IvokfRLNCWuchtM2
 JBxBmI7JbAnI+J+AwZuXGbOvZInA+g6Pjq1PS0rQXzrwDYZPOMvUMgy76PKj518S4wadnBc9Vw
 R61saa63eYH+/RwO18XCPu2Sx9h2vzRPUQeD2c78CpzRhP1dQMPbaF0Bs9CJyXrInjpmS1qp42
 qhw=
X-IronPort-AV: E=Sophos;i="5.64,338,1559545200"; 
   d="scan'208";a="43769138"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Aug 2019 07:21:24 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 2 Aug 2019 07:21:16 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Fri, 2 Aug 2019 07:21:16 -0700
Date:   Fri, 2 Aug 2019 16:21:16 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <idosch@mellanox.com>, <andrew@lunn.ch>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <petrm@mellanox.com>,
        <tglx@linutronix.de>, <fw@strlen.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bridge@lists.linux-foundation.org>
Subject: Re: [net-next,rfc] net: bridge: mdb: Extend with multicast LLADDR
Message-ID: <20190802142115.ablwtxfpv2jmnuex@lx-anielsen.microsemi.net>
References: <1564663840-27721-1-git-send-email-horatiu.vultur@microchip.com>
 <f758fdbf-4e0a-57b3-f13d-23e893ba7458@cumulusnetworks.com>
 <20190802140655.ngbok2ubprhivlhy@lx-anielsen.microsemi.net>
 <fcb0e526-778f-5451-9934-e6c2421e4eb3@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <fcb0e526-778f-5451-9934-e6c2421e4eb3@cumulusnetworks.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 08/02/2019 17:16, Nikolay Aleksandrov wrote:
> On 02/08/2019 17:07, Allan W. Nielsen wrote:
> > The 08/01/2019 17:07, Nikolay Aleksandrov wrote:
> >>> To create a group for two of the front ports the following entries can
> >>> be added:
> >>> bridge mdb add dev br0 port eth0 grp 01:00:00:00:00:04 permanent vid 1
> >>> bridge mdb add dev br0 port eth1 grp 01:00:00:00:00:04 permanent vid 1
> >>>
> >>> Now the entries will be display as following:
> >>> dev br0 port eth0 grp 01:00:00:00:00:04 permanent offload vid 1
> >>> dev br0 port eth1 grp 01:00:00:00:00:04 permanent offload vid 1
> >>>
> >>> This requires changes to iproute2 as well, see the follogin patch for that.
> >>>
> >>> Now if frame with dmac '01:00:00:00:00:04' will arrive at one of the front
> >>> ports. If we have HW offload support, then the frame will be forwarded by
> >>> the switch, and need not to go to the CPU. In a pure SW world, the frame is
> >>> forwarded by the SW bridge, which will flooded it only the ports which are
> >>> part of the group.
> >>>
> >>> So far so good. This is an important part of the problem we wanted to solve.
> >>>
> >>> But, there is one drawback of this approach. If you want to add two of the
> >>> front ports and br0 to receive the frame then I can't see a way of doing it
> >>> with the bridge mdb command. To do that it requireds many more changes to
> >>> the existing code.
> >>>
> >>> Example:
> >>> bridge mdb add dev br0 port eth0 grp 01:00:00:00:00:04 permanent vid 1
> >>> bridge mdb add dev br0 port eth1 grp 01:00:00:00:00:04 permanent vid 1
> >>> bridge mdb add dev br0 port br0 grp 01:00:00:00:00:04 permanent vid 1 // This looks wrong.
> >>>
> >>> We believe we come a long way by re-using the facilities in MDB (thanks for
> >>> convincing us in doing this), but we are still not completely happy with
> >>> the result.
> >> Just add self argument for the bridge mdb command, no need to specify it twice.
> > Like this:
> > bridge mdb add dev br0 port eth1 grp 01:00:00:00:00:04 permanent vid self
> 
> What ?! No, that is not what I meant.
> bridge mdb add dev br0 grp 01:00:00:00:00:04 permanent vid self
> bridge mdb del dev br0 grp 01:00:00:00:00:04 permanent vid self
> 
> Similar to fdb. You don't need no-self..
> I don't mind a different approach, this was just a suggestion. But please
> without "no-self" :)

Good, then we are in sync on that one :-D

> > 
> > Then if I want to remove br0 rom the group, should I then have a no-self, and
> > then it becomes even more strange what to write in the port.
> > 
> > bridge mdb add dev br0 port ?? grp 01:00:00:00:00:04 permanent vid no-self
> >                             ^^
> > And, what if it is a group with only br0 (the traffic should go to br0 and
> > not any of the slave interfaces)?
> > 
> > Also, the 'self' keyword has different meanings in the 'bridge vlan' and the
> > 'bridge fdb' commands where it refres to if the offload rule should be install
> > in HW - or only in the SW bridge.
> 
> No, it shouldn't. Self means act on the device, in this case act on the bridge,
> otherwise master is assumed.
> 
> > 
> > The proposed does not look pretty bad, but at least it will be possible to
> > configured the different scenarios:
> > 
> > bridge mdb add dev br0 port br0 grp 01:00:00:00:00:04 permanent vid 1
> > bridge mdb del dev br0 port br0 grp 01:00:00:00:00:04 permanent vid 1
> > 
> 
> That works too, but the "port" part is redundant.
> 
> > The more I look at the "bridge mdb { add | del } dev DEV port PORT" command, the
> > less I understand why do we have both 'dev' and 'port'? The implementation will
> > only allow this if 'port' has become enslaved to the switch represented by
> > 'dev'. Anyway, what is done is done, and we need to stay backwards compatible,
> > but we could make it optional, and then it looks a bit less strange to allow the
> > port to specify a br0.
> > 
> > Like this:
> > 
> > bridge mdb { add | del } [dev DEV] port PORT grp GROUP [ permanent | temp ] [ vid VID ]
> > 
> > bridge mdb add port eth0 grp 01:00:00:00:00:04 permanent vid 1
> > bridge mdb add port eth1 grp 01:00:00:00:00:04 permanent vid 1
> > bridge mdb add port br0  grp 01:00:00:00:00:04 permanent vid 1 // Add br0 to the gruop
> > bridge mdb del port br0  grp 01:00:00:00:00:04 permanent vid 1 // Delete it again
> > 
> 
> br0 is not a port, thus the "self" or just dev or whatever you choose..
Ahh, now I understand what you meant.

> > Alternative we could also make the port optional:
> > 
> > bridge mdb { add | del } dev DEV [port PORT] grp GROUP [ permanent | temp ] [ vid VID ]
> > 
> > bridge mdb add dev br0 port eth0 grp 01:00:00:00:00:04 permanent vid 1
> > bridge mdb add dev br0 port eth1 grp 01:00:00:00:00:04 permanent vid 1
> > bridge mdb add dev br0           grp 01:00:00:00:00:04 permanent vid 1 // Add br0 to the gruop
> > bridge mdb del dev br0           grp 01:00:00:00:00:04 permanent vid 1 // Delete it again
> > 
> 
> Right. I read this one later. :)
> 
> > Any preferences?
> Not really, up to you. Any of the above seem fine to me.
Perfect, I like this one the most:

bridge mdb { add | del } dev DEV [ port PORT ] grp GROUP [ permanent | temp ] [ vid VID ]

bridge mdb add dev br0 port eth0 grp 01:00:00:00:00:04 permanent vid 1
bridge mdb add dev br0 port eth1 grp 01:00:00:00:00:04 permanent vid 1
bridge mdb add dev br0           grp 01:00:00:00:00:04 permanent vid 1 // Add br0 to the gruop
bridge mdb del dev br0           grp 01:00:00:00:00:04 permanent vid 1 // Delete it again

/Allan
