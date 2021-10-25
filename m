Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E2D439AFD
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 17:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233689AbhJYQBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233628AbhJYQBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:01:33 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD17AC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 08:59:11 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id w8so10723284qts.4
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 08:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZjV3URyePb4s53GQk1M02gG3V/4dpnLt8uVS6yoYgnE=;
        b=nnpRH9u3J9+2NYYU+U5s0uyFX12y5FxDsv6mqiCZ47soMyWTZD5+rwHXOjUieiuTaA
         pGQGs6sVDqn5X//TqfHL/cD+1+rF+EplCDmmiURX7RnXNq2ZelsgPU8DfIHE2OKK1pB4
         jCsqTcqj0bZfhl14PSguoM5dIX1X+5Vb5hlC2qtezjoYiLIc6uu+H4jt143CsTAOvaxz
         i7x5qJfiddBwkevY0s6dCZ5wJCZPz55V0P0xoB6V9xXLFx9PLohGToNWiCj3GE0xQ9/p
         YiAZUyAWYHCVMQqn6d50bQku8pkpVBrL12R3z8cNTBKagNyIYESOpEUE5fYp6L5Y73rS
         q8KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZjV3URyePb4s53GQk1M02gG3V/4dpnLt8uVS6yoYgnE=;
        b=JPZOI9Wk3cRT9mLN5fcBsFDuik5DDwMDyZsjmrGNJxvzi0PJAfEDtC/X4PNflaIGUe
         VCkoosZlhG8Y+nZILXFv4zdgJRMuSwcBDv5lQcweXnZA85GAx740KNKZguGlIEAn8YLH
         sHXnPgFXSdJ7zd3lir4H+JWrVqI6bm6xx+x+3To1nlxXeVVfYA6L7+vOsKMNfqKmH0w7
         D9Ovq8glSu+tNW8oXq+BfY195tfosO66ZKKX8QZFd6Xlmenf+cW9Pn+wN8oBl4HzdiA4
         1N2uc1sWfUodYeeTCkLwDAtTjGF0eGZmYMnbv93qWnSGm2ZRWgZry4lgJAek06WL8BSS
         52dQ==
X-Gm-Message-State: AOAM533Bld7BFblEdlVWtScgMnh9oVk+g3edth23SgMkwEjQ8Z71TyZv
        UlgKicHzjv9bCSVlQ7tM8yt9T6ZkgJH/I6waXWMz/g==
X-Google-Smtp-Source: ABdhPJxlSjBR5isPLhvz6sSXZyIqbg53tHQ5mPFWC0D/kz3HeGGenZQKpsQy9NwnmXMN5kDzEiFWORB+wBjbYYSSSeg=
X-Received: by 2002:ac8:5cd0:: with SMTP id s16mr18546411qta.287.1635177550570;
 Mon, 25 Oct 2021 08:59:10 -0700 (PDT)
MIME-Version: 1.0
References: <20211011155636.2666408-1-sdf@google.com> <20211011155636.2666408-2-sdf@google.com>
 <6172ef4180b84_840632087a@john-XPS-13-9370.notmuch>
In-Reply-To: <6172ef4180b84_840632087a@john-XPS-13-9370.notmuch>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 25 Oct 2021 08:58:59 -0700
Message-ID: <CAKH8qBuR4bYn1POgu0TF428vApknvMNPAng5qMuiKXCpcg8CQQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpftool: don't append / to the progtype
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 10:05 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Stanislav Fomichev wrote:
> > Otherwise, attaching with bpftool doesn't work with strict section names.
> >
> > Also, switch to libbpf strict mode to use the latest conventions
> > (note, I don't think we have any cli api guarantees?).
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  tools/bpf/bpftool/main.c |  4 ++++
> >  tools/bpf/bpftool/prog.c | 15 +--------------
> >  2 files changed, 5 insertions(+), 14 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> > index 02eaaf065f65..8223bac1e401 100644
> > --- a/tools/bpf/bpftool/main.c
> > +++ b/tools/bpf/bpftool/main.c
> > @@ -409,6 +409,10 @@ int main(int argc, char **argv)
> >       block_mount = false;
> >       bin_name = argv[0];
> >
> > +     ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
> > +     if (ret)
> > +             p_err("failed to enable libbpf strict mode: %d", ret);
> > +
>
> Would it better to just warn? Seems like this shouldn't be fatal from
> bpftool side?
>
> Also this is a potentially breaking change correct? Programs that _did_
> work in the unstrict might suddently fail in the strict mode? If this
> is the case whats the versioning plan? We don't want to leak these
> type of changes across multiple versions, idealy we have a hard
> break and bump the version.
>
> I didn't catch a cover letter on the series. A small
> note about versioning and upgrading bpftool would be helpful.

Yeah, it is a breaking change, every program that has non-strict
section names will be rejected.

I mentioned that in the bpftool's commit description:
Also, switch to libbpf strict mode to use the latest conventions
(note, I don't think we have any cli api guarantees?).

So I'm actually not sure what's the best way to handle this migration
and whether we really provide any cli guarantees to the users. I was
always assuming that bpftool is mostly for debugging/introspection,
but not sure.

As Andrii suggested in another email, I can add a flag to disable this
strict mode. Any better ideas?




> >       hash_init(prog_table.table);
> >       hash_init(map_table.table);
> >       hash_init(link_table.table);
> > diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> > index 277d51c4c5d9..17505dc1243e 100644
> > --- a/tools/bpf/bpftool/prog.c
> > +++ b/tools/bpf/bpftool/prog.c
> > @@ -1396,8 +1396,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> >
> >       while (argc) {
> >               if (is_prefix(*argv, "type")) {
> > -                     char *type;
> > -
> >                       NEXT_ARG();
> >
> >                       if (common_prog_type != BPF_PROG_TYPE_UNSPEC) {
> > @@ -1407,19 +1405,8 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
> >                       if (!REQ_ARGS(1))
> >                               goto err_free_reuse_maps;
> >
> > -                     /* Put a '/' at the end of type to appease libbpf */
> > -                     type = malloc(strlen(*argv) + 2);
> > -                     if (!type) {
> > -                             p_err("mem alloc failed");
> > -                             goto err_free_reuse_maps;
> > -                     }
> > -                     *type = 0;
> > -                     strcat(type, *argv);
> > -                     strcat(type, "/");
> > -
> > -                     err = get_prog_type_by_name(type, &common_prog_type,
> > +                     err = get_prog_type_by_name(*argv, &common_prog_type,
> >                                                   &expected_attach_type);
> > -                     free(type);
> >                       if (err < 0)
> >                               goto err_free_reuse_maps;
>
> This wont potentially break existing programs correct? It looks like
> just adding a '/' should be fine.
>
> Thanks,
> John
