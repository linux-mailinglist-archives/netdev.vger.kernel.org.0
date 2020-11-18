Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60952B7A4A
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 10:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgKRJXm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 04:23:42 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35709 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgKRJXm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 04:23:42 -0500
Received: by mail-wm1-f66.google.com with SMTP id w24so2019444wmi.0;
        Wed, 18 Nov 2020 01:23:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2nsnjnOqDV6WPzahzgOv8VDTMdt+UU18h3NLzAQiSpA=;
        b=X5DWRRpLxLa2YwmpnxCDdJ9m2LJqPGahM/mvYxyBmEzouI6woOAdiclOXCRDK+/Ckv
         g/fBPyVpajhQ/8IdIVgnrq2DkTHQLbIltySYpK6SNrsi4rL6urTRYnF58ovnu9W8kRhP
         5akmkcElDDpyjwbI9iBQTZtvQmtpSY5GTLTYxd358utefNb+N4+JvC1ModI61825yr6r
         yeEzcwaSbeiE47oHOoMU72yrUMm28l1Knyt62GCkhyQbqI+mObM+8Spu4fCi++gy3UU5
         7dDmvcPMyd/pKdWXmMaB645OohHZcXNV9JMVkxYwVPaZPkgzxfkqRfNxTo3Oe6bhkZmw
         69OA==
X-Gm-Message-State: AOAM532xzEUwHnoW/fAmZyRrL/eotorSELX22CYYGbjdJeljfqmNYXxG
        BEMtHHfP9zpYeP54o6hxKZVL3tBGSGk=
X-Google-Smtp-Source: ABdhPJxckaDRo8U42uknkQAN3d1oqdfUPR8JMwF4vNreh318c5rq4YB0kqkTqeFa5f4PE6gRlLM59w==
X-Received: by 2002:a7b:c2ef:: with SMTP id e15mr3585111wmk.180.1605691419662;
        Wed, 18 Nov 2020 01:23:39 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id g4sm32723173wrp.0.2020.11.18.01.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 01:23:39 -0800 (PST)
Date:   Wed, 18 Nov 2020 09:23:37 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dmitry.torokhov@gmail.com, derek.kiernan@xilinx.com,
        dragan.cvetic@xilinx.com, richardcochran@gmail.com,
        linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, Wei Liu <wei.liu@kernel.org>
Subject: Re: [PATCH 2/2] x86: make hyperv support optional
Message-ID: <20201118092337.k4inzcaqxygrnqc3@liuwe-devbox-debian-v2>
References: <20201117202308.7568-1-info@metux.net>
 <20201117202308.7568-2-info@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117202308.7568-2-info@metux.net>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 09:23:08PM +0100, Enrico Weigelt, metux IT consult wrote:
> Make it possible to opt-out from hyperv support.
> 

"Hyper-V support".

Have you tested this patch? If so, how?

> Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
> ---
>  arch/x86/Kconfig                 | 7 +++++++
>  arch/x86/kernel/cpu/Makefile     | 4 ++--
>  arch/x86/kernel/cpu/hypervisor.c | 2 ++
>  drivers/hv/Kconfig               | 2 +-
>  4 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index c227c1fa0091..60aab344d6ab 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -808,6 +808,13 @@ config VMWARE_GUEST
>  	  This option enables several optimizations for running under the
>  	  VMware hypervisor.
>  
> +config HYPERV_GUEST
> +	bool "HyperV Guest support"

Hyper-V here.

> +	default y
> +	help
> +	  This option enables several optimizations for running under the
> +	  HyperV hypervisor.
> +

"for running under Hyper-V".

>  config KVM_GUEST
>  	bool "KVM Guest support (including kvmclock)"
>  	depends on PARAVIRT
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index a615b0152bf0..5536b801cb44 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -51,9 +51,9 @@ obj-$(CONFIG_X86_CPU_RESCTRL)		+= resctrl/
>  
>  obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
>  
> -obj-$(CONFIG_HYPERVISOR_GUEST)		+= hypervisor.o mshyperv.o
> +obj-$(CONFIG_HYPERVISOR_GUEST)		+= hypervisor.o
>  obj-$(CONFIG_VMWARE_GUEST)		+= vmware.o
> -
> +obj-$(CONFIG_HYPERV_GUEST)		+= mshyperv.o
>  obj-$(CONFIG_ACRN_GUEST)		+= acrn.o
>  
>  ifdef CONFIG_X86_FEATURE_NAMES
> diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
> index c0e770a224aa..32d6b2084d05 100644
> --- a/arch/x86/kernel/cpu/hypervisor.c
> +++ b/arch/x86/kernel/cpu/hypervisor.c
> @@ -37,7 +37,9 @@ static const __initconst struct hypervisor_x86 * const hypervisors[] =
>  #ifdef CONFIG_VMWARE_GUEST
>  	&x86_hyper_vmware,
>  #endif
> +#ifdef CONFIG_HYPERV_GUEST
>  	&x86_hyper_ms_hyperv,
> +#endif
>  #ifdef CONFIG_KVM_GUEST
>  	&x86_hyper_kvm,
>  #endif
> diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
> index 79e5356a737a..7b3094c59a81 100644
> --- a/drivers/hv/Kconfig
> +++ b/drivers/hv/Kconfig
> @@ -4,7 +4,7 @@ menu "Microsoft Hyper-V guest support"
>  
>  config HYPERV
>  	tristate "Microsoft Hyper-V client drivers"
> -	depends on X86 && ACPI && X86_LOCAL_APIC && HYPERVISOR_GUEST
> +	depends on X86 && ACPI && X86_LOCAL_APIC && HYPERV_GUEST
>  	select PARAVIRT
>  	select X86_HV_CALLBACK_VECTOR
>  	help

Maybe that one should be moved to x86/Kconfig and used instead?

Wei.

> -- 
> 2.11.0
> 
