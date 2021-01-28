Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 283EA307CD8
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 18:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhA1Rmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 12:42:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:58130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232781AbhA1RmX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 12:42:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F30464E17;
        Thu, 28 Jan 2021 17:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611855703;
        bh=FDVmPymxhm72cQCkCKboU7Cc1nRdERbNyqTTxbG64kc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YJnnlj3OuSs0JmtnTLuHpL7t5OjAclcRfNyTWwxBXf/LfL3+W2X+fY+RY8Iz1OgcM
         x3t46yQEbSoWyvFQ9tO5IWD+UBvE/Xenqz7DNNbtXM9yKlVHb+XJts241zeAV/FjOW
         UcnkfIhzgC9eN6YLE9DWcUjOQsLVsoLXXRF7gjX1PV2QbIkxjXD3D238HtyasjUwrt
         WuRKHwo++fA5BEqKKFd5N0Lv22LbTsOongOGBpn3jr2VQDp7+4BCV8mS2sHLnTs8z4
         IxwzO6uDUBRxoAoX2ORcb2ysPw/4uLzQi1aYtOBLnGMlV8PjU+D0EqtVXAW7YNXb9V
         bOMndZnNmZHfw==
Received: by mail-wr1-f48.google.com with SMTP id c4so3565993wru.9;
        Thu, 28 Jan 2021 09:41:42 -0800 (PST)
X-Gm-Message-State: AOAM531bmbvhj8UM62CMGrf+DqSJF2CrSCfnFTErkDK4ZbVdYjQU8X+h
        3uz945ZQrI1dOGnyZO1bpeQ+C20+E4jif/OUaKk=
X-Google-Smtp-Source: ABdhPJzVSdd5eqXhxhnLjpyjpCB2EK4XVVlDXZ0czLbNClKBCjcFmQ5v/mTVw3LSD1D6BmMe3SCvzGwU9YSWuCH1+bY=
X-Received: by 2002:a05:6000:18ac:: with SMTP id b12mr198202wri.77.1611855701607;
 Thu, 28 Jan 2021 09:41:41 -0800 (PST)
MIME-Version: 1.0
References: <1611825204-14887-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1611825204-14887-1-git-send-email-yangtiezhu@loongson.cn>
From:   Song Liu <song@kernel.org>
Date:   Thu, 28 Jan 2021 09:41:30 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5iejOW0EO-cPVpuq2pwUHB5wTF7iQY0UKpfco3zze8Rg@mail.gmail.com>
Message-ID: <CAPhsuW5iejOW0EO-cPVpuq2pwUHB5wTF7iQY0UKpfco3zze8Rg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] MAINTAINERS: BPF: Update web-page bpf.io to
 ebpf.io to avoid redirects
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Xuefeng Li <lixuefeng@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 1:20 AM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>
> When I open https://bpf.io/, it seems too slow.
>
> $ curl -s -S -L https://bpf.io/ -o /dev/null -w '%{time_redirect}\n'
> 2.373
>
> $ curl -s -S -L https://bpf.io/ -o /dev/null -w '%{url_effective}\n'
> https://ebpf.io/
>
> $ curl -s -S -L https://ebpf.io/ -o /dev/null -w '%{time_redirect}\n'
> 0.000
>
> So update https://bpf.io/ to https://ebpf.io/ to avoid redirects.
>
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1df56a3..09314ce 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3260,7 +3260,7 @@ R:        KP Singh <kpsingh@kernel.org>
>  L:     netdev@vger.kernel.org
>  L:     bpf@vger.kernel.org
>  S:     Supported
> -W:     https://bpf.io/
> +W:     https://ebpf.io/
>  Q:     https://patchwork.kernel.org/project/netdevbpf/list/?delegate=121173
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
> --
> 2.1.0
>
