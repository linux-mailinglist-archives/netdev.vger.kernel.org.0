Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1B84413D13
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 23:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbhIUVzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 17:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbhIUVzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 17:55:16 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B595EC0613E0;
        Tue, 21 Sep 2021 14:53:40 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id c7so2656687qka.2;
        Tue, 21 Sep 2021 14:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JuZKNp3WhYi3DR7rWgOF+IrjERPbP8+GlVOGLjF2wg8=;
        b=I1bWPamr9byNu+TXuCSjpcBvbqVnLblH8O/4HbHCfZPBaxUzOpFLPfaplTshTVE1w5
         euu14xzCl14Vs3JJzyOkNVnNYFIjvPS9rXnJYSPV48LOVurjgLcimQcW9oWEqhwqMzUX
         uGHjP/fhRYHU2CfTrPXMmxYvL6zB28vj6d1D62eebcgsdlQDhqGeHQxgEku6gzyCRgw+
         w3VhFoGTJgCqKdFKxqdJkdQV+y8PXqclUtA30LAFbtDx6bzhgnRDfRhoCt3y6XBCKpr4
         m8g76m3niOeD8nOxuwv9ZduLzeTJv1O6l/9+WKf6F6zM0xA8QkHtr2H4N7vyzo2OkOKL
         a7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JuZKNp3WhYi3DR7rWgOF+IrjERPbP8+GlVOGLjF2wg8=;
        b=w500GvDHWqpsmATLkSH6DPn+d0Yp5hdcEZD/4ziocfn7ABfc14KK+8oZFtgEP8g/bI
         Q9qRPHB3uAQ5fFHxJTZYshYX9sRUcmT+KpiDeKdORDVG+ftBJkEnZ6O6rw/XZwP6KnWV
         XtCJr5yCpkCmCaIAZ8BQrr1199Wov72yZyHEDwiQDbIM6n9i4LnCuGY5ycCzM5UBO41q
         GCwomlnTodtTTevxAoxOzDtPHSwCeG+Oubd3+CErQiEmTXmrvYf+Ztj5Qx7QQ/GLOxgE
         UZoPUZhXzY/61KFHWhe+UZhvIZPaSyT7HTbTekS9XIwwZyzAbJOWiNB/DGzccftbvmcu
         9GZw==
X-Gm-Message-State: AOAM5315Mbl0Ylfr+7Y8yqCX8OhlCF1yC5LSthX4KQDzz0xKXM/v3E4c
        fyDtr2FspR+rDeox11YFGJ86nt35Urwisqd3kyzrobH7720=
X-Google-Smtp-Source: ABdhPJwck3quzywdfaTdDtVJvU3YI5hKnN+XHO0+UnqxN/IrDD9LYBFkIn1HuEsC4KgEEf08AtFBuL/MoYtNXKr8KR0=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr41577491ybj.504.1632261219941;
 Tue, 21 Sep 2021 14:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210918020958.1167652-1-houtao1@huawei.com> <20210918020958.1167652-4-houtao1@huawei.com>
In-Reply-To: <20210918020958.1167652-4-houtao1@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 Sep 2021 14:53:28 -0700
Message-ID: <CAEf4BzbstXqV+oH8uBHDDSgSzOY722jv3SsYt+cZCW9Ebwk8+g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/3] bpf/selftests: add test for writable bare tracepoint
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 6:56 PM Hou Tao <houtao1@huawei.com> wrote:
>
> Add a writable bare tracepoint in bpf_testmod module, and
> trigger its calling when reading /sys/kernel/bpf_testmod
> with a specific buffer length. The reading will return
> the value in writable context if the early return flag
> is enabled in writable context.
>
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> ---
>  .../bpf/bpf_testmod/bpf_testmod-events.h      | 15 ++++++++
>  .../selftests/bpf/bpf_testmod/bpf_testmod.c   | 10 ++++++
>  .../selftests/bpf/bpf_testmod/bpf_testmod.h   |  5 +++
>  .../selftests/bpf/prog_tests/module_attach.c  | 36 +++++++++++++++++++
>  .../selftests/bpf/progs/test_module_attach.c  | 14 ++++++++
>  5 files changed, 80 insertions(+)
>

[...]

> +static int trigger_module_test_writable(int *val)
> +{
> +       int fd, err;
> +       char buf[65];
> +       ssize_t rd;
> +
> +       fd = open("/sys/kernel/bpf_testmod", O_RDONLY);
> +       err = -errno;
> +       if (CHECK(fd < 0, "testmod_file_open", "failed: %d\n", err))
> +               return err;
> +
> +       rd = read(fd, buf, sizeof(buf) - 1);
> +       err = rd < 0 ? -errno : -ENODATA;
> +       if (CHECK(rd <= 0, "testmod_file_rd_val", "failed: rd %zd errno %d\n",
> +                 rd, errno)) {
> +               close(fd);
> +               return err;
> +       }
> +

please use ASSERT_xxx() consistently

> +       buf[rd] = '\0';
> +       *val = strtol(buf, NULL, 0);
> +       close(fd);
> +
> +       return 0;
> +}
> +

[...]
