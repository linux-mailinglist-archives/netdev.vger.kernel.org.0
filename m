Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2A75547A7
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245192AbiFVLIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 07:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbiFVLIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 07:08:11 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D0736E3F;
        Wed, 22 Jun 2022 04:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655896091; x=1687432091;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UECPX/Hrh6IDLmJoQE4SMkZQeUBQbE4AVAEal5WWxwo=;
  b=Y94+k74m6SHheIkxla+Vd81y9cMdNBaYRjXEH0Ju5wC33GD0HF4QLw57
   GVOKzoslBCOnDLdSDu+9jwf7yAsOYRRPExQNn4CzK4RJELp91TwVKJzEv
   3EIrx4Dh+LdhHyVccgCkk1EOrVEYMA4gBZEgJxmz3n/C+x8/L284LEofC
   +92qdFPtxRo2eWLfqiZ3KIO/FOGeA/vKIKfHdNKcrkRXEuyY+TpygFRoy
   yT2hVHmrA2d2w3nBjpG3HOqHhgfbMkLN1W7pyUiDullx2RHI2viGrCTfq
   uQ71OpZ1s7ddiD/6czmvZsbfQMqnRrbo6A4Z/8dj8KvBQHKoE5nLA9ps1
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="305839453"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="305839453"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:08:11 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="562935226"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:08:05 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3yDK-000sGk-6b;
        Wed, 22 Jun 2022 14:08:02 +0300
Date:   Wed, 22 Jun 2022 14:08:01 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, vivien.didelot@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Samer El-Haj-Mahmoud <Samer.El-Haj-Mahmoud@arm.com>,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA
 description
Message-ID: <YrL4EQxM1c+p9EUY@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
 <YrDO05TMK8SVgnBP@lunn.ch>
 <YrGm2jmR7ijHyQjJ@smile.fi.intel.com>
 <YrGpDgtm4rPkMwnl@lunn.ch>
 <YrGukfw4uiQz0NpW@smile.fi.intel.com>
 <CAPv3WKf_2QYh0F2LEr1DeErvnMeQqT0M5t40ROP2G6HSUwKpQQ@mail.gmail.com>
 <YrLft+BrP2jI5lwp@lunn.ch>
 <CAPv3WKcAPb1Kc7=YpfmOWKa_kZYQvN8HyvjG91SiMK9c8yZa-Q@mail.gmail.com>
 <YrLw+um7l9LbPqhu@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrLw+um7l9LbPqhu@lunn.ch>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 12:37:46PM +0200, Andrew Lunn wrote:
> On Wed, Jun 22, 2022 at 12:22:23PM +0200, Marcin Wojtas wrote:

...

> MRVL0100 is pretty meaningless, but marvell,orion-mdio gives you a
> much better idea what the device is. That i would say is the key of
> the problem here. Without knowing what MRVL0100 means, it is hard to
> guess the rest.

As I pointed out they may use _DDN which will be part of the DSDT independenly
of the ACPICA version (`iasl` may add comments on the devices it knows) or any
other ACPI tools. The cons of this is the unused bulk in the ACPI tables,
meaning wasted space in firmware.

-- 
With Best Regards,
Andy Shevchenko


