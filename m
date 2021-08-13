Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92C293EBE0D
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 23:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbhHMVsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 17:48:21 -0400
Received: from sonic315-27.consmr.mail.ne1.yahoo.com ([66.163.190.153]:46276
        "EHLO sonic315-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234974AbhHMVsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 17:48:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1628891268; bh=qUlofKBUEgvmxWxfyo46BNlqWnx8gbwxAxICgFOdEP0=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=TOIZLVZaiTGFr5ILPxD/rXdSwyZCX4+3e8mfcv9T2Grs8nkONEbTMzOEWEk/zkakgmqxCRjmBj4jF8UXmsd0McH9lnrPeq/wWlhtWJMRtjlsSbyPXyI87sFJWhicdVR52U+zYmClK7Ax3RfqMKmfOaC618m8Jwgv/npzJ/IDQPa1R8uF9sjPitKIJ+hY0M8X78jRYoZifXTCxpJ0tcAHSOEBlTEoLALPZsgEH76FNnJclJb0zrpLBUSs3Brqo2bgQ/rNqZC9suCgF02z64zhk12NGL4Oox6piIfkPPRnDvmEqCIORGaB80k+oUh36DFu/PGEKjcTpp0XYRaoV23/Mw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1628891268; bh=Q8rpKiGPvgxtTe146RzeL6sPyanIs7XD+A0VLGQ+7Jm=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=uI1nOzp+748Em/FgIIhlVdYgj4rJQURKcv9F3MTtVgcw2mLHUKy78zXOyJQMhm1XqTsiMqhVneQM2+W37hoRHLJky0nsJXWvd74ee2Z57vWVF2a6VwdOyhyKFJIc6DExrMYBxkKEIqkVYSxBh4Xc4coFfB3WPnMJ6bG/omjnWY+ixzJ7Xaz3ozOSpY82NeRaDMFpt1l5p9Xf9tHh7DmfP5Re81J5MHokCNidWmEuCme86WSP+sp0XP/TOKtVYReXTCidm7K1SVUwZ+nG2J1BtjaitR9y09n6gWbqhcrbth+SBmVZpzK93YsmgE1hcH1mXwUsxAIAG0TEnduvqiD0rQ==
X-YMail-OSG: iEhZDpMVM1lFoXv9PC.sma2Ci_JuX6V8yR1DMNsMXOz0mvpBRGEh1p2Ccnbx.fd
 3RlqmcmhOIuSrjEDL32bWgQsZM5imbq6cYR2oJh.t6Duv6UPJRer7.u5jD6A9zDzI0L_MPSmGCgT
 2zKf4WN_P.3cF.G6KwKgKGo9zeJFszyCaIzDLAkVa2TMUBZwlFMY_I_mADP7bO._FRGp11csJrZI
 5trs5g1X71BU8zqsNxn7DsthMX2Kb74n8idvCM6MkCppsQfvvlYTi1C_R27ohoZ2BFzQUIOxO92_
 FiBoZF1Yy2_RZr9MOWXvgsLBFOqJ6s0fUC0hJuMeBNL1hP2GM5wWDbugoasW0njss6FprTfZG1Xc
 sO3YW8UYuyg0atmaG4omXCzinRwIeibk3DgV2UA_OhW11gtRvERownp5PVtMqQ6hiGUs18AsgtWY
 .02DEnrHcKu_drQmPDnBF8PUmUmIb9l4YE_Y.qoAo7eO6wabX7SZfLtfY.JNUiUQGohza_wcAXDj
 g1x.C_gqga39MACiYfKSr2Bq6JON0oFHfP4Cfxrz0gNtO1xetEAgojHsra1ki9bxw4ENB.XVW5dI
 sueALz3gfcZz.qr0HjzvneZbNGO23B_Vcl_DDL_ggSImvIMxBE6vQ4BLmSPxuRLbzq1CzhsFYmRz
 9KYNEWfw1cByRP6fPgwJKRcAkVw0uCETlgo28gIHTqNBFnvXPy9ZGImCHt0RXM4MjfdhHzMoq6H6
 bkTpK2H_IiPWc5lH6D7paSTH8IYWUZrx1aYBi4v3FC2rouX08ND3zahpis2yUy3AAUi_acE2_d1J
 ygz4NLBqVv_m07E6_ZATCvPNY_HeMGkl8gAuYSyIVvPshEsv2dJqhBLNt0Ml2Ye01a7V6Pk1fTDc
 602cGoo1pZ6AIOqA478itA.rX0fe22nF9985o6t6veLLMmUf4j3p1Ub.ET3yYbeABuARCWbOOJKW
 2Lmz_4TT6uzjl2ucCpSsE6zlLJGuKzl2hMDcSkNwuuw0vLF0sPiG64BTcBE1n8GXdSvL2RYMR0il
 uWd83UXYr0RO5wIwci6k8gCC07SUjDTF._o71fI2RpG9IA4j7igNNn.8Uu7YjLyMwUW47CbG0_3O
 L_xar_4IaaqXo3yfJFFxvNmKa7Srk0mobo3B6_frQfKzDKzFsNyx2UBDBTOMj.zEH8vSbHkp.jEi
 wiQPPxHvLpxHGA2Xw7spDIGKprJE7xN12Qni7nMYvLRtPUmF0i4TWhC63ptAdCnWwypOoAEnIPS8
 KwfNZ2yFBRJOU_c8h2JV2o7_Sbh3IStQIPli7Q.Arp.TwAfyQek36AK_xwgP8GcyOP65EdH04k_1
 iTIVPVDSA1umWasfMRhWE1dKFfLjd087GTfIg9YxOsyHj39kFD8ZS.gF2cdbqws5d_XJYPwVmLCm
 Pc9MxMtzBy5GN6LlUBA7aeBO0S.SmBQg70aRl52et26uk.3yAawKYCwgk6ubkKUiP9QFjYIKKlRT
 GPdP01MWnXOv5v9S0VmnieYY4QTvVHbd.c5au9nSnhlkedRWi4Y2la.5hZigX9a3j_1L_xQ49iHb
 stF0xLge0oGqyIPKZy_8FSFgCBrbBKgz3fRzbzQzrpvBRmbngRkcvdEjx8PlpOxaraKkkqwv7BGR
 yyZhlZVNrmmokj5gFF4YnLoZWk_bfJfmcaoXQLXGS9KZFhJT3aC4AYwv2yLGnDC8zHkDg9oleRzp
 hzTpee_dnawJZgJcYDEEVcldar2yyDHzAnEGcYOlNMFrSyYH_qO8XdQU213B6kmO4nDnm7TorgS9
 N1ETOonpbguizm9_rXNrxrcoebvrloEw1rsGvMKFHGlRyRaKHN7n.Vu5dpy1LyaZ1w6UD7OWz2pL
 _a0azn1hd.jImlKGyS3015ItAZiWU0jvvIVL13b34Lgq0lD8ng6mDJDrd_jCLK0mS6fPH0du7BvV
 3tJg6NWhGDiPRBGbw4XxjGEmyua4Ojjrhpe6wUoOkXdyabcyiqzSUQQdYNQXWaWoQpQny1iRtAUM
 Aaz9Cbi70Byvoj5Z7uFU2TO_u_.qtyv6gwzVeTf3ziEkQNiqzUlP07x6Kk9GVmevrmN5tn3NO5dz
 ptbPqOtfWZFy3ujkxr0.iv3nPCYcM8Xfsy7QGvvKP099mr3QcWLal5dUb.7YAZVxqyAhgtaINKyb
 jT6EuON4auGD31JW1ZjlyK12R65pd24INiY1tNEHXQ6PVWC4sPgB4Jt7Epl1icGj2AxAJWacwirZ
 gk9LcpGOJtuWfzCx.XjKnLBbNbdt.6zREFFCPpJY443CnK0P0Uyb7wfabTrkkch0P2WJXOv2sNgD
 ENv782xzm
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Fri, 13 Aug 2021 21:47:48 +0000
Received: by kubenode535.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID a56d8cdd801118492038f45b3107a89e;
          Fri, 13 Aug 2021 21:47:43 +0000 (UTC)
Subject: Re: [PATCH v28 22/25] Audit: Add record for multiple process LSM
 attributes
To:     Paul Moore <paul@paul-moore.com>
Cc:     casey.schaufler@intel.com, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        Stephen Smalley <sds@tycho.nsa.gov>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20210722004758.12371-1-casey@schaufler-ca.com>
 <20210722004758.12371-23-casey@schaufler-ca.com>
 <CAHC9VhTj2OJ7E6+iSBLNZaiPK-16UY0zSFJikpz+teef3JOosg@mail.gmail.com>
 <ace9d273-3560-3631-33fa-7421a165b038@schaufler-ca.com>
 <CAHC9VhSSASAL1mVwDo1VS3HcEF7Yb3LTTaoajEtq1HsA-8R+xQ@mail.gmail.com>
 <fba1a123-d6e5-dcb0-3d49-f60b26f65b29@schaufler-ca.com>
 <CAHC9VhQxG+LXxgtczhH=yVdeh9mTO+Xhe=TeQ4eihjtkQ2=3Fw@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <3ebad75f-1887-bb31-db23-353bfc9c0b4a@schaufler-ca.com>
Date:   Fri, 13 Aug 2021 14:47:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhQxG+LXxgtczhH=yVdeh9mTO+Xhe=TeQ4eihjtkQ2=3Fw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18850 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/2021 1:43 PM, Paul Moore wrote:
> On Fri, Aug 13, 2021 at 2:48 PM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
>> On 8/13/2021 8:31 AM, Paul Moore wrote:
>>> On Thu, Aug 12, 2021 at 6:38 PM Casey Schaufler <casey@schaufler-ca.c=
om> wrote:
>>>> On 8/12/2021 1:59 PM, Paul Moore wrote:
>>>>> On Wed, Jul 21, 2021 at 9:12 PM Casey Schaufler <casey@schaufler-ca=
=2Ecom> wrote:
>>>>>> Create a new audit record type to contain the subject information
>>>>>> when there are multiple security modules that require such data.
>>> ...
>>>
>>>>> The local
>>>>> audit context is a hack that is made necessary by the fact that we
>>>>> have to audit things which happen outside the scope of an executing=

>>>>> task, e.g. the netfilter audit hooks, it should *never* be used whe=
n
>>>>> there is a valid task_struct.
>>>> In the existing audit code a "current context" is only needed for
>>>> syscall events, so that's the only case where it's allocated. Would
>>>> you suggest that I track down the non-syscall events that include
>>>> subj=3D fields and add allocate a "current context" for them? I look=
ed
>>>> into doing that, and it wouldn't be simple.
>>> This is why the "local context" was created.  Prior to these stacking=

>>> additions, and the audit container ID work, we never needed to group
>>> multiple audit records outside of a syscall context into a single
>>> audit event so passing a NULL context into audit_log_start() was
>>> reasonable.  The local context was designed as a way to generate a
>>> context for use in a local function scope to group multiple records,
>>> however, for reasons I'll get to below I'm now wondering if the local=

>>> context approach is really workable ...
>> I haven't found a place where it didn't work. What is the concern?
> The concern is that use of a local context can destroy any hopes of
> linking with other related records, e.g. SYSCALL and PATH records, to
> form a single cohesive event.  If the current task_struct is valid for
> a given function invocation then we *really* should be using current's
> audit_context.
>
> However, based on our discussion here it would seem that we may have
> some issues where current->audit_context is not being managed
> correctly.  I'm not surprised, but I will admit to being disappointed.

I'd believe that with syscall audit being a special case for other reason=
s
the multiple record situation got taken care of on a case-by-case basis
and no one really paid much attention to generality. It's understandable.=


>>> What does your audit config look like?  Both the kernel command line
>>> and the output of 'auditctl -l' would be helpful.
>> On the fedora system:
>>
>> BOOT_IMAGE=3D(hd0,gpt2)/vmlinuz-5.14.0-rc5stack+
>> root=3D/dev/mapper/fedora-root ro resume=3D/dev/mapper/fedora-swap
>> rd.lvm.lv=3Dfedora/root rd.lvm.lv=3Dfedora/swap lsm.debug
>>
>> -a always,exit -F arch=3Db64 -S bpf -F key=3Dtestsuite-1628714321-EtlW=
IphW
>>
>> On the Ubuntu system:
>>
>> BOOT_IMAGE=3D/boot/vmlinuz-5.14.0-rc1stack+
>> root=3DUUID=3D39c25777-d413-4c2e-948c-dfa2bf259049 ro lsm.debug
>>
>> No rules
> The Fedora system looks to have some audit-testsuite leftovers, but
> that shouldn't have an impact on what we are discussing; in both cases
> I would expect current->audit_context to be allocated and non-NULL.

As would I.


>>> I'm beginning to suspect that you have the default
>>> we-build-audit-into-the-kernel-because-product-management-said-we-hav=
e-to-but-we-don't-actually-enable-it-at-runtime
>>> audit configuration that is de rigueur for many distros these days.
>> Yes, but I've also fiddled about with it so as to get better event cov=
erage.
>> I've run the audit-testsuite, which has got to fiddle about with the a=
udit
>> configuration.
> Yes, it looks like my hunch was wrong.
>
>>> If that is the case, there are many cases where you would not see a
>>> NULL current->audit_context simply because the config never allocated=

>>> one, see kernel/auditsc.c:audit_alloc().
>> I assume you mean that I *would* see a NULL current->audit_context
>> in the "event not enabled" case.
> Yep, typo.
>
>>> Regardless, assuming that is the case we probably need to find an
>>> alternative to the local context approach as it currently works.  For=

>>> reasons we already talked about, we don't want to use a local
>>> audit_context if there is the possibility for a proper
>>> current->audit_context, but we need to do *something* so that we can
>>> group these multiple events into a single record.
>> I tried a couple things, but neither was satisfactory.
>>
>>> Since this is just occurring to me now I need a bit more time to thin=
k
>>> on possible solutions - all good ideas are welcome - but the first
>>> thing that pops into my head is that we need to augment
>>> audit_log_end() to potentially generated additional, associated
>>> records similar to what we do on syscall exit in audit_log_exit().
>> I looked into that. You need a place to save the timestamp
>> that doesn't disappear. That's the role the audit_context plays
>> now.
> Yes, I've spent a few hours staring at the poorly planned struct that
> is audit_context ;)
>
> Regardless, the obvious place for such a thing is audit_buffer; we can
> stash whatever we need in there.

I had considered doing that, but was afraid that moving the timestamp
out of the audit_context might have dire consequences.


>>>  Of
>>> course the audit_log_end() changes would be much more limited than
>>> audit_log_exit(), just the LSM subject and audit container ID info,
>>> and even then we might want to limit that to cases where the ab->ctx
>>> value is NULL and let audit_log_exit() handle it otherwise.  We may
>>> need to store the event type in the audit_buffer during
>>> audit_log_start() so that we can later use that in audit_log_end() to=

>>> determine what additional records are needed.
>>>
>>> Regardless, let's figure out why all your current->audit_context
>>> values are NULL
>> That's what's maddening, and why I implemented audit_alloc_for_lsm().
>> They aren't all NULL. Sometimes current->audit_context is NULL,
>> sometimes it isn't, for the same event. I thought it might be a
>> question of the netlink interface being treated specially, but
>> that doesn't explain all the cases.
> Your netlink changes are exactly what made me think, "this is
> obviously wrong", but now I'm wondering if a previously held
> assumption of "current is valid and points to the calling process" in
> the case of the kernel servicing netlink messages sent from userspace.

If that's the case the subject data in the audit record is going
to be bogus. From what I've seen that data appears to be correct.

> Or rather, perhaps that assumption is still true but something is
> causing current->audit_context to be NULL in that case.

I can imagine someone deciding not to set up audit_context in
situations like netlink because they knew that nothing following
that would be a syscall event. I've been looking into the audit
userspace and there are assumptions like that all over the place.

> Friday the 13th indeed.

I've been banging my head against this for a couple months.
My biggest fear is that I may have learned enough about the
audit system to make useful contributions.=20



