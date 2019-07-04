Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 633B85FE36
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 23:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfGDVfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 17:35:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32832 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbfGDVfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 17:35:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id m4so3363638pgk.0
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 14:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=14wy448mTIhCSVoxrWExq+63/W3QV9gu4sEyMYuS70s=;
        b=xYce24T6cWUSmXXqBbV62JYJy/dpduEyCl4+RDPkXaOFNAmxLG+9utYvQnfcoKaa4k
         H/RxbLCuiyEDx5hWZdF91rIddaUpHq9yFikfGiAo+097OLAzS9AhwxOf3LsSkyk3oWAA
         WzrEnAne14hDKuvC5PWFj08P1ACG0GP2ApGSprykLbC2k3DcStgHg3s7MkX5soZDozHH
         Vn23WulBztTW0qWg3ZAhUh5YOymALmRtgZSb+GATwukWG5fOibNL4Bk5WdnVdF0qqvc9
         Y0j/DwsU9f9os6pMvhJOGWayin4+vcrln0tvEA4iEp4WlxnFU7cETwLloZaB5IgEu7+/
         DuAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=14wy448mTIhCSVoxrWExq+63/W3QV9gu4sEyMYuS70s=;
        b=jJFTs3rbsBelVgp3A0W/YXCwlv0XCKnkZc0b6XEz9j7GRfp5y1ZOn6dxHcbEg0wAtH
         mt+Uj4u/AnXC+n9WOpq/C9soymXRcgY4wyYlsXCiHlnFbRuHu5yK2r2F/eze9Cl5eiFP
         221G6qUaxj2zTlrgY4J6IzlZDbxiFEzCD9CrutH+hIf/6iTmfCokFFrof2dZaaKXhAdA
         9K587FBE7tyeYxifA3aO3FqTzqpFUHWuWoSm8o1POUuCg2+d8EswqXagN2stRzlNRR1B
         Hmzb5ROgUanVKEQMcLrgkOrMm9FvxLFo0MVSQQYADJX06dq6ueLrjHXM4AlXa1AJ8mFD
         EhoA==
X-Gm-Message-State: APjAAAU9GHPEzNuQuaWiJ1ap3OX8bsSfuuv9zEG3kp0ivfz8k/u95VPJ
        QC3CrhSL3obY9tLXNodBzBwfHQ==
X-Google-Smtp-Source: APXvYqzcn7zrgKhamWpg8FATHTtwzyoQVaGnsrbRg/v+iVWsDmBieRVHT/mYMGyRwovAlDR28B9KaQ==
X-Received: by 2002:a65:654f:: with SMTP id a15mr568850pgw.73.1562276124387;
        Thu, 04 Jul 2019 14:35:24 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id x26sm7103677pfq.69.2019.07.04.14.35.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 14:35:24 -0700 (PDT)
Date:   Thu, 4 Jul 2019 14:35:21 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>
Subject: Re: [net-next 14/14] net/mlx5e: Add kTLS TX HW offload support
Message-ID: <20190704143521.2d025038@cakuba.netronome.com>
In-Reply-To: <20190704181235.8966-15-saeedm@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
        <20190704181235.8966-15-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Jul 2019 18:16:15 +0000, Saeed Mahameed wrote:
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
> +		goto out;

If a frame for a different device leaked through the stack, we need to
fix the stack.  Also you should drop the frame in this case, the device
will no encrypt it.

> +	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);
> +
> +	if (unlikely(mlx5e_ktls_tx_offload_test_and_clear_pending(priv_tx))) {
> +		mlx5e_ktls_tx_post_param_wqes(sq, priv_tx, false, false);
> +		*wqe = mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
> +		stats->ktls_ctx++;
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
> +	stats->ktls_enc_packets += skb_is_gso(skb) ? skb_shinfo(skb)->gso_segs : 1;
> +	stats->ktls_enc_bytes   += datalen;
> +
> +out:
> +	return skb;
> +}

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> index 483d321d2151..6854f132d505 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
> @@ -50,6 +50,15 @@ static const struct counter_desc sw_stats_desc[] = {
>  #ifdef CONFIG_MLX5_EN_TLS
>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_ooo) },
>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_tls_resync_bytes) },
> +
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_drop_no_sync_data) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_drop_bypass_req) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_dump_bytes) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ooo_dump_packets) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_enc_packets) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_enc_bytes) },
> +	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_ktls_ctx) },
>  #endif
>  
>  	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_lro_packets) },
> @@ -218,6 +227,16 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_priv *priv)
>  #ifdef CONFIG_MLX5_EN_TLS
>  			s->tx_tls_ooo		+= sq_stats->tls_ooo;
>  			s->tx_tls_resync_bytes	+= sq_stats->tls_resync_bytes;
> +
> +			s->tx_ktls_enc_packets           += sq_stats->ktls_enc_packets;
> +			s->tx_ktls_enc_bytes             += sq_stats->ktls_enc_bytes;
> +			s->tx_ktls_ooo                   += sq_stats->ktls_ooo;
> +			s->tx_ktls_ooo_drop_no_sync_data +=
> +				sq_stats->ktls_ooo_drop_no_sync_data;
> +			s->tx_ktls_ooo_drop_bypass_req   += sq_stats->ktls_ooo_drop_bypass_req;
> +			s->tx_ktls_ooo_dump_bytes        += sq_stats->ktls_ooo_dump_bytes;
> +			s->tx_ktls_ooo_dump_packets      += sq_stats->ktls_ooo_dump_packets;
> +			s->tx_ktls_ctx                   += sq_stats->ktls_ctx;
>  #endif
>  			s->tx_cqes		+= sq_stats->cqes;
>  		}
> @@ -1238,6 +1257,16 @@ static const struct counter_desc sq_stats_desc[] = {
>  	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, csum_partial_inner) },
>  	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, added_vlan_packets) },
>  	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, nop) },
> +#ifdef CONFIG_MLX5_EN_TLS
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_ooo) },
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_ooo_drop_no_sync_data) },
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_ooo_drop_bypass_req) },
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_ooo_dump_bytes) },
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_ooo_dump_packets) },
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_enc_packets) },
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_enc_bytes) },
> +	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, ktls_ctx) },
> +#endif
>  	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, csum_none) },
>  	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, stopped) },
>  	{ MLX5E_DECLARE_TX_STAT(struct mlx5e_sq_stats, dropped) },

For the stats as discussed please use common names, and preferably
add yours to the doc too, so we have them documented.  Unless the 
stat seems very specific to your implementation, perhaps.
