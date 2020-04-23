Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFB71B53A8
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 06:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgDWEcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 00:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgDWEcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 00:32:43 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20818C03C1AB;
        Wed, 22 Apr 2020 21:32:43 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id x8so3798735qtp.13;
        Wed, 22 Apr 2020 21:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ONRdv2EHJkeP1dZk13OKJk8t2m0zbusvOF5XkgXsGKI=;
        b=a92P+A4Fo+KyyV/8UnJkqJv1d/jcnr6vx4CAycakBEVOoSOjJCV4aIfT23pN3Olv9a
         746YPQx6Rg8ABXndRaQg817aqQIWe6JqcklJk6ZEEskIEJwPZJaOTT2Yi1QtZnL0noUP
         iDLIVM1Bqcv8yXXwb9e/JJDGWiAbz7Y3k4HMwKgI6wX9jP2jpE/2/aX180kX+ZEqQ6zX
         fmTxrpa+b/zzWyuIvi6IWp6XlZMn04GW1uGetinWQMEHoS8MjcTXg5QCdP24pLuCtN0u
         AjMGcMB/JRU9WZcXdEhrxfGqKhK/VzlCTqWE/OTLU68z5oibQJ9lyb7n3eEft0UmZ3HL
         XI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ONRdv2EHJkeP1dZk13OKJk8t2m0zbusvOF5XkgXsGKI=;
        b=Oz2fiZo8NQs8zoZXeaKYfJTbFqszqKdPJzxbkZuDp0GxYuK1qBfVIS0gXD1NvoqO/H
         a/aYnTsIE/dgFnA6Z26GyucDbdICwqopud77LzB+x5im2Lu9AthWDk0piF6E+m83P09i
         +HdqHLiNVKcikE066FLPGeTyrCdS99tO4ukuWH0jfePimFDPVMGr2hT0SJKESUJpdkwH
         kuZjr47/2xBjaNHt16+qb8lV0IOuvEM+Q2+UpV34IUNXYRoqeD/IEVnIZSYtltAe0zd8
         qAldY4ReJDXmWCiQyzxG+GehZ6W9xacXxzl7szLEJM4nLqpuWs70Kao5yTqNStTcypaN
         qYYw==
X-Gm-Message-State: AGi0PuYivh0gR+m9cteJ6siiY7U1YphYhgjACqQEQHd+jwcnW4fDofmC
        iC8AJBDgjwdn0cC/l5EdkYJqz8yuKX1Spb7/wbE=
X-Google-Smtp-Source: APiQypJxdK9NkfuFdm1IGwzIsysSQUrgJ76ZAZ6RvADlb4IRbSF+aPzKHgjf7Ah5AhIAVQ9yiXP/faq8vJDuGf+VJ1g=
X-Received: by 2002:ac8:193d:: with SMTP id t58mr1984994qtj.93.1587616362178;
 Wed, 22 Apr 2020 21:32:42 -0700 (PDT)
MIME-Version: 1.0
References: <1587609160-117806-1-git-send-email-zou_wei@huawei.com>
In-Reply-To: <1587609160-117806-1-git-send-email-zou_wei@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 22 Apr 2020 21:32:31 -0700
Message-ID: <CAEf4BzaMEsmLmoJKk67DazZ1-GHSiOLcB7nB9Yh8N8wAViG0eg@mail.gmail.com>
Subject: Re: [PATCH -next] bpf: Make bpf_link_fops static
To:     Zou Wei <zou_wei@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 7:27 PM Zou Wei <zou_wei@huawei.com> wrote:
>
> Fix the following sparse warning:
>
> kernel/bpf/syscall.c:2289:30: warning: symbol 'bpf_link_fops' was not declared. Should it be static?
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> ---

Thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  kernel/bpf/syscall.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 8608d6e..fcb80e1 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2286,7 +2286,7 @@ static void bpf_link_show_fdinfo(struct seq_file *m, struct file *filp)
>  }
>  #endif
>
> -const struct file_operations bpf_link_fops = {
> +static const struct file_operations bpf_link_fops = {
>  #ifdef CONFIG_PROC_FS
>         .show_fdinfo    = bpf_link_show_fdinfo,
>  #endif
> --
> 2.6.2
>
