Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAEF192938
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 14:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgCYNIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 09:08:12 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50646 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727046AbgCYNIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 09:08:12 -0400
Received: by mail-pj1-f66.google.com with SMTP id v13so1020055pjb.0
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 06:08:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IkhzGZaebwLHIeGfd9NLNE6HzYOJvljopwtJ8SWO6d4=;
        b=B2Fy/EqJi/svXY7JW6MD8E9dqs4UG2lAgtjKcd4X4XGSmyH9DzGp1nFpTZiWDb9ab/
         3kXEyumlm39m9z7kpMRgWqctZHZr/Y46SYHFrz0c4VcLEq3k465mH4s1yKXSWg262b3Z
         tZuwWpVujjmjNDxYE9FCJ9rg59EWGwpbENjhAL8BidsQFv+Nk+sBOpdpySkWc7tMp1Cv
         FR55LZARgMvIJbJArl2eZ3oMWzS35en6HYrRFgEg6u0asQBcnQxBMbje4CPh/wgw5PaI
         juFE4Go6g1/2NX35FhGWkM5ENuO4bC/tCOuWl4574F/RfYBxgyDBe+yNe8x0CobZr0NO
         3wbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IkhzGZaebwLHIeGfd9NLNE6HzYOJvljopwtJ8SWO6d4=;
        b=as+JS8/eg+9OnF9ZctijsZ/S3huVSu400I42+2rBOfx+Uw8mCWpURxsZ9luF5OkAri
         WJCcbGtP1LgYnVZ2PqUAEYEFWZyVu10ZrpnKpzMcgBmUq9VY26FUFcsjSGrR+XLktjCr
         wmc+wjUfLtaQU8eD4b4MgZ+d3KNArP/8SsLLUjk5lTnOhEBWgaFqEgSvLOSw1qwjHHsX
         O24fxZSoKefdkaM0+l5JGAnRpKuGZdRu1zzHqa1qc6+HPF+TkTyOI1GJDk15JS6x/oZ5
         7I8mxPA/t/yN+I+zsiPQlEetIukFAOAnUeIxM7rAjlRymKiC8pCMt5kT+/rHpTE6RJfj
         7olg==
X-Gm-Message-State: ANhLgQ1tEI/ugWMN6BvKKVCN2LOxJLgh0KzWlv7jLH7rrn7uQIQ05cSt
        SKVDVxSgDfg+n0BjoBsgbuSakwXo
X-Google-Smtp-Source: ADFU+vvRTEz2fhu+oDqv/iq1Oz4oKN151Nhwb/rU+DNPLl4gWuKv3tQ9czQlm1opCbEX3sXuFm4c+Q==
X-Received: by 2002:a17:90a:82:: with SMTP id a2mr3809212pja.47.1585141690436;
        Wed, 25 Mar 2020 06:08:10 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id 62sm9505098pfw.141.2020.03.25.06.08.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 06:08:09 -0700 (PDT)
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
 <075a675c-a2c4-7189-9339-c71d53421855@gmail.com>
 <20200324143658.GB1477940@lore-desk-wlan>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <1d614fdc-3cf1-3558-eb5a-38f16062e57f@gmail.com>
Date:   Wed, 25 Mar 2020 22:08:06 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200324143658.GB1477940@lore-desk-wlan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/03/24 23:36, Lorenzo Bianconi wrote:
> 
> [...]
> 
>>>> }
>>>
>>> actually I have a different idea..what about account tx stats on the peer rx
>>> queue as a result of XDP_TX or ndo_xdp_xmit and properly report this info in
>>> the ethool stats? In this way we do not have any locking issue and we still use
>>> the per-queue stats approach. Could you please take a look to the following patch?
>>
>> Thanks I think your idea is nice.
>>
>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>>> index b6505a6c7102..f2acd2ee6287 100644
>>> --- a/drivers/net/veth.c
>>> +++ b/drivers/net/veth.c
>>> @@ -92,17 +92,22 @@ struct veth_q_stat_desc {
>>>    static const struct veth_q_stat_desc veth_rq_stats_desc[] = {
>>>    	{ "xdp_packets",	VETH_RQ_STAT(xdp_packets) },
>>>    	{ "xdp_bytes",		VETH_RQ_STAT(xdp_bytes) },
>>> -	{ "rx_drops",		VETH_RQ_STAT(rx_drops) },
>>> -	{ "rx_xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
>>> -	{ "rx_xdp_drops",	VETH_RQ_STAT(xdp_drops) },
>>> -	{ "rx_xdp_tx",		VETH_RQ_STAT(xdp_tx) },
>>> -	{ "rx_xdp_tx_errors",	VETH_RQ_STAT(xdp_tx_err) },
>>> -	{ "tx_xdp_xmit",	VETH_RQ_STAT(xdp_xmit) },
>>> -	{ "tx_xdp_xmit_errors",	VETH_RQ_STAT(xdp_xmit_err) },
>>> +	{ "drops",		VETH_RQ_STAT(rx_drops) },
>>> +	{ "xdp_redirect",	VETH_RQ_STAT(xdp_redirect) },
>>> +	{ "xdp_drops",		VETH_RQ_STAT(xdp_drops) },
>>>    };
>>>    #define VETH_RQ_STATS_LEN	ARRAY_SIZE(veth_rq_stats_desc)
>>> +static const struct veth_q_stat_desc veth_tq_stats_desc[] = {
>>> +	{ "xdp_tx",		VETH_RQ_STAT(xdp_tx) },
>>> +	{ "xdp_tx_errors",	VETH_RQ_STAT(xdp_tx_err) },
>>
>> I'm wondering why xdp_tx is not accounted in rx_queue?
>> You can count xdp_tx/tx_error somewhere in rx path like veth_xdp_flush_bq().
>> xdp_redirect and xdp_drops are similar actions and in rx stats.
> 
> Hi,
> 
> thanks for the review :)
> 
> I moved the accounting of xdp_tx/tx_error in veth_xdp_xmit for two reason:
> 1- veth_xdp_tx in veth_xdp_rcv_one or veth_xdp_rcv_skb returns an error
>     for XDP_TX just if xdp_frame pointer is invalid but the packet can be
>     discarded in veth_xdp_xmit if the device is 'under-pressure' (and this can
>     be a problem since in XDP there are no queueing mechanisms so far)

Right, but you can track the discard in veth_xdp_flush_bq().

> 2- to be symmetric  with ndo_xdp_xmit

I thought consistency between drivers is more important. What about other drivers?

Toshiaki Makita

> 
>>
>>> +	{ "xdp_xmit",		VETH_RQ_STAT(xdp_xmit) },
>>> +	{ "xdp_xmit_errors",	VETH_RQ_STAT(xdp_xmit_err) },
>>> +};
>>> +
>>> +#define VETH_TQ_STATS_LEN	ARRAY_SIZE(veth_tq_stats_desc)
>>> +
>>>    static struct {
>>>    	const char string[ETH_GSTRING_LEN];
>>>    } ethtool_stats_keys[] = {
>>> @@ -142,6 +147,14 @@ static void veth_get_strings(struct net_device *dev, u32 stringset, u8 *buf)
>>>    				p += ETH_GSTRING_LEN;
>>>    			}
>>>    		}
>>> +		for (i = 0; i < dev->real_num_tx_queues; i++) {
>>> +			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
>>> +				snprintf(p, ETH_GSTRING_LEN,
>>> +					 "tx_queue_%u_%.18s",
>>> +					 i, veth_tq_stats_desc[j].desc);
>>> +				p += ETH_GSTRING_LEN;
>>> +			}
>>> +		}
>>>    		break;
>>>    	}
>>>    }
>>> @@ -151,7 +164,8 @@ static int veth_get_sset_count(struct net_device *dev, int sset)
>>>    	switch (sset) {
>>>    	case ETH_SS_STATS:
>>>    		return ARRAY_SIZE(ethtool_stats_keys) +
>>> -		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues;
>>> +		       VETH_RQ_STATS_LEN * dev->real_num_rx_queues +
>>> +		       VETH_TQ_STATS_LEN * dev->real_num_tx_queues;
>>>    	default:
>>>    		return -EOPNOTSUPP;
>>>    	}
>>> @@ -160,7 +174,7 @@ static int veth_get_sset_count(struct net_device *dev, int sset)
>>>    static void veth_get_ethtool_stats(struct net_device *dev,
>>>    		struct ethtool_stats *stats, u64 *data)
>>>    {
>>> -	struct veth_priv *priv = netdev_priv(dev);
>>> +	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
>>>    	struct net_device *peer = rtnl_dereference(priv->peer);
>>>    	int i, j, idx;
>>> @@ -181,6 +195,26 @@ static void veth_get_ethtool_stats(struct net_device *dev,
>>>    		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
>>>    		idx += VETH_RQ_STATS_LEN;
>>>    	}
>>> +
>>> +	if (!peer)
>>> +		return;
>>> +
>>> +	rcv_priv = netdev_priv(peer);
>>> +	for (i = 0; i < peer->real_num_rx_queues; i++) {
>>> +		const struct veth_rq_stats *rq_stats = &rcv_priv->rq[i].stats;
>>> +		const void *stats_base = (void *)&rq_stats->vs;
>>> +		unsigned int start, tx_idx;
>>> +		size_t offset;
>>> +
>>> +		tx_idx = (i % dev->real_num_tx_queues) * VETH_TQ_STATS_LEN;
>>
>> I'm a bit concerned that this can fold multiple rx queue counters into one
>> tx counter. But I cannot think of a better idea provided that we want to
>> align XDP stats between drivers. So I'm OK with this.
> 
> Since peer->real_num_rx_queues can be greater than dev->real_num_tx_queues,
> right? IIUC the only guarantee we have is:
> 
> peer->real_num_tx_queues < dev->real_num_rx_queues
> 
> If you are fine with that approach, I will post a patch before net-next
> closure.
> 
> Regards,
> Lorenzo
> 
> 
>>
>> Toshiaki Makita
>>
>>> +		do {
>>> +			start = u64_stats_fetch_begin_irq(&rq_stats->syncp);
>>> +			for (j = 0; j < VETH_TQ_STATS_LEN; j++) {
>>> +				offset = veth_tq_stats_desc[j].offset;
>>> +				data[tx_idx + idx + j] += *(u64 *)(stats_base + offset);
>>> +			}
>>> +		} while (u64_stats_fetch_retry_irq(&rq_stats->syncp, start));
>>> +	}
>>>    }
>>>    static const struct ethtool_ops veth_ethtool_ops = {
>>> @@ -340,8 +374,7 @@ static void veth_get_stats64(struct net_device *dev,
>>>    	tot->tx_packets = packets;
>>>    	veth_stats_rx(&rx, dev);
>>> -	tot->tx_dropped += rx.xdp_xmit_err + rx.xdp_tx_err;
>>> -	tot->rx_dropped = rx.rx_drops;
>>> +	tot->rx_dropped = rx.rx_drops + rx.xdp_tx_err + rx.xdp_xmit_err;
>>>    	tot->rx_bytes = rx.xdp_bytes;
>>>    	tot->rx_packets = rx.xdp_packets;
>>> @@ -353,7 +386,7 @@ static void veth_get_stats64(struct net_device *dev,
>>>    		tot->rx_packets += packets;
>>>    		veth_stats_rx(&rx, peer);
>>> -		tot->rx_dropped += rx.xdp_xmit_err + rx.xdp_tx_err;
>>> +		tot->tx_dropped += rx.xdp_xmit_err + rx.xdp_tx_err;
>>>    		tot->tx_bytes += rx.xdp_bytes;
>>>    		tot->tx_packets += rx.xdp_packets;
>>>    	}
>>> @@ -394,9 +427,9 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>>>    			 u32 flags, bool ndo_xmit)
>>>    {
>>>    	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
>>> -	unsigned int qidx, max_len;
>>>    	struct net_device *rcv;
>>>    	int i, ret, drops = n;
>>> +	unsigned int max_len;
>>>    	struct veth_rq *rq;
>>>    	rcu_read_lock();
>>> @@ -414,8 +447,7 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>>>    	}
>>>    	rcv_priv = netdev_priv(rcv);
>>> -	qidx = veth_select_rxq(rcv);
>>> -	rq = &rcv_priv->rq[qidx];
>>> +	rq = &rcv_priv->rq[veth_select_rxq(rcv)];
>>>    	/* Non-NULL xdp_prog ensures that xdp_ring is initialized on receive
>>>    	 * side. This means an XDP program is loaded on the peer and the peer
>>>    	 * device is up.
>>> @@ -446,7 +478,6 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>>>    	ret = n - drops;
>>>    drop:
>>> -	rq = &priv->rq[qidx];
>>>    	u64_stats_update_begin(&rq->stats.syncp);
>>>    	if (ndo_xmit) {
>>>    		rq->stats.vs.xdp_xmit += n - drops;
>>>
>>>>
>>>> Thoughts?
>>>>
>>>> Toshiaki Makita
