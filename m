Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC6ED750DB
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 16:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387464AbfGYOVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 10:21:06 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:2559 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387415AbfGYOVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 10:21:06 -0400
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: +zUMXScR/IuLVaoogFLG0eUFNk/cAntHaKZhUr2c0LTY9rqicfEs+mlubuSl0eQA10HINvK1SY
 fQ+v4pLoQm8xHkim4iesTvc+K+us513GtF6PqU2nrn+iLXXxeCg6kRn9d1wP3rmzQ82of3aOZw
 ONZzliXHcJECA0quRaCAV6+p3ilx8npUv4kPDPNZtOA3XR3yyDtZqa/cC0Lh4edu1sja4T24Cj
 X4pRqaMfbLFRMbGhclCIWdFBxgGN0X2agSPIAqMOSbzeDuhebAYMyRRnzfO/XEBLX1xL2ekEMN
 3PM=
X-IronPort-AV: E=Sophos;i="5.64,307,1559545200"; 
   d="scan'208";a="42755638"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jul 2019 07:21:04 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.87.71) by
 chn-vm-ex03.mchp-main.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 25 Jul 2019 07:21:04 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 25 Jul 2019 07:21:03 -0700
Date:   Thu, 25 Jul 2019 16:21:03 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     <roopa@cumulusnetworks.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <allan.nielsen@microchip.com>
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190725142101.65tusauc6fzxb2yp@soft-dev3.microsemi.net>
References: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
 <7e7a7015-6072-d884-b2ba-0a51177245ab@cumulusnetworks.com>
 <eef063fe-fd3a-7e02-89c2-e40728a17578@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <eef063fe-fd3a-7e02-89c2-e40728a17578@cumulusnetworks.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

The 07/25/2019 16:21, Nikolay Aleksandrov wrote:
> External E-Mail
> 
> 
> On 25/07/2019 16:06, Nikolay Aleksandrov wrote:
> > On 25/07/2019 14:44, Horatiu Vultur wrote:
> >> There is no way to configure the bridge, to receive only specific link
> >> layer multicast addresses. From the description of the command 'bridge
> >> fdb append' is supposed to do that, but there was no way to notify the
> >> network driver that the bridge joined a group, because LLADDR was added
> >> to the unicast netdev_hw_addr_list.
> >>
> >> Therefore update fdb_add_entry to check if the NLM_F_APPEND flag is set
> >> and if the source is NULL, which represent the bridge itself. Then add
> >> address to multicast netdev_hw_addr_list for each bridge interfaces.
> >> And then the .ndo_set_rx_mode function on the driver is called. To notify
> >> the driver that the list of multicast mac addresses changed.
> >>
> >> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> >> ---
> >>  net/bridge/br_fdb.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
> >>  1 file changed, 46 insertions(+), 3 deletions(-)
> >>
> > 
> > Hi,
> > I'm sorry but this patch is wrong on many levels, some notes below. In general
> > NLM_F_APPEND is only used in vxlan, the bridge does not handle that flag at all.
> > FDB is only for *unicast*, nothing is joined and no multicast should be used with fdbs.
> > MDB is used for multicast handling, but both of these are used for forwarding.
> > The reason the static fdbs are added to the filter is for non-promisc ports, so they can
> > receive traffic destined for these FDBs for forwarding.
> > If you'd like to join any multicast group please use the standard way, if you'd like to join
> > it only on a specific port - join it only on that port (or ports) and the bridge and you'll
> 
> And obviously this is for the case where you're not enabling port promisc mode (non-default).
> In general you'll only need to join the group on the bridge to receive traffic for it
> or add it as an mdb entry to forward it.
> 
> > have the effect that you're describing. What do you mean there's no way ?

Thanks for the explanation.
There are few things that are not 100% clear to me and maybe you can
explain them, not to go totally in the wrong direction. Currently I am
writing a network driver on which I added switchdev support. Then I was
looking for a way to configure the network driver to copy link layer
multicast address to the CPU port.

If I am using bridge mdb I can do it only for IP multicast addreses,
but how should I do it if I want non IP frames with link layer multicast
address to be copy to CPU? For example: all frames with multicast
address '01-21-6C-00-00-01' to be copy to CPU. What is the user space
command for that?

> > 
> > In addition you're allowing a mix of mcast functions to be called with unicast addresses
> > and vice versa, it is not that big of a deal because the kernel will simply return an error
> > but still makes no sense.
> > 
> > Nacked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> > 
> >> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> >> index b1d3248..d93746d 100644
> >> --- a/net/bridge/br_fdb.c
> >> +++ b/net/bridge/br_fdb.c
> >> @@ -175,6 +175,29 @@ static void fdb_add_hw_addr(struct net_bridge *br, const unsigned char *addr)
> >>  	}
> >>  }
> >>  
> >> +static void fdb_add_hw_maddr(struct net_bridge *br, const unsigned char *addr)
> >> +{
> >> +	int err;
> >> +	struct net_bridge_port *p;
> >> +
> >> +	ASSERT_RTNL();
> >> +
> >> +	list_for_each_entry(p, &br->port_list, list) {
> >> +		if (!br_promisc_port(p)) {
> >> +			err = dev_mc_add(p->dev, addr);
> >> +			if (err)
> >> +				goto undo;
> >> +		}
> >> +	}
> >> +
> >> +	return;
> >> +undo:
> >> +	list_for_each_entry_continue_reverse(p, &br->port_list, list) {
> >> +		if (!br_promisc_port(p))
> >> +			dev_mc_del(p->dev, addr);
> >> +	}
> >> +}
> >> +
> >>  /* When a static FDB entry is deleted, the HW address from that entry is
> >>   * also removed from the bridge private HW address list and updates all
> >>   * the ports with needed information.
> >> @@ -192,13 +215,27 @@ static void fdb_del_hw_addr(struct net_bridge *br, const unsigned char *addr)
> >>  	}
> >>  }
> >>  
> >> +static void fdb_del_hw_maddr(struct net_bridge *br, const unsigned char *addr)
> >> +{
> >> +	struct net_bridge_port *p;
> >> +
> >> +	ASSERT_RTNL();
> >> +
> >> +	list_for_each_entry(p, &br->port_list, list) {
> >> +		if (!br_promisc_port(p))
> >> +			dev_mc_del(p->dev, addr);
> >> +	}
> >> +}
> >> +
> >>  static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
> >>  		       bool swdev_notify)
> >>  {
> >>  	trace_fdb_delete(br, f);
> >>  
> >> -	if (f->is_static)
> >> +	if (f->is_static) {
> >>  		fdb_del_hw_addr(br, f->key.addr.addr);
> >> +		fdb_del_hw_maddr(br, f->key.addr.addr);
> > 
> > Walking over all ports again for each static delete is a no-go.
> > 
> >> +	}
> >>  
> >>  	hlist_del_init_rcu(&f->fdb_node);
> >>  	rhashtable_remove_fast(&br->fdb_hash_tbl, &f->rhnode,
> >> @@ -843,13 +880,19 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
> >>  			fdb->is_local = 1;
> >>  			if (!fdb->is_static) {
> >>  				fdb->is_static = 1;
> >> -				fdb_add_hw_addr(br, addr);
> >> +				if (flags & NLM_F_APPEND && !source)
> >> +					fdb_add_hw_maddr(br, addr);
> >> +				else
> >> +					fdb_add_hw_addr(br, addr);
> >>  			}
> >>  		} else if (state & NUD_NOARP) {
> >>  			fdb->is_local = 0;
> >>  			if (!fdb->is_static) {
> >>  				fdb->is_static = 1;
> >> -				fdb_add_hw_addr(br, addr);
> >> +				if (flags & NLM_F_APPEND && !source)
> >> +					fdb_add_hw_maddr(br, addr);
> >> +				else
> >> +					fdb_add_hw_addr(br, addr);
> >>  			}
> >>  		} else {
> >>  			fdb->is_local = 0;
> >>
> > 
> 

-- 
/Horatiu
