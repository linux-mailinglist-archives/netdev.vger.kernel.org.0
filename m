Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F6E662F78
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237251AbjAISrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237362AbjAISrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:47:14 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C501A07F;
        Mon,  9 Jan 2023 10:47:13 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E62A21EC0104;
        Mon,  9 Jan 2023 19:47:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1673290032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=11LnUf4MhejKfgisfPSyS9B0B0xaSZCrX17MQeoncqE=;
        b=sAByOsc/+Oj0INi0+tr34pMFzTLKYdE0Sr9YpSor17uoouv6rwXdWzR47sn0Zolbt29b6f
        gsg8XJ7C2pb+Kcg1pn60LMqgasxwuYbWtcF9SA0noFAmkwEsX+HalnvnH2QPTIxXMsCoGF
        qf5/yHPQ0ycrMslQs6xaSQRFnJsU084=
Date:   Mon, 9 Jan 2023 19:47:08 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Michael Kelley <mikelley@microsoft.com>, wei.liu@kernel.org
Cc:     hpa@zytor.com, kys@microsoft.com, haiyangz@microsoft.com,
        decui@microsoft.com, luto@kernel.org, peterz@infradead.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lpieralisi@kernel.org, robh@kernel.org,
        kw@linux.com, bhelgaas@google.com, arnd@arndb.de,
        hch@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, tglx@linutronix.de,
        mingo@redhat.com, dave.hansen@linux.intel.com,
        Tianyu.Lan@microsoft.com, kirill.shutemov@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, dan.j.williams@intel.com,
        jane.chu@oracle.com, seanjc@google.com, tony.luck@intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        iommu@lists.linux.dev
Subject: Re: [Patch v4 00/13] Add PCI pass-thru support to Hyper-V
 Confidential VMs
Message-ID: <Y7xhLCgCq0MOsqxH@zn.tnic>
References: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1669951831-4180-1-git-send-email-mikelley@microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 07:30:18PM -0800, Michael Kelley wrote:
> This patch series adds support for PCI pass-thru devices to Hyper-V
> Confidential VMs (also called "Isolation VMs"). But in preparation, it
> first changes how private (encrypted) vs. shared (decrypted) memory is
> handled in Hyper-V SEV-SNP guest VMs. The new approach builds on the
> confidential computing (coco) mechanisms introduced in the 5.19 kernel
> for TDX support and significantly reduces the amount of Hyper-V specific
> code. Furthermore, with this new approach a proposed RFC patch set for
> generic DMA layer functionality[1] is no longer necessary.

In any case, this is starting to get ready - how do we merge this?

I apply the x86 bits and give Wei an immutable branch to add the rest of the
HyperV stuff ontop?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
