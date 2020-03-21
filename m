Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDDB18E195
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 14:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgCUNiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 09:38:52 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38028 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbgCUNiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Mar 2020 09:38:52 -0400
Received: by mail-pg1-f196.google.com with SMTP id x7so4560359pgh.5
        for <netdev@vger.kernel.org>; Sat, 21 Mar 2020 06:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sHJC5sylVggAzkwnsCH0x/9ilPJbbsLJTNlX2Wpg48g=;
        b=DjjS2xixbJdzn+T/CZOuXJDRRyFG4SKc7Jhk4PWwyhPRA9e5Exff4wPzwndDz64XW6
         rDjV7oqmpjBUG/2py+lH0QO3wf4dqaYjGI3aEFuo+JtaJbBF3oKxC+dZ6gDoGhs619MK
         LUaYE2VkDXz1ObqmLmsUU0RA64fNPrH0mpOtRt7jnhveqkl5T9PsJRLMBC6X+JiP5bXj
         nXWdspdq4ck4+3qonY7EeBFV9gcPHReBjY7FKAK7uoP5Qek/cxZzK/Hkl1RigHFujGT/
         puSbH+FCG3UV/v/jX8pEwpC4jwgXJB48b6PnRoNP5Cf5xIEuYZGp3P8mdOyOPYqLKTCH
         uZVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sHJC5sylVggAzkwnsCH0x/9ilPJbbsLJTNlX2Wpg48g=;
        b=mwwLjG2wR7arxncqOi4bW+z3GggIdarnNzeO51UhnlmKboKiqpBpxvhMJAST8bx6ad
         Sf7EXh7Lq9UjiL5chwsK16B8VfOKVZKdDEqzDozs5YwFX0Z6E1wl1O5kZ3XNMycIUN9+
         H8yi6GdeQmamVrdi45MXS4ukmCYpGhvzjjscuXQym2Oqo08A/vCe6CJOP8BYPv40ZPkB
         xpcEozJv7+f6mi69ny7H5b2slWuu/wx+5XFErceWKL9VAVb6kBzmEImyixbhp0IQ27QY
         FloRO+ZgBNh734BYX9TOJ9fsayrZOXZg7kjsOWHQgYaWogO9+DKltFhW5Mkxf2XbY9HQ
         jQAQ==
X-Gm-Message-State: ANhLgQ3MU2za6LlKyIYchleS4Du5Rrj4fJy2C0JewXy5Qaqde5ZPCr+d
        nqkbCt8AiX4AXE+zEZi3JxI=
X-Google-Smtp-Source: ADFU+vtt/2qgtcFKyiEPpIFwSyEFJpay/SAk6/PlhIlOS83GjvUaCJINlz96ot8gdXz72HI0PA5/BA==
X-Received: by 2002:a63:5859:: with SMTP id i25mr13020392pgm.74.1584797931533;
        Sat, 21 Mar 2020 06:38:51 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id z37sm1656792pgl.68.2020.03.21.06.38.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Mar 2020 06:38:51 -0700 (PDT)
Subject: Re: [PATCH net-next 4/5] veth: introduce more xdp counters
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, brouer@redhat.com,
        dsahern@gmail.com, lorenzo.bianconi@redhat.com, toke@redhat.com
References: <cover.1584635611.git.lorenzo@kernel.org>
 <0763c17646523acb4dc15aaec01decb4efe11eac.1584635611.git.lorenzo@kernel.org>
 <a3555c02-6cb1-c40c-65bb-12378439b12f@gmail.com>
 <20200320133737.GA2329672@lore-desk-wlan>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <04ca75e8-1291-4f25-3ad4-18ca5d6c6ddb@gmail.com>
Date:   Sat, 21 Mar 2020 22:38:46 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200320133737.GA2329672@lore-desk-wlan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/03/20 22:37, Lorenzo Bianconi wrote:
>> On 2020/03/20 1:41, Lorenzo Bianconi wrote:
>>> Introduce xdp_xmit counter in order to distinguish between XDP_TX and
>>> ndo_xdp_xmit stats. Introduce the following ethtool counters:
>>> - rx_xdp_tx
>>> - rx_xdp_tx_errors
>>> - tx_xdp_xmit
>>> - tx_xdp_xmit_errors
>>> - rx_xdp_redirect
>>
>> Thank you for working on this!
>>
>>> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>>> ---
>> ...
>>> @@ -395,7 +404,8 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>>>    	}
>>>    	rcv_priv = netdev_priv(rcv);
>>> -	rq = &rcv_priv->rq[veth_select_rxq(rcv)];
>>> +	qidx = veth_select_rxq(rcv);
>>> +	rq = &rcv_priv->rq[qidx];
>>>    	/* Non-NULL xdp_prog ensures that xdp_ring is initialized on receive
>>>    	 * side. This means an XDP program is loaded on the peer and the peer
>>>    	 * device is up.
>>> @@ -424,6 +434,17 @@ static int veth_xdp_xmit(struct net_device *dev, int n,
>>>    	if (flags & XDP_XMIT_FLUSH)
>>>    		__veth_xdp_flush(rq);
>>> +	rq = &priv->rq[qidx];
>>
>> I think there is no guarantee that this rq exists. Qidx is less than
>> rcv->real_num_rx_queues, but not necessarily less than
>> dev->real_num_rx_queues.
>>
>>> +	u64_stats_update_begin(&rq->stats.syncp);
>>
>> So this can cuase NULL pointer dereference.
> 
> oh right, thanks for spotting this.
> I think we can recompute qidx for tx netdevice in this case, doing something
> like:
> 
> qidx = veth_select_rxq(dev);
> rq = &priv->rq[qidx];
> 
> what do you think?

This would not cause NULL pointer deref, but I wonder what counters 
you've added mean.

- rx_xdp_redirect, rx_xdp_drops, rx_xdp_tx

These counters names will be rx_queue_[i]_rx_xdp_[redirect|drops|tx].
"rx_" in their names looks redundant.
Also it looks like there is not "rx[i]_xdp_tx" counter but there is 
"rx[i]_xdp_tx_xmit" in mlx5 from this page.
https://community.mellanox.com/s/article/understanding-mlx5-ethtool-counters

- tx_xdp_xmit, tx_xdp_xmit_errors

These counters names will be rx_queue_[i]_tx_xdp_[xmit|xmit_errors].
Are these rx counters or tx counters?
If tx, currently there is no storage to store these tx counters so 
adding these would not be simple.
If rx, I guess you should use peer rx queue counters instead of dev rx 
queue counters.

Toshiaki Makita
