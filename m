Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEFB1763AB
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727432AbgCBTOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:14:51 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37761 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbgCBTOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 14:14:51 -0500
Received: by mail-qt1-f194.google.com with SMTP id j34so857019qtk.4;
        Mon, 02 Mar 2020 11:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D1TQwosAdZnEqzAGNOq0vB5eZuKZaUHDLAHSCbRY1Ag=;
        b=pqZH5KIB2CSXSeGIKgcyhjvJCsVOqy4M3NFm4ODK61wOM9tkWi0URX1AKC0xNPSL2h
         lAPqaNCpTJBoa+Aitc+d6ipB6LiGiQPdi6zoZOyjwCpXyadnF2Cj0gHlsU7pB9Fbhj1Z
         MShcZ7gBbV0T0R+TCfSM6/nMSZZ8E6vQ+9I6dh28IS5wfAqcss9n/MeBoVb6fa4F+WEJ
         S/0MBD+67/uVIoiZUGmeT9v3fZ4NJMgK4it5tMVFQh0WZjapQ2LII2gS0hZBPZ54ErTO
         cR4j8Hs0PWRNl+L94S07A5ZtdKLDix1Aql3W8RUFJTXoJEUeOSkUikYhws0rmS1br5Tx
         IGfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D1TQwosAdZnEqzAGNOq0vB5eZuKZaUHDLAHSCbRY1Ag=;
        b=Q2aMFMgcEX7hMloa8+MmV5YCOEB3fojTBC5UdN8xwaEJuZltmcLb9HkMNrpbkmQnCM
         mhy0jXMQMumrCPMRe/Vmn/TF8LsQnVemAGpnWUfhOzN9PF66dqpvr/r6lxN0kRKw8yjp
         pL9HxR/+oldgmyyJIyS0/iFPyD+EB8ghdyETMU1fxiMNUn5SGN0Zt39VAxhHlYkRCbOs
         s/HjjKQZbVTITjIvW2MfPTyeES59RzGIrEoREGjWYuDszLX9LDIyjg/aVL1JQfI2l1I7
         Zu6FP8J1Kl6CmU23qpBakh5QwVGpbziOlDGzBiTArevgzRqRb0B9qXgkkoSJzFxEUDnS
         LuYQ==
X-Gm-Message-State: ANhLgQ1F9jJ4G+gDh+Xv3LRbm8cpx0TJVCNUuU28QHZxqYm7XgT1UZ5F
        HmHrgVNtU8W1Erka015ucjyBHUbsffAFgZYQ8xw=
X-Google-Smtp-Source: ADFU+vsLeUo7NT2QJ8p2MoHloo2kTIc2aQT2KavqpDGMAdLd7J1JygN+jDMkem+8hWWkUZAkziArm1VkxRo2RQFeytQ=
X-Received: by 2002:ac8:4581:: with SMTP id l1mr1119628qtn.59.1583176489619;
 Mon, 02 Mar 2020 11:14:49 -0800 (PST)
MIME-Version: 1.0
References: <20200301062405.2850114-1-andriin@fb.com> <20200301062405.2850114-2-andriin@fb.com>
 <b57cdf6d-0849-2d54-982e-352886f86201@fb.com> <CAEf4BzZspu-wXMr6v=Sd-_m-XzXJwJHyU9zd0ydEiWmch8F9GQ@mail.gmail.com>
 <af9e3e1e-e1e9-0462-88a4-93fd06c40957@fb.com>
In-Reply-To: <af9e3e1e-e1e9-0462-88a4-93fd06c40957@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Mar 2020 11:14:38 -0800
Message-ID: <CAEf4Bzb9V7JyHzFD6ZFpuq5BQYFPaiRwks2D6Uj_G+gSrnT0Gg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: switch BPF UAPI #define constants to enums
To:     Yonghong Song <yhs@fb.com>
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

On Mon, Mar 2, 2020 at 10:33 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 3/2/20 10:25 AM, Andrii Nakryiko wrote:
> > On Mon, Mar 2, 2020 at 8:22 AM Yonghong Song <yhs@fb.com> wrote:
> >>
> >>
> >>
> >> On 2/29/20 10:24 PM, Andrii Nakryiko wrote:
> >>> Switch BPF UAPI constants, previously defined as #define macro, to anonymous
> >>> enum values. This preserves constants values and behavior in expressions, but
> >>> has added advantaged of being captured as part of DWARF and, subsequently, BTF
> >>> type info. Which, in turn, greatly improves usefulness of generated vmlinux.h
> >>> for BPF applications, as it will not require BPF users to copy/paste various
> >>> flags and constants, which are frequently used with BPF helpers.
> >>>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>> ---
> >>>    include/uapi/linux/bpf.h              | 272 +++++++++++++++----------
> >>>    include/uapi/linux/bpf_common.h       |  86 ++++----
> >>>    include/uapi/linux/btf.h              |  60 +++---
> >>>    tools/include/uapi/linux/bpf.h        | 274 ++++++++++++++++----------
> >>>    tools/include/uapi/linux/bpf_common.h |  86 ++++----
> >>>    tools/include/uapi/linux/btf.h        |  60 +++---
> >>>    6 files changed, 497 insertions(+), 341 deletions(-)
> >>>
> >>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> >>> index 8e98ced0963b..03e08f256bd1 100644
> >>> --- a/include/uapi/linux/bpf.h
> >>> +++ b/include/uapi/linux/bpf.h
> >>> @@ -14,34 +14,36 @@
> >>>    /* Extended instruction set based on top of classic BPF */
> >>>
> >>>    /* instruction classes */
> >>> -#define BPF_JMP32    0x06    /* jmp mode in word width */
> >>> -#define BPF_ALU64    0x07    /* alu mode in double word width */
> >>> +enum {
> >>> +     BPF_JMP32       = 0x06, /* jmp mode in word width */
> >>> +     BPF_ALU64       = 0x07, /* alu mode in double word width */
> >>
> >> Not sure whether we have uapi backward compatibility or not.
> >> One possibility is to add
> >>     #define BPF_ALU64 BPF_ALU64
> >> this way, people uses macros will continue to work.
> >
> > This is going to be a really ugly solution, though. I wonder if it was
> > ever an expected behavior of UAPI constants to be able to do #ifdef on
> > them.
> >
> > Do you know any existing application that relies on those constants
> > being #defines?
>
> I did not have enough experience to work with system level applications.
> But in linux/in.h we have
>
> #if __UAPI_DEF_IN_IPPROTO
> /* Standard well-defined IP protocols.  */
> enum {
>    IPPROTO_IP = 0,               /* Dummy protocol for TCP               */
> #define IPPROTO_IP              IPPROTO_IP
>    IPPROTO_ICMP = 1,             /* Internet Control Message Protocol    */
> #define IPPROTO_ICMP            IPPROTO_ICMP
>    IPPROTO_IGMP = 2,             /* Internet Group Management Protocol   */
> #define IPPROTO_IGMP            IPPROTO_IGMP
>    IPPROTO_IPIP = 4,             /* IPIP tunnels (older KA9Q tunnels use
> 94) */
> #define IPPROTO_IPIP            IPPROTO_IPIP
>    IPPROTO_TCP = 6,              /* Transmission Control Protocol        */
> #define IPPROTO_TCP             IPPROTO_TCP
>    IPPROTO_EGP = 8,              /* Exterior Gateway Protocol            */
> #define IPPROTO_EGP             IPPROTO_EGP
>    IPPROTO_PUP = 12,             /* PUP protocol                         */
> #define IPPROTO_PUP             IPPROTO_PUP
>    IPPROTO_UDP = 17,             /* User Datagram Protocol               */
> #define IPPROTO_UDP             IPPROTO_UDP
>    IPPROTO_IDP = 22,             /* XNS IDP protocol                     */
> #define IPPROTO_IDP             IPPROTO_IDP
>
> ...
>

I can do that as well, going to be pretty ugly and verbose, but will
eliminate that concern. But before I go and update all that, would be
nice to get some consensus on whether we want to convert all the
constants, or only BPF helper flags (which was an immediate motivation
for my patch).

>
> >
> >>
> >> If this is an acceptable solution, we have a lot of constants
> >> in net related headers and will benefit from this conversion for
> >> kprobe/tracepoint of networking related functions.
> >>
> >>>
> >>>    /* ld/ldx fields */
> >>> -#define BPF_DW               0x18    /* double word (64-bit) */
> >>> -#define BPF_XADD     0xc0    /* exclusive add */
> >>> +     BPF_DW          = 0x18, /* double word (64-bit) */
> >>> +     BPF_XADD        = 0xc0, /* exclusive add */
> >>>
> >>>    /* alu/jmp fields */
> >>> -#define BPF_MOV              0xb0    /* mov reg to reg */
> >>> -#define BPF_ARSH     0xc0    /* sign extending arithmetic shift right */
> >>> +     BPF_MOV         = 0xb0, /* mov reg to reg */
> >>> +     BPF_ARSH        = 0xc0, /* sign extending arithmetic shift right */
> >>>
> >>>    /* change endianness of a register */
> >>> -#define BPF_END              0xd0    /* flags for endianness conversion: */
> >>> -#define BPF_TO_LE    0x00    /* convert to little-endian */
> >>> -#define BPF_TO_BE    0x08    /* convert to big-endian */
> >>> -#define BPF_FROM_LE  BPF_TO_LE
> >>> -#define BPF_FROM_BE  BPF_TO_BE
> >>> +     BPF_END         = 0xd0, /* flags for endianness conversion: */
> >>> +     BPF_TO_LE       = 0x00, /* convert to little-endian */
> >>> +     BPF_TO_BE       = 0x08, /* convert to big-endian */
> >>> +     BPF_FROM_LE     = BPF_TO_LE,
> >>> +     BPF_FROM_BE     = BPF_TO_BE,
> >>>
> >>>    /* jmp encodings */
> >>> -#define BPF_JNE              0x50    /* jump != */
> >>> -#define BPF_JLT              0xa0    /* LT is unsigned, '<' */
> >>> -#define BPF_JLE              0xb0    /* LE is unsigned, '<=' */
> >>> -#define BPF_JSGT     0x60    /* SGT is signed '>', GT in x86 */
> >>> -#define BPF_JSGE     0x70    /* SGE is signed '>=', GE in x86 */
> >>> -#define BPF_JSLT     0xc0    /* SLT is signed, '<' */
> >>> -#define BPF_JSLE     0xd0    /* SLE is signed, '<=' */
> >>> -#define BPF_CALL     0x80    /* function call */
> >>> -#define BPF_EXIT     0x90    /* function return */
> >>> +     BPF_JNE         = 0x50, /* jump != */
> >>> +     BPF_JLT         = 0xa0, /* LT is unsigned, '<' */
> >>> +     BPF_JLE         = 0xb0, /* LE is unsigned, '<=' */
> >>> +     BPF_JSGT        = 0x60, /* SGT is signed '>', GT in x86 */
> >>> +     BPF_JSGE        = 0x70, /* SGE is signed '>=', GE in x86 */
> >>> +     BPF_JSLT        = 0xc0, /* SLT is signed, '<' */
> >>> +     BPF_JSLE        = 0xd0, /* SLE is signed, '<=' */
> >>> +     BPF_CALL        = 0x80, /* function call */
> >>> +     BPF_EXIT        = 0x90, /* function return */
> >>> +};
> >>>
> >> [...]
