Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5AECAAE5
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 19:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404259AbfJCRPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 13:15:09 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40919 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391063AbfJCRPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 13:15:08 -0400
Received: by mail-qt1-f194.google.com with SMTP id f7so4642950qtq.7;
        Thu, 03 Oct 2019 10:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1kB+HNMetC19qZY2o5gFAydwEbfXL/aBhCptGyZn1AQ=;
        b=lLixvvNE/Ob5XE12pVNrGVxwsqRBK7Ms+5GZ7Cw4jptNfPS06bagODYaVro1z7OYf1
         Dxa84Cp6gXDVku2eq9+nRIkZWkNKKjLZt9a3pAagryEHezkDcPVrMM+78F5HHbTTzxrF
         B3UcHwt1uujkZOvTfmqRGoUqdVTmIOpSK2yl61TWE8b8jbStfqlxW4OmzHyLxFiBNu5r
         0+gzfi7tc2lJIeurCBad2qTMagdRTc8cDfsILp2AbWOmaQ2t7mHbJm1SLsdyaDpRhbxL
         255XNTBnf6Xi7LeuMLJnjaT6hWTB4DEujbs9Q4SOetpobeNzeQx/aWMp4xLJoxOPlO3x
         6N3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1kB+HNMetC19qZY2o5gFAydwEbfXL/aBhCptGyZn1AQ=;
        b=ARWj+0eZ7H2Bum/sAUVuIuMrCAF9sUtPpPWomPH/9dglwfiq+ZKIb7qmmSesgJxtzj
         wkqRAczZBaXNbvLYpdPkLxzbH3wUgByWGOB2nxKu2xhkR8V62gv1onsOQ6MoI/7m2jxZ
         cLG6mfv4jIYld+h1wD0zb28Va5X7TRfBthYkGXQbnSlGvnPtiGLwQlDTJYG351zNF45r
         TbkSmpzsHebN6EN+/LunhZf3NNvMdgxPMPP4utu4sJQAJhuz68FOMSwmYeQ/NtzvyOH4
         tx25uK6p830uAlINPHwzDC2usc/MwdGDJa8TywMKM9UutVibN9i+rPHhot3Rtq50C1Pz
         Ccxw==
X-Gm-Message-State: APjAAAViAoToElzWG8es5c0Y0mTwNS2E9Ip9MJ7swzuxg2boPZyArHha
        JXZ4SrKO/pC6gdgIMaHVnkdxP4whmSwidC5W5UQ=
X-Google-Smtp-Source: APXvYqyD4sXOBPspLCS9RDJhkjw4yYOX82nJzQ7J8KVNRjGPNI+l27yfBwVTIwm0m+59blZ3YNOYC5DhWgvvZurIqKo=
X-Received: by 2002:aed:2726:: with SMTP id n35mr10829218qtd.171.1570122907296;
 Thu, 03 Oct 2019 10:15:07 -0700 (PDT)
MIME-Version: 1.0
References: <20191003084321.1431906-1-toke@redhat.com>
In-Reply-To: <20191003084321.1431906-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Oct 2019 10:14:56 -0700
Message-ID: <CAEf4BzZpksMGZhggHd=wHVStrN9Wb8RRw-PyDm7fGL3A7YSXdQ@mail.gmail.com>
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

On Thu, Oct 3, 2019 at 1:46 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Using cscope and/or TAGS files for navigating the source code is useful.
> Add simple targets to the Makefile to generate the index files for both
> tools.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Thanks a lot for adding this!

I tested cscope only and it works (especially without -k), so:

Tested-by: Andrii Nakryiko <andriin@fb.com>


>  tools/lib/bpf/.gitignore |  2 ++
>  tools/lib/bpf/Makefile   | 10 +++++++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/.gitignore b/tools/lib/bpf/.gitignore
> index d9e9dec04605..c1057c01223e 100644
> --- a/tools/lib/bpf/.gitignore
> +++ b/tools/lib/bpf/.gitignore
> @@ -3,3 +3,5 @@ libbpf.pc
>  FEATURE-DUMP.libbpf
>  test_libbpf
>  libbpf.so.*
> +TAGS
> +cscope.*
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index c6f94cffe06e..57df6b933196 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -262,7 +262,7 @@ clean:
>
>
>
> -PHONY +=3D force elfdep bpfdep
> +PHONY +=3D force elfdep bpfdep cscope TAGS
>  force:
>
>  elfdep:
> @@ -271,6 +271,14 @@ elfdep:
>  bpfdep:
>         @if [ "$(feature-bpf)" !=3D "1" ]; then echo "BPF API too old"; e=
xit 1 ; fi
>
> +cscope:
> +       (echo \-k; echo \-q; for f in *.c *.h; do echo $$f; done) > cscop=
e.files
> +       cscope -b -f cscope.out

1. I'd drop -k, given libbpf is user-land library, so it's convenient
to jump into system headers for some of BPF definitions.
2. Wouldn't this be simpler and work exactly the same?

ls *.c *.h > cscope.files
cscope -b -q -f cscope.out


> +
> +TAGS:

let's make it lower-case, please? Linux makefile supports both `make
tags` and `make TAGS`, but all-caps is terrible :)

> +       rm -f TAGS
> +       echo *.c *.h | xargs etags -a

nit: might as well do ls *.c *.h for consistency with cscope
suggestion above (though in both cases we just rely on shell expansion
logic, so doesn't matter).

> +
>  # Declare the contents of the .PHONY variable as phony.  We keep that
>  # information in a variable so we can use it in if_changed and friends.
>  .PHONY: $(PHONY)
> --
> 2.23.0
>
