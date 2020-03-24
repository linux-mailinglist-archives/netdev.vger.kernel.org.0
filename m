Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4403F1912D6
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgCXOVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:21:45 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32892 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727925AbgCXOVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:21:44 -0400
Received: by mail-pl1-f195.google.com with SMTP id g18so7456355plq.0
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 07:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4TZK2L4aIKyMYik6GmeTruJZ6BCVrcqgyH6kl4XGyAM=;
        b=pd66TdUKobysBFRUfqGFWGQHnTw5catPJ9x0XXiINDvI4WusKro+CcSUzbmwPHKhR2
         7itA9MH37I1nPCGQmtYgbUdjX26CBwwY46jP8we+nl6MSe9d6LUjPrALRM6AxJdFE+v0
         nptx8+wuaSfDr30EaPKHPoQG+AiKNreFrjIFJQ8X+jCklYLrqnvLnf4KkUEUCvsr99FU
         P8N4uMiz6Tm4Awbs/7JLLXdMb4AcjBhf3CJpB1MlYl3zvUWmIr4kgXRNeSPlEZ2uTszB
         taoHM2WgNEBJoR0JSR3KkLtB2ZOVWGiXsoQQEK2J90lz60CKjQfvnastWCOW+cnP4PDb
         soSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4TZK2L4aIKyMYik6GmeTruJZ6BCVrcqgyH6kl4XGyAM=;
        b=X/5AtCF8nYFfPYnTIXvxLUf7Vw33U0nm524SUmlJxOxoW+ZyJkRB5Qn7uoRU618djp
         DfA8y4s8+NDf9Fc7h+qbP7x3JS3s4SgPld5cOAmb3DsxtyJNTgp+8yA3qeetf+wMnFa9
         5/HtPxiXVYBVYCkgh1oZgQvaLLEjsHb1QCZjfQf5UgrfeA3uuMcLWujEeFrLTJqt3FFE
         kxkECX4WC0S380o6PxC4mSatzuyNJPnwN95WLWzuoWeuIHNngwrFL3zmn/h/hjWycSDK
         /SfFVFzWa3fyXFdaWfpkB/p/7tnyME1s6EsCMKS7bRjokJ2RobW016BVUcQVSOIWItxI
         QPzw==
X-Gm-Message-State: ANhLgQ3njXG//V6GRb6XiUIiXBh4f4Sadgvxofv7HXsUtl5IgsyNEYGQ
        9FJpe6LH8IXG3izY/xMyLAc=
X-Google-Smtp-Source: ADFU+vvTqaF53GWX7XMaPSRQZHRbrxNK83wzhqsapaT3eLLCLwrIiRw6kg5XJw8T9BvPhMOy8Olkfw==
X-Received: by 2002:a17:90b:4c84:: with SMTP id my4mr5689815pjb.3.1585059703649;
        Tue, 24 Mar 2020 07:21:43 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id v26sm3192220pfn.51.2020.03.24.07.21.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 07:21:43 -0700 (PDT)
Subject: Re: [PATCH net-next 4/5] veth: introduce more xdp counters
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
References: <cover.1584635611.git.lorenzo@kernel.org>
 <0763c17646523acb4dc15aaec01decb4efe11eac.1584635611.git.lorenzo@kernel.org>
 <a3555c02-6cb1-c40c-65bb-12378439b12f@gmail.com>
 <20200320133737.GA2329672@lore-desk-wlan>
 <04ca75e8-1291-4f25-3ad4-18ca5d6c6ddb@gmail.com>
 <20200321143013.GA3251815@lore-desk-wlan>
 <d8ccb8c7-0501-dc88-d2b2-ca594df885cb@gmail.com>
 <20200323173113.GA300262@lore-desk-wlan>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <075a675c-a2c4-7189-9339-c71d53421855@gmail.com>
Date:   Tue, 24 Mar 2020 23:21:39 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200323173113.GA300262@lore-desk-wlan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/03/24 2:31, Lorenzo Bianconi wrote:
>> On 2020/03/21 23:30, Lorenzo Bianconi wrote:
>>>> On 2020/03/20 22:37, Lorenzo Bianconi wrote:
>>>>>> On 2020/03/20 1:41, Lorenzo Bianconi wrote:
> 
> [...]
> 
>> As veth_xdp_xmit really does not use tx queue but select peer rxq directly,
>> per_cpu sounds more appropriate than per-queue.
>> One concern is consistency. Per-queue rx stats and per-cpu tx stats (or only
>> sum of them?) looks inconsistent.
>> One alternative way is to change the queue selection login in veth_xdp_xmit
>> and select txq instead of rxq. Then select peer rxq from txq, like
>> veth_xmit. Accounting per queue tx stats is possible only when we can
>> determine which txq is used.
>>
>> Something like this:
>>
>> static int veth_select_txq(struct net_device *dev)
>> {
>> 	return smp_processor_id() % dev->real_num_tx_queues;
>> }
>>
>> static int veth_xdp_xmit(struct net_device *dev, int n,
>> 			 struct xdp_frame **frames, u32 flags)
>> {
>> 	...
>> 	txq = veth_select_txq(dev);
>> 	rcv_rxq = txq; // 1-to-1 mapping from txq to peer rxq
>> 	// Note: when XDP is enabled on rcv, this condition is always false
>> 	if (rcv_rxq >= rcv->real_num_rx_queues)
>> 		return -ENXIO;
>> 	rcv_priv = netdev_priv(rcv);
>> 	rq = &rcv_priv->rq[rcv_rxq];
>> 	...
>> 	// account txq stats in some way here
>> }
> 
> actually I have a different idea..what about account tx stats on the peer rx
> queue as a result of XDP_TX or ndo_xdp_xmit and properly report this info in
> the ethool stats? In this way we do not have any locking issue and we still use
> the per-queue stats approach. Could you please take a look to the following patch?

Thanks I think your idea is nice.

> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index b6505a6c7102..f2acd2ee6287 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -92,17 +92,22 @@ struct veth_q_stat_desc {
>   static const struct veth_q_stat_desc veth_rq_stats_desc[] = {
>   	{ "xdp_packets",	VETH_RQ_STAT(xdp_packets) },
>   	{ "xdp_bytes",		VETH_RQ_STAT(xdp_bytes) },
> -	{ "rx_drops",		VETH_RQ_STAT(rx_drops) },
> -	{ "rx_xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
> -	{ "rx_xdp_drops",	VETH_RQ_STAT(xdp_drops) },
> -	{ "rx_xdp_tx",		VETH_RQ_STAT(xdp_tx) },
> -	{ "rx_xdp_tx_errors",	VETH_RQ_STAT(xdp_tx_err) },
> -	{ "tx_xdp_xmit",	VETH_RQ_STAT(xdp_xmit) },
> -	{ "tx_xdp_xmit_errors",	VETH_RQ_STAT(xdp_xmit_err) },
> +	{ "drops",		VETH_RQ_STAT(rx_drops) },
> +	{ "xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
> +	{ "xdp_drops",		VETH_RQ_STAT(xdp_drops) },
>   };
>   
>   #define VETH_RQ_STATS_LEN	ARRAY_SIZE(veth_rq_stats_desc)
>   
> +static const struct veth_q_stat_desc veth_tq_stats_desc[] = {
> +	{ "xdp_tx",		VETH_RQ_STAT(xdp_tx) },
> +	{ "xdp_tx_errors",	VETH_RQ_STAT(xdp_tx_err) },

I'm wondering why xdp_tx is not accounted in rx_queue?
You can count xdp_tx/tx_error somewhere in rx path like veth_xdp_flush_bq().
xdp_redirect and xdp_drops are similar actions and in rx stats.

> +	{ "xdp_xmit",		VETH_RQ_STAT(xdp_xmit) },
> +	{ "xdp_xmit_errors",	VETH_RQ_STAT(xdp_xmit_err) },
> +};
> +
> +#define VETH_TQ_STATS_LEN	ARRAY_SIZE(veth_tq_stats_desc)
> +
>   static struct {
>   	const char string[ETH_GSTRING_LEN];
>   } ethtool_stats_keys[] = {
> @@ -142,6 +147,14 @@ static void veth_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
>   				p += ETH_GSTRING_LEN;
>   			}
>   		}
> +		for (i = 0; i < dev->real_num_tx_queues; i++) {
> +			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
> +				snprintf(p, ETH_GSTRING_LEN,
> +					 "tx_queue_%u_%.18s",
> +					 i, veth_tq_stats_desc[j].desc);
> +				p += ETH_GSTRING_LEN;
> +			}
> +		}
>   		break;
>   	}
>   }
> @@ -151,7 +164,8 @@ static int veth_get_sset_count(struct net_device *dev, int sset)
>   	switch (sset) {
>   	case ETH_SS_STATS:
>   		return ARRAY_SIZE(ethtool_stats_keys) +
> -		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues;
> +		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues +
> +		       VETH_TQ_STATS_LEN * dev->real_num_tx_queues;
>   	default:
>   		return -EOPNOTSUPP;
>   	}
> @@ -160,7 +174,7 @@ static int veth_get_sset_count(struct net_device *dev, int sset)
>   static void veth_get_ethtool_stats(struct net_device *dev,
>   		struct ethtool_stats *stats, u64 *data)
>   {
> -	struct veth_priv *priv = netdev_priv(dev);
> +	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
>   	struct net_device *peer = rtnl_dereference(priv->peer);
>   	int i, j, idx;
>   
> @@ -181,6 +195,26 @@ static void veth_get_ethtool_stats(struct net_device *dev,
>   		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
>   		idx += VETH_RQ_STATS_LEN;
>   	}
> +
> +	if (!peer)
> +		return;
> +
> +	rcv_priv = netdev_priv(peer);
> +	for (i = 0; i < peer->real_num_rx_queues; i++) {
> +		const struct veth_rq_stats *rq_stats = &rcv_priv->rq[i].stats;
> +		const void *stats_base = (void *)&rq_stats->vs;
> +		unsigned int start, tx_idx;
> +		size_t offset;
> +
> +		tx_idx = (i % dev->real_num_tx_queues) * VETH_TQ_STATS_LEN;

I'm a bit concerned that this can fold multiple rx queue counters into one tx 
counter. But I cannot think of a better idea provided that we want to align XDP 
stats between drivers. So I'm OK with this.

Toshiaki Makita

> +		do {
> +			start = u64_stats_fetch_begin_irq(&rq_stats->syncp);
> +			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
> +				offset = veth_tq_stats_desc[j].offset;
> +				data[tx_idx + idx + j] += *(u64 *)(stats_base + offset);
> +			}
> +		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
> +	}
>   }
>   
>   static const struct ethtool_ops veth_ethtool_ops = {
> @@ -340,8 +374,7 @@ static void veth_get_stats64(struct net_device *dev,
>   	tot->tx_packets = packets;
>   
>   	veth_stats_rx(&rx, dev);
> -	tot->tx_dropped += rx.xdp_xmit_err + rx.xdp_tx_err;
> -	tot->rx_dropped = rx.rx_drops;
> +	tot->rx_dropped = rx.rx_drops + rx.xdp_tx_err + rx.xdp_xmit_err;
>   	tot->rx_bytes = rx.xdp_bytes;
>   	tot->rx_packets = rx.xdp_packets;
>   
> @@ -353,7 +386,7 @@ static void veth_get_stats64(struct net_device *dev,
>   		tot->rx_packets += packets;
>   
>   		veth_stats_rx(&rx, peer);
> -		tot->rx_dropped += rx.xdp_xmit_err + rx.xdp_tx_err;
> +		tot->tx_dropped += rx.xdp_xmit_err + rx.xdp_tx_err;
>   		tot->tx_bytes += rx.xdp_bytes;
>   		tot->tx_packets += rx.xdp_packets;
>   	}
> @@ -394,9 +427,9 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>   			 u32 flags, bool ndo_xmit)
>   {
>   	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
> -	unsigned int qidx, max_len;
>   	struct net_device *rcv;
>   	int i, ret, drops = n;
> +	unsigned int max_len;
>   	struct veth_rq *rq;
>   
>   	rcu_read_lock();
> @@ -414,8 +447,7 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>   	}
>   
>   	rcv_priv = netdev_priv(rcv);
> -	qidx = veth_select_rxq(rcv);
> -	rq = &rcv_priv->rq[qidx];
> +	rq = &rcv_priv->rq[veth_select_rxq(rcv)];
>   	/* Non-NULL xdp_prog ensures that xdp_ring is initialized on receive
>   	 * side. This means an XDP program is loaded on the peer and the peer
>   	 * device is up.
> @@ -446,7 +478,6 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>   
>   	ret = n - drops;
>   drop:
> -	rq = &priv->rq[qidx];
>   	u64_stats_update_begin(&rq->stats.syncp);
>   	if (ndo_xmit) {
>   		rq->stats.vs.xdp_xmit += n - drops;
> 
>>
>> Thoughts?
>>
>> Toshiaki Makita
