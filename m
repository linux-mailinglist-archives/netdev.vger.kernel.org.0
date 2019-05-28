Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6682D098
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 22:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfE1UnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 16:43:17 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41909 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfE1UnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 16:43:17 -0400
Received: by mail-pg1-f195.google.com with SMTP id z3so7062704pgp.8
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 13:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4gvfVtnabcYk/rWSABOoJrM4QZ5d9gZBEGc6X6XZY50=;
        b=C73ZvzGNH/YisC//wt898V66Bjob6D4l49Pu0V7pn6vnXdDXJszYxGcs6bZ3jGi/rN
         fWTVqrdQKipVqDhyjPMgsvqGx5JMm9Z3fvWjEEeXHbLCQOEx/bn/QuIyRE+ssD9nIS2h
         dcQh/lMauhE5YutBCD1KvxdPI89Lvn7Fsi3qwslDHvtbltS+Nc87Cf3idZSDXtQmdFd6
         kBEf5/szEV3rsQmcfU3jYCYr2miJDdz2g02Fuku968l1JkAH52/GrYNuaMxepvW1Zhjj
         sLah05Z5TNKnLJvlbOe5bzDgzySr+zTEeUvvysKq5kBdKEyIS6BGuBwtszIU5oARa/zX
         GEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4gvfVtnabcYk/rWSABOoJrM4QZ5d9gZBEGc6X6XZY50=;
        b=CpR/gLe3MF95YxNcop20KhLRfKcLJ+gqdTLD5wpi1nHPg4yExt+ucHHbEOtGbZ190G
         BGRhGfyF2YIYrSZdxPZg0OVwdUVMpctboTXEWA85/yMghIK29DkfLiR3V/4iQ0zSipqe
         L/74/Lkw91JZu5CXSdA0pjDplcmWcFdfGFGJJL4jTjwq7krKV14uE85fZvhrozOEv+p0
         cVKGywdatLFxjqU23YbBa+m84WOrO/YpnZtGfe9j6womdWEQwqs049havWo0oY4dEwxw
         2fGs4+fsoMpbXcojSWgdRgM82675Wv19w2Ys5MBvvsBJXYy3uP52b5YEV3a1AbuApRp7
         bqug==
X-Gm-Message-State: APjAAAU7/uK3AfXlfwHu8GOogLzLEGQc4XhP8l/P3jK39xG3UeR8Ctc+
        M873P8LV6huj3vHw+yNQcU0=
X-Google-Smtp-Source: APXvYqxpINo5hlSG8EFTMuxKjwNaK3tOIVMDoJzr5on8KeKCsTiW03t3FolwHGgy9uGq+mC9XvV2zw==
X-Received: by 2002:a17:90a:2a09:: with SMTP id i9mr8298025pjd.103.1559076197011;
        Tue, 28 May 2019 13:43:17 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id t10sm21528394pfe.2.2019.05.28.13.43.14
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 13:43:15 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 1/6] bpf: Create
 BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY
To:     Lawrence Brakmo <brakmo@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Martin Lau <kafai@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
References: <20190528034907.1957536-1-brakmo@fb.com>
 <20190528034907.1957536-2-brakmo@fb.com>
 <75cd4d0a-7cf8-ee63-2662-1664aedcd468@gmail.com>
 <B962F80F-FF37-4B96-A942-1C78E4D77A1C@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bb4d491e-324a-a7b0-1e0c-a85d375f1d15@gmail.com>
Date:   Tue, 28 May 2019 13:43:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <B962F80F-FF37-4B96-A942-1C78E4D77A1C@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/28/19 11:54 AM, Lawrence Brakmo wrote:
> On 5/28/19, 6:43 AM, "netdev-owner@vger.kernel.org on behalf of Eric Dumazet" <netdev-owner@vger.kernel.org on behalf of eric.dumazet@gmail.com> wrote:
> 

>     Why are you using preempt_enable_no_resched() here ?
> 
> Because that is what __BPF_PROG_RUN_ARRAY() calls and the macro
> BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY() is an instantiation of it
> (with minor changes in the return value).

I do not see this in my tree.

Please rebase your tree, do not bring back an issue that was solved already.



