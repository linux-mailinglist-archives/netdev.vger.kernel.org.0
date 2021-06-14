Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7293A5D7D
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 09:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhFNHOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 03:14:34 -0400
Received: from verein.lst.de ([213.95.11.211]:43092 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232096AbhFNHOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 03:14:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 537CA67373; Mon, 14 Jun 2021 09:12:23 +0200 (CEST)
Date:   Mon, 14 Jun 2021 09:12:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
        dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, hannes@cmpxchg.org, cai@lca.pw,
        krish.sadhukhan@oracle.com, saravanand@fb.com,
        Tianyu.Lan@microsoft.com, konrad.wilk@oracle.com,
        m.szyprowski@samsung.com, robin.murphy@arm.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, joro@8bytes.org, will@kernel.org,
        xen-devel@lists.xenproject.org, davem@davemloft.net,
        kuba@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        iommu@lists.linux-foundation.org, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, sunilmut@microsoft.com
Subject: Re: [RFC PATCH V3 08/11] swiotlb: Add bounce buffer remap address
 setting function
Message-ID: <20210614071223.GA30171@lst.de>
References: <20210530150628.2063957-1-ltykernel@gmail.com> <20210530150628.2063957-9-ltykernel@gmail.com> <20210607064312.GB24478@lst.de> <48516ce3-564c-419e-b355-0ce53794dcb1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48516ce3-564c-419e-b355-0ce53794dcb1@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 07, 2021 at 10:56:47PM +0800, Tianyu Lan wrote:
> These addresses in extra address space works as system memory mirror. The 
> shared memory with host in Isolation VM needs to be accessed via extra 
> address space which is above shared gpa boundary.

Why?
