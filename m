Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9EA18E95E
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 15:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgCVO3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 10:29:11 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38274 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgCVO3L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 10:29:11 -0400
Received: by mail-pg1-f195.google.com with SMTP id x7so5785970pgh.5
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 07:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jvgGTNq8WWMfcwUiFUHkMYQapO18zpTFT/lHyEvkvyk=;
        b=OgJseWNHLiKlGzfXSW/s0enNn2zs5S44uSqdM6jcxRyezu+IokqLv9CvWwO3KrSJJc
         YO21QPQ9tlfXhbuhONZ9llsN9XtluUGfVmG7BDHkkzP5unISry4iWtlvasHllb7LR4yZ
         rq4uMOeadiVjUFgf0Fnnrqpxp2WNyUVyYqq37yQENgNJM0o8EVA6m9YDXrvYGGf3fZMi
         SXXd0zhstE1XfmJPF+ryGnawpxLUzbCGCmPP8a9nadjXu7JcP6E8LIEITghM4IDUNTHZ
         D/7w7vxnDEN/mtkrvzksIWF6yfFSIwmfXm+IXWu+oWE3mBLOoGBtJNLVFumpIEcflBfl
         wCFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jvgGTNq8WWMfcwUiFUHkMYQapO18zpTFT/lHyEvkvyk=;
        b=WgZ70bzDOVHokqE5ZaTQaHrStC3SjH/SQ2MoPuUvigBB49PsJE43K/2MGGw1y2nlfr
         fcJxvBr1TEp35pEbD0/I8i3qhnvKxl73wpxcSrw1Jk2BM1KLXsC0K7yp/mxv4XR77HTg
         zQMX7KE8ZpKuFu7tZGP3qJzOpYGGMSHoZz0KsQNefMadn4ZdyxYphIrDMcCmIw/e7LdC
         9PSb2tU5B4zh/tS4IedBHXRjyhDqi3nzV5Ap4waxXYt6Lc3a5PzGAU4P6Nb+zeeczuQZ
         NfcUkjBzS3zWQdR98wIVWAmJI7pAnVd0GfyILvJxG+289lna6R6C1N1f71rBDlj4dcac
         j+vg==
X-Gm-Message-State: ANhLgQ1z8crNpqPlzlxTByImPXGkfQvHVc2bDWxYStmQ1fTi+MBNZIoT
        TV6KsEEB21GkahE/8q27AZE=
X-Google-Smtp-Source: ADFU+vvvbim5Xcy6kTLF0ABuS3zHSAuF7on1dG8dT1PJfmQpcictlP/1cXKUCm6DqewPHDUI1dQHjg==
X-Received: by 2002:a63:6ac1:: with SMTP id f184mr18141602pgc.212.1584887347668;
        Sun, 22 Mar 2020 07:29:07 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id y4sm10722888pfe.31.2020.03.22.07.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 07:29:07 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
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
Message-ID: <d8ccb8c7-0501-dc88-d2b2-ca594df885cb@gmail.com>
Date:   Sun, 22 Mar 2020 23:29:04 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200321143013.GA3251815@lore-desk-wlan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/03/21 23:30, Lorenzo Bianconi wrote:
>> On 2020/03/20 22:37, Lorenzo Bianconi wrote:
>>>> On 2020/03/20 1:41, Lorenzo Bianconi wrote:
>>>>> Introduce xdp_xmit counter in order to distinguish between XDP_TX and
>>>>> ndo_xdp_xmit stats. Introduce the following ethtool counters:
>>>>> - rx_xdp_tx
>>>>> - rx_xdp_tx_errors
>>>>> - tx_xdp_xmit
>>>>> - tx_xdp_xmit_errors
>>>>> - rx_xdp_redirect
>>>>
>>>> Thank you for working on this!
>>>>
>>>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>>>> ---
>>>> ...
>>>>> @@ -395,7 +404,8 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>>>>>     	}
>>>>>     	rcv_priv = netdev_priv(rcv);
>>>>> -	rq = &rcv_priv->rq[veth_select_rxq(rcv)];
>>>>> +	qidx = veth_select_rxq(rcv);
>>>>> +	rq = &rcv_priv->rq[qidx];
>>>>>     	/* Non-NULL xdp_prog ensures that xdp_ring is initialized on receive
>>>>>     	 * side. This means an XDP program is loaded on the peer and the peer
>>>>>     	 * device is up.
>>>>> @@ -424,6 +434,17 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>>>>>     	if (flags & XDP_XMIT_FLUSH)
>>>>>     		__veth_xdp_flush(rq);
>>>>> +	rq = &priv->rq[qidx];
>>>>
>>>> I think there is no guarantee that this rq exists. Qidx is less than
>>>> rcv->real_num_rx_queues, but not necessarily less than
>>>> dev->real_num_rx_queues.
>>>>
>>>>> +	u64_stats_update_begin(&rq->stats.syncp);
>>>>
>>>> So this can cuase NULL pointer dereference.
>>>
>>> oh right, thanks for spotting this.
>>> I think we can recompute qidx for tx netdevice in this case, doing something
>>> like:
>>>
>>> qidx = veth_select_rxq(dev);
>>> rq = &priv->rq[qidx];
>>>
>>> what do you think?
>>
>> This would not cause NULL pointer deref, but I wonder what counters you've
>> added mean.
>>
>> - rx_xdp_redirect, rx_xdp_drops, rx_xdp_tx
>>
>> These counters names will be rx_queue_[i]_rx_xdp_[redirect|drops|tx].
>> "rx_" in their names looks redundant.
> 
> yes, we can drop the "rx" prefix in the stats name for them.
> 
>> Also it looks like there is not "rx[i]_xdp_tx" counter but there is
>> "rx[i]_xdp_tx_xmit" in mlx5 from this page.
>> https://community.mellanox.com/s/article/understanding-mlx5-ethtool-counters
> 
> rx[i]_xdp_tx_xmit and rx_xdp_tx are the same, we decided to use rx_xdp_tx for
> it since it seems more clear

OK.

>> - tx_xdp_xmit, tx_xdp_xmit_errors
>>
>> These counters names will be rx_queue_[i]_tx_xdp_[xmit|xmit_errors].
>> Are these rx counters or tx counters?
> 
> tx_xdp_xmit[_errors] are used to count ndo_xmit stats so they are tx counters.
> I reused veth_stats for it just for convenience. Probably we can show them without
> rx suffix so it is clear they are transmitted by the current device.
> Another approach would be create per_cput struct to collect all tx stats.
> What do you think?

As veth_xdp_xmit really does not use tx queue but select peer rxq directly, per_cpu 
sounds more appropriate than per-queue.
One concern is consistency. Per-queue rx stats and per-cpu tx stats (or only sum of 
them?) looks inconsistent.
One alternative way is to change the queue selection login in veth_xdp_xmit and 
select txq instead of rxq. Then select peer rxq from txq, like veth_xmit. Accounting 
per queue tx stats is possible only when we can determine which txq is used.

Something like this:

static int veth_select_txq(struct net_device *dev)
{
	return smp_processor_id() % dev->real_num_tx_queues;
}

static int veth_xdp_xmit(struct net_device *dev, int n,
			 struct xdp_frame **frames, u32 flags)
{
	...
	txq = veth_select_txq(dev);
	rcv_rxq = txq; // 1-to-1 mapping from txq to peer rxq
	// Note: when XDP is enabled on rcv, this condition is always false
	if (rcv_rxq >= rcv->real_num_rx_queues)
		return -ENXIO;
	rcv_priv = netdev_priv(rcv);
	rq = &rcv_priv->rq[rcv_rxq];
	...
	// account txq stats in some way here
}

Thoughts?

Toshiaki Makita
