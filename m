Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741065522D4
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 19:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241863AbiFTRlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 13:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239358AbiFTRls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 13:41:48 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73D5101C5;
        Mon, 20 Jun 2022 10:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655746907; x=1687282907;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=e4K1fpgjFY/51Bjrme/wco0XD9Y7NXWZJctwZ6N44ak=;
  b=DdYJTEIwSQ2ZDLIeI+qZ52RSn9mfSrApUxkTVSQYXllWXnSzGWbg9/76
   f3+LZhjY14uWh/WLo2Yo71/LyZnIl8rX0ws6rHyYdnsSISOUnPz3Qhc7v
   tNaEeXumWnuLhIXxxUiCaBtfCbfsrfssTOOeDybxBCNN2qdGt5WV2BpwY
   MrAIl5VI1onsEX/Ru3giOxy9TPKhSB1m35mBRatnc4l4joJUYvdo/bWml
   JUc+2zoAIG6/PV08G8XmNqYPtKCmWH0YwAufyalBHJr4L0XuzX8FFFuH/
   cbRPpnlH1ox5zdHMN8p7K/n6A08BgqMWa33AntTdSXTfTzQvLtN7KQbaR
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="262981045"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="262981045"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:41:46 -0700
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="676625277"
Received: from smile.fi.intel.com ([10.237.72.54])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 10:41:40 -0700
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1o3LP7-000kZb-DN;
        Mon, 20 Jun 2022 20:41:37 +0300
Date:   Mon, 20 Jun 2022 20:41:37 +0300
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
Subject: Re: [net-next: PATCH 03/12] net: dsa: switch to device_/fwnode_ APIs
Message-ID: <YrCxUfTDmvm9zLXq@smile.fi.intel.com>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-4-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-4-mw@semihalf.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 05:02:16PM +0200, Marcin Wojtas wrote:
> In order to support both ACPI and DT, modify the generic
> DSA code to use device_/fwnode_ equivalent routines.
> No functional change is introduced by this patch.

...

>  	struct device_node	*dn;

What prevents us from removing this?

> +	struct fwnode_handle    *fwnode;

...

> -		dn = of_get_child_by_name(ds->dev->of_node, "mdio");
> +		fwnode = fwnode_get_named_child_node(ds->dev->fwnode, "mdio");

The rule of thumb is avoid dereferencing fwnode from struct device. So
dev_fwnode(), but here it would be achieved by device_get_named_child_node().

...

> -static int dsa_switch_parse_of(struct dsa_switch *ds, struct device_node *dn)
> +static int dsa_switch_parse_of(struct dsa_switch *ds, struct fwnode_handle *fwnode)

Shouldn't _of suffix be replaced by, let's say, _fw?

...

> -	return dsa_switch_parse_ports_of(ds, dn);
> +	return dsa_switch_parse_ports_of(ds, fwnode);

Ditto.

...

> +	fwnode = ds->dev->fwnode;

dev_fwnode() or corresponding device_property_ API.

...

>  	slave_dev->dev.of_node = port->dn;
> +	slave_dev->dev.fwnode = port->fwnode;

device_set_node()

-- 
With Best Regards,
Andy Shevchenko


