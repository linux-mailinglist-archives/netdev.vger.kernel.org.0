Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAB53225FF
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 07:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbhBWGij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 01:38:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhBWGib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 01:38:31 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D1BC06174A;
        Mon, 22 Feb 2021 22:37:51 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id b10so15447060ybn.3;
        Mon, 22 Feb 2021 22:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ov6pN940m3vFTgSSoEhokTMKR3Ljp8jXpLWrzhZXX+I=;
        b=JYR8cnZZ+t3qRrST5Tx7nCSwAMhxgXgsf9kEoAXgY49b70+VDsdIi59cVkdg2SqtZa
         cCNiny8Br7GpZ6qR8nWwk3rJCQlpPv4JnJBehzYFxSD4dAoTMVqSlMCI95SjAChJXULS
         iC7xCuy+RvBJxWHKPuaxB62Oo80dOKQhcJot+SAh4jvHwysAK7TWWqPHNuh8178xX1/b
         TAiCvfGNQ4wiLykdxSuIhNQmVf6clEKRyfbEhUTB4flJ3SRIr/oITeDm+1Ve+QzBIZAn
         dt+TGhYT8HvE8+NMyp+Oj362DNJpdNT0OZtONqISeAXIv/+3c85c9X5Rq3I3r0DeC6no
         DYqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ov6pN940m3vFTgSSoEhokTMKR3Ljp8jXpLWrzhZXX+I=;
        b=j71vjmshs3QMsYfj8mxP1Oq28T0D647SepVY8MPR/blIO7iw9ch4/ukyoWpFgNPM4P
         aa4J9XZksEV0oUiX4qXqqvO0Ntfo27qopUuQD8s0dTkO+4tS7r9gt0yv5OfplgCfVv7g
         d0q4WN9r6sBBagYGjk4LLmvG/WmZKqqKtzZm4GrfyxqLofso15i54yV2axJxmwYj+kX2
         4gD6uRLNL8wbJ9iiqbWDsD+B70yBEaK93Hw/UwcTF74AJKVOvic3Bkw7uyZF5xKqP6gv
         E8iGX1QJFQTJk/06/iZZwKOS6KMf/OYEUqqN2WkWMDNrRKJT/dH230DPFXdTSmVOwILR
         VlTw==
X-Gm-Message-State: AOAM532M9R+szqTqzNgvNn43kMyvEH7o7zFZ3aCjWGUjKtbKA2AM7zB0
        SdB8v8NNIkIrrP56dq4AnyXTYTAH8/gkIV5PEzc=
X-Google-Smtp-Source: ABdhPJzaC7UdIGhKbXiOOeoBLWcfUoFrSyTlj2hf4V/6UpvLhtSkx0WfogjF49K71nqsmIj5Cq1EjsokUmUeIZfvtRU=
X-Received: by 2002:a25:3d46:: with SMTP id k67mr6588877yba.510.1614062270662;
 Mon, 22 Feb 2021 22:37:50 -0800 (PST)
MIME-Version: 1.0
References: <20210222195846.155483-1-grantseltzer@gmail.com>
In-Reply-To: <20210222195846.155483-1-grantseltzer@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Feb 2021 22:37:39 -0800
Message-ID: <CAEf4BzaO6GOnkhnr_2dxgn5WXw+jboLFK7mTx9g8S7W4Eh7jhw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next] Add CONFIG_DEBUG_INFO_BTF and
 CONFIG_DEBUG_INFO_BTF_MODULES check to bpftool feature command
To:     grantseltzer <grantseltzer@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Ian Rogers <irogers@google.com>,
        Yonghong Song <yhs@fb.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Networking <netdev@vger.kernel.org>,
        Michal Rostecki <mrostecki@opensuse.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 11:59 AM grantseltzer <grantseltzer@gmail.com> wrote:
>
> This adds both the CONFIG_DEBUG_INFO_BTF and CONFIG_DEBUG_INFO_BTF_MODULES
> kernel compile option to output of the bpftool feature command.
> This is relevant for developers that want to account for data structure
> definition differences between kernels.
>
> Signed-off-by: Grant Seltzer <grantseltzer@gmail.com>
> ---

Applied to bpf-next, but adjusted subject to shorter:

"Add kernel/modules BTF presence checks to bpftool feature command"

>  tools/bpf/bpftool/feature.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index 359960a8f..40a88df27 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -336,6 +336,10 @@ static void probe_kernel_image_config(const char *define_prefix)
>                 { "CONFIG_BPF_JIT", },
>                 /* Avoid compiling eBPF interpreter (use JIT only) */
>                 { "CONFIG_BPF_JIT_ALWAYS_ON", },
> +               /* Kernel BTF debug information available */
> +               { "CONFIG_DEBUG_INFO_BTF", },
> +               /* Kernel module BTF debug information available */
> +               { "CONFIG_DEBUG_INFO_BTF_MODULES", },
>
>                 /* cgroups */
>                 { "CONFIG_CGROUPS", },
> --
> 2.29.2
>
