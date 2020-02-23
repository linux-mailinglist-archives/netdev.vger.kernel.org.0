Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4DCC16956C
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgBWCl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:41:57 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41683 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgBWCl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 21:41:57 -0500
Received: by mail-yw1-f67.google.com with SMTP id l22so3566815ywc.8
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 18:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=syMqkfbz/HRgW04s+5hDMmMOFh3aus7JJ14qY06TaQ0=;
        b=JfgvVY0QUFBqjjbaDwDXw9z3n/Ddvskn2xtYW3LFSTiO4nAmUT7Rv4wIMDVIDrfUNS
         QOOV+jQmGjmpCa39B5mAB9rBsMjwm50PpOJJWcZsq9GbO++YL93uxFYVSVR/mIjuGh3T
         qPWTP3mnu36CIW4xVsnVEAnQEFxYWwQOFt+ZJLgHfnb6rmFc0uhUnJH0XYlhZ0oXvTq4
         bgZBuAOwM8t8Lrbp2XKV/a1xFasOpAY7y25JkM5aACEvb8GhWasNzoqphfxusyWZrDcC
         WUZz28O8zH7fR4kEt+WAjgN0R3TMDBEMt1zqjFQ8BJ8+3m6syGPdfPGAW3+edg5A4qtz
         e2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=syMqkfbz/HRgW04s+5hDMmMOFh3aus7JJ14qY06TaQ0=;
        b=S06dxeSD7PXhvTaur8+X44lCaB+ajLLul8UqqmS3lIV/TrnUhkr8ad897OCJw4aC5i
         aFtVa4daZgGOP3v56fuMVhcPH3rUbADXqljwBsrMg4dSns5zierDenNpOcIhdO186wIa
         Nj/RYidPAz/vAjqN00I6tlzTfnM5n4yBNkFy6huG7C39MmjNSNQB+eLRJU9n0gfr1603
         cXPFeAbXtz5HaFFHhpPPFE5fbbme0VfekuCoNsz37qv8fG1X4Ojq2R1uheq25PH3aMoW
         aoHDi1HP0XO4WADLNOEb3V26ViNUd90yhXY+Zg0H+AcGBlKdZWiEtoruHONJIoEdv9wA
         3KTw==
X-Gm-Message-State: APjAAAXgBI2Oy9bQ3Z68adv+ulZIJGQubki7gDRc0Smo4YAX0bCayZcB
        u3tpd0yR2vgpMioHuuqvCWtE0+cX
X-Google-Smtp-Source: APXvYqxJUbb1au0Ogie6uKzbat7dYJB4QopNvnf0/tmbceKRmUdDANuU9ecVJ+oNG6HlnulxKswJ+Q==
X-Received: by 2002:a0d:d404:: with SMTP id w4mr34763331ywd.366.1582425713619;
        Sat, 22 Feb 2020 18:41:53 -0800 (PST)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id g65sm3275444ywd.109.2020.02.22.18.41.52
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2020 18:41:52 -0800 (PST)
Received: by mail-yb1-f171.google.com with SMTP id f130so2913440ybc.7
        for <netdev@vger.kernel.org>; Sat, 22 Feb 2020 18:41:52 -0800 (PST)
X-Received: by 2002:a25:cc8a:: with SMTP id l132mr1750782ybf.178.1582425711871;
 Sat, 22 Feb 2020 18:41:51 -0800 (PST)
MIME-Version: 1.0
References: <CA+FuTSeYGYr3Umij+Mezk9CUcaxYwqEe5sPSuXF8jPE2yMFJAw@mail.gmail.com>
 <1582262039-25359-1-git-send-email-kyk.segfault@gmail.com>
In-Reply-To: <1582262039-25359-1-git-send-email-kyk.segfault@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 22 Feb 2020 20:41:12 -0600
X-Gmail-Original-Message-ID: <CA+FuTSe8VKTMO9CA2F-oNvZLbtfMqhyf+ZjruXbqz_WTrj-F1A@mail.gmail.com>
Message-ID: <CA+FuTSe8VKTMO9CA2F-oNvZLbtfMqhyf+ZjruXbqz_WTrj-F1A@mail.gmail.com>
Subject: Re: [PATCH] net: Make skb_segment not to compute checksum if network
 controller supports checksumming
To:     Yadu Kishore <kyk.segfault@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 11:14 PM Yadu Kishore <kyk.segfault@gmail.com> wrote:
>
> Problem:
> TCP checksum in the output path is not being offloaded during GSO
> in the following case:
> The network driver does not support scatter-gather but supports
> checksum offload with NETIF_F_HW_CSUM.
>
> Cause:
> skb_segment calls skb_copy_and_csum_bits if the network driver
> does not announce NETIF_F_SG. It does not check if the driver
> supports NETIF_F_HW_CSUM.
> So for devices which might want to offload checksum but do not support SG
> there is currently no way to do so if GSO is enabled.
>
> Solution:
> In skb_segment check if the network controller does checksum and if so
> call skb_copy_bits instead of skb_copy_and_csum_bits.
>
> Testing:
> Without the patch, ran iperf TCP traffic with NETIF_F_HW_CSUM enabled
> in the network driver. Observed the TCP checksum offload is not happening
> since the skbs received by the driver in the output path have
> skb->ip_summed set to CHECKSUM_NONE.
>
> With the patch ran iperf TCP traffic and observed that TCP checksum
> is being offloaded with skb->ip_summed set to CHECKSUM_PARTIAL.

Did you measure a cycle efficiency improvement? As discussed in the
referred email thread, the kernel uses checksum_and_copy because it is
generally not significantly more expensive than copy alone.

skb_segment already is a very complex function. New code needs to
offer a tangible benefit.

> Also tested with the patch by disabling NETIF_F_HW_CSUM in the driver
> to cover the newly introduced if-else code path in skb_segment.
>
> In-Reply-To: CABGOaVTY6BrzJTYEtVXwawzP7-D8sb1KASDWFk15v0QFaJVbUg@mail.gmail.com

This does not seem to be a commonly used tag. And indeed differs from
the actual In-Reply-To in the email headers. Perhaps

Link: https://lore.kernel.org/netdev/CABGOaVTY6BrzJTYEtVXwawzP7-D8sb1KASDWFk15v0QFaJVbUg@mail.gmail.com/

> Signed-off-by: Yadu Kishore <kyk.segfault@gmail.com>
> ---
>  net/core/skbuff.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 1365a55..82a5b53 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3926,14 +3926,22 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
>                         goto perform_csum_check;
>
>                 if (!sg) {
> -                       if (!nskb->remcsum_offload)
> -                               nskb->ip_summed = CHECKSUM_NONE;
> -                       SKB_GSO_CB(nskb)->csum =
> -                               skb_copy_and_csum_bits(head_skb, offset,
> -                                                      skb_put(nskb, len),
> -                                                      len, 0);
> -                       SKB_GSO_CB(nskb)->csum_start =
> -                               skb_headroom(nskb) + doffset;
> +                       if (!csum) {
> +                               if (!nskb->remcsum_offload)
> +                                       nskb->ip_summed = CHECKSUM_NONE;
> +                               SKB_GSO_CB(nskb)->csum =
> +                                       skb_copy_and_csum_bits(head_skb, offset,
> +                                                              skb_put(nskb,
> +                                                                      len),
> +                                                              len, 0);
> +                               SKB_GSO_CB(nskb)->csum_start =
> +                                       skb_headroom(nskb) + doffset;
> +                       } else {
> +                               nskb->ip_summed = CHECKSUM_PARTIAL;

Is this not already handled by __copy_skb_header above? If ip_summed
has to be initialized, so have csum_start and csum_offset. That call
should have initialized all three.



> +                               skb_copy_bits(head_skb, offset,
> +                                             skb_put(nskb, len),
> +                                             len);
> +                       }
>                         continue;
>                 }
>
> --
> 2.7.4
>
