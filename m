Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA2D262359
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 01:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgIHXEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 19:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgIHXEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 19:04:38 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB76DC061573;
        Tue,  8 Sep 2020 16:04:37 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id h126so539289ybg.4;
        Tue, 08 Sep 2020 16:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y8hsXVohB2iOf+eEUTcp5spGfGJv7tXbMnt02En1QW8=;
        b=AC3II7FbJR44XH6KwMcicoguO9wiKmQ7ZIFY6i/YwT7VeNtiyRNnJpnaR9NqLoN/fl
         /fip7DwKKKEUyM6oDkAsMLN/lK2j/B7+y/3mHqx55qv4WO9zQZQhxkZWwCUHbljseEtf
         QXQ3zWFkL45+wtxErwZO+bUAbYzSdQxTCfsqg/PhvwBiXwaktZNopCYjS53oGR844fI4
         kzz+e+zR+KkhHWzkSACvqd71Bc5SUSvnJraID0vXcOv/6iu1dI++fLtct0cjGuEo3C9S
         kX03u6F3vuujVx7QPmxfouqMThn1Do8le0+BQuN2lI40bjByZ+3xjBw+KL05eKrS5Qy7
         XZHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y8hsXVohB2iOf+eEUTcp5spGfGJv7tXbMnt02En1QW8=;
        b=fPuFQnCSeR1r+6eccj6A4xrm4CJfHGAuVOWcF5Gk8UohLuJGdpkqjNnuzq1bC3sJ79
         2ltiyM5qxn+VBlKt0W6xxa4EhGiaY64jtRo4Rp0IvrOzDklEfhSV4nDUwyKHKa47YUVe
         qJGfWPKo7DGzl3apCl2TNUgCl8z6xCR1G7IIGhXzFD0XJIWtqwyfKS2YqckK75OU499e
         PgHtlNIYz0PtKLlWgc7+clFfNIw1d4ZZAnbbl0cXpyrR6rUG9a/QeI0SKqXWmgIr3vZf
         Bth4ZsAvd9o8Dxea/5mNWVn8IbKH+vcZ5Tsfl3ShUadW/MTDb2vxICvTpEw7laStpekh
         3oDA==
X-Gm-Message-State: AOAM533MEyOug81Sm7q2+IUZhGU5AO4GUAw5BwTlGJXyCn8FQVFebiYC
        uqJnDWmS0gGTtLkJXbIITERfUB5gNT7jsFeX8yU=
X-Google-Smtp-Source: ABdhPJznIm7fSl1Zlha33yud+kajXZ1VkQVDiHphdq+zXsEm4Baaf62L5U97HZX3/nmiSsvgkFmTEe8rO5DBU6kqFpU=
X-Received: by 2002:a25:aa8f:: with SMTP id t15mr1722729ybi.459.1599606276899;
 Tue, 08 Sep 2020 16:04:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200908132201.184005-1-chenzhou10@huawei.com>
In-Reply-To: <20200908132201.184005-1-chenzhou10@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Sep 2020 16:04:26 -0700
Message-ID: <CAEf4BzanC5xCLjq8tOyZKQ=ojhcyDYBhJkGVTcqCB-=uLctUvw@mail.gmail.com>
Subject: Re: [PATCH -next] bpf: Remove duplicate headers
To:     Chen Zhou <chenzhou10@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 1:07 PM Chen Zhou <chenzhou10@huawei.com> wrote:
>
> Remove duplicate headers which are included twice.
>
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  net/core/bpf_sk_storage.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
> index a0d1a3265b71..4a86ea34f29e 100644
> --- a/net/core/bpf_sk_storage.c
> +++ b/net/core/bpf_sk_storage.c
> @@ -12,7 +12,6 @@
>  #include <net/sock.h>
>  #include <uapi/linux/sock_diag.h>
>  #include <uapi/linux/btf.h>
> -#include <linux/btf_ids.h>
>
>  DEFINE_BPF_STORAGE_CACHE(sk_cache);
>
> --
> 2.17.1
>
