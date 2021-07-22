Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35B13D2739
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 18:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbhGVPYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 11:24:03 -0400
Received: from sonic313-14.consmr.mail.ne1.yahoo.com ([66.163.185.37]:35170
        "EHLO sonic313-14.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229459AbhGVPYA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 11:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626969875; bh=/kAoLRImpI/WjxKZyNbkWgtxeurpNm1Zg16K3sDc914=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=Tncbm+PlX4PbxY56kUHUFvxTfPDKIzGJKuL4xFCs+1vrZAghAfYzReR6+Si7X7LFbI9Hw35wUrPW9CakGAvZQ8FErLE8XI/zYiYDgqgefvOr6EPZyyX0d3UfMwA5LllsTaSd38sAxDQnDlmdoR9JIXjAJT7+edG6sG0HA4Dv2aXkV+mOo7kc58fShv/bm13jW05aAPnGw/87ZsztUpAOaMJyQO2PkOuURamrQy8bvRa34A+okhM3IatIKuJJ+BvEt0oSw/17dJtUzKH4Gy5HmVVO/5K9joxYt6SF9ZMA+2xTHja5Yqwf26LLESuABhbF9pEVFAO71IGelIJtYZPNYQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626969875; bh=r/eYhf8oSi6V63frNl5NNLE393nD2xvkRvsdOqWvXC6=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=Tk699INqHxnMYDA1/i9llX1tqBLFXohyAIv52rYkzorjFc5nqxL/dug/fXdWAH+6z1wUTbwSEEbju6Kbe+zZ/ADXIZd6HdI2aTImelS0EWQsh6OiVx1kFZ5A1RRtIuAYAY6DXdQ05Sr2Vn3VGXTSsNkJqqsatPrgstg3EmwtazeFz/C8jlpflaA5g6/XwNBfFebdG9Swg0pTq5PwG+jSY/1VKC3mz5IMvVUcegrKxObsmSTCIBWCveTdJNjSrTicchhAgT6nJJsOMNihESw6ImLX0DarQJtH4BXuEwVkD7PMHXWkFQYy2kRYEAqCVC8NKzH195Kb7lPVdx96Ko1bPw==
X-YMail-OSG: mXiobJIVM1lVDxSx4ifkq9wiX1WP.XvV5dMt5frCA.XFam_tdfcYNHA8QMYt.ql
 sNAaSqQhnXuxxtnDdd9f77.CH9ueiz7p39nuEjffOpbrhSXN8QBoeYQCocYpAHsgvKWzan610Fv9
 T704Dzl7Kv3SuKIEjLXPyKV5R3a7EzLHqJwS.ROcJAjhPbed3mgFUAPduSJmFwM9hPJVwPq6rx0z
 .aCc8JH8YnstVMN9Fa9V9WT9zXZ3ypx0xEh0uVGZYtzriM2lDiFmSPQ0bfiC3bqNrFUNlV.w36It
 S5kBUpJDp1LmzbzC5foCPP8yEjHkVeqjtIcRGh11BTPi7FK7LBiwZwnHlQxMLOVmYh5VD2P6X.fT
 6BvDh3o0VpE7tr3eG46JYql9TFJlJ0MVwrklOWfL1kUmq521Em2JdFkJ7kzSz9eBlS5G594lYnmy
 a4bNTG1c19eYdVEdQh0rfpn3rvwgqlwDZxWWhdFAazWqdAtel2_O6KDAFq9rBV3h1.VCCa7q4NRJ
 sQLwTzkPPw0hHpQ_kpSX2BEZfLusHeTfr71dIXtw9M1QPgaWmPhAwr_1s3LBS7BPXjxhM_iNi7iG
 WrWdV.bDVJL8SKad.dbSS.sN7A49bur2MnfByhqyb6BcL1N9gzNA8QyWKuF2l697Slqab.5A22tk
 A1rIjJz_5hORqO.cVXldckcldQQpd2tHUZOrO_0a.tJHEUIplJkAM_6aAPsOWWrVwMrSgzsIJjNI
 oiMr5Ymtd6F09mGVjNvLJcvRsglr15Ih87pwH.3b2FazS89brLzrHGUP3iPMYFYwbC1WaMi4pDTB
 TBmLfAfMX4I1Y9YgsQ26GLsS9Xq8j0x.BgqTo5nskmzAnDEd05Y_JjWLHDvlNGokq_l63Oz7Tx51
 HaLAjyjelcp2SULy2yJcR9BaSq1tB4aG6zzFnrvQCZHxlw7ubn2fWrgYA6z0xFFUi9amY.HS.Yjp
 3m9_.ArzdevB.lru9kLxoBRqZYGLWXsryXOd85qosN59JIHcYnH2lyfzfzMcFCZwwwU9WcW7asUA
 nCHPYOanvdsLFQIyDFSEJVXwUP1wKfIT8xVhQHLRzxwMzXjBg4ej.q9bljF2ZE82.EhEetxSNkvq
 f6PGc7oHqVwvIL_0IZs7LUZJO14j4bottOvXRMPfjUJYmR3qw8CLGazc_qBS06VKmndJjcDuJiv9
 fyK8TCuJZCth.jINTU7bsEgbsWMFTNd7C3V5wbfaTWh6Y_vlxq.Dwd4HyBuTp_1V1J5rlZvfsNZC
 _3RbmT0D86q5xHSB.6qhTGAn3qPQ1lwZV_LnswyLcAUx2KFCVQTfmxSc1bktqOF0jDw0X.0vkigI
 IKUcYTLB0JudjlNRCIU3311rvmAhE6xX4HyW19MzcoTgbn6ujoQKTL9otutKbpDSnZSwP2js28K7
 _VUb8UjmTnXLEhHgoHMI0kJAkj4wegg3FhMz6dB5iiOUB5cbGNnP1NKDyVmtKx4tIPLj_t3jrLPO
 URQz7_ofhD8kiTIV.uHwbmb.zbVUgGCMpGQQHP8K37plb.pBtHMTV7ABQJt5OCalsu7ryrNww5Iv
 Fz5_tbnFo7_SOuVxan8ACdKI3wIMYKjjgQDMT4pqyll1PyotPv4UI1LRfPbWfSfolZw9RRG2jvzt
 xDOjHY3BbGW3Lj_mmdij5znTJQwn.dw.HuGwa9BVdrDxvIUBNq.nDNLsK.E88iBsosk3ERd8m.8E
 57kym8JOQwxxEG336HupOzy.IVVlt0.tEXkKCzJRS4q_u9KWCynu89k2qvIBA0rdwcIpA79e1l4T
 ZmPpRq4mFdLnCdJJMY9D30PRd3k7wvq0II6TK7uxH9rlxkFuWJzuCf_aub7DpN75d0SCVCEE.nhT
 378MaQ50k6mnqxP93rymCnbD2e__3E6AXN15qxqpjbqrKwyoma6Dy0ivye1uDKQ3rBnY41_g7KW.
 xcnWMvCbhi6rVWbAul6Af0pIsaTr.Zy_bgheYuE3w7j5oizhSqCC.kiCsvDP8SnKjICVdwpS5BMS
 t48xBx.Z5JM5PNYteZznmwaZklkO5vh8gZQw3xALXIHn0MK4_QnPzoiDQ7iHYNBdopo1Zzpj6ITk
 AKiMNTkINkQ6zkng3.m_P_4tJQAqkjJ4StHr2EMjqa0zojLfU27nk.eC6w77NnoAN2y_cFUgrYd3
 4mdEHtdpYehAOe9qNlbMQPJeJg6Q2KcZA9u5ioHNIllIMgGwH5rZRTfGYWSM4eqf2gL9DEog4NvH
 vqvZSXCmkWoT2XyUZXkTuIYfBCowU2yw4NgQN.GiFM_Kir2EFYhih8t906OLx27F8Va3Qx7f9iBL
 9e8bBDbKMVnzcVbRA6lGsYTXKsqtYJsD7ojH_XVMr_mQfoE24pfl4XlRcyJ5xqqkoaBnt_bw0.Oc
 Pn6IjTI1yWl3XbNlq_1Dx4lSIv2h2GSSx2XHmU1ACv.KLW42W90C5l0a94_cVjTvjHs5yGaB.FeT
 KjR89DOfx0mcwNKHZgfHWTjIvih8OUukRSG5FFgx31Uwu3zsT3XgORvvVQWXbBjxlgNVGUYvg58l
 5uXeWjQDtyzU2meyY3WotJ__Cmw8z5yYIACwYGSISEbuyPYwAFPW7Pbs00K2E8KZojI2e6mE1pBG
 TrDqu9EHPhwKvVxV.liJpNtcui1juab4OQ3dSQiPItqM3V1hvc3nKat9c5U12zTEM3vSNu5VEl8i
 ZKxzShEjsxh89YANxh13VnFQfKTnMaTPovuEXciZYUBLNJqj.Yxw5KEPc_oh.U01Ao8gxcodlGxL
 AKELHJN7NKdBtGCdkv3rJ_7nCNRO1_GoQPKnalOVvnJPHPdAaB3bgjxZlUiXVwfaQhxV6It87mVe
 kfvZaJKzoctfasTNBORbJQSb2WtMMergkr7V0jVRHy_QhBfgUOIO1cw9vkeNqDjky1rEDjUX7WbY
 gEEV6wNpkDjBJ1Pfy00jE82rR8m9LUb5JEC1yZDOKJ54BPvvwWGztg7OQE6cQ0jVke5mPaV9hElJ
 Pr0Vtag--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Thu, 22 Jul 2021 16:04:35 +0000
Received: by kubenode549.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 9a0f16f9eee7db92eae94e3321c54973;
          Thu, 22 Jul 2021 16:04:34 +0000 (UTC)
Subject: Re: [PATCH RFC 0/9] sk_buff: optimize layout for GRO
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <cover.1626879395.git.pabeni@redhat.com>
 <1252ad17-3460-5e6a-8f0d-05d91a1a7b96@schaufler-ca.com>
 <e6200ddd38510216f9f32051ce1acff21fc9c6d0.camel@redhat.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <2e9e57f0-98f9-b64d-fd82-aecef84835c5@schaufler-ca.com>
Date:   Thu, 22 Jul 2021 09:04:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <e6200ddd38510216f9f32051ce1acff21fc9c6d0.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.18736 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/2021 12:10 AM, Paolo Abeni wrote:
> Hello,
>
> On Wed, 2021-07-21 at 11:15 -0700, Casey Schaufler wrote:
>> On 7/21/2021 9:44 AM, Paolo Abeni wrote:
>>> This is a very early draft - in a different world would be
>>> replaced by hallway discussion at in-person conference - aimed at
>>> outlining some ideas and collect feedback on the overall outlook.
>>> There are still bugs to be fixed, more test and benchmark need, etc.
>>>
>>> There are 3 main goals:
>>> - [try to] avoid the overhead for uncommon conditions at GRO time
>>>   (patches 1-4)
>>> - enable backpressure for the veth GRO path (patches 5-6)
>>> - reduce the number of cacheline used by the sk_buff lifecycle
>>>   from 4 to 3, at least in some common scenarios (patches 1,7-9).
>>>   The idea here is avoid the initialization of some fields and
>>>   control their validity with a bitmask, as presented by at least
>>>   Florian and Jesper in the past.
>> If I understand correctly, you're creating an optimized case
>> which excludes ct, secmark, vlan and UDP tunnel. Is this correct,
>> and if so, why those particular fields? What impact will this have
>> in the non-optimal (with any of the excluded fields) case?
> Thank you for the feedback.

You're most welcome. You did request comments.

>
> There are 2 different relevant points:
>
> - the GRO stage.
>   packets carring any of CT, dst, sk or skb_ext will do 2 additional
> conditionals per gro_receive WRT the current code. My understanding is
> that having any of such field set at GRO receive time is quite
> exceptional for real nic. All others packet will do 4 or 5 less
> conditionals, and will traverse a little less code.
>
> - sk_buff lifecycle
>   * packets carrying vlan and UDP will not see any differences: sk_buff=

> lifecycle will stil use 4 cachelines, as currently does, and no
> additional conditional is introduced.
>   * packets carring nfct or secmark will see an additional conditional
> every time such field is accessed. The number of cacheline used will
> still be 4, as in the current code. My understanding is that when such
> access happens, there is already a relevant amount of "additional" code=

> to be executed, the conditional overhead should not be measurable.

I'm responsible for some of that "additonal" code. If the secmark
is considered to be outside the performance critical data there are
changes I would like to make that will substantially improve the
performance of that "additional" code that would include a u64
secmark. If use of a secmark is considered indicative of a "slow"
path, the rationale for restricting it to u32, that it might impact
the "usual" case performance, seems specious. I can't say that I
understand all the nuances and implications involved. It does
appear that the changes you've suggested could negate the classic
argument that requires the u32 secmark.

>
> Cheers,
>
> Paolo
>

