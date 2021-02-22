Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C30322011
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhBVTX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbhBVTXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 14:23:03 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62660C061574;
        Mon, 22 Feb 2021 11:22:23 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id p193so14057232yba.4;
        Mon, 22 Feb 2021 11:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WsM98fcGIZKjwnVCaL+ViAH8zE26oXr+w7xGr+VdcXE=;
        b=dteqb54ZVR5E5vjSoMReussOrnHLJHLHFmF6j+Jf8AWCUADCjdUHhNIp+3FYh/LLou
         n1fqaDFlMTIO2lpertgvrto77dx7/7cgRTfGhkViYOI4PNfDU0VD9tUVHyeaz4M0/TF/
         rbJ0jFbnpmRoGYslofXaoDu5Ftw0v8NO/lFFGWZS52lKuyI4lF3PM7QrJRvNDGKe8s/9
         2EUACnKbFxPnlRZpuKIzjfHrqD+7JB29LUcsdSZUT4ACamc0GEjNIfLD102jCusYSbkv
         AL2p+XvZWQ5W0enYq4T0QMB3/WpGRiqUMfU/GTyud5XFM9ahDMZBz2jkdL3npNR8vC4c
         W3Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WsM98fcGIZKjwnVCaL+ViAH8zE26oXr+w7xGr+VdcXE=;
        b=aCS/6+AbegfI/RaNXcQumluui0r3PU/DPa6bSJGiei1bundbLnhtfGGqnSRauQe03S
         P1pKa+vE7OdBN6tZjfvXyEVu00S3HhNrc6wx/iGnn2DJS+VjBnW9m6Yd4/h8MOcWaZYK
         xAAlAwKFs+kkYAheT686GLAF//pWIkbXOYuL7IkDC3bxfq+w1sTkddSi5OT3j5qCLSGr
         VbrR2pIIbvIBp36barRH7EcLIDIj6uUEUrsUJ3va3wIWTeCnWSuZCoaaP3+mWsFSewpm
         IaIyf3WCkxIXPkW/z50ov5kK4AT2YWfNbGK9LAfKmN+lzAsDN4FA4Sow1T+LUnsXOJXd
         g8Jg==
X-Gm-Message-State: AOAM533m91noVzCFVyNqUeP0nIGeQKTggb7Aotb9ftqTtKuxDpXKXZoR
        ngee3dJ6C63Bru3xQp5leTeY3H6GJs6OtF7RlKs=
X-Google-Smtp-Source: ABdhPJwm6M72w2Qk/LpbuhCFYL7dK/aCNFKcdkVTCBZNZnxFmUPslyliJ7HJWXHrtjpqIQYXbIGj1vNd+ZDEnIVZ5Js=
X-Received: by 2002:a25:1e89:: with SMTP id e131mr35479292ybe.459.1614021742742;
 Mon, 22 Feb 2021 11:22:22 -0800 (PST)
MIME-Version: 1.0
References: <20210220171307.128382-1-grantseltzer@gmail.com>
In-Reply-To: <20210220171307.128382-1-grantseltzer@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Feb 2021 11:22:11 -0800
Message-ID: <CAEf4BzYMvLg=B=ppjJpyr9VrjCFZepqyBKqgeaG8CakvpWq-Tw@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next] Add CONFIG_DEBUG_INFO_BTF check to bpftool
 feature command
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

On Mon, Feb 22, 2021 at 7:34 AM grantseltzer <grantseltzer@gmail.com> wrote:
>
> This adds the CONFIG_DEBUG_INFO_BTF kernel compile option to output of
> the bpftool feature command. This is relevant for developers that want
> to use libbpf to account for data structure definition differences
> between kernels.
>
> Signed-off-by: grantseltzer <grantseltzer@gmail.com>

Signed-off-by should have a properly capitalized (where it makes
sense) real name of the author. Is it Grant Seltzer then?

> ---
>  tools/bpf/bpftool/feature.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index 359960a8f..b90cc6832 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -336,6 +336,8 @@ static void probe_kernel_image_config(const char *define_prefix)
>                 { "CONFIG_BPF_JIT", },
>                 /* Avoid compiling eBPF interpreter (use JIT only) */
>                 { "CONFIG_BPF_JIT_ALWAYS_ON", },
> +               /* Kernel BTF debug information available */
> +               { "CONFIG_DEBUG_INFO_BTF", },

How about checking CONFIG_DEBUG_INFO_BTF_MODULES as well (i.e.,
"Kernel module BTF information is available")?

>
>                 /* cgroups */
>                 { "CONFIG_CGROUPS", },
> --
> 2.29.2
>
