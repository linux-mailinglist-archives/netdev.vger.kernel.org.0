Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D473ADD594
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387414AbfJRXi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:38:57 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46604 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfJRXi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:38:57 -0400
Received: by mail-pl1-f194.google.com with SMTP id q24so3556918plr.13
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=9Bw+lSS4xC+8adtb+XwXRobxOG/k7mK2AAeEiFZPDgs=;
        b=F+l4cOfQ6HPbZxvPlNaGfWYw/taUTaLeau+l+1+yiZ5Rl/knWYJ83/JiwLhZE3ztK1
         WRd+Cce46BWf+TqoUjWt8fL3mLZwkSeN8c6AKEptronvH6HDvwo+XebeA2yKFiekxqsZ
         VcawGi0lEuStacCYOZUf/tRvIc1XobW7lR56SPPxY/bmaDMRL51wjskx1JAXQNmW1o0B
         Yvwbcx0Tu+SVRUzbno9SNe8ZDNwaHV1i73dMHRxZnGbdH6THBeu6tr/RE1U1WvICujjy
         UZ/yP9kD1+aWkW1jh4hkZpKoAUoHN0EqxLg7lXM4YqwPLZgCOEXPZt6R1boVfYQ4ynDh
         VrRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=9Bw+lSS4xC+8adtb+XwXRobxOG/k7mK2AAeEiFZPDgs=;
        b=DW4ALqe3hGDlXhcbJadOaqr2HPCMy92YJ2MaKkZs8noT5Gvir6OWX8UZYtfqyx/5fe
         OazLXFMJKCGUYlOZqIoyJwRaLv8DzpUE2LOSDy47SeLFIT7ut+JAKgczj1wBcqhnnwLd
         motp47NjO5TrBsvdYrohmYqZx1I50vfAznYj2Ui0qY9J5uXycBa4uDER67lV2gZi0/6o
         A7N59eWyMOfnVbXM9saCxrXXUnUme6ygadPcOi3EAaz8igVz/86ttKxShXRsJFsVmdlS
         Y/nYyY50MU1FNlqR1XXuuQLAf1fNeu+CeQYAyjA77HPnvRQMyr1wf1CoQQgdnGOfP8GQ
         zV+w==
X-Gm-Message-State: APjAAAV0qcql5KUXyQhmnH3C6X3JZgEEdHx1IGwkNqzeVFfOWH1OUS+2
        U4Epsd5l4q8XZGImuQ7rv+s=
X-Google-Smtp-Source: APXvYqxj7C+o/YPNV05dKT2X6hl8Q12AlBtj3idry8MZRDbwfJDYCsIze2QVbp6wvhgwuHS+o+gAHw==
X-Received: by 2002:a17:902:b412:: with SMTP id x18mr7263868plr.236.1571441935928;
        Fri, 18 Oct 2019 16:38:55 -0700 (PDT)
Received: from [172.20.162.151] ([2620:10d:c090:180::d0dd])
        by smtp.gmail.com with ESMTPSA id q132sm7898405pfq.16.2019.10.18.16.38.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 16:38:55 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Saeed Mahameed" <saeedm@mellanox.com>
Cc:     ilias.apalodimas@linaro.org, kernel-team@fb.com,
        netdev@vger.kernel.org, "Tariq Toukan" <tariqt@mellanox.com>,
        brouer@redhat.com
Subject: Re: [PATCH 04/10 net-next] page_pool: Add API to update numa node and
 flush page caches
Date:   Fri, 18 Oct 2019 16:38:54 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <97611859-102C-4BEB-AD7B-B9D77658AB98@gmail.com>
In-Reply-To: <97c98884948c6221db50bb850bb03e3a4684f060.camel@mellanox.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
 <20191016225028.2100206-5-jonathan.lemon@gmail.com>
 <20191017120617.GA19322@apalos.home>
 <97c98884948c6221db50bb850bb03e3a4684f060.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18 Oct 2019, at 14:07, Saeed Mahameed wrote:

> On Thu, 2019-10-17 at 15:06 +0300, Ilias Apalodimas wrote:
>> Hi Saeed,
>>
>> On Wed, Oct 16, 2019 at 03:50:22PM -0700, Jonathan Lemon wrote:
>>> From: Saeed Mahameed <saeedm@mellanox.com>
>>>
>>> Add page_pool_update_nid() to be called from drivers when they
>>> detect
>>> numa node changes.
>>>
>>> It will do:
>>> 1) Flush the pool's page cache and ptr_ring.
>>> 2) Update page pool nid value to start allocating from the new numa
>>> node.
>>>
>>> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
>>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>>> ---
>>>  include/net/page_pool.h | 10 ++++++++++
>>>  net/core/page_pool.c    | 16 +++++++++++-----
>>>  2 files changed, 21 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>>> index 2cbcdbdec254..fb13cf6055ff 100644
>>> --- a/include/net/page_pool.h
>>> +++ b/include/net/page_pool.h
>>> @@ -226,4 +226,14 @@ static inline bool page_pool_put(struct
>>> page_pool *pool)
>>>  	return refcount_dec_and_test(&pool->user_cnt);
>>>  }
>>>
>>> +/* Only safe from napi context or when user guarantees it is
>>> thread safe */
>>> +void __page_pool_flush(struct page_pool *pool);
>>
>> This should be called per packet right? Any noticeable impact on
>> performance?
>>
> no, once per napi and only if a change in numa node is detected, so
> very very rare !
>
>>> +static inline void page_pool_update_nid(struct page_pool *pool,
>>> int new_nid)
>>> +{
>>> +	if (unlikely(pool->p.nid != new_nid)) {
>>> +		/* TODO: Add statistics/trace */
>>> +		__page_pool_flush(pool);
>>> +		pool->p.nid = new_nid;
>>> +	}
>>> +}
>>>  #endif /* _NET_PAGE_POOL_H */
>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>>> index 5bc65587f1c4..678cf85f273a 100644
>>> --- a/net/core/page_pool.c
>>> +++ b/net/core/page_pool.c
>>> @@ -373,16 +373,13 @@ void __page_pool_free(struct page_pool *pool)
>>>  }
>>>  EXPORT_SYMBOL(__page_pool_free);
>>>
>>> -/* Request to shutdown: release pages cached by page_pool, and
>>> check
>>> - * for in-flight pages
>>> - */
>>> -bool __page_pool_request_shutdown(struct page_pool *pool)
>>> +void __page_pool_flush(struct page_pool *pool)
>>>  {
>>>  	struct page *page;
>>>
>>>  	/* Empty alloc cache, assume caller made sure this is
>>>  	 * no-longer in use, and page_pool_alloc_pages() cannot be
>>> -	 * call concurrently.
>>> +	 * called concurrently.
>>>  	 */
>>>  	while (pool->alloc.count) {
>>>  		page = pool->alloc.cache[--pool->alloc.count];
>>> @@ -393,6 +390,15 @@ bool __page_pool_request_shutdown(struct
>>> page_pool *pool)
>>>  	 * be in-flight.
>>>  	 */
>>>  	__page_pool_empty_ring(pool);
>>> +}
>>> +EXPORT_SYMBOL(__page_pool_flush);
>>
>> A later patch removes this, do we actually need it here?
>
> I agree, Jonathan changed the design of my last patch in this series
> and this became redundant as he is going to do lazy release of unwanted
> pages, rather than flushing the cache.

Yeah - I didn't want to take the latency hit when the node changed,
and would prefer to just amortize the cost over time.
-- 
Jonathan


>
>>
>>> +
>>> +/* Request to shutdown: release pages cached by page_pool, and
>>> check
>>> + * for in-flight pages
>>> + */
>>> +bool __page_pool_request_shutdown(struct page_pool *pool)
>>> +{
>>> +	__page_pool_flush(pool);
>>>
>>>  	return __page_pool_safe_to_destroy(pool);
>>>  }
>>> -- 
>>> 2.17.1
>>>
>>
>> Thanks
>> /Ilias
