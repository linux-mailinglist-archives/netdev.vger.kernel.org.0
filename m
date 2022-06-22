Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 550DE554609
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245634AbiFVLFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 07:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234590AbiFVLFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 07:05:08 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0B93BBC6;
        Wed, 22 Jun 2022 04:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655895904; x=1687431904;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=rXGfo5TTPJwt5jxUV2HzNzGOHPZqSFUbroQvi0MTJtU=;
  b=iJPc+90YX3cbc0j7aNdAhCoYE2BHhRRE94Ca+q1g87E8u9BQ53egU+IY
   4Bwq7+0eY4bNobPcesg8RpZJ6vjMhvwcy0Tba4UWdt8hCBk3JRpkKcilg
   ng2E7VSfYlAXLwvInwgg2FAWD+R0KV93OYBhddhsOL+jUleVDw9vF3d1G
   /Iamzg64WLRGjNSY/4ZWHJnKl9xoTa+VyEoKUMFGNb6Eu7F3hiodwny35
   EDAvIiqREfygDiryKkJ9qgn/u3GbURO5MhbRRAo0eUX9TKZKSY/oCAaSN
   FxacSJ5Jgn/L+aGk31u3qDkRFnXjXHmCDX13BgxCDdFArI5XYhI59tp8v
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="281462478"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="281462478"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:05:00 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="620872649"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 04:04:54 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3yAE-000sGc-W2;
        Wed, 22 Jun 2022 14:04:50 +0300
Date:   Wed, 22 Jun 2022 14:04:50 +0300
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
Message-ID: <YrL3UtIYjmBiWmuH@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
 <YrDO05TMK8SVgnBP@lunn.ch>
 <YrGm2jmR7ijHyQjJ@smile.fi.intel.com>
 <YrGpDgtm4rPkMwnl@lunn.ch>
 <YrGukfw4uiQz0NpW@smile.fi.intel.com>
 <CAPv3WKf_2QYh0F2LEr1DeErvnMeQqT0M5t40ROP2G6HSUwKpQQ@mail.gmail.com>
 <YrLft+BrP2jI5lwp@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YrLft+BrP2jI5lwp@lunn.ch>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 11:24:07AM +0200, Andrew Lunn wrote:
> On Wed, Jun 22, 2022 at 11:08:13AM +0200, Marcin Wojtas wrote:
> > wt., 21 cze 2022 o 13:42 Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> napisał(a):
> > > On Tue, Jun 21, 2022 at 01:18:38PM +0200, Andrew Lunn wrote:
> > > > On Tue, Jun 21, 2022 at 02:09:14PM +0300, Andy Shevchenko wrote:
> > > > > On Mon, Jun 20, 2022 at 09:47:31PM +0200, Andrew Lunn wrote:

...

> > > > > > > +            Memory32Fixed (ReadWrite,
> > > > > > > +                0xf212a200,
> > > > > > > +                0x00000010,
> > > > > >
> > > > > > What do these magic numbers mean?
> > > > >
> > > > > Address + Length, it's all described in the ACPI specification.
> > > >
> > > > The address+plus length of what? This device is on an MDIO bus. As
> > > > such, there is no memory! It probably makes sense to somebody who
> > > > knows ACPI, but to me i have no idea what it means.
> > >
> > > I see what you mean. Honestly I dunno what the device this description is for.
> > > For the DSA that's behind MDIO bus? Then it's definitely makes no sense and
> > > MDIOSerialBus() resources type is what would be good to have in ACPI
> > > specification.
> > 
> > It's not device on MDIO bus, but the MDIO controller's register itself
> 
> Ah. So this is equivalent to
> 
>                 CP11X_LABEL(mdio): mdio@12a200 {
>                         #address-cells = <1>;
>                         #size-cells = <0>;
>                         compatible = "marvell,orion-mdio";
>                         reg = <0x12a200 0x10>;
>                         clocks = <&CP11X_LABEL(clk) 1 9>, <&CP11X_LABEL(clk) 1 5>,
>                                  <&CP11X_LABEL(clk) 1 6>, <&CP11X_LABEL(clk) 1 18>;
>                         status = "disabled";
>                 };
> 
> DT seems a lot more readable, "marvell,orion-mdio" is a good hint that
> device this is. But maybe it is more readable because that is what i'm
> used to.

In ACPI we have _HID and _DDN. _DDN may put a descriptive string.

> Please could you add a lot more comments. Given that nobody currently
> actually does networking via ACPI, we have to assume everybody trying
> to use it is a newbie, and more comments are better than less.

-- 
With Best Regards,
Andy Shevchenko


