Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD25F3EF05A
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 18:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhHQQqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 12:46:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:23539 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbhHQQqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 12:46:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10079"; a="238231523"
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
   d="scan'208";a="238231523"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 09:46:15 -0700
X-IronPort-AV: E=Sophos;i="5.84,329,1620716400"; 
   d="scan'208";a="593440452"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 09:46:13 -0700
Received: from andy by smile with local (Exim 4.94.2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mG2E3-00AoH4-Pt; Tue, 17 Aug 2021 19:46:07 +0300
Date:   Tue, 17 Aug 2021 19:46:07 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net-next 1/1] ptp_ocp: use bits.h macros for all masks
Message-ID: <YRvnz01sPpHMnkqQ@smile.fi.intel.com>
References: <20210817122454.50616-1-andriy.shevchenko@linux.intel.com>
 <20210817064814.13c57002@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817064814.13c57002@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 17, 2021 at 06:48:14AM -0700, Jakub Kicinski wrote:
> On Tue, 17 Aug 2021 15:24:54 +0300 Andy Shevchenko wrote:
> > Currently we are using BIT(), but GENMASK(). Make use of the latter one
> > as well (far less error-prone, far more concise).

> GENMASK is unsigned long:

Ouch, thanks!

-- 
With Best Regards,
Andy Shevchenko


