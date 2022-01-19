Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285B24942C2
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 23:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357512AbiASWDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 17:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357511AbiASWDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 17:03:38 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A487BC061574;
        Wed, 19 Jan 2022 14:03:37 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o64so3810925pjo.2;
        Wed, 19 Jan 2022 14:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IOjldLrnWWwpwY+JkWf0ExE0MpMLGJQlI8NdiUeY93k=;
        b=kSEl/U/1h+1dwvDi0hIgtKSfplmCWl9uNrp2KkVmOGqXTw3Qwmd1cnzjLT97tkOzj+
         Zp2XNWdH8ZH0Ya8qZSIl4+za5S/JcIWOBvnThLOUlDkR0vZ+DSJmM4vVETBIO5uE1gB5
         WemdUYctYV3UseKEp7Tur2cSdm6qMJR/ENUd02x3NghpHewgIS3fW7Ng3RgUzVkT6UiL
         qHzack50wKSJWqqgHsznMtLdSJ4T9hRFlO+O4IPmfUdFN3ys1pUZR+7b8bMX7WWxFbwc
         UpddAjlDPLcoO69i7cj091TwgLVJ7Eur5UCeH6ZAeXeWQheaSUj0OrTxObGS9/eEYCBZ
         FxhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IOjldLrnWWwpwY+JkWf0ExE0MpMLGJQlI8NdiUeY93k=;
        b=JVXz3FhZZ/FH39AZJVyI+ShTjejaQ1tygsSP6jaBuRpzHYmjdWbei8BNi37pCOFIhf
         VIlJcJVGel3cxUq0HfiSQUNHBhqRenMJ0t9NGgYbLubzjTvw3TDxEPMYqrRNsgOo+ewq
         HB0UU7HhgPzAzBcbkKjJ+JSRbL8g9jRmejtFa08Kzn28RnBg4Af6FaIAWB5zdqUQIKmW
         cmB7PxpywPhEYmGhaGkiZCuoAw66bC2ZyzgfvMuPUn8LnqSCnYHnv18f9nPHm1M9BnR8
         pGUuYDB+9I14QdMSspTcq31J353Ov7yvBSkP3bFOmwkxQv/EhgvwoHopzUTNDIO2EpPD
         b65A==
X-Gm-Message-State: AOAM531nk0w3rns3P2/+4DokcJSWQJDbMPGfVEIjXppbdXM7X+AUuXFs
        XwjGGdwOgo8g+/vEQ9vt5tzLFf+8r3ILsI1vAPU=
X-Google-Smtp-Source: ABdhPJzV1oAx/xoKU++dv1R8kUyf32CYmSuCtq2M5RRSdynsPZSmD55U0LG7xKsRNsiyyG6JEjOIsGEiHHaAgYSi7xw=
X-Received: by 2002:a17:902:860c:b0:149:1017:25f0 with SMTP id
 f12-20020a170902860c00b00149101725f0mr34284326plo.116.1642629817114; Wed, 19
 Jan 2022 14:03:37 -0800 (PST)
MIME-Version: 1.0
References: <20220113070245.791577-1-imagedong@tencent.com>
In-Reply-To: <20220113070245.791577-1-imagedong@tencent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 19 Jan 2022 14:03:26 -0800
Message-ID: <CAADnVQKNCqUzPJAjSHMFr-Ewwtv5Cs3UCQpthaKDTd+YNRWqqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: Add document for 'dst_port' of 'struct bpf_sock'
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        mengensun@tencent.com, flyingpeng@tencent.com,
        mungerjiang@tencent.com, Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 11:03 PM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> The description of 'dst_port' in 'struct bpf_sock' is not accurated.
> In fact, 'dst_port' is not in network byte order, it is 'partly' in
> network byte order.
>
> We can see it in bpf_sock_convert_ctx_access():
>
> > case offsetof(struct bpf_sock, dst_port):
> >       *insn++ = BPF_LDX_MEM(
> >               BPF_FIELD_SIZEOF(struct sock_common, skc_dport),
> >               si->dst_reg, si->src_reg,
> >               bpf_target_off(struct sock_common, skc_dport,
> >                              sizeof_field(struct sock_common,
> >                                           skc_dport),
> >                              target_size));
>
> It simply passes 'sock_common->skc_dport' to 'bpf_sock->dst_port',
> which makes that the low 16-bits of 'dst_port' is equal to 'skc_port'
> and is in network byte order, but the high 16-bites of 'dst_port' is
> 0. And the actual port is 'bpf_ntohs((__u16)dst_port)', and
> 'bpf_ntohl(dst_port)' is totally not the right port.
>
> This is different form 'remote_port' in 'struct bpf_sock_ops' or
> 'struct __sk_buff':
>
> > case offsetof(struct __sk_buff, remote_port):
> >       BUILD_BUG_ON(sizeof_field(struct sock_common, skc_dport) != 2);
> >
> >       *insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(struct sk_buff, sk),
> >                             si->dst_reg, si->src_reg,
> >                                     offsetof(struct sk_buff, sk));
> >       *insn++ = BPF_LDX_MEM(BPF_H, si->dst_reg, si->dst_reg,
> >                             bpf_target_off(struct sock_common,
> >                                            skc_dport,
> >                                            2, target_size));
> > #ifndef __BIG_ENDIAN_BITFIELD
> >       *insn++ = BPF_ALU32_IMM(BPF_LSH, si->dst_reg, 16);
> > #endif
>
> We can see that it will left move 16-bits in little endian, which makes
> the whole 'remote_port' is in network byte order, and the actual port
> is bpf_ntohl(remote_port).
>
> Note this in the document of 'dst_port'. ( Maybe this should be unified
> in the code? )

Looks like
 __sk_buff->remote_port
 bpf_sock_ops->remote_port
 sk_msg_md->remote_port
are doing the right thing,
but bpf_sock->dst_port is not correct?

I think it's better to fix it,
but probably need to consolidate it with
convert_ctx_accesses() that deals with narrow access.
I suspect reading u8 from three flavors of 'remote_port'
won't be correct.
'dst_port' works with a narrow load, but gets endianness wrong.
