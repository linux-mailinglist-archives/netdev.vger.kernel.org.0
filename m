Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 906F83EBC35
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 20:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233360AbhHMStB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 14:49:01 -0400
Received: from sonic307-15.consmr.mail.ne1.yahoo.com ([66.163.190.38]:34678
        "EHLO sonic307-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233250AbhHMStA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Aug 2021 14:49:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1628880512; bh=M0IvlQWn1NZVpyUDNBFopADNkTBHVFU56HyMjOLWEjo=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=ZgO+KaM5PnlUvMqaJWCuxa0YBPmkRp6kEzH8b3XkmtRVBcEpvUdQw2HGAjFqTpiDphMRxG+pqbCTrcATMJb20oYDlTb3n1BVHEBX2WK6yT3Hts7N9Zxsz7Jm9CWS4x3FcQhdPcK6Wra/2rFxHt9QzjPC3xcRFe3/amx0li0RXCxzW5l+05VXH9FwAYCMUP8ug9vhNh3WJsV7NDeqX0c2bhsgJ7PNW9ormXY5d5/ZFxryAqxq6emuWE5VPFueCow41R3QqaX+bS2D1bhu/n2mWIc70LUuJPOY3GGXdbXvBsHAZXI4oCF1RPFvIQf9PEzYqOAOqXPQQawhPfN7UlEZOA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1628880512; bh=jBvNAxA/VMvcfD5RelGYHzl4DdJ1BH4Ly9tujw8R8PL=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=sT3Xq2fbTw665eKbyuvqJsIlbUdHKIkX8CiZ2k19YBDjp41L1cxI+VtxNHs0e7U8QdoeH+6mkxubtYN6tvdCelInserXrUQ2xvdLbcokc0oGOHTpjNa9luKwUnrUjsMb9l76/Ln/2+VOEXHBNp4/x7pYZ7zHA8ZnJWSyvZCY4L7GAfptsYWr8ldLyPi6opAyoPyZuvndcklmDf+fJO6mnPVi6Lks7t5w6t+ceP+DkEoAFL2V4TEELSJmsKux6YALmA9iPpwNx3C9s/O1lTHhnDL5qUWgYhVabtmZNtzxx4+ovAMr9f1e472gLXiOD/dlYpI2oMG/MlheFmeJYNOSUA==
X-YMail-OSG: bCEqmp4VM1lmcCZ9AQDkiqI_o8TuUJsyL0cyfz5RIhPviaUqKKuBYN1HY6G9epQ
 95FQyZTLyt9VBXe6hbgnyh8.32uGjXborurpsEugGgZ3jfHaDhbASY0ZLsLMABskpJD5Bw4jLob1
 zQfn.EXRWcSzSG9B8s1vdDCh5yTtx7EeThT6g.BIb.4vRI75Jgo_VkKNskeRhvedCBLD6fQoVozN
 FLZ_TEMEDYGv6CPuvYrVAVbHFVVGefWwBEHJ4AnLQn_5HrdgN.5hgGVrJW95I.k7OKC__5xqQznv
 qpLvaavzG3_abA6Dv3mpK2kg0rxAENj.1f6zTKBtzZgboaiaGHH9xIbxdm_QHQhS5XgRNsRmRgLs
 Xo2nuKsQvFqkptmXN3j4mnG7WsH09mhTTnZJdYGdapl9TrMBzJpgEdPOyiBM9gJeU6qy_mAwrfs1
 7eFTFUwGsKYwBKhDGjhtwLJ2w6Ey4YuevUsD3uMxaa2gemI4cU5LDFn8sBrhdo3Jnnha4uEDhDmS
 2g8wNFhfil8pg18VRS0ZPwISnt9OFc5Z3FM80kbc_pz8TVBnKYCsMmAWfh4Hv62GprQHkd8M0GJJ
 Fv18oQvl15u5HGITUkSfZ1bGGBuAFd2m0nHRsxNVeKjux_xG0fCrLlqkqN_TFtOArCNa.wRtBmb.
 geUkoglndJnxd4.pLgARvbnRDCAZ4djy4NFBj0Gt15FIrJuIVibo74tzTUayA4qGyGezuqcL8P4k
 bfRV7GonuJ22Fhvkj1lo8sTCshSFjK1co6T1sYypLSyQKYJoeZS87lGB300aXP0vIWqesURG5t_A
 L0DFYjaGJfYb4hVhI5iqJLgWHpS5kqjxKmtTVyAADrdrUD6KaQsbhhLlKvUy8Dkyv2vKfyb2YWgS
 ufGtAOy7WnKde6s64Bq4405yjGSaZZMmQgKa_fYGAou2T7sPrmgjg.XVnHABx5TUyTWXH4bcMHEv
 e70OrjtxVait4wh2AcAc9NtpxF5y586Pzlfr_1PVH.UifxaTrKaSB6Ka3n1UGkybwA59i52dmL0_
 w3sQM1sVKZvOtHQ1Q32xKzCbYJCKx0_1nOs5kpeFF9FR1dvWIaUObX.GUSwT1ZfA9JBsdURJcYGS
 BNSgrOuxUcfkOveE5reqgT_RiMnuZbGf._ofsEBJtKIatq2ykQdFsYnR.pdIIr0NFRO0WvMQsHVr
 A5teWmTT6g0.CM42xYuEmfsuYU6eowMddF7cwoy0mfL_x8Mgi50ghfyqWXOxMcdEl8mqdTKBgjWC
 7I8ieSWiyP60jzYp.mN47ypBgyk92cQXpN9AciYid0mpvbRCnvUxuSgnokgVZGveBuVN_YX7d_h2
 oz_S7vvGRO3l7Z8B47EMAhyT7RFfYHr1VF8ptWIZD7JTe9NVQWAerdFHXjZuqsOgnsdkv.d0uPxZ
 b8xu03IleXSSkQVFoYlvjcTTZrkkRBOb6ihzrypY8nTaNtUZCLMxOMZsrHxKtRIn8_GHsM.r2koD
 FsOe0Q2XN7JJ1xwOd4PDD9c_5VBK46rztZZcMCy_SnqzcfBfMmJwjTiqDoSLSXaKm47TVXrlL5Gi
 27YP6gHY_0y__lmdnOiLxBt8NoQu6IswLPuQQyU1cj1nKL6c7IKNOqqvIepIHcWIh.VL6EDcyrb2
 HGLclZGnR6D1wrzkqy5YYY5NF6wWdYBVjSqu1bVqL6swaHnVNnf6PnzeX7bnsmfxG__bBAxhIM5b
 1C4c0Xge3Z0lMu4UwQdojAPeQKvRev5iAB4iaxQTq2dNxMzmWad9zgaVC8lX9EWJNng9V58doSki
 qJ4ndtP2zeRKThzVYQDCEQz2j_Kl8vAiryq67XsMjfs8dkbJ9SSimfX.a3NA_q4SJM1txa9.nkWR
 JY1nUi0fETbQcruSS4j4Iu2hscNqLAkK6772p51C3HsDNbhnuVjc_C5UZMht1YZECeQwR02fy9ns
 0khl6F2dJPUTcD0BA_YDc41x1tqw50lImO4N7NEKQqH844WrMjsRn6Y1yrvvH.DQQU5d5eU6pUex
 5xyqIQu0fG1Ix_Y3Dh_t5Jbd6Ws2UIRyibmrzKdJMQVHRTjRTF0H3LVsNlAHfsC92QNZP2cagRtn
 hN8R2JAaPNHiAtznhHZvVqKEmx9AbFRtkdKhMVNR_M4wGj6_AO5C0XTUSTnz_ElcIqIq3_cW3RqS
 ktpnJLtyauBuxMkELrEXWRJhKIwjtWA8u0IL6YhyDCCrXTz6zOLL_8VaFttov5g08xlyqFPH6M9u
 ban5sGoypXm6PmPEvqagCcoKA82uvHAElaIYmb6PQ81oniWIExufSlk6DlBJI2Z3vJiUT3A_KM6U
 TpN5OnrMKRO0voH_JA83zEf4YLTWFtu7hH1oL210ewuDQuI8FRbj0KiWI
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Fri, 13 Aug 2021 18:48:32 +0000
Received: by kubenode548.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID c6ab84719401a110a9f9bcd99da5cc70;
          Fri, 13 Aug 2021 18:48:27 +0000 (UTC)
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
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <fba1a123-d6e5-dcb0-3d49-f60b26f65b29@schaufler-ca.com>
Date:   Fri, 13 Aug 2021 11:48:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhSSASAL1mVwDo1VS3HcEF7Yb3LTTaoajEtq1HsA-8R+xQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18850 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/13/2021 8:31 AM, Paul Moore wrote:
> On Thu, Aug 12, 2021 at 6:38 PM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
>> On 8/12/2021 1:59 PM, Paul Moore wrote:
>>> On Wed, Jul 21, 2021 at 9:12 PM Casey Schaufler <casey@schaufler-ca.c=
om> wrote:
>>>> Create a new audit record type to contain the subject information
>>>> when there are multiple security modules that require such data.
> ...
>
>>> The local
>>> audit context is a hack that is made necessary by the fact that we
>>> have to audit things which happen outside the scope of an executing
>>> task, e.g. the netfilter audit hooks, it should *never* be used when
>>> there is a valid task_struct.
>> In the existing audit code a "current context" is only needed for
>> syscall events, so that's the only case where it's allocated. Would
>> you suggest that I track down the non-syscall events that include
>> subj=3D fields and add allocate a "current context" for them? I looked=

>> into doing that, and it wouldn't be simple.
> This is why the "local context" was created.  Prior to these stacking
> additions, and the audit container ID work, we never needed to group
> multiple audit records outside of a syscall context into a single
> audit event so passing a NULL context into audit_log_start() was
> reasonable.  The local context was designed as a way to generate a
> context for use in a local function scope to group multiple records,
> however, for reasons I'll get to below I'm now wondering if the local
> context approach is really workable ...

I haven't found a place where it didn't work. What is the concern?


>>> Hopefully that makes sense?
>> Yes, it makes sense. Methinks you may believe that the current context=

>> is available more regularly than it actually is.
>>
>> I instrumented the audit event functions with:
>>
>>         WARN_ONCE(audit_context, "%s has context\n", __func__);
>>         WARN_ONCE(!audit_context, "%s lacks context\n", __func__);
>>
>> I only used local contexts where the 2nd WARN_ONCE was hit.
> What does your audit config look like?  Both the kernel command line
> and the output of 'auditctl -l' would be helpful.

On the fedora system:

BOOT_IMAGE=3D(hd0,gpt2)/vmlinuz-5.14.0-rc5stack+
root=3D/dev/mapper/fedora-root ro resume=3D/dev/mapper/fedora-swap
rd.lvm.lv=3Dfedora/root rd.lvm.lv=3Dfedora/swap lsm.debug

-a always,exit -F arch=3Db64 -S bpf -F key=3Dtestsuite-1628714321-EtlWIph=
W

On the Ubuntu system:

BOOT_IMAGE=3D/boot/vmlinuz-5.14.0-rc1stack+
root=3DUUID=3D39c25777-d413-4c2e-948c-dfa2bf259049 ro lsm.debug

No rules

> I'm beginning to suspect that you have the default
> we-build-audit-into-the-kernel-because-product-management-said-we-have-=
to-but-we-don't-actually-enable-it-at-runtime
> audit configuration that is de rigueur for many distros these days.

Yes, but I've also fiddled about with it so as to get better event covera=
ge.
I've run the audit-testsuite, which has got to fiddle about with the audi=
t
configuration.

> If that is the case, there are many cases where you would not see a
> NULL current->audit_context simply because the config never allocated
> one, see kernel/auditsc.c:audit_alloc().

I assume you mean that I *would* see a NULL current->audit_context
in the "event not enabled" case.
=C2=A0

> If that is the case, I'm
> honestly a little surprised we didn't realize that earlier, especially
> given all the work/testing that Richard has done with the audit
> container ID bits, but then again he surely had a proper audit config
> during his testing so it wouldn't have appeared.
>
> Good times.

Indeed.

> Regardless, assuming that is the case we probably need to find an
> alternative to the local context approach as it currently works.  For
> reasons we already talked about, we don't want to use a local
> audit_context if there is the possibility for a proper
> current->audit_context, but we need to do *something* so that we can
> group these multiple events into a single record.

I tried a couple things, but neither was satisfactory.

> Since this is just occurring to me now I need a bit more time to think
> on possible solutions - all good ideas are welcome - but the first
> thing that pops into my head is that we need to augment
> audit_log_end() to potentially generated additional, associated
> records similar to what we do on syscall exit in audit_log_exit().

I looked into that. You need a place to save the timestamp
that doesn't disappear. That's the role the audit_context plays
now.

>   Of
> course the audit_log_end() changes would be much more limited than
> audit_log_exit(), just the LSM subject and audit container ID info,
> and even then we might want to limit that to cases where the ab->ctx
> value is NULL and let audit_log_exit() handle it otherwise.  We may
> need to store the event type in the audit_buffer during
> audit_log_start() so that we can later use that in audit_log_end() to
> determine what additional records are needed.
>
> Regardless, let's figure out why all your current->audit_context
> values are NULL

That's what's maddening, and why I implemented audit_alloc_for_lsm().
They aren't all NULL. Sometimes current->audit_context is NULL,
sometimes it isn't, for the same event. I thought it might be a
question of the netlink interface being treated specially, but
that doesn't explain all the cases.

>  first (report back on your audit config please), I may
> be worrying about a hypothetical that isn't real.
>

