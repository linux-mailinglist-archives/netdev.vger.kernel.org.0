Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97FA658F6B
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 18:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbiL2RM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 12:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbiL2RMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 12:12:20 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDFCDFF1;
        Thu, 29 Dec 2022 09:12:19 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id EA61F1EC01CE;
        Thu, 29 Dec 2022 18:12:17 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1672333938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=sqeooaleqBTMPBtHWAeLVMtTZ1xfk6rO2FzUqBNbtKw=;
        b=QObNy42hmAtuswnJb8OglmyKvFnt1YAyP0phH4fNMyCB+uOSiROVBU9rTNybRKMg2S/OeP
        JPC3cXk44PBGhiQPG6PRlGGJpi7nj21yYAIhgZNHgpszrJKFqxoS/Z9pQk0OGZjqHuG9SP
        FiF4iIDhSNFB61FuWL9Zr6ZwEnAwzio=
Date:   Thu, 29 Dec 2022 18:12:17 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Michael Kelley <mikelley@microsoft.com>, hpa@zytor.com,
        kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
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
Subject: Re: [Patch v4 04/13] x86/mm: Handle decryption/re-encryption of
 bss_decrypted consistently
Message-ID: <Y63Kcaqo2U6G+JmY@zn.tnic>
References: <Y62FbJ1rZ6TVUgml@zn.tnic>
 <20221229165431.GA611286@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221229165431.GA611286@bhelgaas>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 29, 2022 at 10:54:31AM -0600, Bjorn Helgaas wrote:
> > "sme_postprocess_startup() decrypts the bss_decrypted ection when me_mask
> > sme_is non-zero.
> 
> s/ection/section/
> 
> (In case you copy/paste this text without noticing the typo)

Thanks.

My par-agraph reformating helper does mangle words like that sometimes.
The correct sentence should be:

"sme_postprocess_startup() decrypts the bss_decrypted section when
sme_me_mask is non-zero."

/me makes a mental note to switch to the vim builtin instead.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
