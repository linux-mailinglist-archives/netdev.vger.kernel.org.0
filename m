Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0799524CDEA
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbgHUGWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgHUGWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 02:22:50 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4204C061385;
        Thu, 20 Aug 2020 23:22:49 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x2so470267ybf.12;
        Thu, 20 Aug 2020 23:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zEcOwlnMcuwwyEAS23a3AbBxclif+b1GIZjQ1T2Ymfw=;
        b=DWoOuqUkO+yNg6/KbVNBKdrHocueXJpIkb5WCS1E78isEnGAh3FE//BS+Z36lf4Zl6
         +8edQRthScjDOfQWyMKWL0Wqjz6lDBziPOjFSX/6GImTkC7W6QmY6+eymJyQYSu4FplR
         EZGzmwpNcjQvJbZemtbbOrSKyM5WRcIy5MUQ5B30HbZJXGmUs1PGzq5WH2XZSeNB9uCD
         eaFCY3M/VF9/wjGwYEAzpy64vRWnaUVMAw4M1Uzz+fH/Sgm0QevN33SUPJV3Ux1B9hXe
         vBFmzuBjrkV0/HKQLCyGWf8GQQ60dhpjI/lNzPjUn+M9SW5MKUvrxQnQaF8BHHsGtB/N
         em/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zEcOwlnMcuwwyEAS23a3AbBxclif+b1GIZjQ1T2Ymfw=;
        b=MwNPPkco9SVWW2VfhDXgMqd+VmTWO8Pw+ACQzaY3wk3rqIXLqMFAf7BCi1Q1hBgFTX
         DkLQ4obNoi1rIEwVjC5O8fcSyxlS3L6wSy2dgSt9346eiEzX7Cq30cAT4CHgWgUW/Q8t
         D9hfsBgJIfDzgdmtMv5FJM5xAyVuruAYLK5rLdMRbsZ6Lk9zpeO9EABBQ+okGiebZOM8
         gi71Ba2mxGVUyzqgQUcUSWumxR8EP07ZCIEOaYPtx9Kdami6pjtEkBaFKW+ODOG3CweL
         8l5fw+o9hN+f7qvs6VJm3Sb+NC35Ncd7guHPj2Ku44ozUh3THnpgq128fkS1Kcr6ljTw
         H3mw==
X-Gm-Message-State: AOAM530JA1eXYa9Zu+B1lRmJuNuR2fVhxPu9jdETxwZ4VLoz7M3Rkusq
        zLyJSUTuJsFvWBpOrHy2+bLmtKzFDEJmjNAB5n4=
X-Google-Smtp-Source: ABdhPJyjnhaTaTP4bswvtjmJypu9aB4yPkk8wts2ac+PYBwcJX2VEmp5kxanp2O563Xm5/PkgjFsfDH8s/NfCRFaqsE=
X-Received: by 2002:a25:ae43:: with SMTP id g3mr1734497ybe.459.1597990968925;
 Thu, 20 Aug 2020 23:22:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200821012840.2511-1-cneirabustos@gmail.com>
In-Reply-To: <20200821012840.2511-1-cneirabustos@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Aug 2020 23:22:38 -0700
Message-ID: <CAEf4Bzb9EOHCPfYGnRNtw8xDytB+9aPtU12X=GXJ2_4+fyC8UA@mail.gmail.com>
Subject: Re: [PATCH v7 bpf-next] bpf/selftests: fold test_current_pid_tgid_new_ns
 into test_progs.
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 6:29 PM Carlos Neira <cneirabustos@gmail.com> wrote:
>
> Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
> This change folds test cases into test_progs.
>
> Changes from V6:
>  - Rebased changes.
>
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/.gitignore        |   1 -
>  tools/testing/selftests/bpf/Makefile          |   3 +-
>  .../bpf/prog_tests/ns_current_pid_tgid.c      |  85 ----------
>  .../bpf/prog_tests/ns_current_pidtgid.c       | 133 +++++++++++++++
>  .../bpf/progs/test_ns_current_pid_tgid.c      |  37 ----
>  .../bpf/progs/test_ns_current_pidtgid.c       |  25 +++
>  .../bpf/test_current_pid_tgid_new_ns.c        | 160 ------------------
>  7 files changed, 159 insertions(+), 285 deletions(-)
>  delete mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
>  delete mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ns_current_pidtgid.c
>  delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
>

[...]

> diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
> new file mode 100644
> index 000000000000..f41c1ff5de94
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pidtgid.c
> @@ -0,0 +1,133 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2020 Carlos Neira cneirabustos@gmail.com */
> +
> +#define _GNU_SOURCE
> +#include <test_progs.h>
> +#include "test_ns_current_pidtgid.skel.h"
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <unistd.h>
> +#include <sys/syscall.h>
> +#include <sched.h>
> +#include <sys/wait.h>
> +#include <sys/mount.h>
> +#include <sys/fcntl.h>
> +
> +#define STACK_SIZE (1024 * 1024)
> +static char child_stack[STACK_SIZE];
> +
> +void test_ns_current_pid_tgid_global_ns(void)
> +{

[...]

> +cleanup:
> +       setns(pidns_fd, CLONE_NEWPID);
> +       test_ns_current_pidtgid__destroy(skel);
> +
> +       return err;
> +}
> +
> +void test_ns_current_pid_tgid_new_ns(void)

nit: this and test_ns_current_pid_tgid_global_ns() above would ideally
be static functions

> +{
> +       int wstatus, duration = 0;
> +       pid_t cpid;
> +

[..]
