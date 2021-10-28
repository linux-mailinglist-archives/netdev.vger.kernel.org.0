Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E770943E5A1
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhJ1QB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 12:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhJ1QBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 12:01:25 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2333C061745;
        Thu, 28 Oct 2021 08:58:58 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b12so6623712wrh.4;
        Thu, 28 Oct 2021 08:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IfAjr9+KKKwq3jZHOqs7MUPR8iCNkDuvoFjPyZqntvM=;
        b=PyfGdX5Xu7vVSY+Hs9BCdjCwI9FiBa1IyJEScsuaJItF9N350/OhCZvPJgDBPbEQwZ
         ZiKZFknB6xcMCv78U6DdjH13aJ81hsEW+K3KTejH7iyatPL9WxKiXJdI2TKIBsYATgfW
         vAdkum8G8gQA7Ya1tjmgl5QeQhDymxdZIwQ17UAkuA0vFUkntT7xBe44v5xBoU/VNUjJ
         wH5JGuD3YmKQHPL2GoBNwIZDTtD7DXSUqZvAgBIy/jRkLIWcqzhnSBvNPz48sT/IN2CJ
         7aVIvTNc2lnHFU7mj0heub2Lqj9OkEaQC+jHpUPu//rXmdYQVcfh5Z9poCd3AJ7oFIo6
         FNeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IfAjr9+KKKwq3jZHOqs7MUPR8iCNkDuvoFjPyZqntvM=;
        b=oufkhUDOF6JlShdVaNK4KPWC1wCm+2sKu/HIABvlZzkTbRNn5/boMvfVkgSFU1vsHn
         vjQre+L1HZo0fc2xRLRLlGLyrF/FHcmQa5RNF5c2sPvVRC15EG0vLL9CMoUjxQmvqoLl
         Vxzqw1ywvt57ke45HQ1WLT0RdAWyYe3sKrSj2jCKW49EK9LA9nJuJHMuGKKLU51+dC+2
         EGkkSt++mCysjsRXmN7yM73fgdJCvaeXbccaqJNFuAxxQmRiFK7bjShiWz+c3u6V1zHG
         WnmKGmIPUrt9sXBxxoR0Yp0B9XseHWbHhU6aMLimD1gJF70KjDenCPjzjmrhXjiXdox7
         diUw==
X-Gm-Message-State: AOAM530WjTNqgDBCggIKfhlNnOWJRX6OuuRb86hT5zxl5TJI5LxNfRE9
        Vj/V+pO/HlRg88Z/DnDr6QRpCZ61E4oDBc4ipbQ=
X-Google-Smtp-Source: ABdhPJwF/tzZNVVcXXVBs376LCifqLS0X4Jx4j7NaP5Bpe1G9itZn7ONH0knEsN4be8DkUsJZbmIMYUWJcWhlPkphpo=
X-Received: by 2002:a5d:59a7:: with SMTP id p7mr6896008wrr.141.1635436737323;
 Thu, 28 Oct 2021 08:58:57 -0700 (PDT)
MIME-Version: 1.0
References: <20211028132041.516820-1-bjorn@kernel.org> <20211028132041.516820-5-bjorn@kernel.org>
In-Reply-To: <20211028132041.516820-5-bjorn@kernel.org>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 28 Oct 2021 17:58:45 +0200
Message-ID: <CAJ+HfNjfGfO52KQZ23pRJFZL9arSiYQvJcHJS5nwyBDW40inAw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/4] selftests/bpf: Fix broken riscv build
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Cc:     linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Oct 2021 at 15:20, Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org> wrot=
e:
>
> This patch is closely related to commit 6016df8fe874 ("selftests/bpf:
> Fix broken riscv build"). When clang includes the system include
> directories, but targeting BPF program, __BITS_PER_LONG defaults to
> 32, unless explicitly set. Workaround this problem, by explicitly
> setting __BITS_PER_LONG to __riscv_xlen.
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn@kernel.org>
> ---
>  tools/testing/selftests/bpf/Makefile | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
> index ac47cf9760fc..d739e62d0f90 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -277,7 +277,8 @@ $(RESOLVE_BTFIDS): $(HOST_BPFOBJ) | $(HOST_BUILD_DIR)=
/resolve_btfids        \
>  define get_sys_includes
>  $(shell $(1) -v -E - </dev/null 2>&1 \
>         | sed -n '/<...> search starts here:/,/End of search list./{ s| \=
(/.*\)|-idirafter \1|p }') \
> -$(shell $(1) -dM -E - </dev/null | grep '#define __riscv_xlen ' | sed 's=
/#define /-D/' | sed 's/ /=3D/')
> +$(shell $(1) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("=
-D__riscv_xlen=3D%d -D__BITS_PER_LONG=3D%d", $$3, $$3)}')
> +

Argh, this messes things up. I'll spin a v2 with the extra NL removed.

Bj=C3=B6rn

>  endef
>
>  # Determine target endianness.
> --
> 2.32.0
>
