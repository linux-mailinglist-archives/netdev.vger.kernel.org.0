Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1920F3DD63F
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 14:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbhHBM7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 08:59:55 -0400
Received: from 8bytes.org ([81.169.241.247]:53006 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233718AbhHBM7y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 08:59:54 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id D9F01379; Mon,  2 Aug 2021 14:59:43 +0200 (CEST)
Date:   Mon, 2 Aug 2021 14:59:42 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        jgross@suse.com, sstabellini@kernel.org, will@kernel.org,
        davem@davemloft.net, kuba@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, arnd@arndb.de, hch@lst.de,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, ardb@kernel.org,
        Tianyu.Lan@microsoft.com, rientjes@google.com,
        martin.b.radev@gmail.com, akpm@linux-foundation.org,
        rppt@kernel.org, kirill.shutemov@linux.intel.com,
        aneesh.kumar@linux.ibm.com, krish.sadhukhan@oracle.com,
        saravanand@fb.com, xen-devel@lists.xenproject.org,
        pgonda@google.com, david@redhat.com, keescook@chromium.org,
        hannes@cmpxchg.org, sfr@canb.auug.org.au,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, anparri@microsoft.com
Subject: Re: [PATCH 04/13] HV: Mark vmbus ring buffer visible to host in
 Isolation VM
Message-ID: <YQfsPv1WC7dnHGDu@8bytes.org>
References: <20210728145232.285861-1-ltykernel@gmail.com>
 <20210728145232.285861-5-ltykernel@gmail.com>
 <YQfgH04t2SqacnHn@8bytes.org>
 <173823d1-280c-d34e-be2c-157b55bb6bc3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173823d1-280c-d34e-be2c-157b55bb6bc3@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 08:56:29PM +0800, Tianyu Lan wrote:
> Both second and third are HV_GPADL_RING type. One is send ring and the
> other is receive ring. The driver keeps the order to allocate rx and
> tx buffer. You are right this is not robust and will add a mutex to keep
> the order.

Or you introduce fixed indexes for the RX and TX buffers?
