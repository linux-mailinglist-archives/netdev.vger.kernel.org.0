Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE1041A6D6
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 06:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhI1Ezt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 00:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhI1Ezs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 00:55:48 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48713C061575;
        Mon, 27 Sep 2021 21:54:09 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id s18so14476645ybc.0;
        Mon, 27 Sep 2021 21:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ftE+0CImZ4wvtObNvNqITwScfuIlULxxvwkkXNFZH8g=;
        b=WNzkiWDadIPpdasbIFWXV7DZ6/rbPymEP2Ak28I8fYKTd1ZWXSqQoxzO5w06TN1SMG
         jiFUFYrD2joqcaJK3NLsmtxzIFlOXf9/0q0zsaUWLwwDYf1XeZd0hIoc0nQwqjcisRlW
         kxSMuCqn4IlE/TpS0EEptM2aNXjnxJnoqKbNJOMoxfn4PHSSHNSC7crzGwd8ItuSfUPj
         0DP9IzkesmT1VeFNBEYrp3Wt0CjH1eGDNZ+d/E8IXRW3Nf+gRXVjBhW1RQEzSu5k8V3p
         9NWNbVzfIo1nqFx/mFSIYaTJNZz1/F7wo+5F7MnUFGlCtIAQAjgn7cvVWuhoxRsShyS1
         dfLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ftE+0CImZ4wvtObNvNqITwScfuIlULxxvwkkXNFZH8g=;
        b=M0EaLskdwHvOKpBou+pTLw6ucJy2bEJ+i/lN5fF6Pvg4Ahz4+BGE+Ie2o6/poufgp2
         CdYV+XVN/UPTQhvLNzYBPo7dQBxY6cvLs/fgQWYd7ve11luPe9hlpxwPxOcPneq7BYwK
         gIhHbIg5K7lZEKOrGq6FmQXmkSRwpSwP6TW63UqDIY41LMiwBj2miLTSa0prE2EpgpUu
         8tbh6dEIeNQGlB/LmGb6cWk5H/BYl+B/CKphm3c5bNtmtth+aleGCw1owGh9SbX3aRB7
         3I3zju+2yIjbbofVx+aeIAELEiVgFWrbAFdKTFu1h8srHzILQxRmZZnVkR6Go/FYgULx
         ytzw==
X-Gm-Message-State: AOAM530g0e79FFxdZc0ThKmIeImp3B/U/zI9E9CjBlhWgJZzXkS94eUz
        mV40XsP6abAP6E++ijb0mgUodcHuwBr2RN/x0MI=
X-Google-Smtp-Source: ABdhPJzZ43eQZJXXmKG0MAWW3hdSbUtsC5rpQQl8jDtAE1H+OjyyZHNFQJzGffBGYVZI1JVg9OqskCZppMf+71ogcr8=
X-Received: by 2002:a25:2d4e:: with SMTP id s14mr4126581ybe.2.1632804848553;
 Mon, 27 Sep 2021 21:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <ee84ab66436fba05a197f952af23c98d90eb6243.1632758415.git.jbenc@redhat.com>
In-Reply-To: <ee84ab66436fba05a197f952af23c98d90eb6243.1632758415.git.jbenc@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 27 Sep 2021 21:53:57 -0700
Message-ID: <CAEf4Bza82pfB-DniE+Snb7nZLHXmPBmkgE7yj9qwkdYyOq_qXQ@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: fix makefile dependencies on libbpf
To:     Jiri Benc <jbenc@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 27, 2021 at 9:02 AM Jiri Benc <jbenc@redhat.com> wrote:
>
> When building bpf selftest with make -j, I'm randomly getting build failures
> such as this one:
>
> > In file included from progs/bpf_flow.c:19:
> > [...]/tools/testing/selftests/bpf/tools/include/bpf/bpf_helpers.h:11:10: fatal error: 'bpf_helper_defs.h' file not found
> > #include "bpf_helper_defs.h"
> >          ^~~~~~~~~~~~~~~~~~~
>
> The file that fails the build varies between runs but it's always in the
> progs/ subdir.
>
> The reason is a missing make dependency on libbpf for the .o files in
> progs/. There was a dependency before commit 3ac2e20fba07e but that commit
> removed it to prevent unneeded rebuilds. However, that only works if libbpf
> has been built already; the 'wildcard' prerequisite does not trigger when
> there's no bpf_helper_defs.h generated yet.
>
> Keep the libbpf as an order-only prerequisite to satisfy both goals. It is
> always built before the progs/ objects but it does not trigger unnecessary
> rebuilds by itself.
>
> Fixes: 3ac2e20fba07e ("selftests/bpf: BPF object files should depend only on libbpf headers")
> Signed-off-by: Jiri Benc <jbenc@redhat.com>
> ---
>  tools/testing/selftests/bpf/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 866531c08e4f..e7c42695dbbf 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -375,7 +375,8 @@ $(TRUNNER_BPF_OBJS): $(TRUNNER_OUTPUT)/%.o:                         \
>                      $(TRUNNER_BPF_PROGS_DIR)/%.c                       \
>                      $(TRUNNER_BPF_PROGS_DIR)/*.h                       \
>                      $$(INCLUDE_DIR)/vmlinux.h                          \
> -                    $(wildcard $(BPFDIR)/bpf_*.h) | $(TRUNNER_OUTPUT)
> +                    $(wildcard $(BPFDIR)/bpf_*.h) | $(TRUNNER_OUTPUT)  \
> +                    $$(BPFOBJ)


I've moved `| $(TRUNNER_OUTPUT)` into this new line so it's more
obvious that both are order-only prerequisites. Applied to bpf,
thanks.

>         $$(call $(TRUNNER_BPF_BUILD_RULE),$$<,$$@,                      \
>                                           $(TRUNNER_BPF_CFLAGS))
>
> --
> 2.18.1
>
