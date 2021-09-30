Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1108841E326
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 23:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349527AbhI3VSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 17:18:18 -0400
Received: from mga12.intel.com ([192.55.52.136]:18616 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349413AbhI3VSP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 17:18:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10123"; a="204774280"
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="204774280"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 14:16:31 -0700
X-IronPort-AV: E=Sophos;i="5.85,336,1624345200"; 
   d="scan'208";a="708231121"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2021 14:16:27 -0700
Received: from andy by smile with local (Exim 4.95-RC2)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1mW3Pj-007GBl-F0;
        Fri, 01 Oct 2021 00:16:23 +0300
Date:   Fri, 1 Oct 2021 00:16:23 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Brian Norris <briannorris@chromium.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mwifiex: Try waking the firmware until we get an
 interrupt
Message-ID: <YVYpJ4Thd0VHTDLT@smile.fi.intel.com>
References: <20210914114813.15404-1-verdre@v0yd.nl>
 <20210914114813.15404-3-verdre@v0yd.nl>
 <YUsRT1rmtITJiJRh@smile.fi.intel.com>
 <d9b1c8ea-99e2-7c3e-ec8e-61362e8ccfa7@v0yd.nl>
 <YVYk/1+ftFUOoitF@smile.fi.intel.com>
 <98c1b772-ae6b-e435-030e-399f613061ba@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <98c1b772-ae6b-e435-030e-399f613061ba@v0yd.nl>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 11:07:09PM +0200, Jonas Dreßler wrote:
> On 9/30/21 10:58 PM, Andy Shevchenko wrote:
> > On Thu, Sep 30, 2021 at 08:04:00PM +0200, Jonas Dreßler wrote:

...

> > Second, what is the problem with having one write more or less?
> > Your current code doesn't guarantee this either. It only decreases
> > probability of such scenario. Am I wrong?
> 
> Indeed my approach just decreases the probability and we sometimes end up
> writing twice to wakeup the card, but it would kinda bug me if we'd always
> do one write too much.
> 
> Anyway, if you still prefer the read_poll_timeout() solution I'd be alright
> with that of course.

Yes, it will make code cleaner.

-- 
With Best Regards,
Andy Shevchenko


