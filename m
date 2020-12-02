Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40E432CC939
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:57:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbgLBVz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:55:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgLBVz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:55:57 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE01C0613D6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 13:55:17 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id g185so449651wmf.3
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 13:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=rcqgYaMAbaajv2nqJbuO0l+Zz8nLG5WDq56tPHdhllE=;
        b=qLuYzkV8b3G8UCRGs3iSj8q4yjC/K9lnMVNufpIroSQKOghwGZl05ny2Cw/5hEQ2pY
         n2+P8+BQh/n/febnzaSksder9jwSFGUSRTKWMO2IpuRzwRXYjTLZtsrO84uP+qF3/Asp
         q1Hy8zNpISyZLSsX4dp/pe+2QYe3hc7J6cLMqILvfxxxZGszmGeiF5U3wGNB3abYWP48
         qP7u1Ytm7skTD2kBFEbiIeQ7jWwhQTxVMp/obUxLGlN+BYGfru+538m5SNAehG/k/e42
         eVWJC32InJ97vAp1NsrDdc5qrWY28LXYO18fcFtONN7WAreMzXDHtKtrcKC4SgoXWLMP
         039g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=rcqgYaMAbaajv2nqJbuO0l+Zz8nLG5WDq56tPHdhllE=;
        b=bbfaung0jyq56CSDo1yXRk32DQQ0tj6tveKJh0IGRy8vOPCxvzBN8DkWJMIPKBbpQY
         +VaT9MOEbQ7zigpv7XuL9uWC+X4JV41+cv3AkXlUPIs2xnjwZRGglxMVrqaol5i3NE1Z
         vJZ+ilG+1C2Uo6H2RvwaDQPfGOb6igSj9zVmyMJ4JLxpwLULPzmKcmCC29S2NcGrraDh
         sKIGx+7VRd2ViBNRvWXvw3p2TlBwoZhiuSXKxTUliDCyZc6uljwedlwVTJ4ufVanv2m4
         ZU2DQ2nlpaFdiM/FUYkrtAzrqBLQmlj0gmfPsCrgRdMDavLcYU8uxt+1rKfxmA0VS1Iq
         Y9yQ==
X-Gm-Message-State: AOAM531XZmeRWzl51bFYvjgc06Cg0b4ipu0nwJDC0DxVjc1Y3a/tl7XO
        4JV/KTo+cblBNkAZgY1QMS4=
X-Google-Smtp-Source: ABdhPJyi0Z+mmEP0yh5Bu4Z6nTw9BgV27oRuR9jYweSvfM1IO85hFvXWIFbBuyKz6SHHLNXcEKx4zw==
X-Received: by 2002:a1c:2182:: with SMTP id h124mr25990wmh.25.1606946115554;
        Wed, 02 Dec 2020 13:55:15 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:8c1b:b3f8:bb:ecb? (p200300ea8f2328008c1bb3f800bb0ecb.dip0.t-ipconnect.de. [2003:ea:8f23:2800:8c1b:b3f8:bb:ecb])
        by smtp.googlemail.com with ESMTPSA id b74sm150761wme.27.2020.12.02.13.55.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 13:55:15 -0800 (PST)
Subject: Re: [PATCH V3 net-next 1/9] net: ena: use constant value for
 net_device allocation
To:     akiyano@amazon.com, kuba@kernel.org, netdev@vger.kernel.org
Cc:     dwmw@amazon.com, zorik@amazon.com, matua@amazon.com,
        saeedb@amazon.com, msw@amazon.com, aliguori@amazon.com,
        nafea@amazon.com, gtzalik@amazon.com, netanel@amazon.com,
        alisaidi@amazon.com, benh@amazon.com, ndagan@amazon.com,
        shayagr@amazon.com, sameehj@amazon.com
References: <1606939410-26718-1-git-send-email-akiyano@amazon.com>
 <1606939410-26718-2-git-send-email-akiyano@amazon.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <10a1c719-1408-5305-38fd-254213f8a42b@gmail.com>
Date:   Wed, 2 Dec 2020 22:55:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1606939410-26718-2-git-send-email-akiyano@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 02.12.2020 um 21:03 schrieb akiyano@amazon.com:
> From: Arthur Kiyanovski <akiyano@amazon.com>
> 
> The patch changes the maximum number of RX/TX queues it advertises to
> the kernel (via alloc_etherdev_mq()) from a value received from the
> device to a constant value which is the minimum between 128 and the
> number of CPUs in the system.
> 
> By allocating the net_device struct with a constant number of queues,
> the driver is able to allocate it at a much earlier stage, before
> calling any ena_com functions. This would allow to make all log prints in
> ena_com to use netdev_* log functions instead or current pr_* ones.
> 

Did you test this? Usually using netdev_* before the net_device is
registered results in quite ugly messages. Therefore there's a number
of patches doing the opposite, replacing netdev_* with dev_* before
register_netdev(). See e.g.
22148df0d0bd ("r8169: don't use netif_info et al before net_device has been registered")


> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 46 ++++++++++----------
>  1 file changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index df1884d57d1a..985dea1870b5 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -29,6 +29,8 @@ MODULE_LICENSE("GPL");
>  /* Time in jiffies before concluding the transmitter is hung. */
>  #define TX_TIMEOUT  (5 * HZ)
>  
> +#define ENA_MAX_RINGS min_t(unsigned int, ENA_MAX_NUM_IO_QUEUES, num_possible_cpus())
> +
>  #define ENA_NAPI_BUDGET 64
>  
>  #define DEFAULT_MSG_ENABLE (NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | \
> @@ -4176,18 +4178,34 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  
>  	ena_dev->dmadev = &pdev->dev;
>  
> +	netdev = alloc_etherdev_mq(sizeof(struct ena_adapter), ENA_MAX_RINGS);
> +	if (!netdev) {
> +		dev_err(&pdev->dev, "alloc_etherdev_mq failed\n");
> +		rc = -ENOMEM;
> +		goto err_free_region;
> +	}
> +
> +	SET_NETDEV_DEV(netdev, &pdev->dev);
> +	adapter = netdev_priv(netdev);
> +	adapter->ena_dev = ena_dev;
> +	adapter->netdev = netdev;
> +	adapter->pdev = pdev;
> +	adapter->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
> +
> +	pci_set_drvdata(pdev, adapter);
> +
>  	rc = ena_device_init(ena_dev, pdev, &get_feat_ctx, &wd_state);
>  	if (rc) {
>  		dev_err(&pdev->dev, "ENA device init failed\n");
>  		if (rc == -ETIME)
>  			rc = -EPROBE_DEFER;
> -		goto err_free_region;
> +		goto err_netdev_destroy;
>  	}
>  
>  	rc = ena_map_llq_mem_bar(pdev, ena_dev, bars);
>  	if (rc) {
>  		dev_err(&pdev->dev, "ENA llq bar mapping failed\n");
> -		goto err_free_ena_dev;
> +		goto err_device_destroy;
>  	}
>  
>  	calc_queue_ctx.ena_dev = ena_dev;
> @@ -4207,26 +4225,8 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  		goto err_device_destroy;
>  	}
>  
> -	/* dev zeroed in init_etherdev */
> -	netdev = alloc_etherdev_mq(sizeof(struct ena_adapter), max_num_io_queues);
> -	if (!netdev) {
> -		dev_err(&pdev->dev, "alloc_etherdev_mq failed\n");
> -		rc = -ENOMEM;
> -		goto err_device_destroy;
> -	}
> -
> -	SET_NETDEV_DEV(netdev, &pdev->dev);
> -
> -	adapter = netdev_priv(netdev);
> -	pci_set_drvdata(pdev, adapter);
> -
> -	adapter->ena_dev = ena_dev;
> -	adapter->netdev = netdev;
> -	adapter->pdev = pdev;
> -
>  	ena_set_conf_feat_params(adapter, &get_feat_ctx);
>  
> -	adapter->msg_enable = netif_msg_init(debug, DEFAULT_MSG_ENABLE);
>  	adapter->reset_reason = ENA_REGS_RESET_NORMAL;
>  
>  	adapter->requested_tx_ring_size = calc_queue_ctx.tx_queue_size;
> @@ -4257,7 +4257,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (rc) {
>  		dev_err(&pdev->dev,
>  			"Failed to query interrupt moderation feature\n");
> -		goto err_netdev_destroy;
> +		goto err_device_destroy;
>  	}
>  	ena_init_io_rings(adapter,
>  			  0,
> @@ -4335,11 +4335,11 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	ena_disable_msix(adapter);
>  err_worker_destroy:
>  	del_timer(&adapter->timer_service);
> -err_netdev_destroy:
> -	free_netdev(netdev);
>  err_device_destroy:
>  	ena_com_delete_host_info(ena_dev);
>  	ena_com_admin_destroy(ena_dev);
> +err_netdev_destroy:
> +	free_netdev(netdev);
>  err_free_region:
>  	ena_release_bars(ena_dev, pdev);
>  err_free_ena_dev:
> 

