Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6840424601
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 20:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239064AbhJFS0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 14:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbhJFS0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 14:26:32 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004EFC061764;
        Wed,  6 Oct 2021 11:24:38 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id h2so7430607ybi.13;
        Wed, 06 Oct 2021 11:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CxlSv8wdDAnWCYnuZubNu2S0WrnZQ2jaGbg2rCWosvA=;
        b=K0smwlhsHguJkR/wzEdzzO98uTEW/t4xip5spKyFLQeAlBnck6gIsiBZtaZWsz9xAD
         Q9zhjzVBGlkIRlLT9ZclZq5NMUZJ+7nf/8tVVK0qbJQ3SvnTm9pB3GQlUGVmYXPX8u8m
         HFTszUA4v8du7AFUneacSpKLkPa1AgYGwMZ+w0xjSTSIHxnUxn0SA9e/N2vDDOSkWK7K
         Goc79NKofab8+sLGz20e7fHWhG0CuBHpDg5ZBVvIiCMZhWs3U3nBZ7nsq/6uX5GYmI9f
         6aeK/tiktLHhBjRZJGryNnZrl4WSBww1iEhM3STBZKVWBp10KKf6V+lXLYhfa1JjGVMG
         p1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CxlSv8wdDAnWCYnuZubNu2S0WrnZQ2jaGbg2rCWosvA=;
        b=YxpzUhSs5MmoM/E8rudFp3G/BUIG4O2Zo2tQ2ouMWmwdWkxvWwHAktt1eKf11NfH76
         lprOa1N0D8UM6CiFmN41/XcfcQzQVLnxWASRAgnYG0Wqp3CzE8xmb9+ZCSz5i2WHYQQZ
         UoNLla0kLb6QG5npki29tfcxiSInvmMGIjncXgGnpZVVJPyJc3AwFjiE0wo/g5ZY0bvo
         k0kvSY2pcCXO/MIbIPLi5jBDYFo68WJMyYCxfM+csR2J8wrKVgaT0/o4QV3c7QLSaSMl
         A/RrBc4xsyqKianBXM5VUK5CiPGp2TIZYc85KWApsk1ahHAf7SbgpwusZpV3c0+Ii+Db
         WcLQ==
X-Gm-Message-State: AOAM532E2qD7DiGHI91LNYgHN2XC3ZQukuoXkDuW94cPsOhyk8TkyVvj
        eoZ0jUm4KRen4PHGfw3GEUl+IwkfNWq0jxJM3ew=
X-Google-Smtp-Source: ABdhPJzVYbbi+EbbWDO64iWF1YSgFUOj7n0pbFsMVkii1tkCwLAzyJWmvkxQz7L/w0lb99bSz8LHYLuCIbuX2wttAmk=
X-Received: by 2002:a25:d3c8:: with SMTP id e191mr29968101ybf.455.1633544678311;
 Wed, 06 Oct 2021 11:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <20211003192208.6297-1-quentin@isovalent.com> <20211003192208.6297-9-quentin@isovalent.com>
In-Reply-To: <20211003192208.6297-9-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 Oct 2021 11:24:27 -0700
Message-ID: <CAEf4Bzaq460PCWTZ7jz1dcTR-Rp2nNMUKbO3UFZ-43qSsf-JLg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 08/10] samples/bpf: update .gitignore
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 3, 2021 at 12:22 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Update samples/bpf/.gitignore to ignore files generated when building
> the samples. Add:
>
>   - vmlinux.h
>   - the generated skeleton files (*.skel.h)
>   - the samples/bpf/libbpf/ and .../bpftool/ directories, recently
>     introduced as an output directory for building libbpf and bpftool.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  samples/bpf/.gitignore | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
> index fcba217f0ae2..09a091b8a4f3 100644
> --- a/samples/bpf/.gitignore
> +++ b/samples/bpf/.gitignore
> @@ -57,3 +57,7 @@ testfile.img
>  hbm_out.log
>  iperf.*
>  *.out
> +*.skel.h
> +vmlinux.h
> +bpftool/
> +libbpf/

this will match files and directories in any subdir as well, maybe
let's add / in front to be explicit about doing this only on current
directly level (*.skel.h is fine)?

> --
> 2.30.2
>
