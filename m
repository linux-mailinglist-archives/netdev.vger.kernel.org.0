Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A943A2CB242
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgLBBYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbgLBBYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 20:24:37 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F80C0613CF;
        Tue,  1 Dec 2020 17:23:57 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id e81so145324ybc.1;
        Tue, 01 Dec 2020 17:23:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m45HGgww8rwei1jF9IpqfIHeCT01SQ6NHFuOMNV2Kq8=;
        b=Jtl07/7tAkSef9ioYWQbUPfy8al3gkUP9oA+rjZbdc00reaxXGeuq7tnru1y8gqFVY
         EKG+vkphV43F1gKpnyk/zsJPHZwDbolr1uqBnTpzUBVxPuYChQxySYXt6oWIqnlIf63q
         OQuNFzF9EI+LxUf29IjtBkcF4eVzjQrm8YnE3zrav9c184WO1VoiRNlZoN++jX0/8lew
         Kwd1kXVswZPGwPPUD8dsHuH/BJZB2uNNvWuZWfetWcDof+fLhVz1I1YepvSj6UJkgPJv
         R8j5oLUW1uOQT9xVDcrHGVIuSigYQXbOJpaMyNBRmrCNV+QeEq0HD7UXOUBo35YYfy5t
         Rolw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m45HGgww8rwei1jF9IpqfIHeCT01SQ6NHFuOMNV2Kq8=;
        b=csMRuxUuSwEBhCNg8HJ5Z1O08zovate6Kbx3wIQakR5Q5OJkPGBr1hyJoWu8rdyzSd
         cyW2BRjGjb5W54bCCEPyqhmCMXUsyBz+OFomg/3zlQJsX4kKbx2W+9qw4DB4z0rRtOGk
         dT/QbTef6QQjDs5LdtTZxMHN2CHFJv3rPVRN+kK/CW1s5RyzvxEW4WsOsYK3jUJfRjw7
         TgG4FEGJg+Z7U5mzenkp0Ad8dwpOb1pTvfx4P1l+8YMZ6AbBNDmxk0OiFLKqQ1tFbWYU
         pZ/9s8c3H84ApwEk+1rSK5RjEfPr0hkdGq3mynbVEmr38Cm+wmRcqkJ6Ud6VU+TwyKu5
         vsbA==
X-Gm-Message-State: AOAM532QSIZbyR4cZHNnmpkutW1CnwFfKgx7jZ+GTbpsH9sELMLhAv8R
        u9adTs/bsf+kS/6/OSLsZsNMCuVIAnv4KdnBfm0=
X-Google-Smtp-Source: ABdhPJzy01NvPiH0pMJyF7xSndPk/h78XB3eqvJJ1aXsD0M2QpRIlGnlOVJoqm4V33VSP8WLMcb6M2bsQJYOmqamhpo=
X-Received: by 2002:a25:585:: with SMTP id 127mr182119ybf.425.1606872237019;
 Tue, 01 Dec 2020 17:23:57 -0800 (PST)
MIME-Version: 1.0
References: <20201128192502.88195-1-dev@der-flo.net> <20201128192502.88195-3-dev@der-flo.net>
In-Reply-To: <20201128192502.88195-3-dev@der-flo.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Dec 2020 17:23:46 -0800
Message-ID: <CAEf4BzZhKOi9kX-49+qx0Tq1Gf+KGZLWuOmMx=i4D=m1vLx-Zg@mail.gmail.com>
Subject: Re: [PATCH 2/2] selftests/bpf: Print reason when a tester could not
 run a program
To:     Florian Lehner <dev@der-flo.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 11:29 AM Florian Lehner <dev@der-flo.net> wrote:
>
> Print a message when the returned error is about a program type being
> not supported or because of permission problems.
> These messages are expected if the program to test was actually
> executed.
>
> Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
> Signed-off-by: Florian Lehner <dev@der-flo.net>
> ---
>  tools/testing/selftests/bpf/test_verifier.c | 24 ++++++++++++++++-----
>  1 file changed, 19 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index ceea9409639e..bd95894b7ea0 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -875,19 +875,33 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
>         __u8 tmp[TEST_DATA_LEN << 2];
>         __u32 size_tmp = sizeof(tmp);
>         uint32_t retval;
> -       int err;
> +       int err, saved_errno;
>
>         if (unpriv)
>                 set_admin(true);
>         err = bpf_prog_test_run(fd_prog, 1, data, size_data,
>                                 tmp, &size_tmp, &retval, NULL);
> +       saved_errno = errno;
> +
>         if (unpriv)
>                 set_admin(false);
> -       if (err && errno != 524/*ENOTSUPP*/ && errno != EPERM) {
> -               printf("Unexpected bpf_prog_test_run error ");
> -               return err;
> +
> +       if (err) {
> +               switch (errno) {

nit: stick to using saved_errno consistently, set_admin() does a lot
of things that can change errno

> +               case 524/*ENOTSUPP*/:
> +                       printf("Did not run the program (not supported) ");
> +                       return 0;
> +               case EPERM:
> +                       printf("Did not run the program (no permission) ");
> +                       return 0;

This should be ok to ignore *only* in unpriv mode, no?

> +               default:
> +                       printf("FAIL: Unexpected bpf_prog_test_run error (%s) ",
> +                               strerror(saved_errno));
> +                       return err;
> +               }
>         }
> -       if (!err && retval != expected_val &&
> +
> +       if (retval != expected_val &&
>             expected_val != POINTER_VALUE) {
>                 printf("FAIL retval %d != %d ", retval, expected_val);
>                 return 1;
> --
> 2.28.0
>
