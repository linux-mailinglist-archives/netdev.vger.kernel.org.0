Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2C23EFF8B
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 10:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhHRIu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 04:50:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:5234 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229703AbhHRIux (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 04:50:53 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="277309063"
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="277309063"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 01:50:19 -0700
X-IronPort-AV: E=Sophos;i="5.84,330,1620716400"; 
   d="scan'208";a="680682863"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 01:50:16 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mGHH0-00B3PC-4O; Wed, 18 Aug 2021 11:50:10 +0300
Date:   Wed, 18 Aug 2021 11:50:10 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pavel Skripkin <paskripkin@gmail.com>, davem@davemloft.net,
        christophe.jaillet@wanadoo.fr, jesse.brandeburg@intel.com,
        kaixuxia@tencent.com, lee.jones@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: mii: make mii_ethtool_gset() return void
Message-ID: <YRzJwjuoJvjfEJpa@smile.fi.intel.com>
References: <680892d787669c56f0ceac0e9c113d6301fbe7c6.1629225089.git.paskripkin@gmail.com>
 <20210817173904.306fb7c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817173904.306fb7c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 05:39:04PM -0700, Jakub Kicinski wrote:
> On Tue, 17 Aug 2021 21:34:42 +0300 Pavel Skripkin wrote:
> > mii_ethtool_gset() does not return any errors. We can make it return
> > void to simplify error checking in drivers, that rely on return value
> > of this function.
> > 
> > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> 
> This breaks the build and therefore would be a nuisance in bisection.
> Please squash the changes or invert the order.

Please invert the order. You will need slightly different justification for the
PCH GBE patch. Feel free to add my

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

to the PCH GBE one.

-- 
With Best Regards,
Andy Shevchenko


