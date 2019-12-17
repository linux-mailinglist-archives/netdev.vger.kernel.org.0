Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4305B1221D3
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 03:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfLQCHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 21:07:21 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43166 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbfLQCHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 21:07:21 -0500
Received: by mail-lf1-f67.google.com with SMTP id 9so5743251lfq.10;
        Mon, 16 Dec 2019 18:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JyYnLdraZ3i9mAbNELTDahCGz48WPnWVPKPIPNY5hKg=;
        b=r9cZVoN+YFl3+BZILKRst0PzNyYWJlbPwl0O7Otp8uj/9YdzBzN8/+cRgAF/b8JLZT
         8MvfF4nnBENkks3F5kNVc8XkNPu8FuK51fC1JdZiDlgTECEMtEEguCx7vNorozjOrjTj
         G3t2M968DuoWVYpuBYAgtuv6+MVeaLu2QXOILQAHW+Ooxg6Dv7Hx+qqqKaeJEal4Au5F
         /gQ25CKswtNrY2YgwwwVvkW8oLHcUhN0d5jDALjGP/zRAhqXEFdu9sLkM1o9C8eVYl96
         32IpWL1lxdfitsVz9w0iTtA6ker/fY4072kNhU/DbuOEQdQ3xMd767tJtp1xvqAowFV7
         TDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JyYnLdraZ3i9mAbNELTDahCGz48WPnWVPKPIPNY5hKg=;
        b=RyRSjTZoAM07+gOpY8ll6RqjVF1MFQP1c704OHf6A2zRwYh+cFsEy1oGZ59O63WLo5
         QHd9fqi2lm6/KNypDhVc8gfzgRdV6t2LI5nMG8L8yRwxYBQGIUJsfhUeSCG1rABiBaP6
         4F1NC3rIWMdUZGXccSdCt+1CFl/oFdAkpo2UvzVvycFxVHSQ71n02oBeXbLMyS50AW8s
         w0TnPVPyQA9ELy16v+hBDJ7b26k1hFNGyxDofABN70eVPOfdWAL8p74Y12jJra7lNv/E
         HrlAnjZI8SL5rDyZqf9W5DtsuN5Lx1UYE3iL2tcdk4COZoiJVtdhm/8WGl/fZILn4MMu
         CoCw==
X-Gm-Message-State: APjAAAXQ+zA6ehYb7Xu/cuxDVzozUheenTWctmO8BNcwLoO+PjLF5m60
        SKhZHTy1jMKTMzxDfpz1Zk4bzzwY24y5uaLdWtU=
X-Google-Smtp-Source: APXvYqx8XtOM7Ecfx9GE0h8Mejdo5Rsgcl7suDbjTfcESRRDsZy98q/R6+/sOhxqfpegbA4acAI1oU0rqet8E5iTPAM=
X-Received: by 2002:a19:6d13:: with SMTP id i19mr1319229lfc.6.1576548438829;
 Mon, 16 Dec 2019 18:07:18 -0800 (PST)
MIME-Version: 1.0
References: <20191216082738.28421-1-prashantbhole.linux@gmail.com>
 <20191216132512.GD14887@linux.fritz.box> <CAADnVQKB7hUmXBMmPfFUH4ZxSQfRtam0aEWykBNMhrKS+HjcwQ@mail.gmail.com>
 <caf893fb-e574-7a67-1e4e-4ce5d7836172@gmail.com>
In-Reply-To: <caf893fb-e574-7a67-1e4e-4ce5d7836172@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 16 Dec 2019 18:07:07 -0800
Message-ID: <CAADnVQJXK6TykmFx2axj9Z2yjNMRU9VbO98koneUiEQ-dLwu-Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix build by renaming variables
To:     Prashant Bhole <prashantbhole.linux@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 4:17 PM Prashant Bhole
<prashantbhole.linux@gmail.com> wrote:
>
>
>
> On 12/16/19 11:02 PM, Alexei Starovoitov wrote:
> > On Mon, Dec 16, 2019 at 5:25 AM Daniel Borkmann <daniel@iogearbox.net> =
wrote:
> >>
> >> On Mon, Dec 16, 2019 at 05:27:38PM +0900, Prashant Bhole wrote:
> >>> In btf__align_of() variable name 't' is shadowed by inner block
> >>> declaration of another variable with same name. Patch renames
> >>> variables in order to fix it.
> >>>
> >>>    CC       sharedobjs/btf.o
> >>> btf.c: In function =E2=80=98btf__align_of=E2=80=99:
> >>> btf.c:303:21: error: declaration of =E2=80=98t=E2=80=99 shadows a pre=
vious local [-Werror=3Dshadow]
> >>>    303 |   int i, align =3D 1, t;
> >>>        |                     ^
> >>> btf.c:283:25: note: shadowed declaration is here
> >>>    283 |  const struct btf_type *t =3D btf__type_by_id(btf, id);
> >>>        |
> >>>
> >>> Fixes: 3d208f4ca111 ("libbpf: Expose btf__align_of() API")
> >>> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> >>
> >> Applied, thanks!
> >
> > Prashant,
> > Thanks for the fixes.
> > Which compiler do use?
>
> gcc (GCC) 9.1.1 20190503 (Red Hat 9.1.1-1)

I've tried devtoolset-8 and devtoolset-9.
Which is
gcc version 9.1.1 20190605 (Red Hat 9.1.1-2) (GCC)

make clean;make doesn't produce that warning.
make V=3D1 tells me:
gcc -O2 -W -Wall -Wextra -Wno-unused-parameter
-Wno-missing-field-initializers -Wbad-function-cast
-Wdeclaration-after-statement -Wformat-security -Wformat-y2k
-Winit-self -Wmissing-declarations -Wmissing-prototypes
-Wnested-externs -Wno-system-headers -Wold-style-definition -Wpacked
-Wredundant-decls -Wstrict-prototypes -Wswitch-default -Wundef
-Wwrite-strings -Wformat -Wstrict-aliasing=3D3 -fno-strict-aliasing
-Wno-shadow
... -c -MMD -o gen.o gen.c

For some odd reason this check is failing for me
$ tools/scripts/Makefile.include
ifneq ($(filter 3.%,$(MAKE_VERSION)),)  # make-3
EXTRA_WARNINGS +=3D -fno-strict-aliasing
EXTRA_WARNINGS +=3D -Wno-shadow
else
EXTRA_WARNINGS +=3D -Wshadow
endif

$ make -v
GNU Make 3.82

Not sure how to fix this.
