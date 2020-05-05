Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8FE1C61F6
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgEEU1c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726350AbgEEU1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:27:32 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E81C061A0F;
        Tue,  5 May 2020 13:27:32 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id l18so3238009qtp.0;
        Tue, 05 May 2020 13:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=M+bSfHPTEyBAcHP67vb3R0BiVVVTCuZd1ZgURgvwgHA=;
        b=Fpxw32YZ9PsGRamyG0e286Ip7d+MWKnwVuEYQ/rMNHoBfomHU8H/48x6PwY9zx5RDP
         M+J/nqfyABO9qXP47Hb16V5TSoBgjAFxKkiAxxaloRwyBt5wW+kfUokWgTXLV5zPyPuX
         qqghGLhb7tsRzE4orJsZvlwuJ5gfUQHtzZw0p9zCDkub0p8xRSTHJpODdcI/Hb90PhOf
         qNxeCzi9a0J/rvV0tmx9lJBEXLY+I5/S5pX8umctyx+TEJWdON6XdU04kZJd7TZVZpcS
         Au01sZftkElLxpAQKO/125XjbElYrSPVhR2QySEtCOrIWBsiJgJblVNVUiKDWdSXjfVa
         aKyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M+bSfHPTEyBAcHP67vb3R0BiVVVTCuZd1ZgURgvwgHA=;
        b=NPlJiSyZTLBUZgliG4wHkhInyP0S7AGo5taWgqnqeExTpfl9dySS1flP5ftFFOrjzK
         K9iOvJQjsUHUL7fq5j7Ey4wWYXLwB27qDTHpoPkNK0kA5h7pIo62anlZHjoNnGBelXAx
         hDnh4X740RfQ6T6WNTEmitxH+ZwARDZ2aAJ8a8Nih+CLMvIrHb9IaYbwO7NivhJh6g1g
         AotUBbDNr8Eyi77S6hKYu/hwA4kNr8rBIxEU0BIw+iR1UV5lstcO2SMRzW7ap1n8NJbR
         F0XkcFrxebw2L1F893s7OJ5Q62e+kSkkXeSIvFHSy6XNGJe/YIFxeOg5iPzwpbw2Z0V8
         v/UQ==
X-Gm-Message-State: AGi0PuYNmAcLiOvI6o5Fu44oZJmDteDD1Z8SWRinc5acy6rhHHH1wuG5
        a50vcYSeiGaZT0IdEUFQ4g0gZbZAehjBMFsCZB0rvg==
X-Google-Smtp-Source: APiQypJxn8wQ+DbhLXDjyM9lPXHrI069f+ZGaKC9EMqhEQuexLdC/M6LYkJZkdkv/AgKJMiXMZ+1p34J5wbYFm8dQ7Q=
X-Received: by 2002:ac8:3f6d:: with SMTP id w42mr4650792qtk.171.1588710451432;
 Tue, 05 May 2020 13:27:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062600.2048291-1-yhs@fb.com>
In-Reply-To: <20200504062600.2048291-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 13:27:20 -0700
Message-ID: <CAEf4BzbD=z6k3dcSf+c5qFS+iBUd_bDDWCq52DgEb2XOXSMT9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 12/20] bpf: add PTR_TO_BTF_ID_OR_NULL support
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> Add bpf_reg_type PTR_TO_BTF_ID_OR_NULL support.
> For tracing/iter program, the bpf program context
> definition, e.g., for previous bpf_map target, looks like
>   struct bpf_iter__bpf_map {
>     struct bpf_iter_meta *meta;
>     struct bpf_map *map;
>   };
>
> The kernel guarantees that meta is not NULL, but
> map pointer maybe NULL. The NULL map indicates that all
> objects have been traversed, so bpf program can take
> proper action, e.g., do final aggregation and/or send
> final report to user space.
>
> Add btf_id_or_null_non0_off to prog->aux structure, to
> indicate that if the context access offset is not 0,
> set to PTR_TO_BTF_ID_OR_NULL instead of PTR_TO_BTF_ID.
> This bit is set for tracing/iter program.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h   |  2 ++
>  kernel/bpf/btf.c      |  5 ++++-
>  kernel/bpf/verifier.c | 16 ++++++++++++----
>  3 files changed, 18 insertions(+), 5 deletions(-)
>

[...]
