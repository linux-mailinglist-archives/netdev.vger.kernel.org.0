Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D83B26A317
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 12:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgIOK1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 06:27:14 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:16638 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIOK1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 06:27:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1600165631; x=1631701631;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6pj42hcpmKOUyMQ9MhDbUOl6HOtbIojY8r2/GLfcYBk=;
  b=cAI6zxY48uUIZKfOkoAgTqTHMvUJuLOZgJIoeviH6e5s1RlOZ+L6TCaB
   eZlYrjHwsPb720R1E6Ha9XWnb6oxKOttBh4Mx4T18KzcBNJDkHH4knOIB
   ITEG/QIyHyl7gctWlLh1Z1LTT8BB/0uUlwpAIVvZUecu9bQCR72fWJsyV
   nNabZHNMLXfgkCQrt8Yv8IEMwq3oh4/mvfjPY41eDbxdptSnlE8dLijgB
   VePo863cuP1jg3TySt1IrTVCOLJ7P5m7wxMAUTycTQ9tQJljI5t1Zoj0Q
   1k89KohnB1+WhGlMP35nXn06LZNPx8woPgkqXzRy9/40T9B77AKgnEt6j
   g==;
IronPort-SDR: SeG2nD/GORJgPmYvGhclPsw+G8TXL3rsyaBt8PW20lW/8KhOAwcwu7c0eGtJj72zuL7UlA7vic
 ySqqbTGvBfI2fKz8lGViZBn4kK5p9XyK4r2BIii3Iz2GtNniC3dZSytzS9Vcjjgo/S7wMsI2e4
 FO7vUlsYEQNxoRf0xi0VOFr1dcb1zwL+IgMfbPMxZdkKVZ0J+U3caEcyKBBghp2SaOjNDAmV9O
 KxljA5ep7WrE3dRTvSEPUUcQByQQqZ00iKc0dcKAliua+/ybuR9seP2ngf/8cs+CmLDVuYurI8
 R7g=
X-IronPort-AV: E=Sophos;i="5.76,429,1592895600"; 
   d="scan'208";a="95789163"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Sep 2020 03:26:58 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 03:26:48 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 15 Sep 2020 03:26:48 -0700
Date:   Tue, 15 Sep 2020 10:24:22 +0000
From:   "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH RFC 6/7] bridge: cfm: Netlink Notifications.
Message-ID: <20200915102422.ronvnumdu4lk3l4b@soft-test08>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
 <20200904091527.669109-7-henrik.bjoernlund@microchip.com>
 <cbb516e37457ef1875f99001ec72624c49ab51ed.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <cbb516e37457ef1875f99001ec72624c49ab51ed.camel@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review. Comments below.

The 09/08/2020 13:54, Nikolay Aleksandrov wrote:
> 
> On Fri, 2020-09-04 at 09:15 +0000, Henrik Bjoernlund wrote:
> > This is the implementation of Netlink notifications out of CFM.
> >
> > Notifications are initiated whenever a state change happens in CFM.
> >
> [snip]
> > +     *count = 0;
> > +
> > +     rcu_read_lock();
> > +     list_for_each_entry_rcu(mep, &br->mep_list, head)
> > +             * count += 1;
> 
> please remove the extra space
> 
I have removed the extra space.
This space was added to satify checkpatch as without this space it gives
this error:
CHECK: spaces preferred around that '*' (ctx:ExV)
#136: FILE: net/bridge/br_cfm.c:883:
+               *count += 1;
                ^

> > +     rcu_read_unlock();
> > +
> > +     return 0;
> > +}
> > +
> 
> 

-- 
/Henrik
