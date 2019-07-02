Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B0B5D4AD
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 18:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfGBQtX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 12:49:23 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51482 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBQtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 12:49:22 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so1542269wma.1
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 09:49:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=knQ2jzZVsQSPwZs7eFJmdH3996iyk554lANQSOkuNzs=;
        b=cyU9S2MNNu2uDQHJfzhKP/cnXuvOuHysOSQzt7ncpcNxvqNuVYndJzGNDSKMMlWWIV
         psFKPjKGx86zVvXJH+OxE7u7OY2s7WBUsZ7CEWk7QfVp/ixzaCf77IWKM4LaKg7Z4vHW
         fIuA0rzCFFObvqk4sgG31XnyeW1wSu2kHAXba8DDW9QIb4e3INurN2ON4WawCY2L+QAn
         AsM8FyvMdjGPc7bSkcU1siEZv4S0A0vKdZf9Q2cclvVzH/ciIEqSLA9iVlXmaUk7abKF
         MpE0y3+SuszORqS6XNsu+ssKX2fPRhzGB6fPo9ffvdnrmL9wDq4T5/IWIjJLP8ynnaEm
         CK9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=knQ2jzZVsQSPwZs7eFJmdH3996iyk554lANQSOkuNzs=;
        b=ESAEZmV3nmBOkHb+KVwFtX9UznWrh3JYkN6DOMimRdGx4Tco06EX+Hdwg2+e9FgnJ9
         xYXpHB6vM4fHLlABlzi2c2/Wjw21V2V4t1gyVj4wU7HhpZ6RQQr1WJFhOMgbJUNLHjRD
         siibfR0vfWuQvYUY7h9+TKUdSJgroBvmN7+v11SjnK/QdI+4xwi9BwPk/vrFvk8WoxQ7
         hm78IxvfDavwp3yzONUchsc3foiaQVmdKsjtM9nUPrHm7OLFHdnms1YLOVpAb2PimjGQ
         T3xzuGxzzwl5e9T579YhrFOZu+iKC3cvwper8vMn1wyU3habujbkLDYXgPfwqhTsGCc7
         Zkww==
X-Gm-Message-State: APjAAAVyGUSBN5C/FksODYDLvE2xUkI5uG5HNQV+ZlpgGDN4uhqcIPce
        ULkqHT9UaAsIIwz8fZN+rH8nlKI/
X-Google-Smtp-Source: APXvYqzm+6ZbQGj5v10nzhiSQe8ANZJfwZGJTH0IOKKF597plkjiGd/Vo/wXTQ8k7MsUqukjknbWPw==
X-Received: by 2002:a1c:4184:: with SMTP id o126mr3991671wma.68.1562086160850;
        Tue, 02 Jul 2019 09:49:20 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:5180:2626:d7af:c0a1? (p200300EA8BD60C0051802626D7AFC0A1.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:5180:2626:d7af:c0a1])
        by smtp.googlemail.com with ESMTPSA id o20sm34949930wrh.8.2019.07.02.09.49.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:49:20 -0700 (PDT)
Subject: Re: [PATCH net-next] r8169: add random MAC address fallback
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <61a7754f-bdf9-f69a-296d-47353a78c8b4@gmail.com>
Message-ID: <60c26de4-23bc-a94b-d4a0-1216d8053e1f@gmail.com>
Date:   Tue, 2 Jul 2019 18:49:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <61a7754f-bdf9-f69a-296d-47353a78c8b4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.07.2019 08:18, Heiner Kallweit wrote:
>>From 1c8bacf724f1450e5256c68fbff407305faf9cbd Mon Sep 17 00:00:00 2001
> 
> 
> 

Sorry, something went wrong when preparing the commit message. I'll resubmit.

> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 40 +++++++++++++++--------
>  1 file changed, 27 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 450c74dc1..d6c137b7f 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -6651,13 +6651,36 @@ static int rtl_get_ether_clk(struct rtl8169_private *tp)
>  	return rc;
>  }
>  
> +static void rtl_init_mac_address(struct rtl8169_private *tp)
> +{
> +	struct net_device *dev = tp->dev;
> +	u8 *mac_addr = dev->dev_addr;
> +	int rc, i;
> +
> +	rc = eth_platform_get_mac_address(tp_to_dev(tp), mac_addr);
> +	if (!rc)
> +		goto done;
> +
> +	rtl_read_mac_address(tp, mac_addr);
> +	if (is_valid_ether_addr(mac_addr))
> +		goto done;
> +
> +	for (i = 0; i < ETH_ALEN; i++)
> +		mac_addr[i] = RTL_R8(tp, MAC0 + i);
> +	if (is_valid_ether_addr(mac_addr))
> +		goto done;
> +
> +	eth_hw_addr_random(dev);
> +	dev_warn(tp_to_dev(tp), "can't read MAC address, setting random one\n");
> +done:
> +	rtl_rar_set(tp, mac_addr);
> +}
> +
>  static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  {
> -	/* align to u16 for is_valid_ether_addr() */
> -	u8 mac_addr[ETH_ALEN] __aligned(2) = {};
>  	struct rtl8169_private *tp;
>  	struct net_device *dev;
> -	int chipset, region, i;
> +	int chipset, region;
>  	int jumbo_max, rc;
>  
>  	dev = devm_alloc_etherdev(&pdev->dev, sizeof (*tp));
> @@ -6749,16 +6772,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	u64_stats_init(&tp->rx_stats.syncp);
>  	u64_stats_init(&tp->tx_stats.syncp);
>  
> -	/* get MAC address */
> -	rc = eth_platform_get_mac_address(&pdev->dev, mac_addr);
> -	if (rc)
> -		rtl_read_mac_address(tp, mac_addr);
> -
> -	if (is_valid_ether_addr(mac_addr))
> -		rtl_rar_set(tp, mac_addr);
> -
> -	for (i = 0; i < ETH_ALEN; i++)
> -		dev->dev_addr[i] = RTL_R8(tp, MAC0 + i);
> +	rtl_init_mac_address(tp);
>  
>  	dev->ethtool_ops = &rtl8169_ethtool_ops;
>  
> 

