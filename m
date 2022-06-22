Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22F3D554CBD
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358202AbiFVOUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358175AbiFVOUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:20:11 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D009B5FB6;
        Wed, 22 Jun 2022 07:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655907610; x=1687443610;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FXE8o8UOWuK9nf2Bhh8e/wPro8z+x8Ye/C+F7s9tcSA=;
  b=mBVZF5WJ8pfZYE1mUUrE6BpQ0086cxrsoLEVMR9k2evSljpavn7REb5T
   z1v+Jnd0Go3z8sKSdW9YdrejUXclshYZMRuzZO5LuZPOO/L9urYVi7LZc
   wox3Joq+3VAuvCvQ5EM5wCvYd1tXofNH8UEO426s6g204RHxrG6pqJHRr
   nVHsDAaEuOywVTFTPnAv/d1D2/CcDxDgEMy87xEp3EXIGh3TPikFGM5Cu
   BaFI7LC+Hdn+l/4ixreldOJKO9VC5veYxjY2Hu/CvWBwRpZQ3rp8nTeZZ
   FF4d5GZWHvAMXXbqKmiLHBRoD+FgvtLf4bLDtFX7MUIzqvE3fPQoaLl2c
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="344418822"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="344418822"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 07:20:10 -0700
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="730366946"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 07:20:05 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o41D7-000sN3-B2;
        Wed, 22 Jun 2022 17:20:01 +0300
Date:   Wed, 22 Jun 2022 17:20:01 +0300
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
Message-ID: <YrMlEcKwpTmR5qj6@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
 <YrDO05TMK8SVgnBP@lunn.ch>
 <YrGm2jmR7ijHyQjJ@smile.fi.intel.com>
 <YrGpDgtm4rPkMwnl@lunn.ch>
 <YrGukfw4uiQz0NpW@smile.fi.intel.com>
 <CAPv3WKf_2QYh0F2LEr1DeErvnMeQqT0M5t40ROP2G6HSUwKpQQ@mail.gmail.com>
 <YrL3DQD92ijLam2V@smile.fi.intel.com>
 <YrL7Z6/ghTO/9wlx@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrL7Z6/ghTO/9wlx@lunn.ch>
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

On Wed, Jun 22, 2022 at 01:22:15PM +0200, Andrew Lunn wrote:
> > > It's not device on MDIO bus, but the MDIO controller's register itself
> > > (this _CSR belongs to the parent, subnodes do not refer to it in any
> > > way). The child device requires only _ADR (or whatever else is needed
> > > for the case the DSA device is attached to SPI/I2C controllers).
> > 
> > More and more the idea of standardizing the MDIOSerialBus() resource looks
> > plausible. The _ADR() usage is a bit grey area in ACPI specification. Maybe
> > someone can also make it descriptive, so Microsoft and others won't utilize
> > _ADR() in any level of weirdness.
> 
> I don't know if it makes any difference, but there are two protocols
> spoken over MDIO, c22 and c45, specified in clause 22 and clause 45 of
> the 802.3 specification. In some conditions, you need to specify which
> protocol to speak to a device at a particular address. In DT we
> indicate this with the compatible string, when maybe it should really
> be considered as an extension of the address.
> 
> If somebody does produce a draft for MDIOSerialBus() i'm happy to
> review it.

I also can review it. Marcin, would it be hard for you to prepare a formal
proposal for ACPI specification?

-- 
With Best Regards,
Andy Shevchenko


