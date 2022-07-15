Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEED957679B
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiGOTmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGOTmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:42:33 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BDF72EE8;
        Fri, 15 Jul 2022 12:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657914152; x=1689450152;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=p4fqAN+H8GYhA5CniTp+zWSc9/v2qpee4Ap3oaSAcMA=;
  b=IEd2l3xq0KUyxYA/JgAcAgHJewZVvnWuZR/skRC5M5yiUo085J4pK4em
   ctI0GkMPhVLszncxWcu+oA4BT9DLvH1kq8UjbI4hXMgAogarEgef+68Ed
   X26bNKBK48XMhuveOMRt3ojMGes1WuB0ZqcIGqK76gSkLeH+befjiZPKC
   irqKykKZTQNr0h7koB6a6GoGB3RqyJTs452SkS/moEt2zvJbIyyH71WUp
   wqZSrRHp3OBLmh38qUaQ4f+M/X9/ITr6253C4pOa4ckwgM5zMPsQDrZ21
   4roBpI5Y5+Fx1OuHhV+7ZJ0tOHApk6kLwiDgticRrdGPClIkEQsm/5Sv7
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="287026651"
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="287026651"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 12:42:31 -0700
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="723199261"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 12:42:26 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oCRCg-001JD3-2P;
        Fri, 15 Jul 2022 22:42:22 +0300
Date:   Fri, 15 Jul 2022 22:42:22 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        gjb@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: Re: [net-next: PATCH v2 5/8] device property: introduce
 fwnode_dev_node_match
Message-ID: <YtHDHtWU5Wbgknej@smile.fi.intel.com>
References: <20220715085012.2630214-1-mw@semihalf.com>
 <20220715085012.2630214-6-mw@semihalf.com>
 <YtHBvb/kh/Sl0cmz@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtHBvb/kh/Sl0cmz@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 10:36:29PM +0300, Andy Shevchenko wrote:
> On Fri, Jul 15, 2022 at 10:50:09AM +0200, Marcin Wojtas wrote:
> > This patch adds a new generic routine fwnode_dev_node_match
> > that can be used e.g. as a callback for class_find_device().
> > It searches for the struct device corresponding to a
> > struct fwnode_handle by iterating over device and
> > its parents.
> 
> Implementation
> 1) misses the word 'parent';
> 2) located outside of the group of fwnode APIs operating on parents.
> 
> I would suggest to rename to fwnode_get_next_parent_node() and place
> near to fwnode_get_next_parent_dev() (either before or after, where
> it makes more sense).

And matching function will be after that:

	return fwnode_get_next_parent_node(...) != NULL;

Think about it. Maybe current solution is good enough, just needs better
naming (fwnode_match_parent_node()? Dunno).

P.S. Actually _get maybe misleading as we won't bump reference counting,
     rather _find?

-- 
With Best Regards,
Andy Shevchenko


