Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F5257678C
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiGOTgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiGOTgj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:36:39 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571915A45C;
        Fri, 15 Jul 2022 12:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657913798; x=1689449798;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LyqENZlwfgufzE1PbxZbxp7zROMkjnJjCHn0mDWskg8=;
  b=X16Yxt7+yMUDd+25TnPlev1uUoxFiNXSZ8pQ7YHrd+IJFX01UuWXr1PI
   NBcnej8xjL4EX2WMerVUy5+uq6gf3QSX6ux6LoMtKTeYm1hM5l/ILf2+L
   mIVCXX0lwYgZ6Bn8qKtd4P9m4dyceB4pqIvm2Rx9mmH+oHeRCrXxus13H
   H69Z9UFbQHQ23zvUhR2x8FdvO5i59HthN8Tzzg3J6ycTonbTwHFXVnxDj
   ElC0lA8nMElSHhekMAc5fwt1RT4g48GT5CPQGeLCR7lkDY+gAfegybncF
   +AEnJEPTpF/rHtmThGXK/i4nD1IExuTaHItuEdH7qUBHIuCEeBNUxIk6F
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="311550483"
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="311550483"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 12:36:37 -0700
X-IronPort-AV: E=Sophos;i="5.92,274,1650956400"; 
   d="scan'208";a="600609088"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 12:36:32 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oCR6z-001JCr-1W;
        Fri, 15 Jul 2022 22:36:29 +0300
Date:   Fri, 15 Jul 2022 22:36:29 +0300
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
Message-ID: <YtHBvb/kh/Sl0cmz@smile.fi.intel.com>
References: <20220715085012.2630214-1-mw@semihalf.com>
 <20220715085012.2630214-6-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715085012.2630214-6-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 15, 2022 at 10:50:09AM +0200, Marcin Wojtas wrote:
> This patch adds a new generic routine fwnode_dev_node_match
> that can be used e.g. as a callback for class_find_device().
> It searches for the struct device corresponding to a
> struct fwnode_handle by iterating over device and
> its parents.

Implementation
1) misses the word 'parent';
2) located outside of the group of fwnode APIs operating on parents.

I would suggest to rename to fwnode_get_next_parent_node() and place
near to fwnode_get_next_parent_dev() (either before or after, where
it makes more sense).

-- 
With Best Regards,
Andy Shevchenko


