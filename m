Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A129F0480
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 18:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390594AbfKERzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 12:55:51 -0500
Received: from sonic313-15.consmr.mail.ne1.yahoo.com ([66.163.185.38]:37569
        "EHLO sonic313-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390586AbfKERzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 12:55:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1572976550; bh=m0eV6RivZxxrTplc4CbRCm5zHYpJb9DOad4uWb+vhCw=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=Awr0eoJXkEd6QFwtUmXAJLwk8faDsqvpCf6E1mB+saZtVMb/7XBVJryNEFgh3BjN6Lw4lt24cQr3WYYYhoSouuIf6JbLkaYMV83ZGYxWxulXuSml83FJpS6dXqgPTOP7wTwMGYH0qIfVC2ZpEk3JybJO2COa8ICbqDJIM5J+T4pys5GKUdNW+U965CENDk9V4kelhJT3u1pu+NjaWXhf1EIOWonrQh07C4POQ+M6SwnyXdWUrOtOeoqWrFIxMR5wiraj7Nz6QPp36qTbpySbZWCi1/zoYKklB4rHWW+XPdaT8P+9hVdMJUDBk3I+kLyco73svOwveayrt1quw3pWvw==
X-YMail-OSG: boHysvYVM1kRFUHZ9YTgzEiGUrRD6LpeCX19W6dQvnFb0N.qjuLyuhD2lbsN8jF
 fPdLfD7ggr39lSRLiDxP_yFwaBWBpJLYqg9erNHrYN_m0FJUyWHuuVzEkgRHI2uqY4Fgc4h_BRQ8
 6Lo.pcQwigpKCJw0cKXUqfnWLbHaFgO4plSkhmd45SFrp3Xt0rRlE7ABomaEMIOjgkPTaufiLkg.
 YPc04pkayBlVs8a1G9CeFR7M._Yli.e.AuV7eY_AFtej2LNgoVwHETyFd7nuzo7SxpFZ6LXzLvtJ
 l0xjIVGMz4h5nXUKeOvAAJGwNQJBQu.HMl6CkcTHr8g0AzAqcU4ZQZikzF6P61u4rOHxCSHsGYcT
 7SI2qwyD1t0abVxFiT9n9REV4sZvVK635Qz1LAibkInxQqPWEampAPNtvPggKgRU3R0KjVkDhbSv
 JS3OxlhcTHyrmg.zcLqC1ZHuK4OSmJkChKC1GeTETSqTf9lsFufLxB0BqIl1LrDHwXFY.l1mxhmT
 ICWa.6T9EKsvbNafEZE3Wgju72P5ry8A4dmBGJ7WSaZi06VWvQj57nE_5a3Frir.m5yn_lbfgsEC
 rsvqUP6ru8U8NtlJyNpZsO_g4qv9iAqtJkm5fFWT1_hZXXinHHzNAdGsVlBF8lkToU.SyiJCvXJT
 FsPjtIvQkmtyELvZRe76xiUjP9HqPwXm_CkZtJQNKwocd7wddoqmfeD3wz4iWrnYGGmPfef8rWoC
 qh6tPz1MFZAjuLw67fUTdX4njlv8G1NDJsJ5gR_om3nsabt1JuDtox6oh7rD8CYhoHYPv7ug0qli
 GIZYyEWK.mp87g2UeeKFcZ1aKgPPUaGvQKqvMQvJuT5KjMXrOH0gyxaRXpof82dnkC7RpxqMvMH7
 PKmCCdf8Z1Sy6RoumlNFzx3518Obbe67X0nofTBtYzdZah8xjBKQcQDulFZvAbO0ZEjut.31lfZB
 2DDB.1PnQ3sSYfYsOY3mfabxlkfe86P00LyOl0eWnr1gKl.0m1jdOsNQkS1OX2ZslQFv5WbQ1SRv
 W7yQayEY44VC7dDsBhENoEMu_FQED643KGs1noeIq3.y4p6CJz8bR6pi4T4e8kakQayt4q_PSTcE
 nXG0vspLjCzv7iVbE8b6qG0cPHcPRCdEjpxVEVqxGdrUG33835cqhP_7YYhYd.cFqRlEYFkSx52z
 .X4Ny1Gt0cEW6C29y5XKfBRN4SFO8xXBCvSzE2.Aazp1Pb.DHnhwzMSRz50dJxGuayhY3BfHQLd0
 zYnFbm3IwEL8Sl8hgPitNzpkrjm5LEFo1XA43ARkEG7KsIQi.syJjOb1KzEcgtphGCHLwwm1Ph37
 .ieYf7EbJ11CHoeza9qlz4rJX3UlREqiIWpMh5CAQa3lXrX6vJtQIytmsKmiG.RuWtk1GlMkJFbX
 Bn3aQrWUehRXIdYGdLjksvtK0DpsHqUjzGjdFyg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Tue, 5 Nov 2019 17:55:50 +0000
Received: by smtp430.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 55c0493ae714ce5556e2fc4f9f498925;
          Tue, 05 Nov 2019 17:55:44 +0000 (UTC)
Subject: Re: [PATCH bpf-next v13 4/7] landlock: Add ptrace LSM hooks
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Cc:     linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale <drysdale@google.com>,
        Florent Revest <revest@chromium.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>,
        KP Singh <kpsingh@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>,
        Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>, bpf@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        casey@schaufler-ca.com
References: <20191104172146.30797-1-mic@digikod.net>
 <20191104172146.30797-5-mic@digikod.net>
 <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <c5c6b433-7e6a-c8f8-f063-e704c3df4cc6@schaufler-ca.com>
Date:   Tue, 5 Nov 2019 09:55:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105171824.dfve44gjiftpnvy7@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.14638 hermes Apache-HttpAsyncClient/4.1.4 (Java/1.8.0_181)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/2019 9:18 AM, Alexei Starovoitov wrote:
> On Mon, Nov 04, 2019 at 06:21:43PM +0100, Micka=C3=ABl Sala=C3=BCn wrot=
e:
>> Add a first Landlock hook that can be used to enforce a security polic=
y
>> or to audit some process activities.  For a sandboxing use-case, it is=

>> needed to inform the kernel if a task can legitimately debug another.
>> ptrace(2) can also be used by an attacker to impersonate another task
>> and remain undetected while performing malicious activities.
>>
>> Using ptrace(2) and related features on a target process can lead to a=

>> privilege escalation.  A sandboxed task must then be able to tell the
>> kernel if another task is more privileged, via ptrace_may_access().
>>
>> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> ...
>> +static int check_ptrace(struct landlock_domain *domain,
>> +		struct task_struct *tracer, struct task_struct *tracee)
>> +{
>> +	struct landlock_hook_ctx_ptrace ctx_ptrace =3D {
>> +		.prog_ctx =3D {
>> +			.tracer =3D (uintptr_t)tracer,
>> +			.tracee =3D (uintptr_t)tracee,
>> +		},
>> +	};
> So you're passing two kernel pointers obfuscated as u64 into bpf progra=
m
> yet claiming that the end goal is to make landlock unprivileged?!
> The most basic security hole in the tool that is aiming to provide secu=
rity.
>
> I think the only way bpf-based LSM can land is both landlock and KRSI
> developers work together on a design that solves all use cases. BPF is =
capable
> to be a superset of all existing LSMs

I can't agree with this. Nope. There are many security models
for which BPF introduces excessive complexity. You don't need
or want the generality of a general purpose programming language
to implement Smack or TOMOYO. Or a simple Bell & LaPadula for
that matter. SELinux? I can't imagine anyone trying to do that
in eBPF, although I'm willing to be surprised. Being able to
enforce a policy isn't the only criteria for an LSM. It's got
to perform well and integrate with the rest of the system. I
see many issues with a BPF <-> vfs interface.

> whereas landlock and KRSI propsals today
> are custom solutions to specific security concerns.

Yes. As they should be. No one has every solved the entire
security problem, and no one ever will. The only hope we have
to address security issues is to have the flexibility to add
the mechanisms needed for the concerns of the day. Ideally,
we should be able to drop mechanisms when we decide that they
no longer add value.

> BPF subsystem was extended
> with custom things in the past. In networking we have lwt, skb, tc, xdp=
, sk
> program types with a lot of overlapping functionality. We couldn't figu=
re out
> how to generalize them into single 'networking' program. Now we can and=
 we
> should. Accepting two partially overlapping bpf-based LSMs would be rep=
eating
> the same mistake again.

I don't get your analogy at all. You have a variety of programs because
you have a variety of protocols and administrative interfaces. Of course
you don't have a single 'networking" program. Security has a variety of
issues and policies. A single 'security' program makes no sense whatever.=



