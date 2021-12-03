Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60365467639
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 12:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380403AbhLCL1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 06:27:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243477AbhLCL1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 06:27:10 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A74C06173E;
        Fri,  3 Dec 2021 03:23:46 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 8so2612483pfo.4;
        Fri, 03 Dec 2021 03:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=5qOEsIBGR+o+C/Sd/hZPIupqUBKJep0nylH6kuX0Ydw=;
        b=q0Pme1zsdQbsn/2lt0smQ5WZz4BXmeUPnOOQ1muby1YCdz5IT1U09UP1jUBBmxEyPL
         NOru1PSpvapDsmivD7kZ9TeY4nIh4h/PD8j+3/Qjz2xIc5mwaH978BhiApU+G+OBiI7v
         q/qNUWoMUpEW19dcyNf3m0rrPCJ/jIoQ8FNY77sy6LiOJroeLUPHkq2iJ8x4EVpI8qAR
         W8mXj1YcXAKXWrwiItNpeq0F/HQ8gvHL9KZdDyXlYDHHoBYGqS65rRws5i+e6DI7+Z4H
         wLyunjYStAzQIYUzq5SzqUYg0FmBREr2lO1ssgnjS7fDp96JlKgzobkXt7gXkITr/9HS
         GSkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=5qOEsIBGR+o+C/Sd/hZPIupqUBKJep0nylH6kuX0Ydw=;
        b=Psa5UP3//j6a62MMK70L9SgHE0vK6+tZ3P5F78aQCWOzXjdCFOY10C9yvlOsC4t7Zu
         WsbejgW6lvs2L0qioX3GuWen0pOOV6AgAu7y7qpgopEai38W2W4qoZuRftmomolBQ7/O
         kfxkoyVPlFnyFwveBxavoTImIlH0FR4feGMnbY7BOe+oRFOsD5QRrANUzoVO66Ixc1dV
         ZB1FB2bp+o4HqCXEyfDXG0t1Rm6a2TTD7i0Xuj1ukHrMucbYHD+s8QJScDhmGwLsszG7
         X98P/l/B3eG1zJ6fjBon/RJI2+DNeS6E4BivmPL50mzOmpKnhkSAM4tQIj/KKfucKwT/
         cRSw==
X-Gm-Message-State: AOAM531QvahQh9K8vUbcRX7aAweYdlUpPGud6W7nHLG03hgXiaJam+V2
        2s5pXMx/sfNUCu7mzDgPZNc=
X-Google-Smtp-Source: ABdhPJxsVhY/s/+3W38Gewn81IUYDNoXcMk2IwynUbTteHgWiue1YzqLNGeWHF+qlwyyWcrcPKXfoQ==
X-Received: by 2002:a63:2fc5:: with SMTP id v188mr4006669pgv.190.1638530626460;
        Fri, 03 Dec 2021 03:23:46 -0800 (PST)
Received: from ?IPV6:2404:f801:0:5:8000::50b? ([2404:f801:9000:18:efec::50b])
        by smtp.gmail.com with ESMTPSA id s19sm3163132pfu.104.2021.12.03.03.23.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 03:23:46 -0800 (PST)
Message-ID: <03718701-d27b-7da9-2849-46af3efaaa98@gmail.com>
Date:   Fri, 3 Dec 2021 19:23:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH V3 2/5] x86/hyper-v: Add hyperv Isolation VM check in the
 cc_platform_has()
Content-Language: en-US
To:     Wei Liu <wei.liu@kernel.org>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jgross@suse.com, sstabellini@kernel.org,
        boris.ostrovsky@oracle.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@infradead.org,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        Tianyu.Lan@microsoft.com, thomas.lendacky@amd.com,
        xen-devel@lists.xenproject.org, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, parri.andrea@gmail.com, dave.hansen@intel.com
References: <20211201160257.1003912-1-ltykernel@gmail.com>
 <20211201160257.1003912-3-ltykernel@gmail.com>
 <20211202143946.7o7ncwcjq3t6xcrq@liuwe-devbox-debian-v2>
From:   Tianyu Lan <ltykernel@gmail.com>
In-Reply-To: <20211202143946.7o7ncwcjq3t6xcrq@liuwe-devbox-debian-v2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/2021 10:39 PM, Wei Liu wrote:
>> +static bool hyperv_cc_platform_has(enum cc_attr attr)
>> +{
>> +#ifdef CONFIG_HYPERV
>> +	if (attr == CC_ATTR_GUEST_MEM_ENCRYPT)
>> +		return true;
>> +	else
>> +		return false;
> This can be simplified as
> 
> 	return attr == CC_ATTR_GUEST_MEM_ENCRYPT;
> 
> 
> Wei.

Hi Wei:	
	Thanks for your review. Will update.
