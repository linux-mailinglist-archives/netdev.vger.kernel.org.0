Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43A73D128F
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240013AbhGUO4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239969AbhGUO4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 10:56:32 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE625C061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:37:08 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id y25so2763611ljy.13
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 08:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i7PLflitrAYc1ojvfYP6jnVUAWgG4SsQdyVSTkIdSQc=;
        b=iQDxk669PHPJ3JK0QPn1UuRoWl+P7D6lRGEfG2KuJlRDFoJFl5osPA1cxkLOVNHnt5
         CEUE4ZCxoaU7pfB2lv4TK++7glpEShMgjeuDjpENcjlbJPxbmhUgyWEp8Zgz25DpL1dQ
         3OCilTwpDx2a2CWgx9O9p5n733X3XpYu6hnD4VbD0qkewo+Zw1BzOFOmIpebvAA9IQux
         rJXXu4a3wWuyKnTsia0D0BoVq+pMEu6qGhKBqgkSkEXfzZv9F3oZmQ75xPvoPixfMBaE
         IbdU+qUwtbqJH8/Q2CtB9yjqRf34dHjj7zQW6W70kopkA5Wcd/pgQa/gyNUNKiCP89WP
         c6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i7PLflitrAYc1ojvfYP6jnVUAWgG4SsQdyVSTkIdSQc=;
        b=eyJ05oJPlFMNQkL7B/gATipYT2p2FQtvLxqXh6hKnUPJv5dDaG0HVv3lMYUMFItbR/
         7sDadNW+PsFv4BTG5ZYYr+BtwzgDoGwmd0ykGfXaElxzVd3Foku4SuAAPxmmZg1cZqoi
         VWzaP40LjXlpG4jnJYIJNdKWOoqKG2NEaoj8YUL5smY2MCk6p43SGFakQZenbbzr6cIB
         NsN/FHdy6MXWGFf3JoIpy6LIthpsl+1IwIQ9PwRFzJu7/tQr/+lsd0ABUdbW0aOvGfWB
         6c/G+EzhcakZpL/5tLrPNdCyLeYRVbe4yXdIJm+OGdX4DVnRylAt7igW5lRG2yAVNZKY
         PSpg==
X-Gm-Message-State: AOAM532NOMs7vw7FwWfUKBIn5aw+FYoiXMS9GZ+ijqEKCKiJbGhDNGc4
        Zc/IqZktFJxZ9Dgtv65J0Kh2HkBeM1vTEf+8VHV1Fw==
X-Google-Smtp-Source: ABdhPJyWrUg1KaeLBbfAdHN/o0TIqKf5tf+8Ci5WIgXV5rPeUKicvf5HnDjWpj8bQju2vF1/BBsabuL0fOkrcD6bBh4=
X-Received: by 2002:a05:651c:2ca:: with SMTP id f10mr31375708ljo.203.1626881826838;
 Wed, 21 Jul 2021 08:37:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210721151100.2042139-1-arnd@kernel.org>
In-Reply-To: <20210721151100.2042139-1-arnd@kernel.org>
From:   Bailey Forrest <bcf@google.com>
Date:   Wed, 21 Jul 2021 08:36:55 -0700
Message-ID: <CANH7hM7nLq9LthNi=D9qHsiS_eyhU8-CGjnXhsKYX9dqTaOmNw@mail.gmail.com>
Subject: Re: [PATCH] gve: DQO: avoid unused variable warnings
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Catherine Sullivan <csully@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Arnd Bergmann <arnd@arndb.de>, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the patch!

On Wed, Jul 21, 2021 at 8:11 AM Arnd Bergmann <arnd@kernel.org> wrote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The use of dma_unmap_addr()/dma_unmap_len() in the driver causes
> multiple warnings when these macros are defined as empty:
>
> drivers/net/ethernet/google/gve/gve_tx_dqo.c: In function 'gve_tx_add_skb_no_copy_dqo':
> drivers/net/ethernet/google/gve/gve_tx_dqo.c:494:40: error: unused variable 'buf' [-Werror=unused-variable]
>   494 |                 struct gve_tx_dma_buf *buf =
>
> As it turns out, there are three copies of the same loop,
> and one of them is already split out into a separate function.
>
> Fix the warning in this one place, and change the other two
> to call it instead of open-coding the same loop.
>
> Fixes: a57e5de476be ("gve: DQO: Add TX path")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> The warning is present in both 5.14-rc2 and net-next as of today
> ---
>  drivers/net/ethernet/google/gve/gve_tx_dqo.c | 92 ++++++++------------
>  1 file changed, 35 insertions(+), 57 deletions(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
> index 05ddb6a75c38..fffa882db493 100644
> --- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
> +++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
> @@ -73,6 +73,26 @@ gve_free_pending_packet(struct gve_tx_ring *tx,
>         }
>  }
>
> +static void gve_unmap_packet(struct device *dev,
> +                            struct gve_tx_pending_packet_dqo *pending_packet)
> +{
> +       dma_addr_t addr;
> +       size_t len;
> +       int i;
> +
> +       /* SKB linear portion is guaranteed to be mapped */
> +       addr = dma_unmap_addr(&pending_packet->bufs[0], dma);
> +       len = dma_unmap_len(&pending_packet->bufs[0], len);
> +       dma_unmap_single(dev, addr, len, DMA_TO_DEVICE);

"SKB linear portion is guaranteed to be mapped" is only true if
gve_tx_add_skb_no_copy_dqo completed successfully.

This optimization is important for the success path because otherwise
there would be a per-packet branch misprediction, which I found to
have a large performance impact.

A solution which should address this would be something like:

+static void gve_unmap_packet(struct device *dev,
+     struct gve_tx_pending_packet_dqo *pending_packet
+     bool always_unmap_first)
+{
+ dma_addr_t addr;
+ size_t len;
+ int i;
+
+ if (always_unmap_first || pending_packet->num_bufs > 0) {
+  addr = dma_unmap_addr(&pending_packet->bufs[0], dma);
+  len = dma_unmap_len(&pending_packet->bufs[0], len);
+  dma_unmap_single(dev, addr, len, DMA_TO_DEVICE);
+ }
+
+ for (i = 1; i < pending_packet->num_bufs; i++) {
+  addr = dma_unmap_addr(&pending_packet->bufs[i], dma);
+  len = dma_unmap_len(&pending_packet->bufs[i], len);
+  dma_unmap_page(dev, addr, len, DMA_TO_DEVICE);
+ }
+ pending_packet->num_bufs = 0;
+}

(Sorry my email client keeps turning tabs into spaces...)

By doing this, we can rely on the compiler to optimize away the extra
branch in cases we know the first buffer will be mapped.

>
> +static inline void gve_tx_dma_buf_set(struct gve_tx_dma_buf *buf,
> +                                     dma_addr_t addr, size_t len)
> +{
> +       dma_unmap_len_set(buf, len, len);
> +       dma_unmap_addr_set(buf, dma, addr);
> +}

checkpatch.pl will complain about `inline` in a C file.

However, I would prefer to just not introduce this helper because it
introduces indirection for the reader and the risk of passing the
arguments in the wrong order. Don't have a strong opinion here though.
