Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9002B3DD50F
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 14:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233571AbhHBMB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 08:01:59 -0400
Received: from 8bytes.org ([81.169.241.247]:52728 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233446AbhHBMB4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 08:01:56 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 2A79D379; Mon,  2 Aug 2021 14:01:45 +0200 (CEST)
Date:   Mon, 2 Aug 2021 14:01:41 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
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
Subject: Re: [PATCH 03/13] x86/HV: Add new hvcall guest address host
 visibility support
Message-ID: <YQfepYTC4n6agq9z@8bytes.org>
References: <20210728145232.285861-1-ltykernel@gmail.com>
 <20210728145232.285861-4-ltykernel@gmail.com>
 <c00e269c-da4c-c703-0182-0221c73a76cc@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c00e269c-da4c-c703-0182-0221c73a76cc@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 08:29:41AM -0700, Dave Hansen wrote:
> __set_memory_enc_dec() is turning into a real mess.  SEV, TDX and now
> Hyper-V are messing around in here.

I was going to suggest a PV_OPS call where the fitting implementation
for the guest environment can be plugged in at boot. There is TDX and an
SEV(-SNP) case, a Hyper-V case, and likely more coming up from other
cloud/hypervisor vendors. Hiding all these behind feature checks is not
going to make things cleaner.

Regards,

	Joerg
