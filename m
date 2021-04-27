Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2A536CA8E
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 19:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbhD0Rqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 13:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbhD0Rqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 13:46:33 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC4CC061574;
        Tue, 27 Apr 2021 10:45:50 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id z1so70364917ybf.6;
        Tue, 27 Apr 2021 10:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XgMTxuUnQa2NKHgZKMGZHmGdLmQnXa/coa3xDwJBEwg=;
        b=vbiX1XkgZKfjKlL/u5eU130E4uvI1N8aekf8fXB/pKpWBPMxG9MDU/8fhfYicRV/9V
         7yWLsC2qCXJLz6t624VuwQPBicZc4qR6ODj4ROyLKm8NP2ypbIfeFmEs/4PX3TC2g7a+
         NDXKD+zzYmgqvEv7fGhIEcma3C4aF2ouMJEP/50/uiGCcorGUK4msVw9DBaiuvST3zWk
         4ufcdSklbOvBQI6mpa8Yx05XHTyUwyUbCqmwUSfshU3bqWXEGzqfIv7VM+UCmVpA8Evu
         84d+BMUzS95dXJOHUSD3Derx7cbcXfTRWNDh2Ex7xhjxKsA0kF3CVp8NuYtSbK7KbA3d
         aWaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XgMTxuUnQa2NKHgZKMGZHmGdLmQnXa/coa3xDwJBEwg=;
        b=UBgSuNSAE2m7eVaiM4Cch3/VvG2tGJbm5T3+OBfknjVh4Z7KpQ6uGcTlnfQ4IJPdiE
         0FLHxsYujXhOtwgkEdy4UmiuyqBV2Lyfwtv8Lizt9fGBnuCnw2JnY1V4K3yfYTr7NnJZ
         e/6qLH/tRe1v76tOQdHmIxcZoVgltKI81LKPYQ2WJUj9W2GdGXk1HPvpDqa3z0ZUrOZg
         0u1XyRejwicWHJEy9E2yeHaKnc17v5zlwsDXuPZYcTowWr/EJ5zdfuAqyTl1yBGy4spV
         mY6GAGaZ2b5mbL7icKqAnLBNsTyHkFE81ABcExN2fOJoNXnR2wlcZgco3+223hR9OngX
         uWHQ==
X-Gm-Message-State: AOAM532bkdgdKaTeWsXbLv5APyINJMk9uiI8hxTb3DIrB9N6+QuHhIMY
        LqeWfefts1yRMv1KbJiY46l6Rj87plXBMMR2loc=
X-Google-Smtp-Source: ABdhPJzHD+nEAcmcoQJxT+fUQOy2T9Fk9SK/yDBT9sQi9OwntOKDSnlZp8ZhfUKED3T/G/W2Ukdfs1Lh3NqkpUEfyFk=
X-Received: by 2002:a25:c4c5:: with SMTP id u188mr34329832ybf.425.1619545549517;
 Tue, 27 Apr 2021 10:45:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210423002646.35043-1-alexei.starovoitov@gmail.com>
 <20210423002646.35043-11-alexei.starovoitov@gmail.com> <CAEf4BzYkzzN=ZD2X1bOg8U39Whbe6oTPuUEMOpACw6NPEW69NA@mail.gmail.com>
 <20210427033707.fu7hsm6xi5ayx6he@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210427033707.fu7hsm6xi5ayx6he@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 27 Apr 2021 10:45:38 -0700
Message-ID: <CAEf4BzaPDF8h9t1xqMo-hKqp=J_bE1OtWXh+jugZxV597qjdaw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 10/16] bpf: Add bpf_btf_find_by_name_kind() helper.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 8:37 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Apr 26, 2021 at 03:46:29PM -0700, Andrii Nakryiko wrote:
> > On Thu, Apr 22, 2021 at 5:27 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > Add new helper:
> > >
> > > long bpf_btf_find_by_name_kind(u32 btf_fd, char *name, u32 kind, int flags)
> > >         Description
> > >                 Find given name with given type in BTF pointed to by btf_fd.
> > >                 If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
> > >         Return
> > >                 Returns btf_id and btf_obj_fd in lower and upper 32 bits.
> > >
> > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > ---
> > >  include/linux/bpf.h            |  1 +
> > >  include/uapi/linux/bpf.h       |  8 ++++
> > >  kernel/bpf/btf.c               | 68 ++++++++++++++++++++++++++++++++++
> > >  kernel/bpf/syscall.c           |  2 +
> > >  tools/include/uapi/linux/bpf.h |  8 ++++
> > >  5 files changed, 87 insertions(+)
> > >
> > > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > > index 0f841bd0cb85..4cf361eb6a80 100644
> > > --- a/include/linux/bpf.h
> > > +++ b/include/linux/bpf.h
> > > @@ -1972,6 +1972,7 @@ extern const struct bpf_func_proto bpf_get_socket_ptr_cookie_proto;
> > >  extern const struct bpf_func_proto bpf_task_storage_get_proto;
> > >  extern const struct bpf_func_proto bpf_task_storage_delete_proto;
> > >  extern const struct bpf_func_proto bpf_for_each_map_elem_proto;
> > > +extern const struct bpf_func_proto bpf_btf_find_by_name_kind_proto;
> > >
> > >  const struct bpf_func_proto *bpf_tracing_func_proto(
> > >         enum bpf_func_id func_id, const struct bpf_prog *prog);
> > > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > > index de58a714ed36..253f5f031f08 100644
> > > --- a/include/uapi/linux/bpf.h
> > > +++ b/include/uapi/linux/bpf.h
> > > @@ -4748,6 +4748,13 @@ union bpf_attr {
> > >   *             Execute bpf syscall with given arguments.
> > >   *     Return
> > >   *             A syscall result.
> > > + *
> > > + * long bpf_btf_find_by_name_kind(u32 btf_fd, char *name, u32 kind, int flags)
> > > + *     Description
> > > + *             Find given name with given type in BTF pointed to by btf_fd.
> >
> > "Find BTF type with given name"? Should the limits on name length be
>
> +1
>
> > specified? KSYM_NAME_LEN is a pretty arbitrary restriction.
>
> that's implementation detail that shouldn't leak into uapi.
>
> > Also,
> > would it still work fine if the caller provides a pointer to a much
> > shorter piece of memory?
> >
> > Why not add name_sz right after name, as we do with a lot of other
> > arguments like this?
>
> That's an option too, but then the helper will have 5 args and 'flags'
> would be likely useless. I mean unlikely it will help extending it.
> I was thinking about ARG_PTR_TO_CONST_STR, but it doesn't work,
> since blob is writeable by the prog. It's read only from user space.
> I'm fine with name, name_sz though.

Yeah, I figured ARG_PTR_TO_CONST_STR isn't an option here. By "flags
would be useless" you mean that you'd use another parameter if some
flags were set? Did we ever do that to existing helpers? We can always
add a new helper, if necessary. name + name_sz seems less error-prone,
tbh.

>
> >
> > > + *             If btf_fd is zero look for the name in vmlinux BTF and in module's BTFs.
> > > + *     Return
> > > + *             Returns btf_id and btf_obj_fd in lower and upper 32 bits.
> >
> > Mention that for vmlinux BTF btf_obj_fd will be zero? Also who "owns"
> > the FD? If the BPF program doesn't close it, when are they going to be
> > cleaned up?
>
> just like bpf_sys_bpf. Who owns returned FD? The program that called
> the helper, of course.

"program" as in the user-space process that did bpf_prog_test_run(),
right? In the cover letter you mentioned that BPF_PROG_TYPE_SYSCALL
might be called on syscall entry in the future, for that case there is
no clear "owning" process, so would be curious to see how that problem
gets solved.

> In the current shape of loader prog these btf fds are cleaned up correctly
> in success and in error case.
> Not all FDs though. map fds will stay around if bpf_sys_bpf(prog_load) fails to load.
> Tweaking loader prog to close all FDs in error case is on todo list.

Ok, good, that seems important.
