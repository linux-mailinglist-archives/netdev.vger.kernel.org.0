Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27C141767F9
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 00:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbgCBXOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 18:14:24 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41274 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgCBXOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 18:14:24 -0500
Received: by mail-qk1-f193.google.com with SMTP id b5so1565352qkh.8;
        Mon, 02 Mar 2020 15:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dnFBmnVWf/IQHXmQjUmB+Yi8mGNU/efuxG2w3lUsero=;
        b=ZfM/PX1WkUpNQJmJYahkbclJxP6IBVe3keQQ4OLhGtbPPtoR8UA3blogWzsf+qWalR
         8yQguxpY9eQD8yVIGDVdAFEAIuiW7zLW40QArwgtHkinwS9nSbvpqZ3TKL8IFva96T9D
         j9GXnwPLcE/COprnssREFvPBqHV1ZUArPCzbTrPYen2jkPIU5/J2HdSGvoUkhvkIPUnG
         Vi02Ak+F5K5bmSzD6B0pJJAiEkdC23ucYqQGEdVesSRup+WSy7MfrWBCU4uYEKvPJnwH
         etQ9ebhY8V4Uj4zdLHSgcPmDAVnST6GGRYxv17ECZxDI9bz4irNoLJOXyaSoZGmwfYSU
         Um5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dnFBmnVWf/IQHXmQjUmB+Yi8mGNU/efuxG2w3lUsero=;
        b=pkuXArXjLkSbSRHqW2jJ03nAr/iyQoiBOVCtoOuOUEc95gk2ZzkvQgeRMjp+/PHIk4
         o5qtBZG0TgMV/JoArAl5LUDni5cqh7iBf0HbOr9OU0n0kVISKyJg3NQNQTNL6UPs/X4B
         Uu/s3LtgqWtRjPlHXsHbnhly4TUEtOuTSCF4vih5KaKt7/XDGtGri16D2QPU1c6QJBXF
         MQFcgKCndDlmyZd4mF51wF3E0EEnqIlRND97SFOvQLV8bo9Kx0yzgeQrcja/NVSK7SnK
         PM6JwVbKgmIaXUtCIsIzO2Wcjr0GRcYnvs5mIVPRBi/n4M7W1VnFCFzkih0rkzq/gmvQ
         SgsQ==
X-Gm-Message-State: ANhLgQ3t4X7DmapeIKxnvC1ahBzU+UPMN6tg4oyAujhV0rohzJs8LBL0
        yEc0gpVoXwHntTtpzVdHQjpIYm8dV3lbqxuzaF0=
X-Google-Smtp-Source: ADFU+vtkuecYScVIERtlpU1JqiGuiD933Np9EViewb6+HwO7ggQuEs5cWyw1stx2AjvRBKhDNGHuwwiwgbfVkxVwaEc=
X-Received: by 2002:a37:a2d6:: with SMTP id l205mr1582714qke.92.1583190861255;
 Mon, 02 Mar 2020 15:14:21 -0800 (PST)
MIME-Version: 1.0
References: <20200301062405.2850114-1-andriin@fb.com> <20200301062405.2850114-2-andriin@fb.com>
 <20200302223748.v4omummx43pejzfn@ast-mbp>
In-Reply-To: <20200302223748.v4omummx43pejzfn@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Mar 2020 15:14:10 -0800
Message-ID: <CAEf4BzYWCyLBNzH9ns-jP7SFeOpGfLbypr7VRhDPSTOMA0nyjA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: switch BPF UAPI #define constants to enums
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 2, 2020 at 2:37 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Feb 29, 2020 at 10:24:03PM -0800, Andrii Nakryiko wrote:
> > Switch BPF UAPI constants, previously defined as #define macro, to anonymous
> > enum values. This preserves constants values and behavior in expressions, but
> > has added advantaged of being captured as part of DWARF and, subsequently, BTF
> > type info. Which, in turn, greatly improves usefulness of generated vmlinux.h
> > for BPF applications, as it will not require BPF users to copy/paste various
> > flags and constants, which are frequently used with BPF helpers.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  include/uapi/linux/bpf.h              | 272 +++++++++++++++----------
> >  include/uapi/linux/bpf_common.h       |  86 ++++----
> >  include/uapi/linux/btf.h              |  60 +++---
> >  tools/include/uapi/linux/bpf.h        | 274 ++++++++++++++++----------
> >  tools/include/uapi/linux/bpf_common.h |  86 ++++----
> >  tools/include/uapi/linux/btf.h        |  60 +++---
> >  6 files changed, 497 insertions(+), 341 deletions(-)
>
> I see two reasons why converting #define to enum is useful:
> 1. bpf progs can use them from vmlinux.h as evident in patch 3.
> 2. "bpftool feature probe" can be replaced with
>   bpftool btf dump file /sys/kernel/btf/vmlinux |grep BPF_CGROUP_SETSOCKOPT
>
> The second use case is already possible, since bpf_prog_type,
> bpf_attach_type, bpf_cmd, bpf_func_id are all enums.
> So kernel is already self describing most bpf features.
> Does kernel support bpf_probe_read_user() ? Answer is:
> bpftool btf dump file /sys/kernel/btf/vmlinux | grep BPF_FUNC_probe_read_user
>
> The only bit missing is supported kernel flags and instructions.

Yep, my motivation was primarily the former, but I can see benefits
from the latter as well.

>
> I think for now I would only convert flags that are going to be
> used from bpf program and see whether 1st use case works well.
> Later we can convert flags that are used out of user space too.
>
> In other words:
>
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 8e98ced0963b..03e08f256bd1 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -14,34 +14,36 @@
> >  /* Extended instruction set based on top of classic BPF */
> >
> >  /* instruction classes */
> > -#define BPF_JMP32    0x06    /* jmp mode in word width */
> > -#define BPF_ALU64    0x07    /* alu mode in double word width */
> > +enum {
> > +     BPF_JMP32       = 0x06, /* jmp mode in word width */
> > +     BPF_ALU64       = 0x07, /* alu mode in double word width */
>
> not those.

makes sense

>
> > -#define BPF_F_ALLOW_OVERRIDE (1U << 0)
> > -#define BPF_F_ALLOW_MULTI    (1U << 1)
> > -#define BPF_F_REPLACE                (1U << 2)
> > +enum {
> > +     BPF_F_ALLOW_OVERRIDE    = (1U << 0),
> > +     BPF_F_ALLOW_MULTI       = (1U << 1),
> > +     BPF_F_REPLACE           = (1U << 2),
> > +};
>
> not those either. These are the flags for user space. Not for the prog.

yep...

>
> >  /* flags for BPF_MAP_UPDATE_ELEM command */
> > -#define BPF_ANY              0 /* create new element or update existing */
> > -#define BPF_NOEXIST  1 /* create new element if it didn't exist */
> > -#define BPF_EXIST    2 /* update existing element */
> > -#define BPF_F_LOCK   4 /* spin_lock-ed map_lookup/map_update */
> > +enum {
> > +     BPF_ANY         = 0, /* create new element or update existing */
> > +     BPF_NOEXIST     = 1, /* create new element if it didn't exist */
> > +     BPF_EXIST       = 2, /* update existing element */
> > +     BPF_F_LOCK      = 4, /* spin_lock-ed map_lookup/map_update */
> > +};
>
> yes to these.

yep, these and below are the most important ones...

[...]

>
> In all such cases I don't think we need #define FOO FOO
> trick. These are the flags used within bpf program.
> I don't think any user is doing #ifdef logic there.
> I cannot come up with a use case of anything useful this way.

Sounds good, I'll revert non-BPF helper flags cases and will post v2, thanks!
