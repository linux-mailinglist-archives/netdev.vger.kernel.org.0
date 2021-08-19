Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2EF3F16F6
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 12:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238161AbhHSKCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 06:02:44 -0400
Received: from verein.lst.de ([213.95.11.211]:36963 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238081AbhHSKCn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 06:02:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7AB826736F; Thu, 19 Aug 2021 12:02:00 +0200 (CEST)
Date:   Thu, 19 Aug 2021 12:02:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, pgonda@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, rppt@kernel.org,
        sfr@canb.auug.org.au, saravanand@fb.com,
        krish.sadhukhan@oracle.com, aneesh.kumar@linux.ibm.com,
        xen-devel@lists.xenproject.org, rientjes@google.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, parri.andrea@gmail.com, dave.hansen@intel.com
Subject: Re: [PATCH V3 10/13] x86/Swiotlb: Add Swiotlb bounce buffer remap
 function for HV IVM
Message-ID: <20210819100200.GA16908@lst.de>
References: <20210809175620.720923-1-ltykernel@gmail.com> <20210809175620.720923-11-ltykernel@gmail.com> <20210812122741.GC19050@lst.de> <d18ae061-6fc2-e69e-fc2c-2e1a1114c4b4@gmail.com> <890e5e21-714a-2db6-f68a-6211a69bebb9@gmail.com> <20210819084951.GA10461@lst.de> <1c5ae861-2c35-2ef5-e764-db45bbcb88a9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c5ae861-2c35-2ef5-e764-db45bbcb88a9@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 19, 2021 at 05:59:02PM +0800, Tianyu Lan wrote:
>
>
> On 8/19/2021 4:49 PM, Christoph Hellwig wrote:
>> On Mon, Aug 16, 2021 at 10:50:26PM +0800, Tianyu Lan wrote:
>>> Hi Christoph:
>>>        Sorry to bother you.Please double check with these two patches
>>> " [PATCH V3 10/13] x86/Swiotlb: Add Swiotlb bounce buffer remap function
>>> for HV IVM" and "[PATCH V3 09/13] DMA: Add dma_map_decrypted/dma_
>>> unmap_encrypted() function".
>>
>> Do you have a git tree somewhere to look at the whole tree?
>
> Yes, here is my github link for these two patches.
>
> https://github.com/lantianyu/linux/commit/462f7e4e44644fe7e182f7a5fb043a75acb90ee5
>
> https://github.com/lantianyu/linux/commit/c8de236bf4366d39e8b98e5a091c39df29b03e0b

Which branch is this?

