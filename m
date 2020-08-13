Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35635243B42
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 16:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgHMOKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 10:10:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51151 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726131AbgHMOKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 10:10:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597327829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rUbuth9YsAKh0CAOKDQ5MQczPX5161xmlduVV3vT8TM=;
        b=SxESRVCU3YHs3aVZ1Iu32VmWG4k+OAXQRUwmop3bZEd9nniv5W0UAAuF7z6konKdheJzI/
        FB14lwiCfz5ibr1BKpzAsQPU8OfmEgjJkvF+gfJo8pPdv3OoPuAKX68Y20cjRCSWfwKhiy
        9dvQwpSpo5fEJv4XpY43iSJMbnHbdkA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-iwFXWxN-PAWtqHbso4ZzBA-1; Thu, 13 Aug 2020 10:10:28 -0400
X-MC-Unique: iwFXWxN-PAWtqHbso4ZzBA-1
Received: by mail-wr1-f71.google.com with SMTP id s23so2134638wrb.12
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 07:10:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rUbuth9YsAKh0CAOKDQ5MQczPX5161xmlduVV3vT8TM=;
        b=HJ4kAkORslPE6ir9Buo15SJ+tNNhVGXVFByWuJ6yVUrhEJ+kAzXHwFG9gdgTgdss3M
         OvyUETzNzHTP9hf/Z+YBQmqDGGOCNywui/CyKz76adcUN5/xN5gO3wh49m+11g25wru8
         IxMzd9kgEuPdNbJ08stETr0asaDMvFsFUsAExTH4FkK0r8OkpiBuL7Er02loqZsFnNK6
         lOJUgunzuFf6JVd+dytvNdc62fx9/iHM1w560YJ6rKPEEZ2nvgAJDGVnXBQjj6c5Q1Ta
         6qY4JNhZ7D7J+D2IgjLNphEqYJ2VesDkYSpih11Otuo445ieSvGtVBNzkhMj/MY6BG35
         Pe0A==
X-Gm-Message-State: AOAM532SIahjnvPq7vglSJYACKV888FOdC4E7aqtYHkoQcLZZj4C2+md
        2hKeSnrR2A9FrsmRRyEiVGdaheujdg2DS8oR0igIEsVTioOvTp2XrZjtwqmFTxwtE2dWre43ZZq
        E46GqfwUZrlwsB2e0
X-Received: by 2002:a1c:3c87:: with SMTP id j129mr4485458wma.176.1597327827021;
        Thu, 13 Aug 2020 07:10:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfcHDY8aqtPDjUrHw9QpQSceS/wlBCck79TPwzjfMd/JIYRTJ5uKRTxFiNJ91HMcVXAf4w7w==
X-Received: by 2002:a1c:3c87:: with SMTP id j129mr4485434wma.176.1597327826767;
        Thu, 13 Aug 2020 07:10:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:51ad:9349:1ff0:923e? ([2001:b07:6468:f312:51ad:9349:1ff0:923e])
        by smtp.gmail.com with ESMTPSA id 32sm11176734wrh.18.2020.08.13.07.10.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Aug 2020 07:10:26 -0700 (PDT)
Subject: Re: [RFC PATCH 6/7] core/metricfs: expose x86-specific irq
 information through metricfs
To:     Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Adams <jwadams@google.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>
References: <20200807212916.2883031-1-jwadams@google.com>
 <20200807212916.2883031-7-jwadams@google.com>
 <87mu2yluso.fsf@nanos.tec.linutronix.de>
 <2500b04e-a890-2621-2f19-be08dfe2e862@redhat.com>
 <87a6yylp4x.fsf@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ffeac3eb-fbd5-a605-c6a5-0456813bd918@redhat.com>
Date:   Thu, 13 Aug 2020 16:10:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <87a6yylp4x.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/08/20 14:13, Thomas Gleixner wrote:
>>>> Add metricfs support for displaying percpu irq counters for x86.
>>>> The top directory is /sys/kernel/debug/metricfs/irq_x86.
>>>> Then there is a subdirectory for each x86-specific irq counter.
>>>> For example:
>>>>
>>>>    cat /sys/kernel/debug/metricfs/irq_x86/TLB/values
>>> What is 'TLB'? I'm not aware of any vector which is named TLB.
>> There's a "TLB" entry in /proc/interrupts.
> It's TLB shootdowns and not TLB.

Yes but it's using the shortcut name on the left of the table.

> +METRICFS_ITEM(LOC, apic_timer_irqs, "Local timer interrupts");
> +METRICFS_ITEM(SPU, irq_spurious_count, "Spurious interrupts");
> +METRICFS_ITEM(PMI, apic_perf_irqs, "Performance monitoring interrupts");
> +METRICFS_ITEM(IWI, apic_irq_work_irqs, "IRQ work interrupts");
> +METRICFS_ITEM(RTR, icr_read_retry_count, "APIC ICR read retries");
> +#endif
> +METRICFS_ITEM(PLT, x86_platform_ipis, "Platform interrupts");
> +#ifdef CONFIG_SMP
> +METRICFS_ITEM(RES, irq_resched_count, "Rescheduling interrupts");
> +METRICFS_ITEM(CAL, irq_call_count, "Function call interrupts");
> +METRICFS_ITEM(TLB, irq_tlb_count, "TLB shootdowns");

Paolo

