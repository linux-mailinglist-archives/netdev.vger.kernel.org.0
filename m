Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512336180A3
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 16:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232078AbiKCPJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 11:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232023AbiKCPJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 11:09:04 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2481A381;
        Thu,  3 Nov 2022 08:07:46 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id q9so1874247pfg.5;
        Thu, 03 Nov 2022 08:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w2z6fO+MbyvEiP5JpeiVd1gSvr6rs1hB7YCmNmUxll4=;
        b=gHTFxAQAhXrKKmhv7RuDgqKnsGsxCqlqugARUQMfSbZRJUyGGl3mL8wkQSmtx1yM0k
         rWAXPxKYKEmKaR06qaWeVuQv+zd78X+kjfMmieFmqP0YltSfhp8sGGWQQEsfT/puNDOq
         iGw8EefwxKFixX+hoGi1CiYBQp+RX63QyMGoeVW2KwhYfwJ055FVmGQXQ8av3FmL62zq
         B/13wxMSpgGo5/XcRvsbgI5ffvGI4BWlUQI0jz0DMvA8gjXVcQ8BgeliRdhw+5lJOzoJ
         5L3Yt+biFkv3NnET5xb0mzInjQ+qeLoV+u5gsS8hS3Ojr9W8YmLeUJHtr/quFyYC8F1i
         We9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w2z6fO+MbyvEiP5JpeiVd1gSvr6rs1hB7YCmNmUxll4=;
        b=tquTsXCCv0C3I8eUgFCkftRbl4himl8XP3g87tyu9BEttGI24ps0NrLiQyIqDyoWTE
         gqH3sKpRgxD1Ja9NhRfSdavDpJ0FdsR9J3pjqGTSn+KHpum8MmEo4xv/SjZtAQ832NXE
         kNECsoYMoxUxOEjqIPHupA+PHD9crvulTaz8CieW1rY0rSbYJi1I0N++mFXMmsMY4t1s
         RaoRdPz0EuP3/wuBPP0N6ttoW1n5RY48VhbTC+ZhRd6hsVZ274+yztirAijSYX4TvTsP
         TGd4q+n1H5KYQr25fOOIiCkXBlCfynfB53BkUJjTnpNRMN+Gy7/q7gOFV9MkTQ2q69eb
         rO+A==
X-Gm-Message-State: ACrzQf1lB1soWPpgArkcZDvQnEF1YiGxMdipPO91CnelRavact7GYsxA
        WH8mxpfIaW34UvV5KuPRp7yQx7ce33ny6bL+
X-Google-Smtp-Source: AMsMyM64XJzUHkbNPgJU9Pbog8Ij7QoURi5yiSqvzbNa01qcX2i7L0deLMBHbJeokkmw94e2KlZHQQ==
X-Received: by 2002:a63:b12:0:b0:44a:d193:6b16 with SMTP id 18-20020a630b12000000b0044ad1936b16mr26809861pgl.604.1667488066226;
        Thu, 03 Nov 2022 08:07:46 -0700 (PDT)
Received: from ?IPV6:2404:f801:0:5:8000::75b? ([2404:f801:9000:1a:efea::75b])
        by smtp.gmail.com with ESMTPSA id r12-20020a63ec4c000000b0046ae818b626sm896747pgj.30.2022.11.03.08.07.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 08:07:45 -0700 (PDT)
Message-ID: <900971fc-e8c0-b81b-8836-c416554a4c22@gmail.com>
Date:   Thu, 3 Nov 2022 23:07:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 08/12] Drivers: hv: vmbus: Remove second way of mapping
 ring buffers
Content-Language: en-US
To:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lpieralisi@kernel.org,
        robh@kernel.org, kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
References: <1666288635-72591-1-git-send-email-mikelley@microsoft.com>
 <1666288635-72591-9-git-send-email-mikelley@microsoft.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <1666288635-72591-9-git-send-email-mikelley@microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/2022 1:57 AM, Michael Kelley wrote:
> With changes to how Hyper-V guest VMs flip memory between private
> (encrypted) and shared (decrypted), it's no longer necessary to
> have separate code paths for mapping VMBus ring buffers for
> for normal VMs and for Confidential VMs.
> 
> As such, remove the code path that uses vmap_pfn(), and set
> the protection flags argument to vmap() to account for the
> difference between normal and Confidential VMs.
> 
> Signed-off-by: Michael Kelley<mikelley@microsoft.com>
> ---

Reviewed-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
