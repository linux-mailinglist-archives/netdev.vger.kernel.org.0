Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8CDA474715
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 17:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235491AbhLNQFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 11:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbhLNQFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 11:05:06 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007C7C061574;
        Tue, 14 Dec 2021 08:05:05 -0800 (PST)
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1EC1C1EC01DF;
        Tue, 14 Dec 2021 17:05:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1639497900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=CvKZKs3K1S02aP8gGCL57BLEXwZ8163K5Z/pwHkvTYw=;
        b=n7du2s5k71sYuAU9hRqtj10nW/i1hdOQeyxDRXOoV721Cd6Va+jNJxYyE4hfKuhZbgNNaM
        KfWPAx4LAj7GUDCTIy96twOJeqTQwVq/LtoGn8wOzH0yJpWSY/a6vtWTLmDfd/L9kbOgQ5
        amL+A6pTzbz30GvqWVxI54DllegLQ80=
Date:   Tue, 14 Dec 2021 17:05:01 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, davem@davemloft.net, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, Tianyu.Lan@microsoft.com,
        michael.h.kelley@microsoft.com, iommu@lists.linux-foundation.org,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com, brijesh.singh@amd.com,
        konrad.wilk@oracle.com, hch@lst.de, joro@8bytes.org,
        parri.andrea@gmail.com, dave.hansen@intel.com
Subject: Re: [PATCH V7 2/5] x86/hyper-v: Add hyperv Isolation VM check in the
 cc_platform_has()
Message-ID: <YbjArUL+biZMsFOL@zn.tnic>
References: <20211213071407.314309-1-ltykernel@gmail.com>
 <20211213071407.314309-3-ltykernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211213071407.314309-3-ltykernel@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 13, 2021 at 02:14:03AM -0500, Tianyu Lan wrote:
> From: Tianyu Lan <Tianyu.Lan@microsoft.com>
> 
> Hyper-V provides Isolation VM for confidential computing support and
> guest memory is encrypted in it. Places checking cc_platform_has()
> with GUEST_MEM_ENCRYPT attr should return "True" in Isolation vm. e.g,

Stick to a single spelling variant: "VM".

> swiotlb bounce buffer size needs to adjust according to memory size
> in the sev_setup_arch().

So basically you wanna simply say here:

"Hyper-V Isolation VMs need to adjust the SWIOTLB size just like SEV
guests. Add a hyperv_cc_platform_has() variant which enables that."

?

With that addressed you can have my

Acked-by: Borislav Petkov <bp@suse.de>

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
