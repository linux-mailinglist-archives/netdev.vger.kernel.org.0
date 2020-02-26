Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86D1B1702A8
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 16:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgBZPfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 10:35:54 -0500
Received: from sonic315-26.consmr.mail.ne1.yahoo.com ([66.163.190.152]:36406
        "EHLO sonic315-26.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728358AbgBZPfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 10:35:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1582731346; bh=huKjnpz3nP4S9wIFw5a7/66HugfjSw/J6XlBMt0G9/k=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=S96kvAsp6OBxkxjg1ADwSSjAl7+AZPQx9gyzTolz5CUYtV5xJigD74HMYMvEjfuF9fF9yLUgYEi84OGJHYpxIGy6Pc3uJPG7YlUZ0PJmQOHmMODiJOboc178gP/yAcPR8wJt8aBn2Mly1bMmTEtajqKcVCGVRVjmkyuzEKK4i3YLAIcI42aeM0YOj2cgMWzuCBIvF2ZOI6WjQKo2C6T5Z06eRUHUWdK/JR778qOjJuD03iUDvNUcW7VIRHcRMWznY3RX+xQG+XrC35QVdPAdaR/1AgNutE2e/+fa77gjcHpJK9HdY+s9a7zSHkZ0i4gEPjqzSB+212nQA+TJi8Hv+A==
X-YMail-OSG: Q_iLyWsVM1n7eIw7q0dCW9FPo87KO_Y1kn8vCIRvB0cl_1dpjLnwlVjshvMuFWV
 tj8Zq2.RUKEHQwRk1EwuIXWGrmR6bXpG.v.h0pGeOqj8uGUQPXge7ctbXkcULaZAOW5_4NJRPHgg
 7_reT5qb0V1TpxtLFMfrYJHIpHMl0vnTIIQB424jRutIJylGpzTA_oH_r7dvhDNZTtvCJ_7QP2Bj
 yah7VB_NghxM4Zo2vDCu_SItl0P6wEbyiKABNX8ZEWpAObGUeUKgkwUIQdpDvT0vJvYOIQjmlcaI
 2YAdZ27PWtMgEMJyL8bjG4bHW4CToL0SXzfs4WeySaU.vJj2W3uMNvr1luHVEIVuThzGxCGJGJiE
 PEMEYDQhFXEgwy3hVPksZQPSs5MkuJwRUDwmUfsrSPTLakQ6TE6QXX4x529EA8oAzhosG3IFp5kO
 nZr83VM5tIpgLyLN8qIN4PnfVk7Sk47oPjPTzAL87arUlJsdBCkc27Cvl.n8cc1fc2UZzYccjNHu
 ThpGD4bffMqQ6vYdP7Hgbp_NCs7Oy5g.fUsPjiB.QMVUygjSklwBIlC_EOTVL4ETRIFPTHHkgGYu
 scevYp1t3QdTB_.bEZXudHHrK1qHuU_.wd8JnhEdkR.q8XijznD4XM8KAZHKgUVaLDWN8_x_3Qxw
 73bJcatCXVpGKx7vH0S8xMJFl0IQ3RQIMkBf_p8frSU8LrzX3.ZGDLBsRe6TbcxYJfFq0oPzmSGw
 4eNDjiPQz5j8knR0YUDbqhXRz4Z5Nbgy77X9tFUAF0.JOMK4cdSUxXP2Yb2v3BmbE9gRzqbjkwsd
 XRiikbXj7ohR096tGJfVPmTfNTB4vkjVw4har6Bzad0.dbAn1oZ28GWGiUtFecmwl.3U9U6Tezzy
 JhWwEvqd40tQHuFrzMKH_7CsM261k82OmDC27nqlxR075PZMIkjfB4ShyNzimWi3JyShijWBqq4B
 uZsMWrVFL9_oFFWcOmJDjLoyosG37GJQRkSbaQ7Rgp1HAotTr79G3fRX03VGns5.K5G.lzsQgfLU
 Ve0j2cZLYhhOPIW2vAGIGPUCk7hdYQEo0nFAF7k7Xswp1I1hdYTXkvMLlzlAAI88iI7L_Ojwq_uO
 NkioEbFKE74dnoFBaR_FCCDzk5lUqcV3ByyPHPMAbHaXL1XZdIxAOpKxwDYetwljqw32CyHXi8es
 y98uztNZ8jvozXh_utpltelh.3_j3HZy3wAWVJXkSl.YyMFt5ybTyyosqjG0tBs5.6HrgZv.XvVy
 Ljjt50CA2UBg8ZZ1Zi0cpBx9rphb_iuvj0H2h8c65GhashNkpIqibXTdS60hrf8ka71mEul8ZwJi
 8Ab_tWNlgURbJZzFRowkn96EKd46lTO2f_iBVwa.d8HV1PI9yGzOZixFm3Pa6wNxvxeN68d6gEKU
 868RFJBDvihIHoWNBuhnx4EbPAhFrymlV11mqx7oh7tQWtiVn6xLZW8UfPquA5xeLT906j9K6Wvb
 TxpUNVyy_2HsZzGvECFaDjMw8vNyq0tmXBGsA7Qe8sywrfQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.ne1.yahoo.com with HTTP; Wed, 26 Feb 2020 15:35:46 +0000
Received: by smtp428.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 9a3fc37b51dcecbe04bcd87332e3aec4;
          Wed, 26 Feb 2020 15:35:42 +0000 (UTC)
Subject: Re: [PATCH bpf-next v4 3/8] bpf: lsm: provide attachment points for
 BPF LSM programs
To:     KP Singh <kpsingh@chromium.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        James Morris <jmorris@namei.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
References: <20200220175250.10795-4-kpsingh@chromium.org>
 <0ef26943-9619-3736-4452-fec536a8d169@schaufler-ca.com>
 <202002211946.A23A987@keescook> <20200223220833.wdhonzvven7payaw@ast-mbp>
 <c5c67ece-e5c1-9e8f-3a2b-60d8d002c894@schaufler-ca.com>
 <20200224171305.GA21886@chromium.org>
 <00c216e1-bcfd-b7b1-5444-2a2dfa69190b@schaufler-ca.com>
 <202002241136.C4F9F7DFF@keescook> <20200225054125.dttrc3fvllzu4mx5@ast-mbp>
 <4b56177f-8148-177b-e1e5-c98da86b3b01@schaufler-ca.com>
 <20200226051535.GA17117@chromium.org>
From:   Casey Schaufler <casey@schaufler-ca.com>
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <cf3886b1-2f76-62aa-1ded-56b5ca8411b2@schaufler-ca.com>
Date:   Wed, 26 Feb 2020 07:35:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200226051535.GA17117@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.15302 hermes Apache-HttpAsyncClient/4.1.4 (Java/1.8.0_241)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/25/2020 9:15 PM, KP Singh wrote:
> On 25-Feb 16:30, Casey Schaufler wrote:
>> On 2/24/2020 9:41 PM, Alexei Starovoitov wrote:
>>> On Mon, Feb 24, 2020 at 01:41:19PM -0800, Kees Cook wrote:
>>>> But the LSM subsystem doesn't want special cases (Casey has worked very
>>>> hard to generalize everything there for stacking). It is really hard to
>>>> accept adding a new special case when there are still special cases yet
>>>> to be worked out even in the LSM code itself[2].
>>>> [2] Casey's work to generalize the LSM interfaces continues and it quite
>>>> complex:
>>>> https://lore.kernel.org/linux-security-module/20200214234203.7086-1-casey@schaufler-ca.com/
>>> I think the key mistake we made is that we classified KRSI as LSM.
>>> LSM stacking, lsmblobs that the above set is trying to do are not necessary for KRSI.
>>> I don't see anything in LSM infra that KRSI can reuse.
>>> The only thing BPF needs is a function to attach to.
>>> It can be a nop function or any other.
>>> security_*() functions are interesting from that angle only.
>>> Hence I propose to reconsider what I was suggesting earlier.
>>> No changes to secruity/ directory.
>>> Attach to security_*() funcs via bpf trampoline.
>>> The key observation vs what I was saying earlier is KRSI and LSM are wrong names.
>>> I think "security" is also loaded word that should be avoided.
>> No argument there.
>>
>>> I'm proposing to rename BPF_PROG_TYPE_LSM into BPF_PROG_TYPE_OVERRIDE_RETURN.
>>>
>>>> So, unless James is going to take this over Casey's objections, the path
>>>> forward I see here is:
>>>>
>>>> - land a "slow" KRSI (i.e. one that hooks every hook with a stub).
>>>> - optimize calling for all LSMs
>>> I'm very much surprised how 'slow' KRSI is an option at all.
>>> 'slow' KRSI means that CONFIG_SECURITY_KRSI=y adds indirect calls to nop
>>> functions for every place in the kernel that calls security_*().
>>> This is not an acceptable overhead. Even w/o retpoline
>>> this is not something datacenter servers can use.
>> In the universe I live in data centers will disable hyper-threading,
>> reducing performance substantially, in the face of hypothetical security
>> exploits. That's a massively greater performance impact than the handful
>> of instructions required to do indirect calls. Not to mention the impact
> Indirect calls have worse performance implications than just a few
> instructions and are especially not suitable for hotpaths.
>
> There have been multiple efforts to reduce their usage e.g.:
>
>   - https://lwn.net/Articles/774743/
>   - https://lwn.net/Articles/773985/
>
>> of the BPF programs that have been included. Have you ever looked at what
>   BPF programs are JIT'ed and optimized to native code.

Doesn't mean people won't write slow code.


>> happens to system performance when polkitd is enabled?
> However, let's discuss all this separately when we follow-up with
> performance improvements after submitting the initial patch-set.

Think performance up front. Don't ignore issues.

>>> Another option is to do this:
>>> diff --git a/include/linux/security.h b/include/linux/security.h
>>> index 64b19f050343..7887ce636fb1 100644
>>> --- a/include/linux/security.h
>>> +++ b/include/linux/security.h
>>> @@ -240,7 +240,7 @@ static inline const char *kernel_load_data_id_str(enum kernel_load_data_id id)
>>>         return kernel_load_data_str[id];
>>>  }
>>>
>>> -#ifdef CONFIG_SECURITY
>>> +#if defined(CONFIG_SECURITY) || defined(CONFIG_BPF_OVERRIDE_RETURN)
>>>
>>> Single line change to security.h and new file kernel/bpf/override_security.c
>>> that will look like:
>>> int security_binder_set_context_mgr(struct task_struct *mgr)
>>> {
>>>         return 0;
>>> }
>>>
>>> int security_binder_transaction(struct task_struct *from,
>>>                                 struct task_struct *to)
>>> {
>>>         return 0;
>>> }
>>> Essentially it will provide BPF side with a set of nop functions.
>>> CONFIG_SECURITY is off. It may seem as a downside that it will force a choice
>>> on kernel users. Either they build the kernel with CONFIG_SECURITY and their
>>> choice of LSMs or build the kernel with CONFIG_BPF_OVERRIDE_RETURN and use
>>> BPF_PROG_TYPE_OVERRIDE_RETURN programs to enforce any kind of policy. I think
>>> it's a pro not a con.
>> Err, no. All distros use an LSM or two. Unless you can re-implement SELinux
> The users mentioned here in this context are (I would assume) the more
> performance sensitive users who would, potentially, disable
> CONFIG_SECURITY because of the current performance characteristics.

You assume that the most performance sensitive people would allow
a mechanism to arbitrarily add overhead that is out of their control?
How does that make sense?

> We can also discuss this separately and only if we find that we need
> it for the BPF_OVERRIDE_RET type attachment.
>
> - KP
>
>> in BPF (good luck with state transitions) you've built a warp drive without
>> ever having mined dilithium crystals.
>>
>>
