Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32950263287
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgIIQpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731062AbgIIQpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:45:21 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4A2C061573;
        Wed,  9 Sep 2020 09:45:20 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id h206so2168086ybc.11;
        Wed, 09 Sep 2020 09:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AFhTg63zzzBwgd7SFdeI2btVFUo5PkQMb0jFKCFf5bI=;
        b=lUJzbbW4FRWUCxYAwKcAXsM8Cus2X4Pbo0YBylbNcCzBMs/wlCe5XKzfcCyvxEUT77
         WpINh0ne5xtFHAguUGCWdSUQrYyVb8cG5L6ce7HA3EJzII2Wb+B1bmiNajiXpC/KbCV1
         2R1MnghY540jPmiQo2I8e1KwUrYFP/cNiqxZMYA8MoDIUf5TKTXlHVEZ8Pwt3xc2RwRU
         +YM7WGmQjXQC/6S3uUw35d79zz4bZAtHcw3gxCqeh3Wt4vUqFoRCM7lgd6i48BoYAX4d
         YMFFm1inq6ejFOlyZ7jtvBnEULMgyuVfQE2GfJOB0LfnOGgJ7D68Dcm2P/u+MHvIMgia
         hfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AFhTg63zzzBwgd7SFdeI2btVFUo5PkQMb0jFKCFf5bI=;
        b=VIwRxgEDAZsmofC7uar0XgT4/oLW2gtsOTc9toNc43YMgIThJSJAE6nL2cliQgZ9kv
         3cj9YJ6Tjsh/EelQIMaJQ+MKR+GgfSo+X0MtDRJpJw5ThTcP1p9BPm4VMI7yHcSIpDBn
         jR08bl561EQlQk9X8Emhi/vflrAcM6OpwNSxkohi2ux5TL4y8tWG4iYfSZPZH2qgG9J0
         ZcXhQCtbxW+8AdJLkcmf056qJBGqAaIpKJnhDVB9YaSzj6TKuwC6/nSHGTVBsCU/2MKX
         M2cksfr20xrsZV5/cOP51LFUbdBE1mxppJJrwPmW4ccZbiXhszuVPX/w/3J9X7+HGxVn
         M0EQ==
X-Gm-Message-State: AOAM533Dc1mfrk2/Djsj4OmCNznmScU+m5i6WpLtDn+M0efiHUpmNhei
        igAgDdTEhMHH6bebEgcYpNS3RJu2aVsewIUFpOI=
X-Google-Smtp-Source: ABdhPJw2ib6SGKMqLa6LL4Afci7xdiW2SHxa3MesLNRJKLHRKJLKsmJWommKqI8FS54OFEYXR4JuxawpBpyGc2a/pt0=
X-Received: by 2002:a25:ef43:: with SMTP id w3mr6275421ybm.230.1599669919880;
 Wed, 09 Sep 2020 09:45:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200909162251.15498-1-quentin@isovalent.com> <20200909162251.15498-3-quentin@isovalent.com>
In-Reply-To: <20200909162251.15498-3-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Sep 2020 09:45:09 -0700
Message-ID: <CAEf4BzYaXsGFtX2K9pQF7U-e5ZcHFxMYanvjKanLORk6iF1+Xw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/2] selftests, bpftool: add bpftool (and eBPF
 helpers) documentation build
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 9:22 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> eBPF selftests include a script to check that bpftool builds correctly
> with different command lines. Let's add one build for bpftool's
> documentation so as to detect errors or warning reported by rst2man when
> compiling the man pages. Also add a build to the selftests Makefile to
> make sure we build bpftool documentation along with bpftool when
> building the selftests.
>
> This also builds and checks warnings for the man page for eBPF helpers,
> which is built along bpftool's documentation.
>
> This change adds rst2man as a dependency for selftests (it comes with
> Python's "docutils").
>
> v2:
> - Use "--exit-status=1" option for rst2man instead of counting lines
>   from stderr.

It's a sane default to have non-zero exit code on error/warning, so
why not specifying it all the time?

> - Also build bpftool as part as the selftests build (and not only when
>   the tests are actually run).
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/Makefile          |  5 +++++
>  .../selftests/bpf/test_bpftool_build.sh       | 21 +++++++++++++++++++
>  2 files changed, 26 insertions(+)
>

[...]
