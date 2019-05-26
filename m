Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F852A76D
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 02:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfEZAAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 20:00:33 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43500 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727513AbfEZAAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 20:00:32 -0400
Received: by mail-qk1-f194.google.com with SMTP id z6so12932606qkl.10;
        Sat, 25 May 2019 17:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BkTSjWEz1LlgCo3qfXDf94l/jWd9jJRVXS7/BJDPttg=;
        b=djwIxSNAPoRf9j1KZgzmABuqGt7vk7kOQQ05UTIu6C53b+/3d9Qw0XgZVmPcvJyhwo
         2lbWiG8DwFwZ0koMP+u1m0b9CBqFIeYUM7x6pBx3AgE2+XdXBGhBCIJygE5AeZqScAa+
         U9TFS8L3suGM0OG5eAOMPt/SzbGjDoX6M/nziZ8N0pdRcZaLl9UiiwGkd3HhZLQ9q+2a
         MziMzhO7P0ksz+TkKZM2r/DJgeckH4rV9hAJYtTVnmTsqmwQQMi8CzCMxp5V20w9Ld9A
         QjgZW8ALJUDm7auJLID5HoZEOY28bbfc9Z6tBQEgB90G7+QNR9lC8qe70A5zWjuYXD4t
         bFnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BkTSjWEz1LlgCo3qfXDf94l/jWd9jJRVXS7/BJDPttg=;
        b=pFXBin6y9lYdFdVqvhdJn6vL0YJA9n0n8vqcv+enleDqV6g9LxYQeuBTsPKsv9s2fX
         AR2TKH3jm7XCVKrIol4ZpacoR9AQbFpi/vTShIqsO9+JMQM2VCOSTQGaF1ARcmozhccr
         d1AXmxbr5ITHP2cporHgjmHxJclm+2inxdNDY/g7w2VJaQhKdDRAhQjZldoGc1kLdTxn
         5um5tOC4rVCFszzUUXoB9o5r6vkLhgkvaRLZknYYl5lvbGsjtaJDxwRxkGxISIZuiPA0
         6SfDuWEx359cpe28SUYBkjgfdtsq6UUOgF2npJmSmlWg7t021afGmyds9BSxxbC0/x3w
         KN2A==
X-Gm-Message-State: APjAAAWidR56D+lb+nzNcdBkDyJz2yFIxmGlYMBNZWeSwsItWY3kvlVX
        Mmz2vW70z4riNfQkEt5wv+SjbDkTImaQaN+gb8o=
X-Google-Smtp-Source: APXvYqytntid87c7HLa0AyiOr6+hKKUFraXDQ2d85W7rNmS5L5WXaXWt0NT87qlz0LQSdfO6nSfMxTzU9VTVxHZjJqI=
X-Received: by 2002:ac8:2617:: with SMTP id u23mr89925767qtu.141.1558828831176;
 Sat, 25 May 2019 17:00:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190525053809.1207929-1-andriin@fb.com> <3543ed02-97f5-8d55-58d7-29f66220bacc@netronome.com>
In-Reply-To: <3543ed02-97f5-8d55-58d7-29f66220bacc@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 25 May 2019 17:00:19 -0700
Message-ID: <CAEf4BzZ_Kcjji=_OrR1Gpsojby=7orG=eXy7+4SonCvzgn7_hA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: auto-complete BTF IDs for btf dump
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 25, 2019 at 4:55 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> 2019-05-24 22:38 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> > Auto-complete BTF IDs for `btf dump id` sub-command. List of possible BTF
> > IDs is scavenged from loaded BPF programs that have associated BTFs, as
> > there is currently no API in libbpf to fetch list of all BTFs in the
> > system.
> >
> > Suggested-by: Quentin Monnet <quentin.monnet@netronome.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/bpf/bpftool/bash-completion/bpftool | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> > index 75c01eafd3a1..9fbc33e93689 100644
> > --- a/tools/bpf/bpftool/bash-completion/bpftool
> > +++ b/tools/bpf/bpftool/bash-completion/bpftool
> > @@ -71,6 +71,13 @@ _bpftool_get_prog_tags()
> >          command sed -n 's/.*"tag": "\(.*\)",$/\1/p' )" -- "$cur" ) )
> >  }
> >
> > +_bpftool_get_btf_ids()
> > +{
> > +    COMPREPLY+=( $( compgen -W "$( bpftool -jp prog 2>&1 | \
> > +        command sed -n 's/.*"btf_id": \(.*\),\?$/\1/p' | \
> > +        command sort -nu )" -- "$cur" ) )
> > +}
>
> Thanks! It works well. It looks like the "sort -nu" is not required,
> however? Bash completion on my system seems to run the equivalent of
> "sort -u" on the results anyway, ignoring the ordering you made just
> before. As I understand this is what completion always does, unless we
> pass "-o nosort" to "complete".
>
> E.g. I get the same following output:
>
>         1     1234  191   222   25
>
> When completing with this function:
>
>         _bpftool()
>         {
>                 COMPREPLY+=( $( compgen -W "$( \
>                         command echo '1 1 1 191 1234 25 222')"))
>         }
>         complete -F _bpftool bpftool
>
> or with that one:
>
>         _bpftool()
>         {
>                 COMPREPLY+=( $( compgen -W "$( \
>                         command echo '1 1 1 191 1234 25 222' | \
>                         command sort -nu )" ) )
>         }
>         complete -F _bpftool bpftool
>
> Could you double check you have the same thing on your setup, please? If
> so we can just remove the "sort -nu".

Yeah, seems like it behaves the same without sort -nu, I dropped it in
v2. Thanks!

>
> Quentin
