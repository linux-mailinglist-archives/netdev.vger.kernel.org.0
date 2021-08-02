Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB473DD718
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhHBNal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:30:41 -0400
Received: from 8bytes.org ([81.169.241.247]:53166 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233926AbhHBNaj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 09:30:39 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 0AFF0379; Mon,  2 Aug 2021 15:30:25 +0200 (CEST)
Date:   Mon, 2 Aug 2021 15:30:10 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        sstabellini@kernel.org, will@kernel.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@lst.de, m.szyprowski@samsung.com,
        robin.murphy@arm.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ardb@kernel.org, Tianyu.Lan@microsoft.com,
        rientjes@google.com, martin.b.radev@gmail.com,
        akpm@linux-foundation.org, rppt@kernel.org,
        kirill.shutemov@linux.intel.com, aneesh.kumar@linux.ibm.com,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        xen-devel@lists.xenproject.org, pgonda@google.com,
        david@redhat.com, keescook@chromium.org, hannes@cmpxchg.org,
        sfr@canb.auug.org.au, michael.h.kelley@microsoft.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, anparri@microsoft.com
Subject: Re: [PATCH 03/13] x86/HV: Add new hvcall guest address host
 visibility support
Message-ID: <YQfzYl5N5iXv4ZFH@8bytes.org>
References: <20210728145232.285861-1-ltykernel@gmail.com>
 <20210728145232.285861-4-ltykernel@gmail.com>
 <c00e269c-da4c-c703-0182-0221c73a76cc@intel.com>
 <YQfepYTC4n6agq9z@8bytes.org>
 <5badc0cb-3038-2eff-a4bf-022ce8fc51d7@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5badc0cb-3038-2eff-a4bf-022ce8fc51d7@suse.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 02, 2021 at 03:11:40PM +0200, Juergen Gross wrote:
> As those cases are all mutually exclusive, wouldn't a static_call() be
> the appropriate solution?

Right, static_call() is even better, thanks.
