Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41C4316B1D
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhBJQYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:24:09 -0500
Received: from foss.arm.com ([217.140.110.172]:40286 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhBJQXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 11:23:55 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA94E11D4;
        Wed, 10 Feb 2021 08:23:08 -0800 (PST)
Received: from slackpad.fritz.box (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 19FC33F73B;
        Wed, 10 Feb 2021 08:23:04 -0800 (PST)
Date:   Wed, 10 Feb 2021 16:22:14 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
        tglx@linutronix.de, pbonzini@redhat.com, seanjc@google.com,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, steven.price@arm.com,
        lorenzo.pieralisi@arm.com, sudeep.holla@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, justin.he@arm.com, jianyong.wu@arm.com,
        kernel-team@android.com
Subject: Re: [PATCH v18 5/7] clocksource: Add clocksource id for arm arch
 counter
Message-ID: <20210210162214.2e68e0da@slackpad.fritz.box>
In-Reply-To: <20210208134029.3269384-6-maz@kernel.org>
References: <20210208134029.3269384-1-maz@kernel.org>
        <20210208134029.3269384-6-maz@kernel.org>
Organization: Arm Ltd.
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Feb 2021 13:40:27 +0000
Marc Zyngier <maz@kernel.org> wrote:

> From: Jianyong Wu <jianyong.wu@arm.com>
> 
> Add clocksource id to the ARM generic counter so that it can be easily
> identified from callers such as ptp_kvm.
> 
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> Link: https://lore.kernel.org/r/20201209060932.212364-6-jianyong.wu@arm.com

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  drivers/clocksource/arm_arch_timer.c | 2 ++
>  include/linux/clocksource_ids.h      | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index d0177824c518..8f12e223703f 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -16,6 +16,7 @@
>  #include <linux/cpu_pm.h>
>  #include <linux/clockchips.h>
>  #include <linux/clocksource.h>
> +#include <linux/clocksource_ids.h>
>  #include <linux/interrupt.h>
>  #include <linux/of_irq.h>
>  #include <linux/of_address.h>
> @@ -191,6 +192,7 @@ static u64 arch_counter_read_cc(const struct cyclecounter *cc)
>  
>  static struct clocksource clocksource_counter = {
>  	.name	= "arch_sys_counter",
> +	.id	= CSID_ARM_ARCH_COUNTER,
>  	.rating	= 400,
>  	.read	= arch_counter_read,
>  	.mask	= CLOCKSOURCE_MASK(56),
> diff --git a/include/linux/clocksource_ids.h b/include/linux/clocksource_ids.h
> index 4d8e19e05328..16775d7d8f8d 100644
> --- a/include/linux/clocksource_ids.h
> +++ b/include/linux/clocksource_ids.h
> @@ -5,6 +5,7 @@
>  /* Enum to give clocksources a unique identifier */
>  enum clocksource_ids {
>  	CSID_GENERIC		= 0,
> +	CSID_ARM_ARCH_COUNTER,
>  	CSID_MAX,
>  };
>  

