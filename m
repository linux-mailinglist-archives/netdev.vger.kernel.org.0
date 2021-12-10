Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF1846FFC1
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 12:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240314AbhLJLa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 06:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbhLJLa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 06:30:27 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04985C061746;
        Fri, 10 Dec 2021 03:26:53 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id r5so7806846pgi.6;
        Fri, 10 Dec 2021 03:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oNMML2GUfpRe4KuxNkgjDIBCEtPq+5IBWg/SvCiB1ac=;
        b=R6WJg/vOJke+Pss70tPbsPfFF/c3xP//0lNWb4hUhYl4MWKxQP2AhRoJk4Y5bJnZp1
         KlS/DCpvqpFeiAygTjN3XgOkI4wsSUC3pOrCoqxfXll66oNqjjEsxdBGCU8QLOGpiVFR
         LWobxq8LFE1rEMc9YMoXunbOVZdz+3AjoVc8Kg1y1K0br5h1EYdR+RZpCv+3N4AQ+bZY
         pcM/MyWJuqJ15I3uei6a2bY9gaYAbKfpGIxypgOKVezQsvr67voKcAS9cTyw+4bd89zI
         U6kMYbLLJuqyUsx1sojCQ4Giu6rXvLiH2AL0GvH1cco0m27EzFRtcTcBh4LPEZ09Zf0b
         hZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oNMML2GUfpRe4KuxNkgjDIBCEtPq+5IBWg/SvCiB1ac=;
        b=oe7DT9hup1Ybt4K9Aw9x06z2lhJGiSASd1LxlOnE2k9YU4hB0jN/LiknrD8f2M/6AK
         7iS8Sm46A5/1wVwUtFD6107X5ucOVPCXTy/FiU6uaVQdd4zXZ9UTVUI7WV8uNCPIzGzp
         mrpLvHAkEs+yS09Y91czkXNubyyZ1f/tuFAfhmCLS984zYwU4EGkkLHjvK/BVgDmnZVm
         6wtpJz4QBmrvtiTOGQDfgoAzkX+0o1lnP23vXGKmY6qYuhvKVH2xm9JIuvwXWrkouDT6
         1ZwrP+NQoCCdy9KqByzC3tyZDdv6e8Jo+Up+/HJFFk80TZC3gyxADcKlaKkPBjDZzJuG
         ngXw==
X-Gm-Message-State: AOAM530xXfVP52+SZ3J9blf3A0aqSjz4GJiqQOovt0Bzr+SVXxnEvPW6
        9sTbn5ljHkE46HgFsdLAIOw=
X-Google-Smtp-Source: ABdhPJwHRIt+DqTuxKr3Ov92YpyxCIqQ63650YjNIjSjqT5l4iFIeahNGLj6YxvmmYkMJGFzIrL5ng==
X-Received: by 2002:a63:d753:: with SMTP id w19mr5091188pgi.174.1639135612496;
        Fri, 10 Dec 2021 03:26:52 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:1a:efea::50b])
        by smtp.gmail.com with ESMTPSA id on6sm16041313pjb.47.2021.12.10.03.26.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 03:26:52 -0800 (PST)
Message-ID: <e4125f7b-fdd9-dc0d-63d0-93d841dbb3c3@gmail.com>
Date:   Fri, 10 Dec 2021 19:26:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH V6 2/5] x86/hyper-v: Add hyperv Isolation VM check in the
 cc_platform_has()
Content-Language: en-US
To:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "hch@infradead.org" <hch@infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
Cc:     "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "hch@lst.de" <hch@lst.de>, "joro@8bytes.org" <joro@8bytes.org>,
        "parri.andrea@gmail.com" <parri.andrea@gmail.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>
References: <20211207075602.2452-1-ltykernel@gmail.com>
 <20211207075602.2452-3-ltykernel@gmail.com>
 <MWHPR21MB1593F014EC440F5DEDCFDDFFD7709@MWHPR21MB1593.namprd21.prod.outlook.com>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <MWHPR21MB1593F014EC440F5DEDCFDDFFD7709@MWHPR21MB1593.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10/2021 4:38 AM, Michael Kelley (LINUX) wrote:
> From: Tianyu Lan <ltykernel@gmail.com> Sent: Monday, December 6, 2021 11:56 PM
>>
>> Hyper-V provides Isolation VM which has memory encrypt support. Add
>> hyperv_cc_platform_has() and return true for check of GUEST_MEM_ENCRYPT
>> attribute.
>>
>> Signed-off-by: Tianyu Lan <Tianyu.Lan@microsoft.com>
>> ---
>> Change since v3:
>> 	* Change code style of checking GUEST_MEM attribute in the
>> 	  hyperv_cc_platform_has().
>> ---
>>   arch/x86/kernel/cc_platform.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/arch/x86/kernel/cc_platform.c b/arch/x86/kernel/cc_platform.c
>> index 03bb2f343ddb..47db88c275d5 100644
>> --- a/arch/x86/kernel/cc_platform.c
>> +++ b/arch/x86/kernel/cc_platform.c
>> @@ -11,6 +11,7 @@
>>   #include <linux/cc_platform.h>
>>   #include <linux/mem_encrypt.h>
>>
>> +#include <asm/mshyperv.h>
>>   #include <asm/processor.h>
>>
>>   static bool __maybe_unused intel_cc_platform_has(enum cc_attr attr)
>> @@ -58,9 +59,16 @@ static bool amd_cc_platform_has(enum cc_attr attr)
>>   #endif
>>   }
>>
>> +static bool hyperv_cc_platform_has(enum cc_attr attr)
>> +{
>> +	return attr == CC_ATTR_GUEST_MEM_ENCRYPT;
>> +}
>>
>>   bool cc_platform_has(enum cc_attr attr)
>>   {
>> +	if (hv_is_isolation_supported())
>> +		return hyperv_cc_platform_has(attr);
>> +
>>   	if (sme_me_mask)
>>   		return amd_cc_platform_has(attr);
>>
> 
> Throughout Linux kernel code, there are about 20 calls to cc_platform_has()
> with CC_ATTR_GUEST_MEM_ENCRYPT as the argument.  The original code
> (from v1 of this patch set) only dealt with the call in sev_setup_arch().   But
> with this patch, all the other calls that previously returned "false" will now
> return "true" in a Hyper-V Isolated VM.  I didn't try to analyze all these other
> calls, so I think there's an open question about whether this is the behavior
> we want.
> 

CC_ATTR_GUEST_MEM_ENCRYPT is for SEV support so far. Hyper-V Isolation
VM is based on SEV or software memory encrypt. Most checks can be 
reused. The difference is that SEV code use encrypt bit in the page
table to encrypt and decrypt memory while Hyper-V uses vTOM. But the sev
memory encrypt mask "sme_me_mask" is unset in the Hyper-V Isolation VM
where claims sev and sme are unsupported. The rest of checks for mem enc
bit are still safe. So reuse CC_ATTR_GUEST_MEM_ENCRYPT for Hyper-V.


