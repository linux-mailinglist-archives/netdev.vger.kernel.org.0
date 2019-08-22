Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7103A9A0DE
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388126AbfHVUKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:10:45 -0400
Received: from sonic302-28.consmr.mail.gq1.yahoo.com ([98.137.68.154]:39074
        "EHLO sonic302-28.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388453AbfHVUKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 16:10:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1566504643; bh=2zwlpGXcukVZkgLPp9UxKY68EqPwduS3sG7l9qbi3T0=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=Fn3m85NaBY7vWeNVFSfXmriMqq4A7CvQ/nmfZkVeVLfbAvLHYH53i2CfwBgGfJEInbG7Bip2/s4DRsmcWHN5o5gszqARP+j8JAChwwgUYAm5E8yhorDF6V3+hKeD02caD9qTuEOKFw69mVEFZdCHmwZmHkgsZ47VxILayEgxfCT00Npy3TDYpAOOmksLPuCSlFpzgQ3M/uais8e2jOjyDm6A7/VJIclbrRh3dx61XXR8w9uutHNC5goRswYmCB1uwN5R1efNaN9plbQCjKzjHlM0D6daIJAjVZf4up58GIdATf+d7IYGeK7uYFcdwDt1htALz5wt0fT0wVrcYxFCvg==
X-YMail-OSG: it1csUUVM1ksB5lGCSVv5sbPkUnpGu16fqZSJ7jwKQ5gh6R98yTBtHwoiu57q7X
 axnPe834d4mhcrf3jfxACHGgqIbheaThaiZ9sUffLgwubO_wxZz6SYFesbBnIJrsYBxt7Qa6aNEw
 b.V8j86K5jpTGV.ROgOKjIdvBr3Fyq6kVCsRvGNtbMz8XXiqEGzz_Sh0RJMXiF9ueG1qby_vr.7N
 d5EzU1uev4.8Q2IMkuz_zyqTUYCHnVgSthvgcLbrtJvE5E3Q1qrIyPvTF4Jje_UKfSq4AIWmuGBu
 FzKNeoU5TMWaPnYxzeGvqP1W2.v7wv64FZD.per5VuPFHhXyvLuK2dx1Hx_NrDO.fvz0a15NXl2k
 0a5OC6L.uxYmeH4SfM4Ywdu5hnJCERUE70OtNyuYcWqxXTUJa7kufJjTDv4_EzYjO8klz9HZp_Fl
 eXiFQVR8HZQEOtZGryucv6Y.mqud__hhz8cairYEkp1714NOjDV6KANOX0Vulbvr0cKR3qOF3apF
 XZJ_raseI8ZrYU0lBU2lXPpuSS1sMiA2rNqkukaG4Q_Q6vLP65jGqG1e_6PgnWhDRwSIIHSt4qbk
 iHJTlZQGQS0FLUAgqTY_CgqlG0f9RprDJJUg33DuiTIzADHch2id7llQaKqWlzS1iCWv.vDBeD.m
 y5AhAwlU9uRuZgHoLLnbYtvcSwiw6l732I7tKfwPbbKpE0BftECRyIxOyYAs6t41CL_x2gXA3Xei
 gqSxgXz3S2KLX8SevuyijU9qAmEgK6v7aeEnf0jd9RNII85WL07AUansvWahPSXUYXR36SnR.tgR
 ywisAXlwASo_ruGA0SCNj.azMxyYfFFydUg.FfCBILfqN0s4zcQfnWn1TP64U88ljqwK0yf7GGTX
 9s0ulU8uEe._.bBRcHZcNaVW_hFiypC6YhXKJtPrqfSm6fexqUqawmj3PUtKMjxh_DAA839HpI2k
 u4q8duKE.pHkumGVik9mhfGXcIHetIH2awz0NNXlKm61J89lsi3DvnJcpk7wsZwt_5O6kzEdh18q
 iY.OkH662DBv6fZ12Tf7JzzO7JbHpJ1JAZ5k.J_HdYcCNkJK2VDrBoDB1yTMIhbaKNDc3xlXojFN
 pxpG2aXmHrBcYuJeOJ1q1f4PCp2BisW3cxiIDZiWdsvHDtEmunzFIynzMbu6GQ3bQY0BdSNJacEs
 7LPWL2PHIPR7bhOe7.4evXG.VzKERdR62rtc0hkxaISzYKmnhmdT3ebuGz.TRpwwWqPH5TE2r_NU
 ZWH2_L21AxUPmwxYjDd4dGJr4.v0YSUx2tmTZ_jQurEdtb27uOFKLxMRMVy8rcfJ1oy_isfg-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.gq1.yahoo.com with HTTP; Thu, 22 Aug 2019 20:10:43 +0000
Received: by smtp401.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID c590be7bc3389192be3eb463b03ee945;
          Thu, 22 Aug 2019 20:10:42 +0000 (UTC)
Subject: Re: New skb extension for use by LSMs (skb "security blob")?
To:     Paul Moore <paul@paul-moore.com>, Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, casey@schaufler-ca.com
References: <CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com>
 <20190822070358.GE20113@breakpoint.cc>
 <CAHC9VhQ_+3ywPu0QRzP3cSgPH2i9Br994wJttp-yXy2GA4FrNg@mail.gmail.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <00ab1a3e-fd57-fe42-04fa-d82c1585b360@schaufler-ca.com>
Date:   Thu, 22 Aug 2019 13:10:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhQ_+3ywPu0QRzP3cSgPH2i9Br994wJttp-yXy2GA4FrNg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/2019 9:32 AM, Paul Moore wrote:
> On Thu, Aug 22, 2019 at 3:03 AM Florian Westphal <fw@strlen.de> wrote:
>> Paul Moore <paul@paul-moore.com> wrote:
>>> Hello netdev,
>>>
>>> I was just made aware of the skb extension work, and it looks very
>>> appealing from a LSM perspective.  As some of you probably remember,
>>> we (the LSM folks) have wanted a proper security blob in the skb for
>>> quite some time, but netdev has been resistant to this idea thus far.=

>> Is that "blob" in addition to skb->secmark, or a replacement?
> That's a good question.  While I thought about that, I wasn't sure if
> that was worth bringing up as previous attempts to trade the secmark
> field for a void pointer met with failure.  Last time I played with it
> I was able to take the additional 32-bits from holes in the skb, and
> possibly even improve some of the cacheline groupings (but that is
> always going to be a dependent on use case I think), but that wasn't
> enough.
>
> I think we could consider freeing up the secmark in the main skb, and
> move it to a skb extension, but this would potentially increase the
> chances that we would need to add an extension to a skb.  I don't have
> any hard numbers, but based on discussions and questions I suspect
> Secmark is more widely used than NetLabel and/or labeled IPsec;
> although I'm confident it is still a minor percentage of the overall
> Linux installed base.

Smack uses both extensively. As far as Smack is concerned giving up
the secmark for a blob would be just fine.

I am also working on security module stacking, and a blob in the
skb would dramatically improve the options for making that work
rationally.

> For me the big question is what would it take for us to get a security
> blob associated with the skb?  Would moving the secmark into the skb
> extension be enough?  Something else?  Or is this simply never going
> to happen?  I want to remain optimistic, but I've been trying for this
> off-and-on for over a decade and keep running into a brick wall ;)

Given that the original objection to using a skb extension for a
security blob was that an extension is dynamic, and that the ubiquitous
nature of LSM use makes that unreasonable, it would seem that supporting
the security blob as a basic part if the skb would be the obvious and
correct solution. If the normal case is that there is an LSM that would
befit from the native (unextended) support of a blob, it would seem
that that is the case that should be optimized.


