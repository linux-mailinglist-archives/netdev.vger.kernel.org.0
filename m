Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A0337F19C
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 05:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbhEMDVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 23:21:36 -0400
Received: from mga01.intel.com ([192.55.52.88]:3839 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230186AbhEMDVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 23:21:34 -0400
IronPort-SDR: jpcampUkN8j5ENkutHgnXttTP6UuQWbFX21OkssKz541OKdmrHjBDaIsHglOMfbgUTHtTo9wcM
 u7frGVag81Sg==
X-IronPort-AV: E=McAfee;i="6200,9189,9982"; a="220844202"
X-IronPort-AV: E=Sophos;i="5.82,296,1613462400"; 
   d="scan'208";a="220844202"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2021 20:20:20 -0700
IronPort-SDR: mj7EoWy5caILec4mbk32Dm0KgdMRCgdis+B5aYwjfmce1/m431ZPlq/GAXkQxk0u9LSJU6JlnK
 f6t1SWydDh2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,296,1613462400"; 
   d="scan'208";a="623090674"
Received: from allen-box.sh.intel.com (HELO [10.239.159.128]) ([10.239.159.128])
  by fmsmga006.fm.intel.com with ESMTP; 12 May 2021 20:20:14 -0700
Cc:     baolu.lu@linux.intel.com, linux-hyperv@vger.kernel.org,
        brijesh.singh@amd.com, linux-mm@kvack.org, hpa@zytor.com,
        kys@microsoft.com, will@kernel.org, sunilmut@microsoft.com,
        linux-arch@vger.kernel.org, wei.liu@kernel.org,
        sthemmin@microsoft.com, linux-scsi@vger.kernel.org, x86@kernel.org,
        mingo@redhat.com, kuba@kernel.org, jejb@linux.ibm.com,
        thomas.lendacky@amd.com, Tianyu Lan <Tianyu.Lan@microsoft.com>,
        arnd@arndb.de, haiyangz@microsoft.com, bp@alien8.de,
        tglx@linutronix.de, vkuznets@redhat.com,
        martin.petersen@oracle.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, akpm@linux-foundation.org,
        robin.murphy@arm.com, davem@davemloft.net
Subject: Re: [Resend RFC PATCH V2 10/12] HV/IOMMU: Add Hyper-V dma ops support
To:     Tianyu Lan <ltykernel@gmail.com>, Christoph Hellwig <hch@lst.de>,
        konrad.wilk@oracle.com
References: <20210414144945.3460554-1-ltykernel@gmail.com>
 <20210414144945.3460554-11-ltykernel@gmail.com>
 <20210414154729.GD32045@lst.de>
 <a316af73-2c96-f307-6285-593597e05123@gmail.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <7cda690b-adb0-1f5f-2048-b52f75c0399f@linux.intel.com>
Date:   Thu, 13 May 2021 11:19:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <a316af73-2c96-f307-6285-593597e05123@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/13/21 12:01 AM, Tianyu Lan wrote:
> Hi Christoph and Konrad:
>       Current Swiotlb bounce buffer uses a pool for all devices. There
> is a high overhead to get or free bounce buffer during performance test.
> Swiotlb code now use a global spin lock to protect bounce buffer data.
> Several device queues try to acquire the spin lock and this introduce
> additional overhead.
> 
> For performance and security perspective, each devices should have a
> separate swiotlb bounce buffer pool and so this part needs to rework.
> I want to check this is right way to resolve performance issues with 
> swiotlb bounce buffer. If you have some other suggestions,welcome.

Is this what you want?

https://lore.kernel.org/linux-iommu/20210510095026.3477496-1-tientzu@chromium.org/

Best regards,
baolu
