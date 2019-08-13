Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 981FC8C4DA
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 01:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfHMXiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 19:38:25 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:32994 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfHMXiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 19:38:25 -0400
Received: by mail-qt1-f196.google.com with SMTP id v38so15881221qtb.0;
        Tue, 13 Aug 2019 16:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5VALDoEQf5ycz8FvNAJ3LejkjVDYOhmuS9Gj/GkPw3o=;
        b=L8NaXcnZszHCR5swq/jeZgG9+LgXkXjr5vp5FI6+CmzaiGkc9mEYgSUN2+girqWBfS
         N9fRsXuBX1Bj4TmlnESNCBdrMZjNC+2y57OhTMwG29lPxPBiV+u4IoPNd58aAZmv46M2
         nClDdbRRGV9oSSZFRZOd7HjJ6P9mWv3U9xUJaN/6J2RiToYSoN38TJ3kK6qZBIZbSvMu
         dXCo6a32kuxP7LoIFdynydFUkM5fl9fX/OYm8ZKcH9Gc6Z5b0m2pgANrAUBM8xTjGYAH
         7lVK006xQbSMnmgLLk/zTUsLLwipeQzzAygqgMPC4hFtf+gaZWuw2SGlF8EPx4Kyuld2
         iG+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5VALDoEQf5ycz8FvNAJ3LejkjVDYOhmuS9Gj/GkPw3o=;
        b=mo+JmOrx9rYcuZ1FEpbUB+l0TA6LsCuaqKGpE/WeaRrqgIhO63UO0NJ9j19zaJbEMU
         C2M5vGRk218a5PdRVOjbq0Q47RYPEM7R/fL5wpb74FVJF8evJRJx25lgOYWSDKDzE27s
         HgEVz56T1CWL/UESrIwMKNYc0191DklhMuXs81LwTzXfrtSGgzgJOhAk313iNQSFt/J4
         sNCk/1ujjasbwZXSydR0W8RaaKc64ltfoHPRojA8M96SdVdtI/+Y/Hu3cw5eldyTG3g9
         Xq5wf6ynPvG8HN2i0aiR6G1PtIypIFHZP5CkTHf0tW57WPEXGEddAt7KOzRBpvgVaeUV
         AYsw==
X-Gm-Message-State: APjAAAWXVOkQn+AWTBkBzZbcj7nnFKiOwdqf6GLVt12MNRozrxoYpXg6
        rlZpQ8BECXHBjnxpLEfoMvOGH9tPvQL8+qIRjaU=
X-Google-Smtp-Source: APXvYqyCeaZb5/L5tcoh0D1rc5SJBaOdSZCtPAgTtPVTXyCLT7/j8QVo2aQrKHtr2cMwuVGfFKsRk9xnszjWggzRKBU=
X-Received: by 2002:ad4:56a2:: with SMTP id bd2mr559803qvb.162.1565739504161;
 Tue, 13 Aug 2019 16:38:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190813102318.5521-1-ivan.khoronzhuk@linaro.org> <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190813102318.5521-2-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Aug 2019 16:38:13 -0700
Message-ID: <CAEf4BzZ2y_DmTXkVqFh6Hdcquo6UvntvCygw5h5WwrWYXRRg_g@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] libbpf: add asm/unistd.h to xsk to get __NR_mmap2
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        xdp-newbies@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 3:24 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> That's needed to get __NR_mmap2 when mmap2 syscall is used.
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>  tools/lib/bpf/xsk.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 5007b5d4fd2c..f2fc40f9804c 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -12,6 +12,7 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <unistd.h>
> +#include <asm/unistd.h>

asm/unistd.h is not present in Github libbpf projection. Is there any
way to avoid including this header? Generally, libbpf can't easily use
all of kernel headers, we need to re-implemented all the extra used
stuff for Github version of libbpf, so we try to minimize usage of new
headers that are not just plain uapi headers from include/uapi.

>  #include <arpa/inet.h>
>  #include <asm/barrier.h>
>  #include <linux/compiler.h>
> --
> 2.17.1
>
