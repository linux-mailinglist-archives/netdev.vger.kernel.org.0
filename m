Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD58541F5C1
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 21:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355146AbhJATek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 15:34:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:53733 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229966AbhJATek (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 15:34:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="248118277"
X-IronPort-AV: E=Sophos;i="5.85,340,1624345200"; 
   d="scan'208";a="248118277"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 12:32:55 -0700
X-IronPort-AV: E=Sophos;i="5.85,340,1624345200"; 
   d="scan'208";a="619359793"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 12:32:53 -0700
Received: from andy by smile with local (Exim 4.95-RC2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mWOH4-007WhY-BC;
        Fri, 01 Oct 2021 22:32:50 +0300
Date:   Fri, 1 Oct 2021 22:32:50 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Lee Jones <lee.jones@linaro.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v1 net 1/1] ptp_pch: Load module automatically if ID
 matches
Message-ID: <YVdiYoI2Ye5E4Guu@smile.fi.intel.com>
References: <20211001162033.13578-1-andriy.shevchenko@linux.intel.com>
 <20211001121109.64aaac57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211001121109.64aaac57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 01, 2021 at 12:11:09PM -0700, Jakub Kicinski wrote:
> On Fri,  1 Oct 2021 19:20:33 +0300 Andy Shevchenko wrote:
> > The driver can't be loaded automatically because it misses
> > module alias to be provided. Add corresponding MODULE_DEVICE_TABLE()
> > call to the driver.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Could you reply with a Fixes tag? (no need to resend, I think)

Fixes: 863d08ece9bf ("supports eg20t ptp clock")

-- 
With Best Regards,
Andy Shevchenko


