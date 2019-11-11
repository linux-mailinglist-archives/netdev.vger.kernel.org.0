Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55806F6E69
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 07:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfKKGJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 01:09:47 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37381 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbfKKGJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 01:09:47 -0500
Received: by mail-qt1-f193.google.com with SMTP id g50so14503144qtb.4;
        Sun, 10 Nov 2019 22:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S6NQzB3WBxIeLZV4LIcFE2waNjc0WRlZ5UskUxWA7TQ=;
        b=msqiXp95r8XzOdEtevAVWtBwB+2wLXbRzCsjOUq/jvOHa08d6UFIwC8hGmdZC+MGB9
         1BkR3XQRslIZa0c1PU5F6TXP1YNqc+Qooj7Ja7+z4UIRA8AyKzPQobwfJ3+IohhdHUiQ
         HCDJiBDh3Vi351u4xz8veAVOkVQCpndlOjOdYrWSqQgiO0j99xehc8Va/67Nfew3maxS
         vq/PA0fHhcTQq3ccsYioXCbnysudH2hGxltsaoxghBGA27/0aryEW8Cc/xcwZADBcWvz
         otRUDHqyulkryBL1GI/ANKVV8q4mdI/EJl2MZSIWA8VMh7+dsZmvhNLTjSAaUnSdAFhg
         jd0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S6NQzB3WBxIeLZV4LIcFE2waNjc0WRlZ5UskUxWA7TQ=;
        b=D/5iwQoee34HbxWK48pfVI+nyIU7SEcSbI8y79Nqm+lSJ5UTvJ6BN161xQHU51C7Oh
         MU7gBkPfr2wXNuinT0+I0J7Cqv371UIf2heVRQwUzaTCNzQBb9vGW9gHvrIwbB1e0lue
         YeiPf3z50/erniNAlR4fdAKeANW7noIJCGmDOm6cwCgJMsBh+xykY5hg7j+z9C0jip0N
         5ZZ4uO+3zybhL7r0wHoPNNA7H3EHOFEML45jjkS6p0rvgx9TYR38548IH1LRuNEK1k/O
         fRMKvTKovMBVmWFmkNeLxdd1Rz0vxBWvE85IFM+g/dDMOwrVdpq5HIBGy850VU/s4O2K
         313w==
X-Gm-Message-State: APjAAAVMs/DU/EfNVIX2dOdZ9Abrzo8PygC+GtPU29uHmF8rCaBrfMwt
        5RsiFzA1H+kM5x4Nj5D9BBnOlL1mGTJ8tib5P7I=
X-Google-Smtp-Source: APXvYqxt+1LMRVuJjIMYPfY0o826lJldjZnUHsWYpAZfR878wzkrwE4iivcqbx3WZlVnQLjhqdqGj3Nl8ODWkrGkbwI=
X-Received: by 2002:ac8:7116:: with SMTP id z22mr24468816qto.117.1573452585876;
 Sun, 10 Nov 2019 22:09:45 -0800 (PST)
MIME-Version: 1.0
References: <20191110081901.20851-1-danieltimlee@gmail.com>
In-Reply-To: <20191110081901.20851-1-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 10 Nov 2019 22:09:34 -0800
Message-ID: <CAEf4BzYRqeg5vFm+Ac2TVVeAw=N+qhosy5qF9Dr_ka3hn8DsPg@mail.gmail.com>
Subject: Re: [PATCH] samples: bpf: fix outdated README build command
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 12:19 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Currently, building the bpf samples under samples/bpf directory isn't
> working. Running make from the directory 'samples/bpf' will just shows
> following result without compiling any samples.
>

Do you mind trying to see if it's possible to detect that plain `make`
is being run from samples/bpf subdirectory, and if that's the case,
just running something like `make M=samples/bpf -C ../../`? If that's
not too hard, it would be a nice touch to still have it working old
(and intuitive) way, IMO.


>  $ make
>  make -C ../../ /git/linux/samples/bpf/ BPF_SAMPLES_PATH=/git/linux/samples/bpf
>  make[1]: Entering directory '/git/linux'
>    CALL    scripts/checksyscalls.sh
>    CALL    scripts/atomic/check-atomics.sh
>    DESCEND  objtool
>  make[1]: Leaving directory '/git/linux'
>
> Due to commit 394053f4a4b3 ("kbuild: make single targets work more
> correctly"), building samples/bpf without support of samples/Makefile
> is unavailable. Instead, building the samples with 'make M=samples/bpf'
> from the root source directory will solve this issue.[1]
>
> This commit fixes the outdated README build command with samples/bpf.
>
> [0]: https://patchwork.kernel.org/patch/11168393/
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  samples/bpf/README.rst | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
>

[...]
