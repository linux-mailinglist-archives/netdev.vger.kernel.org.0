Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEBCCBD86
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389042AbfJDOjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:39:42 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38558 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388840AbfJDOjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 10:39:42 -0400
Received: by mail-qt1-f196.google.com with SMTP id j31so8858368qta.5;
        Fri, 04 Oct 2019 07:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=322hdcCW0dkNGxff20XnRBAe5qzhpWXkSO9cVNvWYUY=;
        b=n8HtFp99rngdvd7McMeRWe2GqyArKw5wgUV9SeTkCEDt0tT4usSNFqHKdUGXNS5GZR
         tIQ4ATlzIcTLqD4guzQHaQTfO8wzbV9nqff4E1ASlbKLUrqlJsxWSTxREbwmlpLuhXRS
         B84OuVdHAHsH1w8U4TyP85llcLL0bX5Riq4B2WoOtvTSsCJ0BeasjSdPNddbMZxqMukY
         w4xglnupgDDuC1WaJzO9FP5Ck5381izUWQFM8IhF1KIqqXheMH1P8RWSTgs4ffOj4u5t
         KVWopuypsybTqjOu7DIVEjzO+sw58o976zTosAcwpRf+SLWPD37tgHxvO1x+sMXKPHDb
         keow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=322hdcCW0dkNGxff20XnRBAe5qzhpWXkSO9cVNvWYUY=;
        b=DyQ+t5971BQKShJRE/70YeihxScvFZC9w4BcZx2uIJkDepkGvMWbSTzoskLXRbTMnT
         mu3fDvYmC7nzq/E3qsa6cptKPMt9MnXPaoHqhfeBt1QSVkjGDuVgVq5GL/Sh7lH3SSlE
         2jD+pz4R6fhp7XnppP8PriCOD44t5fF2Hc1FZlpyENbyK6UmXVw2lgf2luBwURBlNom3
         0JCfs/b+bpr0HU02ACsnGI+nF0k/BRhgL0rM9f/ajJffiPDGgL5RaPGOhXU7ggYZENNF
         Ip6tVHUmFpixJgWOoK4Y20j2qxHBfQ4IXUyeErjPTY5NQXuhq6ajrUVPLHmchb4ovXZU
         L+nw==
X-Gm-Message-State: APjAAAWWJAvki8RDBZwAllCtZiXovtHXNzHRI/FCMRJNmDmyXIRlTOlE
        ZMi91qLlb78Gp7qGZEZK9lEANid3rAFwPnVlom0=
X-Google-Smtp-Source: APXvYqwzkfENTgLgXZsMHvqBKI+dCDhvqPk0XhsOatmMr3Qo3bA0dMe3icn+7HptHRmEsYpyhCdeyIsl/bfp+AQZcYc=
X-Received: by 2002:a0c:ae9a:: with SMTP id j26mr14499463qvd.163.1570199980922;
 Fri, 04 Oct 2019 07:39:40 -0700 (PDT)
MIME-Version: 1.0
References: <20191003084321.1431906-1-toke@redhat.com> <CAEf4BzZpksMGZhggHd=wHVStrN9Wb8RRw-PyDm7fGL3A7YSXdQ@mail.gmail.com>
 <87r23soo75.fsf@toke.dk> <CAEf4Bzb0LmgdXh-P7uKjw-n-DuDphB4zYuaj0C+kmdF0xEdWyw@mail.gmail.com>
In-Reply-To: <CAEf4Bzb0LmgdXh-P7uKjw-n-DuDphB4zYuaj0C+kmdF0xEdWyw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Oct 2019 07:39:29 -0700
Message-ID: <CAEf4Bzb7YoXq5HHc=u4U_3k7wH8wV16PJ3K3noGYyB_jy-2q=Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Add cscope and TAGS targets to Makefile
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 7:36 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Oct 4, 2019 at 2:27 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@red=
hat.com> wrote:
> >
> > Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >
> > > On Thu, Oct 3, 2019 at 1:46 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
> > >>
> > >> Using cscope and/or TAGS files for navigating the source code is use=
ful.
> > >> Add simple targets to the Makefile to generate the index files for b=
oth
> > >> tools.
> > >>
> > >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > >> ---
> > >
> > > Thanks a lot for adding this!
> > >
> > > I tested cscope only and it works (especially without -k), so:
> > >
> > > Tested-by: Andrii Nakryiko <andriin@fb.com>
> > >
> > >
> > >>  tools/lib/bpf/.gitignore |  2 ++
> > >>  tools/lib/bpf/Makefile   | 10 +++++++++-
> > >>  2 files changed, 11 insertions(+), 1 deletion(-)
> > >>
> > >> diff --git a/tools/lib/bpf/.gitignore b/tools/lib/bpf/.gitignore
> > >> index d9e9dec04605..c1057c01223e 100644
> > >> --- a/tools/lib/bpf/.gitignore
> > >> +++ b/tools/lib/bpf/.gitignore
> > >> @@ -3,3 +3,5 @@ libbpf.pc
> > >>  FEATURE-DUMP.libbpf
> > >>  test_libbpf
> > >>  libbpf.so.*
> > >> +TAGS
> > >> +cscope.*
> > >> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> > >> index c6f94cffe06e..57df6b933196 100644
> > >> --- a/tools/lib/bpf/Makefile
> > >> +++ b/tools/lib/bpf/Makefile
> > >> @@ -262,7 +262,7 @@ clean:
> > >>
> > >>
> > >>
> > >> -PHONY +=3D force elfdep bpfdep
> > >> +PHONY +=3D force elfdep bpfdep cscope TAGS
> > >>  force:
> > >>
> > >>  elfdep:
> > >> @@ -271,6 +271,14 @@ elfdep:
> > >>  bpfdep:
> > >>         @if [ "$(feature-bpf)" !=3D "1" ]; then echo "BPF API too ol=
d"; exit 1 ; fi
> > >>
> > >> +cscope:
> > >> +       (echo \-k; echo \-q; for f in *.c *.h; do echo $$f; done) > =
cscope.files
> > >> +       cscope -b -f cscope.out
> > >
> > > 1. I'd drop -k, given libbpf is user-land library, so it's convenient
> > > to jump into system headers for some of BPF definitions.
> >
> > Well, the reason I included it was that when using the version in the
> > kernel tree, I found it really annoying to jump to kernel headers
> > installed in the system. Then I'd rather the jump fails and I can go
> > lookup the header in the kernel tree myself.
> >
> > So maybe we should rather use -I to point at the parent directory? You
> > guys could then strip that when syncing to the github repo?
>
> -I will allow to jump into kernel repo includes, right? That would be
> even better!

Oh, and feel free to add:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> >
> > > 2. Wouldn't this be simpler and work exactly the same?
> > >
> > > ls *.c *.h > cscope.files
> > > cscope -b -q -f cscope.out
> >
> > Well, I usually avoid 'ls' because I have it aliased in my shell so it
> > prints more info than just the file names. But I don't suppose that's a=
n
> > issue inside the Makefile, so will fix :)
> >
> > >> +
> > >> +TAGS:
> > >
> > > let's make it lower-case, please? Linux makefile supports both `make
> > > tags` and `make TAGS`, but all-caps is terrible :)
> >
> > You mean just rename the 'make' target, right? Sure, can do...
> >
> > As for the file itself, I think the version actually on what you use to
> > generate the tags file. 'ctags' generates lower-case 'tags' by default,
> > while 'etags' generates 'TAGS'.
> >
> > I don't use either, so dunno why that different exists, and if it's
> > actually meaningful? Should we do both?
>
> Me neither, but yeah, I was referring to `make tags` target only.
>
> >
> > >> +       rm -f TAGS
> > >> +       echo *.c *.h | xargs etags -a
> > >
> > > nit: might as well do ls *.c *.h for consistency with cscope
> > > suggestion above (though in both cases we just rely on shell expansio=
n
> > > logic, so doesn't matter).
> >
> > Heh, pedantic much? ;)
> > But OK, I have no strong feelings one way or the other...
> >
>
> Guilty as charged :) Thanks!
>
> > -Toke
> >
