Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3747656BF8C
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238674AbiGHQL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 12:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238449AbiGHQLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 12:11:24 -0400
Received: from sonic301-38.consmr.mail.ne1.yahoo.com (sonic301-38.consmr.mail.ne1.yahoo.com [66.163.184.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818847697B
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 09:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657296680; bh=d3szPQdw5PU82djtwqik1CLYc98SgVpLE9KkrFdMseg=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=HlJ2bMARaUNCp3N36jhFM5ltkxGIpgQP4PKUo4uilwA2NpAbJ4hovt+CkVsZrAZAPFaxGT3zuhFCfBpuH3X9Rp8Oo3S9WQkOZQpFCv0Ay491OPIRvUt7CJSDjJ74rZ07v0ukEBQVMQn9z/BRNOoW9f+NtP8ycHI0bC7jRRVO/lbclqkBFF6mOoPJ17XVXm40Yqjasv70PaSZ+vBAnZCNy8QVPIWpamFIOwI1+8fX0fRAZSvzjtQbxRepko8nrbiJMfp5nncZqPassH23aBNW0XXlGt7op2a7LNHAj3C8Ljvss8IIlwjNoV8/A9bCINxnxZcB/Cv8EBM/YnCrlchUfw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1657296680; bh=AbFJt0Oieo/Py+ErmmtY2lRKz7uULoJDjAXA/Bipvz7=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=JZeIWVP6/qKKLOMFyJ01/+nZru+86+vsnnMTGk5ztxfFpEyOXvxUqjVNYR0lackNBILwIMUqHVABaccL/rjKQ6KNj61KjezaEX/MB6Uw0SozDFJexoekBcq2RjOnXYPOLy8fysPsfEIP6MQ5AjOvouk5XyGDKdWONQHHb0VTNDyoiEG970iAf85fq0hMRZPojVU2KYelOET6YQ+JMHboObc4EMbLlGT5beYErAdh+KOzN/WNeGBwtzkAXDc4P1AbAHIjGn2C0BWFtZwUtgwZ28EYEt7x0szQQDt5172w79gx+0sFHAxc73CdpVk8oondIPDVPsHpYYj1zVMQT2WHqA==
X-YMail-OSG: PgiMNgoVM1m5GnAyscEVZuUhhX2NnOVBFNf0MEuvNsyYkbXv0CbYM381tfaKwQa
 jww5tekFjrI3L2OGD5m2SVzGNmosj49iPUAiCXdHgJDnnwme.B46moyM1Aue8wogdejGHvp87vBE
 BCx1gWEd1m52T155jAtHSPHm9Y.4_kJEACyX0SZtFKfEyZO_6h02b41enWYm6EkabhtvYcyaMAVn
 iPXYXd2fMTC1W0Vy2mMJrJ1uA5Q7dhJlD0Fkl50HEBNbe88aKntoTDhDYdjLvc8Rv0xiE8yDYoDU
 YNCruH9PFDsSMD0Vs15euAqs802WvMJJ_5_baBoHbgrkbByBsp7IoM6ZwuUxsuXXrELRbipSz5Of
 I0sYq6U0Cjgw6wwZAWuJoNirnlopJVOYTq1KiVpsyjfA4qdxXsYD7Mra.pTUjwBXwOdM5Dr31ipP
 5iT2punKTHKPKA3ABf66nauqenzsp71pnF.XK0bru20A9RgngoAMMI.5mhDztiL_tjVJXU6LRX6t
 hc8fZNjXFfPQGfh0cJqZOoGQU9ycmP2PEg5YXmRLFP00Ztxw9lvJhG45PugBVmgk5_i.mb9ei5WJ
 V3Y0vB0HHsfe16E3WoaGLTuHuFtM9_O_8RTKDUpQEJAC9yualTdY9PzrJyNFZiYDo1ab724I8P6z
 72BZmDQy.apetF8aZkjGfidOQwrGj8HjvX8FjQYkzE5KjrYYBLazT0leRbpFmPJ4baOhrzc91n5H
 2qPP456WgJqMUQ1e3HRgW2GgnRG86tGjrMcc84KPM5YeHfFNcFtdMRIVuysn2MgdgDzEPO3Hbz8I
 YcVKOZJ5JqX4yPWuL0dGO3n70Nlx6wO9zmRMYlqnMNSt4UYWFl2Gv92U0vFeuyx1stFOt9EWclTW
 gTxsedO6E.uRq5gYBtinKKMgPNjH4gyBvtRIfLdHkNFQqEDHtaAW92lOeS6hspR_2Ppg5NTn6JQG
 1gDVWY7arw9cGqVUgH1m4mXkFV5S74o5q2ROybt081lw4UDoCyKwBQ6ZBYHTASeGCiV6eVFjSIqh
 6ir2fvpLRBfmVbm_rk060RyVT5uR8.Ex9t3cSe4L_PBvdUggvj2eoTItv30hAC1OzzgWS2BP3iHp
 .VBZf7zgRw.yBzpJbxu_2FcH7DwYhsIwHNAq6uO9saqADVUfdkY7lY1X7raCK_GUo3HxNwsWo0wn
 mfL.De.s6_I2.Dl15x6_vePHXWobSjvsjC2lDlLtZpRN8_zGMMp9qpos2bj_nO_uxStnM0yiqx_H
 zKdtv.8NVxUSv4rmkAKVbio_gFrEjtlTAV6rOzer4a8rfJULzdf3ti6ozMhZb9Vrnzx_8QByjyjM
 eEZmWu3fXiVeDkCzpYrO0IhfjM6_BFdV1UdbDjpbxbdCDqbEN2qFhapnpdPtl_QJqkxVlxVlKl0i
 ENRime5_GOP7CqDyjUYTJbv7mMDoSKf1yVgJSbGo1Xroz7QjqPF1tckeacNZQY31Cvm6Ukprhh5o
 Y8XAGwL23nWFpsx0JOG90yV32_75EhjzSJzEltwlOhZcU6jQxVooi5KyfHTBktDGJarAItZSm_Ps
 LFaND_JP6RzMKvyr92Mu6QGg4rvgQpIhBni1A_oHFWxcDd0LYVjR6dxSwOz2vFj43L73LaFz_oyB
 y1MJChH.Rg1cMtoeUH8Hh0LNBO9aEokr2TpVjgEQApwyY72R9ZtJkxczrIBO9qZujSDiiVk8bOYv
 hBkNrGb8fVhb2cIebob8_c_hSq8gcMDsVP9xbKq9_5idMMYz2QlnycsQCowH5nTTeZ1_7l_Evmzm
 uBln5UfdZ7J.W_7h.pzRaXmNLW9FKWVvVrHcZbHa7BRDWlwdgsYK41s3anfhMJKtsP_LADOcntDx
 5c2Hbhoz5RQsnlnHMOV0FCX__YteTESapESh9zxAKmE1VgDFqNkZxQDSTdWx.eV9SqTZ8Oq5nLwl
 Dg6WrYitmwa8tloc5NWlNBnSzuZ7yqP4s6r5CV1kKSVE_lyFQxbM2TnWhNuf3FKwl4V6spz5iLfS
 FFByOVcAgB0rCZu1WL.S_SzYrOq_qA6iZMOt845u5Ny6ksgVrgUKmI9bk.sMcKpEhuLbkVEBNKNM
 WXaBuAVqZyagyIEyqRS_AJy5Y_4n1DFQjEwYxt02uKGin0jdlFEtkFzadPlQ0p09jBiTzOfKVf0m
 fkEK7uvijniuh60ss49DyajKGS88W9CUTmBJaCEUULc4hWVQn_BfbV9nIc1z168hYHUUiTvlRePT
 ye.E4l0azldfuPOLYnQSEdBlV0j.NPY2eFp.6NO6S
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic301.consmr.mail.ne1.yahoo.com with HTTP; Fri, 8 Jul 2022 16:11:20 +0000
Received: by hermes--production-gq1-56bb98dbc7-8vq2m (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 05ccd01a84644cefb61c7f788262db90;
          Fri, 08 Jul 2022 16:11:17 +0000 (UTC)
Message-ID: <84fbd508-65da-1930-9ed3-f53f16679043@schaufler-ca.com>
Date:   Fri, 8 Jul 2022 09:11:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 0/4] Introduce security_create_user_ns()
Content-Language: en-US
To:     Frederick Lawler <fred@cloudflare.com>,
        =?UTF-8?Q?Christian_G=c3=b6ttsche?= <cgzones@googlemail.com>
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
        "Eric W. Biederman" <ebiederm@xmission.com>, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        SElinux list <selinux@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        casey@schaufler-ca.com
References: <20220707223228.1940249-1-fred@cloudflare.com>
 <CAJ2a_DezgSpc28jvJuU_stT7V7et-gD7qjy409oy=ZFaUxJneg@mail.gmail.com>
 <3dbd5b30-f869-b284-1383-309ca6994557@cloudflare.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <3dbd5b30-f869-b284-1383-309ca6994557@cloudflare.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.20381 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/8/2022 7:01 AM, Frederick Lawler wrote:
> On 7/8/22 7:10 AM, Christian Göttsche wrote:
>> ,On Fri, 8 Jul 2022 at 00:32, Frederick Lawler <fred@cloudflare.com>
>> wrote:
>>>
>>> While creating a LSM BPF MAC policy to block user namespace
>>> creation, we
>>> used the LSM cred_prepare hook because that is the closest hook to
>>> prevent
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
>>> This patch set first introduces a new security_create_user_ns()
>>> function
>>> and create_user_ns LSM hook, then marks the hook as sleepable in BPF.
>>
>> Some thoughts:
>>
>> I.
>>
>> Why not make the hook more generic, e.g. support all other existing
>> and potential future namespaces?
>
> The main issue with a generic hook is that different namespaces have
> different calling contexts. We decided in a previous discussion to
> opt-out of a generic hook for this reason. [1]
>
>> Also I think the naming scheme is <object>_<verb>.
>
> That's a good call out. I was originally hoping to keep the
> security_*() match with the hook name matched with the caller function
> to keep things all aligned. If no one objects to renaming the hook, I
> can rename the hook for v3.
>
>>
>>      LSM_HOOK(int, 0, namespace_create, const struct cred *cred,
>> unsigned int flags)
>>
>> where flags is a bitmap of CLONE flags from include/uapi/linux/sched.h
>> (like CLONE_NEWUSER).
>>
>> II.
>>
>> While adding policing for namespaces maybe also add a new hook for
>> setns(2)
>>
>>      LSM_HOOK(int, 0, namespace_join, const struct cred *subj,  const
>> struct cred *obj, unsigned int flags)
>>
>
> IIUC, setns() will create a new namespace for the other namespaces
> except for user namespace. If we add a security hook for the other
> create_*_ns() functions, then we can catch setns() at that point.
>
>> III.
>>
>> Maybe even attach a security context to namespaces so they can be
>> further governed?

That would likely add confusion to the existing security module namespace
efforts. SELinux, Smack and AppArmor have all developed namespace models.
That, or it could replace the various independent efforts with a single,
unified security module namespace effort. There's more work to that than
adding a context to a namespace. Treating namespaces as objects is almost,
but not quite, solidifying containers as a kernel construct. We know we
can't do that.

>> SELinux example:
>>
>>      type domainA_userns_t;
>>      type_transition domainA_t domainA_t : namespace domainA_userns_t
>> "user";
>>      allow domainA_t domainA_userns_t:namespace create;
>>
>>      # domainB calling setns(2) with domainA as target
>>      allow domainB_t domainA_userns_t:namespace join;

While I'm not an expert on SELinux policy, I'd bet a refreshing beverage
that there's already a way to achieve this with existing constructs.
Smack, which is subject+object MAC couldn't care less about the user
namespace configuration. User namespaces are DAC constructs.

>>
>
> Links:
> 1.
> https://lore.kernel.org/all/CAHC9VhSTkEMT90Tk+=iTyp3npWEm+3imrkFVX2qb=XsOPp9F=A@mail.gmail.com/
>
>>>
>>> Links:
>>> 1.
>>> https://lore.kernel.org/all/20220608150942.776446-1-fred@cloudflare.com/
>>>
>>> 2.
>>> https://lore.kernel.org/all/87y1xzyhub.fsf@email.froward.int.ebiederm.org/
>>> 3.
>>> https://lore.kernel.org/all/9fe9cd9f-1ded-a179-8ded-5fde8960a586@cloudflare.com/
>>>
>>> Changes since v1:
>>> - Add selftests/bpf: Add tests verifying bpf lsm create_user_ns hook
>>> patch
>>> - Add selinux: Implement create_user_ns hook patch
>>> - Change function signature of security_create_user_ns() to only take
>>>    struct cred
>>> - Move security_create_user_ns() call after id mapping check in
>>>    create_user_ns()
>>> - Update documentation to reflect changes
>>>
>>> Frederick Lawler (4):
>>>    security, lsm: Introduce security_create_user_ns()
>>>    bpf-lsm: Make bpf_lsm_create_user_ns() sleepable
>>>    selftests/bpf: Add tests verifying bpf lsm create_user_ns hook
>>>    selinux: Implement create_user_ns hook
>>>
>>>   include/linux/lsm_hook_defs.h                 |  1 +
>>>   include/linux/lsm_hooks.h                     |  4 +
>>>   include/linux/security.h                      |  6 ++
>>>   kernel/bpf/bpf_lsm.c                          |  1 +
>>>   kernel/user_namespace.c                       |  5 ++
>>>   security/security.c                           |  5 ++
>>>   security/selinux/hooks.c                      |  9 ++
>>>   security/selinux/include/classmap.h           |  2 +
>>>   .../selftests/bpf/prog_tests/deny_namespace.c | 88
>>> +++++++++++++++++++
>>>   .../selftests/bpf/progs/test_deny_namespace.c | 39 ++++++++
>>>   10 files changed, 160 insertions(+)
>>>   create mode 100644
>>> tools/testing/selftests/bpf/prog_tests/deny_namespace.c
>>>   create mode 100644
>>> tools/testing/selftests/bpf/progs/test_deny_namespace.c
>>>
>>> -- 
>>> 2.30.2
>>>
>
