Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE3E50D24
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 16:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729664AbfFXOA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 10:00:59 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35072 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfFXOA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 10:00:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=P36kn/N1hL6vLQjrYYYTpIoKKbISRgU6Xg2zkTQA/00=; b=MgECc+8MDlEJIvcqAD4aHtS+q
        E49AMGRpq5ij9b70AL2iMMk78Xs6U9I533k3fy54DzceDFaRUBXqHPWBY0aeGw4nG1kaBS0t62qcx
        /GT3otQBMYifkFlND816aDaL+FX5YxBDfz2+hdzFAYEQjXQjECS7kpyrfR1f4jM2kwoVe9wwrgkuX
        gg0ZwOGDiFyjLlRIZidhrB1JlownmlZ+nlFtW+PGMpREenznUisZWiojMEykMQh3DYMAE6d+jNZDi
        yv8S6OmbWsF1EUcnZZPShye9LLcPyhYeRwEjtsmjKuYP4xxZEqe0QJbmILVeXEhP6WVKHcXtRE1cn
        9EHtNxEEQ==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:59038)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hfPWS-0008Sd-CZ; Mon, 24 Jun 2019 15:00:40 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hfPWN-0006LT-9N; Mon, 24 Jun 2019 15:00:35 +0100
Date:   Mon, 24 Jun 2019 15:00:35 +0100
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
Subject: Re: [PATCH V2 14/15] ARM: bpf: cleanup cppcheck shifting error
Message-ID: <20190624140035.36md6cp5ikniluwv@shell.armlinux.org.uk>
References: <20190623151313.970-1-tranmanphong@gmail.com>
 <20190624135105.15579-1-tranmanphong@gmail.com>
 <20190624135105.15579-15-tranmanphong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624135105.15579-15-tranmanphong@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 08:51:04PM +0700, Phong Tran wrote:
> [arch/arm/net/bpf_jit_32.c:618]: (error) Shifting signed 32-bit value by
> 31 bits is undefined behaviour
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
>  arch/arm/net/bpf_jit_32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
> index adff54c312bf..4e8ad26305ca 100644
> --- a/arch/arm/net/bpf_jit_32.c
> +++ b/arch/arm/net/bpf_jit_32.c
> @@ -612,7 +612,7 @@ static inline void emit_a32_mov_se_i64(const bool is64, const s8 dst[],
>  				       const u32 val, struct jit_ctx *ctx) {
>  	u64 val64 = val;
>  
> -	if (is64 && (val & (1<<31)))
> +	if (is64 && (val & (BIT(31))))

Extra parens are not necessary, please remove.

>  		val64 |= 0xffffffff00000000ULL;
>  	emit_a32_mov_i64(dst, val64, ctx);
>  }
> -- 
> 2.11.0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
