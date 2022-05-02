Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08A655172E1
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 17:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385885AbiEBPmR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 11:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357481AbiEBPmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 11:42:12 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71ED3A180;
        Mon,  2 May 2022 08:38:43 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id i62so11964899pgd.6;
        Mon, 02 May 2022 08:38:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xdAYU3mu3q5iKW/q53x7SG0PmMFu/IJ99F9X+I1LBFA=;
        b=n+sdzeWg2S/gnK+vDOIvL6IUbN3m/ZsZjzFb11eZoR9Ocah7YJVO2WiV41qchObcfb
         DQoBAV7ZWycdznoAT+bkWgo/wu+1wDV1bIUkSxqup4K24uuli3THOxTxyw5X5d53wgme
         WcsN0rdXUDiQCbaE2BiYM+YRj9TzgmIUMpvqiw3DgUAYB77r1iQIEojYxiA62BjPH8RM
         iKwEObMzsKXIe5T1OWURADziMPdtdHkUN1OxLhRHsrdiQj28siLmQYHweNGUt6WE2RWU
         4RoD4QWsGkku1xASAbiwviIYb1qjscuQqHCmPnV7Xwb2MQ5+T3WoFFqH/wvbUUW3/9i6
         dZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xdAYU3mu3q5iKW/q53x7SG0PmMFu/IJ99F9X+I1LBFA=;
        b=3RQ2j7C3i6zF27z9Ludt7jwycfyMd0Sr+Y1cZxVUkbGPnkrRNsveMQojZhGJQosuop
         8yE9/KfXeRLMzXZaRRgrn1Ntm8QCR3eP8rWnIz2n5DZWafAz7U7j1sh/5IuepY2tKgai
         37+aEdmSp0xmC2KAqnRgCMH43YRidguCnac2MPUSOjssGIpq5SGHQgt/8qHNn2cdwS15
         /nclST37ImbBCKDEHZGymaHHDgb5zg0u51a5PxU0fKqvGUld9GlTTJwQwwGCfZzdJpoR
         NYUzP5ADnGWpYwVmveaRGUXZAF8Dy3qokB4TAlrZzIYlncXleoZUA12QULF6P5Y+YsFi
         8OnA==
X-Gm-Message-State: AOAM533jKWvy34XzFjxJ0mmS/jyNlT7voQYsdPptPBuwES6EMTvYiyKY
        4q2BK+wvG8Vv3V4QulspAX8=
X-Google-Smtp-Source: ABdhPJyFyZFQ5alP4D0nGrJsTy5roBCXXaX5AecPC5DucA/TU9ZDaKugYKQuLpePce1AAM16r6umMQ==
X-Received: by 2002:a05:6a00:846:b0:50d:f02f:bb46 with SMTP id q6-20020a056a00084600b0050df02fbb46mr4382838pfk.74.1651505921477;
        Mon, 02 May 2022 08:38:41 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id j11-20020aa7800b000000b0050dc76281basm5027174pfi.148.2022.05.02.08.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 08:38:40 -0700 (PDT)
Message-ID: <a02821ab-db4f-5bff-2a98-7d74032a0652@gmail.com>
Date:   Mon, 2 May 2022 08:38:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 06/30] soc: bcm: brcmstb: Document panic notifier action
 and remove useless header
Content-Language: en-US
To:     "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, coresight@lists.linaro.org,
        linuxppc-dev@lists.ozlabs.org, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-um@lists.infradead.org, linux-xtensa@linux-xtensa.org,
        netdev@vger.kernel.org, openipmi-developer@lists.sourceforge.net,
        rcu@vger.kernel.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org, x86@kernel.org,
        kernel-dev@igalia.com, kernel@gpiccoli.net, halves@canonical.com,
        fabiomirmar@gmail.com, alejandro.j.jimenez@oracle.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bp@alien8.de,
        corbet@lwn.net, d.hatayama@jp.fujitsu.com,
        dave.hansen@linux.intel.com, dyoung@redhat.com,
        feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, Brian Norris <computersforpeace@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Markus Mayer <mmayer@broadcom.com>
References: <20220427224924.592546-1-gpiccoli@igalia.com>
 <20220427224924.592546-7-gpiccoli@igalia.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220427224924.592546-7-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/27/2022 3:49 PM, Guilherme G. Piccoli wrote:
> The panic notifier of this driver is very simple code-wise, just a memory
> write to a special position with some numeric code. But this is not clear
> from the semantic point-of-view, and there is no public documentation
> about that either.
> 
> After discussing this in the mailing-lists [0] and having Florian explained
> it very well, this patch just document that in the code for the future
> generations asking the same questions. Also, it removes a useless header.
> 
> [0] https://lore.kernel.org/lkml/781cafb0-8d06-8b56-907a-5175c2da196a@gmail.com
> 
> Fixes: 0b741b8234c8 ("soc: bcm: brcmstb: Add support for S2/S3/S5 suspend states (ARM)")
> Cc: Brian Norris <computersforpeace@gmail.com>
> Cc: Doug Berger <opendmb@gmail.com>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Justin Chen <justinpopo6@gmail.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Markus Mayer <mmayer@broadcom.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Likewise, I am not sure if the Fixes tag is necessary here.
-- 
Florian
