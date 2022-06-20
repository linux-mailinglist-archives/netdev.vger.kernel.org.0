Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E06005522C7
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 19:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242859AbiFTRcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 13:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbiFTRcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 13:32:24 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7251A3A4;
        Mon, 20 Jun 2022 10:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655746343; x=1687282343;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CyJzJbaODMGrvMP4xiCkCq489CmE3t9woHs5eOyjZy4=;
  b=N/k5ZBkKSTQsCV7IxA+P4IW73DP4hisMU+7BHxGBuJhZtAPVeQ8KUada
   b0UWMa4P3aAXDZsmaJUhTX9K45xJ5e5uzHxIypvPUmVBQUDFE0EeoJIXI
   3FC6+NhrK8xL0VWrH0+74O+8VGFsvA5e+pmtHgHz7IV/h9K30RLevmkzR
   IVOA6+erjJmCM4Kw5o2xtH+YX+CBVWyc/6T4CjvzUgkxlNWLTOku7yTmO
   8/PA97BaQsmCo5EGP7J36ACjWwok8bPNnnlrAbFB7uDK3cqPJ7gUvb4fz
   pU3xQDtmLSasyDm0UUUUQSiWgwk86WgWkxRK5eTx5gocMOTKep5IDK6dP
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="305382381"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="305382381"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:32:13 -0700
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="764171985"
Received: from smile.fi.intel.com ([10.237.72.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:32:08 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3LFt-000kZM-AM;
        Mon, 20 Jun 2022 20:32:05 +0300
Date:   Mon, 20 Jun 2022 20:32:05 +0300
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
Subject: Re: [net-next: PATCH 02/12] net: mdio: switch fixed-link PHYs API to
 fwnode_
Message-ID: <YrCvFYaBuICKIQM/@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-3-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-3-mw@semihalf.com>
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

On Mon, Jun 20, 2022 at 05:02:15PM +0200, Marcin Wojtas wrote:
> fixed-link PHYs API is used by DSA and a number of drivers
> and was depending on of_. Switch to fwnode_ so to make it
> hardware description agnostic and allow to be used in ACPI
> world as well.

...

> +bool fwnode_phy_is_fixed_link(struct fwnode_handle *fwnode)
> +{
> +	struct fwnode_handle *fixed_link_node;
> +	const char *managed;
> +	int len;
> +
> +	/* New binding */
> +	fixed_link_node = fwnode_get_named_child_node(fwnode, "fixed-link");
> +	if (fixed_link_node) {
> +		fwnode_handle_put(fixed_link_node);
> +		return true;
> +	}
> +
> +	if (fwnode_property_read_string(fwnode, "managed", &managed) == 0 &&
> +	    strcmp(managed, "auto") != 0)
> +		return true;
> +
> +	/* Old binding */
> +	len = fwnode_property_read_u32_array(fwnode, "fixed-link", NULL, 0);


fwnode_property_count_u32()

> +	if (len == (5 * sizeof(u32)))

I'm not sure how to interpret this. len will return a count of u32 elements.
What does the sizeof(u32) mean here?

> +		return true;
> +
> +	return false;
> +}

-- 
With Best Regards,
Andy Shevchenko


