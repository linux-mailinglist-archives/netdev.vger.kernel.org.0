Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A78B2DC9DF
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 01:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgLQARG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 19:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbgLQARF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 19:17:05 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A988C061794;
        Wed, 16 Dec 2020 16:16:25 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id j17so24186937ybt.9;
        Wed, 16 Dec 2020 16:16:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=USwuDt9L3Bf2v1lvHIminMhSpPS8hGvDPuw8C5cLtwk=;
        b=izhxs5xLhfjKKP0pNwYRUaa7XWKWvJM9cqoBhulHIq6RSrw7U31AuXhY8lCtHFbVZz
         hAB/sJt6oP047tZC20jgbgY7pv9RTOuc6O/N+4bixEuB4+hU5OSMJp05CY9kGejlio2w
         7pPKgmNi/TnimqKuPDvkglpmvj/cw3X2N/E/nrSiickZJ4Mhp/zhpzJy5qv2aNRZwsHa
         AstK/IZfHn9jSqRT+n4YidRzJOp5Ljk2NgUbrJcL7CJkQzPlJb3WaHSuQ7/mDZP22KbQ
         7VANvL/3CXRH+pYXowhi6cUD85ahNYu7uLW1HaYseN58KPFsmO8gztMm33zAUjPldlh1
         nS0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=USwuDt9L3Bf2v1lvHIminMhSpPS8hGvDPuw8C5cLtwk=;
        b=awLcwSUPMvUXo5NSKt0mWZA5KQK4bZHMLkhBt0LJe780nw5OXSEaGKIK+dWC+LJpn5
         DxJreALxGId+nozhvxFy5W1Ui6bhqE3ealmPG3aMDf8arMDmSmILmoaoytGz7/0YylVL
         E858bMgP7p9VsoZTa1LUfjRjt8d6b2xFHvuOPeV9CKMe0+sbDupwuyni3XPyo0515PdD
         baHD5/lJKJdp/3hwbgZLzdeerbmDSA2Gh1GG2129dmUJ5WntEZLlXZpjy4QdrZeiny2p
         Y5veCSG2IdU9zInqvtiWwNqmVfDL4fCduhLY4jwT8iSBkNMD4rbvznd9otuM42qlRvgk
         xJWQ==
X-Gm-Message-State: AOAM530lz7AwTSToWv1+8uf+EprXYXAsud/H3hpbylp/uIIoFHhRC3UF
        jQu86r2tblXbNbhRI8RQjviiHU/j/KIyDnyrZzw=
X-Google-Smtp-Source: ABdhPJwojpu4iEItT/s9kBGiB/prgOc2vfqJiriUNlUrP8AdaSZhm2FNtXq1s9hB+VomzmgoUZIiMcMR9wApEn9hzT0=
X-Received: by 2002:a25:e804:: with SMTP id k4mr50119326ybd.230.1608164184602;
 Wed, 16 Dec 2020 16:16:24 -0800 (PST)
MIME-Version: 1.0
References: <1608086835-54523-1-git-send-email-tiantao6@hisilicon.com>
In-Reply-To: <1608086835-54523-1-git-send-email-tiantao6@hisilicon.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 16 Dec 2020 16:16:13 -0800
Message-ID: <CAEf4BzYU65bh165owbL2fSgMBji=O14xUp=JfPd79QjMEVyAtA@mail.gmail.com>
Subject: Re: [PATCH] bpf: remove unused including <linux/version.h>
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 6:47 PM Tian Tao <tiantao6@hisilicon.com> wrote:
>
> Remove including <linux/version.h> that don't need it.
>
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>  kernel/bpf/syscall.c | 1 -
>  1 file changed, 1 deletion(-)
>

Probably a left over since times kprobe programs were required to
specify expected kernel version.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 4caf06f..c3bb03c8 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -17,7 +17,6 @@
>  #include <linux/fs.h>
>  #include <linux/license.h>
>  #include <linux/filter.h>
> -#include <linux/version.h>
>  #include <linux/kernel.h>
>  #include <linux/idr.h>
>  #include <linux/cred.h>
> --
> 2.7.4
>
