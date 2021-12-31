Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315DD4820F9
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 01:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242368AbhLaAVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 19:21:49 -0500
Received: from sonic308-16.consmr.mail.ne1.yahoo.com ([66.163.187.39]:35392
        "EHLO sonic308-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233018AbhLaAVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 19:21:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1640910109; bh=nxhR7UYX/odb7gfWh6xmKUk4pkVVvEwbriMukrNU3tE=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=lsFM2oKFcvE3pu7kuen9fagcpKxN+H6nLlPYKAuqoTo5Q9ysgUT1Ooni7ZVGnVg4D9Wis8e9yaSebtU7c0h9MYY/zceDify8eYFOvFEPI1p86LHu6i2uF/oWgIq5JzY8t6GfW0cZL/WZY+w5+hh0ztaaB6vEy31Yt9eG/XD7Av/56+tLiWIsWKaBkhOwKzreNelpXuI7PDcO1VX1iKlujlRR6q2QcwdyxykAabydRbTaR1u9R9br9PYTBxTcNGaaFYCNGxKYBSa1RGxdPAbz1rTUwTbHFNC1iRGBB1QtLIGvJ7eDC3zX2EXMr+gAmc4FqiGPs9YcUdezvH87FR10rQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1640910109; bh=qS7Bko7Lj2GzG8DfpLVTdjMknegT030WeUssUoIht0Y=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=EaStMz+6KeqVF1qv6rNSJud2hDslBaL+9D3DKm2tZQp44tCwfKMMlmUqKux7ycwoLLUndHNHMV6X+6nwap4wnlVJbNg2uv4iyXdjiH1zuRUbv7goBsT/S5uDC2pYeFjuYTVwYZGB0wRWqhrGOJolW96IyAhQD+fXlVk5K4gYB7lQX5DAiyM3a4kvcnBi3H1VjCqezIb5b1BbdEwvd6jxjNfAMB9H3tvrubRkke0FFR98A2Zvvo3bwvSgmK439F15EyxKdlxXEh5XzFyLiCx0TC1Ps+xRrCWsnS+PvuCGC8bCRsOqsaKa40pgcc7sX+poWZMP/W1VqrtVu7gnA98QHw==
X-YMail-OSG: t37v.RMVM1lN8xj.GAFesf4VIEKYy8YMq6gxVG8BZgK32f3NPf8Oeppl4m1NgzK
 nXy83KBnahSigupfBukDajq.9QpsfiGycN826TqmCBAoLGtFw_8WEi_UtR_.DWVUIuqRWzVw5gCB
 cKfMwBHtG0s7R39YrNcPEJKYqfja3VyuBRxoRgDFW0DKvrEVH1iv6O6ggDRwcTXE.ZP6Zb4MebcD
 NpamYQAJFuRypUnwLMIxwqGFzXOlnUykltLa0AHzkGASjE0ZJ.a0i5jnK7So3qARAV9nfX5a_Ydq
 lCN_HHgLpu45VbMAQx6uS0HMj5lJn_DudZgS98w.rZvCM0HlsXYraXZThxOIRjhDg4b8bZqrCtW7
 2pMwvj.2ZW00O3ijsJI3FEu.J0Thmo7DtFJjRq1QiMfasz6NCcybd70llqK.v5PyfUZBZab6x89F
 5EQLLiGGraORCyz3eG1st.c2Yw.ZDugMzwZBJVXMSN6kz2vwu8ouddgN_ATu26NTaLIqZUZSj2v1
 NVFu0cGCj9a3LX37RhvFwBnAqCuSzRpDfotu_AwbDqjNSTeoghpbMorRSSruejmw8twvuumc9B2U
 snAyjNHnROUSZuzLXYLewnekPWPsOjIBkNwNCZRsjGqXQh_ntsDtAd9FOFxiuF8KiV8T6DEkwV0c
 U1Oog9DJnJGjt8eJ34LpVtXVhWjoCuAnODbDOHzU2pKDwf6y0YQcYMqgbw3nARKql.y_mrNNca9b
 E.E4.l3aeinFLmO0PjuFbDFBW85iRhTmv.BoSnUFBQRsGgI8qOxXAXJ6WEJsm_nm3By6VXI9u4wn
 ZUktEzJgE8xltGzhPlHw7ZB8T3UAEYmUnQdl_kjHluJaBL4WLgZr.K6tWlDrwJJvURsauqxG0kqQ
 f5PFZhBLH3kSUUkJJ5ED9DaJhOw8YqruVXHasdl6d4A201Q5OJAg0n9B.O8.LIxKnG4EFG6T9GKz
 UNHo_IAg0XYy5NGbnKjo2zrwWl2y8egORElMPqogTJtDQKjDA1kIJpAtLa4I1NXiYAbiQfgsAkVE
 mnNDfjoviZlcNJ68Ui38qy3kmsn_Wpw_2mDTtlZx_GP04ZD0MBcCFimfa8.2xLWJUmyipCcfPux4
 eLMJCNp_btnzCvNTnGdFih1U.HJlNnkWfB0feoaWHKfllmejE7kNx7XN.V6cxgeEX619APGj0GID
 ZGDIDFaPXzkRO66BjQM5wQnaRG6DLpOfgehC2Q1YrP5akyvCBZ3HgrDK7PWndySVNDQwKWeSgnqr
 V.KC3JTfqhXTvCKEdp3hbVr68N7bgnKtF_CXTMIT7GjTlx.CrfVA6UCUz.01XRW3FqByukUQzlpl
 RMnaduJtFwiguUA3LzJzD5LKsS6zeBFvfqSfV4S19nTpZK76v6zYG4FoMmLymaP8PEPgT5_e9c1V
 nHC2OiaXLptrhLkZvGJs1GXrLby7BU7Rpo36BKWgXuvdWjbu1nVOwSR8n5uOVxqk8wzX5o.hE.4f
 DHmQRhab_7GUMicYGgsIlEph0Mmqd9IkZ8PRXPrhL0gnv5qyhl.WSJpkl6yz3pKQfjZpPfEs9kzP
 iypxoSu.VpWKTf25lmW3QUon0LrFAFIpzqJIlma3568UrEd14PnXoH7UMuv2bnVq_Q_3KBO8y8LQ
 K4XwTh27Jxsq7nx1TFiucEQqfBiXXIa1RcuV3K3vS5oTLl0_iiOkjOnxxEW.iAMil9FKbSP276OW
 RxTfXd1J7IqTymoHLvmHWOR86MyyfU.1DH.BL7p.DgUNn11NOf2l0VJsTvFO4tx0bvmyXjdZ0cqN
 w.zOtaju9Tt8Y8dgUd1AuRxD38xdHgCIJOZR92Jn.LDd1lRQoE_qIrcTx6UtmvS0Hnt_UHb67phn
 U8UiBBQjtb6MvbOHwrsJMdi38xwLUNV5_1ERG6V5bc9ZxURN.xRao6gQJ3TiF1kkwkA28ulJVqYl
 v9XXQpNJApIt3dd75mAhG_T3SAR.0zH9AvHsPlJs8g7m5C6MsWOGWS5i5s2gUGV4c.yp8Lh5OwOq
 .mB921nNM3TfkOLM_L432GmHo5b8YmtA_hNtN19l_0xcAgUe8SIrkStLX9GI6e4JDfR9zNi2HbRU
 zqe2Dg8Zet.sPLgV2JeP_IR7M6AZlowU8YR4wxhrs.a_b0X.m.X9s6qRW_MXXyE.KdmP0rrhFrWX
 fvHkENH.sVjClaf6sOShM6ZB31FRKr8VaDtkqdmZb93oFPCv3ixGi_7lMq3eXnKZa5orGYkW9nnc
 _j9oRT9E.rW_2zuJdugaHaVpmIddXKpkbk9K99BOhhEspfDu3dYBy70SLHRGP05T6Hz3R
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Fri, 31 Dec 2021 00:21:49 +0000
Received: by kubenode532.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 00c69a60d0a97c60d9fdb048a2091845;
          Fri, 31 Dec 2021 00:21:47 +0000 (UTC)
Message-ID: <3a389006-6080-575f-37a1-364c5e1a3773@schaufler-ca.com>
Date:   Thu, 30 Dec 2021 16:21:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH 0/1] Landlock network PoC
Content-Language: en-US
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, Casey Schaufler <casey@schaufler-ca.com>
References: <20211228115212.703084-1-konstantin.meskhidze@huawei.com>
 <ea82de6a-0b28-7d96-a84e-49fa0be39f0e@schaufler-ca.com>
 <62cf5983-2a81-a273-d892-58b014a90997@huawei.com>
 <f7c587ab-5449-8c9f-aace-4ca60c60663f@schaufler-ca.com>
 <bf9e42b5-5034-561e-b872-7ab20738326b@digikod.net>
 <15442102-8fa7-8665-831a-dc442f1fa073@schaufler-ca.com>
 <a24ffb44-8f3c-e043-61fa-3652e3e648b1@digikod.net>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <a24ffb44-8f3c-e043-61fa-3652e3e648b1@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.19551 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/30/2021 4:00 PM, Mickaël Salaün wrote:
>
> On 31/12/2021 00:23, Casey Schaufler wrote:
>> On 12/30/2021 2:50 PM, Mickaël Salaün wrote:
>>>
>>> On 30/12/2021 18:59, Casey Schaufler wrote:
>>>> On 12/29/2021 6:56 PM, Konstantin Meskhidze wrote:
>>>
>>> [...]
>>>
>>>>
>>>>> But I agree, that socket itself (as collection of data used for interproccess communication) could be not be an object.
>>>>>
>>>>> Anyway, my approach would not work in containerized environment: RUNC, containerd ect. Mickaёl suggested to go another way for Landlock network confinement: Defining "object" with connection port.
>>>>
>>>> Oh, the old days of modeling ...
>>>>
>>>> A port number is a name. It identifies a subject. A subject
>>>> "names" itself by binding to a port number. The port itself
>>>> isn't a thing.
>>>
>>> It depends on the definition of subject, object and action.
>>
>> You are correct. And I am referring to the classic computer security
>> model definitions.
>
> Me too! :)
>
>> If you want to redefine those terms to justify your
>> position it isn't going to make me very happy.
>>
>>
>>> The action can be connect or bind,
>>
>> Nope. Sorry. Bind isn't an "action" because it does not involve a subject
>> and an object.
>
> In this context, the subject is the process calling bind. In a traditional model, we would probably identify the socket as the object though.

Neither a socket nor a port meet the traditional definition of an object.
You don't need to have either a socket or port be an object to decide
that your process shouldn't bind to a port. All you have to do is mark
yourself as "unable to bind to port 7843". No access is required.

>
>>
>>> and the object a TCP port,
>>
>> As I pointed out earlier, a port isn't an object, it is a name.
>> A port as no security attributes. "Privileged ports" are a convention.
>> A port is meaningless unless it is bond, in which case all meaning is
>> tied up with the process that bound it.
>
> A port is not a kernel object, but in this case it can still be defined as an (abstract) object in a security policy. I think this is the misunderstanding here.

"When I use a word," Humpty Dumpty said, in rather a scornful tone, "it means just what I
choose it to mean—neither more nor less."

>
>>
>>
>>> i.e. a subject doing an action on an object may require a corresponding access right.
>>
>> You're claiming that because you want to restrict what processes can
>> bind a port, ports must be objects. But that's not what you're doing here.
>> You are making the problem harder than it needs to be
>>
>>>
>>>>
>>>> You could change that. In fact, Smack includes port labeling
>>>> for local IPv6. I don't recommend it, as protocol correctness
>>>> is very difficult to achieve. Smack will forgo port labeling
>>>> as soon as CALIPSO support (real soon now - priorities permitting)
>>>> is available.
>>> Please keep in mind that Landlock is a feature available to unprivileged (then potentially malicious) processes. I'm not sure packet labeling fits this model, but if it does and there is a need, we may consider it in the future. Let's first see with Smack. ;)
>>>
>>> Landlock is also designed to be extensible. It makes sense to start with an MVP network access control. Being able to restrict TCP connect and bind actions, with exception for a set of ports, is simple, pragmatic and useful. Let's start with that.
>>
>> I'm not saying it isn't useful, I'm saying that it has nothing to do
>> with subjects, objects and accesses. A process changing it's own state
>> does not require access to any object.
>>
>>>
>>>>
>>>> Again, on the other hand, you're not doing anything that's an
>>>> access control decision. You're saying "I don't want to bind to
>>>> port 3920, stop me if I try".
>>>
>>> This is an access control.
>>
>> No.
>
> :)
>
>>
>>> A subject can define restrictions for itself and others (e.g. future child processes).
>>
>> The "others" are subjects whose initial state is defined to be the
>> state of the parent at time of exec. This is trivially modeled.
>
> This doesn't change much.
>
>>
>>> We may also consider that the same process can transition from one subject to another over time.
>>
>> No, you cannot. A process pretty well defines a subject on a Linux system.
>> Where the blazes did you get this notion?
>
> I'm thinking in a more abstract way. I wanted to give this example because of your thinking about what is an access control or not. We don't have to tie semantic to concrete kernel data/objects. Because a process fits well to a subject for some use cases, it may not for others. In the end it doesn't matter much.

Then don't use the terminology. You'll confuse the next generation.

>
>>
>>> This may be caused by a call to landlock_restrict_self(2) or, more abstractly, by an exploited vulnerability (e.g. execve, ROP…). Not everyone may agree with this lexical point of view (e.g. we can replace "subject" with "role"…), but the important point is that Landlock is an access control system, which is not (only) configured by the root user.
>>
>> No. Landlock is a mechanism for processes to prevent themselves from performing
>> operations they would normally be allowed. No access control, subjects or
>> objects are required to do this is many cases. Including bind.
>
> I don't agree. An access control is a mechanism, backed by a security policy, which enforces restrictions on a system. 

No, that's the definition of privilege.

> Landlock is a way to drop privileges but also to enforce a set of security policies. We can see Smack, SELinux or others as a way for root to drop privileges too and for other users to restrict accesses they could have otherwise.
>
>>
>>>
>>>> All you're doing is asking the
>>>> kernel to remember something for you, on the off chance you
>>>> forget. There isn't any reason I can see for this to be associated
>>>> with the port. It should be associated with the task.
>>>
>>> I don't understand your point. What do you want to associate with a task? Landlock domains are already tied to a set of tasks.
>>
>> That's pretty much what I'm saying. It's all task data.
>
> OK
>
>>
>>>
>>>>
>>>>> Can be checked here:
>>>>> https://lore.kernel.org/netdev/d9aa57a7-9978-d0a4-3aa0-4512fd9459df@digikod.net
>>>>>
>>>>> Hope I exlained my point. Thanks again for your comments.
>>>
>>> [...]
