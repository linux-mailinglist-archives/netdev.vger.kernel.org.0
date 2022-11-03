Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C603617EB8
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 15:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiKCOB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 10:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231143AbiKCOBG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 10:01:06 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F2D17897;
        Thu,  3 Nov 2022 07:00:52 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id q9so1682499pfg.5;
        Thu, 03 Nov 2022 07:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xa+0pLAudD6PF06JImFuL7wHTWb9VCg28osWFz6WhGY=;
        b=fJPJDNbojQCIWRnIYnzAvODJUoL1TR6QAu0UwsxvlNSTyVDdKT94NGT9bNHO8H3ZGC
         Qjj1ShOVMKmQZNpRQq35lslk8d864Tn4pRM3am8HvXi0P+QvxUoVPXhbzqt9KQLIcAZj
         hDDSCBB23VxtVeyw7oDQHBf5ga3KOy7ONW3ZozO224wMLz/l6L8+kQqfu+G/fZdp6NB0
         xBc8fs150Vp7/hnwYZXhIsKnATAogsditSiwHDiznGXzlYmqvB74huK95HMmJldE+JTA
         s2lJK57Q9DP/PbWgeHEQH6yeABAMAeySnaKWytYPw6hMtbhAE1YbdlIs2M5QQC8bBlx4
         EuKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xa+0pLAudD6PF06JImFuL7wHTWb9VCg28osWFz6WhGY=;
        b=ZTal4LqpBf7xAbkbUGHbzm7jgZGk6OZDMW6vY/lDyLikzxMjairJHFf/n1n5MZvTKW
         pUfeJYjI893EdsxKA6KJKbQFn0ytsC8ItULautJ2YP4wLMly4FgPP++3Mrpbkq91XXsd
         VOgGdoZ7hF34W0AE7GENUfb8kDV/SLCLgSxC0JfcJnHyhuWCFgddFzpKZ3tWlNqeWQmi
         F9W1+/muvF3Nyam40F6EfimZw1IkoHMw78CaRIa/ZnqlL3gK/MDBZoFRKSIqvb/OGzMi
         01ndDIe2yr9V/FgATxb7VVaFWD3KF/GovgiPRLvKqCrOAvHsw/fFyscS7mxCaVDYG1RO
         HvpA==
X-Gm-Message-State: ACrzQf3WrLJ/UsS2YyD9Q+cDgB/olbcHp3yRhDgyV2AFc0+P45Xkzq8m
        bI5gFyhzlTieth+PIA+hMJ4=
X-Google-Smtp-Source: AMsMyM4O0wDTELSc3hfPrRbSa50TbC9VySJnF/LiWdrNYmNQeUji+UKtn2FJqVoSfqerI/f2rbEuzg==
X-Received: by 2002:a05:6a00:e0f:b0:56d:6e51:3060 with SMTP id bq15-20020a056a000e0f00b0056d6e513060mr22351121pfb.55.1667484051717;
        Thu, 03 Nov 2022 07:00:51 -0700 (PDT)
Received: from ?IPV6:2404:f801:0:5:8000::75b? ([2404:f801:9000:18:efec::75b])
        by smtp.gmail.com with ESMTPSA id e18-20020a17090301d200b00177f25f8ab3sm725747plh.89.2022.11.03.07.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 07:00:51 -0700 (PDT)
Message-ID: <1eedc23a-8b50-bd90-d398-cff3f22af01e@gmail.com>
Date:   Thu, 3 Nov 2022 22:00:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH 05/12] x86/hyperv: Change vTOM handling to use standard
 coco mechanisms
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
 <1666288635-72591-6-git-send-email-mikelley@microsoft.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <1666288635-72591-6-git-send-email-mikelley@microsoft.com>
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
> +
> +void __init hv_vtom_init(void)
> +{
> +	cc_set_vendor(CC_VENDOR_HYPERV);
> +	cc_set_mask(ms_hyperv.shared_gpa_boundary);
> +	physical_mask &= ms_hyperv.shared_gpa_boundary - 1;


hv_vtom_init() also works for VBS case. VBS doesn't have vTOM support
and so shared_gpa_boundary should not be applied for VBS. Here seems to 
assume ms_hyperv.shared_gpa_boundary to 0 for VBS, right?
