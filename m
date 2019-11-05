Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8536BF098E
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbfKEWcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:32:35 -0500
Received: from sonic306-28.consmr.mail.ne1.yahoo.com ([66.163.189.90]:36858
        "EHLO sonic306-28.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729970AbfKEWcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:32:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1572993153; bh=CEqNC2OZLKhyTZ7Hb0wmLJu9sTXB7Mqxnyl1A+S6+TQ=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=EthnUynlV3IADcJoG7UBd/VTNjzZ7I/WBRXx6R0tOfBu/digqcE9CI8gdRu4aZr81P6OpLwRgnsT25ySQipCfZU0BCUBdunGTXIHoP+PiOZEXdNdmK/jzMYw31lw1aWnh+f0jvUliA4etie2rv1S8EhZBKrzcIFeSDaSgHhTRkQiofew4SCwhWp4p/S+ewHGXd5jG48seSE9Q8ekCTB1PysumwFLXyZ7ON6SQtrPWuquqyU1XdnBQRthU8iDf07Nc+Jf9Cx5lPriaeGI15bo9cmQp+2Yv5ziEAgxf3TDPWz7oqNpGzhXXoxXgig9U+3swL3t2ALLrz9/qUbBzRJ4DQ==
X-YMail-OSG: rfffkqUVM1mtWPHBkSEHkDFHFeeok1ZQg00bzBb3.jZv4O1lGgzzwpgqdePX6OZ
 2wiCCfIXfku9bdJSJPbuC.uynz.UKpEKMLq9A90N7FxSs0vvCrkYuLeI70vP.HS1qbFbLZxLoajv
 APnAf4lVryLPORh3ehRfo2ecxYWFpMrxhvyTWIdDz03dy6Ef1c1NB.0nkrIWlOKcty1bHlCKneSY
 WnZ0E8bCeBSnRqJ05Ax1rCB1nMK8WGCru7aWWqvkUuAt3Njz.TmcgHd0DVnDx28jXCmgSKBVYl07
 m_XBbabPZhajs8CoG22v2CvI0XY1.0gD0xPQYH9Wkpkgt8.3Fl1fm7Ab26myjUSniEKVOX0mITx_
 utGnqfzQFR0tQxUw942fQ9Ln.Uki88TS_xdGYRY6xBmRhh6QQuS_hJARlFgdzVNM69yNqLlAPdCM
 vxs__Drt50TIiEJidaazHPgbdURbt4tlCTCQfW4R0k3Lc9QRQqOUA5VGloJDp96t1z3IQ4I2k_Ut
 d2I52vQLMyVMwiGRpofQDYCSeCN7wCdopOKtSC6m04PZZ.G6Tw5qekGrY_gRioO0LULq3ttBJNBH
 ta.ZQfw2OGEltEGS7fJe6Q5GBgHChDEpd4D5GHhEeBiFORQs4bEApBqlYJDXbATHHF0cvLftCKN.
 V4Xp_sHk5ZTTn9f.R4ZhZuj1hgZz2WfmGoKwrjJflvsmk3CJOvGqtsR3HUx7HM53uJl21eY568oj
 r8i9nUBhhfRyFH5W46EMgkTRqHeujpdWsFoz47Np4_lvvCI4q9nuazIdcN.ciDf8jNdNDBha.IVW
 zi3s385lyLENv56IQ7oUn7SImMDPqVQnccSpbQXLK9KHeKn9_NZCECl8TgJIzn54oc6mMmNTcKkh
 MRHnN12UltF_zAUrICz9lppvlYdbwWVssaUiGqmlqygOPjylAHuxbPkKCiyvpuYcrTzzIDZOftAH
 Ekh5Wv1AXnGjOR5eknJrn9Bq6g30FAOIzzz0A3uQOkmM47RtfkCTL5f4ixxWu3EUzDcTKB5A2mbL
 nFyOykPouTuB4zQnOoaIOrRj824trFx5ngqZ5td.U9Aq5UadVbcGBNQFXT9QPD5NxbGxTcGGCUPF
 xE9wLpuGoPxyaFT7fkr.W_K.bgvYCaiHqtT3DuyR1e72jMGWplZanzmUdATo560PH3BtmBVM98Ut
 ehb4TiYD65TKWNWNJcVA.v2lOk4lMztf6q1ITLePRFKgIFmhDjTSriwk8vMv7s.83TIYS1vV9Ehm
 uHxzGDVUvP9pAPtI3VoDH2AonmYyP1fV1WU_VH_THikFCxytq.lMkxAHl..nDFzsTSbO5.iEa.0e
 ocAWJvlJ4R22IBVYY4zPXn4OM7Anqm4yw2CRf7QmHCEERMHm6ohw8TrFdTEb76pPLZ4FGKFEiNOe
 2MceryyCTaRZyLV59o2o4ViUkEJ8DLuG1H3XoMQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ne1.yahoo.com with HTTP; Tue, 5 Nov 2019 22:32:33 +0000
Received: by smtp410.mail.ne1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 8eeec92530544327d71d2d9b5a53830c;
          Tue, 05 Nov 2019 22:32:29 +0000 (UTC)
Subject: Re: [PATCH bpf-next v13 4/7] landlock: Add ptrace LSM hooks
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
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
 <c5c6b433-7e6a-c8f8-f063-e704c3df4cc6@schaufler-ca.com>
 <20191105193130.qam2eafnmgvrvjwk@ast-mbp.dhcp.thefacebook.com>
 <637736ef-c48e-ac3b-3eef-8a6a095a96f1@schaufler-ca.com>
 <20191105215453.szhdkrvuekwfz6le@ast-mbp.dhcp.thefacebook.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
Openpgp: preference=signencrypt
Autocrypt: addr=casey@schaufler-ca.com; keydata=
 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
 abzjfg==
Message-ID: <93f53bdd-a499-6425-111c-ab90d81874d7@schaufler-ca.com>
Date:   Tue, 5 Nov 2019 14:32:27 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191105215453.szhdkrvuekwfz6le@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.14680 hermes Apache-HttpAsyncClient/4.1.4 (Java/1.8.0_181)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/5/2019 1:54 PM, Alexei Starovoitov wrote:
> On Tue, Nov 05, 2019 at 11:55:17AM -0800, Casey Schaufler wrote:
>> On 11/5/2019 11:31 AM, Alexei Starovoitov wrote:
>>> On Tue, Nov 05, 2019 at 09:55:42AM -0800, Casey Schaufler wrote:
>>>> On 11/5/2019 9:18 AM, Alexei Starovoitov wrote:
>>>>> On Mon, Nov 04, 2019 at 06:21:43PM +0100, Micka=C3=ABl Sala=C3=BCn =
wrote:
>>>>>> Add a first Landlock hook that can be used to enforce a security p=
olicy
>>>>>> or to audit some process activities.  For a sandboxing use-case, i=
t is
>>>>>> needed to inform the kernel if a task can legitimately debug anoth=
er.
>>>>>> ptrace(2) can also be used by an attacker to impersonate another t=
ask
>>>>>> and remain undetected while performing malicious activities.
>>>>>>
>>>>>> Using ptrace(2) and related features on a target process can lead =
to a
>>>>>> privilege escalation.  A sandboxed task must then be able to tell =
the
>>>>>> kernel if another task is more privileged, via ptrace_may_access()=
=2E
>>>>>>
>>>>>> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
>>>>> ...
>>>>>> +static int check_ptrace(struct landlock_domain *domain,
>>>>>> +		struct task_struct *tracer, struct task_struct *tracee)
>>>>>> +{
>>>>>> +	struct landlock_hook_ctx_ptrace ctx_ptrace =3D {
>>>>>> +		.prog_ctx =3D {
>>>>>> +			.tracer =3D (uintptr_t)tracer,
>>>>>> +			.tracee =3D (uintptr_t)tracee,
>>>>>> +		},
>>>>>> +	};
>>>>> So you're passing two kernel pointers obfuscated as u64 into bpf pr=
ogram
>>>>> yet claiming that the end goal is to make landlock unprivileged?!
>>>>> The most basic security hole in the tool that is aiming to provide =
security.
>>>>>
>>>>> I think the only way bpf-based LSM can land is both landlock and KR=
SI
>>>>> developers work together on a design that solves all use cases. BPF=
 is capable
>>>>> to be a superset of all existing LSMs
>>>> I can't agree with this. Nope. There are many security models
>>>> for which BPF introduces excessive complexity. You don't need
>>>> or want the generality of a general purpose programming language
>>>> to implement Smack or TOMOYO. Or a simple Bell & LaPadula for
>>>> that matter. SELinux? I can't imagine anyone trying to do that
>>>> in eBPF, although I'm willing to be surprised. Being able to
>>>> enforce a policy isn't the only criteria for an LSM.=20
>>> what are the other criteria?
>> They include, but are not limited to, performance impact
>> and the ability to be analyzed.=20
> Right and BPF is the only thing that exists in the kernel where the ver=
ifier
> knows precisely the number of instructions the critical path through th=
e
> program will take. Currently we don't quantify this cost for bpf helper=
s, but
> it's easy to add. Can you do this for smack? Can you tell upfront the l=
ongest
> execution time for all security rules?

There's much more to analyze than number of instructions.
There's also completion of policy enforcement. There are
lots of tools for measuring performance within the kernel.

>> It has to be fast, or the networking people are
>> going to have fits. You can't require the addition
>> of a pointer into the skb because it'll get rejected
>> out of hand. You can't completely refactor the vfs locking
>> to accommodate you needs.
> I'm not sure why you got such impression. I'm not proposing to refactor=
 vfs or
> add fields to skb.

I'm not saying you did. Those are examples of things you would
have trouble with.

>  Once we have equivalent to smack policy implemented in
> bpf-based lsm let's do performance benchmarking and compare actual numb=
ers
> instead of hypothesizing about them. Which policy do you think would be=

> the most representative of smack use case?

The Tizen3 Three domain model will do just fine.
https://wiki.tizen.org/Security:SmackThreeDomainModel


>
>>>> I see many issues with a BPF <-> vfs interface.
>>> There is no such interface today. What do you have in mind?
>> You can't implement SELinux or Smack using BPF without a way
>> to manipulate inode data.
> Are you talking about inode->i_security ? That's not manipulating inode=
 data.

Poppycock.

> It's attaching extra metadata to inode object without changing inode it=
self.

Where I come from, we call that inode object data.

> BPF can do it already via hash maps. It's not as fast as direct pointer=
 access,

Then you're not listening. Performance MATTERS!

> but for many use cases it's good enough. If it turns out to be a perfor=
mance
> limiting factor we will accelerate it.

How many times have I heard that bit of rubbish?
No. You can't start with a bad design and tweak it to acceptability later=
=2E


>>>> the mechanisms needed for the concerns of the day. Ideally,
>>>> we should be able to drop mechanisms when we decide that they
>>>> no longer add value.
>>> Exactly. bpf-based lsm must not add to kernel abi.
>> Huh? I have no idea where that came from.
> It sounds to me that some folks in the community got wrong impression t=
hat
> anything that BPF accesses is magically turning that thing into stable =
kernel
> ABI. That is not true. BPF progs had access _all_ kernel data pointers =
and
> structures for years without turning the whole kernel into stable ABI. =
I want
> to make sure that this part is understood. This is also a requirement f=
or
> bpf-based LSM. It must not make LSM hooks into stable ABI.
>

