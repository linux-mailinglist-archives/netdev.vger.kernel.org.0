Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57376273151
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 19:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgIUR5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 13:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgIUR5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 13:57:12 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BCEC061755;
        Mon, 21 Sep 2020 10:57:12 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id k18so2157733ybh.1;
        Mon, 21 Sep 2020 10:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sfv2GkP+8uG546pQRvIkIIzlFhcpsb5WNAyb9sZP3VM=;
        b=TfKGQgC76iG5Fwj3HGDdztONc6XcwsCPCJIqzNCmwwrgeqnRr4MMq2tOk+TjEgLP6z
         HuBRL0uucAX+ELBQJCZ+wh4SXLTiEgHPxEdlu3o92QHW36o+E3gqsvWxMXsePu59FAuG
         11ahLkFDhWtU6PQL+6mu0isOO1yT5YBLVQJsJqEM3HEmPS4Uyhpv+LKsvbXRZFHDfKgv
         4e3FCUd7Zm2J0rHGveRP5MxQ1iiny8tEfkS0CRLAdCQN/vO0kghVY14rbjIqHN1CpAxM
         Z6/BwST7aZk5gAIjt6vi9h/i7ZnOlNbOG0OH//KFI4wJQ170nogmmWA4hNX7PSaQVwHr
         uvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sfv2GkP+8uG546pQRvIkIIzlFhcpsb5WNAyb9sZP3VM=;
        b=aPOS58EmRGzijxvygrv9bQ2IKw6JwbI0zrmK0mspAQY9ixfWfv1SFve1P1Nyfc7exr
         fJsCk0qhfSDVohog+qqhSX9oCnJeb3E+GO8n1zXqxZ4j0q623QhpuZu2iYw70w3PJkSX
         a4WS9fbf+1iY6/VboblBnJYyRXFATDo4+gwgxRhYqDLKqylb+ejFg57slmrJXmwQCUvK
         qQqtJqecIgT37xHYMXONyfAi71pDb8kdbvCDCT7GaHnhEuDPrDlcoUCdltIq7UfDoQwh
         d62m4E94GQWXKxMAc/DgOMw88SxtFtrZxTguvnDDUgN3iMAjiRSIImk1DsjVmO7HBMe6
         1Wxg==
X-Gm-Message-State: AOAM532VvF2xvKk6JFBcYgPgUcAydW/qLIfXHe5iaraOVjSgtEvYeniC
        ZEJ5IIhID0S/yKlwSrJflHZzO9FvXap7jSHmImw=
X-Google-Smtp-Source: ABdhPJxS8Q5mIofEfi8HpR2Q+otGNIK3oXK54P/XbCPZoNXSGRzYAgIg5Wb/gxzVpr1D+UCWqCCWEOeF3SveoltgHMU=
X-Received: by 2002:a25:9d06:: with SMTP id i6mr1482122ybp.510.1600711031713;
 Mon, 21 Sep 2020 10:57:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200916223512.2885524-1-haoluo@google.com> <20200916223512.2885524-4-haoluo@google.com>
In-Reply-To: <20200916223512.2885524-4-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 10:57:00 -0700
Message-ID: <CAEf4Bzbxd1Bp8py=gd9mXpcN9HB7a8qR5PtYVLbN_3e7qOP8pA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 3/6] selftests/bpf: ksyms_btf to test typed ksyms
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 3:39 PM Hao Luo <haoluo@google.com> wrote:
>
> Selftests for typed ksyms. Tests two types of ksyms: one is a struct,
> the other is a plain int. This tests two paths in the kernel. Struct
> ksyms will be converted into PTR_TO_BTF_ID by the verifier while int
> typed ksyms will be converted into PTR_TO_MEM.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  .../testing/selftests/bpf/prog_tests/ksyms.c  | 38 ++++------
>  .../selftests/bpf/prog_tests/ksyms_btf.c      | 70 +++++++++++++++++++
>  .../selftests/bpf/progs/test_ksyms_btf.c      | 23 ++++++
>  tools/testing/selftests/bpf/trace_helpers.c   | 27 +++++++
>  tools/testing/selftests/bpf/trace_helpers.h   |  4 ++
>  5 files changed, 137 insertions(+), 25 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_btf.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_ksyms_btf.c
>

[...]
