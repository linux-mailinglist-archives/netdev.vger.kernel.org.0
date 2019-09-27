Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC2BC0228
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 11:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfI0JUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 05:20:40 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:40069 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfI0JUj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 05:20:39 -0400
Received: by mail-lf1-f66.google.com with SMTP id d17so1370699lfa.7
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 02:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZUJ1/Iwwp/mWKX1v6738rug/Uwulg67MH6fF2LkIHoU=;
        b=fYnQUV9aHYiNDRG0ybNWFU/6abt78WerVfUTzWshQ7e1bblOYhLBDafRZrDnXFV55j
         5PJQgGUdwzn0Iy4m1el8QIV1iolOzPuYN8+EuXFNmCo4UL24h5Qng08HNEHJpI/E/ZKg
         07tLg877fK5O/XHo9kLAzHdxN8xnw3Zso3rMnyu0SqQvM8/jFGnGsys3PStlTFcQJTDi
         71kh9G7Cr3kOlRrNjt010xNmqHm/5tIAwYiiK4Ag/US4I/Xc39F4Kq6S+9Ivhs6ArJho
         FJduxbBX7qveLEe7UlrGWHtaMw5etZ3DtAP4BEoYARJQL843vFrcQi/99OAVbzyZDWkF
         MlyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZUJ1/Iwwp/mWKX1v6738rug/Uwulg67MH6fF2LkIHoU=;
        b=QexPm6JoBP5muHikzxcMqGY4QEUS6IBiuco7yEy6HzaUbHBxEee2pC4Q71bdFvC1Pa
         baud6ydZa9M/TpfkI8crnm7V9mkY690iUWYnnV0oEh1jf+ZNfVcPnzjudknI0LLl4c+e
         0yyhULgif6ZSAG2oxxPUKOjyNr1XiR1x2jSs27xHxeMvxvnTkm1wGDLrC0ti0fkjmECN
         Y2QyH7E07QY7ThpEyfqrZQ0GGRZ8DM5jqsRSrnk2mikyHVeGSugkI/FpCziuKnOz41q9
         nZ3Lig/o1XOhH0sRQaB6XhN1Zi5v1UO0QW9nIKObupddn/2E5LOxnCaUQpaeYWL53dOt
         7/Yw==
X-Gm-Message-State: APjAAAVHCRA7/BUjBEJmjYu5ME+czPUVJYWPyZZ1uUBFn8/DW//kW2Yg
        l6usMzWpuE1cUb5R/2VAQDIhEg==
X-Google-Smtp-Source: APXvYqyaCrwz/qm98j1MtO5pqAPgEl3ED11Gh+OFBBX48Aefnwmp87aL9fjMp6c5WyO4uFR7GlAuDA==
X-Received: by 2002:a19:f247:: with SMTP id d7mr1946420lfk.191.1569576037260;
        Fri, 27 Sep 2019 02:20:37 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:8df:57d9:c46b:3c97:5028:3a4f? ([2a00:1fa0:8df:57d9:c46b:3c97:5028:3a4f])
        by smtp.gmail.com with ESMTPSA id q3sm341838ljq.4.2019.09.27.02.20.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Sep 2019 02:20:36 -0700 (PDT)
Subject: Re: [RFC PATCH v4 3/5] psci: Add hvc call service for ptp_kvm.
To:     Jianyong Wu <jianyong.wu@arm.com>, netdev@vger.kernel.org,
        yangbo.lu@nxp.com, john.stultz@linaro.org, tglx@linutronix.de,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
        Will.Deacon@arm.com, suzuki.poulose@arm.com
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Steve.Capper@arm.com, Kaly.Xin@arm.com, justin.he@arm.com,
        nd@arm.com
References: <20190926114212.5322-1-jianyong.wu@arm.com>
 <20190926114212.5322-4-jianyong.wu@arm.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <3586ca5b-7abb-12b2-2368-cbc09fe3777f@cogentembedded.com>
Date:   Fri, 27 Sep 2019 12:20:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190926114212.5322-4-jianyong.wu@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 26.09.2019 14:42, Jianyong Wu wrote:

> This patch is the base of ptp_kvm for arm64.
> ptp_kvm modules will call hvc to get this service.
> The service offers real time and counter cycle of host for guest.
> 
> Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
> ---
>   include/linux/arm-smccc.h | 12 ++++++++++++
>   virt/kvm/arm/psci.c       | 18 ++++++++++++++++++
>   2 files changed, 30 insertions(+)

[...]
> diff --git a/virt/kvm/arm/psci.c b/virt/kvm/arm/psci.c
> index 0debf49bf259..3f30fc42a5ca 100644
> --- a/virt/kvm/arm/psci.c
> +++ b/virt/kvm/arm/psci.c
[...]
> @@ -431,6 +433,22 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>   	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>   		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>   		break;
> +	/*
> +	 * This will used for virtual ptp kvm clock. three
                     ^ be?                            ^ T

[...]

MBR, Sergei
