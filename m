Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F10F9A27E
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404311AbfHVV7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 17:59:40 -0400
Received: from sonic302-28.consmr.mail.gq1.yahoo.com ([98.137.68.154]:32926
        "EHLO sonic302-28.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404199AbfHVV7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 17:59:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1566511179; bh=AnClyWSRc1Jso+ViLXMLCAtAFf244Ny1s99F3Iug+VM=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=ZLyGNLrNzVW1oN9eQ9U5BFqbTJa2CwSOv8L0C5JwUvtkqROA+J1Bn94VjVtUgJhDrNlUdx5QI6VZbiTpr3V3MFOS8XljNFZZ/zMiZ8id2e2I1t09rnh5Joobb5Y3E1JcCzOh1moIWKIUYwO4a5QQbojQq1gnbzAnTNUldFpRxkkAg56vOEA3092H+caAR2/UGHa77NNLVKN1PXTN1b60CcXfLiqCOMplXTesxTBcc9PGhNcEVgYLDDZQS7zxg+WDTWq42vqLZv1JmrFMFIcsS16MqVi2QlwU35gCkCcBMQ0MbJOX+duvIfm0mOHmRPzPDjMlM+CZxwvJUcgdJEteuA==
X-YMail-OSG: EpTHNoYVM1l6j7XYOGL6QX0umjZm454UaLBkNq_podqY52FHK_yPf48sk1GdLwC
 IWX4CB3OVHiUKtDno9mceBTfJZVtgWYyvxHj06vHfLtfzf4UzfvbKzxHDAv5CawOjdy8nNB.igDj
 WSqek4Fj6jI1Xtrc2JfUDyGWexlCYHIhz9NGfBpbbZhNMdckkYvIm2dvVzo7LwwmbqNIEVSGoF.n
 Jm56trop_FOPod2Byr0fPNOGH8P3b18U8ArYI0..1sXjDOqUu_bXvnaSL787duGY0nbX9QJLUzQd
 F7vOV1_ClEns1wyBEDf8S8RX9EOiU7s5Mv.uuwN5fBsVeEJoNfsazBOzJGLiStm46PZxFRbncxAV
 D4K8Idp4OdDAzV4quJKRQf8gAatKeJteK_3sQdQQc8mgmc7wfVNn8LcKTQMdMbf.941PAjAHSwgY
 Kz6LsgiGT5WNWIzw0ID1ljk443XdS4v2zsCbGKC2MKiSz1eGkmyAmzqPoIWnxureW9QPeXn.L454
 DS10YzOFI5djROtnPjGFsa2ZyZiHhN6n76K_i3lf7UsAlHlhcmXC3qcu_3P0glSoLXCfQQmMaC6r
 ueQJ1AHEeiPAG2GizClZpOvr1yhmTvciQdv4preEhwaH8RKhO.UUEArMUiiAgpLluyCVopOUxgSX
 64l17ohO2YeH4aSg4mDtb3OTC2MJ4ZJvDTpX1mnlA2Q6XJ06pRRcqy.gO.Uc5febKE4rNDgjcHts
 AegQ2KgqCY7jJdhUE_e.IdvTexyOlfuK9vFWboIj8_gYwWLM8LD5Dva4HiJ3QV0yVZIj7YLir60k
 StPlQKJ2HwGNeEoz087MExxH1HXHwGObp2XbtS5Ka79wA_1JuJDGpwiqXjSYcHzQv9OYWOBwLKjF
 saGs8MLGDt261p9g42HOWEb9nnc0jKcBilKTkcWMSv3bbLcmGYob3WeS8k01zWqTvUqM4CQzqRtf
 Xn.DOad1eTt4UeAdSjmgFQpN8kFAr3IdkzA_CaDHNQlGA4Ws6p4bn.1fpIDu8J5Ad2pay4opdc2E
 82Bpsx0IIDXlZVQh5T2YVwIzR3ma4eCmabX67oIHHL24mgo_Id8uXtpdoWMmaybDP8IjM0vRFn0N
 tlcUl9je_AmBVMJ3YmoPnDkUT6VB.EN_Rkh1rw.ZFXVC2nNDHscLffWzHr2g0UjnQbdGOWLlDT3s
 orZFjpu.Oyd9DOBrYnZN2qqrJ7El89zB3Ej.NwO7iyf.DG.bmS4gUbDQdIC0NXUyP6OtEhzqkpzn
 fNQdaxj0Rr.8a3u58FQWUEDty7U.Akr9IYiAz6z9JbMZAr93y5LUHsIblnRNEsXtH2Q--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.gq1.yahoo.com with HTTP; Thu, 22 Aug 2019 21:59:39 +0000
Received: by smtp408.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID dfcd2820dec4a94fc52bf598cf6658ce;
          Thu, 22 Aug 2019 21:59:37 +0000 (UTC)
Subject: Re: New skb extension for use by LSMs (skb "security blob")?
To:     David Miller <davem@davemloft.net>
Cc:     fw@strlen.de, paul@paul-moore.com, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        casey@schaufler-ca.com
References: <00ab1a3e-fd57-fe42-04fa-d82c1585b360@schaufler-ca.com>
 <20190822201520.GJ20113@breakpoint.cc>
 <32646e98-2ed6-a63a-5589-fefd57e85f66@schaufler-ca.com>
 <20190822.141845.217313560870249775.davem@davemloft.net>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <e2e22b41-2aa1-6a52-107d-e4efd9dcacf4@schaufler-ca.com>
Date:   Thu, 22 Aug 2019 14:59:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822.141845.217313560870249775.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/2019 2:18 PM, David Miller wrote:
> From: Casey Schaufler <casey@schaufler-ca.com>
> Date: Thu, 22 Aug 2019 13:35:01 -0700
>
>> If the secmark where replaced by a security blob, the u32 secmark field
>> in an sk_buff would be replaced by a void * security field.
> You can already use the secmark to hash to some kind of pointer or other
> object.

Would you really want that used in the most common configuration?
Sure, you *can* do that, but it would be insane to do so.

