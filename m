Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F48720B779
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgFZRnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:43:25 -0400
Received: from smtprelay0223.hostedemail.com ([216.40.44.223]:34546 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725833AbgFZRnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 13:43:24 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id F1539182CED28;
        Fri, 26 Jun 2020 17:43:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2393:2538:2551:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3871:4250:4321:5007:6119:6742:7576:7904:9545:10004:10400:10848:11026:11232:11473:11657:11658:11914:12043:12048:12050:12296:12297:12438:12663:12740:12760:12895:13018:13019:13095:13436:13439:13846:14096:14097:14181:14659:14721:21080:21433:21451:21627:21740:21796:30029:30036:30054:30055:30063:30064:30067:30090:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: join00_341308726e57
X-Filterd-Recvd-Size: 4963
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf19.hostedemail.com (Postfix) with ESMTPA;
        Fri, 26 Jun 2020 17:43:20 +0000 (UTC)
Message-ID: <25ee2faad779d8c49d33e28b2c04f882c05fc60a.camel@perches.com>
Subject: Re: [net-next v3 04/15] iecm: Common module introduction and
 function stubs
From:   Joe Perches <joe@perches.com>
To:     "Brady, Alan" <alan.brady@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Date:   Fri, 26 Jun 2020 10:43:19 -0700
In-Reply-To: <MW3PR11MB45220E5C74C2DC14094EF3788F930@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-5-jeffrey.t.kirsher@intel.com>
         <a6eafe2f110b468a8908e1562bfc707360c27b75.camel@perches.com>
         <MW3PR11MB45220E5C74C2DC14094EF3788F930@MW3PR11MB4522.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.2-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-06-26 at 17:34 +0000, Brady, Alan wrote:
> > -----Original Message-----
> > From: Joe Perches <joe@perches.com>
> > Sent: Thursday, June 25, 2020 7:24 PM
> > To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> > Cc: Michael, Alice <alice.michael@intel.com>; netdev@vger.kernel.org;
> > nhorman@redhat.com; sassmann@redhat.com; Brady, Alan
> > <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.com>; Hay,
> > Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> > <madhu.chittim@intel.com>; Linga, Pavan Kumar
> > <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> > <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> > <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> > <sridhar.samudrala@intel.com>
> > Subject: Re: [net-next v3 04/15] iecm: Common module introduction and
> > function stubs
> > 
> > On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> > > From: Alice Michael <alice.michael@intel.com>
> > > 
> > > This introduces function stubs for the framework of the common module.
> > 
> > trivia:
> > 
> > > diff --git a/drivers/net/ethernet/intel/iecm/iecm_lib.c
> > > b/drivers/net/ethernet/intel/iecm/iecm_lib.c
> > []
> > > @@ -0,0 +1,407 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/* Copyright (C) 2020 Intel Corporation */
> > > +
> > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > +
> > > +#include <linux/net/intel/iecm.h>
> > > +
> > > +static const struct net_device_ops iecm_netdev_ops_splitq; static
> > > +const struct net_device_ops iecm_netdev_ops_singleq; extern int
> > > +debug;
> > 
> > extern int debug doesn't seem like a good global name.
> > 
> > extern int iecm_debug?
> > 
> 
> Agreed, will fix.
> 
> > > diff --git a/drivers/net/ethernet/intel/iecm/iecm_main.c
> > > b/drivers/net/ethernet/intel/iecm/iecm_main.c
> > []
> > > @@ -0,0 +1,47 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/* Copyright (C) 2020 Intel Corporation */
> > > +
> > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > > +
> > > +#include <linux/net/intel/iecm.h>
> > > +
> > > +char iecm_drv_name[] = "iecm";
> > > +#define DRV_SUMMARY	"Intel(R) Data Plane Function Linux Driver"
> > > +static const char iecm_driver_string[] = DRV_SUMMARY; static const
> > > +char iecm_copyright[] = "Copyright (c) 2020, Intel Corporation.";
> > > +
> > > +MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
> > > +MODULE_DESCRIPTION(DRV_SUMMARY); MODULE_LICENSE("GPL v2");
> > > +
> > > +int debug = -1;
> > 
> > iecm_debug?
> > 
> 
> Yes will fix.
> 
> > > +module_param(debug, int, 0644);
> > > +#ifndef CONFIG_DYNAMIC_DEBUG
> > > +MODULE_PARM_DESC(debug, "netif level (0=none,...,16=all), hw
> > > +debug_mask (0x8XXXXXXX)"); #else MODULE_PARM_DESC(debug, "netif level
> > > +(0=none,...,16=all)"); #endif /* !CONFIG_DYNAMIC_DEBUG */
> > 
> > Are debugging levels described?
> > 
> > 
> 
> I'm not confident I know what's being asked here.  We use this module parameter to pass into netif_msg_init for adapter->msg_enable similar to how other Intel NIC drivers do.

Some drivers use this as a debugging "level",
where the level is tested against increasing verbosity
Others use a bitmap.

If this is for netif_dbg, the NETIF_MSG_<FOO>_BIT enum
is used.




