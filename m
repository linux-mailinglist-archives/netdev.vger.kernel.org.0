Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70049CA42E
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 18:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390395AbfJCQWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 12:22:50 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45376 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390379AbfJCQWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 12:22:49 -0400
Received: by mail-qt1-f194.google.com with SMTP id c21so4351540qtj.12;
        Thu, 03 Oct 2019 09:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G+FRTNp5U69SyKtgUfTtfz6xG/uvamnaxAqTNRvN1uU=;
        b=Py2obbtaGVejJTtqfyVJ8AcHteh+akTFnYpJXayi05AAwvnNcKtUTSu11Ufa9dg6jm
         uJipMd15gVa/k0HKGPyMFHr0vcP5/N2fCvr/3gF9EYUoS5ajclCR2nriThWqpaMehId+
         iTWeUV5uBFvqM0agRgIbV5dRtNCD2swRpnmYPgZTYql46XbT/5cZf0Gol/hTnYH7rdqN
         4//OKPNKiN0UnDjyDkfywIJvwpNTGZQnvjmd/9GP/HdZOeFgf1sxI57vKAJvq3lvw3XZ
         tLjPqWz+qytPHif9r3k+62SHEp7bQ20ztz1tNyNgYBhYkMYvmO4RwXN13nx0EoRY3BJW
         1Qdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G+FRTNp5U69SyKtgUfTtfz6xG/uvamnaxAqTNRvN1uU=;
        b=WQdolP+hTpwrV18FjFbiJmfTI9eNZxd30Ducfl/gIDt6ALk62fcR3XHL8jDB88t5tn
         CuxNUlpzgQPJkOOZWAu3w1NQ3h+lLgqxwAHpGUGkwOGQtiAbakYBfP/C7T1LgsITJx4h
         9+jG+gecXmD7NKLFJReIGJcd0O94Ag4N2IZ20QfPcDhybXVy9psjjrp0pgI++3+NJVyi
         4T2Kz+RtLTTr9FA8KeQtfj3yyBSW24Jz4RycDfqFRYfXPH6CXbawSba3h5DJ+hA5CvOo
         N5odbNk3FgX+vqc/0o83i51ANoElyzHSbN1PoZgRWQLNqxGRseizKHBXY2WdRcNC6yja
         7UAQ==
X-Gm-Message-State: APjAAAVBOqCN7pv/aJSViNo0cXL2z7GYq9mqkjM9VQjCsMHEweTUYuWG
        B9qqAqB1O/W2jOaHVBrBvJofvgZWWF5DO+ZxnbI=
X-Google-Smtp-Source: APXvYqwr4OyO7aw4McEPhT6bXXLLvXeg25hQ2+4Df4PnpB49WDi6TQrxI7DtA3ObTK5ak1rOiSKqqZUYecn+U0ouSFo=
X-Received: by 2002:ac8:5147:: with SMTP id h7mr10736467qtn.117.1570119767635;
 Thu, 03 Oct 2019 09:22:47 -0700 (PDT)
MIME-Version: 1.0
References: <20191002215041.1083058-1-andriin@fb.com> <20191002215041.1083058-5-andriin@fb.com>
 <87imp6qo1o.fsf@toke.dk>
In-Reply-To: <87imp6qo1o.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Oct 2019 09:22:36 -0700
Message-ID: <CAEf4BzZa9aSz_FXkexKWse_k-m0WvxZJZG6qOqacaKKxgHb1OA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/7] selftests/bpf: split off tracing-only
 helpers into bpf_tracing.h
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 12:35 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > +/* a helper structure used by eBPF C program
> > + * to describe BPF map attributes to libbpf loader
> > + */
> > +struct bpf_map_def {
> > +     unsigned int type;
> > +     unsigned int key_size;
> > +     unsigned int value_size;
> > +     unsigned int max_entries;
> > +     unsigned int map_flags;
> > +};
>
> Why is this still here? There's already an identical definition in libbpf=
.h...
>

It's a BPF (kernel) side vs userspace side difference. bpf_helpers.h
are included from BPF program, while libbpf.h won't work on kernel
side. So we have to have a duplicate of bpf_map_def.

> -Toke
>
