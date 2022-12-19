Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF989650A6F
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 11:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiLSKzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 05:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231362AbiLSKzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 05:55:12 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B966EE13;
        Mon, 19 Dec 2022 02:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671447311; x=1702983311;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Rn7Mr0fAlPlSOSliFnwKKa7IYFvj5hoJjtusQjHtaAU=;
  b=RJU/UwLjZaN0PhdTpmcY0TwOqcvhUaUFFQ2NV6Wo2F8ncVM0+eC4Aqs/
   Lw9qmiVEJMlv2yt5mkTGgGFdDEKGXJjKkj6/egYfoKv7sCAx476NfoAqT
   8ZAnPSPIT8D7EmhtfItf/o+O0YDvqPykKf/ScGHq4v6KAVx+mQZNd5uOX
   lON4W+lQtsvssqTt8eZx45sBqyTEi9EjhFjPvMFjUZ4FVgjbGepe6ZOdl
   xbhqHqOQcK3eQ342rkzpHLYiCGZOn1hn0rNaLcKnEq3pchfosBTf3oIEP
   dwA/67rGkLiggi5nptdVuhflkoNU/0FAYU1pnwMszik1yda3QzW3S4VQH
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="405574848"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="405574848"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 02:55:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10565"; a="681177436"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="681177436"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 19 Dec 2022 02:55:07 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 857FEF7; Mon, 19 Dec 2022 12:55:37 +0200 (EET)
Date:   Mon, 19 Dec 2022 12:55:37 +0200
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     linux-acpi@vger.kernel.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wolfram Sang <wsa@kernel.org>
Subject: Re: [PATCH RFC net-next v2 2/2] net: sfp: use
 i2c_get_adapter_by_fwnode()
Message-ID: <Y6BDKc4F13w6OEpO@black.fi.intel.com>
References: <Y6Az235wsnRWFYWA@shell.armlinux.org.uk>
 <E1p7CoZ-0012Ur-QD@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <E1p7CoZ-0012Ur-QD@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 09:52:07AM +0000, Russell King (Oracle) wrote:
> Use the newly introduced i2c_get_adapter_by_fwnode() API, so that we
> can retrieve the I2C adapter in a firmware independent manner once we
> have the fwnode handle for the adapter.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
