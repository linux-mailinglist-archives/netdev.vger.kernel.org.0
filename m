Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E80D0C407D
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 20:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfJAS4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 14:56:39 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43176 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfJAS4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 14:56:38 -0400
Received: by mail-qk1-f196.google.com with SMTP id h126so12302446qke.10;
        Tue, 01 Oct 2019 11:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5Cmf1TTXZ4yTVhlW+y1azbdE2Jm5mp/CyFGB0eEvMDU=;
        b=mQ3PM+UArDrouVNorVS6f29161X3YZM3EdqVU77VVVJT5SRh1RvvEuB/0uH8yyFgna
         6R/Eqg0ZPTXmP0fjnlEb6YS/kov/iwJXmkYASuV74IT5tAkykH4Vrtdvno6P3/tMbkD7
         Q18X3IvEE8FsrG60/Z0zBxoWM/dNogXiKQvvJ/9N5wT+5q5XmV0mavfKL1pydTCag3Ir
         yNgGIxva8AnjADZqZybsLn9NOY/U79OB86Ol9J2V5tgeiUINV8uMHmyimkXD0yXGVUjG
         rU712CPTETYQHPGfy920Fw5+ito1yrjKtVAwwLdXJZQTK+YWQI8ce04Mk4JHpCEAb6rL
         zU1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5Cmf1TTXZ4yTVhlW+y1azbdE2Jm5mp/CyFGB0eEvMDU=;
        b=SCLfVS//idPa1uAk/kaLO/O6SnrjeIb0QUBD+i0C81hGWRB3A9b61tLTpufIIGhK2F
         ggCvwfPDuOb+YZie9dlaC54x/OpRtnRnMkJB3nVrnlbflPOtD1MNO2kyvRlJHK2zVaB4
         WopvYOZJXHXZCLaXicM13/Ql0KKv1zG181cy2nsN78WRSHMHdJAXrfvw92Z+y/n28YDD
         rXxgNnCQe2GdPmuqdLcS0UExBckNsMeHuiYEIJqam839+AY5k26xFsjJttWSexIYhOsk
         rHdYYZo+inHKZrHq9+KI1vbu2OkK7GAJsXL5VaGRSBe+8ZajqPBSvj4SzxHHBMMe1TxS
         i93A==
X-Gm-Message-State: APjAAAUmjC4J4tt2iybTY8kSy7UbA+KcuFRyI05+W0gK73CUsuRBFSj4
        R8yZpgWgH9dqA1Ny20ihBGZdl5AtvUiA3ggsxAw=
X-Google-Smtp-Source: APXvYqzKKW9/TFaYOi0hhb4NJ0cFV7omiWN/6Ep2Up7SovtOgCZev+Fcb4l+ORl99QIYG3v01dFGUHq2DDs+MQGB5T4=
X-Received: by 2002:a37:4e55:: with SMTP id c82mr7836372qkb.437.1569956195881;
 Tue, 01 Oct 2019 11:56:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190930164239.3697916-1-andriin@fb.com> <871rvwx3fg.fsf@toke.dk>
In-Reply-To: <871rvwx3fg.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Oct 2019 11:56:24 -0700
Message-ID: <CAEf4BzYvx7wpy79mTgKMuZop3_qYCCOzk4XWoDKiq7Fbj+gAow@mail.gmail.com>
Subject: Re: [RFC][PATCH bpf-next] libbpf: add bpf_object__open_{file,mem} w/
 sized opts
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        KP Singh <kpsingh@chromium.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 1:42 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andriin@fb.com> writes:
>
> > Add new set of bpf_object__open APIs using new approach to optional
> > parameters extensibility allowing simpler ABI compatibility approach.
> >
> > This patch demonstrates an approach to implementing libbpf APIs that
> > makes it easy to extend existing APIs with extra optional parameters in
> > such a way, that ABI compatibility is preserved without having to do
> > symbol versioning and generating lots of boilerplate code to handle it.
> > To facilitate succinct code for working with options, add OPTS_VALID,
> > OPTS_HAS, and OPTS_GET macros that hide all the NULL and size checks.
> >
> > Additionally, newly added libbpf APIs are encouraged to follow similar
> > pattern of having all mandatory parameters as formal function parameter=
s
> > and always have optional (NULL-able) xxx_opts struct, which should
> > always have real struct size as a first field and the rest would be
> > optional parameters added over time, which tune the behavior of existin=
g
> > API, if specified by user.
>
> I think this is a reasonable idea. It does require some care when adding
> new options, though. They have to be truly optional. I.e., I could
> imagine that we will have cases where the behaviour might need to be
> different if a program doesn't understand a particular option (I am
> working on such a case in the kernel ATM). You could conceivably use the
> OPTS_HAS() macro to test for this case in the code, but that breaks if a
> program is recompiled with no functional change: then it would *appear*
> to "understand" that option, but not react properly to it.

So let me double-check I'm understanding this correctly.

Let's say we have some initial options like:

// VERSION 1
struct bla_opts {
    size_t sz;
};

// VERSION 2
Then in newer version we add new field:
struct bla_opts {
    int awesomeness_trigger;
};

Are you saying that if program was built with VERSION 1 in mind (so sz
=3D 8 for bla_opts, so awesomeness_trigger can't be even specified),
then that should be different from the program built against VERSION 2
and specifying .awesomeness_trigger =3D 0?
Do I get this right? I'm not sure how to otherwise interpret what you
are saying, so please elaborate if I didn't get the idea.

If that's what you are saying, then I think we shouldn't (and we
really can't, see Jesper's remark about padding) distinguish between
whether field was not "physically" there or whether it was just set to
default 0 value. Treating this uniformly as 0 makes libbpf logic
simpler and consistent and behavior much less surprising.

>
> In other words, this should only be used for truly optional bits (like
> flags) where the default corresponds to unchanged behaviour relative to
> when the option was added.

This I agree 100%, furthermore, any added new option has to behave
like this. If that's not the case, then it has to be a new API
function or at least another symbol version.

>
> A few comments on the syntax below...
>
>
> > +static struct bpf_object *
> > +__bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
> > +                    struct bpf_object_open_opts *opts, bool enforce_kv=
er)
>
> I realise this is an internal function, but why does it have a
> non-optional parameter *after* the opts?

Oh, no reason, added it later and I'm hoping to remove it completely.
Current bpf_object__open_buffer always enforces kver presence in a
program, which differs from bpf_object__open behavior (where it
depends on provided .prog_type argument), so with this I tried to
preserve existing behavior. But in the final version of this patch I
think I'll just make this kver archaic business in libbpf not
enforced. It's been deleted from kernel long time ago, there is no
good reason to keep enforcing this in libbpf. If someone is running
against old kernel and didn't specify kver, they'll get error anyway.
Libbpf will just need to make sure to pass kver through, if it's
specified. Thoughts?

>
> >       char tmp_name[64];
> > +     const char *name;
> >
> > -     /* param validation */
> > -     if (!obj_buf || obj_buf_sz <=3D 0)
> > -             return NULL;
> > +     if (!OPTS_VALID(opts) || !obj_buf || obj_buf_sz =3D=3D 0)
> > +             return ERR_PTR(-EINVAL);
> >
> > +     name =3D OPTS_GET(opts, object_name, NULL);
> >       if (!name) {
> >               snprintf(tmp_name, sizeof(tmp_name), "%lx-%lx",
> >                        (unsigned long)obj_buf,
> >                        (unsigned long)obj_buf_sz);
> >               name =3D tmp_name;
> >       }
> > +
> >       pr_debug("loading object '%s' from buffer\n", name);
> >
> > -     return __bpf_object__open(name, obj_buf, obj_buf_sz, true, true);
> > +     return __bpf_object__open(name, obj_buf, obj_buf_sz, enforce_kver=
, 0);
> > +}
> > +
> > +struct bpf_object *
> > +bpf_object__open_mem(const void *obj_buf, size_t obj_buf_sz,
> > +                  struct bpf_object_open_opts *opts)
> > +{
> > +     return __bpf_object__open_mem(obj_buf, obj_buf_sz, opts, false);
> > +}
> > +
> > +struct bpf_object *
> > +bpf_object__open_buffer(const void *obj_buf, size_t obj_buf_sz, const =
char *name)
> > +{
> > +     struct bpf_object_open_opts opts =3D {
> > +             .sz =3D sizeof(struct bpf_object_open_opts),
> > +             .object_name =3D name,
> > +     };
>
> I think this usage with the "size in struct" model is really awkward.
> Could we define a macro to help hide it? E.g.,
>
> #define BPF_OPTS_TYPE(type) struct bpf_ ## type ## _opts
> #define DECLARE_BPF_OPTS(var, type) BPF_OPTS_TYPE(type) var =3D { .sz =3D=
 sizeof(BPF_OPTS_TYPE(type)); }

We certainly could (though I'd maintain that type specified full
struct name, makes it easier to navigate/grep code), but then we'll be
preventing this nice syntax of initializing structs, which makes me
very said because I love that syntax.
>
> Then the usage code could be:
>
> DECLARE_BPF_OPTS(opts, object_open);
> opts.object_name =3D name;
>
> Still not ideal, but at least it's less boiler plate for the caller, and
> people will be less likely to mess up by forgetting to add the size.

What do you think about this?

#define BPF_OPTS(type, name, ...) \
        struct type name =3D { \
                .sz =3D sizeof(struct type), \
                __VA_ARGS__ \
        }

struct bla_opts {
        size_t sz;
        int opt1;
        void *opt2;
        const char *opt3;
};

int main() {
        BPF_OPTS(bla_opts, opts,
                .opt1 =3D 123,
                .opt2 =3D NULL,
                .opt3 =3D "fancy",
        );

        /* then also */
        BPF_OPTS(bla_opts, old_school);
        old_school.opt1 =3D 256;

        return opts.opt1;
}

Thanks a lot for a thoughtful feedback, Toke!

>
> -Toke
>
