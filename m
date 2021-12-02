Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E62466142
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 11:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356854AbhLBKQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 05:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356828AbhLBKQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 05:16:53 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3584C06174A;
        Thu,  2 Dec 2021 02:13:28 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id p3-20020a05600c1d8300b003334fab53afso1871007wms.3;
        Thu, 02 Dec 2021 02:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=qHtIrcLBdVwW76CkvNIwp3+IMpC3Sz6lgdbRRy5WGMo=;
        b=VRsLcPfjhc6mTSTomtB1Xi+XHgG93sc5Fu9/4vW8YBuibzOjLW+23K1O4aJvkbk8iw
         1iA77cbWKNIINYSWuIUReVJK6SAXVEBsZ1wPBN5aAdLKCfx+p7jnIFh2WmEQWwf8kPms
         f69ffIWk1neL+ZCNC71P4kvPwQniHzyBlZGlTZs0n5JQBe7cYERl1uQ67LIcc1UWbgpe
         90stHnT0W4nTqoh0FjmwyqgOtAKJkhmkKJzSFefJ95LBMBpPbGEWit6AIm0kyY7arNZf
         NNaeEBeysNNd1Qb1hGQ6R4adHpOAc0IXoMWuY04Ew4tYvuT8HyvP6KBYeP0XJXyUP/oN
         0Rug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=qHtIrcLBdVwW76CkvNIwp3+IMpC3Sz6lgdbRRy5WGMo=;
        b=60KYQR36aRd2nNKU/4dYWYNJ56PNVtcjmddf2c1Y0C9/WTCuMeEbPaNJ/fGb3wvpQg
         YnEqufY2GQyDteAkURpUZh//gwuAz3nkZ2wV3cKnQI5Ilc8OmAV6qAYe8Ny/bjbMME22
         34A20ri7s5I9sFMviNFnQ5q6n4FR8EwayXc2WxkGjpPHoGHqIuRllOqTzH5OOLpQj7qF
         1hJYhYPE4rFMtFSQJXD4gWsBeuZALOtmXHT4ztPYzJkpT1/34BScPqqxoDO0dbptuf++
         irbetvMUC4ePFHHXxqaSvkYIvH3QrFvKchXVGJX52R8ABxttWYWE5IuIfx4GD5v2tu2u
         xZ2g==
X-Gm-Message-State: AOAM532tuRqBrHFcfwKMAkSXnwouCNTe32KU5WPLpjP858PFMcwhRc/4
        uNzpPXgDiYH1YoFKHeg4hI4=
X-Google-Smtp-Source: ABdhPJym4bvQmr7jCuoUsGpAjJ14bAaTdL8NbSsJWhNeZGKsS4HO6MCkzQYRhfSSbDHOhscGwDyFKw==
X-Received: by 2002:a1c:8015:: with SMTP id b21mr5079991wmd.161.1638440007473;
        Thu, 02 Dec 2021 02:13:27 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:6195:7c7f:1f45:58f4? (p200300ea8f1a0f0061957c7f1f4558f4.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:6195:7c7f:1f45:58f4])
        by smtp.googlemail.com with ESMTPSA id p27sm1661375wmi.28.2021.12.02.02.13.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 02:13:27 -0800 (PST)
Message-ID: <9116dadb-c3a3-1e69-164a-2cffa341b91b@gmail.com>
Date:   Thu, 2 Dec 2021 11:13:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, qiangqing.zhang@nxp.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        yannick.vignon@nxp.com, boon.leong.ong@intel.com,
        Jose.Abreu@synopsys.com, mst@redhat.com, Joao.Pinto@synopsys.com,
        mingkai.hu@nxp.com, leoyang.li@nxp.com
References: <20211201014705.6975-1-xiaoliang.yang_1@nxp.com>
 <20211201014705.6975-3-xiaoliang.yang_1@nxp.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 2/2] net: stmmac: make stmmac-tx-timeout
 configurable in Kconfig
In-Reply-To: <20211201014705.6975-3-xiaoliang.yang_1@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.12.2021 02:47, Xiaoliang Yang wrote:
> stmmac_tx_timeout() function is called when a queue transmission
> timeout. When Strict Priority is used as scheduling algorithms, the
> lower priority queue may be blocked by a higher prority queue, which
> will lead to tx timeout. We don't want to enable the tx watchdog timeout
> in this case. Therefore, this patch make stmmac-tx-timeout configurable.
> 
Your patch just disables the timeout handler, the WARN_ONCE() would
still fire. And shouldn't this be a runtime setting rather than a
compile-time setting?

> This patch set the CONFIG_STMMAC_TX_TIMEOUT by default when STMMAC_ETH
> is selected. If anyone want to disable the tx watchdog timeout of
> stmmac, he can unset the CONFIG_STMMAC_TX_TIMEOUT in menuconfig.
> 
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/Kconfig       | 12 ++++++++++++
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  4 ++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> index 929cfc22cd0c..856c7d056b61 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> @@ -271,4 +271,16 @@ config STMMAC_PCI
>  	  If you have a controller with this interface, say Y or M here.
>  
>  	  If unsure, say N.
> +
> +config STMMAC_TX_TIMEOUT
> +	bool "STMMAC TX timeout support"
> +	default STMMAC_ETH
> +	depends on STMMAC_ETH
> +	help
> +	  Support for TX timeout enable on stmmac.
> +
> +	  This selects the TX watchdog timeout support for stmmac driver. The
> +	  feature is enabled by default when STMMAC_ETH is selected. If you
> +	  want to disable the TX watchdog timeout feature, say N here.
> +
>  endif
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 89a6c35e2546..0a712b5d0715 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5421,6 +5421,7 @@ static int stmmac_napi_poll_rxtx(struct napi_struct *napi, int budget)
>  	return min(rxtx_done, budget - 1);
>  }
>  
> +#ifdef CONFIG_STMMAC_TX_TIMEOUT
>  /**
>   *  stmmac_tx_timeout
>   *  @dev : Pointer to net device structure
> @@ -5436,6 +5437,7 @@ static void stmmac_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  
>  	stmmac_global_err(priv);
>  }
> +#endif
>  
>  /**
>   *  stmmac_set_rx_mode - entry point for multicast addressing
> @@ -6632,7 +6634,9 @@ static const struct net_device_ops stmmac_netdev_ops = {
>  	.ndo_fix_features = stmmac_fix_features,
>  	.ndo_set_features = stmmac_set_features,
>  	.ndo_set_rx_mode = stmmac_set_rx_mode,
> +#ifdef CONFIG_STMMAC_TX_TIMEOUT
>  	.ndo_tx_timeout = stmmac_tx_timeout,
> +#endif
>  	.ndo_eth_ioctl = stmmac_ioctl,
>  	.ndo_setup_tc = stmmac_setup_tc,
>  	.ndo_select_queue = stmmac_select_queue,
> 

