Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DFC2E0F5A
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 21:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgLVU04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 15:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgLVU04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 15:26:56 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0371CC0613D6;
        Tue, 22 Dec 2020 12:26:16 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id y128so12734007ybf.10;
        Tue, 22 Dec 2020 12:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ermr6PxSdkqdl6C4e8zOwEP5CSB/npdZD7dWzOJcfEI=;
        b=YWeA6/659b0M8FU2KGposW8zm39hjbllOwFzCNSp4j3xHC7mFFq0pb/DLfBitKz8cj
         I5ZcBhsG+BfJ1hSBvdVCwmZMobQ9GnccjFpVHJQ39V02WeNW9oDxawCgzI8QwiworYtA
         tcPvFbed1XAsGuYKGVXfyqi0EdRA+iw/+tM0vyUSfcRB15+HrsJNcrYsCAqdjdoVshG/
         KbSYFmwHRxNlgqK8HHaZyyKrDNUNzMVSHWs2LYXbWlfGXXT7Euisti/4xcY+wf4owlWw
         Ef8ppBGxDb3ICd02Wvefd8qYb0tABZ7ibut13aEW95Z7kfyRigUlatAXKJaT+NrfcE82
         6lMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ermr6PxSdkqdl6C4e8zOwEP5CSB/npdZD7dWzOJcfEI=;
        b=Xd85v5Ws95N1MIxArKrci7518v3yfqFxPT7f9Rp/3XyGyKhcpVnymCrPeX3WH+DrbD
         WlXmRrE0fTeeAklrdG1qZ3Ki/UTsrGJZ9Q2h+7w+2KnZZ8dqpWfcABp1oHIAc3Nx1qtX
         7C/1vniea9xKd9IA6k1v98uLyXn/xdwc9eo6Ec5rPhcmPm3yxgG+SsaLAzkDLqI6d5td
         zWVLATumXWijp3TV9JiTtPbA5wPKeN5GWt+6ElFGmDHFogYkLJdqOO9TRmFuOZixr02I
         xUEPyp0v+ighCtI65JQV7WtXoUYtS+kRzLYdzN5gVQ95ceEInXP5i2tzRFzMWCbW0GEt
         Lq+g==
X-Gm-Message-State: AOAM5306R4L72QcvC8Hgzgpqz6bL486TkQuDv/4jwHbEuD8NYxEcV/0Y
        72sUHrKUpXE45OosKJdEqbf3Td2RgCc1gnuTyYA=
X-Google-Smtp-Source: ABdhPJzSVMnCErl9KWdmGy6rTbYfFrR7pwbRRjKHCJsflHUHxe8ShOlt9r8bOriqW4cSM9PWGMk1v8GtXnmVdw166jI=
X-Received: by 2002:a25:c089:: with SMTP id c131mr29307609ybf.510.1608668775278;
 Tue, 22 Dec 2020 12:26:15 -0800 (PST)
MIME-Version: 1.0
References: <20201221222315.GA19972@localhost>
In-Reply-To: <20201221222315.GA19972@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 22 Dec 2020 12:26:04 -0800
Message-ID: <CAEf4BzbqWa+Eco4u1zN4RqyprezBAJM-O6Oq4xv9q8Ac74ZhWg@mail.gmail.com>
Subject: Re: [PATCH v10 bpf-next] bpf/selftests: fold test_current_pid_tgid_new_ns
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

On Mon, Dec 21, 2020 at 2:25 PM Carlos Neira <cneirabustos@gmail.com> wrote:
>
> Currently tests for bpf_get_ns_current_pid_tgid() are outside test_progs.
> This change folds test cases into test_progs.
>
> Changes from v9:
>
>  - Added test in root namespace.
>  - Fixed changed tracepoint from sys_enter to sys_usleep.
>  - Fixed pid, tgid values were inverted.
>  - Used CLONE(2) for namespaced test, the new process pid will be 1.
>  - Used ASSERTEQ on pid/tgid validation.
>  - Added comment on CLONE(2) call
>
> Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> ---

See checkpatch.pl errors ([0]), ignore the "do not initialize globals
with zero" ones. Next time, please don't wait for me to point out
every single instance where you didn't align wrapped around
parameters.

  [0] https://patchwork.hopto.org/static/nipa/405025/11985347/checkpatch/stdout

>  tools/testing/selftests/bpf/.gitignore        |   1 -
>  tools/testing/selftests/bpf/Makefile          |   3 +-
>  .../bpf/prog_tests/ns_current_pid_tgid.c      | 149 ++++++++++------
>  .../bpf/progs/test_ns_current_pid_tgid.c      |  29 ++--
>  .../bpf/test_current_pid_tgid_new_ns.c        | 160 ------------------
>  5 files changed, 106 insertions(+), 236 deletions(-)
>  delete mode 100644 tools/testing/selftests/bpf/test_current_pid_tgid_new_ns.c
>

[...]

> -       id = (__u64) tid << 32 | pid;
> -       bss.user_pid_tgid = id;
> +cleanup:
> +        test_ns_current_pid_tgid__destroy(skel);
> +}
> +
> +static int newns_pidtgid(void *arg)

newns_pidtgid and test_ns_current_pid_tgid_global_ns look identical to
me, am I missing something on why you didn't reuse the testing logic
between the two?

> +{
> +       struct test_ns_current_pid_tgid__bss  *bss;
> +       int err = 0, duration = 0;
> +       struct test_ns_current_pid_tgid *skel;
> +       pid_t pid, tgid;
> +       struct stat st;
>

[...]
