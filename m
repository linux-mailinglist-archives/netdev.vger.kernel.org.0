Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1820C352B14
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 15:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbhDBNin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 09:38:43 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:16413 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbhDBNil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 09:38:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617370720; x=1648906720;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=yG0zNJNDTld2DVB53Gy0mL9wk/1ZNB/IybEFKT6Dw0I=;
  b=KacO5tFPJnJzxysj0DrnFk0DTIflr5yEYXdZbG2kHj7HyY9hPTvxrED3
   +5GfwSo5367UN8xEyeuxkxU8DHVwg4ZTpMsWUbRI7n33+EaAcvnWit9v8
   8BjsGvvAJ2fgweCj8br0i6tMO5uk+qosj3feJ4++cgTMpcr4RaAHNWSqj
   GslKAAlM9l+Oa5PyZcA8294TVejBG4ISgbc38Yrx5n2eyB0vxiuA8BVyC
   KdgMmRUC82t5m3W4DO9B+InqTDrGi/bOLhaF+kah8KBC+AvCnz2+qYHRd
   XhLB909/YzwkXfi4Gt9N8wE9SbL5f+VDZ3J/TPQ6EJ8M90F/37Lzf/PS8
   g==;
IronPort-SDR: Tab07F+0/k4/etpOzirtNpQ723JUe0TTg5X6QA2x2tSfT+V11E03Sm0SyK8hLfRDTFRtho8J7h
 tGNvc3BumIGOYLILgdVaslxOKHu7l/Q4eCQhlySn6GkDuPk8JsCf7ncPo3H67o6fe5PjcvoPIe
 Cz6C5da/atvTWpVyWvavVP/jFFs2plrK6lMi3K8NQ5eJjyZ/FPlQk0GIRgZSnNn2rdGR7ltoun
 QpYWwgV/PRuZzSG1A/sXY5Dlby7GRuptIY+FWMfhW2cHg9lg2do+FR15j68Sl4kc8s8KBAGWnj
 2FM=
X-IronPort-AV: E=Sophos;i="5.81,299,1610434800"; 
   d="scan'208";a="121563933"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Apr 2021 06:38:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Apr 2021 06:38:40 -0700
Received: from [10.12.72.81] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Fri, 2 Apr 2021 06:38:38 -0700
Subject: Re: [PATCH 1/1] net: macb: restore cmp registers on resume path
To:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210402124253.3027-1-claudiu.beznea@microchip.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <e3409fe8-72ea-47a2-60cb-8aa558dfefab@microchip.com>
Date:   Fri, 2 Apr 2021 15:38:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210402124253.3027-1-claudiu.beznea@microchip.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/04/2021 at 14:42, Claudiu Beznea wrote:
> Restore CMP screener registers on resume path.
> 
> Fixes: c1e85c6ce57ef ("net: macb: save/restore the remaining registers and features")
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks for this fix Claudiu. Best regards,
   Nicolas

> ---
>   drivers/net/ethernet/cadence/macb_main.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index f56f3dbbc015..ffd56a23f8b0 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -3269,6 +3269,9 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
>   	bool cmp_b = false;
>   	bool cmp_c = false;
>   
> +	if (!macb_is_gem(bp))
> +		return;
> +
>   	tp4sp_v = &(fs->h_u.tcp_ip4_spec);
>   	tp4sp_m = &(fs->m_u.tcp_ip4_spec);
>   
> @@ -3637,6 +3640,7 @@ static void macb_restore_features(struct macb *bp)
>   {
>   	struct net_device *netdev = bp->dev;
>   	netdev_features_t features = netdev->features;
> +	struct ethtool_rx_fs_item *item;
>   
>   	/* TX checksum offload */
>   	macb_set_txcsum_feature(bp, features);
> @@ -3645,6 +3649,9 @@ static void macb_restore_features(struct macb *bp)
>   	macb_set_rxcsum_feature(bp, features);
>   
>   	/* RX Flow Filters */
> +	list_for_each_entry(item, &bp->rx_fs_list.list, list)
> +		gem_prog_cmp_regs(bp, &item->fs);
> +
>   	macb_set_rxflow_feature(bp, features);
>   }
>   
> 


-- 
Nicolas Ferre
