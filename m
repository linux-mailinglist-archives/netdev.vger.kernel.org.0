Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9231FDF3EA
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 19:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbfJURN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 13:13:28 -0400
Received: from muru.com ([72.249.23.125]:38554 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbfJURN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 13:13:28 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 41D32810A;
        Mon, 21 Oct 2019 17:13:59 +0000 (UTC)
Date:   Mon, 21 Oct 2019 10:13:21 -0700
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
Subject: Re: [PATCH 3/9] DTS: ARM: pandora-common: define wl1251 as child
 node of mmc3
Message-ID: <20191021171321.GZ5610@atomide.com>
References: <cover.1571430329.git.hns@goldelico.com>
 <58c57f194e35b2a055a58081a0ea0d3ffcd07b6d.1571430329.git.hns@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58c57f194e35b2a055a58081a0ea0d3ffcd07b6d.1571430329.git.hns@goldelico.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* H. Nikolaus Schaller <hns@goldelico.com> [191018 20:28]:
> Since v4.7 the dma initialization requires that there is a
> device tree property for "rx" and "tx" channels which is
> not provided by the pdata-quirks initialization.
> 
> By conversion of the mmc3 setup to device tree this will
> finally allows to remove the OpenPandora wlan specific omap3
> data-quirks.
> 
> Fixes: 81eef6ca9201 ("mmc: omap_hsmmc: Use dma_request_chan() for requesting DMA channel")

Here you have the subject line the wrong way around,
please update it to start with "ARM: dts: ...".

Regards,

Tony
