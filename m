Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 099E8193742
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 05:18:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgCZERo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 00:17:44 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43185 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgCZERo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 00:17:44 -0400
Received: by mail-qt1-f196.google.com with SMTP id a5so4232795qtw.10;
        Wed, 25 Mar 2020 21:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fHENaFwhjg8MWbs9vsqxRQSS59TKIMR/3p0Xb3bb18k=;
        b=NXJHsvIyKikoFaqS2xXynvDQ3DC3REU/yyiojhLAa9Vh7tA5nBu+PKWLD+LgkwWUa8
         I8n30GSrOr04sbs6B/KIlZ68ilysIEh3KpBBo2C3nKrW91Hp+bjbw8flv4tL3AADcPgU
         4BMYkYee/KRH7/TFWRnvn/nXm5vScqBwfAQUuLIvE2xHDbZPBWPg66w5tUpv8qG3rv0s
         mbUFnF0rdesdUD7fCBeuGkikL8w+W0dZ6iny2jUAjJNAoyYdWonRjSwEJ5MPp6xtlwD9
         XgBXrEyXI0u8gMsV5M1mquiPJC+0m21BLJ6OGndGgetRn0oFnXZQB9pM9QW1XaRqxHDy
         wVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fHENaFwhjg8MWbs9vsqxRQSS59TKIMR/3p0Xb3bb18k=;
        b=BEw6rP/KJuyR88pmMVvJtbr/Kwxhje5jNgCmjYSNzud34DhK0bzGRxJqSVdZluAuPj
         YsKy8OlIGJMzp7HYMRP0WLtxCbIlyPNKkQB55RCOlAaS8Cv4DTP9V7V8St+Ebpu41MUm
         pMxzU+x3wYkB5pRttzUcQfVAW4TGazqngYLCnOS94ktQhC+DxcWufPXWZgLHaniVcmPj
         8wTUrzyihOFNUGjtd3+OH7r+MEB7tfRzF8JXIwOZeLWpiTRJXBydsMY/D/n2Cu5RGyd2
         TWXIqeeOP9M+gKbgTIWNIoujQlfXrWdf8Ddy/ocj8f0wnY7jZO8edpVQ25Z57wph5I9g
         +Gqg==
X-Gm-Message-State: ANhLgQ0Gqd76bNwLabPrhxBSADcWy4S5E5pPTIcQxKGV/Qn0cZc58Mgz
        XB1LDXvt9UXFKztJrjPl+DeuybEmZ4y4G+StMi8=
X-Google-Smtp-Source: ADFU+vvyvipOj8rsPkAgiIMk18Cbe+Y0jlQySYFKCUfo/wKMOuZawNX+BWxy/hR2o/RxP9Lgicfvigq8Qxfngbcofj0=
X-Received: by 2002:ac8:1865:: with SMTP id n34mr6031028qtk.93.1585196262155;
 Wed, 25 Mar 2020 21:17:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200326031613.19372-1-yuehaibing@huawei.com>
In-Reply-To: <20200326031613.19372-1-yuehaibing@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 25 Mar 2020 21:17:30 -0700
Message-ID: <CAEf4BzbeXgvahiDcV+bkMOrgud6-BryPaKUPV+eDQ=TjjqZaLA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: remove unused vairable 'bpf_xdp_link_lops'
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 8:16 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> kernel/bpf/syscall.c:2263:34: warning: 'bpf_xdp_link_lops' defined but not used [-Wunused-const-variable=]
>  static const struct bpf_link_ops bpf_xdp_link_lops;
>                                   ^~~~~~~~~~~~~~~~~
>
> commit 70ed506c3bbc ("bpf: Introduce pinnable bpf_link abstraction")
> involded this unused variable, remove it.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---

Yeah, I noticed this when I was adding bpf_cgroup_link (and replaced
this declaration with bpf_cgroup_link_lops. But I guess we can fix it
sooner.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/syscall.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 85567a6ea5f9..7774e55c9881 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2252,7 +2252,6 @@ static int bpf_link_release(struct inode *inode, struct file *filp)
>  #ifdef CONFIG_PROC_FS
>  static const struct bpf_link_ops bpf_raw_tp_lops;
>  static const struct bpf_link_ops bpf_tracing_link_lops;
> -static const struct bpf_link_ops bpf_xdp_link_lops;
>
>  static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
>  {
> --
> 2.17.1
>
>
