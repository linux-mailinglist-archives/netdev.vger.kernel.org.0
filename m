Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6015B41AB
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 22:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391310AbfIPUS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 16:18:27 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:34170 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728003AbfIPUS0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 16:18:26 -0400
Received: by mail-qt1-f194.google.com with SMTP id j1so1528809qth.1;
        Mon, 16 Sep 2019 13:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QEfTUH7Dj5bEKXTFuGOQc+OAP+VdIgkp+YMXyKatLYY=;
        b=RZ6erArdcAZdtjv3JOmWbrX4/G0vjwHOK8U+bo+sFvT5YFuZGgjV6AOft9NjTWc2zF
         gYYrQLCUNQqxHmDMF9osHnUVsKnGJJfEQvBZ6KLby8w2wqExy4QoXDHO9gDnZxQ5GxRc
         VBI+3ejWmrJnYjI5YAv78mq2nvYJ9x9f6G1h9ZoRgW99rH03H63kuZ7PG1Lsoeaqehbm
         GET0TL50doQoESLtm2vTNs1EU3+9Sg2blvTaoI91O/w5BoMKFwoi7uTzsI/LxC2V2bR1
         /DYrMEqoeiAx+s48lIsCkGJlXAyG4BHNFyDC/2T/JjmsBQLe0Bhor1thC8+e6koCprSp
         +GUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QEfTUH7Dj5bEKXTFuGOQc+OAP+VdIgkp+YMXyKatLYY=;
        b=ujQOjsnXJblsoYVz3BZbawAymykwWKwgb9/8IL8pSuQ9SDVa/39/CJ/1KoH+6xAYgP
         yiogsQYl8Xtto8Oh/Z5S1Vzp3TK02rmOU8U/6kV0na7i/rzmrkEDWIiwfbU4Zf9D5t3V
         pcN6XEJfACN6elWFKwBp1dBVW4il04wdyW9TZSBfwHOMfAzIr/bIxJ7I8QDE7KiubUyy
         B4CK4baAcC5eGPiqLZMwuXxPW41I2ZsyRIG6O3Y3MFhs+Ls6uUgEY9DrGUtnt3XWAIDy
         G6pW5X4wG8CBnzuKolHDrGhyH9GZWLqUxs16TLYHSTiTPLLGxvERmKa6GJqqEKP+0m9U
         YOgg==
X-Gm-Message-State: APjAAAVEziO7HMLFq5yB0nWvBH4Nh2xfkYiJfIO5jo7MWh5XJ1YXPGuk
        BMi8iSDQ0ADQaIcoaMohK96vT5KhcGxX8A2RdgE=
X-Google-Smtp-Source: APXvYqw+ZHsh8RU8noqA0dDMyf1yC2xpqfVnOyJozeB+kygnh9xNGYRtDLhJvEiqe/XplH2JsgoBVdgIFTixu/com0A=
X-Received: by 2002:aed:2726:: with SMTP id n35mr188114qtd.171.1568665105443;
 Mon, 16 Sep 2019 13:18:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org> <20190916105433.11404-3-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190916105433.11404-3-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Sep 2019 13:18:14 -0700
Message-ID: <CAEf4Bzbsud6HPdOCswB6JyMNiQPCAhog3Qqe4-2oKZrA8btgvQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 02/14] samples: bpf: makefile: fix
 cookie_uid_helper_example obj build
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        sergei.shtylyov@cogentembedded.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 16, 2019 at 3:59 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> Don't list userspace "cookie_uid_helper_example" object in list for
> bpf objects.
>
> 'always' target is used for listing bpf programs, but
> 'cookie_uid_helper_example.o' is a user space ELF file, and covered
> by rule `per_socket_stats_example`, so shouldn't be in 'always'.
> Let us remove `always += cookie_uid_helper_example.o`, which avoids
> breaking cross compilation due to mismatched includes.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  samples/bpf/Makefile | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index f50ca852c2a8..43dee90dffa4 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -145,7 +145,6 @@ always += sampleip_kern.o
>  always += lwt_len_hist_kern.o
>  always += xdp_tx_iptunnel_kern.o
>  always += test_map_in_map_kern.o
> -always += cookie_uid_helper_example.o
>  always += tcp_synrto_kern.o
>  always += tcp_rwnd_kern.o
>  always += tcp_bufs_kern.o
> --
> 2.17.1
>
