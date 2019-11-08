Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C87BEF5B59
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfKHWwU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:52:20 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46885 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfKHWwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:52:20 -0500
Received: by mail-qk1-f196.google.com with SMTP id h15so6728925qka.13;
        Fri, 08 Nov 2019 14:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WMQDp49yeXvamrrdeakb+3cfl6V33i1WwQsMuj7jjPg=;
        b=AYVw3DrKG3GxagsN8rKObOOVrn4CPrpB0vVrR9MVrSaDOdmPzPsJ7F2Fxq9oa+fUYk
         nJ4wj0Q3VGPE0E1+bjMdDoU/yiGbm/9BIdueh+csAMljamKoppHFo4fFPJfUpevxylVk
         KGdr1OoiDiNsP/JjGohTufKHciWOkAmS775EibBOXzhEQbBq8XZBZuzMpORlysuC+X1x
         zVkAn0SD7bSzn7XAUC+wV1+F8/9ZAPkE4pttf7K/kkU2bboquoDlhFVvlr48i9RqeL9E
         IDPCIlDNNe23I+zDOsM+OCPmAVSlAPSFe2HUI9IYmFbY+t1v6A5c2wmegBPeWcFCO8YV
         9MNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WMQDp49yeXvamrrdeakb+3cfl6V33i1WwQsMuj7jjPg=;
        b=rrPTfDgSYbarjOeIdMQJDEubWTDpjHnBUKxvcJpQzqyksryDNGzgzl4Ha7WNENGw52
         v/gcf0rN0ExOCmaAuwsvEvyJxF9kRXKLsDmyt18MhLIeR44+DrQ2e7vrZeFyd870mxBH
         6DYiV2YXLd6VY8rXiBxazkbi4SCPxVybMG9swFMDT5riVHdCn0/yUZdYMb4Y01uL1z3c
         6DXxUH/MOnagVQMpLQo4IZpL8yG48GCLKzVTX32A1SJ1ZozTxAgAZBCoXTAK1jXNAHul
         pHodzaeNFeFe1A4z8o0MQq0a1giwWKqarhnatLlDRF9218/nGpiwv6QuLctARIHogA68
         O27A==
X-Gm-Message-State: APjAAAVd/7K9ApMko04TRs2mfZT/atwKb8X4bFwpsB4Fu42Vjn76Sfgp
        mAIQb+F6o3IsSWOKJm+HivKjrKVm8EWGY90ECww=
X-Google-Smtp-Source: APXvYqzYejG/fDn6vhyMUvuHvNnHceBUc9Ogoc7tfQUy3P7lt7ElbnrmNB7a7EVhEC6h8zuYo4amdeEg7TgCsDpV0C4=
X-Received: by 2002:a37:9a8a:: with SMTP id c132mr11319906qke.92.1573253537715;
 Fri, 08 Nov 2019 14:52:17 -0800 (PST)
MIME-Version: 1.0
References: <157324878503.910124.12936814523952521484.stgit@toke.dk> <157324878956.910124.856248605977418231.stgit@toke.dk>
In-Reply-To: <157324878956.910124.856248605977418231.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 14:52:06 -0800
Message-ID: <CAEf4BzZOwFf1Ht3fr7_v9VfhQgesko7guPwPhDAJ+AbRduWfOQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/6] libbpf: Use pr_warn() when printing
 netlink errors
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 1:33 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> The netlink functions were using fprintf(stderr, ) directly to print out
> error messages, instead of going through the usual logging macros. This
> makes it impossible for the calling application to silence or redirect
> those error messages. Fix this by switching to pr_warn() in nlattr.c and
> netlink.c.
>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/netlink.c |    3 ++-
>  tools/lib/bpf/nlattr.c  |   10 +++++-----
>  2 files changed, 7 insertions(+), 6 deletions(-)
>

[...]
