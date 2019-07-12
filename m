Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E94A3662AB
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 02:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730475AbfGLAK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 20:10:29 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45122 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728582AbfGLAK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 20:10:29 -0400
Received: by mail-qt1-f196.google.com with SMTP id x22so1456503qtp.12;
        Thu, 11 Jul 2019 17:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WzVqjz+ovYVJRN1UL9XOiaqyrDBmch5lCBZzUwHfOaY=;
        b=uXGCVxnBJH+IrTUQWBZvqNDA8TsqpMaP2yszpAVamWVilZL18N18DcsOAbwo/fDSq8
         668wNSevaj6G+5reko3+9dXNspY6ji0n4wgsyXk/tWCgzWSGH8u59bStJr2imP0XlgIk
         Krcnp+3YHvYdG88eAdcEs0wxIwBCnC7rvUwVhKjYbvRXxqBYVYYbYeKWjrouvpO9DGb3
         zXQiyAV07LL/OJMLs80rctj8ApHvW5XsodGmBl6vZlA1W5XmjXeRxS+BplegUHl7bzey
         4vOTWQoIxYQvWJEbw4iEgA/6fdlt8rDdjTTB0FiqFH4E8hPfjEDubUGS0aV2FEWNArUH
         0XrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WzVqjz+ovYVJRN1UL9XOiaqyrDBmch5lCBZzUwHfOaY=;
        b=TpETizw8vMuX45v2nH1FpLjEAvq2Ou1kf7m2BsQEQLX1V+osM/Xmst9hgQpiMDjaJJ
         XrhJHiHf+EJ4U4V1CGpu9SD+7wFgQlXLCTRhayRZgSSfl1/2JORIK0xkB/PJJeV2i04+
         vIwsdyj2sxJi0zc26t3W7fwNqqeyoo9x0D3yIOfRnfc8iwHsaTaau3iAk2hvnDVOfZ8F
         xGleSZKsy3gRdGmGVIfQ477YemngclIfqAEprUAHh3WQ1+lcQ/u02772/zP8CQGNEcNF
         2nNQ7/NdArWRPpET09vt2evXeandcXcEtHNGoIz/Yc89DyUawCXTSt0y/RXgEqurreoB
         4K7w==
X-Gm-Message-State: APjAAAWDJYg8nOslMq02nJMF1R0wjPuDqjW7cB95ml1IdauO5AXI6VgE
        rwc6Vyxke18A3miylgFowH7kZW9K+zeDRWeXvaE=
X-Google-Smtp-Source: APXvYqzIg0sY6zjxpBd9of08XzWu259C1MQr+I7Q2VLBe3mYWznBjpvBpc3EEJAwziLsMwYtKdePvkRWzPSihHrP7y8=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr3876880qty.141.1562890227759;
 Thu, 11 Jul 2019 17:10:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-2-krzesimir@kinvolk.io>
 <CAEf4BzYDOyU52wdCinm9cxxvNijpTJgQbCg9UxcO1QKk6vWhNA@mail.gmail.com> <CAGGp+cEaGphDCuZL+sbo2aCVumk2jrq9_Lshifg-Ewphfm40Wg@mail.gmail.com>
In-Reply-To: <CAGGp+cEaGphDCuZL+sbo2aCVumk2jrq9_Lshifg-Ewphfm40Wg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Jul 2019 17:10:16 -0700
Message-ID: <CAEf4BzZBzreJOvEzm-OzVPNfwHOhuQ4nh4P04Nh5-u24sjFEcA@mail.gmail.com>
Subject: Re: [bpf-next v3 01/12] selftests/bpf: Print a message when tester
 could not run a program
To:     Krzesimir Nowak <krzesimir@kinvolk.io>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 4:36 AM Krzesimir Nowak <krzesimir@kinvolk.io> wrot=
e:
>
> On Thu, Jul 11, 2019 at 1:45 AM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> w=
rote:
> > >
> > > This prints a message when the error is about program type being not
> > > supported by the test runner or because of permissions problem. This
> > > is to see if the program we expected to run was actually executed.
> > >
> > > The messages are open-coded because strerror(ENOTSUPP) returns
> > > "Unknown error 524".
> > >
> > > Changes since v2:
> > > - Also print "FAIL" on an unexpected bpf_prog_test_run error, so ther=
e
> > >   is a corresponding "FAIL" message for each failed test.
> > >
> > > Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> > > ---
> > >  tools/testing/selftests/bpf/test_verifier.c | 17 +++++++++++++----
> > >  1 file changed, 13 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/test=
ing/selftests/bpf/test_verifier.c
> > > index c5514daf8865..b8d065623ead 100644
> > > --- a/tools/testing/selftests/bpf/test_verifier.c
> > > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > > @@ -831,11 +831,20 @@ static int do_prog_test_run(int fd_prog, bool u=
npriv, uint32_t expected_val,
> > >                                 tmp, &size_tmp, &retval, NULL);
> > >         if (unpriv)
> > >                 set_admin(false);
> > > -       if (err && errno !=3D 524/*ENOTSUPP*/ && errno !=3D EPERM) {
> > > -               printf("Unexpected bpf_prog_test_run error ");
> > > -               return err;
> > > +       if (err) {
> > > +               switch (errno) {
> > > +               case 524/*ENOTSUPP*/:
> > > +                       printf("Did not run the program (not supporte=
d) ");
> > > +                       return 0;
> > > +               case EPERM:
> > > +                       printf("Did not run the program (no permissio=
n) ");
> >
> > Let's add "SKIP: " prefix to these?
>
> Not sure about it. The important part of the test (the program being
> verified by the kernel's verifier) was still executed, so the test is
> not really skipped.


Ah, I see. So the program was loaded/verifierd, but wasn't test-run.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
>
> >
> > > +                       return 0;
> > > +               default:
> > > +                       printf("FAIL: Unexpected bpf_prog_test_run er=
ror (%s) ", strerror(saved_errno));
> > > +                       return err;
> > > +               }
> > >         }
> > > -       if (!err && retval !=3D expected_val &&
> > > +       if (retval !=3D expected_val &&
> > >             expected_val !=3D POINTER_VALUE) {
> > >                 printf("FAIL retval %d !=3D %d ", retval, expected_va=
l);
> > >                 return 1;
> > > --
> > > 2.20.1
> > >
>
>
>
> --
> Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
> Gesch=C3=A4ftsf=C3=BChrer/Directors: Alban Crequy, Chris K=C3=BChl, Iago =
L=C3=B3pez Galeiras
> Registergericht/Court of registration: Amtsgericht Charlottenburg
> Registernummer/Registration number: HRB 171414 B
> Ust-ID-Nummer/VAT ID number: DE302207000
