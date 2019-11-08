Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4B01F5241
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfKHRKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:10:15 -0500
Received: from muru.com ([72.249.23.125]:40970 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbfKHRKP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 12:10:15 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 012E380D4;
        Fri,  8 Nov 2019 17:10:47 +0000 (UTC)
Date:   Fri, 8 Nov 2019 09:10:08 -0800
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
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 03/12] ARM: dts: pandora-common: define wl1251 as
 child node of mmc3
Message-ID: <20191108171008.GJ5610@atomide.com>
References: <cover.1573122644.git.hns@goldelico.com>
 <bd14b481105b21a0c1882a1ea34281893233db31.1573122644.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd14b481105b21a0c1882a1ea34281893233db31.1573122644.git.hns@goldelico.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* H. Nikolaus Schaller <hns@goldelico.com> [191107 10:33]:
> Since v4.7 the dma initialization requires that there is a
> device tree property for "rx" and "tx" channels which is
> not provided by the pdata-quirks initialization.
> 
> By conversion of the mmc3 setup to device tree this will
> finally allows to remove the OpenPandora wlan specific omap3
> data-quirks.
> 
> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")

Probably best to queue this all via the mmc tree when no more comments:

Acked-by: Tony Lindgren <tony@atomide.com>
