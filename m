Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF64A6CD2
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 17:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729600AbfICPWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 11:22:36 -0400
Received: from mga06.intel.com ([134.134.136.31]:2599 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729393AbfICPWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 11:22:36 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 08:22:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="383116703"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga006.fm.intel.com with ESMTP; 03 Sep 2019 08:22:33 -0700
Received: from andy by smile with local (Exim 4.92.1)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1i5Adb-0003Wh-IW; Tue, 03 Sep 2019 18:22:31 +0300
Date:   Tue, 3 Sep 2019 18:22:31 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 4/4] can: mcp251x: Get rid of legacy platform data
Message-ID: <20190903152231.GY2680@smile.fi.intel.com>
References: <20190903124259.60920-1-andriy.shevchenko@linux.intel.com>
 <20190903124259.60920-5-andriy.shevchenko@linux.intel.com>
 <dc494f9a-0de3-5beb-bcbf-adbfb4813761@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc494f9a-0de3-5beb-bcbf-adbfb4813761@pengutronix.de>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 03, 2019 at 03:17:11PM +0200, Marc Kleine-Budde wrote:
> On 9/3/19 2:42 PM, Andy Shevchenko wrote:
> > Instead of using legacy platform data, switch to use device properties.
> > For clock frequency we are using well established clock-frequency property.
> > 
> > Users, two for now, are also converted here.
> 
> I've removed this section already in this patch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/commit/?h=linux-can-next-for-5.4-20190903&id=f6cae800bfdb6711f0d45af98643a944998be6f2
> 
> ...I've dropped that hunk.

Awesome, thanks!

-- 
With Best Regards,
Andy Shevchenko


