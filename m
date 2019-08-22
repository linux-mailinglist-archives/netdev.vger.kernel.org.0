Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B10BB9A2F8
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 00:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390885AbfHVWet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 18:34:49 -0400
Received: from sonic312-30.consmr.mail.gq1.yahoo.com ([98.137.69.211]:38979
        "EHLO sonic312-30.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390871AbfHVWet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 18:34:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1566513288; bh=THFbgmcdlBfNpoMu/4z/15ZZztg9HXgWK2GoqdBunio=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=XCja4onJYysoKDB25BOdnunv11JjaHTYHGTB1tfYPhiNZIro2Hs7Zkzo/+rjYdIxCngAgc9XKcyqh3vy1YQXBYKmCP7rWtRH6ELtbuKXfLV31DYa/Q3ifAMPbd9L2lkCiJIlTcAOYlKBN8kmJ1Dyj5Q2o/qTovg4GqUjTx94DcO2wuHwMBPY7ZkzrepwMEC2xR1mOX22vuuLXs7iIqgNTuvCxXi9be3VwDvjFiQc95QIXiyswP7/bF+VuOgTdPmhpXpiIgllemWHGUZGUKR4dPe/G1wrDCuSb4h1BI3AkCCPsXtAQauj6dMkHndjBuiD3rhJyJs1vf/5Nnma9OZBmA==
X-YMail-OSG: 4j1fksUVM1mim9v_GwlR96_TFSiV4kPP0fgFD_xJmduBHtrxAQGzOMeaElohTs_
 TcD0mH1bbElSva4fnNnLXH3AEFOh4E9wkj6u1CSHUIPtVp0RTjjHRebuI3LqTN8zetL1GyD.RWSn
 8CqCyug4ZB4A6COsKDnT_ewGCrXM_p79jkPGs9g14m8i5a5U1xYIZoNQTJT79D10hCtzUEj4UrWP
 XQELm2Mki.UV6SJA4ys2X4RVF3wi6TZYGYAu0w9fs2HvJKIJJpq_3diXqDOuqTD_NFzxUlrPhvdv
 ui_b1YZL5q30Z_TPRnOLijn8Bam6Sq7i5DH7xccPdkeR9NnMHgFXvF2pV4T3bg4zDxvL0Z4Z3MZJ
 0wsLW.zeA8AHCX3tXChj.0vq2kbCpXO_oX7mtYHE0TD8LvU1Jfx5mcTNrhAzwVLOvkBh7YJ7WJhF
 W_MZJGW.yiWItA5L5Tjo30uLhlx6m58ztHGRFX4gVjSs5owzGn2eFIlkmA.0iLqPQgUFGBI0YImf
 e6sO6gDcIctmwMlg8ZjBdKh38BrzBa60cO9tyMurr2DSXZiZBInGl62W6CvTfzzPMTwtf0b0l7kD
 XTQcyStx.MzZV6xb3.aRioTczyhgmRQ4PVCbxJdTbGJ3T1OKqiqlAKpO_PCJsIuwPVb3k1WVM0_u
 IpcrnolJjTNDW_joSYPe9FqoP8f.8McRjxqQpdoDMx9.lt8EGACOBJP9NglA68U3rfXzRDU8iDsA
 4QmL6Ko7LiX9jQ01tFQ8kypaI0BKx4e34rmMh0rCV1007eOvY6rkT6_oJG5.ZK.Sy6ozWO.dmufL
 LNo9znJoyxcUWBLXKZTitvjuqdvOA6NpBBDw7vrPE3gf0vZyiFrZCfkYf.HI7hZ6xtJd_40gUkvH
 b0iDH4nb4wIPT3yQSPlIvZonsrn7Md3t5kLyWdB77LJ7Cs3j2pzEzn5i1z12vrYywHlxabrUfNuR
 scmimAlEwciQPVk4Qt0kzPNxTzAqBXDnAB7Y1H_6K7s0UVR7qljmdjr4m1fPoMh4OIWMh8_RBgUG
 Srzkyv5YeU8UpmM2My2aTHlpnzV8OKe3jvmMMDzombkZz6ggLOmWqV3liK5QrryueymHnogW8ydb
 k.hQnRs.X_ELfdQorp7_Ng5fRTAtQXxbvu1RIuewaB.YYgSZdAFD3Y3AadobFTCmSufZjYzhMY1j
 zuRfx1T0ENZH8IoB62fpc4s6EtE0m9oCgIfguumPsGkvW43UoCTW6bEFxSJcDreZyg9QtctwzVMA
 rbndC5fmXl42S9xSnUlxx6KXRA4s3oRhidO3YhnJEGoGpCMAgQKQsM.Y9XlE13Dy6rR4-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.gq1.yahoo.com with HTTP; Thu, 22 Aug 2019 22:34:47 +0000
Received: by smtp431.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID a9c78b9af744263d7b1f81320c14035d;
          Thu, 22 Aug 2019 22:34:44 +0000 (UTC)
Subject: Re: New skb extension for use by LSMs (skb "security blob")?
To:     David Miller <davem@davemloft.net>
Cc:     fw@strlen.de, paul@paul-moore.com, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        casey@schaufler-ca.com
References: <32646e98-2ed6-a63a-5589-fefd57e85f66@schaufler-ca.com>
 <20190822.141845.217313560870249775.davem@davemloft.net>
 <e2e22b41-2aa1-6a52-107d-e4efd9dcacf4@schaufler-ca.com>
 <20190822.152857.1388207414767202364.davem@davemloft.net>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <5d524e45-0d80-3a1c-4fd2-7610d2197bf8@schaufler-ca.com>
Date:   Thu, 22 Aug 2019 15:34:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190822.152857.1388207414767202364.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/22/2019 3:28 PM, David Miller wrote:
> From: Casey Schaufler <casey@schaufler-ca.com>
> Date: Thu, 22 Aug 2019 14:59:37 -0700
>
>> Sure, you *can* do that, but it would be insane to do so.
> We look up the neighbour table entries on every single packet we
> transmit from the kernel in the same exact way.
>
> And it was exactly to get rid of a pointer in a data structure.

I very much expect that the lifecycle management issues would
be completely different, but I'll admit to having little understanding
of the details of the neighbour table.

