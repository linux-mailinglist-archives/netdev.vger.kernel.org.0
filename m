Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25DA2554F26
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359402AbiFVP0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358515AbiFVP02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:26:28 -0400
Received: from sonic316-26.consmr.mail.ne1.yahoo.com (sonic316-26.consmr.mail.ne1.yahoo.com [66.163.187.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D7B3983F
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1655911587; bh=/6ibs5PwJZWhrNJzoAj7ZlgjTRVeUhaKc2p+U/9eA50=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=KlvMMewNeQxnqnpY6O2qxdw2+wa5nya2Z1goQnzPIeG8RuW0nKlaRdq0K7GSTF3HG4vBXkhuvAYAbQz2NS7jDRUz2WsKD6oLVNfYHzUx2YNZRVMIZHcWXe1iWCQLhZ+VVrQBKGrL4SRPgcKWVgprkrxUjEdv/3uRYowjxAGLxF9P+ydrY+CDqsSgPp5mrLLKcp5ODi3XfsAj75j37uSQvLNf2upsQduNnRwdpW6eezwTBHnkR1fI4JFXgJ5kLKgXETH3RdHZHn+2ouOPkPZ1Vkcwy42rFs2lZgLr8icglIDFWoluRXbEW2Tc60lFOqOIOEu1wKf+Zh79mpO88Odrpw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1655911587; bh=o2HQ7ByRckABKGBAtlTp0o2B/g2Otr+E6MPfeaBX8yM=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=jEHHjc5KVLo26SDxntXnoRSx3Nh4QjeHc81elQSCNKsJaSesSgc1JdIY5lRP0II6yzm/sdyclBiLB9V26eqFXdZZEdk2vQjCeHJUOOxPz81NBIKJ8qv2hoNlVRwskIiOS39lM8HoBWl9VgbGdtQ+5s/PILXxvcSgvr4mzu9kyBvR2RlR0xOkfghFoS0qIPAJFYkBuMr73n/4ilLFiN4iGhRJuAXtllW49tk22yxgVSmYkk60b5fbQ4mw6+cvqp3B1rb71poDe9Wk1ozYzu62VJx1vKA610X01UHUX18GOkuk1782U3REnFXbapAyonh5+3ZBxn+wLEFDdYsvaVFWvw==
X-YMail-OSG: YeY3loMVM1lwNk2HSo55a7qZ8D4laXwPr5P7cqM9x7Iq34QIZCwCMGXvfd4TRRC
 DGXmQmF1zUNQRsi26pXIMYZ26Sev1PpC9JQu.mxo.huycJPzcmUWT8wEZjGPg9DSQpValwUKDBW6
 tws8s3njeG9XHA7eexoaLN6YLuED9qIs4xqm3qch57dm4wfIIYkxmGICYao3EZkwWC0GIbmCLze8
 Avz0DGsosO4UCXe0K26PES6bV.AIoKIeus0OlHBX6EUnGKQBDpC_BeaNrTCNH22zk1ly_Z1mFwwn
 _GRYfYuVXMjKBHpKbJUwjChPyUcZ6S0l69GS7M7qmbOszA0NdXhSGgaTRpGBxaWnGVcm800X2C86
 s6YK5sbxcQ2PVvOv1Q3SchEsDarjIsJOC2dZ3fV_9qGyad4x6zDoVidMEmqh1reCfnpFECTE3WUe
 Nddf9Gy81JNNzJOVhpnBpSTSlbnCEWQIWal3KZmyKxcpxv.Y8gG5LFelDmp.yc.CTNowuyAjEHhS
 I0Vg2Gq0afItvLDz.51zoxZgZUaZZDKSbxtjvS06gzRp7L03qpTpqPzHe4tIS_q9Iyx3nl9M3IoQ
 xmr3YYKxH3ogFdEKIcb4ZJ0QaHj_oJt06StgZ4Jo2EmxJPpgucHydjzVfnUC.FDE.IiJnjs14Oma
 XcLkeyuHfB0p1etlIO_4d_5YniNvCKxGvKk.3.A0ZCswNN8baHuyr9u7Izo7XTGv5T0ZV8SgOMxL
 cwiXn8McT2W9woHnqeoVDRxIEOe52DW0UEO4VbB0jP._jnn6lBszTndyxE_ahfkMMI5U4sZAB5F2
 _fzLUI7NdGN536qZHD6O86D2RyJJdk.7xeUw3_.WaHZNWqgrxAP60j941w2op_acLFJbbHShqgDN
 xkN0pJ1ZpD_7vOMeocDBwTtFPtCWKwOTnNRDjv9Dp1yX56f2RJ_VBSjadEAuWgRj4Fxg1GUemUVB
 VZ8ZehvJ59JY7Mka.83kFzKM0VKz7sD_IwwYqh_pAxytXi9UIL8SNNMbsvqg0_MAXOqaMKxSbh.k
 W_cXVqH_wQ4DQ7q_dlPezFB1xr46k3sX2QgIOl.69uPOQmzENZKtT6kXmfT_i9fjVs6zlyE2KR5F
 8X0B03M5PrFTRm0P_Lc3EqhtWrWhkNbavPKxMFDC6OSvQFm7KCcgJaMqXPF59xQNmLAmV6gsJ7Pr
 xOph9KZpUH6N0fjq8uSs30uHLmicAu.z4jUBtx44stYA4jUhEZSYXDH6JRExbQmmeccBIQ9JYA_x
 1U02hdSjE9Dcbch4QbOBkVyEnjV_nQNnk4_tZSITrxh2C3maNwSwYJ.NL5duuTCzhz8M30dpPnM2
 NLCyVyrqPnosjY5tvMveKhEn.lyPfWdR1BK3XZMGekaRBVevv2_2zv1VGkE51Ph2mc.ODlmivUtd
 lvbFKphrrlX5f2NK.7frSbU6NjUSnPAqw5kStv05yfRJi4v3gc6MLx0UJvMk0T1qbQIgu3oJZ93l
 7_BdkTYY.mD3I7LFD9C2xhg6I_iL3pvmqZbcfBxnV0021_3OxcU9HL_qeLtYHhyrr1gEInWYDXyP
 3KGjfRjqPUOXubVk_Bd6z5Dd0YI5KLHP_69BuonL7c7_VORE_Hf4D1wQus2Y6V9s7lLzAF6V2e4E
 e8YWVvLvvQcSNQj6JNsq.CRAwrTCNLfQp8glOJ7BDpbwcps1VbkKipEVAGYe3EAi0TEaDx7T3C.I
 F0PtiK2IA8lCvHS9PhKOt7MfcR6HaaW0vMt5fseKJQRbyzvoGw2npBYIgb6WwjeOuSH6I3tGCIHM
 gPKcq46kuJ0MnuD.cEJ2AVUf73a2hcc6.nNWmzyHYO23eLxCr28IyFMyHICRsvhsspeJCM_bOjeW
 1AQnJEpAOD7iHbhTtQyzo.b9ppgnwbukpztYN2s.vKv2DEeaGrM8.7GY73CVVAzNO1oZBLZhp27N
 XEW4j4L4wS8P.mVmFiuzpf3687pX_5h9NFWOvRmOlOqH1HE2qQPLA3YhE1pSxWXok1U7pvnDPlXx
 Oz4Gmauds9h0cxvJJukRSSVa_0ahAPqJgggHun1jLpjyphHG0WzJ.2F2I_XI9vi75NvRfIRQ5W0_
 XbZCbODc6aY5htAzOQdN3kOlelauvZeKH8ESvGAFpSBz_VM9Jdvp8AbTiakivUAJrmM_IqdTVLSA
 9aWx4u0Xm26h8Bc99rVYAE3hfYdM9ef7fU6.M9CMsB9Uu8JX8L6hoPTSgeYIJqYvP89BIqcOCpDp
 euN9muZT93bHC3ASznamM_DGRxRLRpgkCyQEyE.Pw1IHm0YobXAgwd8A-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Wed, 22 Jun 2022 15:26:27 +0000
Received: by hermes--canary-production-bf1-8bb76d6cf-spklk (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID e5e8de9273842f754433b90629d03f6d;
          Wed, 22 Jun 2022 15:26:22 +0000 (UTC)
Message-ID: <4b62f0c5-9f3c-e0bc-d836-1b7cdea429da@schaufler-ca.com>
Date:   Wed, 22 Jun 2022 08:26:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
Content-Language: en-US
To:     Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc:     brauner@kernel.org, paul@paul-moore.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@cloudflare.com,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20220621233939.993579-1-fred@cloudflare.com>
 <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
 <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <b72c889a-4a50-3330-baae-3bbf065e7187@cloudflare.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.20280 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/2022 7:24 AM, Frederick Lawler wrote:
> Hi Casey,
>
> On 6/21/22 7:19 PM, Casey Schaufler wrote:
>> On 6/21/2022 4:39 PM, Frederick Lawler wrote:
>>> While creating a LSM BPF MAC policy to block user namespace creation, we
>>> used the LSM cred_prepare hook because that is the closest hook to prevent
>>> a call to create_user_ns().
>>>
>>> The calls look something like this:
>>>
>>>      cred = prepare_creds()
>>>          security_prepare_creds()
>>>              call_int_hook(cred_prepare, ...
>>>      if (cred)
>>>          create_user_ns(cred)
>>>
>>> We noticed that error codes were not propagated from this hook and
>>> introduced a patch [1] to propagate those errors.
>>>
>>> The discussion notes that security_prepare_creds()
>>> is not appropriate for MAC policies, and instead the hook is
>>> meant for LSM authors to prepare credentials for mutation. [2]
>>>
>>> Ultimately, we concluded that a better course of action is to introduce
>>> a new security hook for LSM authors. [3]
>>>
>>> This patch set first introduces a new security_create_user_ns() function
>>> and create_user_ns LSM hook, then marks the hook as sleepable in BPF.
>>
>> Why restrict this hook to user namespaces? It seems that an LSM that
>> chooses to preform controls on user namespaces may want to do so for
>> network namespaces as well.
> IIRC, CLONE_NEWUSER is the only namespace flag that does not require CAP_SYS_ADMIN.

LSM hooks are (or should be) orthogonal to capabilities, except for
where they are required to implement capabilities.

> There is a security use case to prevent this namespace from being created within an unprivileged environment.

Yes, which is why some people argued against allowing unprivileged creation of
user namespaces.

> I'm not opposed to a more generic hook, but I don't currently have a use case to block any others. We can also say the same is true for the other namespaces: add this generic security function to these too.

If the only reason to have the hook is to disallow unprivileged user namespaces
it's probably time to revise the decision to always allow them. Make it a build
or runtime option. That would address the issue more directly than creating a
security module.

>
> I'm curious what others think about this too.
>
>
>> Also, the hook seems backwards. You should
>> decide if the creation of the namespace is allowed before you create it.
>> Passing the new namespace to a function that checks to see creating a
>> namespace is allowed doesn't make a lot off sense.
>>
>
> I think having more context to a security hook is a good thing. I believe you brought up in the previous discussions that you'd like to use this hook for xattr purposes. Doesn't that require a namespace?

I'm not saying the information isn't required. But if you create a new namespace
and then decide the user isn't allowed to create a namespace you have to tear it
down. That's ugly. Better to pass the creation parameters to the hook before
creating the namespace.

The relationship between xattrs and namespaces is it's own can of worms.

>
>>>
>>> Links:
>>> 1. https://lore.kernel.org/all/20220608150942.776446-1-fred@cloudflare.com/
>>> 2. https://lore.kernel.org/all/87y1xzyhub.fsf@email.froward.int.ebiederm.org/
>>> 3. https://lore.kernel.org/all/9fe9cd9f-1ded-a179-8ded-5fde8960a586@cloudflare.com/
>>>
>>> Frederick Lawler (2):
>>>    security, lsm: Introduce security_create_user_ns()
>>>    bpf-lsm: Make bpf_lsm_create_user_ns() sleepable
>>>
>>>   include/linux/lsm_hook_defs.h | 2 ++
>>>   include/linux/lsm_hooks.h     | 5 +++++
>>>   include/linux/security.h      | 8 ++++++++
>>>   kernel/bpf/bpf_lsm.c          | 1 +
>>>   kernel/user_namespace.c       | 5 +++++
>>>   security/security.c           | 6 ++++++
>>>   6 files changed, 27 insertions(+)
>>>
>>> -- 
>>> 2.30.2
>>>
>
