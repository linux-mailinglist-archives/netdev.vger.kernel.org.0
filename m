Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C50128F289
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 14:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgJOMlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 08:41:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgJOMlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 08:41:47 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E70C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 05:41:47 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g12so3259616wrp.10
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 05:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gVOZeFI6XYUPK4xQnWsbEsH9LP3cSlbrYfYrvw/6j4Y=;
        b=OYS0WY2VI5/PCZdQ0dMKzBmpX02byLz9sHnng61JzJ2Ypw/oASydU1RyswCqcy1+ST
         MAaQRFuZ0O6yuteZrUytQSOlDWqmMoZfRXVjwF5a4CwWX6iHjGtzzkYZ4EeUPjn6z41Z
         k8uHg7TZ0l2XLrrG1ba2b3xAZGmVaW8OXMk2S2FTPIJx/Qu2X+WGrXsx4cywHRzSeDtG
         IM2nPs7i20fbH3jT6DwjpAiisjabkBBnJiUh2pWpCWugcSq8hh0ePdJByF1k3hHHTqK7
         FVN2I6WGx56HUDSSRTXHxPSbXdquFYMUSBJ3dVoqA+vMrp7Cj0qMqffeDt3BqTCtcpZY
         svKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gVOZeFI6XYUPK4xQnWsbEsH9LP3cSlbrYfYrvw/6j4Y=;
        b=qpa653VeIu3HwOZYj0RyE0dhjX0Zb7m5AecI3lhK8gnvbKE0g3642hPfndvbNWARKU
         kP+h/hH0uK2ryqHRE2gz/COqfHWfauD0OVCA3rw92YqdqYJGkAFK6ba8H5mMpOs/66n2
         OxGRvDZdi5x4yQU1HlBrO6p+ofR2c2wqXHQ013IUlrCpUqHx9p1jnPeelfbnwOppwZzW
         3sy+rdJ1T2cpz+nvRAGC0s8tB1vrrm6twQtLTdtr6PQB8zBsjXj0a2AuftmmOEy74F+q
         Be4xi1IzqCYYYOl6vWVklV2rr0CcCuKNG300znHfetQSZTOlM8ftmGNrgYIR6o8lvnj0
         +nWw==
X-Gm-Message-State: AOAM532+8GKxNKQxpgzQ9BJMcEMpyAuEdopOEUsmwSvZCLTVHZxDlayE
        O+NPnhUecS/srW0KDbQnfh4=
X-Google-Smtp-Source: ABdhPJwrenbBXeHTsjn4r32CQHwKN9rZIMyZKVQxLfB5uGfqIZdXK7B5Au8PgOaZMq7RE5aOuE3fEA==
X-Received: by 2002:a5d:4103:: with SMTP id l3mr4180012wrp.260.1602765705958;
        Thu, 15 Oct 2020 05:41:45 -0700 (PDT)
Received: from [192.168.8.147] ([37.165.69.53])
        by smtp.gmail.com with ESMTPSA id d3sm2718742wrb.66.2020.10.15.05.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 05:41:45 -0700 (PDT)
Subject: Re: [PATCH v4 1/2] net: Add mhi-net driver
To:     Loic Poulain <loic.poulain@linaro.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, hemantk@codeaurora.org,
        manivannan.sadhasivam@linaro.org, eric.dumazet@gmail.com
References: <1602757888-3507-1-git-send-email-loic.poulain@linaro.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ec2a1d76-d51f-7ec5-e2c1-5ed0eaf9a537@gmail.com>
Date:   Thu, 15 Oct 2020 14:41:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1602757888-3507-1-git-send-email-loic.poulain@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/15/20 12:31 PM, Loic Poulain wrote:
> This patch adds a new network driver implementing MHI transport for
> network packets. Packets can be in any format, though QMAP (rmnet)
> is the usual protocol (flow control + PDN mux).
> 
> It support two MHI devices, IP_HW0 which is, the path to the IPA
> (IP accelerator) on qcom modem, And IP_SW0 which is the software
> driven IP path (to modem CPU).
> 
>
> +static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
> +{
> +	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> +	struct mhi_device *mdev = mhi_netdev->mdev;
> +	int err;
> +
> +	skb_tx_timestamp(skb);
> +
> +	/* mhi_queue_skb is not thread-safe, but xmit is serialized by the
> +	 * network core. Once MHI core will be thread save, migrate to
> +	 * NETIF_F_LLTX support.
> +	 */
> +	err = mhi_queue_skb(mdev, DMA_TO_DEVICE, skb, skb->len, MHI_EOT);
> +	if (err == -ENOMEM) {
> +		netif_stop_queue(ndev);

If you return NETDEV_TX_BUSY, this means this skb will be requeues,
then sent again right away, and this will potentially loop forever.

Also skb_tx_timestamp() would be called multiple times.

I suggest you drop the packet instead.

> +		return NETDEV_TX_BUSY;
> +	} else if (unlikely(err)) {
> +		net_err_ratelimited("%s: Failed to queue TX buf (%d)\n",
> +				    ndev->name, err);
> +		mhi_netdev->stats.tx_dropped++;
> +		kfree_skb(skb);
> +	}
> +
> +	return NETDEV_TX_OK;
> +}
> +
> +static void mhi_ndo_get_stats64(struct net_device *ndev,
> +				struct rtnl_link_stats64 *stats)
> +{
> +	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
> +
> +	stats->rx_packets = mhi_netdev->stats.rx_packets;
> +	stats->rx_bytes = mhi_netdev->stats.rx_bytes;
> +	stats->rx_errors = mhi_netdev->stats.rx_errors;
> +	stats->rx_dropped = mhi_netdev->stats.rx_dropped;
> +	stats->tx_packets = mhi_netdev->stats.tx_packets;
> +	stats->tx_bytes = mhi_netdev->stats.tx_bytes;
> +	stats->tx_errors = mhi_netdev->stats.tx_errors;
> +	stats->tx_dropped = mhi_netdev->stats.tx_dropped;
> +}

This code is not correct on a 32bit kernel, since u64 values
can not be safely be read without extra care.


