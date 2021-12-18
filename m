Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53EF479AD9
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 13:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233184AbhLRM6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 07:58:31 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:63941 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbhLRM6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 07:58:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639832311; x=1671368311;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9RHZGm/RyQO/SwBbxq2vJVAd6q93OrFI9a9a1bm8ozE=;
  b=V9CXyT6J4C24F/P8+P3IW2/m+LsEfjbv9j5G+zrVny9OxIEBsceEA3e9
   d+n+6BtWy677E6F2SH6xxFwVr3UyWYR0iUy0iLfEb9w+8EsHbOOf69+ol
   pQ62wmY2bjaPvF4CMCQO1CzjpuN3P07MRdjXB24TWR63CD4fzRhyFEqYu
   CTkIgFbQzrQW673qxqP8SWrJ7dp0iakbnNgT8CVEHL0dV6KAj/K86vKsa
   YB0f/pZ2Fi9CLQUiXaywQ0q+7nm3l4rp1ICO/05rf4focFGCuLOhpEpCY
   +N0CSDUVohq34BuXCeCg81XzsnL4HTB6CYUmpARPjhnlZFhGM8Py72s0R
   w==;
IronPort-SDR: Eg/fQwPAuOB5N06Pi1HvTDNtzUmyKPOhwIhuSpLg1h6KwUyuBEd6VevktI2tNO0zAx1MhEv1bs
 Ulw1TknVok4uY0QyBLm5eBJHEgvsJIrKoMODN/ykCEWCnSTf7Z2UYsrFXU63033vlEZvMhjJIO
 /IFGedXS6SBI34HTEzSnDeoqhjYZQ0vVl/0jHZH3qjumGnEBXC9jP09vpFMHMqpE+hxcfllJCH
 88b87qQs27TEDQFy29FKbMoq+zKXYemloNd4MFoy8MdtW4QKhoOpAstsEyYA3oRf6yX8lqj6HR
 DXE=
X-IronPort-AV: E=Sophos;i="5.88,216,1635231600"; 
   d="scan'208";a="155971066"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Dec 2021 05:58:28 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 18 Dec 2021 05:58:09 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Sat, 18 Dec 2021 05:58:09 -0700
Date:   Sat, 18 Dec 2021 14:00:14 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v7 9/9] net: lan966x: Extend switchdev with fdb
 support
Message-ID: <20211218130014.yb5wyfbyk4qv6ck4@soft-dev3-1.localhost>
References: <20211217155353.460594-1-horatiu.vultur@microchip.com>
 <20211217155353.460594-10-horatiu.vultur@microchip.com>
 <20211217181235.wquhfoq6qyqsfkxp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211217181235.wquhfoq6qyqsfkxp@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/17/2021 18:12, Vladimir Oltean wrote:
> 
> On Fri, Dec 17, 2021 at 04:53:53PM +0100, Horatiu Vultur wrote:
> > Extend lan966x driver with fdb support by implementing the switchdev
> > calls SWITCHDEV_FDB_ADD_TO_DEVICE and SWITCHDEV_FDB_DEL_TO_DEVICE.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> 
> Looks pretty good. Just one question, since I can't figure this out by
> looking at the code. Is the CPU port in the unknown unicast flood mask
> currently?

It is not. Because under a bridge can be only lan966x ports so the
HW will do already the flooding of the frames.

> 
> >  .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
> >  .../ethernet/microchip/lan966x/lan966x_fdb.c  | 244 ++++++++++++++++++
> >  .../ethernet/microchip/lan966x/lan966x_main.c |   5 +
> >  .../ethernet/microchip/lan966x/lan966x_main.h |  14 +
> >  .../microchip/lan966x/lan966x_switchdev.c     |  21 ++
> >  .../ethernet/microchip/lan966x/lan966x_vlan.c |  15 +-
> >  6 files changed, 298 insertions(+), 3 deletions(-)
> >  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_fdb.c
> (...)
> > +static void lan966x_fdb_add_entry(struct lan966x *lan966x,
> > +                               struct switchdev_notifier_fdb_info *fdb_info)
> > +{
> > +     struct lan966x_fdb_entry *fdb_entry;
> > +
> > +     fdb_entry = lan966x_fdb_find_entry(lan966x, fdb_info);
> > +     if (fdb_entry) {
> > +             fdb_entry->references++;
> > +             return;
> > +     }
> > +
> > +     fdb_entry = kzalloc(sizeof(*fdb_entry), GFP_KERNEL);
> > +     if (!fdb_entry)
> > +             return;
> > +
> > +     memcpy(fdb_entry->mac, fdb_info->addr, ETH_ALEN);
> 
> ether_addr_copy
> 
> > +     fdb_entry->vid = fdb_info->vid;
> > +     fdb_entry->references = 1;
> > +     list_add_tail(&fdb_entry->list, &lan966x->fdb_entries);
> > +}

-- 
/Horatiu
