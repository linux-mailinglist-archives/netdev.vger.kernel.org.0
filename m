Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630735827BC
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 15:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbiG0Ncs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 09:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbiG0Ncr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 09:32:47 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E57829C9D;
        Wed, 27 Jul 2022 06:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658928766; x=1690464766;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RcqDnhmoJjzqlpW1a5WDzGkdb1I584oLPuqYJXjz+hs=;
  b=ZwCVlPusdAMbuX+DRKs9AnF0BhT1w/18OCc9Mf9eWeRcqcGBnJ/m0KoM
   iK775GNhUHD8e3H1xH9UsneVdV5FpCNRQ5yA+uhidF8A0S3ARdllJ0Nzn
   qDvCVl5OwVxfTdjewaENtlohxfLf5PRVNjl/Ks1pIdmvX79qeyjGHRLNe
   599baMC2vdzeH09V9nlStuiTMvRe4GVaz+4mmkCrVlAQ14abb2H8tce1E
   6mvUgT17ESNNqjMj+uF8AnaSYDFFZV6y74kX5+KEt/t/xuHfhzHj1lLDo
   ItRbZd+5cNd+o89lUIn2B1cKorSHa+xvwfVsuuDVi2QqCHaa1hVeydx7C
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10420"; a="314012360"
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="314012360"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 06:32:45 -0700
X-IronPort-AV: E=Sophos;i="5.93,195,1654585200"; 
   d="scan'208";a="659198392"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2022 06:32:40 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.96)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1oGh9R-001cbo-0U;
        Wed, 27 Jul 2022 16:32:37 +0300
Date:   Wed, 27 Jul 2022 16:32:36 +0300
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
Subject: Re: [net-next: PATCH v3 7/8] net: mdio: introduce
 fwnode_mdiobus_register_device()
Message-ID: <YuE+dMw+1htaM30b@smile.fi.intel.com>
References: <20220727064321.2953971-1-mw@semihalf.com>
 <20220727064321.2953971-8-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727064321.2953971-8-mw@semihalf.com>
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

On Wed, Jul 27, 2022 at 08:43:20AM +0200, Marcin Wojtas wrote:
> As a preparation patch to extend MDIO capabilities in the ACPI world,
> introduce fwnode_mdiobus_register_device() to register non-PHY
> devices on the mdiobus.

...

> +	dev_dbg(&mdio->dev, "registered mdio device %p fwnode at address %i\n",
> +		child, addr);

"%p" makes a little sense (and we have hashed pointers). I think the "%pfw"
would be much better for the user to see.

...

> -	dev_dbg(&mdio->dev, "registered mdio device %pOFn at address %i\n",
> -		child, addr);

Exactly my point above.

-- 
With Best Regards,
Andy Shevchenko


