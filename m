Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20FB3F5BB2
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKHXQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:16:58 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:43518 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKHXQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 18:16:58 -0500
Received: by mail-qv1-f68.google.com with SMTP id cg2so2874186qvb.10;
        Fri, 08 Nov 2019 15:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XnUYRQCprUGek7oCJJDaNl/6dWM/aS6EQrXD5UUlk0I=;
        b=Ou4MVs2euDEVJerZE+fWK+6YaDAjeIVhXRKzP6j39xAFxYN7uk61imvMjKG/6dtkwK
         /wmBfqlev4dLGcb/WfiK0i8z27xbFMMATYGBEa4Y1WxTTC/C80Acg/ifrAbMHVtC5L6d
         05mLdKrNIlyY87aMQu5ZjD4Le5QZodJy5c1hYlkUvbzpMBeDHIoO1rSE1pe4bvJ3ahId
         f2aod8zSe+HnyMwsVkHWTbmXcyenTLl8L2DWG7plgjKodqWJyldGHmmL6Z4zOjFr5kUK
         rm/dLT4ILlK5+cuprrZCxUj+Ls8yfOvrSWiN5tHI9SjHmoGqE1jWQbader5m4RMg7DAr
         48kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XnUYRQCprUGek7oCJJDaNl/6dWM/aS6EQrXD5UUlk0I=;
        b=rCH4Ux/vu8W2d9ITjv6qh3Ca7WtYBNgE3PWXYHbq6pTZFjBjxXMEHqu4voD9IX4rJo
         thc51Y56HRm6rn/jO4NNwqkY5xZJMuJne5UQSWZUjSPKJjc/BeRPNSInPGBFCVGwqW3m
         jdc37nANIh4G/ew/Ik/9J5plSyzDmD9m5pkvkSE4thC6OhnkbsSMfvhiNNOsVK0MJ6gv
         qtVVtPFsyE9+1KU/khxu6TgJtjoCdqk9gwhCVO30pr3Key7cIMXsGv9c0cL+DIIe0AJq
         N55Z5T+UyisTsbYTDtsoXtzXK8KGuPFYhFyGIrYfISU6A+H4hp5d+za1+YdlsmXsooWA
         ptPQ==
X-Gm-Message-State: APjAAAWqHMh8BRPK9ykRi329TXboaszEHfZ1BZoABVI7ebNMnRL5cssu
        YaUCJlrIpwM0WuhOPYzU00AdePknQ4qFn43bvwY=
X-Google-Smtp-Source: APXvYqxdtztCBKJmvzpITe+hgBzDt0jW4q0CdxwkIX8Zt4n0jMlKLeiHSWpvOykJNzr1NvqKrudUtE9uv/Ebv8Jt31o=
X-Received: by 2002:ad4:4e4a:: with SMTP id eb10mr11749908qvb.228.1573255016902;
 Fri, 08 Nov 2019 15:16:56 -0800 (PST)
MIME-Version: 1.0
References: <157324878503.910124.12936814523952521484.stgit@toke.dk> <157324879178.910124.2574532467255490597.stgit@toke.dk>
In-Reply-To: <157324879178.910124.2574532467255490597.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 15:16:45 -0800
Message-ID: <CAEf4BzZAfXjh+QdaRPHyNJKiW3PzL8UF38_-AridYdM7Bg54_Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 6/6] libbpf: Add getter for program size
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
> This adds a new getter for the BPF program size (in bytes). This is usefu=
l
> for a caller that is trying to predict how much memory will be locked by
> loading a BPF object into the kernel.
>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Can you add comment mentioning that this is size in bytes, not in
number of instructions? It's certainly will be a first question anyone
using this will ask.

I think it's good to have this, but I don't think you can really
predict how much memory will be used. I'd expect memory used by maps
(and not just based on element size and count, but some internal
bookkeeping stuff) would be much bigger factor and not easy to guess.
So beyond just stats dumping, I think this won't be that helpful.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c   |    5 +++++
>  tools/lib/bpf/libbpf.h   |    1 +
>  tools/lib/bpf/libbpf.map |    1 +
>  3 files changed, 7 insertions(+)
>

[...]
