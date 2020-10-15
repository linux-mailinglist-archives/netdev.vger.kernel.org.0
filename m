Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F5C28EDAE
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 09:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbgJOH0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 03:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgJOH0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 03:26:00 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830A5C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 00:26:00 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 13so2054800wmf.0
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 00:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aDwPHUxxIHGSGd5acXdTkmOfTk0TSyYa6ts+8FQBGXY=;
        b=MN3kbhiNjIRJ/vAg/AWxKPFyjKIzblyIM3lkztXl28eErt9ORWTHtrvrnGul4AEXu8
         es0qlgfSm76TXmwDd/KsWhMKUUjMUbGnDNJlnmdXr4NgCgi3b3b//h2476NRJkuFOg8/
         ercieYWxDbVJaSQkoJ1MiEMoXTbvVaqLcsXoEZHfZH1N8xdP8kac1ay5faM+DUUIvMzG
         3RvQLlFpPc8bCQqbj2RqNsVYVMp237Hl5EOoYBY68C/szpv+syfuqIyRt2z4kDtqUglQ
         LgnB2zNMSQIfHK47pYcThXNDENVMWssDUZ5S0fmGq6a1xujrGvKldbjNIcFDmZSJC19c
         FWHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aDwPHUxxIHGSGd5acXdTkmOfTk0TSyYa6ts+8FQBGXY=;
        b=pkyVUlfmtWsOixVjF1sgKmM8coVByXk5EiLlQ5eZSqiARUtSfCzUcaetagdaSN+0U5
         wN7Kwzhk7jfxmMPGNdJbvfNcM648p+l8sMBfKTLQ57JnM8cUw3he4b9W8hFpys8cmQlg
         uVqkAiIAltvGj8cT1Lj/Zn1m0nAQX0gOeEq/AQu5CEVHvEcuqjX+/7VPupAxkvgoVvfT
         vApq/M20zoT9e3bYvR+agowphLWMvxv88yX1PVO1+HvyFEDNdOzMtjdVTKyPWs91ISMy
         MQ6118yO5ZV68vhFjEGRELy64l1HBwRevxUsy9pHTDfBQG6g4CpkkTLSi5cFl3xZUigM
         wHsg==
X-Gm-Message-State: AOAM533cG0JJfI9ID57l41EOUaZqcISaN6H5UU+Nxe4qXvHXTxxqmgR+
        sIwnnIxHl/u1r43t8IeT9xQ=
X-Google-Smtp-Source: ABdhPJxEWFzLgY9Mk4y0HVM3iknl6sFc4N2kbmmRqS+Bzyx+QMgYbp3xWbZgrtZd/uEEX9q9VFN+2A==
X-Received: by 2002:a05:600c:2241:: with SMTP id a1mr2645579wmm.49.1602746758010;
        Thu, 15 Oct 2020 00:25:58 -0700 (PDT)
Received: from [192.168.8.147] ([37.172.154.187])
        by smtp.gmail.com with ESMTPSA id t124sm2982776wmg.31.2020.10.15.00.25.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 00:25:57 -0700 (PDT)
Subject: Re: [PATCH v3] net: Add mhi-net driver
To:     Loic Poulain <loic.poulain@linaro.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, hemantk@codeaurora.org,
        manivannan.sadhasivam@linaro.org
References: <1602676437-9829-1-git-send-email-loic.poulain@linaro.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b7fd004c-2293-a08c-51eb-40eecbdd4a9c@gmail.com>
Date:   Thu, 15 Oct 2020 09:25:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1602676437-9829-1-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/14/20 1:53 PM, Loic Poulain wrote:
> This patch adds a new network driver implementing MHI transport for
> network packets. Packets can be in any format, though QMAP (rmnet)
> is the usual protocol (flow control + PDN mux).
> 

...

> +static void mhi_net_rx_refill_work(struct work_struct *work)
> +{
> +	struct mhi_net_dev *mhi_netdev = container_of(work, struct mhi_net_dev,
> +						      rx_refill.work);
> +	struct net_device *ndev = mhi_netdev->ndev;
> +	struct mhi_device *mdev = mhi_netdev->mdev;
> +	struct sk_buff *skb;
> +	int err;
> +
> +	do {
> +		skb = netdev_alloc_skb(ndev, READ_ONCE(ndev->mtu));
> +		if (unlikely(!skb))
> +			break;

It is a bit strange you use READ_ONCE(ndev->mtu) here, but later
re-read ndev->mtu

It seems you need to store the READ_ONCE() in a temporary variable,

                unsigned int mtu = READ_ONCE(ndev->mtu);

> +
> +		err = mhi_queue_skb(mdev, DMA_FROM_DEVICE, skb, ndev->mtu,
> +				    MHI_EOT);

                 s/ndev->mtu/mtu/


> +		if (err) {
> +			if (unlikely(err != -ENOMEM))
> +				net_err_ratelimited("%s: Failed to queue RX buf (%d)\n",
> +						    ndev->name, err);
> +			kfree_skb(skb);
> +			break;
> +		}
> +
> +		atomic_inc(&mhi_netdev->stats.rx_queued);

This is an unbound loop in the kernel ?

Please add a :

		cond_resched();

Before anyone gets hurt.


> +	} while (1);
> +
> +	/* If we're still starved of rx buffers, reschedule latter */
> +	if (unlikely(!atomic_read(&mhi_netdev->stats.rx_queued)))
> +		schedule_delayed_work(&mhi_netdev->rx_refill, HZ / 2);
> +}
> +
> 


