Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC02B3318C8
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 21:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhCHUmW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 15:42:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhCHUmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 15:42:19 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BA4C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 12:42:18 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4DvVdN2y1RzQjbT;
        Mon,  8 Mar 2021 21:42:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mailbox.org; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :references:in-reply-to:message-id:subject:subject:from:from
        :date:date:received; s=mail20150812; t=1615236130; bh=WCgvf6vl6q
        VvKTuLJMMsF/OCrdJhqu3t7vkWNTG5xq4=; b=mnU6jEgaXk7xtbZmqIdVNhrshR
        CdA1hghBn7O9+4DOvkIcmTfLoYVVxQrSYs/VOj0hoTLQ54MfTDvlPyaICN9SBp43
        /TL/n2UR1cY+5a7bs31dfnSjoG7zmjDuiirDSyBEHIfUOsgYZRVVpaT4sAg6QqxX
        q/T3Wb2ufPLOg1+dpf/muTfD9t/nKKQuKcft+csCg76S5FOCiMzYSk4kuSOsTp2S
        JNY+oMds4HUY4IOQtUn4nV33vaANGXVPsuluBuL6KHx/WT8Cz4cL64chRHyiATa4
        6Q0ijx5kSA2l6AsHn03Anv7e3UCMshbwnI32aEjcy/ZwXmkcBgMJkjaqJIMA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1615236134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lLhzZsJB8xwELfXL0R4Tq3JOpiBvlNqofQ9BNIHapUw=;
        b=wL5ETTtGjAsuBnTCG8+b+veNt4eO9xMeHDYtat1KGF3aWOy/u4qdK/Zqq/6XJ3gLXmaKQS
        Qs08msCJoqii7bocm6JYZZdO/uooVHpOK7wC7Y77xNcMLFIqZqQXHBV03p492VlS64d09g
        3+/Hz2YUPtEfbT1bLCfkgvEYPUnJ9yg2BC/+TMCSzWiBAWtfi3lHCn4mxbMm35eWHwP88m
        Ijw7SRM93XzZGlcH12xGjRYThgH+2C8OE+DyHGCM1yO//nEqCZaIHwqmuPxOk5g88ITaOh
        WECUz/ZXHVz7dMJ0sSzd8StuNhicobVdzXJCQQbfnzHX+eohOhc6KJIqbgTinQ==
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter01.heinlein-hosting.de (spamfilter01.heinlein-hosting.de [80.241.56.115]) (amavisd-new, port 10030)
        with ESMTP id 2KwuPCa1Y_kR; Mon,  8 Mar 2021 21:42:10 +0100 (CET)
Date:   Mon, 8 Mar 2021 21:42:08 +0100
From:   "Erhard F." <erhard_f@mailbox.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: seqlock lockdep false positives?
Message-ID: <20210308214208.42a5577f@yea>
In-Reply-To: <YEXicy6+9MksdLZh@hirez.programming.kicks-ass.net>
References: <20210303164035.1b9a1d07@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YESayEskbtjEWjFd@lx-t490>
        <YEXicy6+9MksdLZh@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.62 / 15.00 / 15.00
X-Rspamd-Queue-Id: 5873B1857
X-Rspamd-UID: 816df9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Mar 2021 09:38:11 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> Indeed, that's one area where inlines are very much not equivalent to
> macros. Static variables in inline functions aren't exact, but they very
> much do not get to be one per invocation.
> 
> Something like the below ought to be the right fix I think.
> 
> diff --git a/include/linux/u64_stats_sync.h b/include/linux/u64_stats_sync.h
> index c6abb79501b3..e81856c0ba13 100644
> --- a/include/linux/u64_stats_sync.h
> +++ b/include/linux/u64_stats_sync.h
> @@ -115,12 +115,13 @@ static inline void u64_stats_inc(u64_stats_t *p)
>  }
>  #endif
>  
> +#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
> +#define u64_stats_init(syncp)	seqcount_init(&(syncp)->seq)
> +#else
>  static inline void u64_stats_init(struct u64_stats_sync *syncp)
>  {
> -#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
> -	seqcount_init(&syncp->seq);
> -#endif
>  }
> +#endif
>  
>  static inline void u64_stats_update_begin(struct u64_stats_sync *syncp)
>  {

Hi Peter!

I can confirm that your patch on top of 5.12-rc2 makes the lockdep splat disappear (Ahmeds' 1st patch not installed).
