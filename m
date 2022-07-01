Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605245629D4
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 05:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbiGADrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 23:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234353AbiGADrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 23:47:09 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A65FF5A
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 20:47:08 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id be10so1952698oib.7
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 20:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JkA08FeJ1HPIWUMmPcxvLgd72joY5bgojRJIZwDeTG8=;
        b=JytORWl21Ha4yQ9vdhNmxGpP8g/xHKB5SStKIhVBRYA/JTy2bIfHNl969VPp9j28pR
         lLrkOeU+ACPpdO00smm8p7vCJYGVC/tFIHcB1mWLeG9UH1fjUlUl37YDkRc27ER0iHQF
         XeIt1h0agCslGSinWj5+pTOCmbQ8N6FdHgkmM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JkA08FeJ1HPIWUMmPcxvLgd72joY5bgojRJIZwDeTG8=;
        b=b4Oy+n0uL1tPt6SbYBDHN8+dvDoGl3WxSCM8YjdPSJ6cn3W0KzSorns6/McV+Rcr2l
         SVSmUXMg0thFlSQZsU03R64ADuKmH7H0352VzU4aXPL8Z5t/qfPAi2pgOsqJeAtGaI+F
         BSVsGbdm8qBJp1ZpanugB1vyDiPg3mpJX9EDobk9knM33Ea0WvkGd2kuCXdja2Bt9bBA
         MA79PfzZ9NA1H8biPFlP4ajChwUHlriHI2nQifXPiODOKMiIIbyRaAFAvQl1KTlWvApX
         1L3bTe6lhl3CgC4zLU/hoRJH4LaMbG9F0ptpf7PwSrXHQc5A8DoKP0hFWGwMtNAMCVge
         Is3A==
X-Gm-Message-State: AJIora9B5aZXxaknYUZ4ojl+Z1Clb1xKVvGFRd/cOtU8qFyrk1MFtaqU
        cL3LBjsn4s8gSbvRinHJS7qaBw==
X-Google-Smtp-Source: AGRyM1ttKCiWIzqJTEca/XZV2t3Mb0HUtTNHINW3dPLSGBTo8+e387vz+HM5miYJDcvhpRheVLai3A==
X-Received: by 2002:a05:6808:1295:b0:335:ab74:6d33 with SMTP id a21-20020a056808129500b00335ab746d33mr7173916oiw.229.1656647227463;
        Thu, 30 Jun 2022 20:47:07 -0700 (PDT)
Received: from [192.168.0.41] ([184.4.90.121])
        by smtp.gmail.com with ESMTPSA id r16-20020a056830237000b006168bc4caacsm12205744oth.67.2022.06.30.20.47.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jun 2022 20:47:07 -0700 (PDT)
Message-ID: <01368386-521f-230b-1d49-de19377c27d1@cloudflare.com>
Date:   Thu, 30 Jun 2022 22:47:05 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
Content-Language: en-US
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Casey Schaufler <casey@schaufler-ca.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, brauner@kernel.org,
        paul@paul-moore.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@cloudflare.com
References: <20220621233939.993579-1-fred@cloudflare.com>
 <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
 <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com>
 <87v8singyt.fsf@email.froward.int.ebiederm.org>
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <87v8singyt.fsf@email.froward.int.ebiederm.org>
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

On 6/30/22 1:28 PM, Eric W. Biederman wrote:
> Frederick Lawler <fred@cloudflare.com> writes:
> 
>> Hi Casey,
>>
>> On 6/21/22 7:19 PM, Casey Schaufler wrote:
>>> On 6/21/2022 4:39 PM, Frederick Lawler wrote:
>>>> While creating a LSM BPF MAC policy to block user namespace creation, we
>>>> used the LSM cred_prepare hook because that is the closest hook to prevent
>>>> a call to create_user_ns().
>>>>
>>>> The calls look something like this:
>>>>
>>>>       cred = prepare_creds()
>>>>           security_prepare_creds()
>>>>               call_int_hook(cred_prepare, ...
>>>>       if (cred)
>>>>           create_user_ns(cred)
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
>>>> and create_user_ns LSM hook, then marks the hook as sleepable in BPF.
>>> Why restrict this hook to user namespaces? It seems that an LSM that
>>> chooses to preform controls on user namespaces may want to do so for
>>> network namespaces as well.
>> IIRC, CLONE_NEWUSER is the only namespace flag that does not require
>> CAP_SYS_ADMIN. There is a security use case to prevent this namespace
>> from being created within an unprivileged environment. I'm not opposed to a more
>> generic hook, but I don't currently have a use case to block any others. We can
>> also say the same is true for the other namespaces: add this generic security
>> function to these too.
> 
> There is also a very strong security use case for not putting security
> checks in the creation of the user namespace.
> 
> In particular there are all kinds of kernel features that are useful for
> building sandboxes namespaces, chroot, etc, that previous to user
> namespaces were not possible to make available to unprivileged users
> because they could confuse suid-root executables.  With user namespaces
> the concern about confusing suid-root executable goes away.
> 
> The only justification I have ever heard for restricting the user
> namespace is because it indirectly allows for greater kernel attack
> surface.
> 
> Do you have a case for restricting the user namespace other than the
> kernel is buggy and the user namespace makes the kernel bugs easier
> to access?

No.

> 
> How does increasing the attack surface of the kernel make the situation
> that the kernel is buggy and the attack surface is too big better?
> 

We agree that completely blocking this feature may disable effective 
sandboxing techniques, but uncontrolled user namespace creation 
increases the attack surface as well. There are known examples where 
creating a new namespace is the first step in a priv escalation attack.

> Perhaps it is explained somewhere down-thread and I just have not caught
> up yet, but so far I have not see a description of why it makes sense
> for a security module to restrict the kernel here.
> 

Having a new security hook allows us to decide when unpriv user 
namespace creation is acceptable and unacceptable. Patching 
vulnerabilities takes time and effort amongst the community. We want to 
protect our systems so that we are not as impacted by the next 0-day 
disclosure. This in turn decreases our overall attack surface.

Security hooks are a good fit because they offer us flexibility to 
protect our systems how we see fit.

> Eric
> 
> p.s.  I am little disappointed that I was not copied on this thread
> given that it is my code you are messing with, and I was in an earlier
> version of this thread.

