Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B55DCF5247
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbfKHRKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:10:41 -0500
Received: from muru.com ([72.249.23.125]:41030 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbfKHRKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 12:10:41 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id C83AD8168;
        Fri,  8 Nov 2019 17:11:14 +0000 (UTC)
Date:   Fri, 8 Nov 2019 09:10:35 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        devicetree@vger.kernel.org, letux-kernel@openphoenux.org,
        linux-mmc@vger.kernel.org, kernel@pyra-handheld.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 05/12] omap: pdata-quirks: revert pandora specific
 gpiod additions
Message-ID: <20191108171035.GK5610@atomide.com>
References: <cover.1573122644.git.hns@goldelico.com>
 <a90b488031c3d5da2feb2f157efa6c4287cf1922.1573122644.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a90b488031c3d5da2feb2f157efa6c4287cf1922.1573122644.git.hns@goldelico.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* H. Nikolaus Schaller <hns@goldelico.com> [191107 10:33]:
> introduced by commit
> 
> efdfeb079cc3b ("regulator: fixed: Convert to use GPIO descriptor only")
> 
> We must remove this from mainline first, so that the following patch
> to remove the openpandora quirks for mmc3 and wl1251 cleanly applies
> to stable v4.9, v4.14, v4.19 where the above mentioned patch is not yet
> present.
> 
> Since the code affected is removed (no pandora gpios in pdata-quirks
> and more), there will be no matching revert-of-the-revert.

This too:

Acked-by: Tony Lindgren <tony@atomide.com>
