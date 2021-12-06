Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3442D469808
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 15:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245014AbhLFOLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 09:11:05 -0500
Received: from verein.lst.de ([213.95.11.211]:50654 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245648AbhLFOKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 09:10:30 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1077C68B05; Mon,  6 Dec 2021 15:06:52 +0100 (CET)
Date:   Mon, 6 Dec 2021 15:06:51 +0100
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
Subject: Re: [PATCH V4 2/5] x86/hyper-v: Add hyperv Isolation VM check in
 the cc_platform_has()
Message-ID: <20211206140651.GA5100@lst.de>
References: <20211205081815.129276-1-ltykernel@gmail.com> <20211205081815.129276-3-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211205081815.129276-3-ltykernel@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 05, 2021 at 03:18:10AM -0500, Tianyu Lan wrote:
> +static bool hyperv_cc_platform_has(enum cc_attr attr)
> +{
> +#ifdef CONFIG_HYPERV
> +	return attr == CC_ATTR_GUEST_MEM_ENCRYPT;
> +#else
> +	return false;
> +#endif
> +}

Can we even end up here without CONFIG_HYPERV?
