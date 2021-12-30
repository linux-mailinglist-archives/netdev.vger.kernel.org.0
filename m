Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3BB4820D9
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 00:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241659AbhL3XXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 18:23:48 -0500
Received: from sonic304-28.consmr.mail.ne1.yahoo.com ([66.163.191.154]:45659
        "EHLO sonic304-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240511AbhL3XXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 18:23:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1640906627; bh=Nev+FrB6z/t3bsN6K0oYX8DPdbnk00cvlb0T30nTpNg=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=a5HroqkG6xl3Xrzv74tKXe8H562XPt0F1VtdnsTHXTtT7U3fC/UrPJz2G9Ej1ZiveysD5NljI6bfn0Bo0n58UQN/bq7McUHFY61tuPMX9lcHJvGQptjMjKrPJDEg287IX5I1gh+kbR9HAsl2NN7xVnvbupIsX2zFyrFGKPbTlZAkJADg6iOoXZJ3LGXo89sVOQVWg7Cjiq5BMZA0CAyDuomnY5y2UqfBcxwVJBKoyxunYEAmmPpRxo0tmEE6AOTqOE0xyUK4R8atnpICY39VE8VwvPSKZdh2l/tE72ETRsF70FObzT4TY6OzPpMN3bf4zZZqg9fAql+S+lCCmHgRzA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1640906627; bh=h+FTCGLKVL3L21oVCiR7rb01APgIPfiFW2ZQVdKpysZ=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=g7FfKxPGocXuxpCK3r9TBqKo+vuqSgiDh/GNRfpNt5wyQpUvKu4GkRMSXTlxrdKjy1H7yT/G4XTntBmSPO1CRFvFRqHRmve8ogIfb3TFk2fU0muvkk2bal8GGB2lTIyfei9s+0rxK5yytwYNB0ic9RwMXR4widH3KGq27erT39yMb2PSl9zVvQPA7tRWJgnF9pUO1VmK/YVMPP+DDuAiU3tt7OKo7qOX8+xAtbq9ilK80xQzocdfJbSIKzND9jwYFrzopgrXNhV8/dp4N6IqikeOCYnZtwoSJks3bU/lflmsVwvQ0G7hUQeTBUTY/jkl9GId687sZt6Z7kL0S9aKzw==
X-YMail-OSG: nXhul50VM1kLu7tENZqganD7FmJ9oEOBx2v4y6TEpZvgWgpUzaDMi2.qYiOl5QW
 jR_wef7JRlvDYhv3czx4csk5VcPeUxxcatWFijbqH2p0LhBOFLrdoru2Q3VDdu0Ia5EuiDLvlNzt
 nWEkFM1jbb2asGHZ28AGCrdLj58JHA0XEabYiaVZLMi13Bc0V9Bk5dPltjfeI_ZfTJHpWvkyrl85
 6akha8CBO6Ghu6mfMSYFulNrfDjrMJ_.55pNGR2zHKNiYb4offGpisGX63WNKfWmzEnYpSULQihP
 Y.FjLsRAlkEhVnuXMY5swu6N3HuQwG7e1u8wd.SeAuucVuinP84GgN56ga0cvhtax876MG9ZO6e8
 RyAe_CP112NMSyvtQdS4MnEk6BdJu0pFNh9hg0ZsimdIooJzV07Srh2FzfmlGUUy_mhT6h7JmBgv
 8TpjAm0JHBOh_9SRIqYtPOphejDLd3O43228Ozfv8Bwvu.sINBI2vZDllpKhdvWcYuK9Db2uehQB
 Qy.n2htw4Y3C2Eok_HdchQJIc07PkAW3M1ZO_UOKqvPoK8smrFwD6990PiZOx4YGfo_tSqgUDfyA
 OnXr2qrP4WO7I2w8GjCGWubUA3T94B.bCeuHkzLP0QFzr2fJKKRke0JkcgcSrYr733_k3MkJrrS7
 w18hVtCIKL5VsZhxE.oNhzyEamM7yRurPKP9rLiy_wur7YP_74zsdqfLaZK.LbePBbEMEFJnwSTx
 uYbRp.K2j04SBcvH6POC1KW9pbs9o4dqiipwqQDo1hP3AXOHLNtrJrMA0x27dFqKW.CnwTmFZJVI
 GWyKIj0q9UdQJBggGzxMXNlGFWPVB7mNP_kFnnTzwyJpjzHcdhDUAKNlZ.vjHQfjIpzuXs_hT2hr
 tG3n9SbLuo8H8z7weiscr8YRtD_1n.B5adj2H.OS6vccKdKfY9__LM0znr0AjBgHfldDNt5p47JS
 22_3TEEwSvwVLixCzGjFDToCvcdpiwq7V7IMGfhpLC1_5U9Gn.9AMPImEjfNMtqCjrNfoercPERP
 I0HUBkwkkjuYZMXMx9O1ixbBpmEvNbZLAvUjEvIj6.E4u_doktUqkjqE46cjlw9WaXRSUlD6oalM
 YnDrtMS56Ym7fQ6ZIiJlf1ggkcia.a8hU8fp5Cg1lXngX8HiMOL.2cKW9DZP8gruzQTmBcHLtgCm
 1W_g62pM8It3nrfdgGSa8ZhcSDQQR4wo0GX.94XHfs6BrOM7YRcmsNxoUNDB9.cTRMCVOiCdyNPI
 W1VMxEucNEqp6JIiNRobW8tCyFRpNunC.ChH9lwGnRtQOpO4G51qC_eaCwFXwclk0pjeQMe4BDo7
 C3CW1qeKyv_xQ3W1BSgonekxlo0cX0N1xDl6HSYdtm61_uagXJQJeSQKV_8_B5gOhnlexJEW1mK3
 eG9Hk73qYsg0LMnD5UxDQ6jYn5_INE_Aw5bR5ZSgqYid2VeslNPQajxGoyIlGJ95dJB55pP3BIlQ
 BeZGmNGpBt01m2RANCP3LtxhfWa2j6SO5Fx7sQHGk1T8_gwvI3P.TElwK1VWOQWmHUDvNvsPMTYH
 S4z8ielZn7Qj2lZeI_ic591H17IPx1TYKb6Z6.KAliyDuUi_kyCl18ur24E8oRMUbbk1VumAScBT
 zgk8SZ_PlfuSHcP.wL3qyKtIqwmCaT91bq78dxDnIlZSx1ogAiIbYT.tZvS4FUCAmanfDbqh5cpM
 8rDY4ynOmS1YYxAwOOutGV6wY4WSzndpeFWy17TJD8C3BJY7LkCPHO.t9aupSxoadWS_dYWD7ne8
 KgBe.T4Dr2j1fPeDgiccvpCpEJJnOAHUnjavSsIhezkLM4vHRszgn2sWQKDFbcLtH9rBnRcShD2e
 Cx4cye..JXnJiuHpqOg5jq4G28RZ8ibhGeTyqL_4F11ZAUqEeJlW0RKmOisYxPDR3BQ0LmRP_54l
 Bgjm73MyWBqR.keFdNoZR.emsnd.Hlzt7P21STAg6Slid2.u0mHhVcEs4QjujY.kRykKomaivaJz
 Cdm94qeqI2IsqH2CPleGwGnws0KeE770NY25xIeM0LJFP49Pe3YNUyD0SD2JMBmdsqqGrpg0iTjZ
 HELdvaC1CCQICAXsSuWUdGZp7r_fPrBmqhi.M03AGQxWIgnZlU.JHpsIFs.S.4ItkhYPN84FcC.J
 w1xE_2WP_eaEuikvt8gL43KJEWzEPGOXoLePLk5BB1dBH4RrQ5tLk5FgDYbhiOzZIRJTjCvedE8t
 BmNyvNsrIjbv6bo5kKqabTnirB4mDb7Qan4SLwyP4Nh65cUGuXnOcWbkRFEBsRd0-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Thu, 30 Dec 2021 23:23:47 +0000
Received: by kubenode532.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 8db30ebf6771ecc8b273cac7e56a5d30;
          Thu, 30 Dec 2021 23:23:43 +0000 (UTC)
Message-ID: <15442102-8fa7-8665-831a-dc442f1fa073@schaufler-ca.com>
Date:   Thu, 30 Dec 2021 15:23:42 -0800
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
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <bf9e42b5-5034-561e-b872-7ab20738326b@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.19551 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/30/2021 2:50 PM, Mickaël Salaün wrote:
>
> On 30/12/2021 18:59, Casey Schaufler wrote:
>> On 12/29/2021 6:56 PM, Konstantin Meskhidze wrote:
>
> [...]
>
>>
>>> But I agree, that socket itself (as collection of data used for interproccess communication) could be not be an object.
>>>
>>> Anyway, my approach would not work in containerized environment: RUNC, containerd ect. Mickaёl suggested to go another way for Landlock network confinement: Defining "object" with connection port.
>>
>> Oh, the old days of modeling ...
>>
>> A port number is a name. It identifies a subject. A subject
>> "names" itself by binding to a port number. The port itself
>> isn't a thing.
>
> It depends on the definition of subject, object and action.

You are correct. And I am referring to the classic computer security
model definitions. If you want to redefine those terms to justify your
position it isn't going to make me very happy.


> The action can be connect or bind,

Nope. Sorry. Bind isn't an "action" because it does not involve a subject
and an object.

> and the object a TCP port,

As I pointed out earlier, a port isn't an object, it is a name.
A port as no security attributes. "Privileged ports" are a convention.
A port is meaningless unless it is bond, in which case all meaning is
tied up with the process that bound it.


> i.e. a subject doing an action on an object may require a corresponding access right.

You're claiming that because you want to restrict what processes can
bind a port, ports must be objects. But that's not what you're doing here.
You are making the problem harder than it needs to be

>
>>
>> You could change that. In fact, Smack includes port labeling
>> for local IPv6. I don't recommend it, as protocol correctness
>> is very difficult to achieve. Smack will forgo port labeling
>> as soon as CALIPSO support (real soon now - priorities permitting)
>> is available.
> Please keep in mind that Landlock is a feature available to unprivileged (then potentially malicious) processes. I'm not sure packet labeling fits this model, but if it does and there is a need, we may consider it in the future. Let's first see with Smack. ;)
>
> Landlock is also designed to be extensible. It makes sense to start with an MVP network access control. Being able to restrict TCP connect and bind actions, with exception for a set of ports, is simple, pragmatic and useful. Let's start with that.

I'm not saying it isn't useful, I'm saying that it has nothing to do
with subjects, objects and accesses. A process changing it's own state
does not require access to any object.

>
>>
>> Again, on the other hand, you're not doing anything that's an
>> access control decision. You're saying "I don't want to bind to
>> port 3920, stop me if I try".
>
> This is an access control.

No.

> A subject can define restrictions for itself and others (e.g. future child processes).

The "others" are subjects whose initial state is defined to be the
state of the parent at time of exec. This is trivially modeled.

> We may also consider that the same process can transition from one subject to another over time.

No, you cannot. A process pretty well defines a subject on a Linux system.
Where the blazes did you get this notion?

> This may be caused by a call to landlock_restrict_self(2) or, more abstractly, by an exploited vulnerability (e.g. execve, ROP…). Not everyone may agree with this lexical point of view (e.g. we can replace "subject" with "role"…), but the important point is that Landlock is an access control system, which is not (only) configured by the root user.

No. Landlock is a mechanism for processes to prevent themselves from performing
operations they would normally be allowed. No access control, subjects or
objects are required to do this is many cases. Including bind.

>
>> All you're doing is asking the
>> kernel to remember something for you, on the off chance you
>> forget. There isn't any reason I can see for this to be associated
>> with the port. It should be associated with the task.
>
> I don't understand your point. What do you want to associate with a task? Landlock domains are already tied to a set of tasks.

That's pretty much what I'm saying. It's all task data.

>
>>
>>> Can be checked here:
>>> https://lore.kernel.org/netdev/d9aa57a7-9978-d0a4-3aa0-4512fd9459df@digikod.net
>>>
>>> Hope I exlained my point. Thanks again for your comments.
>
> [...]
