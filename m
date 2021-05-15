Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F9F3814C9
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 02:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234657AbhEOA6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 20:58:31 -0400
Received: from sonic309-28.consmr.mail.ne1.yahoo.com ([66.163.184.154]:44146
        "EHLO sonic309-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234599AbhEOA63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 20:58:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621040235; bh=OPLVYA6PTN9lQ2PFoMQqxiAJ97QKtgsHa94krTc9ksU=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=DubuQ+fv/RFAAPQylfA0PvckacLMPtYg19ueNlsCzAWEb+PrsY9bkM0DAJtqW+KX8o1huPjbwQcgh4+QMYLXhItTcb/jGg25lvk2ekt82e9VyLw9hLR5kfytULuQPa0pEEloJYIYHUG2X9v1BicPaJ/cNbhPEcuFD9jZS/BTh84oJOfaVwitzrF53rkC3j2siUtkiJ10hgifZs+7NTsJhECobHPZaj32Jbi6SGOkH8zSxZfKVVUVIIPV8/XvXSEXyah+eGBp6H8E+4p62jYQOD+a/y3ZEHwvenKk+ws0Jbk3iBOMJ78Jd7Y7UA5QmUsvYwCNA2sRRfdMVLz5T4nmEg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621040235; bh=e0NqqRzAQzSzTEIadnIqVpfv70OT85Dv4nxEGMsJs8Y=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=T89+lWT/6suHY0cJxMvBejkDydxm+aVcdhfTiqcJX7EXr1mQQR/ZHx/1c8lLi1ADR1YmrjPFzVD+1/2VghqQCuH9iepAWGQTcjSbgFqq3bJfnkxp/LngeyITWO2KyLzTYMkMc5VgFAVWMPQpurFYuUfFDmgj5qM3R2wDpekuBdtvP/QoLZcKQ3irSP+hI50MvMV377zt7P6zs7ntAsXNcWz/HGjDoPeuAEZeelOMfkX1j7xWt3/HEGoWGi2CTlNzNW+/5MaUxily9HV5pb33b8xhmH8i+KvnzN4nCc+LkMVQG1o9TeV9Wrw/ZeZSZ2cAJiRVuv+joJl5RQJWpTLMIw==
X-YMail-OSG: Th9g6XwVM1nnGsiFhnM3K57fZCpswIuTd5UKh0Me.hsWYXlPqIdTlckH1AzpjSa
 Oxgg5R1l0GjHU0VkRDck59C.P.a.v7VDIyr.djD8ZdRX0A8yXLSnbGBrY8jsx0KhHE3f8oTT4KZq
 iGIyDEFJ85xfLP1btt._fujjDZilaU9DV9WLAkLW9gQ_NA5KQAHpLPffgtHIP2ej_zBXn5BRGPJ3
 qoCKcNz0DzNuVWJJ65E8RUvHGaxg5nKbE2j8pYPcuiVD1gmZCF_GYpbuMPlZckgyvuXZvqmhA5.R
 tR_seR.QsCB6NeIC14g7FU.Q5CSrJ7xTT5Qjsxc93EQ2In_80.XXVHdgGeWZ1HOGbaJjvixGB1tJ
 4jLxP1Hqj.pLkqQGPNxH2KMNL3rzlrWORs3XwbNGz.zryWaaMxyc2ELNlNVRCa1LbINTqskKRqWO
 Dv7tBX_CZ2K.xIDxmTQqd.e_UO8bya5Z6djnp8YT2SOqlKC6hEC8o4ps4CN3W86PcyzdGMsXwog.
 6Borb4_LU7ysCemG2evG6_mW4t.gv04JnkrNnjECA7mfYeaJ8t_gMyb8M925UbxqUSO5gwSvxgFi
 QEIq38EI5JgazRzW9sEhnExkmohR1Sy3y_iMXMfo2omFJK.pHGPqQgpWXWKIUTypA93sdh189ht_
 A5_JexvHwYJrD2GL5MM9ePkVmOht_56MSI._qvE4AEzwtYq_7KSgoF662SEAV8lBck2Vk5QAk8ME
 1Ht5Rg7RSKmNoxXHp2bGQKNOC.9W4_xcGiFnjvDMhzlIT4LaUZmtJspQvgE6p9VLe5xG3OEIxKkA
 9xqca6vRVIvdhxaNLfFjCwNU903Yyn8iBaNLFgpNnkIMzcc0Iilt6LosF3SBfSJPYG93McEw7ZZL
 BNA5Fw5G5smuLfMXq8BU1ocDJDs9weoQOeiwJCxOOj5daSFTN82vs48k4D3Ks1OggOrO8VMmhDTe
 S779WNuKOmlyjzaYYNhfnvOEkVo_vXxhZfnGtMKtjQs51O7qD4cyaRMvwFqcmXsXPN8oZnKitI5g
 wirwSKKsFx3rjk7rMKvcb7Il5stmlheNiooACH6Ptu.WsqufISdnEMDkB9IgRDtoRwpZEsBclpdR
 5_ri4GN07iaugSV35ZChrLZ7GSrNdYw5pIvMpiOgjMjqxTXDXYUo2RU9saIoS1MYeGhkM3Can1pL
 OXzmBgWYrVYOVNAwr5sADx6ZXcuSrQeuuYN5kWeVYWd_g3vFt3D7TcPESFHbmIJHG8PYaKq43mbb
 PBXcsZlc861h6ihrYRNBGgv81nmmrpCcVXnxg3VR05cA5Nz2BIi.ddko7NM6BSSjJ_1RJGm5IuuW
 PtDaA9MZqn.R.WHI6G15LMGEXdk_8xOohnrfQNPKZSzfoZ5IU7yLeBnKYMVV2FCfnWMbjltOHm_i
 EAottlvAWDNK0WpIUyEHvVa2Tfm7fRuqLQAUlT9bCk7b52gdqnmwdLN_mAfRYBLyPErSA6vT2x7G
 t1dseEfn4IRtlacmlFlJpWkG.jKz8qYvkxyTUdE3_I4QEY53Bg.2u9Hu6pJ9gNQ92_JyxMQm6swf
 Y5wZq3EO75bM_5x1fohIbSUY4wRdoEEe9F_o6ZbWB0gkYiK_H.9AAUKrSLhzfHO50R.DBvvKURrN
 Tu.TyV2bQHlDw3nTje2pVz4QTn_tvDDL3.3porfKTVLA0DSUUagapmDyCpPQYC_uEBat1U5G3zKz
 FOSlfrKtVmMiPq5czyCwQVQMEiBgu2A98SqjTVUEOS5lQ91g6l75prRSzxiYCiysa5RmuMeMeurm
 1Oy1sEspGtaUfQeqTd30A_My5DxkU1pMBJX8bgRwpJlnfO4DH_Efd_eOAQeaXfOuBQZ2I.bR4xkI
 mCZWZHfyP9gz6h1RqgzBMi_w9aX5GhuVoWMrCgEpDiGjsN58CeA472MgGrfJrxl0Cj2J2FO5u2m2
 lIvGDQr.r44LzH2C45Ax0fWJDYfYKC3wpoU5F1djVUhkZUguKP2M9WWYNuj1qOwwbZmKb9gAgKpQ
 gb4BrgwQbzZ3AfHPvaCzPVFpzsaiSej4wi0BNzePeMds_.ItbQ.s6e3S0dtN5IUbwE0h3IBXGG8n
 gpB8KKhoN5wpAbnEgRbkWCnvFwX4vfSs3SEQofZ9XRL88CEjZvdhs0WSKZSnV6o9GF2ONzNI8rRo
 bIV_Urw1PA1.azwHyTLju2CHi1BaBPvh2rLudAefZgRH1ma6ieWTP6y7sJPFPOxFlTZN45u5sNJ7
 7.52qmCsxUwGMCCtA6DvlHWHUnbxpVzeZs5voqdmr4P8kzkqG9JRQkxHy0pqv1Om0Qygne5ZtbSB
 8MkWoDAMKgKg9xgXRJOPsJAihVRmCEaYFVYxPjVzV3QVGzZ2Fpy8jNwrXPdAON9d5wVjgqQ7L2xe
 UQySe0ExWYdrjIwcDiuviwbB1aMHVmzR4ln6e1sc1jKD16OzcEHh3YuD4Jmhe0aqxag5zPco1pNB
 hjl8somiN5w9BtBSVSvMXjpBxtihqsrROlS4xkPoEHfyQt0hFyA8reVSjP74Lvp26o_fdBPFg6Ys
 ZXsy4a_j0vLl8jz1IFqh9HnATOEsMea.lVnjXjODiSCAVznUYceshrLyhqZrpXIool7UJrKjwTyc
 j3yZx8Ra0NXutlTlPz0roAOTgpU5.Q298qSuyteY6.Gc4rLlmJiTw8g8DclFe127W8cQUkWdKT6W
 SN79syNbAsB0gJZRgYJZYtsySnP6chFmw9qGmGGspzp62x4mhrI76Vokoajs5hYN2h8l12Q1MrXw
 0dkibwlhPMP.acep9TUw488_qzk01ecNU3O0r_bQhBEQTE3m.zWkPapEJXd9mcrCUCigsly7hJHm
 4y.oZASv3bLR8Wps3g6OupBnA7ltrA..UeSWiL6RcbeWivYTl68tq1epM2rWhOvuDCyL1NQPQxBy
 B6MkPgkFkMI0jB8Yzs8lIzhFwOOcsC0h4UNaJze0DYi5PyJUNFRU4KSYsF09ztp0mED3mWgeCTpH
 109bnUdvP6wWAqD5BgiOotdnaYj8s1_C11c1gSoFsBaoqG3vIoOFMOdC4fRxQBRJel7sQWe8.5.D
 xd5adgP_bcDAhsf46kydJk3dLnUxMwH0WUDCqrHlM.SJxYRdHHSYoJpnbHEzWZSCnvx9yZyj87Bf
 hKYmcosXTDFb4USfN7BMfVSz24eaahwsoVTMtDlxk5R3ssEGc8S4jegZ9Ko14HL4Mt8USh6JAnp9
 xr1BeM9BMhdOl98HDAJArYq2lVIq04nj7KVom5Cn3Q4xyHoLAeTQBtZjZ581C7s58TBhUx7SFbGc
 E4F4Lj0rIl58.mVY7x2G383pldqzVaLR6uVqXccGOfH1RW2bnTVO9FmANo....pizyPvZhLFBCgR
 yM61aTChKrLpnb3lPXoBjzeF9V41rfuYzDk6yaKSc1Ki2fXL2ZZigQ3lk91m3kR9xr6V_wPcJOTQ
 96DN5mun.SD9o3nEbYw6JXxGpg0hkmkxwhDBG2BV7HtjWL8bD0sH7IQGpKCB9glMG1v5DlphqbqM
 _CuAr_m3X1UmD5_h3YIEKTYKCz2TUuvZI5QONuMv_WTJeahutPx34q84QVuuXpwQ-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Sat, 15 May 2021 00:57:15 +0000
Received: by kubenode532.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 10c01b97f9e192adb0693999166f13aa;
          Sat, 15 May 2021 00:57:11 +0000 (UTC)
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
 <e8d60664-c7ad-61de-bece-8ab3316f77bc@schaufler-ca.com>
 <CAFqZXNu_DW1FgnVvtA+CnBMtdRDrzYo5B3_=SzKV7-o1CaV0RA@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <94486043-322f-74bd-dc33-83e43b531068@schaufler-ca.com>
Date:   Fri, 14 May 2021 17:57:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAFqZXNu_DW1FgnVvtA+CnBMtdRDrzYo5B3_=SzKV7-o1CaV0RA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.18291 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/2021 8:12 AM, Ondrej Mosnacek wrote:
> On Wed, May 12, 2021 at 7:12 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 5/12/2021 9:44 AM, Ondrej Mosnacek wrote:
>>> On Wed, May 12, 2021 at 6:18 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>> On 5/12/2021 6:21 AM, Ondrej Mosnacek wrote:
>>>>> On Sat, May 8, 2021 at 12:17 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>>>> On 5/7/2021 4:40 AM, Ondrej Mosnacek wrote:
>>>>>>> Commit 59438b46471a ("security,lockdown,selinux: implement SELinux
>>>>>>> lockdown") added an implementation of the locked_down LSM hook to
>>>>>>> SELinux, with the aim to restrict which domains are allowed to perform
>>>>>>> operations that would breach lockdown.
>>>>>>>
>>>>>>> However, in several places the security_locked_down() hook is called in
>>>>>>> situations where the current task isn't doing any action that would
>>>>>>> directly breach lockdown, leading to SELinux checks that are basically
>>>>>>> bogus.
>>>>>>>
>>>>>>> Since in most of these situations converting the callers such that
>>>>>>> security_locked_down() is called in a context where the current task
>>>>>>> would be meaningful for SELinux is impossible or very non-trivial (and
>>>>>>> could lead to TOCTOU issues for the classic Lockdown LSM
>>>>>>> implementation), fix this by adding a separate hook
>>>>>>> security_locked_down_globally()
>>>>>> This is a poor solution to the stated problem. Rather than adding
>>>>>> a new hook you should add the task as a parameter to the existing hook
>>>>>> and let the security modules do as they will based on its value.
>>>>>> If the caller does not have an appropriate task it should pass NULL.
>>>>>> The lockdown LSM can ignore the task value and SELinux can make its
>>>>>> own decision based on the task value passed.
>>>>> The problem with that approach is that all callers would then need to
>>>>> be updated and I intended to keep the patch small as I'd like it to go
>>>>> to stable kernels as well.
>>>>>
>>>>> But it does seem to be a better long-term solution - would it work for
>>>>> you (and whichever maintainer would be taking the patch(es)) if I just
>>>>> added another patch that refactors it to use the task parameter?
>>>> I can't figure out what you're suggesting. Are you saying that you
>>>> want to add a new hook *and* add the task parameter?
>>> No, just to keep this patch as-is (and let it go to stable in this
>>> form) and post another (non-stable) patch on top of it that undoes the
>>> new hook and re-implements the fix using your suggestion. (Yeah, it'll
>>> look weird, but I'm not sure how better to handle such situation - I'm
>>> open to doing it whatever different way the maintainers prefer.)
>> James gets to make the call on this one. If it was my call I would
>> tell you to make the task parameter change and accept the backport
>> pain. I think that as a security developer community we spend way too
>> much time and effort trying to avoid being noticed in source trees.
> Hm... actually, what about this attached patch? It switches to a
> single hook with a cred argument (I figured cred makes more sense than
> task_struct, since the rest of task_struct should be irrelevant for
> the LSM, anyway...) right from the start and keeps the original
> security_locked_down() function only as a simple wrapper around the
> main hook.
>
> At that point I think converting the other callers to call
> security_cred_locked_down() directly isn't really worth it, since the
> resulting calls would just be more verbose without much benefit. So
> I'm tempted to just leave the security_locked_down() helper as is, so
> that the more common pattern can be still achieved with a simpler
> call.
>
> What do you think?

It's still a bit kludgy, but a big improvement over the previous version.
I wouldn't object to this approach.

>
> --
> Ondrej Mosnacek
> Software Engineer, Linux Security - SELinux kernel
> Red Hat, Inc.
