Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2B3257082
	for <lists+netdev@lfdr.de>; Sun, 30 Aug 2020 22:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgH3Uc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Aug 2020 16:32:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29016 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726150AbgH3UcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Aug 2020 16:32:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598819543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C6LNd/M7f8yjnWnGycX0VNlHNADmyStv3fopd0UN66g=;
        b=DTOWtMDgAe/Um7mXNl8Asl9UPZHmdGo+Es7X90pJqjJvcgF0YiLX68hY76cICMv50EfyR0
        rE9w6srWiGvJWTrE7Lr9IiGC/HX+J7pVh3b9NhIvo2Fo9kT6lfcRKVxLMgJNbdEHR7DF43
        Egx653+88ZF1G1p0OBSlz32qbswJghg=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-C_l-VuQAO9CbYaDXWaiamQ-1; Sun, 30 Aug 2020 16:32:21 -0400
X-MC-Unique: C_l-VuQAO9CbYaDXWaiamQ-1
Received: by mail-oo1-f70.google.com with SMTP id i1so3414869ood.9
        for <netdev@vger.kernel.org>; Sun, 30 Aug 2020 13:32:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=C6LNd/M7f8yjnWnGycX0VNlHNADmyStv3fopd0UN66g=;
        b=uZIAvBzS+VpVT3vaOoyIqOhdfIGG3FwxeAbs3AI1VVjpl35IZIdwrciShcvcYtdilv
         9xuGZXnoJ0tdLNwD5F0TtYVgRi+HqXfLAjYpljRwoz7HqPFUPx7t/Px81GqlXgZsz6sP
         dxo0Gd7fK7PZb+Sr6Iaf96j0GcB8WTIc88qbdAdNLRjJl11J3LLvHE1jEObv1UTAQbWB
         eArUJMq0hNrbcViZqB9xHSyq4thQkCeYO12MrVjO+BmXCwSm1x5uxZe9Gq99cJKR3BbD
         6bsRTK6o7fjoTS3fff/rsm5n5HGRoxL/HaXdwsdkJumExzX4b7tLhrSpeNdwjtogmblh
         5i5g==
X-Gm-Message-State: AOAM531P1jnqkEYuLqj79ZWP5FMVbM3jTIpLrhNsVtJn8OEeOFFYMbrU
        ozrPA6DP1j/9gG1mCdwAEa6Ufll9xN5/vGdvqnV1gH3N9lffhCAahZ4TcqiOz0MSKC0Qh/JS9X9
        A/D5N7guYJvhjmZyl
X-Received: by 2002:a05:6808:117:: with SMTP id b23mr1888087oie.100.1598819540612;
        Sun, 30 Aug 2020 13:32:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwrD9u+F/6q4rxTxr/wlg5yP/lpYGhMDfdv39b63+EyY5FCBbybR161LiJntIW2vFMpWCd8RQ==
X-Received: by 2002:a05:6808:117:: with SMTP id b23mr1888076oie.100.1598819540299;
        Sun, 30 Aug 2020 13:32:20 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id w21sm1244227oih.37.2020.08.30.13.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Aug 2020 13:32:19 -0700 (PDT)
Subject: Re: [PATCH] net: openvswitch: pass NULL for unused parameters
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     pshelar@ovn.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev <netdev@vger.kernel.org>, dev@openvswitch.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20200830151459.4648-1-trix@redhat.com>
 <CAHp75VcdUoNMxzoQ4n2y4LrbYX5nTh3Y8rFh=5J9cv7iU-V=Hg@mail.gmail.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <5fc7bdfa-fedf-8f5e-9584-eb168b2fe3f3@redhat.com>
Date:   Sun, 30 Aug 2020 13:32:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VcdUoNMxzoQ4n2y4LrbYX5nTh3Y8rFh=5J9cv7iU-V=Hg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/30/20 1:02 PM, Andy Shevchenko wrote:
> On Sun, Aug 30, 2020 at 6:17 PM <trix@redhat.com> wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> clang static analysis flags these problems
>>
>> flow_table.c:713:2: warning: The expression is an uninitialized
>>   value. The computed value will also be garbage
>>         (*n_mask_hit)++;
>>         ^~~~~~~~~~~~~~~
>> flow_table.c:748:5: warning: The expression is an uninitialized
>>   value. The computed value will also be garbage
>>                                 (*n_cache_hit)++;
>>                                 ^~~~~~~~~~~~~~~~
>>
>> These are not problems because neither pararmeter is used
> parameter
Too many ar's, it must be talk like a pirate day.
>
>> by the calling function.
>>
>> Looking at all of the calling functions, there are many
>> cases where the results are unused.  Passing unused
>> parameters is a waste.
>>
>> To avoid passing unused parameters, rework the
>> masked_flow_lookup() and flow_lookup() routines to check
>> for NULL parameters and change the unused parameters to NULL.
>>
>> Signed-off-by: Tom Rix <trix@redhat.com>
>> ---
>>  net/openvswitch/flow_table.c | 16 +++++++---------
>>  1 file changed, 7 insertions(+), 9 deletions(-)
>>
>> diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
>> index e2235849a57e..18e7fa3aa67e 100644
>> --- a/net/openvswitch/flow_table.c
>> +++ b/net/openvswitch/flow_table.c
>> @@ -710,7 +710,8 @@ static struct sw_flow *masked_flow_lookup(struct table_instance *ti,
>>         ovs_flow_mask_key(&masked_key, unmasked, false, mask);
>>         hash = flow_hash(&masked_key, &mask->range);
>>         head = find_bucket(ti, hash);
>> -       (*n_mask_hit)++;
>> +       if (n_mask_hit)
>> +               (*n_mask_hit)++;
>>
>>         hlist_for_each_entry_rcu(flow, head, flow_table.node[ti->node_ver],
>>                                 lockdep_ovsl_is_held()) {
>> @@ -745,7 +746,8 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
>>                                 u64_stats_update_begin(&ma->syncp);
>>                                 usage_counters[*index]++;
>>                                 u64_stats_update_end(&ma->syncp);
>> -                               (*n_cache_hit)++;
>> +                               if (n_cache_hit)
>> +                                       (*n_cache_hit)++;
>>                                 return flow;
>>                         }
>>                 }
>> @@ -798,9 +800,8 @@ struct sw_flow *ovs_flow_tbl_lookup_stats(struct flow_table *tbl,
>>         *n_cache_hit = 0;
>>         if (unlikely(!skb_hash || mc->cache_size == 0)) {
>>                 u32 mask_index = 0;
>> -               u32 cache = 0;
>>
>> -               return flow_lookup(tbl, ti, ma, key, n_mask_hit, &cache,
>> +               return flow_lookup(tbl, ti, ma, key, n_mask_hit, NULL,
>>                                    &mask_index);
> Can it be done for mask_index as well?

Yes, it's a bit more complicated but doable.

Tom

