Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACC6B675BF
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 22:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfGLUPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 16:15:12 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:40345 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727125AbfGLUPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 16:15:12 -0400
Received: by mail-qt1-f196.google.com with SMTP id a15so9423361qtn.7;
        Fri, 12 Jul 2019 13:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LAHnrDdMVUv7xAGW5DfLj/F+sQF4Cb8/6ATsTX4w9vM=;
        b=XrEMFti//4a7M9eVgNrgrwFdUY989LAmaCgcbmXfob+udrhnwwoOet5n7W6jz5tL+T
         +XvOZ3esRo+b2s2YrdFXhFrFaWWR/pwSBnlfc4v5EK/hcJywnfFV8QNh1iaw30JMCjkW
         u5yDCQNQAi4OSZPqE6dFN3gmNfuxw/zSU5GOnQYTEd5iViewcpEoQT5ZABAfeI3E3jlb
         mGzo90Up3FNWb5vC3dgxkQFh+730UVL4ZWA9700GLaD7k9aHi84O3Tg7o42kC0XB2Mbn
         X7R7jh6zDsrUgNUtl8u/oJ1f3L8WKzhK0OvU8UxJJcm2wvSq/sC7jIltfZK94/b3/8fb
         ycHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LAHnrDdMVUv7xAGW5DfLj/F+sQF4Cb8/6ATsTX4w9vM=;
        b=gO1YSzaqUDi9NgMJPfhKkt+CvQoEFgt1TJ4wFpxuQE8SkjXL1gY4Zn5UqLTA9Ebpi3
         yWucA8EHinrjIWx2oFmqdelrSRFUMHflCp3g/KCOYkc2zWuNryMshblF6sJz0EavRpne
         T0LuvRgL70S10xHqLr5lzYFnIVOYyai25QQV7OA46rIQh9SDf7HHxXrtR7uhJCEB4Fvx
         5fQUrB98xwC+2NhcL2DPsiaR/9MU/VUuRMj+da7wKMDpF2/HXDeMIWPsz5afAHfXjXuo
         C3h4gfQczVEJR6M639uczHE2pgpWkMyaYrahoxVM4neRmH9yMf8xnNxNWbVPw7Ycqyg/
         qIWA==
X-Gm-Message-State: APjAAAUrxpWMmlTPS33mbt1E+1Wi2us5rp/duEe75ShsrzPpBezCmO4p
        /BSTnt0D47f9jSkxhxP3BGKMaMBF0WTyyT0wz+bVyQEyQnx/Wg==
X-Google-Smtp-Source: APXvYqwX1EtXQsTBQey3KX6PZON6bGB486pJRkwh8yCAqbS2eUN4ZJtbdxtRVMIs3bbld1EPWOtc1OvqceP0Il9SMd4=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr7833379qta.171.1562962511516;
 Fri, 12 Jul 2019 13:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190712135950.91600-1-iii@linux.ibm.com>
In-Reply-To: <20190712135950.91600-1-iii@linux.ibm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 12 Jul 2019 13:15:00 -0700
Message-ID: <CAEf4Bza3fDw+M-S-1G1D+hsoCEum=WEoycbFgi2c-cdfG8=Ckw@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: put test_stub.o into $(OUTPUT)
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        gor@linux.ibm.com, heiko.carstens@de.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 12, 2019 at 7:00 AM Ilya Leoshkevich <iii@linux.ibm.com> wrote:
>
> Add a rule to put test_stub.o in $(OUTPUT) and change the references to
> it accordingly. This prevents test_stub.o from being created in the
> source directory.
>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> ---

Makes sense.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/Makefile | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 277d8605e340..66b6f7fb683c 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -83,13 +83,16 @@ all: $(TEST_CUSTOM_PROGS)
>  $(OUTPUT)/urandom_read: $(OUTPUT)/%: %.c
>         $(CC) -o $@ $< -Wl,--build-id
>
> +$(OUTPUT)/test_stub.o: test_stub.c
> +       $(CC) $(TEST_PROGS_CFLAGS) $(CFLAGS) -c -o $@ $<
> +
>  $(OUTPUT)/test_maps: map_tests/*.c
>
>  BPFOBJ := $(OUTPUT)/libbpf.a
>
> -$(TEST_GEN_PROGS): test_stub.o $(BPFOBJ)
> +$(TEST_GEN_PROGS): $(OUTPUT)/test_stub.o $(BPFOBJ)
>
> -$(TEST_GEN_PROGS_EXTENDED): test_stub.o $(OUTPUT)/libbpf.a
> +$(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(OUTPUT)/libbpf.a
>
>  $(OUTPUT)/test_dev_cgroup: cgroup_helpers.c
>  $(OUTPUT)/test_skb_cgroup_id_user: cgroup_helpers.c
> --
> 2.21.0
>
