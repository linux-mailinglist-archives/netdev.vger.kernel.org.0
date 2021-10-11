Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C878B42957F
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 19:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233809AbhJKRYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 13:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbhJKRYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Oct 2021 13:24:05 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6141DC061570;
        Mon, 11 Oct 2021 10:22:05 -0700 (PDT)
Received: from zn.tnic (p200300ec2f08bb00e407f16cd758a723.dip0.t-ipconnect.de [IPv6:2003:ec:2f08:bb00:e407:f16c:d758:a723])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id E9C6D1EC03CA;
        Mon, 11 Oct 2021 19:22:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1633972924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=7pr8bEeJf1Wrlt46Jv44VNtGfFCv8rw1yr3U/jRU4RM=;
        b=OdE/UbxCU3yTYZT/ktofAGoS+iLn+dZ9zwJxQwidg90AQ9pLlMGucuTpD2uy49N6mUkhN4
        1gJFOcJev9HmqJiNW4CcowDcstnO7INQsNnxRfDzrbHViv/3ozShIPUhFGbaUVGd21BKOQ
        kNoH+EJuqF5afswjpkvxa0TUjI5BMvA=
Date:   Mon, 11 Oct 2021 19:22:04 +0200
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
Message-ID: <YWRyvD413h+PwU9B@zn.tnic>
References: <20211006063651.1124737-1-ltykernel@gmail.com>
 <20211006063651.1124737-6-ltykernel@gmail.com>
 <9b5fc629-9f88-039c-7d5d-27cbdf6b00fd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9b5fc629-9f88-039c-7d5d-27cbdf6b00fd@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 11, 2021 at 10:42:18PM +0800, Tianyu Lan wrote:
> Hi @Tom and Borislav:
>      Please have a look at this patch. If it's ok, could you give your ack.

I needed to do some cleanups in that area first:

https://lore.kernel.org/r/YWRwxImd9Qcls/Yy@zn.tnic

Can you redo yours ontop so that you can show what exactly you need
exported for HyperV?

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
