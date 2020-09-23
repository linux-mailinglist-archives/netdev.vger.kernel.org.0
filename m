Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88960276301
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 23:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIWVWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 17:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWVWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 17:22:12 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18180C0613CE;
        Wed, 23 Sep 2020 14:22:12 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id k2so770134ybp.7;
        Wed, 23 Sep 2020 14:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZdJKpnwJ9jONh7SpdPR+qSM7COPpaMQpIOw9WDP7OcI=;
        b=A+j6lJ0+QDSSwe3JWX4qR/8LC3LdGVCdTVMv+f1YuK2u1zp/fzwHU1EMxis7zOZnwg
         /pBNuje6OEspcqYjyknphvr1VoY22dLX4m/nCZ+dr7WHbmwTtTbc7KeJFXo5XyElEXIR
         rEHK2o4buvpomiPtvv4AQAFaIynnipecS8lY+tPnqQyyZzf8zi6lcyHBOdjZbFmN9BPU
         FgiuynpwgGP1+Ey/CiyZAYHIt6lbqF5Y/nuudYhtq1K6FtSp59lvvpn0fqzOQNhQ13Og
         UgKbmhGcsbbKB5UilSmHiDSfREGWegMlgYsLGjCfNrNJJLc08WPytaD7/U9W3it2O8k8
         CLeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZdJKpnwJ9jONh7SpdPR+qSM7COPpaMQpIOw9WDP7OcI=;
        b=RlB+EcPAoB03zwmKQOf6pGr8fXCcskn+1PgeP19WdCKGTN58CA3+ehzXgvitQtLopc
         dVXL0KzBhLQlccWZz2tQNb5DdrI9yFuX0Fe8b4p91o/i9jaFFlay3kEorXh5QVlWW2L6
         UCiQ+qSHU5HiQ8ke84k+THcoSSbYldrshZDwu8meDS+0fMtul+bDK9dLetz/FrFlE6aX
         Xgn5ZOkzcdgz81l9Vup/Asvelrgj7nvWv5sPne5bBvsYnBm3VHdP6MsbVEdKUmW3zdEx
         ql03Q23uaXRan1IOK/RoE6Yp3JN+EJ3YXABZUEwTobtrEsiY8maOuy+dM7r+CBPCdOja
         5dWQ==
X-Gm-Message-State: AOAM53358v3BS+DOgpay+wr6ZJXBrSH8V2hTSj9LCQhwWspJUnGA20aw
        pSVsqO8DYNOmxlKf4JfJJIepzMDbWXyKAKxWeec=
X-Google-Smtp-Source: ABdhPJw7c5gjFHzPJfXXPSNJbePaxvlmYk5fOdcXAIsawDEeGat/POTAVdyjUP3jvs99SVUgzKRwudh/l4vr1nQo9Gg=
X-Received: by 2002:a25:8541:: with SMTP id f1mr2690291ybn.230.1600896131286;
 Wed, 23 Sep 2020 14:22:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200922070409.1914988-1-kafai@fb.com> <20200922070459.1922443-1-kafai@fb.com>
In-Reply-To: <20200922070459.1922443-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 23 Sep 2020 14:22:00 -0700
Message-ID: <CAEf4BzaTU5bh_feyuTVupy4TZ0TR32OzU1yOJsSkmzCDq2nzCw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 08/11] bpf: selftest: Move sock_fields test
 into test_progs
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 22, 2020 at 12:40 AM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This is a mechanical change to
> 1. move test_sock_fields.c to prog_tests/sock_fields.c
> 2. rename progs/test_sock_fields_kern.c to progs/test_sock_fields.c
>
> Minimal change is made to the code itself.  Next patch will make
> changes to use new ways of writing test, e.g. use skel and global
> variables.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  tools/testing/selftests/bpf/Makefile                        | 2 +-
>  .../bpf/{test_sock_fields.c => prog_tests/sock_fields.c}    | 6 ++----
>  .../progs/{test_sock_fields_kern.c => test_sock_fields.c}   | 0

Remove it from .gitignore as well?

>  3 files changed, 3 insertions(+), 5 deletions(-)
>  rename tools/testing/selftests/bpf/{test_sock_fields.c => prog_tests/sock_fields.c} (99%)
>  rename tools/testing/selftests/bpf/progs/{test_sock_fields_kern.c => test_sock_fields.c} (100%)
>

[...]
