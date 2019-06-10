Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFF43BB9A
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 20:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388411AbfFJSFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 14:05:41 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33769 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388052AbfFJSFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 14:05:41 -0400
Received: by mail-qt1-f196.google.com with SMTP id x2so10623276qtr.0;
        Mon, 10 Jun 2019 11:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZtStdpDNoyEsUZ6qL6LprfD1eEPpxVt5IEMfulMqHXY=;
        b=ICFgyX5FN9AjjbitaeqmhCoIKKQQX/8+Rk0dyoN/VHYeFttg/zqJEFKpB4dvXSgkXr
         7IpvnX1fbkSfhogHqesZ7GAbbq/vtijTJCfmoozhS6QutFABFhKe1YhPmt4PqU3HaBqG
         Ww4akR1fqYLjQj3ERf/YPi4cYhtfc7n7EchhSYJ42iBMuwr05uzy/iMpqGDqGadx13CX
         Zdi6af1ZJ4VxA046BZfU3KfOONRi0rm3dL0CRjc+bs1CC3Ksp11x8f8mZN7EzBM0RqDo
         WfH+kHv8dIeIBoBDT4Wz06NIqjwsKaDHiP37q1qNkoBNSY1DsOJ0EoHhVzGeCqnLQrzl
         v9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZtStdpDNoyEsUZ6qL6LprfD1eEPpxVt5IEMfulMqHXY=;
        b=OsuOcy9L5wbt/BiAoK5vIz31z/1nHC0oyfhzkdmbFyGIPuRHRdwSH0RSMwKscewA2S
         GmkceKU1fvTJwWNxi5iEv3G+2V9741PbfWj+l/iO4aJy92YlfyRnNwRtWQLirTT6IqFd
         rSr001Mc0AeAITASXAhPPP3nLKeQBVweLXjpGI32h0x0HwlMoQpmUDfTQrr4/3S7f4oF
         tQsA19+tRxJUpAmyE44CgOl/4F9xNtpSsUnOB5Z05ABy3KYz5u/oQvqaQRsr6uJZMsqk
         +n2iF7KVDDmZxL4UgrlZQ7z/bH/7HA4BnPGEPhDM/1L/0neBv8THu5pLv8eQoZYOV6Es
         dPSA==
X-Gm-Message-State: APjAAAUHmntxZQ30+9gEBa+lbEqdjOoBBIqwahtI+nPpMaOBQgXi7ssf
        Dg+3FYohYi+RKPNYD58LYGNjYQuN6YrAp6crI6Y=
X-Google-Smtp-Source: APXvYqyr7p8LglbEhvSAleTQvxen1XQO6XNyrKqkUdrjB6tREVMk8IGec9zH4R6BQ2zlWR/jUaKetesb3owr0fn6Yfg=
X-Received: by 2002:ac8:21b7:: with SMTP id 52mr42323888qty.59.1560189939904;
 Mon, 10 Jun 2019 11:05:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190610165708.2083220-1-hechaol@fb.com>
In-Reply-To: <20190610165708.2083220-1-hechaol@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 Jun 2019 11:05:28 -0700
Message-ID: <CAEf4BzZGK+SN1EPudi=tt8ppN58ovW8o+=JMd8rhEgr4KBnSmw@mail.gmail.com>
Subject: Re: [PATCH v1 bpf-next] selftests/bpf : Clean up feature/ when make clean
To:     Hechao Li <hechaol@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 9:57 AM Hechao Li <hechaol@fb.com> wrote:
>
> I got an error when compiling selftests/bpf:
>
> libbpf.c:411:10: error: implicit declaration of function 'reallocarray';
> did you mean 'realloc'? [-Werror=implicit-function-declaration]
>   progs = reallocarray(progs, nr_progs + 1, sizeof(progs[0]));
>
> It was caused by feature-reallocarray=1 in FEATURE-DUMP.libbpf and it
> was fixed by manually removing feature/ folder. This diff adds feature/
> to EXTRA_CLEAN to avoid this problem.
>
> Signed-off-by: Hechao Li <hechaol@fb.com>
> ---

There is no need to include v1 into patch prefix for a first version
of a patch. Only v2 and further versions are added.


>  tools/testing/selftests/bpf/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 2b426ae1cdc9..44fb61f4d502 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -279,4 +279,5 @@ $(OUTPUT)/verifier/tests.h: $(VERIFIER_TESTS_DIR) $(VERIFIER_TEST_FILES)
>                  ) > $(VERIFIER_TESTS_H))
>
>  EXTRA_CLEAN := $(TEST_CUSTOM_PROGS) $(ALU32_BUILD_DIR) \
> -       $(VERIFIER_TESTS_H) $(PROG_TESTS_H) $(MAP_TESTS_H)
> +       $(VERIFIER_TESTS_H) $(PROG_TESTS_H) $(MAP_TESTS_H) \
> +       feature

It doesn't seem any of linux's Makefile do that. From brief reading of
build/Makefile.feature, it seems like it is supposed to handle
transparently the case where environment changes and thus a set of
supported features changes. I also verified that FEATURE-DUMP.libbpf
is re-generated every single time I run make in
tools/testing/selftests/bpf, even if nothing changed at all. So I
don't think this patch is necessary.

I'm not sure what was the cause of your original problem, though.

> --
> 2.17.1
>
