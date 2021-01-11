Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DEE2F1B69
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 17:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389044AbhAKQte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 11:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731662AbhAKQte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 11:49:34 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4F6C061794;
        Mon, 11 Jan 2021 08:48:53 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id p187so255487iod.4;
        Mon, 11 Jan 2021 08:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=spVYhTS2xSe7X2/p6lgS2W3n4UcE/4EmWasD+b9iMd0=;
        b=JsIba6UIAPo/WE5OAM1gTrbYkJPv0+n7QInBqxWE3R79pZU1/6Eat1O3oRIkvTjMHY
         JyuRn5IAmKcv0INMKF3WCPFfdsbX2YR6CeghLVv+7hm6agcNYA9kZc3bqhka7bP2K90l
         94yO0nVprb0F04mkIG6XOicpEvYVMryRUAcvgyvwlRkJmHI+7W60Z1er6VuJMjeWchmW
         hAnPkZNxtXVdrZmZ0Gr9+4NOuxqImX6pOYS5gqlfc6gMbNcERzetMfXTnMzvFjI0cw04
         CWRp0gZbE0lK1LOKMhczgUnng3e6BQbqxeouin/7TZHONpXnEyAf4OL59SkK0CdE7Wjp
         r4sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=spVYhTS2xSe7X2/p6lgS2W3n4UcE/4EmWasD+b9iMd0=;
        b=Ja4PEH65zU4+rf+XVMarHHZiuYoef6HaRk1XBNdQI/vMQHC2p3KsqYzFjMrNpzsYU4
         Vdq7kXlGhx1YWwUAYqJB+i2dnKuAfGWejnF6gqj6SshYbIZcBUu67AtZ7qTAbtF7rIQH
         H6nffmhDFZeWKA3hcKaOExHaVXk4rViGeNq2va3/4uE2fJwU4hE/Q7tZCIZ55ETRG4Wx
         BgZ5wvVi9k0Fz5XBm3rOStmd/Bhe9zqmqwpnXvoJ5tq8Sbv5zmk7litpcnGJiUB92Euc
         cEcMMYYftFh4ujwQTK54j0pTalf5w+zZqOHegfZIHp2oOMyz+dUUZFlIhAhA9gIhUB48
         RQ5A==
X-Gm-Message-State: AOAM530vZlaBAwTu4kxoNOXVrTatGKSFBDUvnNj2J9FebHVMttUiixOG
        Y1afAAeUd0I8h64K/iKSeW47bSuseqbRk19unr0=
X-Google-Smtp-Source: ABdhPJw/6jk06SZrDW0UvAxTGDsLYGwXU6YlzaW0Y4AjE7YRgBm5E5mcdgUEtFFU/QK2s+U857QRLMan4j6JnWwCOSg=
X-Received: by 2002:a5d:9a82:: with SMTP id c2mr157246iom.38.1610383733021;
 Mon, 11 Jan 2021 08:48:53 -0800 (PST)
MIME-Version: 1.0
References: <d8dc3cd362915974426d8274bb8ac6970a2096bb.1610371323.git.lucien.xin@gmail.com>
In-Reply-To: <d8dc3cd362915974426d8274bb8ac6970a2096bb.1610371323.git.lucien.xin@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 11 Jan 2021 08:48:41 -0800
Message-ID: <CAKgT0UeEkqQjSU_t1wp3_k4pRYxM=FE-rTk2sBa-mdSwPnAstw@mail.gmail.com>
Subject: Re: [PATCHv2 net-next] ip_gre: remove CRC flag from dev features in gre_gso_segment
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 5:22 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> This patch is to let it always do CRC checksum in sctp_gso_segment()
> by removing CRC flag from the dev features in gre_gso_segment() for
> SCTP over GRE, just as it does in Commit 527beb8ef9c0 ("udp: support
> sctp over udp in skb_udp_tunnel_segment") for SCTP over UDP.
>
> It could set csum/csum_start in GSO CB properly in sctp_gso_segment()
> after that commit, so it would do checksum with gso_make_checksum()
> in gre_gso_segment(), and Commit 622e32b7d4a6 ("net: gre: recompute
> gre csum for sctp over gre tunnels") can be reverted now.
>
> Note that the current HWs like igb NIC can only handle the SCTP CRC
> when it's in the outer packet, not in the inner packet like in this
> case, so here it removes CRC flag from the dev features even when
> need_csum is false.

So the limitation in igb is not the hardware but the driver
configuration. When I had coded things up I put in a limitation on the
igb_tx_csum code that it would have to validate that the protocol we
are requesting an SCTP CRC offload since it is a different calculation
than a 1's complement checksum. Since igb doesn't support tunnels we
limited that check to the outer headers.

We could probably enable this for tunnels as long as the tunnel isn't
requesting an outer checksum offload from the driver.

> v1->v2:
>   - improve the changelog.
>   - fix "rev xmas tree" in varibles declaration.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/ipv4/gre_offload.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
>
> diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
> index e0a2465..a681306 100644
> --- a/net/ipv4/gre_offload.c
> +++ b/net/ipv4/gre_offload.c
> @@ -15,10 +15,10 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
>                                        netdev_features_t features)
>  {
>         int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
> -       bool need_csum, need_recompute_csum, gso_partial;
>         struct sk_buff *segs = ERR_PTR(-EINVAL);
>         u16 mac_offset = skb->mac_header;
>         __be16 protocol = skb->protocol;
> +       bool need_csum, gso_partial;
>         u16 mac_len = skb->mac_len;
>         int gre_offset, outer_hlen;
>
> @@ -41,10 +41,11 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
>         skb->protocol = skb->inner_protocol;
>
>         need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
> -       need_recompute_csum = skb->csum_not_inet;
>         skb->encap_hdr_csum = need_csum;
>
>         features &= skb->dev->hw_enc_features;
> +       /* CRC checksum can't be handled by HW when SCTP is the inner proto. */
> +       features &= ~NETIF_F_SCTP_CRC;
>
>         /* segment inner packet. */
>         segs = skb_mac_gso_segment(skb, features);

Do we have NICs that are advertising NETIF_S_SCTP_CRC as part of their
hw_enc_features and then not supporting it? Based on your comment
above it seems like you are masking this out because hardware is
advertising features it doesn't actually support. I'm just wondering
if that is the case or if this is something where this should be
cleared if need_csum is set since we only support one level of
checksum offload.

> @@ -99,15 +100,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
>                 }
>
>                 *(pcsum + 1) = 0;
> -               if (need_recompute_csum && !skb_is_gso(skb)) {
> -                       __wsum csum;
> -
> -                       csum = skb_checksum(skb, gre_offset,
> -                                           skb->len - gre_offset, 0);
> -                       *pcsum = csum_fold(csum);
> -               } else {
> -                       *pcsum = gso_make_checksum(skb, 0);
> -               }
> +               *pcsum = gso_make_checksum(skb, 0);
>         } while ((skb = skb->next));
>  out:
>         return segs;
> --
> 2.1.0
>
