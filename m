Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6F04337DD
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 15:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbhJSOAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:00:13 -0400
Received: from mail.skyhub.de ([5.9.137.197]:57182 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230487AbhJSOAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 10:00:13 -0400
Received: from zn.tnic (p200300ec2f12f600999171228a6b1e18.dip0.t-ipconnect.de [IPv6:2003:ec:2f12:f600:9991:7122:8a6b:1e18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B5CE91EC0531;
        Tue, 19 Oct 2021 15:57:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1634651878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Eyr0BrQZjw5sA8H+/VXcyKJdpJUglZVq/GeFUKleCV4=;
        b=QF8gs6XkuuDcKOT13EUBQzf9lyHTxW5lV7gAtEvIN8wrhfvvKsrtdW0u3OyzuQl9o9oPC9
        g6vLJPblxsuxMCz5FAqebChv09tHnR9hf/faZRWncEBjRgHesQYF137zk7h9agm8Axz1eA
        gVKxa+XbD67lOoBLWeuCURojCdedmy4=
Date:   Tue, 19 Oct 2021 15:57:56 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Tianyu Lan <ltykernel@gmail.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, linux-arch@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, vkuznets@redhat.com,
        konrad.wilk@oracle.com, hch@lst.de, robin.murphy@arm.com,
        joro@8bytes.org, parri.andrea@gmail.com, dave.hansen@intel.com,
        Hikys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        hpa@zytor.com, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, davem@davemloft.net, kuba@kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, jroedel@suse.de,
        brijesh.singh@amd.com, Tianyu.Lan@microsoft.com, pgonda@google.com,
        akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        rppt@kernel.org, tj@kernel.org, aneesh.kumar@linux.ibm.com,
        saravanand@fb.com, hannes@cmpxchg.org, rientjes@google.com,
        michael.h.kelley@microsoft.com
Subject: Re: [PATCH V7 5/9] x86/sev-es: Expose __sev_es_ghcb_hv_call() to
 call ghcb hv call out of sev code
Message-ID: <YW7O5HmcD/JK0Twr@zn.tnic>
References: <20211006063651.1124737-1-ltykernel@gmail.com>
 <20211006063651.1124737-6-ltykernel@gmail.com>
 <9b5fc629-9f88-039c-7d5d-27cbdf6b00fd@gmail.com>
 <YWRyvD413h+PwU9B@zn.tnic>
 <5a0b9de8-e133-c17b-bc0d-93bfb593c48f@gmail.com>
 <2772390d-09c1-80c1-082f-225f32eae4aa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2772390d-09c1-80c1-082f-225f32eae4aa@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 08:19:30PM +0800, Tianyu Lan wrote:
> Gentle Ping.

$ patch -p1 --dry-run -i /tmp/ltykernel.01
checking file arch/x86/include/asm/sev.h
patch: **** malformed patch at line 128: return 0; }

Can you pls send a patch which is not mangled and I can apply?

Also, this might have some info on the matter:

Documentation/process/email-clients.rst

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
