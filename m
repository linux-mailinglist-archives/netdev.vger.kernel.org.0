Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C0220CDA
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 18:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfEPQVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 12:21:46 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41714 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfEPQVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 12:21:46 -0400
Received: by mail-lj1-f196.google.com with SMTP id k8so3638408lja.8
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 09:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2e5Do/kWandKX1Zbza7sapR2anoZAP3eXmyFdlVoIKA=;
        b=ArCqLQ+mQc4Jf+7VG1OdMWx31L6sOXF2Y4z/qL7fxHo0l/XOMLxlZhFvmSO9hV7WSy
         6RJy27G0BLy0i2xPqrJIdetwNB9Q4Spb89sBui0GkTfheyp1uV6bp0C+WzQPpw197YmW
         Dt+Sg/qBSz6e625LoIace3EjYmevysKHUexhc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2e5Do/kWandKX1Zbza7sapR2anoZAP3eXmyFdlVoIKA=;
        b=fuDjxhqeKPnvCHJBb+7+gZAQEWBdyRC0767d7n/1ijU6kLDwCiF6m7cGM+ZHAxEktO
         7NRU/h1spKBI7NuPoLHtrOARrNL8KWCMPxTfwj21xLV1kbVbh8S4u0uH51+5+eQk0vOM
         1VxYPmR1a8O75+9rSdlRQeVGVSSnbcDHJj6IKyGlcIZ3tFaal6nOfbBGb1TXTN+xZJya
         biza4L0ZwdE1mxHj8mKHsE2j+m46w1a8dkIyHqj5kalO9cACWiD8+ehyQ1Dbyuuqp1mw
         OTufb5ms8s4KaaQ3osAz3LlV5n+rSIoG0hW/Uuur+f4DuSMp2j8L467BWDJsK43Dl8Mj
         Q/ww==
X-Gm-Message-State: APjAAAVYdJGKLGCEbLpVbAZQzJHpfL9OcZ24WbKFIyAPfke/t7tdHQVF
        tvTEQW6m27/74kA/EEC9fEkgPoeiDYk+EkEk+QY88A==
X-Google-Smtp-Source: APXvYqyqHiyH4AeBft1evepIQq8xBjLJiWFn//O/FH36CylnD2Em3MeZL1D22OC+4X2lB0bbci0VypEz679vdXG/w5Q=
X-Received: by 2002:a2e:88ce:: with SMTP id a14mr18017256ljk.122.1558023704266;
 Thu, 16 May 2019 09:21:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190515134731.12611-1-krzesimir@kinvolk.io> <20190515134731.12611-3-krzesimir@kinvolk.io>
 <20190515144537.57f559e7@cakuba.netronome.com> <CAGGp+cGN+YYVjJee5ba84HstSrHGurBvwmKmzNsFRvb344Df3A@mail.gmail.com>
 <20190516085035.3cdb0ae6@cakuba.netronome.com>
In-Reply-To: <20190516085035.3cdb0ae6@cakuba.netronome.com>
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
Date:   Thu, 16 May 2019 18:21:32 +0200
Message-ID: <CAGGp+cEFxzbH-8vnSAK3sZkM-u3WN4HGnkYvhFwBp85yVtD7Xg@mail.gmail.com>
Subject: Re: [PATCH bpf v1 2/3] selftests/bpf: Print a message when tester
 could not run a program
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     bpf@vger.kernel.org,
        =?UTF-8?Q?Iago_L=C3=B3pez_Galeiras?= <iago@kinvolk.io>,
        "Alban Crequy (Kinvolk)" <alban@kinvolk.io>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrey Ignatov <rdna@fb.com>, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 5:51 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu, 16 May 2019 11:29:39 +0200, Krzesimir Nowak wrote:
> > > > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/te=
sting/selftests/bpf/test_verifier.c
> > > > index ccd896b98cac..bf0da03f593b 100644
> > > > --- a/tools/testing/selftests/bpf/test_verifier.c
> > > > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > > > @@ -825,11 +825,20 @@ static int do_prog_test_run(int fd_prog, bool=
 unpriv, uint32_t expected_val,
> > > >                               tmp, &size_tmp, &retval, NULL);
> > > >       if (unpriv)
> > > >               set_admin(false);
> > > > -     if (err && errno !=3D 524/*ENOTSUPP*/ && errno !=3D EPERM) {
> > > > -             printf("Unexpected bpf_prog_test_run error ");
> > > > -             return err;
> > > > +     if (err) {
> > > > +             switch (errno) {
> > > > +             case 524/*ENOTSUPP*/:
> > > > +                     printf("Did not run the program (not supporte=
d) ");
> > > > +                     return 0;
> > > > +             case EPERM:
> > > > +                     printf("Did not run the program (no permissio=
n) ");
> > > > +                     return 0;
> > >
> > > Perhaps use strerror(errno)?
> >
> > As I said in the commit message, I open-coded those messages because
> > strerror for ENOTSUPP returns "Unknown error 524".
>
> Ah, sorry, missed that.  I wonder if that's something worth addressing
> in libc, since the BPF subsystem uses ENOTSUPP a lot.

The "not supported" errno situation seems to be a mess. There is an
ENOTSUP define in libc. ENOTSUP is usually defined to be EOPNOTSUPP
(taken from kernel), which in turn seems to have a different value
(95) than kernel's ENOTSUPP (524). Adding ENOTSUPP (with two Ps) to
libc would only add to the confusion. So it's kind of meh and I guess
people just moved on with workarounds.

--=20
Kinvolk GmbH | Adalbertstr.6a, 10999 Berlin | tel: +491755589364
Gesch=C3=A4ftsf=C3=BChrer/Directors: Alban Crequy, Chris K=C3=BChl, Iago L=
=C3=B3pez Galeiras
Registergericht/Court of registration: Amtsgericht Charlottenburg
Registernummer/Registration number: HRB 171414 B
Ust-ID-Nummer/VAT ID number: DE302207000
