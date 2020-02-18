Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89507162D17
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 18:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgBRRfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 12:35:18 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35156 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbgBRRfS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 12:35:18 -0500
Received: by mail-wm1-f66.google.com with SMTP id b17so3877503wmb.0
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 09:35:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RILWoXXun3vjq+42du8IC+UmbZgRdTK1KmCkih2WLgI=;
        b=GcgG0g7oTyfqugWUxGmwTGyE0HE9J8IbJgdE4weTCvpOmnnj/PLJJRvmAzk5qQMHn3
         le7wf/QB761zG1i/AU9+ZziDLItIJNxoADUEkKhMRod2TyJvMxCrB5Y074ZElULEV5lO
         TDK/VyePvPm3q8pHXP2YiMdh30eVSqWmWJZv9gg4y9jYaTjJrQVonXIZo/BUoE+vJHcp
         QYwbYS3MqIiB0EG5f+hBQ9/W3nvuZKxwLXkef12rCY6gruqCcqklg7TJMKl2XAonkFkv
         +hIx5GlKXORzaP67V9J5jvF4nyqBgdyqgp/zAQGgTQX02nrDI5iNV58lh0752z4Adlpg
         OQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RILWoXXun3vjq+42du8IC+UmbZgRdTK1KmCkih2WLgI=;
        b=bkgsFbM8rTIHtfbuMeHnypEXIoaoTNslq26AxlIeAEV0JXQhuZiArydSUk8Jy9Le1/
         jpgjrP8IntmpxZiUB3XTIYlTjYMt18eDZPswcwphX0E+mNBtnQzLP0PLVkZmVXs9xLAq
         VzOGn1C7x/pzDkhb21J9IYOA8BDWU0zAsDPD7UTVmpwag8OlqRlwZyaV5dx8m28uQeNM
         Ig/Pj4jaXNEZ1/S1XnnFOBE6FQwHFCQS/LDu4SwO0nO0vp6nGiu6cNIpvO1gTZb09Peh
         e+xFzykVfDQSBqXpRMeAWdMwthTrS69B595QDW9fkV2DO/7+Ru+G4s44Kq7AhePGaydI
         KqCw==
X-Gm-Message-State: APjAAAUQZjdTg4aDXdWv8WUcFvWalktFB03JFuM4jvvaG/OZmvG1y/Ej
        rTlEs/4eZwFIP7fq028gsoHXig==
X-Google-Smtp-Source: APXvYqwV2asQG46dY9dPtK3kmRKdgGKPf77Ywn9l/NS4zXqZ/iEYlIgdCdisI+0MnwB3PrsCC0zWtg==
X-Received: by 2002:a05:600c:2:: with SMTP id g2mr4245334wmc.18.1582047315026;
        Tue, 18 Feb 2020 09:35:15 -0800 (PST)
Received: from ?IPv6:2a01:e34:ed2f:f020:59:7ef1:274e:1203? ([2a01:e34:ed2f:f020:59:7ef1:274e:1203])
        by smtp.googlemail.com with ESMTPSA id z8sm2273263wrv.74.2020.02.18.09.35.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 09:35:14 -0800 (PST)
Subject: Re: [RFC PATCH 03/11] cpuidle: Remove Calxeda driver
To:     Rob Herring <robh@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        soc@kernel.org, Andre Przywara <andre.przywara@arm.com>,
        Robert Richter <rrichter@marvell.com>,
        Jon Loeliger <jdl@jdl.com>, Alexander Graf <graf@amazon.com>,
        Matthias Brugger <mbrugger@suse.com>,
        Mark Langsdorf <mlangsdo@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Cornelia Huck <cohuck@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org,
        James Morse <james.morse@arm.com>,
        Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pm@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        netdev@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robin Murphy <robin.murphy@arm.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Will Deacon <will@kernel.org>
References: <20200218171321.30990-1-robh@kernel.org>
 <20200218171321.30990-4-robh@kernel.org>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Autocrypt: addr=daniel.lezcano@linaro.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <17a4842d-7ecb-a9c8-6f1e-9295b9b5f00d@linaro.org>
Date:   Tue, 18 Feb 2020 18:35:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200218171321.30990-4-robh@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/02/2020 18:13, Rob Herring wrote:
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>


> ---
> Do not apply yet.
> 
>  drivers/cpuidle/Kconfig.arm       |  7 ---
>  drivers/cpuidle/Makefile          |  1 -
>  drivers/cpuidle/cpuidle-calxeda.c | 72 -------------------------------
>  3 files changed, 80 deletions(-)
>  delete mode 100644 drivers/cpuidle/cpuidle-calxeda.c
> 
> diff --git a/drivers/cpuidle/Kconfig.arm b/drivers/cpuidle/Kconfig.arm
> index 62272ecfa771..c2830d2ed44a 100644
> --- a/drivers/cpuidle/Kconfig.arm
> +++ b/drivers/cpuidle/Kconfig.arm
> @@ -42,13 +42,6 @@ config ARM_CLPS711X_CPUIDLE
>  	help
>  	  Select this to enable cpuidle on Cirrus Logic CLPS711X SOCs.
> 
> -config ARM_HIGHBANK_CPUIDLE
> -	bool "CPU Idle Driver for Calxeda processors"
> -	depends on ARM_PSCI && !ARM64
> -	select ARM_CPU_SUSPEND
> -	help
> -	  Select this to enable cpuidle on Calxeda processors.
> -
>  config ARM_KIRKWOOD_CPUIDLE
>  	bool "CPU Idle Driver for Marvell Kirkwood SoCs"
>  	depends on (MACH_KIRKWOOD || COMPILE_TEST) && !ARM64
> diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
> index cc8c769d7fa9..eee5f276edf7 100644
> --- a/drivers/cpuidle/Makefile
> +++ b/drivers/cpuidle/Makefile
> @@ -14,7 +14,6 @@ obj-$(CONFIG_HALTPOLL_CPUIDLE)		  += cpuidle-haltpoll.o
>  obj-$(CONFIG_ARM_MVEBU_V7_CPUIDLE) += cpuidle-mvebu-v7.o
>  obj-$(CONFIG_ARM_BIG_LITTLE_CPUIDLE)	+= cpuidle-big_little.o
>  obj-$(CONFIG_ARM_CLPS711X_CPUIDLE)	+= cpuidle-clps711x.o
> -obj-$(CONFIG_ARM_HIGHBANK_CPUIDLE)	+= cpuidle-calxeda.o
>  obj-$(CONFIG_ARM_KIRKWOOD_CPUIDLE)	+= cpuidle-kirkwood.o
>  obj-$(CONFIG_ARM_ZYNQ_CPUIDLE)		+= cpuidle-zynq.o
>  obj-$(CONFIG_ARM_U8500_CPUIDLE)         += cpuidle-ux500.o
> diff --git a/drivers/cpuidle/cpuidle-calxeda.c b/drivers/cpuidle/cpuidle-calxeda.c
> deleted file mode 100644
> index b17d9a8418b0..000000000000
> --- a/drivers/cpuidle/cpuidle-calxeda.c
> +++ /dev/null
> @@ -1,72 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0-only
> -/*
> - * Copyright 2012 Calxeda, Inc.
> - *
> - * Based on arch/arm/plat-mxc/cpuidle.c: #v3.7
> - * Copyright 2012 Freescale Semiconductor, Inc.
> - * Copyright 2012 Linaro Ltd.
> - *
> - * Maintainer: Rob Herring <rob.herring@calxeda.com>
> - */
> -
> -#include <linux/cpuidle.h>
> -#include <linux/cpu_pm.h>
> -#include <linux/init.h>
> -#include <linux/mm.h>
> -#include <linux/platform_device.h>
> -#include <linux/psci.h>
> -
> -#include <asm/cpuidle.h>
> -#include <asm/suspend.h>
> -
> -#include <uapi/linux/psci.h>
> -
> -#define CALXEDA_IDLE_PARAM \
> -	((0 << PSCI_0_2_POWER_STATE_ID_SHIFT) | \
> -	 (0 << PSCI_0_2_POWER_STATE_AFFL_SHIFT) | \
> -	 (PSCI_POWER_STATE_TYPE_POWER_DOWN << PSCI_0_2_POWER_STATE_TYPE_SHIFT))
> -
> -static int calxeda_idle_finish(unsigned long val)
> -{
> -	return psci_ops.cpu_suspend(CALXEDA_IDLE_PARAM, __pa(cpu_resume));
> -}
> -
> -static int calxeda_pwrdown_idle(struct cpuidle_device *dev,
> -				struct cpuidle_driver *drv,
> -				int index)
> -{
> -	cpu_pm_enter();
> -	cpu_suspend(0, calxeda_idle_finish);
> -	cpu_pm_exit();
> -
> -	return index;
> -}
> -
> -static struct cpuidle_driver calxeda_idle_driver = {
> -	.name = "calxeda_idle",
> -	.states = {
> -		ARM_CPUIDLE_WFI_STATE,
> -		{
> -			.name = "PG",
> -			.desc = "Power Gate",
> -			.exit_latency = 30,
> -			.power_usage = 50,
> -			.target_residency = 200,
> -			.enter = calxeda_pwrdown_idle,
> -		},
> -	},
> -	.state_count = 2,
> -};
> -
> -static int calxeda_cpuidle_probe(struct platform_device *pdev)
> -{
> -	return cpuidle_register(&calxeda_idle_driver, NULL);
> -}
> -
> -static struct platform_driver calxeda_cpuidle_plat_driver = {
> -        .driver = {
> -                .name = "cpuidle-calxeda",
> -        },
> -        .probe = calxeda_cpuidle_probe,
> -};
> -builtin_platform_driver(calxeda_cpuidle_plat_driver);
> --
> 2.20.1
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

