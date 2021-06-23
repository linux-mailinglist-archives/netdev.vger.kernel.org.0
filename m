Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F933B13FE
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 08:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbhFWGfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 02:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWGfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 02:35:00 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854D0C061574;
        Tue, 22 Jun 2021 23:32:42 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l11so913505pji.5;
        Tue, 22 Jun 2021 23:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xJdnFfE3PfYVnhG5Z/vLXv7ETsm3m4letYFLnkEV8dM=;
        b=kKHO+F2wzhMRj9EgaZlyVg552Sm6hloAXa1E534iJAGvKsRIAfUGHZgw5SCARpeos2
         c+YI6/QunZgQrWlyJUuEFqGbOTV4Zg6JOwhhRK7AteFqZrKM66i/PIrqjYK0mY1Te9Vj
         eQLz35+73moIyCLaWsHyg6af8MNf4C/uhnrcHtitmPsQfiKQTz5zXMeKzpRKNXwjFfq/
         5ALRlubNloYGJvNbeHLdpi4HcCHCseTIByVTaWc8oRxjr4VVI+zZ08bTi7GEOT21nZc1
         tGUfqhXumPJJIanSTGOduA40fTI5hHRx6LzB3fXEwlw3ywPI/rKNZrtXmFmw0pIcskNr
         +nSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xJdnFfE3PfYVnhG5Z/vLXv7ETsm3m4letYFLnkEV8dM=;
        b=Lo+fZ2Ym+QYTcbIAAKjhz3CW9SPwh7dqfCq1k7WhwL8Q0G5Apd7HVsUI2LzW2Lr4J2
         fnCvXSWD3buKp7r1v3M1TUi2NCNCpW31T7H98jV68RrmrRzdUGh6qTgUvyJX7YpgGCdt
         qMAliqO6JDCsZIYNGPSQtpsDdcod5o3KKT2Dl1WeWx3uoQxRtSNr93iTN3ytk/j+b93t
         UqHtYT7IiRmv0x1+sIA95XeCI5Vge6YlGnVu+bDYA+4efaAEjTvVHke22M0SPIM6yiiv
         iD1lUwSu4DV+N2wGOvV8vdrh36FMem9RN0JgoHmOaK1g6EyPmO9229Gswz4QzNJwoG3G
         8QIw==
X-Gm-Message-State: AOAM531YE7wAr4WFvFcOA9Dz3OBBWu5Ax7LB3ZVHbcovONR0f/dY3rJO
        GHqjZrvFZjgrr1tT2KLYYaJJYgNCC/yYAnV9GUU=
X-Google-Smtp-Source: ABdhPJw7ScLCZDYlVN5RUxJ2w8iUMF+Ur6lP6oF1HYkj6gfGi5L79ao+U07v6Dvsaeg8fFnx8/lPuZSFVglkCmSvQWg=
X-Received: by 2002:a17:90a:8589:: with SMTP id m9mr7956572pjn.168.1624429961937;
 Tue, 22 Jun 2021 23:32:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210622185647.3705104-1-i.maximets@ovn.org>
In-Reply-To: <20210622185647.3705104-1-i.maximets@ovn.org>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 23 Jun 2021 08:32:30 +0200
Message-ID: <CAJ8uoz3Wbfq4C2NeXS6f_1aUk6tb9qRmsKQK7fDyqsgZEXKoSA@mail.gmail.com>
Subject: Re: [PATCH] docs: af_xdp: consistent indentation in examples
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 22, 2021 at 8:57 PM Ilya Maximets <i.maximets@ovn.org> wrote:
>
> Examples in this document use all kinds of indentation from 3 to 5
> spaces and even mixed with tabs.  Making them all even and equal to
> 4 spaces.
>
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
> ---
>  Documentation/networking/af_xdp.rst | 32 ++++++++++++++---------------
>  1 file changed, 16 insertions(+), 16 deletions(-)

Thanks for the cleanup Ilya.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
> index 2ccc5644cc98..42576880aa4a 100644
> --- a/Documentation/networking/af_xdp.rst
> +++ b/Documentation/networking/af_xdp.rst
> @@ -290,19 +290,19 @@ round-robin example of distributing packets is shown below:
>     #define MAX_SOCKS 16
>
>     struct {
> -        __uint(type, BPF_MAP_TYPE_XSKMAP);
> -        __uint(max_entries, MAX_SOCKS);
> -        __uint(key_size, sizeof(int));
> -        __uint(value_size, sizeof(int));
> +       __uint(type, BPF_MAP_TYPE_XSKMAP);
> +       __uint(max_entries, MAX_SOCKS);
> +       __uint(key_size, sizeof(int));
> +       __uint(value_size, sizeof(int));
>     } xsks_map SEC(".maps");
>
>     static unsigned int rr;
>
>     SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
>     {
> -       rr = (rr + 1) & (MAX_SOCKS - 1);
> +       rr = (rr + 1) & (MAX_SOCKS - 1);
>
> -       return bpf_redirect_map(&xsks_map, rr, XDP_DROP);
> +       return bpf_redirect_map(&xsks_map, rr, XDP_DROP);
>     }
>
>  Note, that since there is only a single set of FILL and COMPLETION
> @@ -379,7 +379,7 @@ would look like this for the TX path:
>  .. code-block:: c
>
>     if (xsk_ring_prod__needs_wakeup(&my_tx_ring))
> -      sendto(xsk_socket__fd(xsk_handle), NULL, 0, MSG_DONTWAIT, NULL, 0);
> +       sendto(xsk_socket__fd(xsk_handle), NULL, 0, MSG_DONTWAIT, NULL, 0);
>
>  I.e., only use the syscall if the flag is set.
>
> @@ -442,9 +442,9 @@ purposes. The supported statistics are shown below:
>  .. code-block:: c
>
>     struct xdp_statistics {
> -         __u64 rx_dropped; /* Dropped for reasons other than invalid desc */
> -         __u64 rx_invalid_descs; /* Dropped due to invalid descriptor */
> -         __u64 tx_invalid_descs; /* Dropped due to invalid descriptor */
> +       __u64 rx_dropped; /* Dropped for reasons other than invalid desc */
> +       __u64 rx_invalid_descs; /* Dropped due to invalid descriptor */
> +       __u64 tx_invalid_descs; /* Dropped due to invalid descriptor */
>     };
>
>  XDP_OPTIONS getsockopt
> @@ -483,15 +483,15 @@ like this:
>  .. code-block:: c
>
>      // struct xdp_rxtx_ring {
> -    //         __u32 *producer;
> -    //         __u32 *consumer;
> -    //         struct xdp_desc *desc;
> +    //     __u32 *producer;
> +    //     __u32 *consumer;
> +    //     struct xdp_desc *desc;
>      // };
>
>      // struct xdp_umem_ring {
> -    //         __u32 *producer;
> -    //         __u32 *consumer;
> -    //         __u64 *desc;
> +    //     __u32 *producer;
> +    //     __u32 *consumer;
> +    //     __u64 *desc;
>      // };
>
>      // typedef struct xdp_rxtx_ring RING;
> --
> 2.26.3
>
