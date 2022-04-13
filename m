Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEB04FFCA7
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 19:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234560AbiDMRaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 13:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbiDMRaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 13:30:23 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199366C1C4
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:28:02 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id i24-20020a17090adc1800b001cd5529465aso2198146pjv.0
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 10:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=kujL7p0GwLveBSEOqYGp7ryLlCB5QH+7/CE7iGZN0TQ=;
        b=GExPk5ATZICbkE5mIW9Lihjs5TT+H85wuaaWrwsxiwX2vOfbDPkzTueBzSpeycJd28
         B3cq90bS3TBuEciCNFfHlw0vlLAwZBqOXldlrsqJo1LeqoU8kewJoTI8DDzsjTeQ1EwN
         eVxw5viL/HADnH+iBGy/k9tHGrEkQ0FQaZy7naRprjo/hbp6yuq0HExm4t0VArNiACFe
         z1jO7mtxqcyIVXfsjofuN5z1Un0L0wfErSduSroSulRsf721KEVkubfsvw/WagFApY5m
         Y4IHRl+jmzDDhz7G9IvXHlpC/PmIQ2ToDOiCe5SHRuQJt7L8af1CZ4I4kfkJtMZO6pcf
         xJGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=kujL7p0GwLveBSEOqYGp7ryLlCB5QH+7/CE7iGZN0TQ=;
        b=GUBIt+SaFqvbsNuYRCifX4aD1YecWsJeRn9ufv4D9ET2I8zQ2N8v5EixseeEgj9cIs
         pzohGYlSKRobY3BvTe5DKzOMsZN/YcoUU9vROzIOTMdrTmYp85MFytLM8rsshK73umDC
         3mvynREmXDvq3jCub9GQixUm/Oxk0ntz1uhyMWqNt2+L5WBj7dLTk0FAVk1Pu0n1EuoK
         ZZbzWjRWBql7UJhCnbacN0S+ogcm77Jo3qvjC+PkUa82XNtcPyjsth4ME8n5iJlRySQN
         QpX0qpAWou1laU/Yk+lPcCdZ2O/AvAWexJsNyQA8YBcF2FUFGlFlMd1AHfrWgIxwJK4I
         Vfdg==
X-Gm-Message-State: AOAM532DMRIBtEQdCT8/mXNmuQ2X06F8CLnPO33J4ix5M3t2868s4zXK
        MIrmjuySwjEAZYnq9Db4DaRr5w==
X-Google-Smtp-Source: ABdhPJz8ZapMqiwl4OrMI2SS4sA+Qlg/GiP6YYR3gcnNXfXia66TKVeK0m/YUYMyqvdlWycLHKEGqg==
X-Received: by 2002:a17:90b:3a91:b0:1cb:955d:905c with SMTP id om17-20020a17090b3a9100b001cb955d905cmr12094736pjb.164.1649870881553;
        Wed, 13 Apr 2022 10:28:01 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id k27-20020aa79d1b000000b005059ad6b943sm16367677pfp.166.2022.04.13.10.28.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 10:28:01 -0700 (PDT)
Message-ID: <e7692d0b-e495-8d3e-4905-c4109bf5caa4@linaro.org>
Date:   Wed, 13 Apr 2022 10:28:00 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        syzbot+f264bffdfbd5614f3bb2@syzkaller.appspotmail.com
References: <20220405170356.43128-1-tadeusz.struk@linaro.org>
 <CAEf4BzaPmp5TzNM8U=SSyEp30wv335_ZxuAL-LLPQUZJ9OS74g@mail.gmail.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH] bpf: Fix KASAN use-after-free Read in
 compute_effective_progs
In-Reply-To: <CAEf4BzaPmp5TzNM8U=SSyEp30wv335_ZxuAL-LLPQUZJ9OS74g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrii,
On 4/12/22 21:34, Andrii Nakryiko wrote:
> On Tue, Apr 5, 2022 at 10:04 AM Tadeusz Struk<tadeusz.struk@linaro.org>  wrote:
>> Syzbot found a Use After Free bug in compute_effective_progs().
>> The reproducer creates a number of BPF links, and causes a fault
>> injected alloc to fail, while calling bpf_link_detach on them.
>> Link detach triggers the link to be freed by bpf_link_free(),
>> which calls __cgroup_bpf_detach() and update_effective_progs().
>> If the memory allocation in this function fails, the function restores
>> the pointer to the bpf_cgroup_link on the cgroup list, but the memory
>> gets freed just after it returns. After this, every subsequent call to
>> update_effective_progs() causes this already deallocated pointer to be
>> dereferenced in prog_list_length(), and triggers KASAN UAF error.
>> To fix this don't preserve the pointer to the link on the cgroup list
>> in __cgroup_bpf_detach(), but proceed with the cleanup and retry calling
>> update_effective_progs() again afterwards.
> I think it's still problematic. BPF link might have been the last one
> that holds bpf_prog's refcnt, so when link is put, its prog can stay
> there in effective_progs array(s) and will cause use-after-free
> anyways.
> 
> It would be best to make sure that detach never fails. On detach
> effective prog array can only shrink, so even if
> update_effective_progs() fails to allocate memory, we should be able
> to iterate and just replace that prog with NULL, as a fallback
> strategy.

it would be ideal if detach would never fail, but it would require some kind of 
prealloc, on attach maybe? Another option would be to minimize the probability
of failing by sending it gfp_t flags (GFP_NOIO | GFP_NOFS | __GFP_NOFAIL)?
Detach can really only fail if the kzalloc in compute_effective_progs() fails
so maybe doing something like bellow would help:

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 128028efda64..5a47740c317b 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -226,7 +226,8 @@ static bool hierarchy_allows_attach(struct cgroup *cgrp,
   */
  static int compute_effective_progs(struct cgroup *cgrp,
  				   enum cgroup_bpf_attach_type atype,
-				   struct bpf_prog_array **array)
+				   struct bpf_prog_array **array,
+				   gfp_t flags)
  {
  	struct bpf_prog_array_item *item;
  	struct bpf_prog_array *progs;
@@ -241,7 +242,7 @@ static int compute_effective_progs(struct cgroup *cgrp,
  		p = cgroup_parent(p);
  	} while (p);

-	progs = bpf_prog_array_alloc(cnt, GFP_KERNEL);
+	progs = bpf_prog_array_alloc(cnt, flags);
  	if (!progs)
  		return -ENOMEM;

@@ -308,7 +309,7 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
  	INIT_LIST_HEAD(&cgrp->bpf.storages);

  	for (i = 0; i < NR; i++)
-		if (compute_effective_progs(cgrp, i, &arrays[i]))
+		if (compute_effective_progs(cgrp, i, &arrays[i], GFP_KERNEL))
  			goto cleanup;

  	for (i = 0; i < NR; i++)
@@ -328,7 +329,8 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
  }

  static int update_effective_progs(struct cgroup *cgrp,
-				  enum cgroup_bpf_attach_type atype)
+				  enum cgroup_bpf_attach_type atype,
+				  gfp_t flags)
  {
  	struct cgroup_subsys_state *css;
  	int err;
@@ -340,7 +342,8 @@ static int update_effective_progs(struct cgroup *cgrp,
  		if (percpu_ref_is_zero(&desc->bpf.refcnt))
  			continue;

-		err = compute_effective_progs(desc, atype, &desc->bpf.inactive);
+		err = compute_effective_progs(desc, atype, &desc->bpf.inactive,
+					      flags);
  		if (err)
  			goto cleanup;
  	}
@@ -499,7 +502,7 @@ static int __cgroup_bpf_attach(struct cgroup *cgrp,
  	bpf_cgroup_storages_assign(pl->storage, storage);
  	cgrp->bpf.flags[atype] = saved_flags;

-	err = update_effective_progs(cgrp, atype);
+	err = update_effective_progs(cgrp, atype, GFP_KERNEL);
  	if (err)
  		goto cleanup;

@@ -722,7 +725,7 @@ static int __cgroup_bpf_detach(struct cgroup *cgrp, struct 
bpf_prog *prog,
  	pl->prog = NULL;
  	pl->link = NULL;

-	err = update_effective_progs(cgrp, atype);
+	err = update_effective_progs(cgrp, atype, GFP_NOIO | GFP_NOFS | __GFP_NOFAIL);
  	if (err)
  		goto cleanup;

>> -cleanup:
>> -       /* restore back prog or link */
>> -       pl->prog = old_prog;
>> -       pl->link = link;
>> +       /* In case of error call update_effective_progs again */
>> +       if (err)
>> +               err = update_effective_progs(cgrp, atype);
> there is no guarantee that this will now succeed, right? so it's more
> like "let's try just in case we are lucky this time"?

Yes, there is no guarantee, but my thinking was that since we have freed some
memory (see kfree(pl) above) let's retry and see if it works this time.
If that is combined with the above gfp flags it is a good chance that it will
work. What do you think?

-- 
Thanks,
Tadeusz
