Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3779F5250
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbfKHRLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:11:13 -0500
Received: from muru.com ([72.249.23.125]:41074 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725970AbfKHRLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 12:11:12 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id D4BDB817C;
        Fri,  8 Nov 2019 17:11:45 +0000 (UTC)
Date:   Fri, 8 Nov 2019 09:11:06 -0800
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
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, letux-kernel@openphoenux.org,
        kernel@pyra-handheld.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 06/12] omap: pdata-quirks: remove openpandora quirks
 for mmc3 and wl1251
Message-ID: <20191108171106.GL5610@atomide.com>
References: <cover.1573122644.git.hns@goldelico.com>
 <ff450c14eb1e13d2db6533fa06e069c5bec3a0c4.1573122644.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff450c14eb1e13d2db6533fa06e069c5bec3a0c4.1573122644.git.hns@goldelico.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* H. Nikolaus Schaller <hns@goldelico.com> [191107 10:32]:
> With a wl1251 child node of mmc3 in the device tree decoded
> in omap_hsmmc.c to handle special wl1251 initialization, we do
> no longer need to instantiate the mmc3 through pdata quirks.
> 
> We also can remove the wlan regulator and reset/interrupt definitions
> and do them through device tree.
> 
> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")

Good to see this go away:

Acked-by: Tony Lindgren <tony@atomide.com>
