Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA7A35F804
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233924AbhDNPlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:41:06 -0400
Received: from verein.lst.de ([213.95.11.211]:59329 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233075AbhDNPk6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 11:40:58 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6973E68C7B; Wed, 14 Apr 2021 17:40:28 +0200 (CEST)
Date:   Wed, 14 Apr 2021 17:40:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, joro@8bytes.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Tianyu Lan <Tianyu.Lan@microsoft.com>,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        sunilmut@microsoft.com
Subject: Re: [Resend RFC PATCH V2 03/12] x86/Hyper-V: Add new hvcall guest
 address host visibility support
Message-ID: <20210414154028.GA32045@lst.de>
References: <20210414144945.3460554-1-ltykernel@gmail.com> <20210414144945.3460554-4-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210414144945.3460554-4-ltykernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/*
> + * hv_set_mem_host_visibility - Set host visibility for specified memory.
> + */

I don't think this comment really clarifies anything over the function
name.  What is 'host visibility'

> +int hv_set_mem_host_visibility(void *kbuffer, u32 size, u32 visibility)

Should size be a size_t?
Should visibility be an enum of some kind?

> +int hv_mark_gpa_visibility(u16 count, const u64 pfn[], u32 visibility)

Not sure what this does either.

> +	local_irq_save(flags);
> +	input_pcpu = (struct hv_input_modify_sparse_gpa_page_host_visibility **)

Is there a chance we could find a shorter but still descriptive
name for this variable?  Why do we need the cast?

> +#define VMBUS_PAGE_VISIBLE_READ_ONLY HV_MAP_GPA_READABLE
> +#define VMBUS_PAGE_VISIBLE_READ_WRITE (HV_MAP_GPA_READABLE|HV_MAP_GPA_WRITABLE)

pointlessly overlong line.
