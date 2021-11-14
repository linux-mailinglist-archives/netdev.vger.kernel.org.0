Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E2F44FA1D
	for <lists+netdev@lfdr.de>; Sun, 14 Nov 2021 20:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236179AbhKNTWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Nov 2021 14:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236196AbhKNTWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Nov 2021 14:22:32 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6979EC061746;
        Sun, 14 Nov 2021 11:19:36 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id k23so2543759lje.1;
        Sun, 14 Nov 2021 11:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Smx2GT4U6hH7iOi/1cAa+TyFVS+CT1sHsL8FpqzaNu4=;
        b=jyJ8oMAhhusNAOyaTldgTm6ov6aZJo7J45gYTadmnWyN7IpoLSjbpGT4OiU8zSIsQb
         LzLYKv8U7x/mRTEeJo3/EcFLrRG13C8f2MjGYEquJ1TiaZbEMcfq8a/V0/sX5B1rdGXp
         UaP/INv3Z9zFgoLYFpaICBY44t/ouP0XJ0H6BXOBQmCnI97oy7ATSqc57EtFuaexJrbL
         Kg8dZxEEinoEm/+HcZYmdtIU02uxyNpOZKKfzYrJ4hMrQwQSTJ3UjIVcahvRvFpvG5Mb
         tAlexfKhawnR+Wgu8D2IDZfch/xTjiTALKUuky0UIpIhpom9juIgwllRbR1aODWodS3M
         lzbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Smx2GT4U6hH7iOi/1cAa+TyFVS+CT1sHsL8FpqzaNu4=;
        b=k9BmxhQO3RLSDWkHZjlIkgsdEKvad/kTdR2fVmnBMxSgLaMlEw4yTFjjB/KVzJ38O7
         G/X9K29ZQXgUBMQ43E9fqeBkEtZJuXzKIwJ0b3hJHhW4T+SF6RoAnfMaHsIkhCKGf5yc
         ltyhzL+2TA7LLkwycOMposRmNVeb99Srl0F6J82E55WJwWyLcek0/QT4kfA7e8GriBXY
         KfXQE1nFv5YbUXui4KMLDaISyqrnERVf+yOsCuS8wevcC9uVHV8gY5NDIU40TVlfQh1p
         +M5UTN3Bto5Yx27LbihVnue5+AYW9N+Mfx6VCTPWuA9m/BrxLAk9IiYmvbafRsZG3GUA
         UWUQ==
X-Gm-Message-State: AOAM531VY0vowNrSQ1IsUnymq2/kf56tKiJp8d7mmEbZsdS/s9foJFZO
        NcU1sdQXz5m+9nNa78B6k7eRgPOdEnQ=
X-Google-Smtp-Source: ABdhPJzI9fS20qwc93wj1B/cBFKmjS/NEKhioBTw85bvrmdUlSYHx/3ku6lcga7NsytXKzsikLxCyw==
X-Received: by 2002:a2e:3c13:: with SMTP id j19mr4771535lja.311.1636917574668;
        Sun, 14 Nov 2021 11:19:34 -0800 (PST)
Received: from [192.168.1.11] ([94.103.224.112])
        by smtp.gmail.com with ESMTPSA id b14sm1192840lfs.174.2021.11.14.11.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Nov 2021 11:19:33 -0800 (PST)
Message-ID: <52dbf9c9-0fa6-d4c6-ed6e-bba39e6e921b@gmail.com>
Date:   Sun, 14 Nov 2021 22:19:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH 2/2] net: ethernet: Add driver for Sunplus SP7021
Content-Language: en-US
To:     Wells Lu <wellslutw@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de
Cc:     Wells Lu <wells.lu@sunplus.com>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <650ec751dd782071dd56af5e36c0d509b0c66d7f.1635936610.git.wells.lu@sunplus.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Wells!

On 11/3/21 14:02, Wells Lu wrote:

[code snip]

> +		if (comm->dual_nic) {
> +			struct net_device *net_dev2 = mac->next_netdev;
> +
> +			if (!netif_running(net_dev2)) {
> +				mac_hw_stop(mac);
> +
> +				mac2 = netdev_priv(net_dev2);
> +

(*)

> +				// unregister and free net device.
> +				unregister_netdev(net_dev2);
> +				free_netdev(net_dev2);
> +				mac->next_netdev = NULL;
> +				pr_info(" Unregistered and freed net device \"eth1\"!\n");
> +
> +				comm->dual_nic = 0;
> +				mac_switch_mode(mac);
> +				rx_mode_set(net_dev);
> +				mac_hw_addr_del(mac2);
> +

mac2 is net_dev2 private data (*), so it will become freed after 
free_netdev() call.

FWIW the latest `smatch` should warn about this type of bugs.

> +				// If eth0 is up, turn on lan 0 and 1 when
> +				// switching to daisy-chain mode.
> +				if (comm->enable & 0x1)
> +					comm->enable = 0x3;

[code snip]

> +static int l2sw_remove(struct platform_device *pdev)
> +{
> +	struct net_device *net_dev;
> +	struct net_device *net_dev2;
> +	struct l2sw_mac *mac;
> +
> +	net_dev = platform_get_drvdata(pdev);
> +	if (!net_dev)
> +		return 0;
> +	mac = netdev_priv(net_dev);
> +
> +	// Unregister and free 2nd net device.
> +	net_dev2 = mac->next_netdev;
> +	if (net_dev2) {
> +		unregister_netdev(net_dev2);
> +		free_netdev(net_dev2);
> +	}
> +

Is it save here to free mac->next_netdev before unregistering "parent" 
netdev? I haven't checked the whole code, just asking :)

> +	sysfs_remove_group(&pdev->dev.kobj, &l2sw_attribute_group);
> +
> +	mac->comm->enable = 0;
> +	soc0_stop(mac);
> +
> +	napi_disable(&mac->comm->rx_napi);
> +	netif_napi_del(&mac->comm->rx_napi);
> +	napi_disable(&mac->comm->tx_napi);
> +	netif_napi_del(&mac->comm->tx_napi);
> +
> +	mdio_remove(net_dev);
> +
> +	// Unregister and free 1st net device.
> +	unregister_netdev(net_dev);
> +	free_netdev(net_dev);
> +
> +	clk_disable(mac->comm->clk);
> +
> +	// Free 'common' area.
> +	kfree(mac->comm);

Same here with `mac`.

> +	return 0;
> +}


I haven't read the whole thread, i am sorry if these questions were 
already discussed.



With regards,
Pavel Skripkin
