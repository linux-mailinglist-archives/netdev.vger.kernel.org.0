Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4294D60C2D
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 22:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbfGEUR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 16:17:28 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33770 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfGEUR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 16:17:28 -0400
Received: by mail-qt1-f194.google.com with SMTP id h24so12393763qto.0
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 13:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=OVvz6MF5gI6S+r2Yr5rm2cNik2RQCHYY+DN+IbnRcvo=;
        b=X8uutzhXX5o7R2Im+mXo8g1o+Jn7jgBKD0Q33za68OlbFUnXGQlXimsfXUTWc2OlZC
         LB0d9QrjMlyjsfd1uo5x6UjqKA1k5zaQw9h7t6Oo7SZLn358wrrMfEaK8oiMHaW68MV2
         pxeLqGkk7wuBhb91Ne69J6G5QVGbgG3o5A7pZKTJC74RYkuVrBHjcK4xpTt2gDRxbn7b
         5QZ3wUVQG3reo5LRnDxLcw7wah1r6GOiiRQ3BnS4AfWVZdQ+vlc9np9DeuBsUzkW+tLH
         r0nikRydD65FOdtR9GPD5/1K9Kz3FkTP9RmUCLTcA6X3MR4pO1KcaljZJEzHOeX5vC9d
         WpwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=OVvz6MF5gI6S+r2Yr5rm2cNik2RQCHYY+DN+IbnRcvo=;
        b=cK/wM2DPvWrCH1vuZmHtCI2toaxho/D9gIsMAMufgdZ6IBMINDIBC+jzNSsLpPZKtC
         s4lUAlVb3bKQorWxKXwxw7sVucPVMWrK2Bu1RRGh3sAoRmNecJsNaU2cTHSc0pYlBRQ9
         m1RrILWKru3+vSxjNmzZifYT9o/2B7bPaMv9iOWwc1QaCU2xj1ej8yJI2dSo4iR14WKI
         a+gjLG4jJFMuanF97JbJzQNy9dHiuOBK/gn8aWc22uputtAR60/3pif4l3qm91AyY82I
         lpk8NclMcLaj5I8Rej8JWaCNqou3puypjmLspiZid7txLLeoiJQ4815JV2UmOVkfh9cE
         V48Q==
X-Gm-Message-State: APjAAAW1tgbr/oqjEvHGwrm2mxbyNzjEHkJrQQczreLpi5j36AdotYJ9
        1ayxZYF9f55kDRrRo0xGmMZG8w==
X-Google-Smtp-Source: APXvYqzkQ/ZnGf1N1jq8niJ+f9H6uiyZLxra4vxfH33f5yhakuZkoJdHK8mcSURBuLl6F7hrwCg3mg==
X-Received: by 2002:ac8:2e5d:: with SMTP id s29mr4188456qta.70.1562357846987;
        Fri, 05 Jul 2019 13:17:26 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id j6sm3947790qkf.119.2019.07.05.13.17.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 05 Jul 2019 13:17:26 -0700 (PDT)
Date:   Fri, 5 Jul 2019 13:17:22 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>, moshe@mellanox.com
Subject: Re: [PATCH net-next 12/12] net/mlx5e: Add kTLS TX HW offload
 support
Message-ID: <20190705131722.464a1628@cakuba.netronome.com>
In-Reply-To: <1562340622-4423-13-git-send-email-tariqt@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
        <1562340622-4423-13-git-send-email-tariqt@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  5 Jul 2019 18:30:22 +0300, Tariq Toukan wrote:
> Add support for transmit side kernel-TLS acceleration.
> Offload the crypto encryption to HW.
> 
> Per TLS connection:
> - Use a separate TIS to maintain the HW context.
> - Use a separate encryption key.
> - Maintain static and progress HW contexts by posting the proper
>   WQEs at creation time, or upon resync.
> - Use a special DUMP opcode to replay the previous frags and sync
>   the HW context.
> 
> To make sure the SQ is able to serve an xmit request, increase
> SQ stop room to cover:
> - static params WQE,
> - progress params WQE, and
> - resync DUMP per frag.
> 
> Currently supporting TLS 1.2, and key size 128bit.
> 
> Tested over SimX simulator.
> 
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>

> +struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_device *netdev,
> +					 struct mlx5e_txqsq *sq,
> +					 struct sk_buff *skb,
> +					 struct mlx5e_tx_wqe **wqe, u16 *pi)
> +{
> +	struct mlx5e_ktls_offload_context_tx *priv_tx;
> +	struct mlx5e_sq_stats *stats = sq->stats;
> +	struct mlx5_wqe_ctrl_seg *cseg;
> +	struct tls_context *tls_ctx;
> +	int datalen;
> +	u32 seq;
> +
> +	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
> +		goto out;
> +
> +	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
> +	if (!datalen)
> +		goto out;
> +
> +	tls_ctx = tls_get_ctx(skb->sk);
> +	if (unlikely(tls_ctx->netdev != netdev))

This really shouldn't happen, could you please add a WARN_ON_ONCE here?

> +		goto err_out;
> +
> +	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
> +
> +	if (unlikely(mlx5e_ktls_tx_offload_test_and_clear_pending(priv_tx))) {
> +		mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, false, false);
> +		*wqe = mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
> +		stats->tls_ctx++;
> +	}
> +
> +	seq = ntohl(tcp_hdr(skb)->seq);
> +	if (unlikely(priv_tx->expected_seq != seq)) {
> +		skb = mlx5e_ktls_tx_handle_ooo(priv_tx, sq, skb, seq);
> +		if (unlikely(!skb))
> +			goto out;
> +		*wqe = mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
> +	}
> +
> +	priv_tx->expected_seq = seq + datalen;
> +
> +	cseg = &(*wqe)->ctrl;
> +	cseg->imm = cpu_to_be32(priv_tx->tisn);
> +
> +	stats->tls_encrypted_packets += skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1;
> +	stats->tls_encrypted_bytes   += datalen;
> +
> +out:
> +	return skb;
> +
> +err_out:
> +	dev_kfree_skb_any(skb);
> +	return NULL;
> +}

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> index 5f540db47cc9..539b4d3656da 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> @@ -48,8 +48,15 @@
>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_nop) },
>  
>  #ifdef CONFIG_MLX5_EN_TLS
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_encrypted_packets) },

As mentioned in the other email could you change this in docs and
the nfp driver (just change the ethtool string)?

> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_encrypted_bytes) },

This one looks like it'd be worth adding to the general doc.
Could you please make it clear this only counts L4 payload data, 
not the full frames?  Also perhaps worth mentioning for the packet
counter that it doesn't count pure acks and other frames with no
playload.

> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_ctx) },

And this one.

>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_ooo) },
>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_resync_bytes) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_drop_no_sync_data) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_drop_bypass_req) },

And this one, too.

> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_dump_packets) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_dump_bytes) },
>  #endif
>  
>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_packets) },
> @@ -271,8 +278,15 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_priv *priv)
>  			s->tx_csum_none		+= sq_stats->csum_none;
>  			s->tx_csum_partial	+= sq_stats->csum_partial;
>  #ifdef CONFIG_MLX5_EN_TLS
> -			s->tx_tls_ooo		+= sq_stats->tls_ooo;
> -			s->tx_tls_resync_bytes	+= sq_stats->tls_resync_bytes;
> +			s->tx_tls_encrypted_packets += sq_stats->tls_encrypted_packets;
> +			s->tx_tls_encrypted_bytes   += sq_stats->tls_encrypted_bytes;
> +			s->tx_tls_ctx               += sq_stats->tls_ctx;
> +			s->tx_tls_ooo               += sq_stats->tls_ooo;
> +			s->tx_tls_resync_bytes      += sq_stats->tls_resync_bytes;
> +			s->tx_tls_drop_no_sync_data += sq_stats->tls_drop_no_sync_data;
> +			s->tx_tls_drop_bypass_req   += sq_stats->tls_drop_bypass_req;
> +			s->tx_tls_dump_bytes        += sq_stats->tls_dump_bytes;
> +			s->tx_tls_dump_packets      += sq_stats->tls_dump_packets;
>  #endif
>  			s->tx_cqes		+= sq_stats->cqes;
>  		}
> @@ -1293,6 +1307,16 @@ static int mlx5e_grp_tls_fill_stats(struct mlx5e_priv *priv, u64 *data, int idx)
>  	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, csum_partial_inner) },
>  	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, added_vlan_packets) },
>  	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, nop) },
> +#ifdef CONFIG_MLX5_EN_TLS
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_packets) },
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_encrypted_bytes) },
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_ctx) },
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_ooo) },
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_drop_no_sync_data) },
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_drop_bypass_req) },
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_dump_packets) },
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, tls_dump_bytes) },
> +#endif
>  	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, csum_none) },
>  	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, stopped) },
>  	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, dropped) },
