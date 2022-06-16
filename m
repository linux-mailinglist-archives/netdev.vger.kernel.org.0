Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E5254E0C6
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 14:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376857AbiFPM2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 08:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376785AbiFPM2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 08:28:20 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B0642EE5;
        Thu, 16 Jun 2022 05:28:19 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t2so1163223pld.4;
        Thu, 16 Jun 2022 05:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CsyNlWGfCLaN1Mp5MzxrFekUYxYGGamzpItJbY7hpFI=;
        b=P3rJYrI7hIaS3hN5m5N1doteyRlY3IKEBEa2dPkgzXRcYwNTf0gInJwy2kawcx3XGp
         P/iTp6OJ10VfO0hwGVjjjwFMwPccvXGpFQNMdWpAgYGdotVLKt8ZArbQlja7/LyTz7DU
         4wSH/De/pr73AMHSQ612QfzhtOVwuoyLub42cU8VPGXbTECLZhJwRJEXDmBELloKcpB2
         LJB81nalmgBQAvg83WrtHRmi0KL6j92dAArTYsoeBn7THIswqdd+4EFlb4ld3GpQy2tu
         n0AlZzWy7dg598x3nW/2KP9tdYqNeDq+8yr+QAjL8jzdfch5tPqhl1ZAdiEkiC/v/mwh
         eZRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CsyNlWGfCLaN1Mp5MzxrFekUYxYGGamzpItJbY7hpFI=;
        b=4DiccbPuTCi+8VPDk/ngjQYQS/lVh23Rcm/2jH/BzOXb3G473xvLAj8qmARMhg3Q5M
         f26cM0w4mXSTwhtY9lyWElpLFKZ5poy3JyEPoHtI3WNRqvibn6RcxFOYP0sUj5GtO8gg
         uGzYsqPnFgiT2h/W/K+Gv5DN9PZxu6TK3E24k9CH5jrWr56BppHq8Q/8gpmYNxmq/ILd
         HCcPuCzBUjWf/GibnIdzpL84JudWaAqgpfdL0+Drul5GfgSZOkt+jDxrXPDBsOSGhFcs
         lNxCModPu2XO/fGP4BglyIFfKQ9RcTL1U0IHxSFULNjo0ck/5nW/mCL2mYTShEwqBHiD
         X5iQ==
X-Gm-Message-State: AJIora9tpZQUzI1hDVf3Xp4/A2R27wMC0y/Nkv9JyXXr2S6OJPA44MmC
        K9RIMdo0wbaOUf1hx9LXLX7YzKVB/x1VOGz0i58=
X-Google-Smtp-Source: AGRyM1vd/yKOgu5k6NsVqOMQbP1n9CbyiP0WqzBAIbF2cbOb1yPNJ39prLIdXJ2nsc+UdJt1eJB4SKEqRreW74++kao=
X-Received: by 2002:a17:90b:1e42:b0:1e8:7669:8a1c with SMTP id
 pi2-20020a17090b1e4200b001e876698a1cmr4843719pjb.206.1655382498796; Thu, 16
 Jun 2022 05:28:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220615161041.902916-1-maciej.fijalkowski@intel.com> <20220615161041.902916-11-maciej.fijalkowski@intel.com>
In-Reply-To: <20220615161041.902916-11-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 16 Jun 2022 14:28:07 +0200
Message-ID: <CAJ8uoz1_ygfd9rU20MpxFLG=0sPnEutr8WtowaySL7z1ERPw_A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 10/11] selftests: xsk: remove struct xsk_socket_info::outstanding_tx
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 15, 2022 at 6:18 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> Previous change makes xsk->outstanding_tx a dead code, so let's remove
> it.
>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 20 +++-----------------
>  tools/testing/selftests/bpf/xdpxceiver.h |  1 -
>  2 files changed, 3 insertions(+), 18 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index 13a3b2ac2399..ade9d87e7a7c 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -815,7 +815,7 @@ static void kick_rx(struct xsk_socket_info *xsk)
>                 exit_with_error(errno);
>  }
>
> -static int complete_pkts(struct xsk_socket_info *xsk, int batch_size)
> +static void complete_pkts(struct xsk_socket_info *xsk, int batch_size)
>  {
>         unsigned int rcvd;
>         u32 idx;
> @@ -824,20 +824,8 @@ static int complete_pkts(struct xsk_socket_info *xsk, int batch_size)
>                 kick_tx(xsk);
>
>         rcvd = xsk_ring_cons__peek(&xsk->umem->cq, batch_size, &idx);
> -       if (rcvd) {
> -               if (rcvd > xsk->outstanding_tx) {
> -                       u64 addr = *xsk_ring_cons__comp_addr(&xsk->umem->cq, idx + rcvd - 1);
> -
> -                       ksft_print_msg("[%s] Too many packets completed\n", __func__);
> -                       ksft_print_msg("Last completion address: %llx\n", addr);
> -                       return TEST_FAILURE;
> -               }

Actually Maciej, I would like to keep this test. The more sanity
checks we can do, the better. The bug that was just fixed in commit
a6e944f25cdb ("xsk: Fix generic transmit when completion queue
reservation fails") can be caught by this check as the bug introduced
more completions than packets received.

So please drop this patch for the v4.

Thanks: Magnus

> -
> +       if (rcvd)
>                 xsk_ring_cons__release(&xsk->umem->cq, rcvd);
> -               xsk->outstanding_tx -= rcvd;
> -       }
> -
> -       return TEST_PASS;
>  }
>
>  static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
> @@ -955,9 +943,7 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
>         pthread_mutex_unlock(&pacing_mutex);
>
>         xsk_ring_prod__submit(&xsk->tx, i);
> -       xsk->outstanding_tx += valid_pkts;
> -       if (complete_pkts(xsk, i))
> -               return TEST_FAILURE;
> +       complete_pkts(xsk, i);
>
>         usleep(10);
>         return TEST_PASS;
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
> index f364a92675f8..12b792004163 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.h
> +++ b/tools/testing/selftests/bpf/xdpxceiver.h
> @@ -104,7 +104,6 @@ struct xsk_socket_info {
>         struct xsk_ring_prod tx;
>         struct xsk_umem_info *umem;
>         struct xsk_socket *xsk;
> -       u32 outstanding_tx;
>         u32 rxqsize;
>  };
>
> --
> 2.27.0
>
