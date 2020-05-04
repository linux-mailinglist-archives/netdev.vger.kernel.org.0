Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475B11C3E26
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 17:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbgEDPJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 11:09:10 -0400
Received: from muru.com ([72.249.23.125]:52774 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728997AbgEDPJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 11:09:10 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 42AFE8030;
        Mon,  4 May 2020 15:09:57 +0000 (UTC)
Date:   Mon, 4 May 2020 08:09:05 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Clay McClure <clay@daemons.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        kbuild test robot <lkp@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Wingman Kwok <w-kwok2@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Andi Kleen <ak@linux.intel.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Dinh Nguyen <dinguyen@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: ti: Remove TI_CPTS_MOD workaround
Message-ID: <20200504150905.GJ37466@atomide.com>
References: <20200502233910.20851-1-clay@daemons.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502233910.20851-1-clay@daemons.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Clay McClure <clay@daemons.net> [200502 23:41]:
> diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
> index 3cc3ca5fa027..e00f0d871c53 100644
> --- a/arch/arm/configs/omap2plus_defconfig
> +++ b/arch/arm/configs/omap2plus_defconfig
> @@ -57,7 +57,6 @@ CONFIG_CPUFREQ_DT=m
>  CONFIG_ARM_TI_CPUFREQ=y
>  CONFIG_CPU_IDLE=y
>  CONFIG_ARM_CPUIDLE=y
> -CONFIG_DT_IDLE_STATES=y
>  CONFIG_KERNEL_MODE_NEON=y
>  CONFIG_PM_DEBUG=y
>  CONFIG_ARM_CRYPTO=y

Hmm the change above does not look related. Can you please check all the
defconfig related changes so you are only changing the related options?

Regards,

Tony
