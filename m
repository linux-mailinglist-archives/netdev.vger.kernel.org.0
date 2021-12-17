Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E3A479375
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 19:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236418AbhLQSCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 13:02:08 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:37873 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235822AbhLQSCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 13:02:07 -0500
Received: by mail-wr1-f44.google.com with SMTP id t26so5589424wrb.4;
        Fri, 17 Dec 2021 10:02:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oMu9apPBaIi5tnaaEn/7B+TGrd8QQOY69E+E1XVDBJI=;
        b=rQiiVzDgUTRI5Aw4FhDYAb1jNDiVSrnyY735WPIpQ2mHwSdIBpd61t4lV18ihtqCBX
         g9Qp7v51MbxDsvkU1GA+VRskJPURthVlBDgaY2QeB5EkrKJxlRAyrWV8d+GwaY7dQ8DN
         Pjzq3e6X8UFatGKwaCWmKM5CcCUreAJjHSP/kcm6cJiMdQFxjsMYQ9z/ZQLtb6TBYAcZ
         OWbBNR/Eg2dur7qP9TfmcXZOI5SPC2B7HVT7Y49LTvXOpA82vDv8yXOsMA9mnxDqbN1l
         M6awgz6LRSxEBMCsyVYgkArezUopkBDeTmAq74gH8IEH6ISd6hpLsITLAEpuSTqsuIig
         nIzg==
X-Gm-Message-State: AOAM5303ZUM9l8KtGH77J5dONtbP0JmE18td727pFB/XOgwugalr59Ea
        ujbaw5AiV2ZPZQwFG0UTi3g=
X-Google-Smtp-Source: ABdhPJxZW9VkgRs6Fqo+bYWZVKfD8ydQU1cDhNtoIVkXQmcCzITHgxDeT8/9Q5qOUz6j3QSv/dbrVg==
X-Received: by 2002:a5d:58f2:: with SMTP id f18mr3409586wrd.98.1639764125887;
        Fri, 17 Dec 2021 10:02:05 -0800 (PST)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id d2sm7663606wmb.31.2021.12.17.10.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 10:02:05 -0800 (PST)
Date:   Fri, 17 Dec 2021 18:02:03 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, brijesh.singh@amd.com, konrad.wilk@oracle.com,
        hch@lst.de, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: Re: [PATCH V7 0/5] x86/Hyper-V: Add Hyper-V Isolation VM
 support(Second part)
Message-ID: <20211217180203.sb4av3a7ezqmtvu6@liuwe-devbox-debian-v2>
References: <20211213071407.314309-1-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213071407.314309-1-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 02:14:01AM -0500, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
[...]
> 
> Tianyu Lan (5):
>   swiotlb: Add swiotlb bounce buffer remap function for HV IVM
>   x86/hyper-v: Add hyperv Isolation VM check in the cc_platform_has()
>   hyper-v: Enable swiotlb bounce buffer for Isolation VM
>   scsi: storvsc: Add Isolation VM support for storvsc driver
>   net: netvsc: Add Isolation VM support for netvsc driver
> 

Applied to hyperv-next. Thanks.

Wei.
