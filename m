Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD56136349
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgAIWhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:37:01 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41075 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbgAIWhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 17:37:01 -0500
Received: by mail-qk1-f194.google.com with SMTP id x129so140399qke.8;
        Thu, 09 Jan 2020 14:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a0ymKDSrFHTTcKEwOLDygYHEK2TyXdhplOIm/izNpc0=;
        b=vg29O69/gxbVEUO96QSWkkt+wE3+ZA8yqO/VaizxLClCtiYtonrXDdifyU19LG78Rw
         +Wsf7CTiW1j2HuqrnHoX+ZCwLH+KwTYKuLGWdWbmF4xCw6lxUh9Dv5/mA0OulJpAt9Zr
         HG5kkJ3dl38z4vS8d2xbEFgMr/Jh3uPzYM8r+NiE/NNuo09c1HXYdpmU+bLYHXKJrmbe
         YHCiLhhEWNE7D32MEq0BasFDt7o8p61/wCn1H08wZHtoQE92n2N4IcccmDSMGlxsvZbi
         dFuA7Q1M17oKDIbFYH0tefb37s1kTIIaY31kSnzmQPCVcBwItDYRDPSiUWqRH3OjFgqk
         /DCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a0ymKDSrFHTTcKEwOLDygYHEK2TyXdhplOIm/izNpc0=;
        b=JkmyGVfhNgjAf76vf5l4q2TS2ApZNvdybrRH16MZ2K4z+UbvIdcTCMM1lLDYHvyyfz
         jjBsWCsSPRg0dKDiHhA6hcIBtIYR0uYC0UeLyEFPYnHNssQP9dPgLnpy7tQcp59CctCm
         a0DxvPWLvMRAZ1Pbodwj9DYaVnGXGoxZmeAsbgzMEYAxSw5BGTnlU9fLIlKRHvbP+uH6
         myK8nHchmlCOkdpv/3lhx29x19che5/+73Wq4Uefrdt54h64McE0x3CYOP1ekb6KIIyl
         FaD+1YYZKtV7ShQCk4eE/j3j/ZeZ5CqvSbRDHa/OGGwXbTF4qGlmehGHOPX9h6jAe25W
         ArCQ==
X-Gm-Message-State: APjAAAW+C29er8+G7DSBqBDK6S1VF27PYj4eot1GyumP1FHp7QwVEK3g
        HvvAi6UGrL9tKqTHFbalASuH2jqLlLWfTn5tfow=
X-Google-Smtp-Source: APXvYqy8Y19/m0UOMT5N6FBA8j5nLprpXICzzzRwTuOtmgEGrneSO9gwbndalb7nGWa8Xp9wep+JbHtmt7W2E8KTUVs=
X-Received: by 2002:a37:e408:: with SMTP id y8mr184176qkf.39.1578609420094;
 Thu, 09 Jan 2020 14:37:00 -0800 (PST)
MIME-Version: 1.0
References: <20200109003453.3854769-1-kafai@fb.com> <CAADnVQ+nkr5+KJ8GAH7=TwA72ttB7xxrU8T5+RxkDKvn4FbWHg@mail.gmail.com>
In-Reply-To: <CAADnVQ+nkr5+KJ8GAH7=TwA72ttB7xxrU8T5+RxkDKvn4FbWHg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Jan 2020 14:36:49 -0800
Message-ID: <CAEf4BzZ_LahEL_tJQhzSAxeoyEq_8_hA7QM80qRFG2tQBN3WPQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 00/11] Introduce BPF STRUCT_OPS
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 9, 2020 at 12:39 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Jan 8, 2020 at 4:35 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > This series introduces BPF STRUCT_OPS.  It is an infra to allow
> > implementing some specific kernel's function pointers in BPF.
> > The first use case included in this series is to implement
> > TCP congestion control algorithm in BPF  (i.e. implement
> > struct tcp_congestion_ops in BPF).
> >
> > There has been attempt to move the TCP CC to the user space
> > (e.g. CCP in TCP).   The common arguments are faster turn around,
> > get away from long-tail kernel versions in production...etc,
> > which are legit points.
> >
> > BPF has been the continuous effort to join both kernel and
> > userspace upsides together (e.g. XDP to gain the performance
> > advantage without bypassing the kernel).  The recent BPF
> > advancements (in particular BTF-aware verifier, BPF trampoline,
> > BPF CO-RE...) made implementing kernel struct ops (e.g. tcp cc)
> > possible in BPF.
> >
> > The idea is to allow implementing tcp_congestion_ops in bpf.
> > It allows a faster turnaround for testing algorithm in the
> > production while leveraging the existing (and continue growing) BPF
> > feature/framework instead of building one specifically for
> > userspace TCP CC.
> >
> > Please see individual patch for details.
> >
> > The bpftool support will be posted in follow-up patches.
> >
> > v4:
> > - Expose tcp_ca_find() to tcp.h in patch 7.
> >   It is used to check the same bpf-tcp-cc
> >   does not exist to guarantee the register()
> >   will succeed.
> > - set_memory_ro() and then set_memory_x() only after all
> >   trampolines are written to the image in patch 6. (Daniel)
> >   spinlock is replaced by mutex because set_memory_*
> >   requires sleepable context.
>
> Applied. Thanks
>
> Please address any future follow up
> and please remember to provide 'why' details in commit log
> no matter how obvious the patch looks as Arnaldo pointed out.
>
> Re: 'bpftool module' command.
> I think it's too early to call anything 'a module',
> since in this context people will immediately assume 'a kernel module'
> It's a loaded phrase with a lot of consequences.
> bpf-tcp-cc cubic and dctcp do look like kernel modules, but they are
> not kernel modules at all. imo making them look like kernel modules
> has plenty of downsides.
> So as an immediate followup for bpftool I'd recommend to stick
> with 'bpftool struct_ops' command or whatever other name.
> Just not 'bpftool module'.
>
> I think there is a makefile issue with selftests.
> make clean;make -j50
> kept failing for me three times in a row with:
> progs/bpf_dctcp.c:138:4: warning: implicit declaration of function
> 'bpf_tcp_send_ack' is invalid in C99 [-Wimplicit-function-declaration]
>                         bpf_tcp_send_ack(sk, *prior_rcv_nxt);
> but single threaded 'make clean;make' succeeded.
> Andrii, you have a chance to take a look and reproduce would be great.

Spotted few problems that might have caused this, will send a fix shortly.
