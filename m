Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F54637D06B
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 19:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbhELReh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 13:34:37 -0400
Received: from sonic309-27.consmr.mail.ne1.yahoo.com ([66.163.184.153]:38995
        "EHLO sonic309-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346394AbhELRNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 13:13:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620839535; bh=owHgUhsZZlmphmqpYBWQnx2t3FJsF2eK7W/oEWJ2W5s=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=IV5tTuJo+XNnghrttd8CHE4uUVZclPQeCZszzQ46vuJGnKnhWJf++YF8KZtJPhNWghvq8wwwxipOc6Ga5FCZdvL8THf9QVqpQ/wSU8CBXROjUHhML+sHR2qbG3DlUzCYCZ9gxsk5UsvgmR32jGTraHltA3gidaYeW3q+pjVPWgbXhdxUfe3tgI+k4iktiVf6zdSYSexcBW2lDtkRJm/Uh/1PyQ5l1GTKFgAxR5GYrhwI/H/JvhDlEQ7PGJ6RooCO1azQyeAeleIIuiyJDOwbAKOCVwzeXAfvCrzW8g18LgthkzOY3bzFaXHuC5apJFhXS0k3rRH6sopSGndD4LMYhg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620839535; bh=G79SEXyj0oRsVq9RPEYGDu4/KjRvcwmNQRnD3AgRCCs=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=hXjjUR+kSGg0IAqSS7EVxW7Avu1SevaZ6VKWBeYggc2kIsVGVz89CQaGOg55XKwFGh1g/MuYpLYHv1PnXJtuXq2DDPZF9kB2/Je6UudJqVjlw2Cdwh175CeyAPIG40b2tybbFueib3FDGhFyCRpG5hJT9+fZCbuZVJ5v9K9qQEhsrUHiQwzMzEo2jYk5Lcj3skykWnWIlnFz01MN3n9A5WHZcjaZagax4HkPSuo52uSfjjjzEd0jntRkNimz6A6t0x1lGudpAMrfNBw9duPKPEkTdcJ0KmOPoNkZXv7MOA82MhXi/l1QxJYc5rLRZhQmu9WSahTf1o+o3vVBPqexNg==
X-YMail-OSG: mQI1zOoVM1ncDBLGlc0PT.OpGZENlJK8gLyJ84bV_UD4WA6dcN8M1wD4et0U_L9
 S1mFSkT4uYiJTXJvdPJX8YMdiKayoflvZTOubBD6_POx52_jmj.h.9hrpMQV0fMYmG1KmzFQ4WsD
 MfXi736.O55x_4vGF.hyrJktfJXsNZRRQsDr2jf5H8VVXTeE.hfnlmYsobCVZrotYNJwilRTABMt
 nB0wDT6_iQxX3Zm9pdea4GUXfgpBFOudZkL2O3xbn4DTe712s_ByUp2hkC8IXWMnUuooVs1QxjI1
 4gG_reUpacmiFHANY.jqnH75YErbK1MvVOQFscsIT7T.4gTI6sNu7_f7vEzyO8Sanq2P5ZJOhiBx
 84QpEwFJLn4UVlP2V9SFw.7UgmWRinH0_eZzp5mRuKJuVeW0oqeKo9elbBYlbdOXw0p.lyd61COr
 8AiCJQ38Wch8v2RGcw4aH74gHNvOLsjO1W5AF1C9BxP_NlODt8oGuc05F0Pf3hk680SXokUUqPRz
 U15PJ78QglgXER.VAWDTUjL3zNu81kJT.7NyTVcuwFQPYPtGxtWpFmCkgcK8W2yb5yqgkiewqndp
 oqV20H6fBPBz4tIeTgnRb0ltGo8CsBWaG.nRO1kFMv5rWLtY4H7_1m.kAHYciMg.wDhNx.jV1ozi
 XQzkFLBQ95rlKYTsOtx1wNe72_35ivjvTzWixDLqtwMnu4lQdeDvfHagwPTPjZIfXd_UmuHunKZ8
 0XI700nGhf3TJ5fTIdjIVGPJ6v2Nb8A9miEiK9UJ2zLNCDYsovUUjvYL_mRCX.xeocjEFq0RZFpe
 QUQcbBe.D0GKI20ovIy3DuTnfgF6FCMF4CPezt6DsZKEYA7EfB31BIxvX0RkyzCmuqs2AeGXhb3C
 AruuINPIoNZllxQoDgHZL39QKykl8Uu9Yc8CahXwS0ZqURmjPABNimyAsBBOa7LpYJXNyC8qFUdu
 zD3XlU4YYFnIaoxjd0Y2e5WDvP_j59aswcxMIDgmwRLo6gCZqqSO6iQevyN5cBgDLzG3k6nIYEfP
 dJQBHod_LNhRW53T..4zy008A2mlwziFDQ5ATYqv6OdJuGK09BeqiFAQPVHAQgQP.pdvqFykXX10
 ztI9UAyEnisZBdTksZGxpuNue8agBF.j_BKepniIk29YYFSz5IxUl0OHC.Bn6KPtOng_rOO_H_b6
 mJOMd6NuDRva5LdDLnMVx50qKqCefltZ5xTwrxd5KWGUd1BQKjjkHfusEb6303vqL1oBfbRZkivu
 w0r1qe2pq4b0CdYBOAGb4WgEjj3RqrshEbFtJTBIE_ywdjBosBBEzj_tRtnVEUGlwd9ILEMgRbqx
 wbrnnLlq9.SG5AWP4PMyGuEwPneXXr22Nu9Opxs56RgxXCWj3tml7sgNKFrf.8IaPywqKX4_r0tt
 ZZf82mEeXigYnslq7iJKkNk0.j03.0tQK97I_XqkQE53q9tXCy1k5PWPBj9C.pj_lMLUf3N.t5ul
 5pZJny6SQGH1wlgfKRfHdfNms2EePfUNTVKWO6IRgxC.YnT_QZktDua0kqqlZPQ9mLjkKBJOfM71
 22YL0Hd86JPNSsVOqqVeyyRMFFh9Mb91zg0UUzUpUDYuRds7mLwBKAos7mwfWi6MRLOQ9XWrL4Uz
 SrTiwPWNx1gQjHNkgk3cCeP37j2QiyCRB.5qjvKW8DBUu89lgkqP9epzSm5Tt28eICHu_dfU_15D
 ICUgZIDP8D14o_CpnIGxYlKEK0m2ZQiJOZ.XxoQToH3EY6v3fcQtWn7GPNgzbL5VC3tYY2gVrCCf
 Xyef9iyIeI.SBsTVjXJTcqSLLXVgPGyHI7TcP1Nok5QKLFIEjCM2NcVRQlp.WjzEiuQf6Ay8Efix
 JVScHWgmihZPZnpBpA2EqUG8sNOW3wHsrSQl4Gr0MbSiASxL8lDAZafl6To_pnJo9PLRBgX.nPM4
 rAgQ2CAb4YVnBE4QJurOm3KShLb2K8FjhLE383yE5EL.zuaXRX5iXVSh6MLWhFjo2kzbAzfQneJh
 GPBkUwwH307SjzR3EWomGQLy388r_laLWTl1J75yn5EKNe2Ru1qJMQXnQwS.I9nrRUq38STuqF3O
 04MKMCp9WYaw6oxPk_ae.ZGDBLOXVKFo4bW.8_SDGp2rcb.w9EmticLzxYVu7j3.Z7y7wbHH6HWB
 Jw3fcSVTHPWjjWNwbRBA60or2Xs6Sl3j0GrMxWsExJYwjzbrvIGMnQ91k1DoslZkNyXxyuud7Szt
 gPBktAqvv1s4af8vCQihe0nGpiHb_aRJWxoERV3g2BQEoU1WCkBcUVoIaVK988VYu0gsCCCwp8rU
 AlGGnouUFHVJLBDJ2DfdFjQhkx8OL5pukC6ljOW4qY8Ehi6d1YKws8hZ29BlTf4rXAIobfhhmru8
 fmNwEAFtjZ_aGJv1ASx.5kea_nSmXAn.7LYOAMMh0CBb7bEV9YYF8NccLl8UhAnP_hQuUJly9edk
 vpCQffU3x6dKI_7s8GAipwe.8.Vc6u943D8VNL8O53PimjI4TaHjG.t4PUuRuTuQBbZnhoTFET8Y
 bUYmwrGWfTigWbaRgqrYfBtzMFc3Bcj.svIFt.cRMYkmp.aEKt3_3BO.sFZGCRYgbkCd_PxjuW_9
 tcsuv4pjLmKAr.I0ZgH_12iL4Y5ulsrRLLyAABiKAnIp4Envxf78AZOFqs0rqfdsAWqsWnsy5Hmp
 9ELZ8das7CG619eCZpZV7JeU_bHSKf8ili5b0bnNXC0zv5XZNtbU1z4i0oxMW051VW1SL8RUP9XR
 ZzxKvCqA9u5ZM4RVdBVkWnqwlj9xD_myHlo4bzidNqKWnDoyhRjOMtzz8dk3wTXhpgOjebh81Dfe
 SpLdD.xDbG9zEiaiNWWIO2FyZ61QDtdTZ..2OSphX8S37CwymKQPLzmH77alHrrKrpByBx_1iiCW
 cVLsunCyVuln9_6t5eE3wi6AwnOX4K5DyoOpqqrFLMuqi0dIgjnnaFFNaL3wg6xx6jy2oVEregfU
 knwoAktt.obHOMOO3oM0z3zKa.Nn.M8gRWoSVbBnxdPmYjE_AZiRmmfpknlqgprQXb1tFKtjO3WM
 HLj_CS8apEBMkiDtuGQ1MpVwZJyB4mSCoPaDzSRwOQjpOkp8anevMWPCB_7dW0vLcklytQimNmVn
 JbgVU7pC6BEMxag7LNBwP.TGzKLgB1h.j4yCm8GpSVJCI5bEoSSj2IVMPRPrvkuri06hQ844UZpU
 rIDxv2gOUzztcaMT.fOCKmtLLus8ClNQVhwSB5jiJDE95pddniwn1FxdDJ.9gZDG5mrZxtCPxLbc
 5n9xuoHboma7KBiy_9OzzlUwTYI6ptIUBb1TkXCv217OpMVSkpc0eo0t1FYG00NyEEXKbtwxAfGo
 6ehGIS43nEJQ5.0ESlX6C8eIYKMCzvxsKFMqPps9Dk.iEpWtJendY7DhdSnFbG7bEIwNBiWtXqp2
 GPNzQZh710PUWiUMHi6QsVkT0oNzj80SIetrZ9txPngwXZXdcuobu1RmF6WPMAfF30WgKAeRIP00
 Z_JWoVb8k14YhlTzL9nIK
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Wed, 12 May 2021 17:12:15 +0000
Received: by kubenode581.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 9c6b4d7f0dd72aac49127cecce153b31;
          Wed, 12 May 2021 17:12:11 +0000 (UTC)
Subject: Re: [PATCH] lockdown,selinux: fix bogus SELinux lockdown permission
 checks
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, network dev <netdev@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20210507114048.138933-1-omosnace@redhat.com>
 <a8d138a6-1d34-1457-9266-4abeddb6fdba@schaufler-ca.com>
 <CAFqZXNtr1YjzRg7fTm+j=0oZF+7C5xEu5J0mCZynP-dgEzvyUg@mail.gmail.com>
 <24a61ff1-e415-adf8-17e8-d212364d4b97@schaufler-ca.com>
 <CAFqZXNvB-EyPz1Qz3cCRTr1u1+D+xT-dp7cUxFocYM1AOYSuxw@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <e8d60664-c7ad-61de-bece-8ab3316f77bc@schaufler-ca.com>
Date:   Wed, 12 May 2021 10:12:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAFqZXNvB-EyPz1Qz3cCRTr1u1+D+xT-dp7cUxFocYM1AOYSuxw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18295 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/2021 9:44 AM, Ondrej Mosnacek wrote:
> On Wed, May 12, 2021 at 6:18 PM Casey Schaufler <casey@schaufler-ca.com=
> wrote:
>> On 5/12/2021 6:21 AM, Ondrej Mosnacek wrote:
>>> On Sat, May 8, 2021 at 12:17 AM Casey Schaufler <casey@schaufler-ca.c=
om> wrote:
>>>> On 5/7/2021 4:40 AM, Ondrej Mosnacek wrote:
>>>>> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux
>>>>> lockdown") added an implementation of the locked_down LSM hook to
>>>>> SELinux, with the aim to restrict which domains are allowed to perf=
orm
>>>>> operations that would breach lockdown.
>>>>>
>>>>> However, in several places the security_locked_down() hook is calle=
d in
>>>>> situations where the current task isn't doing any action that would=

>>>>> directly breach lockdown, leading to SELinux checks that are basica=
lly
>>>>> bogus.
>>>>>
>>>>> Since in most of these situations converting the callers such that
>>>>> security_locked_down() is called in a context where the current tas=
k
>>>>> would be meaningful for SELinux is impossible or very non-trivial (=
and
>>>>> could lead to TOCTOU issues for the classic Lockdown LSM
>>>>> implementation), fix this by adding a separate hook
>>>>> security_locked_down_globally()
>>>> This is a poor solution to the stated problem. Rather than adding
>>>> a new hook you should add the task as a parameter to the existing ho=
ok
>>>> and let the security modules do as they will based on its value.
>>>> If the caller does not have an appropriate task it should pass NULL.=

>>>> The lockdown LSM can ignore the task value and SELinux can make its
>>>> own decision based on the task value passed.
>>> The problem with that approach is that all callers would then need to=

>>> be updated and I intended to keep the patch small as I'd like it to g=
o
>>> to stable kernels as well.
>>>
>>> But it does seem to be a better long-term solution - would it work fo=
r
>>> you (and whichever maintainer would be taking the patch(es)) if I jus=
t
>>> added another patch that refactors it to use the task parameter?
>> I can't figure out what you're suggesting. Are you saying that you
>> want to add a new hook *and* add the task parameter?
> No, just to keep this patch as-is (and let it go to stable in this
> form) and post another (non-stable) patch on top of it that undoes the
> new hook and re-implements the fix using your suggestion. (Yeah, it'll
> look weird, but I'm not sure how better to handle such situation - I'm
> open to doing it whatever different way the maintainers prefer.)

James gets to make the call on this one. If it was my call I would
tell you to make the task parameter change and accept the backport
pain. I think that as a security developer community we spend way too
much time and effort trying to avoid being noticed in source trees.


