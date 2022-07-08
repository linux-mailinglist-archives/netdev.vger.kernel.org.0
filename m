Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A45556BB72
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 16:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiGHOCD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 10:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238375AbiGHOCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 10:02:02 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368EF18395
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 07:02:00 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id l9-20020a056830268900b006054381dd35so16269258otu.4
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 07:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AgCA7JC4n87M0J4Cctl8zaLThkaSJBjNpAQEBOK0n1E=;
        b=YuCU3LC4EmqmDANYLVa2rGn4cR9g+9cw2DLgXF8oCoF6AZxLFRfSQJPVMFb5dcnxhI
         a05pFGlm/tVZW44jkqy1SXPlR5wDktz+7LIkeToD/5YkiElWGugxmgLSpDUf+s2OskWJ
         Cp37s+zDo3qupWC0gw3gLYxdm4Zdfrlycfxyk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AgCA7JC4n87M0J4Cctl8zaLThkaSJBjNpAQEBOK0n1E=;
        b=gG7WFeH5lXJKNsWyyZ5ScKmo6G29V8GhWpjtA0x6O5+q05amTw/nWzJPSTNmSWntnD
         aSwJKSvXzBVz96qHiTrBTLxtMB6GHewyD+2IuL4+Wu597Cu6yTpXN4iohhaAYcaN09L3
         EXwbFvZ4rNWcjRDmWQZ9IQqPMaZFQn15WDoXb8TiXB0SI+c+ztbpkIXG3eUXePpdzahB
         uNxxpyEcsKxKLGfKBDaxlPOSlNaeNC7vpNVhsPQRhlHPUFcBSsH8T5AYUAmTIxB9cjvG
         FkV5hyQlXqj/Q6PCZ/Rw5AO/6AiOfEbsDdT5BIbSGpq59oDSL9pWDXasupGcuKcI7p8f
         FA/g==
X-Gm-Message-State: AJIora/IQ2DireVvxpqQZmRDvrueg/Plek5bNUuKur/7hcrtPw6732c2
        7ksNyaQeD5QblbZWTmDOJarxmQ==
X-Google-Smtp-Source: AGRyM1sIQoZ2at//x/8ubeDtbsVzTdvW8iCJcL4x2IwszMFpKBYhfmP4STbUFtn8jkNHayqOr+h8zw==
X-Received: by 2002:a05:6830:2331:b0:61c:2c18:555 with SMTP id q17-20020a056830233100b0061c2c180555mr1212008otg.367.1657288919372;
        Fri, 08 Jul 2022 07:01:59 -0700 (PDT)
Received: from [192.168.0.41] ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id x10-20020a9d704a000000b00616d98ad780sm12787337otj.52.2022.07.08.07.01.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 07:01:43 -0700 (PDT)
Message-ID: <3dbd5b30-f869-b284-1383-309ca6994557@cloudflare.com>
Date:   Fri, 8 Jul 2022 09:01:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 0/4] Introduce security_create_user_ns()
Content-Language: en-US
To:     =?UTF-8?Q?Christian_G=c3=b6ttsche?= <cgzones@googlemail.com>
Cc:     KP Singh <kpsingh@kernel.org>, revest@chromium.org,
        jackmanb@chromium.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, shuah@kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        SElinux list <selinux@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, kernel-team@cloudflare.com
References: <20220707223228.1940249-1-fred@cloudflare.com>
 <CAJ2a_DezgSpc28jvJuU_stT7V7et-gD7qjy409oy=ZFaUxJneg@mail.gmail.com>
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <CAJ2a_DezgSpc28jvJuU_stT7V7et-gD7qjy409oy=ZFaUxJneg@mail.gmail.com>
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

On 7/8/22 7:10 AM, Christian Göttsche wrote:
> ,On Fri, 8 Jul 2022 at 00:32, Frederick Lawler <fred@cloudflare.com> wrote:
>>
>> While creating a LSM BPF MAC policy to block user namespace creation, we
>> used the LSM cred_prepare hook because that is the closest hook to prevent
>> a call to create_user_ns().
>>
>> The calls look something like this:
>>
>>      cred = prepare_creds()
>>          security_prepare_creds()
>>              call_int_hook(cred_prepare, ...
>>      if (cred)
>>          create_user_ns(cred)
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
> Some thoughts:
> 
> I.
> 
> Why not make the hook more generic, e.g. support all other existing
> and potential future namespaces?

The main issue with a generic hook is that different namespaces have 
different calling contexts. We decided in a previous discussion to 
opt-out of a generic hook for this reason. [1]

> Also I think the naming scheme is <object>_<verb>.

That's a good call out. I was originally hoping to keep the security_*() 
match with the hook name matched with the caller function to keep things 
all aligned. If no one objects to renaming the hook, I can rename the 
hook for v3.

> 
>      LSM_HOOK(int, 0, namespace_create, const struct cred *cred,
> unsigned int flags)
> 
> where flags is a bitmap of CLONE flags from include/uapi/linux/sched.h
> (like CLONE_NEWUSER).
> 
> II.
> 
> While adding policing for namespaces maybe also add a new hook for setns(2)
> 
>      LSM_HOOK(int, 0, namespace_join, const struct cred *subj,  const
> struct cred *obj, unsigned int flags)
> 

IIUC, setns() will create a new namespace for the other namespaces 
except for user namespace. If we add a security hook for the other 
create_*_ns() functions, then we can catch setns() at that point.

> III.
> 
> Maybe even attach a security context to namespaces so they can be
> further governed?
> SELinux example:
> 
>      type domainA_userns_t;
>      type_transition domainA_t domainA_t : namespace domainA_userns_t "user";
>      allow domainA_t domainA_userns_t:namespace create;
> 
>      # domainB calling setns(2) with domainA as target
>      allow domainB_t domainA_userns_t:namespace join;
> 

Links:
1. 
https://lore.kernel.org/all/CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com/

>>
>> Links:
>> 1. https://lore.kernel.org/all/20220608150942.776446-1-fred@cloudflare.com/
>> 2. https://lore.kernel.org/all/87y1xzyhub.fsf@email.froward.int.ebiederm.org/
>> 3. https://lore.kernel.org/all/9fe9cd9f-1ded-a179-8ded-5fde8960a586@cloudflare.com/
>>
>> Changes since v1:
>> - Add selftests/bpf: Add tests verifying bpf lsm create_user_ns hook patch
>> - Add selinux: Implement create_user_ns hook patch
>> - Change function signature of security_create_user_ns() to only take
>>    struct cred
>> - Move security_create_user_ns() call after id mapping check in
>>    create_user_ns()
>> - Update documentation to reflect changes
>>
>> Frederick Lawler (4):
>>    security, lsm: Introduce security_create_user_ns()
>>    bpf-lsm: Make bpf_lsm_create_user_ns() sleepable
>>    selftests/bpf: Add tests verifying bpf lsm create_user_ns hook
>>    selinux: Implement create_user_ns hook
>>
>>   include/linux/lsm_hook_defs.h                 |  1 +
>>   include/linux/lsm_hooks.h                     |  4 +
>>   include/linux/security.h                      |  6 ++
>>   kernel/bpf/bpf_lsm.c                          |  1 +
>>   kernel/user_namespace.c                       |  5 ++
>>   security/security.c                           |  5 ++
>>   security/selinux/hooks.c                      |  9 ++
>>   security/selinux/include/classmap.h           |  2 +
>>   .../selftests/bpf/prog_tests/deny_namespace.c | 88 +++++++++++++++++++
>>   .../selftests/bpf/progs/test_deny_namespace.c | 39 ++++++++
>>   10 files changed, 160 insertions(+)
>>   create mode 100644 tools/testing/selftests/bpf/prog_tests/deny_namespace.c
>>   create mode 100644 tools/testing/selftests/bpf/progs/test_deny_namespace.c
>>
>> --
>> 2.30.2
>>

