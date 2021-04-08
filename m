Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78561358B7C
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 19:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232574AbhDHRhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 13:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232374AbhDHRhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 13:37:09 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44534C061760;
        Thu,  8 Apr 2021 10:36:58 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id w70so3053793oie.0;
        Thu, 08 Apr 2021 10:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9A7WE4oNJYMOtIeZ4f1kRgh1llUM0leZ6aBbZlOQsEY=;
        b=qlHnLwUvHXlaPTOE5gLf2vh569G7Ws5cqIyuSqc8hW2Ixy3lsQNhGWCqE0dSr95qUW
         4BUV6LRdrAJCLQ2HvbD4vQQbFn264j2Y7+ZXo3EWj5T3IOTTfwl2Uja/cAqkZKD3l/NT
         f250f9u6+dKGLFqvG0ZegZWxCV+86FujawYB0UDaUoATUVQr6dzvMs4CLuc+ZnYnsFG/
         wHrKzpwt+gd8AicVU099/PA0rPxZb4WnH05LUUlAGxX7ActL3tX59xip+D4i6+SZIhV6
         xO64OXJ+gNUQ49bCqFZjqHIfWKpziKhJHPVMDwCCzuicSDd8SNWEEhN6Sg7Z+NH2fMtS
         lOUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9A7WE4oNJYMOtIeZ4f1kRgh1llUM0leZ6aBbZlOQsEY=;
        b=lcoPfoOp5MHA+ydpdoGctN5yi6qA6EE5+EtWIVZiTBdAJYEc+vQK2pbuqepYTV/kWT
         NQN6crpZmFhhuwvSrC05f0GchQjABpxryGvc/rfYzI8iUw0cbkkBSVss+0fTUWd9OTE4
         1nov/Dcbujk8I4e6glTKTltazIP/jlKZpV8CtC0zO8+935kSVyehOp33GezHaerv1ZYE
         VHAYwEkMehH4955LBBAzuAOc0VW8eFBU+sB/3LTJK+KsIUUlVsViYXrAkyqd5Js2QAMM
         2OFGw6Ib9uBQkSpFMXKE9MHSq2mhaeSERjADH17S0F8DGyhoZCOMP7qBifQxwOhvUyIR
         SaKQ==
X-Gm-Message-State: AOAM531xRMmJfr+aizqSfnhqk6ypRjoslZwauOJe6DUqo0xyj3bky6ZE
        Dip9GDX9GELjSM6rVngMnFPrXOLApew5fmxpPJa5yaLzHA==
X-Google-Smtp-Source: ABdhPJxTVtVpRXLoBvJcXq+Xtif9ClFSbu6H0JvFQFlIABCgnWYdOPXu0bOqo9Ks9ZmjapvPDC4t0VhDdkSlFGqpmkI=
X-Received: by 2002:aca:fc41:: with SMTP id a62mr7102824oii.92.1617903417601;
 Thu, 08 Apr 2021 10:36:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210408172353.21143-1-TheSven73@gmail.com>
In-Reply-To: <20210408172353.21143-1-TheSven73@gmail.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Thu, 8 Apr 2021 12:36:45 -0500
Message-ID: <CAFSKS=O4Yp6gknSyo1TtTO3KJ+FwC6wOAfNkbBaNtL0RLGGsxw@mail.gmail.com>
Subject: Re: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not
 just 2"
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 8, 2021 at 12:23 PM Sven Van Asbroeck <thesven73@gmail.com> wrote:
>
> From: Sven Van Asbroeck <thesven73@gmail.com>
>
> This reverts commit 3e21a10fdea3c2e4e4d1b72cb9d720256461af40.
>
> The reverted patch completely breaks all network connectivity on the
> lan7430. tcpdump indicates missing bytes when receiving ping
> packets from an external host:

Can you explain the difference in behavior with what I was observing
on the LAN7431? I'll retest but if this is reverted I'm going to start
seeing 2 extra bytes on the end of frames and it's going to break DSA
with the LAN7431 again.

>
> host$ ping $lan7430_ip
> lan7430$ tcpdump -v
> IP truncated-ip - 2 bytes missing! (tos 0x0, ttl 64, id 21715,
>     offset 0, flags [DF], proto ICMP (1), length 84)
>
> Fixes: 3e21a10fdea3 ("lan743x: trim all 4 bytes of the FCS; not just 2")
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> ---
>
> To: Bryan Whitehead <bryan.whitehead@microchip.com>
> To: "David S. Miller" <davem@davemloft.net>
> To: Jakub Kicinski <kuba@kernel.org>
> To: George McCollister <george.mccollister@gmail.com>
> Cc: UNGLinuxDriver@microchip.com
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
>  drivers/net/ethernet/microchip/lan743x_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index 1c3e204d727c..dbdfabff3b00 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -2040,7 +2040,7 @@ lan743x_rx_trim_skb(struct sk_buff *skb, int frame_length)
>                 dev_kfree_skb_irq(skb);
>                 return NULL;
>         }
> -       frame_length = max_t(int, 0, frame_length - RX_HEAD_PADDING - 4);
> +       frame_length = max_t(int, 0, frame_length - RX_HEAD_PADDING - 2);
>         if (skb->len > frame_length) {
>                 skb->tail -= skb->len - frame_length;
>                 skb->len = frame_length;
> --
> 2.17.1
>

Regards,
George
