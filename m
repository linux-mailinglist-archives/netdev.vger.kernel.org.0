Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36D3D3EA4A0
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 14:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbhHLM13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 08:27:29 -0400
Received: from verein.lst.de ([213.95.11.211]:44135 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236519AbhHLM11 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 08:27:27 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 97D3B68B05; Thu, 12 Aug 2021 14:26:57 +0200 (CEST)
Date:   Thu, 12 Aug 2021 14:26:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, joro@8bytes.org,
        will@kernel.org, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@lst.de, m.szyprowski@samsung.com, robin.murphy@arm.com,
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
Subject: Re: [PATCH V3 09/13] DMA: Add
 dma_map_decrypted/dma_unmap_encrypted() function
Message-ID: <20210812122657.GB19050@lst.de>
References: <20210809175620.720923-1-ltykernel@gmail.com> <20210809175620.720923-10-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809175620.720923-10-ltykernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 09, 2021 at 01:56:13PM -0400, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> In Hyper-V Isolation VM with AMD SEV, swiotlb boucne buffer
> needs to be mapped into address space above vTOM and so
> introduce dma_map_decrypted/dma_unmap_encrypted() to map/unmap
> bounce buffer memory. The platform can populate man/unmap callback
> in the dma memory decrypted ops.

Nothing here looks actually DMA related, and the names are horribly
confusing vs the actual dma_map_* calls.
