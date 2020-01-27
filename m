Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7642814A90D
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 18:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgA0Rel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 12:34:41 -0500
Received: from sonic316-26.consmr.mail.ne1.yahoo.com ([66.163.187.152]:38842
        "EHLO sonic316-26.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbgA0Rek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 12:34:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1580146478; bh=A/ZYBcsKjndslC0dUgOAmvGgLpzj7T5uRCYfgFS3GvE=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=oD/eweIdtKTSTazSa57JvtWG/Ur6KJau1xTaDaXu0fn2kE7mHLIM15rWDnBv7CbzbrumR6S62Moz84mkhs7L5mo36hXdBO/EM7NkQWMVFEhP3qBa4B7FIXHkL0AVS0eI0ymgmlMG1gAnvhSnFspmhr6KtIMnwuex9ak8fk6f4HFiyeSRFXqxCIK9Q0Ya1kbiCvoHVYXNYByqOtPw23lObnZA8EXJrnPoUG35zG/nsCQtAjtHUfxHxRCXPIh487uusbeZbSqOK9yVRaOquwW+H64CXeZcb+zghECA3gz1mgbivkjP7h1pV/UoNj3JxaiP7KnPu220dtuhS1Sgagc81g==
X-YMail-OSG: UIEmYk8VM1nUFo.TG2huX.9Yf51YUwgGeR8.Rvcw3gyDo4HZzBN2aLT_OB8VGHI
 kS7rbKIRDliKAg7ib45TdfcTIc_xLiJ1WKXWdY1T7GW4Puc4ZvA52vaO.m8o4Ab3iCESw8KADzma
 PGluHQSY602GWkHEtwo0iPPb3M4bof.lL2bsoa.CrE6RcXJVRQaqgwU72v8fP73E2wexNDoSxNly
 rOvNoSpi610HvpH20r8LrzJe6hreZa_6KZ3zRuASUqjWAF.f7bz4C01idFzW.vcFnfgAXoHkt13k
 3qujb9Bprbg3lYbOop0IoE_Ib6LWK5mXONn3_kkJRxgIXCFnUr4PbIM275ZpzljexMIx1WafrCQF
 b4bACrL1105_87yi1A3cTBWk8zrnjaVBfB.bPlxev4nJOytcU840_VMc7oeMfALnYDCHpA783Vg0
 xUp8_wmq3XuF8FOdslHyRPtDuFBGoplpVr90QyXUgGv9MTOivh5Ka.AkpIcFY4WQLsqehA0Pnzx.
 .vWVaTnTfpA2M4p12oKeXMa0IVmeV3a2kMUgCIEo4iQH.qq.zIn354f8MMAqt1Q7xoD6yiV8UGKT
 v5_yG.1rixf38soN.FiiltyrA7DOX3ULseALlv6iBrqVQkvHQtjMXnXwBq_rXjBY.1ag7mvYjc4P
 WjlRlhFNAo7PsPH7eDT6rdd7Mkq7U.rKion58rhW33AlQc1lSSVeDw8snQztC_jqmW498bp_KRGQ
 b380DccyPa88oLc9YLtwSALuNIL4F6euqqj1WDW6U0zOTV3SYG5xS82WQoUu6027T2AtCFQdkba1
 CbJaYp9r1nMQJ5iHpzwmWym8OtnCM6b99YAabd3blil4Z95bpZgBwBQY5LnP470v4xWZEOv.8Dch
 0m58RKwW38RfnQaLO0euItesA8IlIsmOcqwFtt.kvIC5AVCUcfcMsgqsMbu70hxulzVdycTJV9qA
 Kl6.lT3carJ4JpnfWNMcjbIYUJ1tfW1CmyAC7q2oNq.zmxQ9lfhctTVYdT6Fu5Zx4zdIkI4l2O_E
 N5qNg1UWqtvet4Xf8NlZfN7_TfRyjNbjf9J9B4YARcTnAyu3HQ9Z4klX7n4uNFTYPpsXnAX2_UuV
 3SkcZV9hz54bALb22w8toJKqd50IGJjjB7qH.zjt4p3cileUt3ozvy.DmtUO2rFEkUilQEYWUc42
 9wu05HdGCmzwyAjSRTT3Bfkgg_8GfrxfcMNKzB2pIFDLpQKbPv42zOWcyG7Z0jAzujHo0K5fvLxh
 FdT639sycg8aGvwzWQBXX4mYUfNSQiHFkCIrNVA458SyEdmQbgwBaZcQNo7qnEsu.I8D_xHIbDcN
 LQdxDicOW6m9ATstAdC38W80PRhnZDk0vj2NDmg0hkfMr2d9w12cc8Izs5q9hYRRX98HQcksJqIc
 FAD9Ls4YWSPs3Nwv.Ii_KXKdvS1f.Vw--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Mon, 27 Jan 2020 17:34:38 +0000
Received: by smtp429.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 0e6883b3604d029b21a83e85a9420c9f;
          Mon, 27 Jan 2020 17:34:33 +0000 (UTC)
Subject: Re: KASAN slab-out-of-bounds in tun_chr_open/sock_init_data (Was: Re:
 [PATCH v14 00/23] LSM: Module stacking for AppArmor)
To:     Stephen Smalley <sds@tycho.nsa.gov>, casey.schaufler@intel.com,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org
Cc:     keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        lorenzo@google.com, "David S. Miller" <davem@davemloft.net>,
        amade@asmblr.net,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        maxk@qti.qualcomm.com, Casey Schaufler <casey@schaufler-ca.com>
References: <20200124002306.3552-1-casey.ref@schaufler-ca.com>
 <20200124002306.3552-1-casey@schaufler-ca.com>
 <22585291-b7e0-5a22-6682-168611d902fa@tycho.nsa.gov>
 <6b717a13-3586-5854-0eee-617798f92d34@schaufler-ca.com>
 <de97dc66-7f5b-21f0-cf3d-a1485acbc1c9@tycho.nsa.gov>
 <628f018e-5a88-295b-9e4d-b4c6a49645b5@tycho.nsa.gov>
From:   Casey Schaufler <casey@schaufler-ca.com>
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <736cf361-1eaf-2d5e-ffc5-c5cda6e2ec7d@schaufler-ca.com>
Date:   Mon, 27 Jan 2020 09:34:33 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <628f018e-5a88-295b-9e4d-b4c6a49645b5@tycho.nsa.gov>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.15116 hermes Apache-HttpAsyncClient/4.1.4 (Java/1.8.0_181)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/2020 8:56 AM, Stephen Smalley wrote:
> On 1/27/20 11:14 AM, Stephen Smalley wrote:
>> On 1/24/20 4:49 PM, Casey Schaufler wrote:
>>> On 1/24/2020 1:04 PM, Stephen Smalley wrote:
>>>> On 1/23/20 7:22 PM, Casey Schaufler wrote:
>>>>> This patchset provides the changes required for
>>>>> the AppArmor security module to stack safely with any other.
>>>>>
>>>>> v14: Rebase to 5.5-rc5
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Incorporate feedback from v13
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - Use an array of audit rules =
(patch 0002)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - Significant change, removed =
Acks (patch 0002)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - Remove unneeded include (pat=
ch 0013)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - Use context.len correctly (p=
atch 0015)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - Reorder code to be more sens=
ible (patch 0016)
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - Drop SO_PEERCONTEXT as it's =
not needed yet (patch 0023)
>>>>
>>>> I don't know for sure if this is your bug, but it happens every time=
 I boot with your patches applied and not at all on stock v5.5-rc5 so her=
e it is.=C2=A0 Will try to bisect as time permits but not until next week=
=2E Trigger seems to be loading the tun driver.
>>>
>>> Thanks. I will have a look as well.
>>
>> Bisection led to the first patch in the series, "LSM: Infrastructure m=
anagement of the sock security". Still not sure if the bug is in the patc=
h itself or just being surfaced by it.
>
> Looks like the bug is pre-existing to me and just exposed by your patch=
=2E

OK, thanks. I don't see how moving the allocation ought to have
perturbed that, but it's good to know what happened.=20


