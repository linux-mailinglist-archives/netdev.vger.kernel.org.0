Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B9E553149
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 13:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiFULqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 07:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350016AbiFULqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 07:46:20 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7422A951;
        Tue, 21 Jun 2022 04:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655811980; x=1687347980;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3GUgWTllOUgsMA7bwu4qZaUXD45tDHXoYQUBLPICbPI=;
  b=Gtus1wMNFspB6w9Luyr4HGzryCSUT3yWR2G7fyr0ZC9dbqVYpc0/DER4
   ezn7ZBwdU+4DJor513GBwrQR9Ewt25Rf8S8B6/YdFE2upq49iejjDkA08
   jdM8qJkR0y/5pQehrTdxfAHU/FKkc4gMw0lFhCny/3PnwlqCDELN4Xrtw
   wXN2PUCqaLB3K7PBQ1sIn7d977gz2TrHU3dICBqz58R1MGfjiKcy06JQM
   m8qBtjUqerujAiHgyuL/Trjedos4/Kg8arl2yfX4DhyJiunYk2npzxc6T
   xCO5ELFrLGzY2JqRncjf0Kgi4gQTp3m1o4fio3h2LeX2Yx9FeGtDVwc4D
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="277646587"
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="277646587"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 04:46:19 -0700
X-IronPort-AV: E=Sophos;i="5.92,209,1650956400"; 
   d="scan'208";a="585252456"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 04:46:09 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3cKb-000qzY-PZ;
        Tue, 21 Jun 2022 14:46:05 +0300
Date:   Tue, 21 Jun 2022 14:46:05 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Marcin Wojtas <mw@semihalf.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, lenb@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux@armlinux.org.uk, hkallweit1@gmail.com, gjb@semihalf.com,
        jaz@semihalf.com, tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA
 description
Message-ID: <YrGvfdRF4jNIGzQq@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
 <20220621094556.5ev3nencnw7a5xwv@bogus>
 <YrGoXXBgHvyifny3@smile.fi.intel.com>
 <YrGqg5fHB4s+Y7wx@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrGqg5fHB4s+Y7wx@lunn.ch>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 01:24:51PM +0200, Andrew Lunn wrote:
> On Tue, Jun 21, 2022 at 02:15:41PM +0300, Andy Shevchenko wrote:
> > On Tue, Jun 21, 2022 at 10:45:56AM +0100, Sudeep Holla wrote:

...

> > I dunno we have a such, but the closest I may imagine is MIPI standardization,
> > that we have at least for cameras and sound.
> > 
> > I would suggest to go and work with MIPI for network / DSA / etc area, so
> > everybody else will be aware of the standard.
> 
> It is the same argument as for DT. Other OSes and bootloaders seem to
> manage digging around in Linux for DT binding documentation. I don't
> see why bootloaders and other OSes can not also dig around in Linux
> for ACPI binding documentations.
> 
> Ideally, somebody will submit all this for acceptance into ACPI, but
> into somebody does, i suspect it will just remain a defacto standard
> in Linux.

The "bindings" are orthogonal to ACPI specification. It's a vendor / OS / ...
specific from ACPI p.o.v. It has an UUID field and each UUID may or may not
be a part of any standard.

-- 
With Best Regards,
Andy Shevchenko


