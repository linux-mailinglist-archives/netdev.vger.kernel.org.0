Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB2ED16AF93
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 19:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgBXSpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 13:45:33 -0500
Received: from sonic309-27.consmr.mail.ne1.yahoo.com ([66.163.184.153]:42148
        "EHLO sonic309-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727479AbgBXSpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 13:45:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1582569930; bh=tYd9i4LXx1qA0rwDL69S44TRxcmSxBQnzGrpNesEXXE=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=BS7TPavd26J34xORa94t8dRl52q1dmwzewnAtoaw79+qBro5qyKxNiGToUsvpjJ0nc4rV8PEy/MJ/UuSdAy6Mq9tzNbJnlmGvR0drtrrOyH7u/H4g0D67RZmS/BKmQz7AvxnNuD/YDaLytOD2K73btAfcizc8X+OjlRljzinvRB+FdVGlre3MLcmx6dMuTskZlrz4weuJ9DwdKqRP0y0qz5k9BtNEPgzAdJoa0BWxMeEv0wsJ9EHSArf/8QzzuUsTxbo+r2Hi5TTjgQMryWSA+Ze9k0mbtQGvQegyb5WoXpH34IIYFVZhFtGLiSRW5GdmdNSQeY8yn4hjSCyLydMXw==
X-YMail-OSG: Fg8O2iEVM1k8nweQp.QcdczEE858DIUdqSEVFproEUftAOhe_ug1Hed_V_zs3Rr
 5QUhuFMchgeFwCqSB7VkgP5td9v1WrMeqlMJP9H6EUmtS4dwQeOydZ.z4_bgYEIPy0bjU3Fhbi73
 JKk3Y7NfX2gM.YFA12N0n.MoSQk0aM8UrQAYGUKe2P3Rz2SnacyqawUnUYZwyFpyMBVlSMG3pjir
 xHxshAS9orPvRUMitwp97Z1ohglYNybFGI6riD3TZj7aYQ8fVj.azNVTN_owFpJ_xHskWC24a1pD
 WkIMJ1gziAI4tfZDXFl3GpmyvpUFx87mAnm_UfVDvAAnUgEcA1Mt3m4fgiCFvZAmJw0iEJcAT.y7
 SCahD5ePHnSTI2Zcft4ws6qT44xnOByklysW7fZFk.vGL_LhyRifAFmVqKXXgLocvl2ooPwLdYM6
 auac8A5J5upAqu1gfoECyVPFtFBW_NLzkQ33yy_d_X_julRX7weMHfs1BSrjspOehu5AQg_Itrt5
 bKUwYvXHZ29LGnCHPWin8mJj8a4jd3QaRk.2rCU45wRVDR13blKj2bSBU5UOoh3T2Q_01Gjty594
 UTn9fDJ7hK7t5hZSEk26vUWFbfGMUg1vRl71MA0BOw5OPgOTjs2X6huk9xiXjRuiFOrmWvib1jxi
 OMcgXO8IiuoYsbMMNBmehPTPagdE1LwsxQdERJfBAMA6_TeaTo_6_fBzxhkhZS6kD5yYAamuwT_O
 bWMG9yXzg9h6y.kTvLqgVbbEpF37uPd8yVKiR08yRYHxgF6PvN8iUd63hvYCOAMpYRqZ1madMSYd
 2VvSDQ2_w5l06C93lF51n6cRcq8RYPD7jLvaB1nmUM1WHfH6xDNZ1.ySbynSwuwRTACrOgHnGccb
 mytRABgXfpcAT4AigYiamrj6VAT1tw9QRIWIuIwjh_B28ov4zj3ZM3VRb_s68ABBt8Mq4vwIIdOg
 BkP8TJ7DuXOT.weYuyGdR1TCfnuL7CWSP8j3GnCzyylPCL1ZKntBWC0cEqkbrJsK2c6ml5MOQKUJ
 Grcs9cejT7X.EkI0YGL85CrYJvlEYs.4cRCsJbgYBnbhAK0n.4SxqRGSgN.1RW8LfjcyVpledpCz
 ZMzcz6_35aBaW02.SZqM3yVoHGPpur834FJFLnrFmiN49bTubYxC9TfBFCUafto9OMAzDY.VkjvG
 yNc_bQvvOf7dlx4BR6Z4ui3IDhirwETRejLgl79APe2MLRWAoyGqu1FV3qufEGsXJgP62VCr86gK
 f3tZmeqqg50IYlUfFVAA1qge1yLWi0JJVYtCKCIGBDQm_i.ZQAdcqZqWoWdv2fhLQSlj1dlspGAK
 qxJ8z04YNMWifEkU5o9f8dkZo1W_ZXnj1kCPFMwk9_MFnSLNo1RPE70Ohtq7WRXT9PkJvXtN6Td6
 8zHd5SIZxSJdqyiGB00_Swg38XoSfFE4DY2kYEZW06VHwg621n9r8KQ4iD3wMl6rKgG2eRNQqdGf
 cevsxnsq.WBQ-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Mon, 24 Feb 2020 18:45:30 +0000
Received: by smtp401.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 613f9ccbfbc34f22cb58e117d12795c9;
          Mon, 24 Feb 2020 18:45:28 +0000 (UTC)
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
References: <20200220175250.10795-1-kpsingh@chromium.org>
 <20200220175250.10795-4-kpsingh@chromium.org>
 <0ef26943-9619-3736-4452-fec536a8d169@schaufler-ca.com>
 <202002211946.A23A987@keescook> <20200223220833.wdhonzvven7payaw@ast-mbp>
 <c5c67ece-e5c1-9e8f-3a2b-60d8d002c894@schaufler-ca.com>
 <20200224171305.GA21886@chromium.org>
From:   Casey Schaufler <casey@schaufler-ca.com>
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <00c216e1-bcfd-b7b1-5444-2a2dfa69190b@schaufler-ca.com>
Date:   Mon, 24 Feb 2020 10:45:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200224171305.GA21886@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.15199 hermes Apache-HttpAsyncClient/4.1.4 (Java/1.8.0_241)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/2020 9:13 AM, KP Singh wrote:
> On 24-Feb 08:32, Casey Schaufler wrote:
>> On 2/23/2020 2:08 PM, Alexei Starovoitov wrote:
>>> On Fri, Feb 21, 2020 at 08:22:59PM -0800, Kees Cook wrote:
>>>> If I'm understanding this correctly, there are two issues:
>>>>
>>>> 1- BPF needs to be run last due to fexit trampolines (?)
>>> no.
>>> The placement of nop call can be anywhere.
>>> BPF trampoline is automagically converting nop call into a sequence
>>> of directly invoked BPF programs.
>>> No link list traversals and no indirect calls in run-time.
>> Then why the insistence that it be last?
> I think this came out of the discussion about not being able to
> override the other LSMs and introduce a new attack vector with some
> arguments discussed at:
>
>   https://lore.kernel.org/bpf/20200109194302.GA85350@google.com/
>
> Let's say we have SELinux + BPF runnng on the system. BPF should still
> respect any decisions made by SELinux. This hasn't got anything to
> do with the usage of fexit trampolines.

The discussion sited is more about GPL than anything else.

The LSM rule is that any security module must be able to
accept the decisions of others. SELinux has to accept decisions
made ahead of it. It always has, as LSM checks occur after
"traditional" checks, which may fail. The only reason that you
need to be last in this implementation appears to be that you
refuse to use the general mechanisms. You can't blame SELinux
for that.

>>>> 2- BPF hooks don't know what may be attached at any given time, so
>>>>    ALL LSM hooks need to be universally hooked. THIS turns out to cr=
eate
>>>>    a measurable performance problem in that the cost of the indirect=
 call
>>>>    on the (mostly/usually) empty BPF policy is too high.
>>> also no.
>> Um, then why not use the infrastructure as is?
> I think what Kees meant is that BPF allows hooking to all the LSM
> hooks and providing static LSM hook callbacks like traditional LSMs
> has a measurable performance overhead and this is indeed correct. This
> is why we want provide with the following characteristics:

I was responding to the "also no", which denies both what Kees said
and what you're saying here.=20

> - Without introducing a new attack surface, this was the reason for
>   creating a mutable security_hook_heads in v1 which ran the hook
>   after v1.

Yeah,

>   This approach still had the issues of an indirect call and an
>   extra check when not used. So this was not truly zero overhead even
>   after special casing BPF.

The LSM mechanism is not zero overhead. It never has been. That's why
you can compile it out. You get added value at a price. You get the
ability to use SELinux and KRSI together at a price. If that's unacceptab=
le
you can go the route of seccomp, which doesn't use LSM for many of the
same reasons you're on about.

When LSM was introduced it was expected to be used by the lunatic fringe
people with government mandated security requirements. Today it has a
much greater general application. That's why I'm in the process of
bringing it up to modern use case requirements. Performance is much
more important now than it was before the use of LSM became popular.

> - Having a truly zero performance overhead on the system. There are
>   other tracing / attachment mechnaisms in the kernel which provide
>   similar guarrantees (using static keys and direct calls) and it
>   seems regressive for KRSI to not leverage these known patterns and
>   sacrifice performance espeically in hotpaths. This provides users
>   to use KRSI alongside other LSMs without paying extra cost for all
>   the possible hooks.

This is in direct conflict with the aforementioned "also no".

>>>> So, trying to avoid the indirect calls is, as you say, an optimizati=
on,
>>>> but it might be a needed one due to the other limitations.
>>> I'm convinced that avoiding the cost of retpoline in critical path is=
 a
>>> requirement for any new infrastructure in the kernel.
>> Sorry, I haven't gotten that memo.
>>
>>> Not only for security, but for any new infra.
>> The LSM infrastructure ain't new.
> But the ability to attach BPF programs to LSM hooks is new.

Stop right there. No, I mean it. Really, stop right there.
I don't give a flying fig (he said, using the polite expression
rather than the vulgar) about what you want to do within a
security module. Attach a BPF program, randomize arbitrary
memory locations, do traditional Bell & LaPadula, it's all the
same to the LSM infrastructure. If you want to do something
that has to work outside that, the way audit and seccomp do,
you need to take that out of the LSM infrastructure. If you
want the convenience of the LSM infrastructure you don't get
to muck it up.

> Also, we
> have not had the whole implementation of the LSM hook be mutable
> before and this is essentially what the KRSI provides.

It can do that wholly within KRSI hooks. You don't need to
put KRSI specific code into security.c.

>>> Networking stack converted all such places to conditional calls.
>>> In BPF land we converted indirect calls to direct jumps and direct ca=
lls.
>>> It took two years to do so. Adding new indirect calls is not an optio=
n.
>>> I'm eagerly waiting for Peter's static_call patches to land to conver=
t
>>> a lot more indirect calls. May be existing LSMs will take advantage
>>> of static_call patches too, but static_call is not an option for BPF.=

>>> That's why we introduced BPF trampoline in the last kernel release.
>> Sorry, but I don't see how BPF is so overwhelmingly special.
> My analogy here is that if every tracepoint in the kernel were of the
> type:
>
> if (trace_foo_enabled) // <-- Overhead here, solved with static key
>    trace_foo(a);  // <-- retpoline overhead, solved with fexit trampoli=
nes
>
> It would be very hard to justify enabling them on a production system,
> and the same can be said for BPF and KRSI.

The same can be and has been said about the LSM infrastructure.
If BPF and KRSI are that performance critical you shouldn't be
tying them to LSM, which is known to have overhead. If you can't
accept the LSM overhead, get out of the LSM. Or, help us fix the
LSM infrastructure to make its overhead closer to zero. Whether
you believe it or not, a lot of work has gone into keeping the LSM
overhead as small as possible while remaining sufficiently general
to perform its function.

No. If you're too special to play by LSM rules then you're special
enough to get into the kernel using more direct means.



