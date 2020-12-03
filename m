Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798E22CDCFE
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731556AbgLCSCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:02:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727427AbgLCSCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:02:06 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E80C061A4E;
        Thu,  3 Dec 2020 10:01:25 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id f190so4861413wme.1;
        Thu, 03 Dec 2020 10:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uuffdwLR2hZJFHYYMgq3J065S+Cnd9UrLlfcWQHHRhU=;
        b=o0vdXh7ZI9OrkzmMfVdo98vW7TalOsoE09k43V1Cpz/0HXOIT/OSTWHqMOnlGH0X69
         QVa10Gqk1Fw2MVx+xdOxH/Myg5pyNReAAImIwLc1k4/vAbL+bquEpO0SWlAwjzt3M4Eg
         tSMWJPgrcN5x1J14oF2zjqUC7vMWlUvBSzKjowzJfi4ZlGPwhGlgVJe+xAJoVN0GjyRr
         cLAJ1rDZZd62WOAOSyTp1+tQxLTC/r5u+oYrS8oWagjL9QV3ewhKIOENa3/KlND5PNnE
         DVgqfFTFUMEvZk60FaBF/BmG6iEG9mPdQceQAGzvXUVfnLPlfocZ+y35+cTODHI3QNhS
         1XOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uuffdwLR2hZJFHYYMgq3J065S+Cnd9UrLlfcWQHHRhU=;
        b=R8C527/D0dKOnpu0pWNaRmYjmLQETQ726yeCeypbF/zQSY0VHtmiYMO1/L1YOGEVIr
         NfcYL1JA/LROx2KrCuJTtvR7K9capTZwWdfmuw0O6X6EDwMglhIJ+2HfEM3II4S6Utp+
         W4KaKwrBrdw1cpuoPsIKZWG1XiVyVbBgbtXi2WQnvRkomkGra7zjj85CgBiq6Pd8uZg7
         5z5pe2F1Rh7spUYg41FuJnfhertgarC64x4VhG9eeD8YNYkDVyCqE8iy1PsY6KfXOVKj
         2lLDrD/DSXFQDeTgq7B2G6ecfRiNCh4uUcCmuwcsLAxaV+0tZK+Kx1A6A039zA99I8LK
         K2GA==
X-Gm-Message-State: AOAM530n59Agy+zrzXtgdBKfKX6+Dp9qTZw0FQ94DMi0SoLexagqoEd0
        MFSfKmPgUn+i//NvpuR5h3s=
X-Google-Smtp-Source: ABdhPJzKYm/Tc7VYPzNBAzdvQ0VlSfpqcD7vnwrCTRP8CvVSHVjoLR2d2rQ/I7tPXyOaPq3FwI33Tw==
X-Received: by 2002:a1c:1f54:: with SMTP id f81mr52035wmf.44.1607018484390;
        Thu, 03 Dec 2020 10:01:24 -0800 (PST)
Received: from [192.168.8.116] ([37.165.75.126])
        by smtp.gmail.com with ESMTPSA id c81sm186654wmd.6.2020.12.03.10.01.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Dec 2020 10:01:23 -0800 (PST)
Subject: Re: WARNING in sk_stream_kill_queues (5)
To:     Marco Elver <elver@google.com>, Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Jann Horn <jannh@google.com>, Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Willem de Bruijn <willemb@google.com>,
        syzbot <syzbot+7b99aafdcc2eedea6178@syzkaller.appspotmail.com>
References: <000000000000b4862805b54ef573@google.com>
 <X8kLG5D+j4rT6L7A@elver.google.com>
 <CANn89iJWD5oXPLgtY47umTgo3gCGBaoy+XJfXnw1ecES_EXkCw@mail.gmail.com>
 <CANpmjNOaWbGJQ5Y=qC3cA31-R-Jy4Fbe+p=OBG5O2Amz8dLtLA@mail.gmail.com>
 <CANn89iKWf1EVZUuAHup+5ndhxvOqGopq53=vZ9yeok=DnRjggg@mail.gmail.com>
 <X8kjPIrLJUd8uQIX@elver.google.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <af884a0e-5d4d-f71b-4821-b430ac196240@gmail.com>
Date:   Thu, 3 Dec 2020 19:01:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <X8kjPIrLJUd8uQIX@elver.google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/3/20 6:41 PM, Marco Elver wrote:

> One more experiment -- simply adding
> 
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -207,7 +207,21 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
>  	 */
>  	size = SKB_DATA_ALIGN(size);
>  	size += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +	size = 1 << kmalloc_index(size); /* HACK */
>  	data = kmalloc_reserve(size, gfp_mask, node, &pfmemalloc);
> 
> 
> also got rid of the warnings. Something must be off with some value that
> is computed in terms of ksize(). If not, I don't have any explanation
> for why the above hides the problem.

Maybe the implementations of various macros (SKB_DATA_ALIGN and friends)
hae some kind of assumptions, I will double check this.

