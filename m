Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25F6AA0EBC
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 02:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727125AbfH2Axz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 20:53:55 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41624 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbfH2Axy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 20:53:54 -0400
Received: by mail-pl1-f194.google.com with SMTP id m9so741562pls.8
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 17:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=niV0Vp7x3UxpuQqmhDXSp6GQ0LY7VPID2j1WUvmosog=;
        b=knbrg7HZ9zD6jAR0pDXbT2QWHN9HyskXUA7IVXeZZeEaJqEmeYmxu0BoaA29JsT3dZ
         VWDjqum4FBYePzmTFQ9O0n6FW5X+pvRAUBuxuLGIiiLmA8OVjSbAWv7WB09cj2ikuq4F
         c9iQ0ye+bdv5n+rc1uZc6hg1jJvSm/gL8JT+jVh01JPAJgm+zv9agsjBW1CpWbacA7BS
         XMGiyxvQ28cgo/eGLMG6Eo+LmOb9S2dXvq3B2n4mUDRuUarRRhD71RwKg1Ju9Hz6yA+0
         W7cuJsRrgA4a6assCKbfcAz0N2xCa2YEbNZpch9IjN2rnn1iTHAAHEmCqkFVEGfsBtxP
         Dmkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=niV0Vp7x3UxpuQqmhDXSp6GQ0LY7VPID2j1WUvmosog=;
        b=JgWy4Skkt2snLjQVmAsGFmTxOLAGFN454ZP0y2Fk1izpUG1hXsFxcyu2YvVAyfOM1X
         UGFY8Hc1jkk3k+4y60XwMDRt6L/H789g4S0YYo0QdVrLneimDUB7xPw/kW4Oz3TIBMiM
         Q82gGGkEr/TqXNFw7HJX1GfgsyhZ/iaj9yhlLC/auqV51fggBf/2+ZaR4GksFOBQRtDS
         MYh5dV7lhwS5RLMC5SuJj0RqoHdfxFhTTLxFQUMaTAHEfGHyBWYYhwgzNczg78XyfsMQ
         OeF+GBrMG8+E3h+xndl4IjqNnUJnRkzWQYE4FBfXyIB029NwbNbhsbe2uEAgOZdTKH9Y
         hRPw==
X-Gm-Message-State: APjAAAVLoXopGnkrXMFIzsPGMXQEiN8BdD4Jh05oHoqDWjRcZh8UeAUx
        j8nLEeHYIFeK1qt6z2+pSGgkaQ==
X-Google-Smtp-Source: APXvYqxjc9+Ihkedt5ExbUSYmi7pmtCngCxCmmQGbFSk9d8ssSE6C5rOe8vY9FBLF6/lXy4xrM/Irw==
X-Received: by 2002:a17:902:a715:: with SMTP id w21mr6774701plq.274.1567040033758;
        Wed, 28 Aug 2019 17:53:53 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:9437:f332:3e4c:f05b? ([2601:646:c200:1ef2:9437:f332:3e4c:f05b])
        by smtp.gmail.com with ESMTPSA id e24sm336834pgk.21.2019.08.28.17.53.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 17:53:52 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16G77)
In-Reply-To: <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
Date:   Wed, 28 Aug 2019 17:53:52 -0700
Cc:     Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <260ADB71-A11C-4BFA-997E-9ECB2AE5D0D7@amacapital.net>
References: <20190827205213.456318-1-ast@kernel.org> <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com> <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com> <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com> <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com> <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com> <20190828225512.q6qbvkdiqih2iewk@ast-mbp.dhcp.thefacebook.com> <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Aug 28, 2019, at 5:45 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>=20
>=20
>>> On Aug 28, 2019, at 3:55 PM, Alexei Starovoitov <alexei.starovoitov@gmai=
l.com> wrote:
>>>=20
>>> On Tue, Aug 27, 2019 at 11:12:29PM -0700, Andy Lutomirski wrote:
>>>>>=20
>>>>>=20
>>>>> =46rom the previous discussion, you want to make progress toward solvi=
ng
>>>>> a lot of problems with CAP_BPF.  One of them was making BPF
>>>>> firewalling more generally useful. By making CAP_BPF grant the ability=

>>>>> to read kernel memory, you will make administrators much more nervous
>>>>> to grant CAP_BPF.
>>>>=20
>>>> Andy, were your email hacked?
>>>> I explained several times that in this proposal
>>>> CAP_BPF _and_ CAP_TRACING _both_ are necessary to read kernel memory.
>>>> CAP_BPF alone is _not enough_.
>>>=20
>>> You have indeed said this many times.  You've stated it as a matter of
>>> fact as though it cannot possibly discussed.  I'm asking you to
>>> justify it.
>>=20
>> That's not how I see it.
>> I kept stating that both CAP_BPF and CAP_TRACING are necessary to read
>> kernel memory whereas you kept distorting my statement by dropping second=

>> part and then making claims that "CAP_BPF grant the ability to read
>> kernel memory, you will make administrators much more nervous".
>=20
> Mea culpa. CAP_BPF does, however, appear to permit breaking kASLR due to u=
nsafe pointer conversions, and it allows reading and writing everyone=E2=80=99=
s maps.  I stand by my overall point.
>=20
>>=20
>> Just s/CAP_BPF/CAP_BPF and CAP_TRACING/ in this above sentence.
>> See that meaning suddenly changes?
>> Now administrators would be worried about tasks that have both at once.
>> They also would be worried about tasks that have CAP_TRACING alone,
>> because that's what allows probe_kernel_read().
>=20
> This is not all what I meant. Of course granting CAP_BPF+CAP_TRACING allow=
s reading kernel memory. This is not at all a problem.  Here is a problem I s=
ee:
>=20
> CAP_TRACING + CAP_BPF allows modification of other people=E2=80=99s maps a=
nd potentially other things that should not be implied by CAP_TRACING alone a=
nd that don=E2=80=99t need to be available to tracers. So CAP_TRACING, which=
 is powerful but has somewhat limited scope, isn=E2=80=99t fully useful with=
out CAP_BPF, and giving CAP_TRACING *and* CAP_BPF allows things that teacher=
s shouldn=E2=80=99t be able to do. I think this would make the whole mechani=
sm less useful to Android, for example.
>=20
> (Also, I=E2=80=99m not sure quite what you mean by =E2=80=9CCAP_TRACING ..=
. allows probe_kernel_read()=E2=80=9D. probe_kernel_read() is a kernel funct=
ion that can=E2=80=99t be directly called by userspace. CAP_TRACING allows r=
eading kernel memory in plenty of ways regardless.)
>=20
>>=20
>>> It seems like you are specifically trying to add a new switch to turn
>>> as much of BPF as possible on and off.  Why?
>>=20
>> Didn't I explain it several times already with multiple examples
>> from systemd, daemons, bpftrace ?
>>=20
>> Let's try again.
>> Take your laptop with linux distro.
>> You're the only user there. I'm assuming you're not sharing it with
>> partner and kids. This is my definition of 'single user system'.
>> You can sudo on it at any time, but obviously prefer to run as many
>> apps as possible without cap_sys_admin.
>> Now you found some awesome open source app on the web that monitors
>> the health of the kernel and will pop a nice message on a screen if
>> something is wrong. Currently this app needs root. You hesitate,
>> but the apps is so useful and it has strong upstream code review process
>> that you keep running it 24/7.
>> This is open source app. New versions come. You upgrade.
>> You have enough trust in that app that you keep running it as root.
>> But there is always a chance that new version doing accidentaly
>> something stupid as 'kill -9 -1'. It's an open source app at the end.
>>=20
>> Now I come with this CAP* proposal to make this app safer.
>> I'm not making your system more secure and not making this app
>> more secure. I can only make your laptop safer for day to day work
>> by limiting the operations this app can do.
>> This particular app monitros the kernel via bpf and tracing.
>> Hence you can give it CAP_TRACING and CAP_BPF and drop the rest.
>=20
> This won=E2=80=99t make me much more comfortable, since CAP_BPF lets it do=
 an ever-growing set of nasty things. I=E2=80=99d much rather one or both of=
 two things happen:
>=20
> 1. Give it CAP_TRACING only. It can leak my data, but it=E2=80=99s rather h=
ard for it to crash my laptop, lose data, or cause other shenanigans.
>=20
> 2. Improve it a bit do all the privileged ops are wrapped by capset().
>=20
> Does this make sense?  I=E2=80=99m a security person on occasion. I find v=
ulnerabilities and exploit them deliberately and I break things by accident o=
n a regular basis. In my considered opinion, CAP_TRACING alone, even extende=
d to cover part of BPF as I=E2=80=99ve described, is decently safe. Getting r=
oot with just CAP_TRACING will be decently challenging, especially if I don=E2=
=80=99t get to read things like sshd=E2=80=99s memory, and improvements to m=
itigate even that could be added.  I am quite confident that attacks startin=
g with CAP_TRACING will have clear audit signatures if auditing is on.  I am=
 also confident that CAP_BPF *will* allow DoS and likely privilege escalatio=
n, and this will only get more likely as BPF gets more widely used. And, if B=
PF-based auditing ever becomes a thing, writing to the audit daemon=E2=80=99=
s maps will be a great way to cover one=E2=80=99s tracks.
>=20
>=20
>> I think they have no choice but to do kernel.unprivileged_bpf_disabled=3D=
1.
>> We, as a kernel community, are forcing the users into it.
>> Hence I really do not see a value in any proposal today that expands
>> unprivileged bpf usage.
>=20
> I think you=E2=80=99re overemphasizing bpf=E2=80=99s role in the whole spe=
culation mess. I realize that you=E2=80=99ve spent an insane amount of time o=
n mitigations to stupid issues. I=E2=80=99ve spent a less insane amount of t=
ime on mitigating similar issues outside of bpf.  It=E2=80=99s a mess.  At t=
he end of the day, the kernel does its best, and new bugs show up. New CPUs w=
ill be less buggy.

Bah, accidentally hit send.

If the kernel=E2=80=99s mitigations aren=E2=80=99t good enough or you=E2=80=99=
re subject to direct user attack (e.g. via insufficient IBPB, SMT attack, et=
c) then you=E2=80=99re vulnerable. Otherwise you=E2=80=99re less vulnerable.=
 BPF is by no means the whole story. Heck, the kernel *could*, at unfortunat=
e performance cost, more aggressively flush around BPF and effectively treat=
 it like user code.

So I think we should design bpf=E2=80=99s API=E2=80=99s security with the ph=
ilosophy that speculation attacks are just one more type of bug, and we shou=
ld make sure that real-world useful configurations don=E2=80=99t give BPF to=
 tasks that don=E2=80=99t need it. My unpriv proposal tries to do this. This=
 is *why* my proposal keeps test_run locked down and restricts running each p=
rogram type to tasks that are explicitly granted the ability to attach it.

So let=E2=80=99s let CAP_TRACING use bpf. Speculation attacks are mostly irr=
elevant to tracers anyway, but all the rest of the stuff I=E2=80=99ve been t=
alking is relevant.=
