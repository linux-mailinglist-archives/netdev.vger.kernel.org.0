Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD47099F30
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 20:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389151AbfHVSuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 14:50:35 -0400
Received: from sonic302-28.consmr.mail.gq1.yahoo.com ([98.137.68.154]:45933
        "EHLO sonic302-28.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731458AbfHVSuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 14:50:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1566499833; bh=iGg+xKs9IWe92dtM6j+aU79MyRSLr1YHffVa8Fw1ZQA=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=c4vVQ+9W+THmOw7kEkQ5ja2REV1zMy0T6UJXUThjRGjfex1Hsd/cFwKiyteHsW6ZcTwoUIhPxF/t5HWkWKtd2iXlmdBMGvXy6z+wweJMIDRUCroJQSBnfmb2Xl7cjz6YbXQGz0XdVkhS8xWagmdk9UrW5ybsh7Mepob0le5w21ErpQXcdspd/20FUtYiKubTRFfb4rdkfwj9sUJ4RZH5nhfYOluJ5oaarkH9uVHMubKrcwGPn0rhGXFKxVyOfurxheEFwscfsh8+nXFbw7Yez/FUhU9VyjzqpDeHZHRq+gYjlkeNLkoA4Vk6TZVEqq5Pli5/sSpZGrPm4Mfg0MATxw==
X-YMail-OSG: d4MmHSIVM1kQNLQN9luXcVEIwCEPEreKRmXjnJ_qerw.F7hDKfWAQX6NbthOkiR
 chnmOu3A889TbZP1EKbqAYq.T8.GPSGDZvn54UJg4epoarBSXFmJtiwAzVhcxEnYamOZ1PY5ZGv8
 XwN8Aa7Lc4DAaOWbDE5AkesJIAZl7W61g9X2U5TGd3BJkaeQeSFPerJYbPchd0FEvFU4y1G6KEU7
 xIRoBHTRTzKkVZ5tgJ20Jpgd_D4up2qrnlSTjlILT4j0huWTHiOAe66wQLb6zMDuxaMstZquBiF_
 gvBHVYsYmcEgfASMWYPRAI_dKu5nmpix3wgJ8p9We36_9zBx2X2l0fJlN3I2MvoxwewE2w1kf29n
 D3XfNgO31aCsUFtTn2L6LGMb54FpvpChAyq20umqGAIu2ApBuYDyQ6oYjpZbp2toFJpBOM_eFKuN
 yHZ.AIunDybSdWRmlBjf6dhCvPz17s2k47199PnBHpPCVJMMduPniREgn1Mg_JuYOM7Nsilf6Ls4
 Xt3sHFFvk36s_.dBV_Xsyir8If77plnsM_riJc5qKfKgByFMDURGatrEn7nCJLUYdGPXWvUMl5qF
 I61tsTLZkFpC1.0Ngmm7YW.Q7dJcrk.unroGOOwcV75uBGDsOlriQK2k2bsYvyVQzpSn1GcA1n5v
 yU6lvfUDlXwrYmr5uqp6EvNRltYXiRkSQdhaoIteBA8jjidDGZ_IypSFXbP0iRjfg6gfxy5tk2KG
 G5WUP9qL.edecbDBAOgiA95KZJw811uEmXlO..klSKUqaVjMtELIx8gMHiEw_LvF1hJlUNSgCye4
 U980vDaTmmE35n05uE6aycHxS6GNAokliTRYDXTQN2VIwmmVPMVYYS8mONyY9ShUNq_xhz3qv.oj
 .6jfp5laVGo_gVATxrcjXf8Zaued06g5RdwZv.su5YckU7v1vp8rcihDWzEqcD6e9O9I4dQTncKH
 d.fP973_f3uIL7vzYaXOrfeaVZkcqHcsfoYv8ZEqc1KESgNF43.mVe4m7ugDtkTqp0Ft6yDSA.aU
 DCdJ3WAFzqr3zQi6.QHAdx2bG36UPeQ0O4T01bHN2_ZxA40QyM0KTkUpkhTzWWlIAoc93KTZr6Ol
 bQ5p3QGN_YYdhJGnCG1z2P73ACgSFWMWYztqph9NrkmG66PmrCJL86ufCTw9pQdr.qtljGXKECjG
 Ctd3ba2F1ewqE7sLZyn_5xR7lim7MFiF00dZ.RLRU_7dZAfjuiuEDAjRjQemM7_rH3g9dB94WlX5
 jx59hbFl7UFL8T4T7CFhG0dMpjSALx.MJgEwW5NnPRubqWDE-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.gq1.yahoo.com with HTTP; Thu, 22 Aug 2019 18:50:33 +0000
Received: by smtp419.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID fb795a423b8272431beb45d8e1e8aca6;
          Thu, 22 Aug 2019 18:50:30 +0000 (UTC)
Subject: Re: New skb extension for use by LSMs (skb "security blob")?
To:     David Miller <davem@davemloft.net>, paul@paul-moore.com
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, casey@schaufler-ca.com
References: <CAHC9VhSz1_KA1tCJtNjwK26BOkGhKGbPT7v1O82mWPduvWwd4A@mail.gmail.com>
 <20190821.155013.1723892743521935274.davem@davemloft.net>
 <CAHC9VhRLexftb5mK8_izVQkv9w46m=aPukws2d2m+yrMvHUF_g@mail.gmail.com>
 <20190821.205454.2103510420957943248.davem@davemloft.net>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <36602a25-3a38-8478-d5e0-8d03d52593f3@schaufler-ca.com>
Date:   Thu, 22 Aug 2019 11:50:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190821.205454.2103510420957943248.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/2019 8:54 PM, David Miller wrote:
> From: Paul Moore <paul@paul-moore.com>
> Date: Wed, 21 Aug 2019 23:27:03 -0400
>
>> On Wed, Aug 21, 2019 at 6:50 PM David Miller <davem@davemloft.net> wro=
te:
>>> From: Paul Moore <paul@paul-moore.com>
>>> Date: Wed, 21 Aug 2019 18:00:09 -0400
>>>
>>>> I was just made aware of the skb extension work, and it looks very
>>>> appealing from a LSM perspective.  As some of you probably remember,=

>>>> we (the LSM folks) have wanted a proper security blob in the skb for=

>>>> quite some time, but netdev has been resistant to this idea thus far=
=2E
>>>>
>>>> If I were to propose a patchset to add a SKB_EXT_SECURITY skb
>>>> extension (a single extension ID to be shared among the different
>>>> LSMs), would that be something that netdev would consider merging, o=
r
>>>> is there still a philosophical objection to things like this?
>>> Unlike it's main intended user (MPTCP), it sounds like LSM's would us=
e
>>> this in a way such that it would be enabled on most systems all the
>>> time.

Only SELinux and Smack use the networking hooks today,
although I understand that AppArmor has plans to do so
in the not too distant future. Smack enables labeled
networking at all times. While Smack doesn't have the
expansive use that SELinux does because of Android, it
is used extensively in embedded systems via Tizen and
Yocto Project deployments.

>>> That really defeats the whole purpose of making it dynamic. :-/

It argues that fulfilling the needs of LSMs ought to be a basic
feature of the skb, rather than a dynamic extension. When LSMs were
introduced 20 years ago it was assumed their use would be rare, and
it was. Today almost all Linux systems use LSMs, and once AppArmor
adds network labeling it will be quite difficult to find a major
distribution that doesn't need the support.

>> I would be okay with only adding a skb extension when we needed it,
>> which I'm currently thinking would only be when we had labeled
>> networking actually configured at runtime and not just built into the
>> kernel.  In SELinux we do something similar today when it comes to our=

>> per-packet access controls; if labeled networking is not configured we=

>> bail out of the LSM hooks early to improve performance (we would just
>> be comparing unlabeled_t to unlabeled_t anyway).  I think the other
>> LSMs would be okay with this usage as well.

Smack uses labeled (CIPSO now, CALIPSO 'soon') networking by default
and depends on it heavily for basic system policy enforcement.

>> While a number of distros due enable some form of LSM and the labeled
>> networking bits at build time, vary few (if any?) provide a default
>> configuration so I would expect no additional overhead in the common
>> case.

Tizen isn't a distro, but neither is Android.

>> Would that be acceptable?
> I honestly don't know, I kinda feared that once the SKB extension went =
in
> people would start dumping things there and that's exactly what's happe=
ning.

As Paul has mentioned, the LSM community (Paul and me in particular)
have been looking for a better way to deal with the network stack
for a long time.

> I just so happened to be reviewing:
>
> 	https://patchwork.ozlabs.org/patch/1150091/
>
> while you were writing this email.
>
> It's rediculous, the vultures are out.

