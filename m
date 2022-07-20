Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A0F57BFC6
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 23:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiGTVmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 17:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbiGTVmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 17:42:20 -0400
Received: from sonic304-28.consmr.mail.ne1.yahoo.com (sonic304-28.consmr.mail.ne1.yahoo.com [66.163.191.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4218042ADE
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 14:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1658353338; bh=024Za88HO+9X5Rrkmz+l65LYdp4ARNuEcFMmXa44Nvc=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=rPnIw53cgHymRSqYc47n0VX8Iy6rXPSqim2Z/Z1+Isirkw04IyQ6CHGiaDhtrZi9hlsZPz7yevrEoRGdtx+v5f+1Y67q/gbnxTdK6D58aRpIPIWvHpMjtsFeBDaX9sJUb8Ji88FiFeAHo4o7bzzTLbapx9ehPZES3XicxooOie5Uy0/fLuGp2RQ05XSOzXrCYrWgHdh/cvuDhnlR3Ef6bvaph7aqv0knDvDv8y7CALxY0W4ROL7Jn9FfNPUN81KLVGMUU6purJb5ACXBGcDJi97sk12iUjiJJxwV22VQ/PNCmP2TmU6qOpds1KXM52O/3TeKYoXYT8R8vwGj6RJRow==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1658353338; bh=PliYMJuTipfZXacnZ3n2Q/EQrXc4+8YW+Y2cjiQgK7N=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=YwEb+s1QHE2QAZjhG/3WqxxejdGOsHGKoAODUws1VU8zJ60S7hcmpn8iV5mqJkqaOWp9bwGQQSjm2dZQzmJKJWOigx6P40gCxlOI58qamtZv+hg2zmFHUjh+uYX8UPkmI/NqdTO4U937QDErh1MH91S9e/evnq818JddYf7W7QdpZZW1biMuJCTvRES3Fwq1EfrBTEcwZEJflIsI1gTMm8RTTvFTrOdNEiEFFwB2j/QrMlYZ4gM9gdrEXZ+rfxbuPi0zo3bPi0IsZjwBLk/yxQgw8MbweyiQN9SWaykZnOR/dm1eP/hPv7V42nbBN2ELruUiEbHPTdBLBixkXWkGzA==
X-YMail-OSG: 4iE9000VM1mvGFKgiz8JI0BR2S4bwwaLHLFFg3MI.zCYp7TcDpKM9bdkPEeLv.m
 U1_lLO4rd4HLDDFBnVkLMN46qNhIxjbCQVBrZ_PFS41l.80PFPJm8GVlDjMOTor6.pELnFRjt_t9
 x0iaRzAsFPcBYVPdo3O6qsVUiWW4A_kCTVtBEBT2IugV9JsFt_ts24Dttn.M5nnRmaiKz97cLNB3
 8nuy1U.FJ3Vtn2ITJYTdB.JV_TwFAK8bJ.335q7ILA9wdLinHo4KUD3nC8XCRqPdWJtlVMVQaQWY
 fSvz4vpHHj2sKkqIqVLzLAcEr976SV4cmO6hiIJm2RKkl0Q324haKPUxgj_rffn5w3_4b2ZB_Akb
 4KgOFvdJEsn_JQ6xCHaNZEPr7.rvRxW4UDZG2IH5YatG8NAYG_Iub3jK1SaD72MOyp.BqqIbjGu1
 hvVhVkETt3JEkFLRzY8K2c9AHucKD14ZeyUbNYzURtwHeKz1U0XtDxXc3P3iWOOh7bcS3XTL2WCI
 cfHfXhdd5qy8c6U_clNcx7VOyeoFMdtbcxDI7FOTaK.Jt6b1TQ794YhQ4HO.rBRQ5BKKIYWRJtbs
 lGoGbtEDoJWnGMJYx_xLQzyFEK4hW86xUaaNJ.U3gZtHHhbtw2kZr8dBU349umDS6OF616e1yNAO
 d72c1Lmitns_mQm_iIdpjfmILskcjGaMzvqpEgo9ToqYSpCJsr16mgKmKqvhVtaQBqJRhrV2H2Ib
 Q36lh7udgEFeTuQn1kHnGyXPXjn8ooYmJJnFvSnfcFHO19lIiI.bVhKZqTErp5uvJGbmIlzsApIV
 D2ubl0rkXDXAitfQkv2Fq3AOybcDpEgfbrlJYuHIAECktscaJHhCg9KzQE.jcAxg_wNmRGLoNn.F
 33XDqUDDjqtD1YGov4TF9MzOWlDmg_lRT4F5uIErR_hLUsAcL7yTVvP2EDbFw4swNK1pWdHj9ag.
 58KWnuSmKWvgg_vItGzamkAkR7vRSt02ttxHrRX_y5LiYvfcZ86hG.Cxx7JuYbf4JqeLzEJG4HR0
 dbf7PGloC3j4opghP37xhlE1t17gUjV7ToH0DuuV9lL30HLpm.rrUFZnDc4n0yAsN3siO1PevLJR
 _Sa4J9sg9muptgcaPEP1hhKoTWtJAoQ8f80E19Yecjek1KUqVdyNUXByXblRR1w7ekG3wPJ6rYkI
 9LVotjE9o6QlZCF390qz8t3psZd074cPGZgTPpufPR6KpQIFbfIBkp1NhCJXQ3wWAGb3jo7HCn_q
 STBcbCeGHI9lVS2kKdmHbymlnnFJCL4mjRUyQPFUFzOGQBrlwy7wiIa4EseRNhl4eio_RR2hZmMw
 XeVMujh4a6xZTVNnqeSlaoML5X7hS8oHQuMhu3v7gADZCVqsd52.3i63V9eTfZ3.tCigYLUo46i0
 frIiHNXL1bFhKQOMQEJiHpeWWHlTRtDld6Q59pxVBn_GTDMj6MV7sv6wQjmUYGUsy0WNt2qzIi2g
 rNIXwvWzklwDWXXzDKGL4gRcBPHDcZSHBAL.gvu4iROnSuNHE7yo.VFBUHNHk2vBD9Mqkj.ZPS7S
 O4JVJFsyCoebiGr3gSdSOMZzewUoR1MYry7FRTkbDCuWujgpMSkbkrohWkKJ5yQH0GtnklwaR1a8
 PFjpJ6h_enssf_giRX3wBGKxIN5HkAUqXZfSfw1H2CydKfhicREdoTTbrTO0h0U1T1pk_4sOGjfu
 ZtdmSzaoFLfomLXK9BuXxucS1HZU01deqkSdl41dEsHHwLCXTir.kpCt7GQWl8AcctFejGQy.p_U
 YPUif.ACQ4QB3DIE8Q.75i8gGJQwG_a.5v2RKbMPL2awZ6Zqt.MVm.UYK3L_FcwJxTpvt8nS107g
 tyX_cC0F6MdYwc9Uc_rBtyv0vVht6Kit8lvZMTnZQjEesNycBVoFdFHYeXewu5F6VHhf_KqmZZf3
 bClLhac36gOzhnCjBtqIO.HkL3mBisTAtZzZAKywVQ._pvX.Mg9tMh1xjUObqPlAk8pbI1am8rBY
 P51UjvJYunDa9zZlkrLdCokgAXJvSBZX7EmzKgyUho9YdcocwDmvjjT594.zfwN5Ru62AjOV8Kj1
 08oZ4yHAlFINtcelSg2rv9EFQ1Ov.Yzni0nbpp58nsrVyPFX7KZFdh5.NPTK6AcPfdWYTTJU27hG
 uReasEqDKD9CXTYGoeKcamlPwtZciUfITP6Nx_c_eIF8Ip8lY2zpGDD9hl_JlkHcsZxewtRNryjk
 q9StXkopiSU1E8jBYk2wRbSBdQPPl_YSPr2MWdik-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Wed, 20 Jul 2022 21:42:18 +0000
Received: by hermes--production-gq1-56bb98dbc7-hx587 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 926c34200fa537ef42813b3d43720d1f;
          Wed, 20 Jul 2022 21:42:13 +0000 (UTC)
Message-ID: <f1f8b350-4dc5-b975-3854-ecbf9f4e54ba@schaufler-ca.com>
Date:   Wed, 20 Jul 2022 14:42:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 0/4] Introduce security_create_user_ns()
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>
Cc:     Frederick Lawler <fred@cloudflare.com>,
        =?UTF-8?Q?Christian_G=c3=b6ttsche?= <cgzones@googlemail.com>,
        KP Singh <kpsingh@kernel.org>, revest@chromium.org,
        jackmanb@chromium.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
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
 <84fbd508-65da-1930-9ed3-f53f16679043@schaufler-ca.com>
 <CAHC9VhQ-mBYH-GwSULDyyQ6mNC6K8GNB4fra0pJ+s0ZnEpCgcg@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhQ-mBYH-GwSULDyyQ6mNC6K8GNB4fra0pJ+s0ZnEpCgcg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.20447 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/2022 6:32 PM, Paul Moore wrote:
> On Fri, Jul 8, 2022 at 12:11 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>> On 7/8/2022 7:01 AM, Frederick Lawler wrote:
>>> On 7/8/22 7:10 AM, Christian Göttsche wrote:
>>>> ,On Fri, 8 Jul 2022 at 00:32, Frederick Lawler <fred@cloudflare.com>
>>>> wrote:
> ..
>
>>>> Also I think the naming scheme is <object>_<verb>.
>>> That's a good call out. I was originally hoping to keep the
>>> security_*() match with the hook name matched with the caller function
>>> to keep things all aligned. If no one objects to renaming the hook, I
>>> can rename the hook for v3.
> No objection from me.
>
> [Sorry for the delay, the last week or two has been pretty busy.]
>
>>>> III.
>>>>
>>>> Maybe even attach a security context to namespaces so they can be
>>>> further governed?
>> That would likely add confusion to the existing security module namespace
>> efforts. SELinux, Smack and AppArmor have all developed namespace models.
> I'm not sure I fully understand what Casey is saying here as SELinux
> does not yet have an established namespace model to the best of my
> understanding, but perhaps we are talking about different concepts for
> the word "namespace"?

Stephen Smalley proposed a SELinux namespace model, with patches,
some time back. It hasn't been adopted, but I've seen at least one
attempt to revive it. You're right that there isn't an established
model. The model proposed for Smack wasn't adopted either. My point
is that models have been developed and refinements and/or alternatives
are likely to be suggested.

>
> >From a SELinux perspective, if we are going to control access to a
> namespace beyond simple creation, we would need to assign the
> namespace a label (inherited from the creating process).  Although
> that would need some discussion among the SELinux folks as this would
> mean treating a userns as a proper system entity from a policy
> perspective which is ... interesting.
>
>> That, or it could replace the various independent efforts with a single,
>> unified security module namespace effort.
> We've talked about this before and I just don't see how that could
> ever work, the LSM implementations are just too different to do
> namespacing at the LSM layer.

It's possible that fresh eyes might see options that those who have
been staring at the current state and historical proposals may have
missed.

>   If a LSM is going to namespace
> themselves, they need the ability to define what that means without
> having to worry about what other LSMs want to do.

Possibly. On the other hand, if someone came up with a rational scheme
for general xattr namespacing I don't see that anyone would pass it up.


