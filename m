Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0E84A6BFD
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 07:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236833AbiBBG70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 01:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbiBBG7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 01:59:25 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D62C061714;
        Tue,  1 Feb 2022 22:59:25 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id h7so24264792iof.3;
        Tue, 01 Feb 2022 22:59:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2IxjCPSQamGn0ge0aPL35vxu066qywElzYY00Z/1OAk=;
        b=ZrvVtULuaeeLO4AOigmHAWR8nqGHwfgHlzYHaa3Wu2xBMXmFIXp+oaSD2oeMCnU6KL
         R0rNdOTvPZYQ8udc9clKDrSkuHg6XrnbfcbMB+jffQM6wPrOQ7M5VpcQNFTR+d4YvjSy
         kMlcjK7SWaoMjlVv/0c9U7YhRYZNx+aKgK/8RmAgjH4NMI3bXxcP2jyR/1ekFnDmJhky
         F+ZRBnUy14/PL6LdEnSJJg6ZchzbWJlJb3UyyY8FOJm0WlFmc8jxYYkVQB7rmmJDWkcr
         DuD6H8PXC754fUenmha8suX2/uXIlpXlBEjlTEoQ0AtYMJJdzo48e2RILoHyiShq5x/Z
         ok+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2IxjCPSQamGn0ge0aPL35vxu066qywElzYY00Z/1OAk=;
        b=O1kKoZNGzOgp8qSBAPB0Zu3jwC0JzPJnf6Wc+tqt6z6zpJPA7qA7nFshlW4QXjLN9S
         p8k8fskva93+BdObRzO0IjS3dl0BrdvntcQkeJrLsxpH5HD/WSTiweXXy0kD1Lq9RKN8
         Hbc1eMMNOMhFZwk++2pducWYGmfq+kHiqIMnOZHyJadxc05Kgo1OwBJdAvsUa0KXLRvX
         ZhBTGpcq9Wq52K7UuQfKFFfV9M1Oon5cTP39Vw3JCqF6bYz2wvzw9GX3YEcmvheRt0l/
         XbZE55Eh6JlCRNQoe/QMN9POJkGDMsxkppVRJSNGJKBaaWv9jc6shL7XG6QLXc0SRsPm
         htCg==
X-Gm-Message-State: AOAM532j6y4dLJpecRN1xDdjlcgmRIzLJC3dxvMQauJ12vhzPyLtIeYL
        aQUB0Bu9dWpp6z0uKIPI4f+XKSfQnrrrWUrtqZztrPoC
X-Google-Smtp-Source: ABdhPJwd6S9clhB+0Mbd33bHueQo3HbGsCCthRhXPgrjhBWcWc6fIFwMXbwk9RHBefw2gTyekBK5hQny85KWB4/4ufU=
X-Received: by 2002:a02:2422:: with SMTP id f34mr14953219jaa.237.1643785165272;
 Tue, 01 Feb 2022 22:59:25 -0800 (PST)
MIME-Version: 1.0
References: <20220131211136.71010-1-quentin@isovalent.com> <20220131211136.71010-4-quentin@isovalent.com>
In-Reply-To: <20220131211136.71010-4-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Feb 2022 22:59:14 -0800
Message-ID: <CAEf4BzbB3PDGTXuCou7cSbWHpKiTzZWA52UFTxzM1=Z1o4+Qjw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] bpftool: Update versioning scheme
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 31, 2022 at 1:11 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Since the notion of versions was introduced for bpftool, it has been
> following the version number of the kernel (using the version number
> corresponding to the tree in which bpftool's sources are located). The
> rationale was that bpftool's features are loosely tied to BPF features
> in the kernel, and that we could defer versioning to the kernel
> repository itself.
>
> But this versioning scheme is confusing today, because a bpftool binary
> should be able to work with both older and newer kernels, even if some
> of its recent features won't be available on older systems. Furthermore,
> if bpftool is ported to other systems in the future, keeping a
> Linux-based version number is not a good option.
>
> It would make more sense to align bpftool's number on libbpf, maybe.
> When versioning was introduced in bpftool, libbpf was in its initial
> phase at v0.0.1. Now it moves faster, with regular version bumps. But
> there are two issues if we want to pick the same numbers. First, that
> would mean going backward on the numbering, and will be a huge pain for
> every script trying to determine which bpftool binary is the most
> recent (not to mention some possible overlap of the numbers in a distant
> future). Then, bpftool could get new features or bug fixes between two
> versions libbpf, so maybe we should not completely tie its versions to
> libbpf, either.
>
> Therefore, this commit introduces an independent versioning scheme for
> bpftool. The new version is v6.0.0, with its major number incremented
> over the current 5.16.* returned from the kernel's Makefile. The plan is
> to update this new number from time to time when bpftool gets new
> features or new bug fixes. These updates could possibly lead to new
> releases being tagged on the recently created out-of-tree mirror, at
> https://github.com/libbpf/bpftool.
>
> Version number is moved higher in the Makefile, to make it more visible.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/Makefile | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index bd5a8cafac49..b7dbdea112d3 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -1,6 +1,8 @@
>  # SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>  include ../../scripts/Makefile.include
>
> +BPFTOOL_VERSION := 6.0.0
> +

It's going to be a PITA to not forget to update this :( As discussed,
I'm fine with this, but I also recalled the versioning approach that
libbpf-sys library is using (see [0]). Maybe we could steal some of
those ideas. As in, base bpftool version on libbpf (with major version
+ 6 as you do here), but also have "-1", "-2", etc suffixes for
bpftool releases for when libbpf version didn't change. Don't know,
just throwing out the idea for your consideration.

  [0] https://github.com/libbpf/libbpf-sys#versioning


>  ifeq ($(srctree),)
>  srctree := $(patsubst %/,%,$(dir $(CURDIR)))
>  srctree := $(patsubst %/,%,$(dir $(srctree)))
> @@ -39,9 +41,6 @@ LIBBPF_BOOTSTRAP := $(LIBBPF_BOOTSTRAP_OUTPUT)libbpf.a
>  LIBBPF_INTERNAL_HDRS := $(addprefix $(LIBBPF_HDRS_DIR)/,hashmap.h nlattr.h)
>  LIBBPF_BOOTSTRAP_INTERNAL_HDRS := $(addprefix $(LIBBPF_BOOTSTRAP_HDRS_DIR)/,hashmap.h)
>
> -ifeq ($(BPFTOOL_VERSION),)
> -BPFTOOL_VERSION := $(shell make -rR --no-print-directory -sC ../../.. kernelversion)
> -endif
>  LIBBPF_VERSION := $(shell make -r --no-print-directory -sC $(BPF_DIR) libbpfversion)
>
>  $(LIBBPF_OUTPUT) $(BOOTSTRAP_OUTPUT) $(LIBBPF_BOOTSTRAP_OUTPUT) $(LIBBPF_HDRS_DIR) $(LIBBPF_BOOTSTRAP_HDRS_DIR):
> --
> 2.32.0
>
