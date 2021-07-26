Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819DB3D67E5
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 22:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhGZT21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhGZT20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:28:26 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B51CC061757;
        Mon, 26 Jul 2021 13:08:55 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id q15so16865136ybu.2;
        Mon, 26 Jul 2021 13:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fe0Zj0kLfDwuvDh0NL9Bbb/3VqfG0rz29xHBAnxvKU0=;
        b=YnHwit+0ngIFE2vbGwqq63hxBrZw7fQthnQ3tHdhXhMt2d0zcF1I2y0k/fZWfKNr5n
         h+yJj86GA6r3pm8s3x+LUf6e3noFczJ8awGFhJV7+Yo9dfMULRQ4IOyXujYS63zJtv4l
         FakyG9MSvPS+uEQhT/ZnUnucAeMylUb4ILU9X+0IFOoOUNdQoAVFQjlsCxMAqE9WijIO
         7TVtVhTHifptjHk5TIy48sblveGzcLsPpcGD7n9UAwGPTgHz5M1iNVNByGprpEzdvXKl
         oqUvSZKGRmFKcODGOULE57c5G3rXQCgpcNG34MyfkrLIGESWywfiG676xRx93p0AOcsa
         4wJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fe0Zj0kLfDwuvDh0NL9Bbb/3VqfG0rz29xHBAnxvKU0=;
        b=VXiElmlKgLOw0UkhF4SbeSJImvOiVZzHwz/AV/3TTe/3NkrVicWeLr7KDK3TQghQxM
         RdMmpmRu1fJx20wiShHYSG9H0Nq4KFzcSmHk8+jduJYJv7iNGEeozvdub0r9GMCrcO2R
         MFGWEcNb/A455U3eZR/YEzaz1S5tHYW4Kw0Or+sczr/PG+xoJIqGqbfuB9BMrLfobv2c
         jT/j4FkaugOCLLCKZJ2qmFenVewVcoA5dk65Isfihhq2CKqPhG2Q5hCXAry/iLBFoUZ2
         AA0EnoUZRVpA0nmnR8va7DSxtUx6yX8lFIrOiHglzxpCPuVDBqpw972TWllumNnxsO1e
         ai9g==
X-Gm-Message-State: AOAM532kLlfa954LFjSs9QvGIv1Q5CVD21tu6xqLHCcGWFPs1378+Hgk
        sGfKdIWOhS96TOGGkXbeOZ2Hc95I+Mbc3fz/Yf8=
X-Google-Smtp-Source: ABdhPJzGNhzROPlgtVQSlmcA9Fiw5osrHRVlAvKWmU39Foakr2MzFm55SkKYFpiR9fw1LdEoeYbJ3Zrwuv2vFRonAQU=
X-Received: by 2002:a25:9942:: with SMTP id n2mr26763537ybo.230.1627330134299;
 Mon, 26 Jul 2021 13:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210724152124.9762-1-claudiajkang@gmail.com>
In-Reply-To: <20210724152124.9762-1-claudiajkang@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Jul 2021 13:08:43 -0700
Message-ID: <CAEf4Bzb-9TKKdL4x4UYw8T925pASYjt3+29+0xXq-reNG3qy8A@mail.gmail.com>
Subject: Re: [bpf-next 1/2] samples: bpf: Fix tracex7 error raised on the
 missing argument
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 24, 2021 at 8:21 AM Juhee Kang <claudiajkang@gmail.com> wrote:
>
> The current behavior of 'tracex7' doesn't consist with other bpf samples
> tracex{1..6}. Other samples do not require any argument to run with, but
> tracex7 should be run with btrfs device argument. (it should be executed
> with test_override_return.sh)
>
> Currently, tracex7 doesn't have any description about how to run this
> program and raises an unexpected error. And this result might be
> confusing since users might not have a hunch about how to run this
> program.
>
>     // Current behavior
>     # ./tracex7
>     sh: 1: Syntax error: word unexpected (expecting ")")
>     // Fixed behavior
>     # ./tracex7
>     ERROR: Run with the btrfs device argument!
>
> In order to fix this error, this commit adds logic to report a message
> and exit when running this program with a missing argument.
>
> Additionally in test_override_return.sh, there is a problem with
> multiple directory(tmpmnt) creation. So in this commit adds a line with
> removing the directory with every execution.
>
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> ---
>  samples/bpf/test_override_return.sh | 1 +
>  samples/bpf/tracex7_user.c          | 5 +++++
>  2 files changed, 6 insertions(+)
>
> diff --git a/samples/bpf/test_override_return.sh b/samples/bpf/test_override_return.sh
> index e68b9ee6814b..6480b55502c7 100755
> --- a/samples/bpf/test_override_return.sh
> +++ b/samples/bpf/test_override_return.sh
> @@ -1,5 +1,6 @@
>  #!/bin/bash
>
> +rm -rf tmpmnt

Do we need -rf or -r would do?

>  rm -f testfile.img
>  dd if=/dev/zero of=testfile.img bs=1M seek=1000 count=1
>  DEVICE=$(losetup --show -f testfile.img)
> diff --git a/samples/bpf/tracex7_user.c b/samples/bpf/tracex7_user.c
> index fdcd6580dd73..8be7ce18d3ba 100644
> --- a/samples/bpf/tracex7_user.c
> +++ b/samples/bpf/tracex7_user.c
> @@ -14,6 +14,11 @@ int main(int argc, char **argv)
>         int ret = 0;
>         FILE *f;
>
> +       if (!argv[1]) {
> +               fprintf(stderr, "ERROR: Run with the btrfs device argument!\n");
> +               return 0;
> +       }
> +
>         snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
>         obj = bpf_object__open_file(filename, NULL);
>         if (libbpf_get_error(obj)) {
> --
> 2.27.0
>
