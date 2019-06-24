Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0A750CF5
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731706AbfFXN6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:58:35 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34828 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbfFXN6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:58:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5smB2m4Y0klWGWmyQa1vij++fAOVw9JkYbzzRYavqp0=; b=RqvOmp3XCu8FvyJ4/NnZgL9F9
        O+oWz0ngTcwSIz0vq1xJMc7pIDWXKVxRJsS0GDEIixdtmJvp8JkDEj03OSWb5lIP1iKSSifK7IrBt
        5qVxBYLQJ0Nq5iS2OLrnVZ0rOpf6XH5bcGjBlB69YPrlPghhFQIZNj/xtO2MSpOHdMg25LVQ7GZXc
        heHcRY08SNZ7sPS8jk5zUua9UQYFPzuWBilAO3eqxm/U5MxAxi+tUnyBT9UfcGnxTc6A+Z1p1sZ7o
        MLF3aXvnzV4T6Ynia00aB8mrNldelIynZsG4wpG1V4bMhNpxEX4UOfIDX+RT8vtpNrbOonXhcJxwk
        Yp8JldWCw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:58948)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfPUA-0008Pi-EE; Mon, 24 Jun 2019 14:58:18 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfPU6-0006L9-0v; Mon, 24 Jun 2019 14:58:14 +0100
Date:   Mon, 24 Jun 2019 14:58:13 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Phong Tran <tranmanphong@gmail.com>
Cc:     acme@kernel.org, alexander.shishkin@linux.intel.com,
        alexander.sverdlin@gmail.com, allison@lohutok.net, andrew@lunn.ch,
        ast@kernel.org, bgolaszewski@baylibre.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, daniel@zonque.org, dmg@turingmachine.org,
        festevam@gmail.com, gerg@uclinux.org, gregkh@linuxfoundation.org,
        gregory.clement@bootlin.com, haojian.zhuang@gmail.com,
        hsweeten@visionengravers.com, illusionist.neo@gmail.com,
        info@metux.net, jason@lakedaemon.net, jolsa@redhat.com,
        kafai@fb.com, kernel@pengutronix.de, kgene@kernel.org,
        krzk@kernel.org, kstewart@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, liviu.dudau@arm.com,
        lkundrak@v3.sk, lorenzo.pieralisi@arm.com, mark.rutland@arm.com,
        mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
        nsekhar@ti.com, peterz@infradead.org, robert.jarzmik@free.fr,
        s.hauer@pengutronix.de, sebastian.hesselbarth@gmail.com,
        shawnguo@kernel.org, songliubraving@fb.com, sudeep.holla@arm.com,
        swinslow@gmail.com, tglx@linutronix.de, tony@atomide.com,
        will@kernel.org, yhs@fb.com
Subject: Re: [PATCH V2 04/15] ARM: exynos: cleanup cppcheck shifting error
Message-ID: <20190624135813.ojywq36nljk4ukyj@shell.armlinux.org.uk>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
 <20190624135105.15579-5-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624135105.15579-5-tranmanphong@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 08:50:54PM +0700, Phong Tran wrote:
> [arch/arm/mach-exynos/suspend.c:288]: (error) Shifting signed 32-bit
> value by 31 bits is undefined behaviour
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
>  arch/arm/mach-exynos/suspend.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-exynos/suspend.c b/arch/arm/mach-exynos/suspend.c
> index be122af0de8f..b6a73dc5bde4 100644
> --- a/arch/arm/mach-exynos/suspend.c
> +++ b/arch/arm/mach-exynos/suspend.c
> @@ -285,7 +285,7 @@ static void exynos_pm_set_wakeup_mask(void)
>  	 * Set wake-up mask registers
>  	 * EXYNOS_EINT_WAKEUP_MASK is set by pinctrl driver in late suspend.
>  	 */
> -	pmu_raw_writel(exynos_irqwake_intmask & ~(1 << 31), S5P_WAKEUP_MASK);
> +	pmu_raw_writel(exynos_irqwake_intmask & ~(BIT(31)), S5P_WAKEUP_MASK);

Parens around BIT() are no longer required.

>  }
>  
>  static void exynos_pm_enter_sleep_mode(void)
> -- 
> 2.11.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
