Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576F5526977
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383367AbiEMSij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359088AbiEMSig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:38:36 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E944F10E4
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:38:30 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id x88so8815696pjj.1
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=bUll9EZdTqdsVM4QKgbt5mHzhJZWttOT3qxL7FR14WM=;
        b=oKXAjDiycQ+Xl95nE6rgB+ktCMLwY/tqptAt8RwtI8tWNNEmOCh/ZaJgnE979uldkv
         rNRtLb0SW/+4xgBwxY7PFzfR4D4LiTLFcFPA8Pzxz9hnHbvkH8lYtl3+bUs+Q6OiYPlp
         IDClf8QTqyaEN+EMugVck5CVl3s2uTfqm9hsW+KJFXExijs3Nw/NDixOg9IMaexAVDHl
         V1IcWfH8C2ZQ79ZDHVuMexe4s0lqM0VwhJXCYK0eSE2RXYFPpyNtWwxSsuZLD/fNf3OF
         fzu37XqCqgPjxzfC90EHvluJZDe304JJBjcm32hiGpB8H7KUjJ3e3tP5TNGG8ItWH10n
         w4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=bUll9EZdTqdsVM4QKgbt5mHzhJZWttOT3qxL7FR14WM=;
        b=r3EMlfpLZS674lU/XOv5Yx8fAJoR3Q/JfTu4Is7yxs/y6CknxrMdFiVr+W6TxMjIVR
         S8ay3yMcZh5lCZxq0JEpLKlN4JyXWPm/udTAOtbYJaeKwwuVbDzWJM5Xc0pbLxswOz3Z
         /xxjUAAb7D3OY2MpR9xSbcCDdukYv5ZToGCGMZ7WxF4RRq4kaaINfoEbSvsYJUhLVZnz
         QtQlMYWDgXR4FKSQJtwJnQfP3moNxbpSATZkdAUlk9+BrxtzhTRdP/40xlPMA5d7/Lle
         Dtd8rYTaUb0M+bd/uLn9lN0U2UDESlTksuK6p3GJOwSKFItv+GYUcURlbMza066DRjHk
         INhQ==
X-Gm-Message-State: AOAM532qWjaPDUpD62Mh5P/FRMrAqtYYNe7eH3qO7PQJHvP8XEf0kbAk
        9AP6WL5JfQr+o5OJxTIu5l9E4g==
X-Google-Smtp-Source: ABdhPJygXvdM77Qs1Phfsnv0IQN/lWgaQlWeL3omu1KKDpZJfEDXiWrvXt+LWmuScYehHcRKS2rR2g==
X-Received: by 2002:a17:902:f684:b0:15e:8c4a:c54b with SMTP id l4-20020a170902f68400b0015e8c4ac54bmr5986060plg.21.1652467110296;
        Fri, 13 May 2022 11:38:30 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id a9-20020a62bd09000000b0050dc762818csm2092022pff.102.2022.05.13.11.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 11:38:29 -0700 (PDT)
Message-ID: <49f0ab7d-def2-811a-d414-37369faf882e@linaro.org>
Date:   Fri, 13 May 2022 11:38:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com
References: <CAEf4BzbiVeQfhxEu908w2mU4d8+5kKeMknuvhzCXuxM9pJ1jmQ@mail.gmail.com>
 <20220415141355.4329-1-tadeusz.struk@linaro.org>
 <CAEf4Bzah9K7dEa_7sXE4TnkuMTRHypMU9DxiLezgRvLjcqE_YA@mail.gmail.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH v2] bpf: Fix KASAN use-after-free Read in
 compute_effective_progs
In-Reply-To: <CAEf4Bzah9K7dEa_7sXE4TnkuMTRHypMU9DxiLezgRvLjcqE_YA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrii,
On 4/20/22 10:07, Andrii Nakryiko wrote:
>> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
>> index 128028efda64..5a64cece09f3 100644
>> --- a/kernel/bpf/cgroup.c
>> +++ b/kernel/bpf/cgroup.c
>> @@ -723,10 +723,8 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>>          pl->link = NULL;
>>
>>          err = update_effective_progs(cgrp, atype);
>> -       if (err)
>> -               goto cleanup;
>>
>> -       /* now can actually delete it from this cgroup list */
>> +       /* now can delete it from this cgroup list */
>>          list_del(&pl->node);
>>          kfree(pl);
>>          if (list_empty(progs))
>> @@ -735,12 +733,55 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
>>          if (old_prog)
>>                  bpf_prog_put(old_prog);
>>          static_branch_dec(&cgroup_bpf_enabled_key[atype]);
>> -       return 0;
>> +
>> +       if (!err)
>> +               return 0;
>>
>>   cleanup:
>> -       /* restore back prog or link */
>> -       pl->prog = old_prog;
>> -       pl->link = link;
>> +       /*
>> +        * If compute_effective_progs failed with -ENOMEM, i.e. alloc for
>> +        * cgrp->bpf.inactive table failed, we can recover by removing
>> +        * the detached prog from effective table and rearranging it.
>> +        */
>> +       if (err == -ENOMEM) {
>> +               struct bpf_prog_array_item *item;
>> +               struct bpf_prog *prog_tmp, *prog_detach, *prog_last;
>> +               struct bpf_prog_array *array;
>> +               int index = 0, index_detach = -1;
>> +
>> +               array = cgrp->bpf.effective[atype];
>> +               item = &array->items[0];
>> +
>> +               if (prog)
>> +                       prog_detach = prog;
>> +               else
>> +                       prog_detach = link->link.prog;
>> +
>> +               if (!prog_detach)
>> +                       return -EINVAL;
>> +
>> +               while ((prog_tmp = READ_ONCE(item->prog))) {
>> +                       if (prog_tmp == prog_detach)
>> +                               index_detach = index;
>> +                       item++;
>> +                       index++;
>> +                       prog_last = prog_tmp;
>> +               }
>> +
>> +               /* Check if we found what's needed for removing the prog */
>> +               if (index_detach == -1 || index_detach == index-1)
>> +                       return -EINVAL;
>> +
>> +               /* Remove the last program in the array */
>> +               if (bpf_prog_array_delete_safe_at(array, index-1))
>> +                       return -EINVAL;
>> +
>> +               /* and update the detached with the last just removed */
>> +               if (bpf_prog_array_update_at(array, index_detach, prog_last))
>> +                       return -EINVAL;
>> +
>> +               err = 0;
>> +       }

Thanks for feedback, and sorry for delay. I got pulled into something else.

> There are a bunch of problems with this implementation.
> 
> 1. We should do this fallback right after update_effective_progs()
> returns error, before we get to list_del(&pl->node) and subsequent
> code that does some additional things (like clearing flags and stuff).
> This additional code needs to run even if update_effective_progs()
> fails. So I suggest to extract the logic of removing program from
> effective prog arrays into a helper function and doing
> 
> err = update_effective_progs(...);
> if (err)
>      purge_effective_progs();
> 
> where purge_effective_progs() will be the logic you are adding. And it
> will be void function because it can't fail.

I have implemented that in v3, will send that out soon.

> 
> 2. We have to update not just cgrp->bpf.effective array, but all the
> descendants' lists as well. See what update_effective_progs() is
> doing, it has css_for_each_descendant_pre() iteration. You need to do
> it here as well. But instead of doing compute_effective_progs() which
> allocates a new copy of an array we'll need to update existing array
> in place.
> 
> 3. Not clear why you need to do both bpf_prog_array_delete_safe_at()
> and bpf_prog_array_update_at(), isn't delete_safe_at() enought?

I thought that we need to reshuffle the table and move the progs around,
but your are right, delete_safe_at() is enough.

-- 
Thanks,
Tadeusz
