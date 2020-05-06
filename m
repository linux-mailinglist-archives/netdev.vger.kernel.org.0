Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BA01C7C84
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730058AbgEFVdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728621AbgEFVdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:33:49 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510A0C061A0F;
        Wed,  6 May 2020 14:33:49 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id q13so2923016qtp.7;
        Wed, 06 May 2020 14:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oxq/+H+xeQ+mv0tMvO5y3IYe9t01YqrY24EF/jtyldM=;
        b=JzpDNdPYTPxFaUJBI4wO/veVbXFJgJkPrBP/OfGrsNnX8LGz5nuLs4oG3lltFk3/Fx
         TEa+XtZ6C0J+Hesq1mQ2zPg28GjbJLBMCRvNxplqEgB6fxuIlW71tmMwP3ug/tsjYI35
         BbqKWHvsh59x1F5iv5dzK8HfxhUPWKpJu1KKqZR5+/SYKaZbCopPzJ8XQUjQ2PG4Z5jp
         V/qHPrTnifNUjqOi+es8cWAkIx4x6zk03HngHsEV/Q+x3gVZdIXnoxFLWlpYhCIMOCaV
         4RVshHt6yYWgeEwypEmCLp8j62Fr/jWtYYe+AQi6nK1nYSSu/KGmCN7bVEzpY2sAsn+u
         PBFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oxq/+H+xeQ+mv0tMvO5y3IYe9t01YqrY24EF/jtyldM=;
        b=bTH5j1wh4Bkn0QNlueRx+l9NFL0UcDEkTaMr9cT5WzlsipG6JNG9yBsAvv8ML6cO/u
         jafQF3DisB9OP3UvB3b3F9D0g43XTtCGboVpRi1pxM7mzyQ4bYSEzfQ0qIp+THlQRfOK
         0KWeWFZqMJcmf1bO4TfREAZwJM3uD06hbUWfyc8iQux8+hYESY08vo18kfc+zK2JDArC
         XQ+Z1K4DBpJA8zJTo7+eImI8EzATFvDhhXf1BrN9PRf0nGeh1NDwDyvLnhqHPV4llst6
         4/bRHjT3VJHUdEY98McDLDI2E3sPMhJF6fn+h2ujfxi7RZRdHPaLV1Va+7Zvc0tLgy+x
         NsNg==
X-Gm-Message-State: AGi0PubLH42G3jDfXvrlANdCaJziN2V1BOzVs6UiciQG0cOO6S9kUBnI
        JzQd8yNTrhgJbIbcBlyoX5B7GhBKyEFghvR6g0I=
X-Google-Smtp-Source: APiQypJpsaSQT2qGJ86FLuFicIlyv3y+HBRJHzXrPJic7JUYJNR9KUObIce/p0SIw7yu2XjUcR0G7ZmOo+OyrDJyboo=
X-Received: by 2002:aed:2e24:: with SMTP id j33mr10425153qtd.117.1588800828042;
 Wed, 06 May 2020 14:33:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200506205257.8964-1-irogers@google.com> <20200506205257.8964-2-irogers@google.com>
In-Reply-To: <20200506205257.8964-2-irogers@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 May 2020 14:33:37 -0700
Message-ID: <CAEf4BzZRmiEds_8R8g4vaAeWvJzPb4xYLnpF0X2VNY8oTzkphQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] lib/bpf hashmap: increase portability
To:     Ian Rogers <irogers@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 1:54 PM Ian Rogers <irogers@google.com> wrote:
>
> Don't include libbpf_internal.h as it is unused and has conflicting
> definitions, for example, with tools/perf/util/debug.h.
> Fix a non-glibc include path.
>
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/lib/bpf/hashmap.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/hashmap.h b/tools/lib/bpf/hashmap.h
> index bae8879cdf58..d5ef212a55ba 100644
> --- a/tools/lib/bpf/hashmap.h
> +++ b/tools/lib/bpf/hashmap.h
> @@ -13,9 +13,8 @@
>  #ifdef __GLIBC__
>  #include <bits/wordsize.h>
>  #else
> -#include <bits/reg.h>
> +#include <linux/bitops.h>

why this change? It might be ok for libbpf built from kernel source,
but it will break Github libbpf.

>  #endif
> -#include "libbpf_internal.h"

Dropping this seems ok, don't remember why I had it here in the first place.

>
>  static inline size_t hash_bits(size_t h, int bits)
>  {
> --
> 2.26.2.526.g744177e7f7-goog
>
