Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B63B5522F0
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 19:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243556AbiFTRtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 13:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbiFTRtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 13:49:06 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8472DB850;
        Mon, 20 Jun 2022 10:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655747345; x=1687283345;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OKa6b6f93kGV9/bC7EwdIhfMop2yIvaF5QfkGTjKUZ0=;
  b=i3QpTGRVWGp7wSQrK4VheDggz7GEyRDhyu4KCSdXTQc6Xkn3Ynad7NYp
   8SPU94kAAyShbgbf7JxejzY/NZeMnsiG6/gMTmz6mLamwbPPSGZ0dvjYF
   x7sD1KP/rkdaU1MglsBlE/qQ5ZCMOjVLWXde9jpTOkaerBy9zOc7Buu3q
   TwEldaAofiVka9YusFwqWH8Fr+/7Uupoa4eTr/BSi6nFdakO9JGB4Bg80
   RvUXE6WXdELq560IBsMOYRpMwYBawJiw2Dic/BLX6Ywu02hbhQ07/n3+H
   S235QFFTY7qhsNQHUe5lN4wiF5u5AFdnZAS5NL8fDQIOSOvec2Q4ZGPEq
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="259770137"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="259770137"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:49:05 -0700
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="620189113"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:48:59 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3LWC-000kaO-2Q;
        Mon, 20 Jun 2022 20:48:56 +0300
Date:   Mon, 20 Jun 2022 20:48:55 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, lenb@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com, gjb@semihalf.com, jaz@semihalf.com,
        tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com,
        upstream@semihalf.com
Subject: Re: [net-next: PATCH 06/12] net: mdio: introduce
 fwnode_mdiobus_register_device()
Message-ID: <YrCzBzKfSl1u90lB@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-7-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-7-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 05:02:19PM +0200, Marcin Wojtas wrote:
> As a preparation patch to extend MDIO capabilities in the ACPI world,
> introduce fwnode_mdiobus_register_device() to register non-PHY
> devices on the mdiobus.
> 
> While at it, also use the newly introduced fwnode operation in
> of_mdiobus_phy_device_register().

...

>  static int of_mdiobus_register_device(struct mii_bus *mdio,
>  				      struct device_node *child, u32 addr)
>  {

> +	return fwnode_mdiobus_register_device(mdio, of_fwnode_handle(child), addr);
>  }

Since it's static one-liner you probably may ger rid of it completely.

-- 
With Best Regards,
Andy Shevchenko


