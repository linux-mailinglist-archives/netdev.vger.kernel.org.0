Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4221F1E6785
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 18:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405102AbgE1QgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 12:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405021AbgE1QgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 12:36:18 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D037EC08C5C6;
        Thu, 28 May 2020 09:36:17 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jeLVl-0004mm-VY; Thu, 28 May 2020 18:36:06 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 3A4C7100D01; Thu, 28 May 2020 18:36:05 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, maz@kernel.org,
        richardcochran@gmail.com, Mark.Rutland@arm.com, will@kernel.org,
        suzuki.poulose@arm.com, steven.price@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        Wei.Chen@arm.com, jianyong.wu@arm.com, nd@arm.com
Subject: Re: [RFC PATCH v12 05/11] time: Add mechanism to recognize clocksource in time_get_snapshot
In-Reply-To: <20200522083724.38182-6-jianyong.wu@arm.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com> <20200522083724.38182-6-jianyong.wu@arm.com>
Date:   Thu, 28 May 2020 18:36:05 +0200
Message-ID: <87tv00nhje.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jianyong Wu <jianyong.wu@arm.com> writes:
> From: Thomas Gleixner <tglx@linutronix.de>
> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
> index 7cb09c4cf21c..a8f65b3e4ec8 100644
> --- a/kernel/time/clocksource.c
> +++ b/kernel/time/clocksource.c
> @@ -928,6 +928,9 @@ int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
>  
>  	clocksource_arch_init(cs);
>  
> +if (WARN_ON_ONCE((unsigned int)cs->id >= CSID_MAX))
> +		cs->id = CSID_GENERIC;
> +

This is white space damaged and certainly not from me.

