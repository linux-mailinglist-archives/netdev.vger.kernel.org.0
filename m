Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC93223DD70
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 19:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbgHFRJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 13:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730028AbgHFRGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 13:06:01 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FD8C034600;
        Thu,  6 Aug 2020 10:00:44 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id x6so12005136pgx.12;
        Thu, 06 Aug 2020 10:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=NLT43nTelEOprq8u7oeswEavW3NBJsJ52FtmKVX81fo=;
        b=IAyZjT8YL/t+Dof+pq9jvDbNtM+SaGw6+OI4icNf67RlX6kJmIpjJDZvFUdCSEWLdq
         4acCAf6+0jGzciBRldkvWyP04bpvNzphxwuZEarjg5gSzTiBNZHFiRiDahCm9Xe5Tfyz
         55pf95eRc8t2S7wbIq8Teybp3fg21HrGNUJFzFBTcSuGADCIKZgRr5rgitwHN+XFn2uO
         W5W9D33BSE8aTLA6DPc4zUbsBfBHNF+vdPKPos6CHPVM0DT7sh0oydVazdxka6IKgt7d
         s/4aWgOfrMpESOQzOHgbxt+HPRR5Reqgmag81lN7Pt2QC2KN61ctl+jB8gHwDghlgW08
         tIOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=NLT43nTelEOprq8u7oeswEavW3NBJsJ52FtmKVX81fo=;
        b=B+1/G+0bVMvlWtLtbMfilgvLEEkJZlp6Uxmrn5V4hUaNtvb/TLUYekC4qpmWfwEZUv
         jlnoMv3rmKaUYPCD3Swzv4PbBBjnoEYJ5pLKEsmgUwan1VjgsN7b8xQhjPrFnFMVC9s9
         0kI5bW1PWxYHJl1DD+863Fj9ieLebbM7Bcv+Uwio14FP2V0vLiooAWtgypqJ+s9bl1CN
         0oTO5fF7t8cxYCwtFn6nm4JVG9yu/IdfDZ92Q2O9dDpN+7E0Zl0duaa4+F1dA++jE2j3
         Zmv/JI4TuQpvGnTxDzs81c2I7XUshDObJ9/Knh1Fao8BhuxwgEog5wsaGwBd+I/gl8/A
         Lo+w==
X-Gm-Message-State: AOAM532LpXAy1A7kW9N2JKoiGd0OaAQo7oa7i85RF78ypWkyQo9HSCQF
        5tZ380/wR6fkAPHAguAPcHpQk4EhXcE8VA==
X-Google-Smtp-Source: ABdhPJwYXSAv6gX++vHBHf0QWqMmWr6cR73RB82vN4bBP6HKSory/Emn19+h+yrQuVA6N3LoEgoLDw==
X-Received: by 2002:a62:fcca:: with SMTP id e193mr6495630pfh.316.1596733243751;
        Thu, 06 Aug 2020 10:00:43 -0700 (PDT)
Received: from ?IPv6:2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff? (node-1w7jr9qsv51tb41p80xpg7667.ipv6.telus.net. [2001:569:7bc3:ce00:a4b2:4936:f0f6:3eff])
        by smtp.gmail.com with ESMTPSA id x23sm8467642pfi.60.2020.08.06.10.00.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 10:00:43 -0700 (PDT)
Subject: Re: Flaw in "random32: update the net random state on interrupt and
 activity"
To:     tytso@mit.edu
Cc:     Willy Tarreau <w@1wt.eu>, netdev@vger.kernel.org,
        aksecurity@gmail.com, torvalds@linux-foundation.org,
        edumazet@google.com, Jason@zx2c4.com, luto@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, peterz@infradead.org,
        stable@vger.kernel.org
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
 <20200805024941.GA17301@1wt.eu> <20200805153432.GE497249@mit.edu>
 <c200297c-85a5-dd50-9497-6fcf7f07b727@gmail.com>
 <20200805220550.GA785826@mit.edu>
From:   Marc Plumb <lkml.mplumb@gmail.com>
Message-ID: <334b350c-a2ed-ab42-ab30-cc3520664218@gmail.com>
Date:   Thu, 6 Aug 2020 10:00:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200805220550.GA785826@mit.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020-08-05 3:05 p.m., tytso@mit.edu wrote:
>
> Well, technically it's not supposed to be a secure cryptographic
> primitive.  net_rand_state is used in the call prandom_u32(), so the
> only supposed guarantee is PSEUDO random.
>
> That being said, a quick "get grep prandom_u32" shows that there are a
> *huge* number of uses of prandom_u32() and whether they are all
> appropriate uses of prandom_u32(), or kernel developers are using it
> because "I haz a ne3D for spE3d" but in fact it's for a security
> critical application is a pretty terrifying question.  If we start
> seeing CVE's getting filed caused by inappropriate uses of
> prandom_u32, to be honest, it won't surprise me.

The danger I'm worried about it's misuse of prandom_u32. That would mean 
one function would have weak random numbers. I'm worried about the 
disclosure of the entropy that is the basis for the good random numbers 
because that would undermine the security of the people who are using 
the right functions for their task.

Having said that, auditing all uses of prandom_u32 would be useful, but 
a different issue.
