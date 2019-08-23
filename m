Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFDC29B68D
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 20:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390920AbfHWS4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 14:56:39 -0400
Received: from sonic315-21.consmr.mail.bf2.yahoo.com ([74.6.134.195]:42912
        "EHLO sonic315-21.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390803AbfHWS4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 14:56:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1566586597; bh=cqaUxta/pT8unQJ+ttunQCK8bIaVe1d/QYPhUjE6xGc=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=CLPcQ+nxNq/tEuXACQfEUcZ3XpO0OVkd7UkbGC/a53NpgH16bR96EpqaLZZKKID9cZZrNZCF4tp8Gl+879Dkonn3wxmqAR9UVGleflz6qLxEf2s+IzZu9z90/fPYrYd5uC2f0A0lzoyBfUNKxTMNoQpRG43pllDjYw065irTjeokGwMDc0OOsWE43plaGGx61TEOoeWe4PxKRYxaBJByLxHu1W28CpFQ3qmfA6I7xFnJ9fqedoNEuK8TGsRMi5Tmf2Js5KogOQE4Rf8o+C4oHv1oB8PQfFtqWiux6lFJ8WnPpS2zTVMrlA1PF6l7y6q30FcjC18gNrtpufojoZKSfA==
X-YMail-OSG: Af6kOfMVM1l7GiNJRbjyR2TaCXO05u7ue9p3sRiKNc7WRgKY.o8.picezGVXnTx
 HGi1vpaIb3PBX9k1rZK8CqitU3yWBSy0b7mSSwQe3MXLQcLeqpEeLqdspr4yeoync5lSsbkPxVkY
 PVXKEW0yEN4xVP.Yib2Duk_LTnP9zt.Z03jBTNXfEufBvqB602ZyRuJoZEUVWMdJKd0g7qMucYDV
 DlEddrQ8QX3FW.2T9LXIl9RdHnLWGEKhsRI99PbM79ROA22NfWxE3NkIRIkLUw2Ey6qRUeuoqjZ8
 TAoZDF12Q.9e9qSKBl3U9G7Yr50t9IoFZRUqBo.Bhs7CODbxYT_Kb69xuaQmiZO5cQoqnkZ.ATkR
 OEDtgWdtpqOiqL.zudTMmHAYCeo6dup2_0MRed3Luy8wbSIpO3FcnS2tadsP8PXFX7VpoY0gZ2ND
 Q.DXgnaJNq6QuDXUkVkhWG1psakNdYOvvqvwRkMgbvhxvmpGt86Upr1b2srbzzPoeIXyCjFHBfYN
 ZmbZid8nuW4PgXLKeX09Aa_44coIdrv49TqSbdqOrSJ9q3sEHo5_c42V6NaLxAsq4COZTGS9BN.l
 rF7uMlKA7xHDKIHv3TteBPicmWLtO7.xigfDCxfGTQyXa3yzbN9FCg_kz2rWxJjIk1Pl2jnsv3bh
 FhXpo.jrg9Y2zNXM2WdwFZrwx3wofTDDh_46skeTq5K0rioZO_XIv1GAxkE_gSAzAcEght5yFjU2
 Gp4bg8R14PcxdWkROLR8cF3NIZBqhKNRvG4U197lmmhY0tkcsxYv5u7Y3mvX1r..x.ZLUaWvRlxT
 tzsNybEHvD.ggYUtuI.ol4WljP8LurRAPJVZfHEdafpeWTaYkincnDGOi0fkZAMfRDAGd1ifgGL.
 1jjFV2WF4x9h9p9su2e739ZPr.9yXIpW6ULTbb1I0C9JSsvO191UVm2y8RhCYyuuIZBA8dPiUXCL
 bTkksqoCduQgLBdu2rGdBoNv_LXTKsC0cS86NQoWiffTPWWGaBftNiZHxL77gmcIgdE8X6WbKzwM
 jWbYEBOuxSymZ4y8xYsmPVhWXfOlqKLG6D4MQpr9mahYejzAqujzpzn_H6A1a1yL_P91ZumKT1SE
 BrzfYf6cjyvTuaz7VI7YAZym3igLXuUAHO2Hm6b25f159wdkNAE4_82jWcirv5cvYHP.5FCUWWhq
 Ws5IzqkCT4we3c9u1.aiI5PQbDSu5cmex0yON3hADsV5_OelYPVwbaGWYhOm.YeDat_YS0JnObx3
 cCkkzLRHmbPxkDQ9BsXTlXxaagybIUHhoEVRCbl22EVYZ1KTrM0CvVbLBawM5ZQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Fri, 23 Aug 2019 18:56:37 +0000
Received: by smtp413.mail.bf1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID fe6a3e7576acbf8d549b1cb40353c7b4;
          Fri, 23 Aug 2019 18:56:34 +0000 (UTC)
Subject: Re: New skb extension for use by LSMs (skb "security blob")?
To:     David Miller <davem@davemloft.net>
Cc:     fw@strlen.de, paul@paul-moore.com, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        casey@schaufler-ca.com
References: <e2e22b41-2aa1-6a52-107d-e4efd9dcacf4@schaufler-ca.com>
 <20190822.152857.1388207414767202364.davem@davemloft.net>
 <5d524e45-0d80-3a1c-4fd2-7610d2197bf8@schaufler-ca.com>
 <20190822.153642.10800077338364583.davem@davemloft.net>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <b090707c-7ddf-d046-7517-438434e7ff65@schaufler-ca.com>
Date:   Fri, 23 Aug 2019 11:56:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822.153642.10800077338364583.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/2019 3:36 PM, David Miller wrote:
> From: Casey Schaufler <casey@schaufler-ca.com>
> Date: Thu, 22 Aug 2019 15:34:44 -0700
>
>> On 8/22/2019 3:28 PM, David Miller wrote:
>>> From: Casey Schaufler <casey@schaufler-ca.com>
>>> Date: Thu, 22 Aug 2019 14:59:37 -0700
>>>
>>>> Sure, you *can* do that, but it would be insane to do so.
>>> We look up the neighbour table entries on every single packet we
>>> transmit from the kernel in the same exact way.
>>>
>>> And it was exactly to get rid of a pointer in a data structure.
>> I very much expect that the lifecycle management issues would
>> be completely different, but I'll admit to having little understanding=

>> of the details of the neighbour table.
> Neighbour table entries can live anywhere from essentially forever down=

> to several microseconds.
>
> If your hash is good, and you use RCU locking on the read side, it's a
> single pointer dereference in cost.

The secmark is the data used by the netfilter system.
While it would be (Turing compatible, after all) possible,
we're talking multiple attributes with different lifecycles
being managed in a table (list, whatever) that may expand
explosively. Using a single ID to reference into a table that
could contain:
	secmark from iptables for SELinux
	secmark from iptables for AppArmor
	SELinux secid/context for the packet
	AppArmor secid/context for the packet
will be hairy. In the netfilter processing we may have to
allocate a new table entry. There's no way to identify that
the entry is no longer necessary, as there is no lifecycle
on a secmark. Is it possible to come up with something that
will limp along? Possibly. If there's a blob pointer, we know
how to do all this effectively.


