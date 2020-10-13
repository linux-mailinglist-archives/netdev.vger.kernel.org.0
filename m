Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC9028C8CD
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 08:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732554AbgJMGzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 02:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727353AbgJMGze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 02:55:34 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32669C0613D0;
        Mon, 12 Oct 2020 23:55:34 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e18so22576610wrw.9;
        Mon, 12 Oct 2020 23:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tsRtK+RphjJoix8LNFIUyEqIBIL/eXaIC2bZ4t/CBOQ=;
        b=DVCqZc0KrivZAyxTL0AvxUJIK8ar/eLOwEdWUo/cKCbAoTHgn33/8+mW9OHucS84v6
         0imUvQqQAst6kKaHRL53ucde/VGeMSByqHyllJ/uDQpUysG6+31rPcgj26UxVsnLdPw8
         bfyqYHaZd6F7DTxDh4M9MqsWd1Fqr7QO6Eib0jiaFCXEG3HkYbI14lKYhDar8x0Cdl8s
         pB7FD0Rhk2JUG7jdZ45/x7EknGoQjDpzV2vQ7D5UdDPRn5/rJbsCpCJQU5neobKMaKUQ
         U6QTs0HJiG92p59SleNX/m+xsMzOj0Pb+03mhokRCjuiTEZ/11U7eLxoWvknFy0pXz3f
         EJ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tsRtK+RphjJoix8LNFIUyEqIBIL/eXaIC2bZ4t/CBOQ=;
        b=dvGKsceSZHrXAvGm8wap9aB1lMJfJn7DxNjAZ4U5adYy66ftRTYeoY49LlHhrl5qV3
         j7Xi89dfLgY7McgHT9yK5OPf65n7z9z3W7lT8wolgX3bEJkDrp9uQhBGyqGfjZMvai1g
         5IsEJek8s2G4gtDYy6ObD3uMIosl/leTRsKWur1u2q1c6AURct5F3zPrbHeo4Lu3XWgE
         uvAfatXTNEbj2j+KCLm3A5C6PJ+vPN2vI53cS6jujPX08SgaFd41RJWO/WA+lru1MUH7
         TB1KHJ8GzAoglk0hioq4hImnszojbgkibZXrQrUlcoUMCfHhlZWyMIiU1aC3PCbgosGJ
         SgCQ==
X-Gm-Message-State: AOAM530mG2NdPEkYGbbCz/z7nRDJBo1rguo8zJwUAWuW3JEnAadNDhy7
        C7sQspuCN1ui1jxjvpscTqs=
X-Google-Smtp-Source: ABdhPJyQXupiGXk53k8bnCs10W8RAjL7Zi7PA+tSuK0vnrjR6U4YpJdR1j2LtYICyCerFkByTf/QBw==
X-Received: by 2002:adf:e412:: with SMTP id g18mr11015720wrm.211.1602572132746;
        Mon, 12 Oct 2020 23:55:32 -0700 (PDT)
Received: from [192.168.8.147] ([37.171.149.236])
        by smtp.gmail.com with ESMTPSA id f14sm26683540wme.22.2020.10.12.23.55.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 23:55:32 -0700 (PDT)
Subject: Re: [External] Re: [PATCH] mm: proc: add Sock to /proc/meminfo
To:     Muchun Song <songmuchun@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, rafael@kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Shakeel Butt <shakeelb@google.com>,
        Will Deacon <will@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Roman Gushchin <guro@fb.com>, Neil Brown <neilb@suse.de>,
        rppt@kernel.org, Sami Tolvanen <samitolvanen@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Feng Tang <feng.tang@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Florian Westphal <fw@strlen.de>, gustavoars@kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Thomas Gleixner <tglx@linutronix.de>, dave@stgolabs.net,
        Michel Lespinasse <walken@google.com>,
        Jann Horn <jannh@google.com>, chenqiwu@xiaomi.com,
        christophe.leroy@c-s.fr, Minchan Kim <minchan@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
References: <20201010103854.66746-1-songmuchun@bytedance.com>
 <CAM_iQpUQXctR8UBNRP6td9dWTA705tP5fWKj4yZe9gOPTn_8oQ@mail.gmail.com>
 <CAMZfGtUhVx_iYY3bJZRY5s1PG0N1mCsYGS9Oku8cTqPiMDze-g@mail.gmail.com>
 <CANn89iKprp7WYeZy4RRO5jHykprnSCcVBc7Tk14Ui_MA9OK7Fg@mail.gmail.com>
 <CAMZfGtXVKER_GM-wwqxrUshDzcEg9FkS3x_BaMTVyeqdYPGSkw@mail.gmail.com>
 <9262ea44-fc3a-0b30-54dd-526e16df85d1@gmail.com>
 <CAMZfGtVF6OjNuJFUExRMY1k-EaDS744=nKy6_a2cYdrJRncTgQ@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <93d5ad90-2bd5-07ad-618e-456ed2e6da87@gmail.com>
Date:   Tue, 13 Oct 2020 08:55:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAMZfGtVF6OjNuJFUExRMY1k-EaDS744=nKy6_a2cYdrJRncTgQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/20 11:53 AM, Muchun Song wrote:

> We are not complaining about TCP using too much memory, but how do
> we know that TCP uses a lot of memory. When I firstly face this problem,
> I do not know who uses the 25GB memory and it is not shown in the /proc/meminfo.
> If we can know the amount memory of the socket buffer via /proc/meminfo, we
> may not need to spend a lot of time troubleshooting this problem. Not everyone
> knows that a lot of memory may be used here. But I believe many people
> should know /proc/meminfo to confirm memory users.

Adding yet another operations in networking fast path is a high cost to pay
just to add one extra line in /proc/meminfo, while /proc/net/sockstat
is already a good proxy, with per protocol details, instead of a single bucket.

I reiterate that zero copy would make this counter out of sync,
unless special support is added (adding yet another operations ?)

Also your patch does not address gazillions of page allocations from drivers
in RX path.

Here at Google the majority of networking mm usage when hosts are under stress
is in RX path, when out of order queues start to grow in TCP sockets.

Allocations in TX path were greatly reduced and optimally sized with the introduction
of /proc/sys/net/ipv4/tcp_notsent_lowat.

We have gazillions of put_page()/__free_page()/__free_pages()/alloc_page()/... all
over the places, adding yet another tracking of "this page is used by networking stacks"
is going to be quite a big project.

I thought memcg was a better goal in the long run, lets focus on it.



