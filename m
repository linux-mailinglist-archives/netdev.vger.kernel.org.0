Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499204394BB
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 13:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhJYL0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 07:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhJYL0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 07:26:48 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B45EC061745;
        Mon, 25 Oct 2021 04:24:25 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0f4e0014f3333d144d8f4c.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:4e00:14f3:333d:144d:8f4c])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 13FEA1EC01A2;
        Mon, 25 Oct 2021 13:24:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1635161063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=GB4wwUoNrSKvD0FFHFrXixqZowcWitH6npE3fw5REDE=;
        b=qdBi9f6jWqvSTvTaHXXYJI0NAkbh1H9pqmdm9QaoRq0DEgw3j1xMJ6maBpwpSlaOGLgBpl
        j/KO5S8D3wCIMCDWRRtf1aIPRiPq3PLSrsqTgQpz3taWrttvBiYsmMHLDPFAeUonc7rxPT
        qBNNWiJglHCfktyMXroK9xhwICV3Za0=
Date:   Mon, 25 Oct 2021 13:24:20 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Wei Liu <wei.liu@kernel.org>
Cc:     Tianyu Lan <ltykernel@gmail.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com,
        decui@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, davem@davemloft.net,
        kuba@kernel.org, gregkh@linuxfoundation.org, arnd@arndb.de,
        brijesh.singh@amd.com, jroedel@suse.de, Tianyu.Lan@microsoft.com,
        thomas.lendacky@amd.com, rientjes@google.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, saravanand@fb.com, aneesh.kumar@linux.ibm.com,
        hannes@cmpxchg.org, tj@kernel.org, michael.h.kelley@microsoft.com,
        linux-arch@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        vkuznets@redhat.com, konrad.wilk@oracle.com, hch@lst.de,
        robin.murphy@arm.com, joro@8bytes.org, parri.andrea@gmail.com,
        dave.hansen@intel.com
Subject: Re: [PATCH V8 5/9] x86/sev-es: Expose sev_es_ghcb_hv_call() to call
 ghcb hv call out of sev code
Message-ID: <YXaT5HcLoX59jZH2@zn.tnic>
References: <20211021154110.3734294-1-ltykernel@gmail.com>
 <20211021154110.3734294-6-ltykernel@gmail.com>
 <YXGTwppQ8syUyJ72@zn.tnic>
 <00946764-7fe0-675f-7b3e-9fb3b8e3eb89@gmail.com>
 <20211025112033.eqelx54p2dmlhykw@liuwe-devbox-debian-v2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211025112033.eqelx54p2dmlhykw@liuwe-devbox-debian-v2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 11:20:33AM +0000, Wei Liu wrote:
> Borislav, please take the whole series via the tip tree if possible.
> That's perhaps the easiest thing for both of us because the rest of the
> series depends on this patch. Or else I will have to base hyperv-next on
> the tip tree once you merge this patch.
>
> Let me know what you think.

You'll be able to simply merge the tip/x86/sev branch which will have it
and then base everything ontop.

However, there's still a question open - see my reply to Michael.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
