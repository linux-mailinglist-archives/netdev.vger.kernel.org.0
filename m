Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1773D5CBB
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 17:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbhGZOe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 10:34:56 -0400
Received: from sonic309-26.consmr.mail.ne1.yahoo.com ([66.163.184.152]:40107
        "EHLO sonic309-26.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234725AbhGZOdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 10:33:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1627312415; bh=MfaQOxKqX5SB6Ig+FHkMaEEbg/ipEZK0/3EgGqlg+yk=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=lAXQqh6dzZLaXhBSMApDo99Cm/6DNIwo4/csRASAG6tHFSTASaK3VMJeBEYrRSmbYiNCjtSHFhThaFljt24yr6RPOPNGKkayGwDE5yzKZAWpE4kVI56C9vufMTJQSOqGGulNOXRG+iAInYiG2sDf7rNaXdHz8DQ05XsQPeqtJKiJEy8Znd4JB0lZ0w9G6WM+MIOa2h9AEtYEMfx/GXiWpqd4QIgwC3ak6uRQtbUY7yE/mt+9GvshXTo+TRQ1FL0r0hrbn40/37GRjWaHhHIG1kq+mlJzetRlk68W53Hiosr/i94/fOIx9HXFls4KmHnNzIuwiZFCNqCUTPhmf5p66g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1627312415; bh=AbdSOo7XTKhb24Un2wpPlYoaLRNSIVlSS85P5jpW2gl=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=M4FDQ6neq5IVH+0L3yYl4hf0xSeRp82jkeqsGoRz5oukGqPpRYz7hQ6O8oy8hcYy/vr7co1iHwi/TRWNcVpjApKUR9HeaxNVqpNTZvnyvtnfsXHBSUKXNQdTPvslsVM3DMA1G/akwMiD2bLTGWikXfrRO9awkAc3TXUsGWcxTjZRGSDt3D5kwtSM7dQ2mnUGnLbxEKS2lZ2zkUvLf8A1HESThzlb0DtKudaR500BJSms8meCyOfwh/F2mdXE1jYS0vd1Rbp8dzvO3xO1BfIILrLMsvSHC/zg8QpdKNEWR8KXCL8HeQfJn1AjypmWMq6MdN8C5W9HnfAfbGjKZzWXGA==
X-YMail-OSG: 9jzndLQVM1l7.Mqn2DIy1xE0AS4h_xiCAi8UWivztDtxXqxw8y33cwh34.KKz8J
 3gDTKHxBJNdCW_v_GAMfBzb1VfMl._ZULixggpTE5ST.c2m.q1KBvV2TTl0vkzqAGWz2Bt2WjDPI
 Y7OYomQP4J1DJfq6_OMVrR3AkqL0djXsAM84SYbNaaAEa0Rs.zYuTuRBGj0VnCP24FD86OUOkfiz
 ACip8vtch77rMwEmN9PvIeQe4kKXhNvT3qpaTe8jVbD2ZuqU.JGc142_jARWNiiBbGCMfV.EpOas
 _M9jHXzInWbr3CntHg1RTtM4E9CD3ko584aN6spl2nMvYUNQeEGLbqKhMpXko52PeisqqJ9RIg57
 I.zacSSMeWwyJ8oKcFMfp5lduRW62.xzyYVUJZiAP.g4jVpx4i4NhaH3R2RE8BK2cEfN8aNT.FhT
 gcDw9OAnO80A1PXVyLr0puffMHDNei70b.fHdTtIGsJtuhJprkPNrMfpwKMf9fbeY.TYp9v5vNQq
 bA2.Gb1oENTM007JoQ1Hwo.jgUHtUlXSLlkNeFlPF2LehU_bEessFVoE_iFGs1oEEWAUEthp3AJl
 nWti4dL.ILucHTg3_6LONlJgONQg5.AI7fbs3mav6tNNsjDxlKDlC5hipL6mIC0.B.V244iAdYnJ
 SKDAALffbZ9MtpcNx8Ibp.5RWOcK7VC_8zSI_KCQu2pp2eInC09M3tkzyOH.viJY3fMjtEc65X2_
 XxMaZC3OqDOxd4HNf2NAGurFbElAxefdtiuy7pcMWmpm1JKUVDax7uJp1WrdfOvPWPoz1pS8g_WN
 iubv4TYz9yU_NMdGT6Wdks0lll_leljMOwZyS1Sfk9JKZTxfXv7uvBdJN_dzjpqYK6LOt1wnxbSE
 G5aQNXzvNvu8c1.MqdLVQRcqBfswdLiyQeUufaCHjfznGJjMRuePluaXcJFGauVyu9u5q2a1NvRf
 NOVSL8YPs47mtKtw6aOxyDu3DNBKA8wfMmc21Lp.k85W2hG5PkbwzIV6n_VOlen.DyKyG5PUi_zt
 jqMX0T3xx0BCzIvm6NexQZ9rMlSM_rVb3JNQ6xCbirtIFZqGA3p_p9ULpXcLf4Xo8_4xBHgMND5o
 VGSwZxkOK6pyLjxv3j7KLWzpkMZ8c2r5IABC6DtCNMf6xS8m_DPOYPTmv4xork5RWFOTq2gyPQh5
 io0Sbmz2ldrzjg4uHIdGsZ4d9B1YiiDvNt1cqFxDEpDvEBws5o3lt66jKSfDfdTHzv5KENrGEn9f
 qcQQApQKkrAX4ktCYePalOcgA4Y6y6qQUv40dBZSgd7mFwJLqcyilJm0sFyWL0SsRzxXpdpmq8j9
 XRDUNZNDdhBsoAWZuf2esu07oD_XZt5t9gqxZ_EtWdAqea.bTus9mwEZZt7d7I4fP5K4B_9LLJvy
 lqWzk0.zTrYe2q87P9PIWIHv3K6voSpeExfdURlE3WPe7zu_YRH1VPjdhO6o35yBn2DnsW5m5mMV
 JSuqC4cmuAdxfYLX7h50Pf.zp6pTALyn6kdMQZ6zzAAfV8KnWbCA.X24SG4MFGnpTwTrrXtx_7Ak
 1z5k2vB.7.wXL6D4ptH_T7Ye2JLKJUvWqdUzt9NiS0oZEenhlX5e5dPymDljCIiBWdyWCqbMEwCW
 H_vPUqq6.9O8lg5wSXJ.sSovbWiUKxorPCAietNSmwM1fbjGWzFkXZzmr2L4KmS6GeCDOnPDQ4qd
 rD_0U5fl.D1yNtLF3FlAF06EfercGBRBfVLCG2D5qrfHR0O7VnU04LHXlTm.mfJP7pog6f07ithS
 p1UhdlAaqIm95FAi5Ar3m8vyNf1YyQa2AbFBqgXWzDBu1OKgurG5.ziiOZ7v1GzXRofF6IMd2IlH
 DQ.hnGOaA7KhHp.OJ.gbljiCf11DcAVOsY5S6IRYgik2g5LzH.lXOelD97wAGnGgXn_.F2aWLYyh
 rXOK7uWLQjWrVzHPHQzWabp2U5S7ZJUkDRPVPb_t5DyN3i0sZfe0B48tLTYpdS1Sg2PjzH7UH_J7
 1uSP3XEwXJ561ee2rLpufvRZFd_ro6GXDNAhnYwFz0LhnNtvgrQzaHmqjmmZW.WgQ23A2FQuJI6P
 rMNVOkRtUfMD4bZS77NDgF6kJ41jgGgOICGVG9EkURcOZ54utvionXdjrV8UB9ZCNXyCT9lupJaK
 rXrYaqkn.6mNUcl0HzIbDVbgQRr4qwgklV7Y4Wf.rGorhkCfDDGFNyU3pG_30qdHe5JCPZj5xtdf
 gsrWUv4N2kEcU4LdW7Q5ffRmOAzyYJLZ9QtEhQfSN157GeEEANTQMgMz2mPGHUvi5DoED2UAKbkk
 pIrmrkPtd3GtpvHn52bQBb6iANpiW10Bl5qLJSk2jGYFwhXwMzbdhb2gEK1dDcMmz5PXbHcbBw30
 69BDLYGAbWnobcz2mprLJQ5nuO4IKaC8FSzEBwtC1hbQhwselVdsgozU4PHIbFv6LddyrTFKoyKU
 nVHQEePbP1Mi3LGZF02w5VdEG9g6zbIgBPMOJk.2cJr2I17M4nFd6UTEaw9wdn2jNNlh.AYet_G2
 2NQJQmyGGUysqC0usO31anB.a.6_93aSG5Gau1.7h.bSITbNpyXTlpsDSkOS56p8tl0NEFDlpCX.
 CVs5C5weuVJppvHSDF_G4E2w6883hlxC.rLLK7H6TK2NIr96oqkSjnyGRRZnfDcSpRznfeHEMifB
 l3QEU8Aq8LcOaU35rKo2Npi58G35JlxwwamACXJuOw18fV8QHWKv.BnHuJySv8WOcscRNocoUF43
 0HxgEvhZFglZ42nZuYovM7FnN_nPwqpiBRuakLvl.ThqQ79tLJpuM02lIakHuRjpkLjS78LHlIXF
 7AUmlBwFdjWMdix0EjAH6x6aHZ7s7YPblAWpGvvxBsJVEI0Kn62URcpRhwLnpsRPd_0rv509yl_v
 .4tsOnAmAnrlkoxis3HdeW9kzQeLiWSRNLSXymbhGOAkawDhL69gqZzpUHsB7Xss8LeXFbpGoW6d
 dPOetrR3BWeH8D2OypRHYj0uUkheiDKXzQbf36he_GYCkHj2vyrHRMRtyjLMM8Iz.ycZvII7cLo6
 p8LWY_nbMFksAgrsqvKidwBcLk8chlTvIqwiCOlpDo27jHSr5zAA82cVU6RZyXx2qD89O
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Mon, 26 Jul 2021 15:13:35 +0000
Received: by kubenode548.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 64455857ee5ba6420f10bf63e3f9a591;
          Mon, 26 Jul 2021 15:13:28 +0000 (UTC)
Subject: Re: [PATCH RFC 0/9] sk_buff: optimize layout for GRO
To:     Florian Westphal <fw@strlen.de>
Cc:     Paul Moore <paul@paul-moore.com>, Paolo Abeni <pabeni@redhat.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <cover.1626879395.git.pabeni@redhat.com>
 <1252ad17-3460-5e6a-8f0d-05d91a1a7b96@schaufler-ca.com>
 <e6200ddd38510216f9f32051ce1acff21fc9c6d0.camel@redhat.com>
 <2e9e57f0-98f9-b64d-fd82-aecef84835c5@schaufler-ca.com>
 <d3fe6ae85b8fad9090288c553f8d248603758506.camel@redhat.com>
 <CAHC9VhT0uuBdmmT1HhMjjQswiJxWuy3cZdRQZ4Zzf-H8n5arLQ@mail.gmail.com>
 <20210724185141.GJ9904@breakpoint.cc>
 <CAHC9VhSsNWSus4xr7erxQs_4GyfJYb7_6a8juisWue6Xc4fVkQ@mail.gmail.com>
 <20210725162528.GK9904@breakpoint.cc>
 <75982e4e-f6b1-ade2-311f-1532254e2764@schaufler-ca.com>
 <20210725225200.GL9904@breakpoint.cc>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <d0186e8f-41f8-7d4d-5c2c-706bfe3c30cc@schaufler-ca.com>
Date:   Mon, 26 Jul 2021 08:13:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210725225200.GL9904@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18736 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/25/2021 3:52 PM, Florian Westphal wrote:
> Casey Schaufler <casey@schaufler-ca.com> wrote:
>> RedHat and android use SELinux and will want this. Ubuntu doesn't
>> yet, but netfilter in in the AppArmor task list. Tizen definitely
>> uses it with Smack. The notion that security modules are only used
>> in fringe cases is antiquated.=20
> I was not talking about LSM in general, I was referring to the
> extended info that Paul mentioned.
>
> If thats indeed going to be used on every distro then skb extensions
> are not suitable for this, it would result in extr akmalloc for every
> skb.

I am explicitly talking about the use of secmarks. All my
references are uses of secmarks.

>>> It certainly makes more sense to me than doing lookups
>>> in a hashtable based on a ID
>> Agreed. The data burden required to support a hash scheme
>> for the security module stacking case is staggering.
> It depends on the type of data (and its lifetime).
>
> I suspect you have something that is more like skb->dev/dst,
> i.e. reference to object that persists after the skb is free'd.

Just so. Only to make it more complicated, SELinux and Smack,
the two LSMs currently using secmarks, use them differently.
SELinux uses u32 "secids" natively, but Smack suffers serious
performance degradation because it has to look up (efficiently,
but look up nonetheless) the real Smack value on every packet.
Please, I know about hash caches, cache hashes and all sorts
of clever tricks to reduce the impact. Nothing beats having the
end value up front.
=C2=A0


