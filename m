Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4783434D72
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 16:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhJTOZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 10:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbhJTOZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 10:25:32 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478A3C06161C;
        Wed, 20 Oct 2021 07:23:18 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id i5so10015281pla.5;
        Wed, 20 Oct 2021 07:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1+wO52EUtHQ326ESucN0rcfKouiHhmJ3JHdJ375dyL8=;
        b=KeHs522TBRCaRxTAiW+bosO8q0FZN+hQzkIq7RjSB9JeP/QBnkLl3Ryr7RPyHboFla
         bdiWcsbeW5S6ZcLaWn0YxsPm7SKDgnc/dC/HpQUp7dCEs/9I/z2g3Z3YnxLWJgxz08Xc
         uAK3JO7VZSRag4B4+K0rg9FISkr2ms7WiPBZ/8GzpFXva7XyqP3oqunzDlHJGS4PcOFb
         4+Oo9Pc9hcNcqF+hTDnCM21jQEv3TxpVXDSEWLIlQLElO35Ig0VqsHE6SY3zSK72ZirL
         KsSbCRyEmFIdm1HP1BOhtCmNE2SOauIOWKN4HnOXQXG4Ky1OOncCJXZyR5GAauN+yZxu
         wNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1+wO52EUtHQ326ESucN0rcfKouiHhmJ3JHdJ375dyL8=;
        b=Ht6RRu1HAzXq2BG4wYrLSZy1jRG115F992JXd/zAZ79ykC6fCzzGTt4U4LoC8ZVVLr
         K2WvKaYtnzXtJARZwcbNesNTyO/UFr5Wqw24dq/6r23Rd0pklChdNixoOMhGt+qqzecE
         2QxP/bVGN03BTBR9A/JBJCXrdqyRjWNWkmiwgbbkyIi0e6ItAfHXU2qXye0BUQYKI4vC
         awvyWp2fm0+RlB1YQve9Wb3cBXZ9CK17ZIHMQVIOxKblrZVg77PcquXxcHv6ZEv00BsP
         PqQKLwXGFjQ8+wqMHY/4W/x3OUGWVqJZOnJhn1C/K2F4c2z59monvdyy1KtNL5i4mO5b
         R1Jg==
X-Gm-Message-State: AOAM532TKstK15d/YYVW8EqvxJaAwU0L58DWRYjUnLYDXxJ9du4RiMZ3
        O986qfJPngByu/bQ5fNrQUg=
X-Google-Smtp-Source: ABdhPJw/t5cv2TX/FltMTLi8gEkjaeB/miH3KusmWaYCc57vmj9qBYB7O6ukrxDxKulCghbNWQ9oXQ==
X-Received: by 2002:a17:90a:df91:: with SMTP id p17mr7711069pjv.185.1634739797840;
        Wed, 20 Oct 2021 07:23:17 -0700 (PDT)
Received: from ?IPV6:2404:f801:0:6:8000::a31c? ([2404:f801:9000:1a:efeb::a31c])
        by smtp.gmail.com with ESMTPSA id j8sm2665985pfe.105.2021.10.20.07.23.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 07:23:17 -0700 (PDT)
Message-ID: <32336f13-fa66-670d-0ea3-7822bd5b829b@gmail.com>
Date:   Wed, 20 Oct 2021 22:23:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] x86/sev-es: Expose __sev_es_ghcb_hv_call() to call ghcb
 hv call out of sev code
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        jroedel@suse.de, brijesh.singh@amd.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, tj@kernel.org, aneesh.kumar@linux.ibm.com,
        saravanand@fb.com, hannes@cmpxchg.org, rientjes@google.com,
        michael.h.kelley@microsoft.com, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        konrad.wilk@oracle.com, hch@lst.de, robin.murphy@arm.com,
        joro@8bytes.org, parri.andrea@gmail.com, dave.hansen@intel.com
References: <2772390d-09c1-80c1-082f-225f32eae4aa@gmail.com>
 <20211020062321.3581158-1-ltykernel@gmail.com> <YW/oaZ2GN15hQdyd@zn.tnic>
 <c5b55d93-14c4-81cf-e999-71ad5d6a1b41@gmail.com> <YXAcGtxe08XiHBFH@zn.tnic>
 <62ffaeb4-1940-4934-2c39-b8283d402924@amd.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <62ffaeb4-1940-4934-2c39-b8283d402924@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On 10/20/2021 9:56 PM, Tom Lendacky wrote:
> On 10/20/21 8:39 AM, Borislav Petkov wrote:
>> On Wed, Oct 20, 2021 at 08:39:59PM +0800, Tianyu Lan wrote:
>>> Hyper-V runs paravisor in guest VMPL0 which emulates some functions
>>> (e.g, timer, tsc, serial console and so on) via handling VC exception.
>>> GHCB pages are allocated and set up by the paravisor and report to Linux
>>> guest via MSR register.Hyper-V SEV implementation is unenlightened guest
>>> case which doesn't Linux doesn't handle VC and paravisor in the VMPL0
>>> handle it.
>>
>> Aha, unenlightened.
>>
>> So why don't you export the original function by doing this (only
>> partial diff to show intent only):

This follows Joreg's previous comment and I implemented similar version 
in the V! patchset([PATCH 05/13] HV: Add Write/Read MSR registers via 
ghcb page https://lkml.org/lkml/2021/7/28/668).
"Instead, factor out a helper function which contains what Hyper-V needs 
and use that in sev_es_ghcb_hv_call() and Hyper-V code."

https://lkml.org/lkml/2021/8/2/375

>>
>> ---
>> diff --git a/arch/x86/kernel/sev-shared.c b/arch/x86/kernel/sev-shared.c
>> index f1d513897baf..bfe82f58508f 100644
>> --- a/arch/x86/kernel/sev-shared.c
>> +++ b/arch/x86/kernel/sev-shared.c
>> @@ -125,7 +125,7 @@ static enum es_result verify_exception_info(struct 
>> ghcb *ghcb, struct es_em_ctxt
>>       return ES_VMM_ERROR;
>>   }
>> -static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb,
>> +static enum es_result sev_es_ghcb_hv_call(struct ghcb *ghcb, bool 
>> set_ghcb_msr,
>>                         struct es_em_ctxt *ctxt,
>>                         u64 exit_code, u64 exit_info_1,
>>                         u64 exit_info_2)
>> @@ -138,7 +138,14 @@ static enum es_result sev_es_ghcb_hv_call(struct 
>> ghcb *ghcb,
>>       ghcb_set_sw_exit_info_1(ghcb, exit_info_1);
>>       ghcb_set_sw_exit_info_2(ghcb, exit_info_2);
>> -    sev_es_wr_ghcb_msr(__pa(ghcb));
>> +    /*
>> +     * Hyper-V unenlightened guests use a paravisor for communicating 
>> and
>> +     * GHCB pages are being allocated by that paravisor which uses a
>> +     * different MSR and protocol.
> 
> Just to clarify the comment, the paravisor uses the same GHCB MSR and 
> GHCB protocol, it just can't use __pa() to get the address of the GHCB. 
> So I expect that the Hyper-V support sets the address properly before 
> calling this function.
> 
> Thanks,
> Tom
> 
>> +     */
>> +    if (set_ghcb_msr)
>> +        sev_es_wr_ghcb_msr(__pa(ghcb));
>> +
>>       VMGEXIT();
>>       return verify_exception_info(ghcb, ctxt);
>>
>>
