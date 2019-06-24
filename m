Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7564E50CE6
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 15:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbfFXN55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 09:57:57 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34784 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728664AbfFXN55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 09:57:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=J+znOVyKIP4YC32RqBS1C9KhPqih43zJm7vHjG7mLE8=; b=L0aOs5+8LuV5WNLDJCJxTC4o+
        6AyC48v+UQfYq79WfO5ytWyy4l5TcxrddC2ehtlDX95f4oqzxU2LzggM2duS1PZ4cwD2cFJF42Rdv
        QEgl94LTcRYgdyeVQP7kK9hiz/G5QBRMNksBnGjaQb57612kM8csbmJCvPMI7Fr2DJ71gKKKKRxs3
        JNEWhrrTfkSfe5u/pKMmhV1bd8An723+q2VvIKyFAddQAJW8fpFhqhSgQb+Z+TVN4yT9Tho2Xkl7U
        70pH3gJyMz8ZtAq4vjt87Jlt4bmjhS83h5iFJfdz791q7KRqREIkmOK05+LjkAPYWZal68fqnn7WA
        G8evw7PpA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:59936)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfPTZ-0008PC-EF; Mon, 24 Jun 2019 14:57:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfPTN-0006L1-Tn; Mon, 24 Jun 2019 14:57:29 +0100
Date:   Mon, 24 Jun 2019 14:57:29 +0100
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
Subject: Re: [PATCH V2 12/15] ARM: vexpress: cleanup cppcheck shifting error
Message-ID: <20190624135729.q6k5hjq3ajwhi4gb@shell.armlinux.org.uk>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
 <20190624135105.15579-13-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624135105.15579-13-tranmanphong@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 08:51:02PM +0700, Phong Tran wrote:
> [arch/arm/mach-vexpress/spc.c:366]: (error) Shifting signed 32-bit value
> by 31 bits is undefined behaviour
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
>  arch/arm/mach-vexpress/spc.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/mach-vexpress/spc.c b/arch/arm/mach-vexpress/spc.c
> index 0f5381d13494..425ce633667a 100644
> --- a/arch/arm/mach-vexpress/spc.c
> +++ b/arch/arm/mach-vexpress/spc.c
> @@ -57,8 +57,8 @@
>  
>  /* SPC CPU/cluster reset statue */
>  #define STANDBYWFI_STAT		0x3c
> -#define STANDBYWFI_STAT_A15_CPU_MASK(cpu)	(1 << (cpu))
> -#define STANDBYWFI_STAT_A7_CPU_MASK(cpu)	(1 << (3 + (cpu)))
> +#define STANDBYWFI_STAT_A15_CPU_MASK(cpu)	BIT((cpu))
> +#define STANDBYWFI_STAT_A7_CPU_MASK(cpu)	BIT((3 + (cpu)))

I guess you did this using a script, however, in the above two cases,
you don't need the extra parens - it was necessary in the original
though.

>  
>  /* SPC system config interface registers */
>  #define SYSCFG_WDATA		0x70
> @@ -69,7 +69,7 @@
>  #define A7_PERFVAL_BASE		0xC30
>  
>  /* Config interface control bits */
> -#define SYSCFG_START		(1 << 31)
> +#define SYSCFG_START		BIT(31)
>  #define SYSCFG_SCC		(6 << 20)
>  #define SYSCFG_STAT		(14 << 20)
>  
> @@ -90,8 +90,8 @@
>  #define CA15_DVFS	0
>  #define CA7_DVFS	1
>  #define SPC_SYS_CFG	2
> -#define STAT_COMPLETE(type)	((1 << 0) << (type << 2))
> -#define STAT_ERR(type)		((1 << 1) << (type << 2))
> +#define STAT_COMPLETE(type)	(BIT(0) << (type << 2))
> +#define STAT_ERR(type)		(BIT(1) << (type << 2))
>  #define RESPONSE_MASK(type)	(STAT_COMPLETE(type) | STAT_ERR(type))
>  
>  struct ve_spc_opp {
> @@ -162,7 +162,7 @@ void ve_spc_cpu_wakeup_irq(u32 cluster, u32 cpu, bool set)
>  	if (cluster >= MAX_CLUSTERS)
>  		return;
>  
> -	mask = 1 << cpu;
> +	mask = BIT(cpu);
>  
>  	if (!cluster_is_a15(cluster))
>  		mask <<= 4;
> -- 
> 2.11.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
