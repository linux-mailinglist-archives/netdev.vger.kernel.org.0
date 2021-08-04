Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248703E0AE5
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 01:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbhHDXfe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 19:35:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235723AbhHDXfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 19:35:31 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FC8C0613D5;
        Wed,  4 Aug 2021 16:35:17 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id z128so6231771ybc.10;
        Wed, 04 Aug 2021 16:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FIStWUnIwN9xxzfhFSpEOvwZlqPC8eOzQW+QcRRnr8Q=;
        b=OCSICMD496iCs9XQO4XN5mwHQezzdsJwBrrFPKqRjaveesTUwvIg8EmKGiGTLaQnAT
         H9+nJTgcWbjIe58nGn8yA1j2MW1yDkfbFORxnUtbDqbO9+reFk8l7FCOM6zXANu8jybI
         dZtzAivZLSMYcV3o6E4pH3+uD8eLEm1cPlBa1Cneq8BjQatQMVClsVAw5uIgTwelGvxb
         L3SsIMyx5AYubVx8mlXzj5QR2BnqhDkAuZPhaTpa9anb2CtChNGS+XClxTU8PNCFJeBq
         zRerHZYds+6VsR6XnbdA/Ib3hMVrTN+YHUpNvnWB4pwFGM34K6ykNVmtI5jdM1T/jeZL
         v8LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FIStWUnIwN9xxzfhFSpEOvwZlqPC8eOzQW+QcRRnr8Q=;
        b=kSuCMWoH/a7HJAQ1OzMRNcuD9/RqULyxD2pQKd/0nEqS1Gmuyr5pUq8iBA48haFv9o
         OpXDIwiedC/MByWVQ8GVHUYklD74oUs9+fPCfQ1BCIQhegkmPaHwXwx11GdqkS/hvnbX
         6RlS7R99XlD92kBMA3ApoGBy6MFDWe8ar/+kztG1/WAKtgf/4mftEPgxPYHg9fwyNpUq
         xvX4UGyHf7hjRpaqKiBBsM2rCZl8VL9goOQewqWMP221bCD6d+VYOj1LFBkM5iqvhzxi
         0ch1lAGebN1FXyu96V00QHdsIC5nKRap1gyvaDMFB5luKS3WG0GmXcZmdz1Nr/1c7fZi
         T0Dg==
X-Gm-Message-State: AOAM530NUASq1IER04r/da/dLLf/vMeG3JhVNcoK0njsd94KonzyqL8J
        /30kUwYW6YccbsJdSjLn6Wht9vWEeO7/pLkkYhs=
X-Google-Smtp-Source: ABdhPJwl4J885Dz0VCjsxYdDBL0rcUm7lg/YcvRC/1LThvVQymxOR+xRqpLpWHz/lqtP3Zw0KxgHMCbZaEpGTE3dpls=
X-Received: by 2002:a25:d691:: with SMTP id n139mr2444161ybg.27.1628120116912;
 Wed, 04 Aug 2021 16:35:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210730061822.6600-1-joamaki@gmail.com>
 <20210730061822.6600-7-joamaki@gmail.com>
In-Reply-To: <20210730061822.6600-7-joamaki@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 4 Aug 2021 16:35:05 -0700
Message-ID: <CAEf4BzaLWuJi5YAj5imV3j6T8NR-P+ZRuE5mT_Fvvo1vG47SpQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 6/7] selftests/bpf: Fix xdp_tx.c prog section name
To:     Jussi Maki <joamaki@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 4, 2021 at 5:45 AM Jussi Maki <joamaki@gmail.com> wrote:
>
> The program type cannot be deduced from 'tx' which causes an invalid
> argument error when trying to load xdp_tx.o using the skeleton.
> Rename the section name to "xdp/tx" so that libbpf can deduce the type.
>
> Signed-off-by: Jussi Maki <joamaki@gmail.com>
> ---
>  tools/testing/selftests/bpf/progs/xdp_tx.c   | 2 +-
>  tools/testing/selftests/bpf/test_xdp_veth.sh | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/xdp_tx.c b/tools/testing/selftests/bpf/progs/xdp_tx.c
> index 94e6c2b281cb..ece1fbbc0984 100644
> --- a/tools/testing/selftests/bpf/progs/xdp_tx.c
> +++ b/tools/testing/selftests/bpf/progs/xdp_tx.c
> @@ -3,7 +3,7 @@
>  #include <linux/bpf.h>
>  #include <bpf/bpf_helpers.h>
>
> -SEC("tx")
> +SEC("xdp/tx")

please use just SEC("xdp")

>  int xdp_tx(struct xdp_md *xdp)
>  {
>         return XDP_TX;
> diff --git a/tools/testing/selftests/bpf/test_xdp_veth.sh b/tools/testing/selftests/bpf/test_xdp_veth.sh
> index ba8ffcdaac30..c8e0b7d36f56 100755
> --- a/tools/testing/selftests/bpf/test_xdp_veth.sh
> +++ b/tools/testing/selftests/bpf/test_xdp_veth.sh
> @@ -108,7 +108,7 @@ ip link set dev veth2 xdp pinned $BPF_DIR/progs/redirect_map_1
>  ip link set dev veth3 xdp pinned $BPF_DIR/progs/redirect_map_2
>
>  ip -n ns1 link set dev veth11 xdp obj xdp_dummy.o sec xdp_dummy
> -ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec tx
> +ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec xdp/tx
>  ip -n ns3 link set dev veth33 xdp obj xdp_dummy.o sec xdp_dummy
>
>  trap cleanup EXIT
> --
> 2.17.1
>
