Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9892554CDF
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358667AbiFVOY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358369AbiFVOYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:24:49 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD77C3A5F5
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 07:24:35 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-f2a4c51c45so22616451fac.9
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 07:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RTCiI3z/FejuYZ8fuG7ALGW0XqlrQSjMbaE9qwJX9Cg=;
        b=ZQVTbEN7aUSDEdVs2YzfZWlgi3LbLYER2SLB8yHQY9UzSHPRwUSbJ/NDygAsKrAd7J
         aCH94nDm4GL5jbWvtBLV8vfQuiMl7/ZDQHOeePpUKtuiYYEaVMFgNk3doBxXIONUBjgv
         I6Rp+PmtrGPbaTovYHGreme6UXJYrZb4m5Bjs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RTCiI3z/FejuYZ8fuG7ALGW0XqlrQSjMbaE9qwJX9Cg=;
        b=tsisFcLEGH6r+l/Y8gdxYPidckk9XTqYR2PRnqWBDR6/dI9iTesUby59+WTBSAYNX5
         p+IEM5yzehjx7Z7PkV6HtFeniIKXTVAqKrUKQozjAb8kh37u2t/ntsU5y2eVuDdWb1Mf
         ORgefsj271wioRRrmEiG2DdGHv8EAY8YtKOEhHdGByJ+uJmVatabDQGnCGMys1gt13DR
         Me+9fnCmzXS4mrmJ8n6X2hw10jRg0AH6cyTzrK10iEfArDoSh5+6jsH7kC4UHhKV6ttn
         xMrbmvapDFKASmOeLBa2wy87wI9Heqtcckc2WOmpjv9GTbN8zpUp4//SpO+aYCJBG6/l
         oKvw==
X-Gm-Message-State: AJIora9mdgQUcTkRpQX/C2bfw1BCvCRu4LXdhRyQtgIjKAnqGD4z41ZB
        37n+zYo7JlO1FFTDzDXM0Y1Oag==
X-Google-Smtp-Source: AGRyM1v60GyMFZawKSzE9AV+dokDeZ2oOw03of096v2vdWHskT34HNJlwjkQbYpYkHqZslvi3hON/w==
X-Received: by 2002:a05:6870:3320:b0:fd:a944:1abf with SMTP id x32-20020a056870332000b000fda9441abfmr24133333oae.251.1655907874821;
        Wed, 22 Jun 2022 07:24:34 -0700 (PDT)
Received: from [192.168.0.115] ([172.58.70.161])
        by smtp.gmail.com with ESMTPSA id w25-20020a4a7659000000b0035eb4e5a6cesm11612512ooe.36.2022.06.22.07.24.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 07:24:34 -0700 (PDT)
Message-ID: <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com>
Date:   Wed, 22 Jun 2022 09:24:31 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
Content-Language: en-US
To:     Casey Schaufler <casey@schaufler-ca.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc:     brauner@kernel.org, paul@paul-moore.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
References: <20220621233939.993579-1-fred@cloudflare.com>
 <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Casey,

On 6/21/22 7:19 PM, Casey Schaufler wrote:
> On 6/21/2022 4:39 PM, Frederick Lawler wrote:
>> While creating a LSM BPF MAC policy to block user namespace creation, we
>> used the LSM cred_prepare hook because that is the closest hook to 
>> prevent
>> a call to create_user_ns().
>>
>> The calls look something like this:
>>
>>      cred = prepare_creds()
>>          security_prepare_creds()
>>              call_int_hook(cred_prepare, ...
>>      if (cred)
>>          create_user_ns(cred)
>>
>> We noticed that error codes were not propagated from this hook and
>> introduced a patch [1] to propagate those errors.
>>
>> The discussion notes that security_prepare_creds()
>> is not appropriate for MAC policies, and instead the hook is
>> meant for LSM authors to prepare credentials for mutation. [2]
>>
>> Ultimately, we concluded that a better course of action is to introduce
>> a new security hook for LSM authors. [3]
>>
>> This patch set first introduces a new security_create_user_ns() function
>> and create_user_ns LSM hook, then marks the hook as sleepable in BPF.
> 
> Why restrict this hook to user namespaces? It seems that an LSM that
> chooses to preform controls on user namespaces may want to do so for
> network namespaces as well.
IIRC, CLONE_NEWUSER is the only namespace flag that does not require 
CAP_SYS_ADMIN. There is a security use case to prevent this namespace 
from being created within an unprivileged environment. I'm not opposed 
to a more generic hook, but I don't currently have a use case to block 
any others. We can also say the same is true for the other namespaces: 
add this generic security function to these too.

I'm curious what others think about this too.


> Also, the hook seems backwards. You should
> decide if the creation of the namespace is allowed before you create it.
> Passing the new namespace to a function that checks to see creating a
> namespace is allowed doesn't make a lot off sense.
> 

I think having more context to a security hook is a good thing. I 
believe you brought up in the previous discussions that you'd like to 
use this hook for xattr purposes. Doesn't that require a namespace?

>>
>> Links:
>> 1. 
>> https://lore.kernel.org/all/20220608150942.776446-1-fred@cloudflare.com/
>> 2. 
>> https://lore.kernel.org/all/87y1xzyhub.fsf@email.froward.int.ebiederm.org/ 
>>
>> 3. 
>> https://lore.kernel.org/all/9fe9cd9f-1ded-a179-8ded-5fde8960a586@cloudflare.com/ 
>>
>>
>> Frederick Lawler (2):
>>    security, lsm: Introduce security_create_user_ns()
>>    bpf-lsm: Make bpf_lsm_create_user_ns() sleepable
>>
>>   include/linux/lsm_hook_defs.h | 2 ++
>>   include/linux/lsm_hooks.h     | 5 +++++
>>   include/linux/security.h      | 8 ++++++++
>>   kernel/bpf/bpf_lsm.c          | 1 +
>>   kernel/user_namespace.c       | 5 +++++
>>   security/security.c           | 6 ++++++
>>   6 files changed, 27 insertions(+)
>>
>> -- 
>> 2.30.2
>>

