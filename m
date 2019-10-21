Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0336FDF3E0
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 19:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbfJURLL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 13:11:11 -0400
Received: from muru.com ([72.249.23.125]:38502 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727328AbfJURLL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 13:11:11 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 059FB80CC;
        Mon, 21 Oct 2019 17:11:41 +0000 (UTC)
Date:   Mon, 21 Oct 2019 10:11:04 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        devicetree@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>,
        linux-wireless@vger.kernel.org,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        letux-kernel@openphoenux.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Petr Mladek <pmladek@suse.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        kernel@pyra-handheld.com,
        Alexios Zavras <alexios.zavras@intel.com>,
        Rob Herring <robh+dt@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        David Sterba <dsterba@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-omap@vger.kernel.org, Allison Randal <allison@lohutok.net>,
        linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 07/11] omap: remove old hsmmc.[ch] and in Makefile
Message-ID: <20191021171104.GY5610@atomide.com>
References: <cover.1571510481.git.hns@goldelico.com>
 <9bd4c0bb0df26523d7f5265cdb06d86d63dafba8.1571510481.git.hns@goldelico.com>
 <20191021143008.GS5610@atomide.com>
 <3FDBE28F-B2C5-4EDE-905C-687F601462B6@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3FDBE28F-B2C5-4EDE-905C-687F601462B6@goldelico.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* H. Nikolaus Schaller <hns@goldelico.com> [191021 17:08]:
> 
> > Am 21.10.2019 um 16:30 schrieb Tony Lindgren <tony@atomide.com>:
> > 
> > * H. Nikolaus Schaller <hns@goldelico.com> [191019 18:43]:
> >> --- a/arch/arm/mach-omap2/Makefile
> >> +++ b/arch/arm/mach-omap2/Makefile
> >> @@ -216,7 +216,6 @@ obj-$(CONFIG_MACH_NOKIA_N8X0)		+= board-n8x0.o
> >> 
> >> # Platform specific device init code
> >> 
> >> -omap-hsmmc-$(CONFIG_MMC_OMAP_HS)	:= hsmmc.o
> >> obj-y					+= $(omap-hsmmc-m) $(omap-hsmmc-y)
> > 
> > The related obj-y line can go now too, right?
> 
> Yes, I think so. It is a construction that I have never seen before :)
> Therefore I did not recognize that it is related.
> 
> > And looks like common.h also has struct omap2_hsmmc_info
> > so maybe check by grepping for hsmmc_info to see it's gone.
> 
> Yes, it is just a forward-declaration of the struct name with
> no user anywhere.
> 
> Scheduled for v3.
> 
> BTW: should this series go through your tree since it is an
> omap machine?

Or MMC tree as that's where the code change really are.

Regards,

Tony
