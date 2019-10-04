Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2628CBD6E
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 16:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389172AbfJDOhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 10:37:12 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37355 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389100AbfJDOhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 10:37:12 -0400
Received: by mail-qk1-f193.google.com with SMTP id u184so5996089qkd.4;
        Fri, 04 Oct 2019 07:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LzTxGyjYLTsw0pCip0bemDA+PgNvNEIPY1MQuMvAiEE=;
        b=bxUllsR3CEeaoz+xvdO3CEbPntC/SbNDEtX2BrIszD44zdvREjyEKs7zQgZD2nMcET
         9v53muUfzhm7mLGbjXozvKPvMuSP1nF6O5m2+lJEIxCkFB0MiR8Gyb09EVF+lZDq+ZGH
         CWn7x8cab2R0Rqef44H5JF2aGknyqHZFJdBkPi7JfVpSWPs9hq/+/KVXlfPArmr7QoAC
         boj/iBIhxn/nH05Oxe4xNIv0g67RwXLiNBYq3IeVlEUyzCEBAOuTqKxMcKq2F1sXzTjm
         bcnYlg8OYkIzbZgbZS7B8JwAK98X9MYUnql4uqACHtRtoXGqpmzj5+/mLesYKQnZwytl
         evpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LzTxGyjYLTsw0pCip0bemDA+PgNvNEIPY1MQuMvAiEE=;
        b=LZG9XvR4ZtA4/ws0YgPt3cLPpV/I3cGXsnDictfq7jhQFNNUbh7FCCjR5EHzLiG1ij
         zT9ZveqdipLioOFWfy282d8ueHGvnQV6jOptNsxyy+sVdvO34k1erYQHN1s5oCGNIalW
         dsX1+hdiAqXwaxPP76R9ka0JkHIpayf7jPo9jLFITu+lBiPijCfg6Maji8zUtNYgh216
         zEpVksYqf9n4GHUxnS6/o9tVdYwA6993IAaW9XtU9/H9srhY5IjlZckOXLmavt5PZTc5
         Dgpmi0g8O/Au57UEmp/Yo4RY2xmW5uQWC+TAC6V2GULWPLXPZyDgsPrGoeghPOAmZ2kv
         X+9w==
X-Gm-Message-State: APjAAAW0PQNO4QmVpT4NClcL9mHJs2wITiuiy1I6xP8crNVU/LsEC9tG
        2Zbpg2VQG3XkZgL5fn2DJ3Y5k4j5HKM+16KwXS8QEu2aN0PwHA==
X-Google-Smtp-Source: APXvYqzEaYjOSNW3k3r1SKGyMbgBPc0MMMjZ4rv9+Ayqc4HWtOkHB5dggelmH/rRS+NEAeFIWCg9RJ9FqfU7MZsf4ks=
X-Received: by 2002:a05:620a:119a:: with SMTP id b26mr10163076qkk.39.1570199830618;
 Fri, 04 Oct 2019 07:37:10 -0700 (PDT)
MIME-Version: 1.0
References: <20191003084321.1431906-1-toke@redhat.com> <CAEf4BzZpksMGZhggHd=wHVStrN9Wb8RRw-PyDm7fGL3A7YSXdQ@mail.gmail.com>
 <87r23soo75.fsf@toke.dk>
In-Reply-To: <87r23soo75.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Oct 2019 07:36:59 -0700
Message-ID: <CAEf4Bzb0LmgdXh-P7uKjw-n-DuDphB4zYuaj0C+kmdF0xEdWyw@mail.gmail.com>
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

On Fri, Oct 4, 2019 at 2:27 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Thu, Oct 3, 2019 at 1:46 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@r=
edhat.com> wrote:
> >>
> >> Using cscope and/or TAGS files for navigating the source code is usefu=
l.
> >> Add simple targets to the Makefile to generate the index files for bot=
h
> >> tools.
> >>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >
> > Thanks a lot for adding this!
> >
> > I tested cscope only and it works (especially without -k), so:
> >
> > Tested-by: Andrii Nakryiko <andriin@fb.com>
> >
> >
> >>  tools/lib/bpf/.gitignore |  2 ++
> >>  tools/lib/bpf/Makefile   | 10 +++++++++-
> >>  2 files changed, 11 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/tools/lib/bpf/.gitignore b/tools/lib/bpf/.gitignore
> >> index d9e9dec04605..c1057c01223e 100644
> >> --- a/tools/lib/bpf/.gitignore
> >> +++ b/tools/lib/bpf/.gitignore
> >> @@ -3,3 +3,5 @@ libbpf.pc
> >>  FEATURE-DUMP.libbpf
> >>  test_libbpf
> >>  libbpf.so.*
> >> +TAGS
> >> +cscope.*
> >> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> >> index c6f94cffe06e..57df6b933196 100644
> >> --- a/tools/lib/bpf/Makefile
> >> +++ b/tools/lib/bpf/Makefile
> >> @@ -262,7 +262,7 @@ clean:
> >>
> >>
> >>
> >> -PHONY +=3D force elfdep bpfdep
> >> +PHONY +=3D force elfdep bpfdep cscope TAGS
> >>  force:
> >>
> >>  elfdep:
> >> @@ -271,6 +271,14 @@ elfdep:
> >>  bpfdep:
> >>         @if [ "$(feature-bpf)" !=3D "1" ]; then echo "BPF API too old"=
; exit 1 ; fi
> >>
> >> +cscope:
> >> +       (echo \-k; echo \-q; for f in *.c *.h; do echo $$f; done) > cs=
cope.files
> >> +       cscope -b -f cscope.out
> >
> > 1. I'd drop -k, given libbpf is user-land library, so it's convenient
> > to jump into system headers for some of BPF definitions.
>
> Well, the reason I included it was that when using the version in the
> kernel tree, I found it really annoying to jump to kernel headers
> installed in the system. Then I'd rather the jump fails and I can go
> lookup the header in the kernel tree myself.
>
> So maybe we should rather use -I to point at the parent directory? You
> guys could then strip that when syncing to the github repo?

-I will allow to jump into kernel repo includes, right? That would be
even better!

>
> > 2. Wouldn't this be simpler and work exactly the same?
> >
> > ls *.c *.h > cscope.files
> > cscope -b -q -f cscope.out
>
> Well, I usually avoid 'ls' because I have it aliased in my shell so it
> prints more info than just the file names. But I don't suppose that's an
> issue inside the Makefile, so will fix :)
>
> >> +
> >> +TAGS:
> >
> > let's make it lower-case, please? Linux makefile supports both `make
> > tags` and `make TAGS`, but all-caps is terrible :)
>
> You mean just rename the 'make' target, right? Sure, can do...
>
> As for the file itself, I think the version actually on what you use to
> generate the tags file. 'ctags' generates lower-case 'tags' by default,
> while 'etags' generates 'TAGS'.
>
> I don't use either, so dunno why that different exists, and if it's
> actually meaningful? Should we do both?

Me neither, but yeah, I was referring to `make tags` target only.

>
> >> +       rm -f TAGS
> >> +       echo *.c *.h | xargs etags -a
> >
> > nit: might as well do ls *.c *.h for consistency with cscope
> > suggestion above (though in both cases we just rely on shell expansion
> > logic, so doesn't matter).
>
> Heh, pedantic much? ;)
> But OK, I have no strong feelings one way or the other...
>

Guilty as charged :) Thanks!

> -Toke
>
