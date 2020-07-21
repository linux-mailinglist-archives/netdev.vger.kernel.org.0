Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7702288FF
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 21:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730324AbgGUTRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 15:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbgGUTRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 15:17:50 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF084C061794;
        Tue, 21 Jul 2020 12:17:49 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 140so1900536lfi.5;
        Tue, 21 Jul 2020 12:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZWBDSpvSID9isJQH7VhMl+fYpyhlV/5rIWPv6OTFX7k=;
        b=bjJmOnjSvHymIbPjtRqJcq5iUmACuMPlpNYY6EiWRnwQ+sFauRHkIDHR5ii1tNFodT
         ZnGD/2GgQCh8NnD4rf8Ac3y7LP2ZzOXhMhd4+1PTsXLxT1J6FVdqFTZl9/8paiZu46F+
         11ZygeKCLBq/O9uFsto9he37C6pu1uCRIFRFhS+mH2Fx+r/+W8yMbhqzmFUsWNxY2dVJ
         oFKNi1baFIPVyTgn3OmUXQr+TVKR8DWDca0+usbBxY573rfj5PrAwdT/AviH+Bnnqzh7
         rBH51dIX87TxnklidM+nyuPcde5wMeX/OKWTGFOpS9tuuruGLaHLaQjhwVMbJGhs9QN9
         g+rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZWBDSpvSID9isJQH7VhMl+fYpyhlV/5rIWPv6OTFX7k=;
        b=AqaVCx4dmf0CXrkFgizjSdrMNXq1tiW3GbiKWWSS6i1b5l25oLIKJEbAu5Z23SAKhv
         we2eO1gpnmZ1itRuk+79LC7oipIy/366k26PsifiC73+6khysTu9APkjhgk5jy4VPDl6
         agy1ateTmz1U8pr6Q/HAeMyqEMqecEk3jU1j9d6R8eEGC9KPrHSWaeaJlLEhdGG5XSsn
         /lh9UbfRNqFl9S+aS6/O/7kSi8C+NKlV4+F6RRyOw67HDxofh6DQikahdz2+/SH4y809
         xeltIrGOszq7R60Enus0i81EQ/HtMRTXLqQvwwFeQJNF07x0wxXFQQcBJj7UmaU7lHi+
         B1tA==
X-Gm-Message-State: AOAM533Cy1GKErFDLZle7T6sZC/JUdZZyn00xY+5lEkpXyKGsAZ8LPUf
        BHUcm2W2tpuF81Sz4a0PTwaW9tk+7dStOuGj90Q=
X-Google-Smtp-Source: ABdhPJzrrRmzoMl0l7Jzq9SQZQf3um1JlMaVowRRAM+BxYECxE+izAQMM7qYNVXZ6dnQZDkCxLqs2b1d7HmQF0qklRk=
X-Received: by 2002:a05:6512:3610:: with SMTP id f16mr6898040lfs.8.1595359068359;
 Tue, 21 Jul 2020 12:17:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200717020842.GA29747@vm_111_229_centos>
In-Reply-To: <20200717020842.GA29747@vm_111_229_centos>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Jul 2020 12:17:36 -0700
Message-ID: <CAADnVQJvW7hto4E740Hi9b22wszYLxVwUCDS5jMdQ_2E3==GRQ@mail.gmail.com>
Subject: Re: [PATCH] ebpf: fix parameter naming confusing
To:     YangYuxi <yx.atom1@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 7:08 PM YangYuxi <yx.atom1@gmail.com> wrote:
>
> Signed-off-by: YangYuxi <yx.atom1@gmail.com>
> ---
>  kernel/bpf/syscall.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 0fd80ac81f70..300ae16baffc 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -1881,13 +1881,13 @@ struct bpf_prog *bpf_prog_inc_not_zero(struct bpf_prog *prog)
>  EXPORT_SYMBOL_GPL(bpf_prog_inc_not_zero);
>
>  bool bpf_prog_get_ok(struct bpf_prog *prog,
> -                           enum bpf_prog_type *attach_type, bool attach_drv)
> +                           enum bpf_prog_type *prog_type, bool attach_drv)
>  {
>         /* not an attachment, just a refcount inc, always allow */
> -       if (!attach_type)
> +       if (!prog_type)
>                 return true;

I think it makes it worse.
Now the comment doesn't match the code.
And attach_drv name also looks out of place.
Technically program type is also an attach type to some degree.
The name could be a bit confusing, but in combination with type:
'enum bpf_prog_type *attach_type'
I think it's pretty clear what these functions are doing.
So I prefer to keep the code as-is.
