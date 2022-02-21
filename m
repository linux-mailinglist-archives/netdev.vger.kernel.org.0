Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 718F84BE997
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:07:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiBUSGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 13:06:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232547AbiBUSE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 13:04:26 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF7131D0C7;
        Mon, 21 Feb 2022 09:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645466182; x=1677002182;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=+/KTjRfi65Ib76kWEGOorsZScmtiCnDSMiUu8H92FgM=;
  b=ITLgqtddaj9jqorF5CndFdZuYeHqPzmeK9CwEFHoTW8C1rV5J8x8Nr2g
   L6o9qXrSkWArfVrOfsUUquPA4cmaHrePYOgyc7Me3nqMQLLjk+0lHYNv8
   +qyHTnvJe32vv6p2wpcqlPfZkcdTa8/4r4n0BWPL6DGIJVUav09bw49TJ
   h4cN2Sv54eyyGHC0b6gL7FyMc3QJRAT77ed6egzjP0sMT92oseMNSMmwW
   RSCItpfmqtW2uMbvmi19HjTbuHUS7PSRfdlKzuzagVkjVPL+bKJkE+MGQ
   S+tCoQEaJoD5tuf3khN+27vGg9lts/JTRz3qf1NBrlvt86N3x83AXt5xg
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="314812286"
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="314812286"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 09:56:22 -0800
X-IronPort-AV: E=Sophos;i="5.88,386,1635231600"; 
   d="scan'208";a="706329238"
Received: from smile.fi.intel.com ([10.237.72.59])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 09:56:17 -0800
Received: from andy by smile.fi.intel.com with local (Exim 4.95)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1nMCuD-006s7L-Qt;
        Mon, 21 Feb 2022 19:55:25 +0200
Date:   Mon, 21 Feb 2022 19:55:25 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 09/10] i2c: mux: add support for fwnode
Message-ID: <YhPSDTAPiTvEESnO@smile.fi.intel.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
 <20220221162652.103834-10-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220221162652.103834-10-clement.leger@bootlin.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 05:26:51PM +0100, Clément Léger wrote:
> Modify i2c_mux_add_adapter() to use with fwnode API to allow creating
> mux adapters with fwnode based devices. This allows to have a node
> independent support for i2c muxes.

I^2C muxes have their own description for DT and ACPI platforms, I'm not sure
swnode should be used here at all. Just upload a corresponding SSDT overlay or
DT overlay depending on the platform. Can it be achieved?

-- 
With Best Regards,
Andy Shevchenko


