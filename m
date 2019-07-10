Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 165AB64F57
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 01:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727869AbfGJXpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 19:45:08 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46117 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfGJXpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 19:45:08 -0400
Received: by mail-qt1-f195.google.com with SMTP id h21so4398244qtn.13;
        Wed, 10 Jul 2019 16:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+sqiUwWG1mesQFrY9cj+FFlURTAmOGb307o36jkpKUA=;
        b=VUZ7ZPsRDv0lE9oH6yFofV6HgtN0E35Umsfhfrver5Gf3jWCGylbX2z9k5XMZwTB3l
         w0uKdVOGr/rGGo/GlDvEKsm6HMP3LU+4HBGjz0BW1CmR5bMyTtne12DlD2lLpN199S5v
         ji/Bhv1iqG2QzNs92n6pFKaDZJh3/skcvjJqxJysFMTL2CjYA8XT09FJDiHEnHi1b+pv
         CS//+7M5xf7qb6li+WNEtnDbwpJgrhv07w1QBoPQsDSOa/lgVOaREkvCaIsuZCgwC7Ku
         J+FIpfKu1Fi1rVZhW5fOXu1zIdtYyj5Fr8NsIdj0lebp4GK2KniY4LGhZoWN1DTtdrAX
         EQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+sqiUwWG1mesQFrY9cj+FFlURTAmOGb307o36jkpKUA=;
        b=Xqpr32kKUCPaOozdUUl/gQg19UBpUwJqMEHmKwiLlhP4G8YPt0/hOIPCmjc9nva+5D
         JZSIRfxJiAJ+Yal7+dT/T0+v9t+KZO4h6uiJMLAk269lmFJgB/akJgG7IuT8GvCEObP+
         7fhBTUkHSDVKxLdwTclSZ/li9qSNdgW3kG34e2U+y89uUd3/5pW/GT3g3zM1qpYxZMrS
         yXkcXe1MsK4NSUqCktHy9W2KzjhqyDM0awY6lSf9XPIjC80q+Nk1D1YaJwGOMAGM6uZW
         O42G3QvFAlRvd7j8Gt5Q4C+OirTUGbdyoOa4cMGPpdLNx/GhbO8qWrFuQdwe0P7qbhRk
         PjBg==
X-Gm-Message-State: APjAAAWvV7y7EbkY2ctsfsPOQOGBZesdhs49sMkF2KQQPLKGUH5Hng3z
        LMdNlurMnmPYbiJYrQErH6z5ES0HlfWivIwWVJ0=
X-Google-Smtp-Source: APXvYqy8GWjftJ3Av6vXwuKiibSMw+/nri5HwCcX0ApT0PI4jJeELHj+Rbkf5rNNwm4kqnppptUnNg32L2xGZz/8cLI=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr539105qta.171.1562802306754;
 Wed, 10 Jul 2019 16:45:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190708163121.18477-1-krzesimir@kinvolk.io> <20190708163121.18477-2-krzesimir@kinvolk.io>
In-Reply-To: <20190708163121.18477-2-krzesimir@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 10 Jul 2019 16:44:55 -0700
Message-ID: <CAEf4BzYDOyU52wdCinm9cxxvNijpTJgQbCg9UxcO1QKk6vWhNA@mail.gmail.com>
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
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 3:42 PM Krzesimir Nowak <krzesimir@kinvolk.io> wrote:
>
> This prints a message when the error is about program type being not
> supported by the test runner or because of permissions problem. This
> is to see if the program we expected to run was actually executed.
>
> The messages are open-coded because strerror(ENOTSUPP) returns
> "Unknown error 524".
>
> Changes since v2:
> - Also print "FAIL" on an unexpected bpf_prog_test_run error, so there
>   is a corresponding "FAIL" message for each failed test.
>
> Signed-off-by: Krzesimir Nowak <krzesimir@kinvolk.io>
> ---
>  tools/testing/selftests/bpf/test_verifier.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index c5514daf8865..b8d065623ead 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -831,11 +831,20 @@ static int do_prog_test_run(int fd_prog, bool unpriv, uint32_t expected_val,
>                                 tmp, &size_tmp, &retval, NULL);
>         if (unpriv)
>                 set_admin(false);
> -       if (err && errno != 524/*ENOTSUPP*/ && errno != EPERM) {
> -               printf("Unexpected bpf_prog_test_run error ");
> -               return err;
> +       if (err) {
> +               switch (errno) {
> +               case 524/*ENOTSUPP*/:
> +                       printf("Did not run the program (not supported) ");
> +                       return 0;
> +               case EPERM:
> +                       printf("Did not run the program (no permission) ");

Let's add "SKIP: " prefix to these?

> +                       return 0;
> +               default:
> +                       printf("FAIL: Unexpected bpf_prog_test_run error (%s) ", strerror(saved_errno));
> +                       return err;
> +               }
>         }
> -       if (!err && retval != expected_val &&
> +       if (retval != expected_val &&
>             expected_val != POINTER_VALUE) {
>                 printf("FAIL retval %d != %d ", retval, expected_val);
>                 return 1;
> --
> 2.20.1
>
