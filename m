Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D821E9D955
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 00:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbfHZWl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 18:41:26 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41548 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbfHZWlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 18:41:25 -0400
Received: by mail-qt1-f193.google.com with SMTP id i4so19534586qtj.8;
        Mon, 26 Aug 2019 15:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MT7NyKdT3JW9FjRxV3RaRw0YFd6/yJSjZTw+y3VedLs=;
        b=hp07n3ttsmkDweBuXXf9fae40jyu1jm/TPd8HMt2a8w/FZJbaqFxRwP5SQ1t8JSzxv
         hT2C+vI3RmYUel01lrjPBAqzbG/DVXbbajoMxoWMA+xkqlS1xoDWPxz/ulhjX+2vhpfD
         dSAUjkva4AXAYIa3pbrhVAx+wfdUtQS+wWs4lZAjyVSvIliAjMBB1n7Erfm5cKJbpbmS
         Hw5rqNxmWygy+X/uVXgak3r+Y9LwR8hXfhd2Uj15zOEd+0GzebZlOm1FTBl4TB1zKlim
         bzSk4gFWbBK3SaMAy5KUzZZLFdRTYBlfZXboAxTcuDeO7QtCG9USKnQL7/pVnCpG8/AV
         3sgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MT7NyKdT3JW9FjRxV3RaRw0YFd6/yJSjZTw+y3VedLs=;
        b=ARf+kGLCBrS8UyLJ95+xCwHGLSHA4WImzFFm8QmySDZ7IlQEZ/nC5opGYfy3hfbLjP
         wd26GpH5YBjWREwX2M+Ys+vnH5KtQ6UY8dKPtKDM6xlQ6yaKsdgyz6jXBq+5ak3wPjoB
         LOq+bozvUpCkyV7oVJY/KFsSQ0knMRY1jD4xOnRi4IOYRbVR/ssq2ix3lZgGjcgnkGFB
         muz3qDoonFGnwVlNNzgouRJy2vheatPd/OqrEqDVo4+dkXIMsOSXC+3vMGG63VPe2CYH
         y3t0VXgbtaiosGlx065NT7s+dP9/Bigrut7WBeYJo+syKM8/xBFYFxUWObT3BAX5qMvO
         ftkA==
X-Gm-Message-State: APjAAAUCI2abgOZmSqddtf/mxfq1WGdNlNpL747WTtUCUdHIrUpjgFgu
        KfSBL3jPxnhxB160t2392qrURmDPv7Rtja5K7kM=
X-Google-Smtp-Source: APXvYqyzBOrZ6nEvGr2YigcTHxZeYU7UdDmZ+BJ4PllN9k+0PpcV0wjcRLz6HkYB1aGbSDwaT9BdoASU4R86FKu4r5U=
X-Received: by 2002:ad4:424b:: with SMTP id l11mr17730686qvq.145.1566859284560;
 Mon, 26 Aug 2019 15:41:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190826222712.171177-1-sdf@google.com>
In-Reply-To: <20190826222712.171177-1-sdf@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Mon, 26 Aug 2019 15:41:13 -0700
Message-ID: <CAPhsuW65rWrY8THLK1gVeH4HN3YS3PeiUvPqDYqT9cOoENQSqA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: remove wrong nhoff in flow
 dissector test
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 3:28 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> .nhoff = 0 is (correctly) reset to ETH_HLEN on the next line so let's
> drop it.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/testing/selftests/bpf/prog_tests/flow_dissector.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> index 6892b88ae065..d2f4a8262200 100644
> --- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> @@ -344,7 +344,6 @@ struct test tests[] = {
>                         .tcp.dest = 8080,
>                 },
>                 .keys = {
> -                       .nhoff = 0,
>                         .nhoff = ETH_HLEN,
>                         .thoff = ETH_HLEN + sizeof(struct iphdr) +
>                                 sizeof(struct iphdr),
> --
> 2.23.0.187.g17f5b7556c-goog
>
