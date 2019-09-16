Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 360CFB427D
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 22:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733103AbfIPUwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 16:52:19 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34071 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfIPUwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 16:52:18 -0400
Received: by mail-qt1-f193.google.com with SMTP id j1so1652976qth.1;
        Mon, 16 Sep 2019 13:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5E9DgtscC1GCtZrAXaWV/e6LeSvuqfRExaR2l222qbg=;
        b=enkRrJ55r7CGq7yUK4OocWnjoUqN9/uub1ZCS+9yECQozqQ2jDtdumCB63K7CeXa+l
         V0SxSGOa2bxm/UuZbey4+hVW3Iht0Nv47si42XYT9Til3uYobVfFgyM2oOxcedhJGTsa
         SRfEmCG1mjtekX2nNy3N2WD8vbFBgpij7OBs4C6IZWXB2JNzS6I3POMHJ14q8B8euY0j
         olun8rjtZ4LUOTrxIH+MGn4+lq21PMDeXOAzFdFtA7YZksoryS2UPeUl0VRQfYjBDFfw
         0GOkbQduwoMvvmPtumFqWVDuHkSrHWAyaTuqiHTiiAFTsv08OgLSV6a1pXJIAO27yvlG
         NaBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5E9DgtscC1GCtZrAXaWV/e6LeSvuqfRExaR2l222qbg=;
        b=pQ086qCrJAZxk90lCU07eUltPVNd9NHJySnh92eOeSWGo2ZTovFNAx9RQhRU8NQMmz
         PM3kZsofdJm0fQ0Z1Zcyu18Nubh9XlmbD/atAGZvQe/3wdByF+7dkEltlnLyJTzBYOR9
         MUw+xC/xH/KBzWsqRxllzkBLCd40HGKE2UAxTCc/P37q8vWd0J6ToEYi0UQZ9QkZa4JF
         foBt3N+RmWKC9YfFoFu8EePB2BkLPssIi7cIybEh2Hwq2QDSnR09ntQdSkaxny9/4NGr
         6MrihgoUYU6X8hLUL2Zdj4huD5GJwa1ahVJf4woxZUn2h2MqRChKox7r5tyIjtt3rT2p
         ZRbA==
X-Gm-Message-State: APjAAAWpY0HN0fM1up2xAhHimYSLU+WgZcbJx3Itfek54hoZ9aC6u7sm
        FLBugqAerwftNF3aDKV2175yTn3GdBgPl9zFQqE=
X-Google-Smtp-Source: APXvYqyfMJnpEjwqE4JJFdMyeOIHHaKx1q6Z6c4or3iQtVgnN7odi3uyKCacD3BuDE1jEzb/b2tO2nkGx6ORAW/uLZc=
X-Received: by 2002:ac8:7401:: with SMTP id p1mr324627qtq.141.1568667137518;
 Mon, 16 Sep 2019 13:52:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190916105433.11404-1-ivan.khoronzhuk@linaro.org> <20190916105433.11404-7-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190916105433.11404-7-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 16 Sep 2019 13:52:06 -0700
Message-ID: <CAEf4BzYvt8=mnvo7jrSKhuHg-_kunb1F_F3g8hhwsZfWExEFPg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 06/14] samples: bpf: makefile: drop
 unnecessarily inclusion for bpf_load
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

On Mon, Sep 16, 2019 at 4:01 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> Drop inclusion for bpf_load -I$(objtree)/usr/include as it is
> included for all objects anyway, with above line:
> KBUILD_HOSTCFLAGS += -I$(objtree)/usr/include
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  samples/bpf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index d3c8db3df560..9d923546e087 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -176,7 +176,7 @@ KBUILD_HOSTCFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
>  KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/ -I$(srctree)/tools/include
>  KBUILD_HOSTCFLAGS += -I$(srctree)/tools/perf
>
> -HOSTCFLAGS_bpf_load.o += -I$(objtree)/usr/include -Wno-unused-variable
> +HOSTCFLAGS_bpf_load.o += -Wno-unused-variable
>
>  KBUILD_HOSTLDLIBS              += $(LIBBPF) -lelf
>  HOSTLDLIBS_tracex4             += -lrt
> --
> 2.17.1
>
