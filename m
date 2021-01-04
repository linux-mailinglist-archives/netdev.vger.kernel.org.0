Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1952EA128
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 00:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbhADXwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 18:52:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbhADXwi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 18:52:38 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727EAC061794;
        Mon,  4 Jan 2021 15:51:58 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id w127so27625430ybw.8;
        Mon, 04 Jan 2021 15:51:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OUC+sjRwzZPWZn9wQSpN2ckaEnS39drtltw2kfzj/2k=;
        b=iL7V859rzK4Ja2ZDu4+HR6dh9OdCpMHpPFNC88MrGQIy9iV/H2+j0oG/ohbggl1rGu
         w8OZrsSHzsgFqITYmjGFmXlJgS3fo+7oKwJZwh7JCbhSXE7SpVHMQDCl4hvWBPjw6a6y
         M/AJnNxWhhyQ90ll/8y23r0yj77EeFIplTKp7ibP0n+OE3rQzlgsHzLkRNaG55HyKQlb
         36IBTLyrXrM4iYd2GFUIfoLSxvWv9ymf2/CGRDMW2nYrWKjbHwYViF8N5Nc2kEpSNvCK
         VKok0Vcf0awc1+1UVCwAdR8Bbr8gRftQT36M2DER1SpMqSFhmB7gqqQ6paQz1fhzL5PA
         MDiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OUC+sjRwzZPWZn9wQSpN2ckaEnS39drtltw2kfzj/2k=;
        b=pDqWfkpbMXlBBQPDgkwEBHAqfMmRioLJF8NiPA00Ko+h4RyWsjnFjmQH6+eHjAuqsE
         AK49FVG3DUozZK7lY3kFkjMP8lZUrPI0ND/rPcMhL/RBegn5nRJBShJhkjCd53kZkLvo
         NDhB3WHnifqTMzprSEHLgrgE73YMBaeCnYz+szJZ0p4k/g+4zbW7SmqmWk+rZdYFEagv
         52M3QfMp79wokeR1+TfM4RPtrTmiO9B1sCRmbLubXZpKazFUqD1g5+aBidna7Fy9A0/H
         4CXch+yAgmMFwtWqBz+8D0dmAAQm0GU931/CJHaf/k1MbqRzu4mrMnp+oaDH/KSI0fyv
         owsg==
X-Gm-Message-State: AOAM532/tq9oL2kfknXAeDYCaeeL+s2Y6m8tGcfSGNbfD34/3gvrk2BM
        IZoY65E7ihJzWwQdvchftWx1rCIuI4f+gNbuCnd1fHRp
X-Google-Smtp-Source: ABdhPJwnEh0ALf4m/tKSP6OEVGqL4lmQ2ZYuSnjHl+tf2p1bYdRvrGcbu0BIxkNyjNXx6/tEHmZI4BkmKIqQC8keUXI=
X-Received: by 2002:a25:c7c6:: with SMTP id w189mr107309965ybe.403.1609794047281;
 Mon, 04 Jan 2021 13:00:47 -0800 (PST)
MIME-Version: 1.0
References: <20201228154437.GA18684@localhost>
In-Reply-To: <20201228154437.GA18684@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 4 Jan 2021 13:00:36 -0800
Message-ID: <CAEf4BzYGJAyu5h9UNrcY-iHDDBw-vLo18UgyKzmNHwnhKoqEBQ@mail.gmail.com>
Subject: Re: [PATCH v11 bpf-next] bpf/selftests: fold test_current_pid_tgid_new_ns
 into test_progs.
To:     Carlos Neira <cneirabustos@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 7:48 AM Carlos Neira <cneirabustos@gmail.com> wrote:
>
> Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
> This change folds test cases into test_progs.
>
> Changes from v10:
>
>  - Code style fixes.
>  - Remove redundant code.
>
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---
>  tools/testing/selftests/bpf/.gitignore        |   1 -
>  tools/testing/selftests/bpf/Makefile          |   3 +-
>  .../bpf/prog_tests/ns_current_pid_tgid.c      | 118 ++++++-------
>  .../bpf/progs/test_ns_current_pid_tgid.c      |  28 +--
>  .../bpf/test_current_pid_tgid_new_ns.c        | 160 ------------------
>  5 files changed, 69 insertions(+), 241 deletions(-)
>  delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
>

[...]

> -void test_ns_current_pid_tgid(void)
> +static int test_current_pid_tgid(void *args)
>  {
> -       const char *probe_name = "raw_tracepoint/sys_enter";
> -       const char *file = "test_ns_current_pid_tgid.o";
> -       int err, key = 0, duration = 0;
> -       struct bpf_link *link = NULL;
> -       struct bpf_program *prog;
> -       struct bpf_map *bss_map;
> -       struct bpf_object *obj;
> -       struct bss bss;
> +       struct test_ns_current_pid_tgid__bss  *bss;
> +       struct test_ns_current_pid_tgid *skel;
> +       int err = 0, duration = 0;
> +       pid_t tgid, pid;
>         struct stat st;
> -       __u64 id;
> -
> -       obj = bpf_object__open_file(file, NULL);
> -       if (CHECK(IS_ERR(obj), "obj_open", "err %ld\n", PTR_ERR(obj)))
> -               return;
>
> -       err = bpf_object__load(obj);
> -       if (CHECK(err, "obj_load", "err %d errno %d\n", err, errno))
> +       skel = test_ns_current_pid_tgid__open_and_load();
> +       if (CHECK(!skel, "skel_open_load", "failed to load skeleton\n"))
>                 goto cleanup;

err will be 0 here, and test failure won't be detected (if it happens
in a child process), right? please check all the other cases. It might
be better to assign err = -1 at the beginning and just assign err = 0
after all tests succeeded, right before the clean up.

>
> -       bss_map = bpf_object__find_map_by_name(obj, "test_ns_.bss");
> -       if (CHECK(!bss_map, "find_bss_map", "failed\n"))
> -               goto cleanup;
> +       pid = syscall(SYS_gettid);
> +       tgid = getpid();
>

[...]

> -cleanup:
> -       bpf_link__destroy(link);
> -       bpf_object__close(obj);
> +       if (CHECK(waitpid(cpid, &wstatus, 0) == -1, "waitpid", strerror(errno)))
> +               exit(EXIT_FAILURE);
> +
> +       if (CHECK(WEXITSTATUS(wstatus) != 0, "newns_pidtgid", "failed"))
> +               exit(EXIT_FAILURE);

this exit will happen in the parent process, which is test_progs test
runner itself, right? Which will prematurely stop all of the remaining
tests to run. I.e., you can't just exit(), you need to just return and
let test_progs keep running.

> +}
> +
> +void test_ns_current_pid_tgid(void)
> +{
> +       if (test__start_subtest("ns_current_pid_tgid_root_ns"))
> +               test_current_pid_tgid(NULL);
> +       if (test__start_subtest("ns_current_pid_tgid_new_ns"))
> +               test_ns_current_pid_tgid_new_ns();
>  }

[...]
