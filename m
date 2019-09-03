Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8AFA692E
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbfICNCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:02:30 -0400
Received: from mga12.intel.com ([192.55.52.136]:39212 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728094AbfICNCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 09:02:30 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 06:02:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="382111575"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga005.fm.intel.com with ESMTP; 03 Sep 2019 06:02:28 -0700
Received: from andy by smile with local (Exim 4.92.1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1i58S3-00012l-8z; Tue, 03 Sep 2019 16:02:27 +0300
Date:   Tue, 3 Sep 2019 16:02:27 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/4] can: mcp251x: Make use of device properties
Message-ID: <20190903130227.GX2680@smile.fi.intel.com>
References: <20190903124259.60920-1-andriy.shevchenko@linux.intel.com>
 <9ba9d56b-c045-74d3-9693-a9a959ffb675@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ba9d56b-c045-74d3-9693-a9a959ffb675@pengutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 02:50:05PM +0200, Marc Kleine-Budde wrote:
> On 9/3/19 2:42 PM, Andy Shevchenko wrote:
> > The purpose of this series is to simplify driver by switching to use device
> > properties. In particular it allows to drop legacy platform data.
> > 
> > Patch 1 switches driver to use devm_clk_get_optional() API.
> > 
> > Patch 2 unifies getting the driver data independently of the table which
> > provides it.
> > 
> > Patch 3 drops extra check for regulator presence by switch to use an already
> > present wrapper.
> > 
> > And patch 4 gets rid of legacy platform data.
> > 
> > Changelog v2:
> > - add patch 4 to get rid of legacy platform data
> 
> Sorry for not telling, your v1 series has already been applied and it's
> included in the latest pull request. Can you please rebase your patches
> on top of:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/tag/?h=linux-can-next-for-5.4-20190903


Thank you!

Basically first 3 patches didn't change. Consider patch 4 only. Should I resend
it separately as v3?

-- 
With Best Regards,
Andy Shevchenko


