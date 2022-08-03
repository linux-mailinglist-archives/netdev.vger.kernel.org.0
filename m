Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3354B588F44
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbiHCPUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238084AbiHCPUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:20:37 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD7C1145E
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 08:20:35 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id o16-20020a9d4110000000b0061cac66bd6dso12385281ote.11
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 08:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=RPqGFZtbNqgICpWV/6VvhSR6n3AOi6dZZb+5V7yogyQ=;
        b=eKxcY/wUV1t5iGFQOTkC3uUqXsNlO3wJPUXpinu2/pZFiIuEZDbShMVl1SWFB8VMKG
         dN33busgN2TumcApmrWbU9bmxspzUC3EobauqLvOHnBA8X1FgGKATmogtCPRFVJX7swX
         jnEljBTuf+JFh+gnVMEfcFQpvfPapnczKgq9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=RPqGFZtbNqgICpWV/6VvhSR6n3AOi6dZZb+5V7yogyQ=;
        b=PJjfstHDlSgkIxbJ0Z4VUHKxHe0jkAyMMkMI3Lzw9P5OXRCDAnV17fDW0Dd8lU8k60
         KARTERAV6JN5m5PH3K7etpGddK91rS4oTtQdJw7PV/WvkdAQtpBzHB2oLXM3uF3wvBbU
         GcHfzMe2EHBsRXC0eUizUN9ZCUyUQzlt3lrp+dr0jrPCm/kRxIuEs1bjo1Nz+HIFkZOr
         uoCraOhf66PT+K5NjF9RBfbr+TAjCyKD/jaimWgtxsyN0sfCeViDyLHY0HrAjGjvaXqM
         KRO6CbJQisAYfh6i9UdXyQ6Zp4FJ4lRRA0XYASuEh+RlJqVI5TMLlI4BIcOUPXG03v7h
         nLFA==
X-Gm-Message-State: AJIora8vr8zjC1lurUC/nzSe2cTTgWbFqfAM6PcSEVYuF7xVK7rdD+Eu
        qG6DAi5ZQIVkozG+rkXkUePLlQ==
X-Google-Smtp-Source: AGRyM1vhYxujzT2YaLXCnoBJSDqDHPUJMnPpsU0AX9VW0hT0pmIMq5BAvFR7alVbeYb7pUS4X0XAlA==
X-Received: by 2002:a9d:6007:0:b0:61c:ecd2:ac55 with SMTP id h7-20020a9d6007000000b0061cecd2ac55mr8737434otj.32.1659540034249;
        Wed, 03 Aug 2022 08:20:34 -0700 (PDT)
Received: from [192.168.0.41] ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id fo22-20020a0568709a1600b0010eaeee89a1sm3056992oab.46.2022.08.03.08.20.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Aug 2022 08:20:33 -0700 (PDT)
Message-ID: <aad6c2cb-abdd-b066-9d1d-d0f415256ae6@cloudflare.com>
Date:   Wed, 3 Aug 2022 10:20:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 0/4] Introduce security_create_user_ns()
Content-Language: en-US
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Paul Moore <paul@paul-moore.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, jmorris@namei.org,
        serge@hallyn.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, brauner@kernel.org,
        casey@schaufler-ca.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com,
        tixxdz@gmail.com
References: <20220721172808.585539-1-fred@cloudflare.com>
 <20220722061137.jahbjeucrljn2y45@kafai-mbp.dhcp.thefacebook.com>
 <18225d94bf0.28e3.85c95baa4474aabc7814e68940a78392@paul-moore.com>
 <87a68mcouk.fsf@email.froward.int.ebiederm.org>
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <87a68mcouk.fsf@email.froward.int.ebiederm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/2/22 4:33 PM, Eric W. Biederman wrote:
> Paul Moore <paul@paul-moore.com> writes:
> 
>> On July 22, 2022 2:12:03 AM Martin KaFai Lau <kafai@fb.com> wrote:
>>
>>> On Thu, Jul 21, 2022 at 12:28:04PM -0500, Frederick Lawler wrote:
>>>> While creating a LSM BPF MAC policy to block user namespace creation, we
>>>> used the LSM cred_prepare hook because that is the closest hook to prevent
>>>> a call to create_user_ns().
>>>>
>>>> The calls look something like this:
>>>>
>>>> cred = prepare_creds()
>>>> security_prepare_creds()
>>>> call_int_hook(cred_prepare, ...
>>>> if (cred)
>>>> create_user_ns(cred)
>>>>
>>>> We noticed that error codes were not propagated from this hook and
>>>> introduced a patch [1] to propagate those errors.
>>>>
>>>> The discussion notes that security_prepare_creds()
>>>> is not appropriate for MAC policies, and instead the hook is
>>>> meant for LSM authors to prepare credentials for mutation. [2]
>>>>
>>>> Ultimately, we concluded that a better course of action is to introduce
>>>> a new security hook for LSM authors. [3]
>>>>
>>>> This patch set first introduces a new security_create_user_ns() function
>>>> and userns_create LSM hook, then marks the hook as sleepable in BPF.
>>> Patch 1 and 4 still need review from the lsm/security side.
>>
>>
>> This patchset is in my review queue and assuming everything checks
>> out, I expect to merge it after the upcoming merge window closes.
> 
> It doesn't even address my issues with the last patchset.

Are you referring to [1], and with regards to [2], is the issue that the 
wording could be improved for both the cover letter and patch 1/4?

Ultimately, the goal of CF is to leverage and use user namespaces and 
block tasks whose meta information do not align with our allow list 
criteria. Yes, there is a higher goal of restricting our attack surface. 
Yes, people will find ways around security. The point is to have 
multiple levels of security, and this patch series allows people to add 
another level.

Calling this hook a regression is not true since there's no actual 
regression in the code. What would constitute a perceived regression is 
an admin imposing such a SELinux or BPF restriction within their 
company, but developers in that company ideally would try to work with 
the admin to enable user namespaces for certain use cases, or 
alternatively do what you don't want given current tooling: always run 
code as root. That's where this hook comes in: let people observe and 
enforce how they see fit. The average enthusiasts would see no impact.

I was requested to add _some_ test to BPF and to add a SELinux 
implementation. The low hanging fruit for a test to prove that the hook 
is capable of doing _something_ was to simply just block outright, and 
provide _some example_ of use. It doesn't make sense for us to write a 
test that outlines specifically what CF or others are doing because that 
would put too much emphasis on an implementation detail that doesn't 
matter to prove that the hook works.

Without Djalal's comment, I can't defend an observability use case that 
we're not currently leveraging. We have it now, so therefore I'll defend 
it per KP's suggestion[3] in v5.

By not responding to the email discussions, we can't accurately gauge 
what should or should not be in the descriptions. No one here 
necessarily disagrees with some of the points you made, and others have 
appropriately responded. As others have also wrote, you're not proposing 
alternatives. How do you expect us to work with that?

Please, let us know which bits and pieces ought to be included in the 
descriptions, and let us know what things we should call out caveats to 
that would satisfy your concerns.

Links:
1. 
https://lore.kernel.org/all/01368386-521f-230b-1d49-de19377c27d1@cloudflare.com/
2. 
https://lore.kernel.org/all/877d45kri4.fsf@email.froward.int.ebiederm.org/#t
3. 
https://lore.kernel.org/all/CACYkzJ4x90DamdN4dRCn1gZuAHLqJNy4MoP=qTX+44Bqx1uxSQ@mail.gmail.com/
4. 
https://lore.kernel.org/all/CAEiveUdPhEPAk7Y0ZXjPsD=Vb5hn453CHzS9aG-tkyRa8bf_eg@mail.gmail.com/#t

> 
> So it has my NACK.
> 
> Eric

