Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4DF55EA3F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233166AbiF1Quu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237535AbiF1Qrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:47:45 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465B7286E5
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:44:50 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1013ecaf7e0so17747640fac.13
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:reply-to:from:in-reply-to:content-transfer-encoding;
        bh=vJfBn+f7lVK7AifdRhZ14mIHvBk5ROqtbtEkpEUekVI=;
        b=PStwN8J9WglnPwSrV0dM3AVahzXE6kSqMbbkzaOjiLnRigpJdtZbsznzA6h0ZHFxCl
         VCc2EwXkgQTpc2I8msSXawKjWhovEq4qPlEq9FHqwcAnhsRf38LfjGSr2OksXXnBDVe5
         D2AXYVst8rALAmrORJawmosR19EMmGOJojF8g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:reply-to:from:in-reply-to
         :content-transfer-encoding;
        bh=vJfBn+f7lVK7AifdRhZ14mIHvBk5ROqtbtEkpEUekVI=;
        b=BvJcKUTsYo0YwCyScyFlQ565zQDlEDjI0h/9L35SlWeBA1i9nzPJH4Aojq2RyXbOCb
         TWUMcyB1z/i0ekBCP7hd7+aSP5EfKC3ykDxD1Pqj8NHyR2TdqUVESYljdd9fyuuTYH6t
         zKmpBPN7sPUs2+yR2yI8CMw52v9GYJaiIb81qP8P+oSV2yzEtc7kpMx5lCbs8PD3NSX/
         Yw/rNmcScrNn8yaz28WSYl98yEU9bkonQ4P8x3ew3F2cSbyOxIbdtU/FX72MrCH9gZp5
         1u48yuhGCH+FvqSAEfewSd8u2G93efdY6HWbg4aJHYonC5o2zrrM5Ki5EPtRlII/aIqs
         I7jw==
X-Gm-Message-State: AJIora9l7pe2XmgYX/jLaQsaDuMoMSwHFVJn9Ogi7Ha0omzaN5EXX6hM
        Vhj31OUyMjx9aPkx5sLFzCdaTg==
X-Google-Smtp-Source: AGRyM1uH8/M2iGX2n2wOrXwL+tXc5HmSsj392p52tR/beA2RwQ1QmjHwdDlm5rbSnYFM5umdpppZNA==
X-Received: by 2002:a05:6870:649e:b0:ed:a1c0:f810 with SMTP id cz30-20020a056870649e00b000eda1c0f810mr285467oab.289.1656434689573;
        Tue, 28 Jun 2022 09:44:49 -0700 (PDT)
Received: from [192.168.0.41] ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id y27-20020a544d9b000000b0032b99637366sm4400950oix.25.2022.06.28.09.44.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 09:44:49 -0700 (PDT)
Message-ID: <83b9774f-5cda-d05f-e62d-7bf7547ae7ba@cloudflare.com>
Date:   Tue, 28 Jun 2022 11:44:47 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
Content-Language: en-US
To:     KP Singh <kpsingh@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Christian Brauner <brauner@kernel.org>, revest@chromium.org,
        jackmanb@chromium.org, ast@kernel.org, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@cloudflare.com
References: <20220621233939.993579-1-fred@cloudflare.com>
 <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
 <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com>
 <CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com>
 <20220627121137.cnmctlxxtcgzwrws@wittgenstein>
 <CAHC9VhSQH9tE-NgU6Q-GLqSy7R6FVjSbp4Tc4gVTbjZCqAWy5Q@mail.gmail.com>
 <6a8fba0a-c9c9-61ba-793a-c2e0c2924f88@iogearbox.net>
 <CAHC9VhQQJH95jTWMOGDB4deS=whSfnaF_e73zoabOOeHJMv+0Q@mail.gmail.com>
 <685096bb-af0a-08c0-491a-e176ac009e85@schaufler-ca.com>
 <9ae473c4-cd42-bb45-bce2-8aa2e4784a43@cloudflare.com>
 <d70d3b2d-6c3f-b1fc-f40c-f5ec01a627c0@schaufler-ca.com>
 <CACYkzJ6GmotfhBk1+9BjGC6Ct7bGxQGVTZTX2iQcrhjfV7VHwQ@mail.gmail.com>
Reply-To: CACYkzJ6GmotfhBk1+9BjGC6Ct7bGxQGVTZTX2iQcrhjfV7VHwQ@mail.gmail.com
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <CACYkzJ6GmotfhBk1+9BjGC6Ct7bGxQGVTZTX2iQcrhjfV7VHwQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/28/22 11:12 AM, KP Singh wrote:
> On Tue, Jun 28, 2022 at 6:02 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>>
>> On 6/28/2022 8:14 AM, Frederick Lawler wrote:
>>> On 6/27/22 6:18 PM, Casey Schaufler wrote:
>>>> On 6/27/2022 3:27 PM, Paul Moore wrote:
>>>>> On Mon, Jun 27, 2022 at 6:15 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>>>>> On 6/27/22 11:56 PM, Paul Moore wrote:
>>>>>>> On Mon, Jun 27, 2022 at 8:11 AM Christian Brauner <brauner@kernel.org> wrote:
>>>>>>>> On Thu, Jun 23, 2022 at 11:21:37PM -0400, Paul Moore wrote:
>>>>>>> ...
>>>>>>>
>>>>>>>>> This is one of the reasons why I usually like to see at least one LSM
>>>>>>>>> implementation to go along with every new/modified hook.  The
>>>>>>>>> implementation forces you to think about what information is necessary
>>>>>>>>> to perform a basic access control decision; sometimes it isn't always
>>>>>>>>> obvious until you have to write the access control :)
>>>>>>>> I spoke to Frederick at length during LSS and as I've been given to
>>>>>>>> understand there's a eBPF program that would immediately use this new
>>>>>>>> hook. Now I don't want to get into the whole "Is the eBPF LSM hook
>>>>>>>> infrastructure an LSM" but I think we can let this count as a legitimate
>>>>>>>> first user of this hook/code.
>>>>>>> Yes, for the most part I don't really worry about the "is a BPF LSM a
>>>>>>> LSM?" question, it's generally not important for most discussions.
>>>>>>> However, there is an issue unique to the BPF LSMs which I think is
>>>>>>> relevant here: there is no hook implementation code living under
>>>>>>> security/.  While I talked about a hook implementation being helpful
>>>>>>> to verify the hook prototype, it is also helpful in providing an
>>>>>>> in-tree example for other LSMs; unfortunately we don't get that same
>>>>>>> example value when the initial hook implementation is a BPF LSM.
>>>>>> I would argue that such a patch series must come together with a BPF
>>>>>> selftest which then i) contains an in-tree usage example, ii) adds BPF
>>>>>> CI test coverage. Shipping with a BPF selftest at least would be the
>>>>>> usual expectation.
>>>>> I'm not going to disagree with that, I generally require matching
>>>>> tests for new SELinux kernel code, but I was careful to mention code
>>>>> under 'security/' and not necessarily just a test implementation :)  I
>>>>> don't want to get into a big discussion about it, but I think having a
>>>>> working implementation somewhere under 'security/' is more
>>>>> discoverable for most LSM folks.
>>>>
>>>> I agree. It would be unfortunate if we added a hook explicitly for eBPF
>>>> only to discover that the proposed user needs something different. The
>>>> LSM community should have a chance to review the code before committing
>>>> to all the maintenance required in supporting it.
>>>>
>>>> Is there a reference on how to write an eBPF security module?
>>>
>>> There's a documentation page that briefly touches on a BPF LSM implementation [1].
>>
>> That's a brief touch, alright. I'll grant that the LSM interface isn't
>> especially well documented for C developers, but we have done tutorials
>> and have multiple examples. I worry that without an in-tree example for
>> eBPF we might well be setting developers up for spectacular failure.
>>
> 
> Casey, Daniel and I are recommending an in-tree example, it will be
> in BPF selftests and we will CC you on the reviews.
> 
> Frederick, is that okay with you?

Yep.

> 
>>>
>>>> There should be something out there warning the eBPF programmer of the
>>>> implications of providing a secid_to_secctx hook for starters.
>>>>
>>>
>>> Links:
>>> 1. https://docs.kernel.org/bpf/prog_lsm.html?highlight=bpf+lsm#
>>>

