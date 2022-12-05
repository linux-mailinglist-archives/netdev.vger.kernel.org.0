Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2C964237E
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiLEHST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:18:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiLEHSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:18:18 -0500
X-Greylist: delayed 183 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 04 Dec 2022 23:18:14 PST
Received: from hfcrelay.icp-osb-irony-out8.external.iinet.net.au (hfcrelay.icp-osb-irony-out8.external.iinet.net.au [203.59.1.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F333EE17
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 23:18:13 -0800 (PST)
IronPort-SDR: V9fknfqS3qV63liEyjfM0VZZ515I35kUq9qZcuVSQpxxGxBno9ZcMhpaF9c2jPjPs0Cg+sPVz5
 JIY7ZyHoQL6U2q9HSmCYprhkW8vyL8o7pNuRY0ihR8Tah6nOZiXAsgup5gt4Nhoc0WgzA3B1Tk
 kg7p5KGALVif9SIgIIv9OBq6m8eOCoO6wIcSGMGWXF+4MKFUt3/4/YhvfybFMgoTJvUyBxoapS
 3dPH1u3saKX4Fv4mzoOTK0tq/IV49jEND2dP+QYZ6AdrNfRMqf70LYicl3dNfWAgZp/F/2fFRx
 WPg=
X-SMTP-MATCH: 1
IronPort-Data: A9a23:IKRPqazsm3yZ1NiN9sB6t+c7xyrEfRIJ4+MujC+fZmUNrF6WrkU3e
 hirod39jgY+HhL3funC5f239Uo2DfZgF+fXKXJsnZ1XZysiRfHtWJLIcC8cAwvIdpeZFRg/s
 51EAjX9BJtcokH090/F3ofJ8CEUOZGgHtIQ38adZ0id7Sc9IMsQoUoLd9wR2+aEsvDga++5g
 u4eluWEULOTN5+YBUpPg06LgEsHUP3a5GhC5gRmDRxBlAe2e3I9VPrzKYntdCGgGtE88uOSH
 47+IL+FEmzx8E8iBcGktpHBckBQRa6VYyino3xQYv336vRCjnRaPqcTB6NNMwEO1WXPx5Yrk
 uAlWZ6YEFZyePSVxqJDDV8BQ34W0a5uodcrJVCwq8Gc0kvJfmHh2d1xAVoqO4AEvO1wBCdH6
 JT0LRhRMkve3Lrrnu/Tpu9EjcASdNLqF78k/VZQ7GDpHbEcbM/xTPCfjTNf9HJq7ixUJt7aZ
 swEeRJ1ZQ/FfgZRO1MTBZc5kfzuinqXWyRZoVSavKsx7C7BzAV335DrIMKTcduPLe1Zl1iVo
 0rK9nr0BxUdOsDZzzeZmlqhivLKlDH2RKodE7q38vMsi1qWrkQQFRcffVi2u/+0jgi5Qd03A
 1Qd8CcorIAo+UCrR8W7VBq9yFaCswIQVsR4DeI38keOx7DS7gLfAXILJhZFado7pIo1SCYs2
 1uhgdzkH3psvaeTRHbb8a2bxQ5eIgBMfDRHPHZaCFVbpoCz/8cvlh3OCN1kFei8k7UZBA3N/
 txDlwBm7517sCLB//jTEYzv6950mqX0cw==
IronPort-HdrOrdr: A9a23:g20XiKzUTP0NMIuZrGVlKrPwBL1zdoMgy1knxilNoH1uHvBw8v
 rEoB1173DJYVoqNk3I++rhBEDwexLhHPdOiOF6UItKOjOW2ldAR7sSjrcKrQeQYhHWx6pw0r
 phbrg7KPCYNykDsS6siDPId+rIGeP3l5xAU92uqUuEV2lRGsRd0zs=
X-IronPort-AV: E=Sophos;i="5.96,218,1665417600"; 
   d="scan'208";a="443530565"
Received: from 193-116-66-187.tpgi.com.au (HELO [192.168.0.22]) ([193.116.66.187])
  by icp-osb-irony-out8.iinet.net.au with ESMTP; 05 Dec 2022 15:15:05 +0800
Message-ID: <c69c1ff1-4da9-89f8-df2e-824cb7183fe9@westnet.com.au>
Date:   Mon, 5 Dec 2022 17:15:04 +1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Content-Language: en-US
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Greg Ungerer <gregungerer@westnet.com.au>
Subject: Re: [PATCH] net: fec: don't reset irq coalesce settings to defaults
 on "ip link up"
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus,

On 23 Nov 2022, Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
> Currently, when a FEC device is brought up, the irq coalesce settings
> are reset to their default values (1000us, 200 frames). That's
> unexpected, and breaks for example use of an appropriate .link file to
> make systemd-udev apply the desired
> settings (https://www.freedesktop.org/software/systemd/man/systemd.link.html),
> or any other method that would do a one-time setup during early boot.
> 
> Refactor the code so that fec_restart() instead uses
> fec_enet_itr_coal_set(), which simply applies the settings that are
> stored in the private data, and initialize that private data with the
> default values.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

This breaks The ColdFire parts that use the FEC hardware module at the
very least. It results in an access to a register (FEC_TXIC0) that does
not exist in the ColdFire FEC. Reverting this change fixes it.

So for me this is now broken in 6.1-rc8.

Regards
Greg


> ---
>  drivers/net/ethernet/freescale/fec_main.c | 22 ++++++----------------
>  1 file changed, 6 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index f623c12eaf95..2ca2b61b451f 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -74,7 +74,7 @@
>  #include "fec.h"
>  
>  static void set_multicast_list(struct net_device *ndev);
> -static void fec_enet_itr_coal_init(struct net_device *ndev);
> +static void fec_enet_itr_coal_set(struct net_device *ndev);
>  
>  #define DRIVER_NAME	"fec"
>  
> @@ -1220,8 +1220,7 @@ fec_restart(struct net_device *ndev)
>  		writel(0, fep->hwp + FEC_IMASK);
>  
>  	/* Init the interrupt coalescing */
> -	fec_enet_itr_coal_init(ndev);
> -
> +	fec_enet_itr_coal_set(ndev);
>  }
>  
>  static int fec_enet_ipc_handle_init(struct fec_enet_private *fep)
> @@ -2856,19 +2855,6 @@ static int fec_enet_set_coalesce(struct net_device *ndev,
>  	return 0;
>  }
>  
> -static void fec_enet_itr_coal_init(struct net_device *ndev)
> -{
> -	struct ethtool_coalesce ec;
> -
> -	ec.rx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
> -	ec.rx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
> -
> -	ec.tx_coalesce_usecs = FEC_ITR_ICTT_DEFAULT;
> -	ec.tx_max_coalesced_frames = FEC_ITR_ICFT_DEFAULT;
> -
> -	fec_enet_set_coalesce(ndev, &ec, NULL, NULL);
> -}
> -
>  static int fec_enet_get_tunable(struct net_device *netdev,
>  				const struct ethtool_tunable *tuna,
>  				void *data)
> @@ -3623,6 +3609,10 @@ static int fec_enet_init(struct net_device *ndev)
>  	fep->rx_align = 0x3;
>  	fep->tx_align = 0x3;
>  #endif
> +	fep->rx_pkts_itr = FEC_ITR_ICFT_DEFAULT;
> +	fep->tx_pkts_itr = FEC_ITR_ICFT_DEFAULT;
> +	fep->rx_time_itr = FEC_ITR_ICTT_DEFAULT;
> +	fep->tx_time_itr = FEC_ITR_ICTT_DEFAULT;
>  
>  	/* Check mask of the streaming and coherent API */
>  	ret = dma_set_mask_and_coherent(&fep->pdev->dev, DMA_BIT_MASK(32));
> -- 
> 2.37.2

