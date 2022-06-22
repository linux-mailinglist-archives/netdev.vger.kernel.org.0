Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0B67554F22
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 17:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359346AbiFVP01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 11:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358064AbiFVP00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 11:26:26 -0400
Received: from sonic304-27.consmr.mail.ne1.yahoo.com (sonic304-27.consmr.mail.ne1.yahoo.com [66.163.191.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D322F39165
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 08:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1655911584; bh=/6ibs5PwJZWhrNJzoAj7ZlgjTRVeUhaKc2p+U/9eA50=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=q82cYSZhdunnuj+1tUnWR5wq85n4VvRZ4fbc31MBFTgFfZR0p9sRGEmXBMeq3Xr0A5nVBYU5rL3vL88jJP/yM379fvrRvkZPusk2QPOKwIy6ocJrkJ8KB01lM1AWlCcdxhhFKmScrNj4k/uSBFbCxI0cvktKoVWCU7b6i80GPkKIi/cqw/SfCdL1O73MIiuzkaX1uVDGpzvIe/6EOIi4yCmxEFqPTDEInwBva6DAmRHD3f+QS/hhVjUwa0Msp9UdbGc1JUIZ3GAmXiiWJp8cTWbJ7/TaOG+cPEA/Jbc9dq1PjS/1JApJAhw2ToEuz2q3Z0J5WJlQLoMkSCkOIGFi/g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1655911584; bh=e6DxFG7+k/i/dNY58coXNyDcCd8r23yFxD+UjgWG/Ks=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=bn/XJ0/xvyRcntGwWdvzl5MUwIOEqflVVINXN0qAO2OgfVRYgTyCn7pWzdNZA+Vb0XXSQ8T7WdS9Udf1Z70PB3x+zW4nswTmF4yi6p/SI9gUAHl9T1FVX9ZP6JLDjGXb/1vrTLh5mb+KDRN/lU/RnVBaCdm502p4euEa17JsNlZLZa+ChdP9tzFUa2sIDePpZ6fd+KJz1eCYTTVhz64cv2ZRSDnSWZQ+HtT8epdxIVPUFK3uA1P8PENAEi9tlr1B4mz8/P6b71rqAoQPtPuUQEracUKmCcaVr5pURmyggYtd94IeOQJpCWgNVpOv7FjAN5p8e/aq8Sib29xbuJbscQ==
X-YMail-OSG: 497agoMVM1mtrf5WnhiRDfBPO9MBmxiA2EwFlJKXjaJbRAyVjaKBzBdDJr631vI
 mbQvWRt2uL0iMHg220TUChMDXftFh3JWnmJwCiA4e82H3rQjYy8rxNxfCxdEHEdN0hB4Ocy.brXA
 HUaQT6pQb7Sfo62prhO3CymrrLsrc1wulNOPFG5OEW5fBlUs.MxUYGK97w_HSXSw95P9v6sjAXhM
 xR5HxzKG3VhMgj3qz2bcRsl4g7CdSsO..zvym6Qb37dpFLLxNObPLDDmk_h2MGaTR6l0Njuj2zdy
 fscPTs9qPeHPdrCaP.H5vGKtIwRQh2E9gDvLTaWUJ1IVibdkbV_1BPZI4qfA8LGfSnOeyTtjMdko
 O6DXsJpT.O94cRq8qp_TfZUXD8.k.aI42jg1ixsQ5FrLykWEp3KyoUmQjFyHfyvbg6742R5Yii2r
 wSCLgp6xCRj7Abh42G3pTVqyWia9s2frmB_MePMXLMjJOkmJGGJA.sOAp7aI2EOwxiNKHZcsQQa0
 .FkU8r0EjQw2o73J7J9dk4BOF1f.f5E3OBxXZszCxH8U5.rrfwqAJhbB5WF2qyoq61Hbd_pTTP2I
 EMX3nKpuQpDQuSc6P1lON7KFmS4u4YQFcP4Cw_TB8ogdLMg3oYgQz9rYD7aG5ZP5uE3_4qF6qeA6
 4T.FAElfm6VbKsfIkzjIl8Lchz7sNASaG1Mx47BikeDSa3fqmpl_kqp5KAC7xUDx6c8vneIVToPU
 Ir5FET6UBf5UdSf3EgMXamiuSKsfoKEMPeJz_MRbpGmActrhveBa45GP12KUSdmncu8tSSzE1r2H
 _vT4gkIC9sKFz4tzUjg02duy8JsC1LPxKyS2HrfHAyNAZNlYk9O6kRX1Doad2sAAO1s6id6znHYo
 fbkcheOST_v9TWg6_qdjf2G2OkUA81uv91PsJwXgXuOBdlN7MzJUOSBfZHoUcU9sftaBNrMBoPP0
 cEOFOZEbq.X4XC9RDMUWdDcxBeYLQZ3qsRFym1A61F2w5dwuBN8ViDh5hkNL7._rjtfdYyegY0Vu
 snuc8Au4N8yicgcpeflLdbHb_OoGGO7RIJtJq2yJZdCZAx4VBZDwrva0g8O2uHv5RMYmnBFaiZxn
 __v6xazDrljEz2PxIELVlgiPHtMyWrPazix0psxCZs.BQI3h_5uFhY7Idex_k0CNPg246F134ON5
 fEs.RL3FKyszJ9OsO.yVWqWDED9KLh_6Z7lDZdAlGWiZ7G13_5tcVSGd.9MW5uph0hPDsfUO7amQ
 omKMP96cG8SffXgZyxHzi9tlVhyZ171uZj1xtT7pQF6iUd9H4c8_Z_lqAA0fyD2wdulkxvDVjPyM
 6mo7uk8NHFSN6DbBBY1XdzyNXua_v6nnHTS4Zv.MOqNjwesaFyva5YfLysAhM5MORz3PYO_VVZsW
 nkslL_GZuoTfAfVe_qB3moFK6bzya4tgdL1rSowLzMJDT2V3CUGNa6NgeOG5HcnEt2Ar6k5mnTHH
 oKn2kCYM2l5gfcu3V3HsTJfd3WSSizKRDqiEVSsg9vUfpjwAk5JKF3zmOQN86nmavxngw1uYeWQt
 FTPZnPqJa4Bd4thFW0tpUBoDZ7LheZKVQ3kZ8RoawGkwoJovR2wlZ_WC6xltaAaeOZ9ucwMeNQ8j
 WUgHpiKrhfc6e_SIohdxiiRe0slNLVaWqo0eX8YYfl6Iy0NhaVDDVegLFjuPh52Qh9tH3ze_Ih1F
 sFsOsAeg4yhp8U3wxY8ZrIEJq5.uQFez3OuWK5JeMTSHZW4VNpFOVEM_UtJxH6DAVA_elVcq1NlT
 4NHiY5Y5cYFt6dV.y8pJaGgYuO5ucTfAnA9Z6WaM2CYwzfaNirjcswrYwtWNfhqciJXIzFxycaLb
 vWIHwUYZ7RhFCx1yh4vokWP81uruUsAlGckmKlyFlbmmfvnCqQBT.DtXw2fhrlTTqWjhCAEVPsKW
 c2vJva2oyJt5xPU6qTw.FHgKRKXbklCkEn2Au2VxqPmcOYZgam8envLr.1MFBwBv8PJTqqh8n6K_
 3gqmmSnoHktuX.hqgJL6ZWxLS2hK66n0zUaQJzAtSXZWXCPNXTmvPxtybLa66RnWjH4Ye1Yq0JPE
 4UEa1bnNEH2Ji0cNAbo3a47bYQRM_bFO2I5SW4D0QA00mFW3nOEHz6qO.7vQny0aJkzsfMWGPw18
 Uv8Sp_KHw3DX00e7k5PVNAJEZQBPKx80Ehi9srADp3kMT_SX2PTaNxChEQm.5h5EvY7Cye1v.HKO
 FzwuSno3jdKItZ5rX3XwT3gDacRQBnne02Vphz3fhKQ8MbmN92K6vovkq.ciJofbr6cW7IrSOgPk
 h79lPjhA-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Wed, 22 Jun 2022 15:26:24 +0000
Received: by hermes--canary-production-bf1-8bb76d6cf-xkxwt (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 07c0242e81d2b6dbf8b87d1c4f1a4e22;
          Wed, 22 Jun 2022 15:26:22 +0000 (UTC)
Message-ID: <cc755f63-806a-b385-e3e5-8c1e9a9ee875@schaufler-ca.com>
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
