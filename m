Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043961B7B8F
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 18:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgDXQ1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 12:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgDXQ1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 12:27:47 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF71C09B046;
        Fri, 24 Apr 2020 09:27:34 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id j4so10700929qkc.11;
        Fri, 24 Apr 2020 09:27:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x+fUUJZC+/c8g5zIluBggAakJoixVUnYt117PQvinJI=;
        b=cO0f8vN0b6uacnvOKLW4h+1PijwRMQvfJU4mVI9ifU4LidsrbZkr8osrS9E9o6lm0l
         8MIA61E4yeXNkTcLTzK0yhIJHw8UExwXJq0GjoWuZfGvF9Nf/CiM+iJfGTo0nPrBZXka
         ZLWFx5DWreg6Wo7A7Z+yQmyFlvj/i8mJkZlN6kzM1ChXXcwgaIbna917VBI6lLZp1Oe4
         GLQT475VxFc9SxUTmbM3Pva7AIOASA/y6oGQcLEmmG1ltVDSTMYahmPUSw837X8v1aVn
         32WZj1hQGWKtCPWXMoWYj77YuaxNXX/IgOHz7oBlndPPXYmDKhIrD63O2/4oPVLtMlbP
         HFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x+fUUJZC+/c8g5zIluBggAakJoixVUnYt117PQvinJI=;
        b=oOi7wEMBq36gHDoDN0d8++hejP0LrnJnPu6wlYyjGJcGvoiBcksKc/z6zWdCvgLAQl
         gy3QkszcLPV8MYaVI6z7PxUsKb9+zbkmpcClJKjJoDOXE5+6gZSn4g1igOpaHX+19Vc1
         KYx1/4fFlrEtm31BYhSKBqpkqhNcroULntVKgMSuKUZJnVumleJ8q3HoWZ1td/mscs9H
         o792gLEskWwVBjrTNU0FJ/a0z37lNI/ceRk/WBxZjJcbUA0o/HQEaqXln1ceI1vPlI1E
         1ElOY4HD05EYFpaoCwV/tN+vvy5fE+Bo5IsvAG7lfmlvjCaODabfZjJK8yUai1nl/Xd4
         sqwg==
X-Gm-Message-State: AGi0PubgIis1bVWhxL3PUY9mjPvcRHATCbDetXP69N3AjxgKSju618rW
        yDH/q5QUdk3wUymvFwlFwMhjFkZKnkkVGp3xBkQdAQIZCkc=
X-Google-Smtp-Source: APiQypLMqS8hpZ1rMyFwjFIYahxa5/X1rrGWaYDhu4tfP/Srmo2/7kRYCiRDU/MyT8dt3Bh6ZQ+X3EB1aTU4BPlgeYc=
X-Received: by 2002:a37:787:: with SMTP id 129mr9665751qkh.92.1587745653955;
 Fri, 24 Apr 2020 09:27:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200424053505.4111226-1-andriin@fb.com> <20200424053505.4111226-8-andriin@fb.com>
 <34110254-6384-153f-af39-d5f9f3a50acb@isovalent.com>
In-Reply-To: <34110254-6384-153f-af39-d5f9f3a50acb@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 24 Apr 2020 09:27:22 -0700
Message-ID: <CAEf4BzY9tjQm1f8eTyjYjthTF9n6tZ59r1mpUsYWL4+bFuch2Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 07/10] bpftool: expose attach_type-to-string
 array to non-cgroup code
To:     Quentin Monnet <quentin@isovalent.com>
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

On Fri, Apr 24, 2020 at 3:32 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2020-04-23 22:35 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> > Move attach_type_strings into main.h for access in non-cgroup code.
> > bpf_attach_type is used for non-cgroup attach types quite widely now. So also
> > complete missing string translations for non-cgroup attach types.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/bpf/bpftool/cgroup.c | 28 +++-------------------------
> >  tools/bpf/bpftool/main.h   | 32 ++++++++++++++++++++++++++++++++
> >  2 files changed, 35 insertions(+), 25 deletions(-)
> >
> > diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
> > index 62c6a1d7cd18..d1fd9c9f2690 100644
> > --- a/tools/bpf/bpftool/cgroup.c
> > +++ b/tools/bpf/bpftool/cgroup.c
> > @@ -31,35 +31,13 @@
> >
> >  static unsigned int query_flags;
> >
> > -static const char * const attach_type_strings[] = {
> > -     [BPF_CGROUP_INET_INGRESS] = "ingress",
> > -     [BPF_CGROUP_INET_EGRESS] = "egress",
> > -     [BPF_CGROUP_INET_SOCK_CREATE] = "sock_create",
> > -     [BPF_CGROUP_SOCK_OPS] = "sock_ops",
> > -     [BPF_CGROUP_DEVICE] = "device",
> > -     [BPF_CGROUP_INET4_BIND] = "bind4",
> > -     [BPF_CGROUP_INET6_BIND] = "bind6",
> > -     [BPF_CGROUP_INET4_CONNECT] = "connect4",
> > -     [BPF_CGROUP_INET6_CONNECT] = "connect6",
> > -     [BPF_CGROUP_INET4_POST_BIND] = "post_bind4",
> > -     [BPF_CGROUP_INET6_POST_BIND] = "post_bind6",
> > -     [BPF_CGROUP_UDP4_SENDMSG] = "sendmsg4",
> > -     [BPF_CGROUP_UDP6_SENDMSG] = "sendmsg6",
> > -     [BPF_CGROUP_SYSCTL] = "sysctl",
> > -     [BPF_CGROUP_UDP4_RECVMSG] = "recvmsg4",
> > -     [BPF_CGROUP_UDP6_RECVMSG] = "recvmsg6",
> > -     [BPF_CGROUP_GETSOCKOPT] = "getsockopt",
> > -     [BPF_CGROUP_SETSOCKOPT] = "setsockopt",
> > -     [__MAX_BPF_ATTACH_TYPE] = NULL,
>
> So you removed the "[__MAX_BPF_ATTACH_TYPE] = NULL" from the new array,
> if I understand correctly this is because all attach type enum members
> are now in the new attach_type_name[] so we're safe by looping until we
> reach __MAX_BPF_ATTACH_TYPE. Sounds good in theory but...
>

Well, NULL is default value, so having [__MAX_BPF_ATTACH_TYPE] = NULL
just increases ARRAY_SIZE(attach_type_names) by one. Which is
generally not needed, because we do proper < ARRAY_SIZE() checks
everywhere... except for one place. show_bpf_prog in cgroup.c looks up
name directly and can pass NULL into jsonw_string_field which will
crash.

I can fix that by setting [__MAX_BPF_ATTACH_TYPE] to "unknown" or
adding extra check in show_bpf_prog() code? Any preferences?

> > -};
> > -
> >  static enum bpf_attach_type parse_attach_type(const char *str)
> >  {
> >       enum bpf_attach_type type;
> >
> >       for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++) {
> > -             if (attach_type_strings[type] &&
> > -                 is_prefix(str, attach_type_strings[type]))
> > +             if (attach_type_name[type] &&
> > +                 is_prefix(str, attach_type_name[type]))
> >                       return type;
> >       }
>
> ... I'm concerned the "attach_type_name[type]" here could segfault if we
> add a new attach type to the kernel, but don't report it immediately to
> bpftool's array.

I don't think so. Here we'll iterate over all possible bpf_attach_type
(as far as our copy of UAPI header is concerned, of course). If some
of the values don't have entries in attach_type_name array, we'll get
back NULL (same as with explicit [__MAX_BPF_ATTACH_TYPE] = NULL, btw),
which will get handled properly in the loop. And caller will get back
__MAX_BPF_ATTACH_TYPE as bpf_attach_type value. So unless I'm still
missing something, it seems to be working exactly the same as before?

>
> Is there any drawback with keeping the "[__MAX_BPF_ATTACH_TYPE] = NULL"?
> Or change here to loop on ARRAY_SIZE(), as you do in your own patch for
> link?

ARRAY_SIZE() == __MAX_BPF_ATTACH_TYPE, isn't it? Previously ARRAY_SIZE
was (__MAX_BPF_ATTACH_TYPE + 1), but I don't think it's necessary?

The only difference is show_bpf_prog() which now is going to do out of
array reads, while previously it would get NULL. But both cases are
bad and needs fixing.
