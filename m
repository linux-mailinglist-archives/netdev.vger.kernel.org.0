Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E774A5427EA
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 09:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233922AbiFHHWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 03:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354551AbiFHGTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 02:19:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B503A26C5;
        Tue,  7 Jun 2022 23:13:31 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654668810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+mvJm3CEojdKR7HAxJc1Qh72VUiJYk9o3mvVYg67Vjw=;
        b=zhLoVxUvsIxFmVH+MzPhxAhfV3xo2PXd0rpy8uARLIeoVnP3JvEvQOk5s3ADOm8kbN2/iI
        OrAarvc63NAZ3VtgCN2O94dwKpDPmYhoyL0m7M7Y0N1cjgr84ldxYEaxc/kclplw+Ym+O4
        icM8VsXDKqtExQDRc5NL5KPsrPV91W/Dy8GHU0JSBbQ36Y8eZ3+BOO/HeE+rdlgj5la9lk
        cLJ5I8bCa2B8n3MCgxmm4ujdPb8OO0/AKpS9g33d7AI558NtiO81GnfXKvaXAIdqWbffBq
        rcTWVS3IvjTWrIeqLkirail+TpzKsUd1DEeB31ZR4Sp60mZrLKpxh61f059/ZA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654668810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+mvJm3CEojdKR7HAxJc1Qh72VUiJYk9o3mvVYg67Vjw=;
        b=6S+xTa4GtfrWZOA3oEcKVEdUl+9TMweY3vT//05V17kO10bfUpeie6R9SnpPg4zhQWNVT4
        Z4u6mgndIcRY5SCw==
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Geliang Tang <geliang.tang@suse.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next] bpf: Add BPF-helper for accessing CLOCK_TAI
In-Reply-To: <CAADnVQKqo1XfrPO8OYA1VpArKHZotuDjGNtxM0AftUj_R+vU7g@mail.gmail.com>
References: <20220606103734.92423-1-kurt@linutronix.de>
 <CAADnVQJ--oj+iZYXOwB1Rs9Qiy6Ph9HNha9pJyumVom0tiOFgg@mail.gmail.com>
 <875ylc6djv.ffs@tglx> <c166aa47-e404-e6ee-0ec5-0ead1923f412@redhat.com>
 <CAADnVQKqo1XfrPO8OYA1VpArKHZotuDjGNtxM0AftUj_R+vU7g@mail.gmail.com>
Date:   Wed, 08 Jun 2022 08:13:28 +0200
Message-ID: <87zginy96f.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Tue Jun 07 2022, Alexei Starovoitov wrote:
> On Tue, Jun 7, 2022 at 12:35 PM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>>
>>
>> On 07/06/2022 11.14, Thomas Gleixner wrote:
>> > Alexei,
>> >
>> > On Mon, Jun 06 2022 at 08:57, Alexei Starovoitov wrote:
>> >> On Mon, Jun 6, 2022 at 3:38 AM Kurt Kanzenbach <kurt@linutronix.de> wrote:
>> >>>
>> >>> From: Jesper Dangaard Brouer <brouer@redhat.com>
>> >>>
>> >>> Commit 3dc6ffae2da2 ("timekeeping: Introduce fast accessor to clock tai")
>> >>> introduced a fast and NMI-safe accessor for CLOCK_TAI. Especially in time
>> >>> sensitive networks (TSN), where all nodes are synchronized by Precision Time
>> >>> Protocol (PTP), it's helpful to have the possibility to generate timestamps
>> >>> based on CLOCK_TAI instead of CLOCK_MONOTONIC. With a BPF helper for TAI in
>> >>> place, it becomes very convenient to correlate activity across different
>> >>> machines in the network.
>> >>
>> >> That's a fresh feature. It feels risky to bake it into uapi already.
>> >
>> > What? That's just support for a different CLOCK. What's so risky about
>> > it?
>>
>> I didn't think it was "risky" as this is already exported as:
>>   EXPORT_SYMBOL_GPL(ktime_get_tai_fast_ns);
>>
>> Correct me if I'm wrong, but this simple gives BPF access to CLOCK_TAI
>> (see man clock_gettime(2)), right?
>> And CLOCK_TAI is not really a new/fresh type of CLOCK.
>>
>> Especially for networking we need this CLOCK_TAI time as HW LaunchTime
>> need this (e.g. see qdisc's sch_etf.c and sch_taprio.c).

In addition to Tx launchtime I have two other uses cases in mind:
Timestamping and policing.

>
> I see. I interpreted the commit log that commit 3dc6ffae2da2
> introduced TAI into the kernel for the first time.
> But it introduced the NMI safe version of it, right?

Yes, exactly. The clock itself is nothing new. Only the NMI safe version
of it is. It is designated to be used e.g., in tracing or bpf.

I'll update the changelog.

>
>> >
>> >> imo it would be better to annotate tk_core variable in vmlinux BTF.
>> >> Then progs will be able to read all possible timekeeper offsets.
>> >
>> > We are exposing APIs. APIs can be supported, but exposing implementation
>> > details creates ABIs of the worst sort because that prevents the kernel
>> > from changing the implementation. We've seen the fallout with the recent
>> > tracepoint changes already.
>>
>> Hmm... annotate tk_core variable in vmlinux BTF and letting BPF progs
>> access this seems like an unsafe approach and we tempt BPF-developers to
>> think other parts are okay to access.
>
> It is safe to access.
> Whether garbage will be read it's a different story.
>
> The following works (with lose definition of 'works'):
>
> extern const void tk_core __ksym;
>
> struct timekeeper {
>         long long offs_tai;
> } __attribute__((preserve_access_index));
>
> struct seqcount_raw_spinlock {
> } __attribute__((preserve_access_index));
>
> long get_clock_tai(void)
> {
>    long long off = 0;
>    void *addr = (void *)&tk_core +
>       ((bpf_core_type_size(struct seqcount_raw_spinlock) + 7) / 8) * 8 +
>       bpf_core_field_offset(struct timekeeper, offs_tai);
>
>    bpf_probe_read_kernel(&off, sizeof(off), addr);
>    return bpf_ktime_get_ns() + off;
> }

Thanks for the example.

>
> It's ugly, but no kernel changes are necessary.
> If you need to access clock_tai you can do so on older kernels too.
> Even on android 4.19 kernels.
>
> It's not foolproof. Future kernel changes will break it,
> but CO-RE will detect the breakage.
> The prog author would have to adjust the prog every time.
>
> People do these kinds of tricks all the time.
>
> Note that above was possible even before CO-RE came to existence.
> The first day bpf_probe_read_kernel() became available 8 years ago
> the tracing progs could read any kernel memory.
> Even earlier kprobes could read it for 10+ years.
>
> And in all those years bpf progs accessing kernel internals
> didn't freeze kernel development. bpf progs don't extend
> uapi surface unless the changes are in uapi/bpf.h.
>
> Anyway I guess new helper bpf_ktime_get_tai_ns() is ok, since
> it's so trivial, but selftest is necessary.

OK. I'll add a selftest and resolve the warnings detected by netdev ci.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmKgPggTHGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzgr63D/9PEFVlC32EXnNouer0Qeig/MO/RrOq
ohtwSp9NhAmq8aNXyBpd8SfR84VUIybd9AN0/psgDFnsKKPfKN8njTu5TLz6To9S
kSy2IwAfFDaI0AIlxr/Bqd2e8M3sFLS97Od1fXIQB7eplRh/BG5UaAX0t2vCxBjY
Zh3yinjeW4bVPWJfXdIaTeZDZ5F3to0Y+KowpIilcSdGKX7V9Uk145XaDg8y/K+X
iws4xhbyLEuTyo18T1DpnLONr70679pwbxbKcq7vs6g3GytmQjGhYHnIxOfFK4Uv
PUflzBMIlolrpOi0wyMDumvFmUQxz+Zr5ixPUIXY1TI49SOBfTA/cunCv/0AEsZX
iBuml4zTBbOXTsJGc/n7NWAK2eEwWrU5wSSx2WGLLXJz61oFONNzNVuQPvpnvIIR
/nNjWGcYTnML0ZExhplJjjDIyrDjXLtobtc+l/uFCpYj2E6ABdbsHZypZe5noxFC
i3d4EoNL5xjPSUsiiTd4J2aL9J5kPzHxra8AM5+xBd8o5k2kSqJdkGxe+nYxZNXH
kFQSxLr4Hr/aNgPhBpmSZ4j14DuOpCXPIL3GP/MjrG5wOX6u2OXOt9f9Chj4w9IG
zpYRUyVzf0DNGS1LKm3mEvuw7eXXCYP6scrwSiX5a4Mr5ZRYyW2ggLUzVwbFdu2M
69jjSDS9RWYbjw==
=Ko1E
-----END PGP SIGNATURE-----
--=-=-=--
