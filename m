Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D41469819
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 15:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245459AbhLFOM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 09:12:56 -0500
Received: from verein.lst.de ([213.95.11.211]:50705 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237344AbhLFOM4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 09:12:56 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6C59868B05; Mon,  6 Dec 2021 15:09:17 +0100 (CET)
Date:   Mon, 6 Dec 2021 15:09:16 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, jgross@suse.com,
        sstabellini@kernel.org, boris.ostrovsky@oracle.com,
        joro@8bytes.org, will@kernel.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        arnd@arndb.de, hch@infradead.org, m.szyprowski@samsung.com,
        robin.murphy@arm.com, thomas.lendacky@amd.com,
        Tianyu.Lan@microsoft.com, xen-devel@lists.xenproject.org,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, hch@lst.de, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: Re: [PATCH V4 1/5] Swiotlb: Add Swiotlb bounce buffer remap
 function for HV IVM
Message-ID: <20211206140916.GB5100@lst.de>
References: <20211205081815.129276-1-ltykernel@gmail.com> <20211205081815.129276-2-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211205081815.129276-2-ltykernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please spell swiotlb with a lower case s.  Otherwise this look good

Acked-by: Christoph Hellwig <hch@lst.de>

Feel free to carry this in whatever tree is suitable for the rest of the
patches.
