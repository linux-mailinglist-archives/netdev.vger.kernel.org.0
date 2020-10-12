Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5FC28B16A
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 11:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgJLJYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 05:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgJLJYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 05:24:11 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6774C0613CE;
        Mon, 12 Oct 2020 02:24:10 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t9so18307362wrq.11;
        Mon, 12 Oct 2020 02:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DMVGRL2h5VknQLtG+XBcBI/2PJssThsIUXIEgYmYsSU=;
        b=uKFHU+okcDjb6Fb/zP+lA9f+wlJxiFRf7FlqX2XxTyuTAKieQcr+4zEW7fj4A8Nodv
         UF+rwE5tD2Honok8Btx3sX6sPae46NxFjByl9kbbCK6ESCFKenq7EwhoEVom6Bihw8o8
         JwSALjaIOzE1qYYNL5Z5adiyP5tSNlQubxoSXrK/Q/orJAeILuAmOveunVcy+BUGzlKh
         GiyXc7DjBg3xpg2bF/WuWixArQ5fEkUFuXU6lyRn3lcpiitXWoGX4CX48uXPPd3VpwYe
         HPOJndvhcauDFtUV5/TmvJEWQsDs07mw7cLnIx/vGlrqjxN8HNJwzQgzNPlmNJICIUK+
         Nd0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DMVGRL2h5VknQLtG+XBcBI/2PJssThsIUXIEgYmYsSU=;
        b=Ku7+aPhQPMMJ/r0tqU2La/x6Wv1viUaqthJN93lDREzB0lWKUFrDoOTHWsndLZpSWA
         ABBAow1rw9sUqkiUoT1NoBweX0eiG1Wrbby6Upy3mhEm5U6r3puftkCsx44z2Zh937p8
         hPbQ5AuwVP5rT5WIVaoBtyFUyxerHwGxsre4XjHCtzMZ0KYeCg6P+Hgb9xl4X/dyivFZ
         lEbfZpfnn1m01hX921/fE0OgDkgSqI6KhK7+cFBKqWH2dQ8WOA/lV38jlxEO7TVIofqA
         HrxrdjWY0jSXT3vmDnHoRNjGFkfPwD7oYuFhCag3ebpkGVtedQC6kziZcTLMM+mbjgVh
         02Lg==
X-Gm-Message-State: AOAM531rC2RaAGUkzRe51Z9/foBYwM8tCd4ZJz8tuP9UfiTBdKyDR/WL
        J4jNIkm+oXTxGqdC4gzzlPk=
X-Google-Smtp-Source: ABdhPJxWeGiqNCh1RC5V9AJmojzSnIkqs8imzlEXRVq0FqWUz6cdLVCww51FepImaJs0WTrh5TtGDQ==
X-Received: by 2002:adf:9f4c:: with SMTP id f12mr16937624wrg.108.1602494649624;
        Mon, 12 Oct 2020 02:24:09 -0700 (PDT)
Received: from [192.168.8.147] ([37.167.93.109])
        by smtp.gmail.com with ESMTPSA id c16sm25066726wrx.31.2020.10.12.02.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Oct 2020 02:24:08 -0700 (PDT)
Subject: Re: [External] Re: [PATCH] mm: proc: add Sock to /proc/meminfo
To:     Muchun Song <songmuchun@bytedance.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
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
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9262ea44-fc3a-0b30-54dd-526e16df85d1@gmail.com>
Date:   Mon, 12 Oct 2020 11:24:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAMZfGtXVKER_GM-wwqxrUshDzcEg9FkS3x_BaMTVyeqdYPGSkw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/20 10:39 AM, Muchun Song wrote:
> On Mon, Oct 12, 2020 at 3:42 PM Eric Dumazet <edumazet@google.com> wrote:
>>
>> On Mon, Oct 12, 2020 at 6:22 AM Muchun Song <songmuchun@bytedance.com> wrote:
>>>
>>> On Mon, Oct 12, 2020 at 2:39 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>>>>
>>>> On Sat, Oct 10, 2020 at 3:39 AM Muchun Song <songmuchun@bytedance.com> wrote:
>>>>>
>>>>> The amount of memory allocated to sockets buffer can become significant.
>>>>> However, we do not display the amount of memory consumed by sockets
>>>>> buffer. In this case, knowing where the memory is consumed by the kernel
>>>>
>>>> We do it via `ss -m`. Is it not sufficient? And if not, why not adding it there
>>>> rather than /proc/meminfo?
>>>
>>> If the system has little free memory, we can know where the memory is via
>>> /proc/meminfo. If a lot of memory is consumed by socket buffer, we cannot
>>> know it when the Sock is not shown in the /proc/meminfo. If the unaware user
>>> can't think of the socket buffer, naturally they will not `ss -m`. The
>>> end result
>>> is that we still don’t know where the memory is consumed. And we add the
>>> Sock to the /proc/meminfo just like the memcg does('sock' item in the cgroup
>>> v2 memory.stat). So I think that adding to /proc/meminfo is sufficient.
>>>
>>>>
>>>>>  static inline void __skb_frag_unref(skb_frag_t *frag)
>>>>>  {
>>>>> -       put_page(skb_frag_page(frag));
>>>>> +       struct page *page = skb_frag_page(frag);
>>>>> +
>>>>> +       if (put_page_testzero(page)) {
>>>>> +               dec_sock_node_page_state(page);
>>>>> +               __put_page(page);
>>>>> +       }
>>>>>  }
>>>>
>>>> You mix socket page frag with skb frag at least, not sure this is exactly
>>>> what you want, because clearly skb page frags are frequently used
>>>> by network drivers rather than sockets.
>>>>
>>>> Also, which one matches this dec_sock_node_page_state()? Clearly
>>>> not skb_fill_page_desc() or __skb_frag_ref().
>>>
>>> Yeah, we call inc_sock_node_page_state() in the skb_page_frag_refill().
>>> So if someone gets the page returned by skb_page_frag_refill(), it must
>>> put the page via __skb_frag_unref()/skb_frag_unref(). We use PG_private
>>> to indicate that we need to dec the node page state when the refcount of
>>> page reaches zero.
>>>
>>
>> Pages can be transferred from pipe to socket, socket to pipe (splice()
>> and zerocopy friends...)
>>
>>  If you want to track TCP memory allocations, you always can look at
>> /proc/net/sockstat,
>> without adding yet another expensive memory accounting.
> 
> The 'mem' item in the /proc/net/sockstat does not represent real
> memory usage. This is just the total amount of charged memory.
> 
> For example, if a task sends a 10-byte message, it only charges one
> page to memcg. But the system may allocate 8 pages. Therefore, it
> does not truly reflect the memory allocated by the above memory
> allocation path. We can see the difference via the following message.
> 
> cat /proc/net/sockstat
>   sockets: used 698
>   TCP: inuse 70 orphan 0 tw 617 alloc 134 mem 13
>   UDP: inuse 90 mem 4
>   UDPLITE: inuse 0
>   RAW: inuse 1
>   FRAG: inuse 0 memory 0
> 
> cat /proc/meminfo | grep Sock
>   Sock:              13664 kB
> 
> The /proc/net/sockstat only shows us that there are 17*4 kB TCP
> memory allocations. But apply this patch, we can see that we truly
> allocate 13664 kB(May be greater than this value because of per-cpu
> stat cache). Of course the load of the example here is not high. In
> some high load cases, I believe the difference here will be even
> greater.
> 

This is great, but you have not addressed my feedback.

TCP memory allocations are bounded by /proc/sys/net/ipv4/tcp_mem

Fact that the memory is forward allocated or not is a detail.

If you think we must pre-allocate memory, instead of forward allocations,
your patch does not address this. Adding one line per consumer in /proc/meminfo looks
wrong to me.

If you do not want 9.37 % of physical memory being possibly used by TCP,
just change /proc/sys/net/ipv4/tcp_mem accordingly ?


