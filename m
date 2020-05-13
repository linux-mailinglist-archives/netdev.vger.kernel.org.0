Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4E51D1EE3
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390518AbgEMTRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:17:14 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D90C061A0C;
        Wed, 13 May 2020 12:17:14 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id f4so165423pgi.10;
        Wed, 13 May 2020 12:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GqpOTC77iftRlmeCJv2qZPQF7gymosnRKGcq5umLM6E=;
        b=iqlCGMhcrgy8UmEdmX2CoIak3ZfLfdmlriWXAYDX66rC+fwGlOW98aqlcJqAZO9wKU
         cyFzW8CtCTA2vtvJ6Yky0qeaE0iMkAHnwIc2++aRVWChVvTXGCqaQxnNqXo6oJukWDLt
         gwrd/RUEgg6D5nO8y2EBzva5JVLNFTu0fPoMze+LozW63ttxOi5pDVkf8gj79YhHE7pL
         x7tlEjBtuoQV4h/DGXVqjz2FLY0v0E6dAP92r9x4gXfycvy0a4hBH3CSi1KZkpGuUJ3I
         m0QUy/b7T9Rv8z84O9bNNbNC5siI5DUBJK3wIPeMsZhI7kkYbdMsl4Us18jg76alg59w
         M2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GqpOTC77iftRlmeCJv2qZPQF7gymosnRKGcq5umLM6E=;
        b=msk/ymkGlVxizGEAtLamTBWc54xQOJOqqn7r8FSBTut6AxnHLUM/kYu+1VFcMuFFYm
         nnigXGFQvAi+gghLtUXljvP3JqgcgWiJN0ZcRaXuNQwcBJ0c/joX8VqOfOvp8lk8eMgE
         xxPVdVpPrIp1jXMuegSd7D0RtCl5K84RxzhCujxmJBmLeGhajWBsZOXsPg/YVOx8S9jT
         HmpPoZlz85vstFj8w9jIssPXF05zMZ9sG4z+ESHwJ4yVUKUVSobwgT5vAU9pR6mqhUoc
         KPSxm4uIuXgR5riY52T+nuC2yzLdxMPqqMlc+k5eXDlKghAzvT0OAcIJ3L5MciZanA3E
         CrdQ==
X-Gm-Message-State: AOAM533ck9J5S+zZKgASj/g5noZB9sDAF6mnwAn8SovZb5W5SZ1yjZUn
        VEXucJQLKljoqfrr/Op5pQeLHc50
X-Google-Smtp-Source: ABdhPJy5v2ZC7OJLzdwmuSXeKZfTfjEMxOTCmyVYUnRzVZxsIqhMgXszhPMKbMFlVPqodnUfDj4iHw==
X-Received: by 2002:a63:145c:: with SMTP id 28mr723687pgu.77.1589397433198;
        Wed, 13 May 2020 12:17:13 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q62sm259612pfc.132.2020.05.13.12.17.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2020 12:17:12 -0700 (PDT)
Subject: Re: [PATCH] lan743x: Added fixed link support
To:     Roelof Berg <rberg@berg-solutions.de>
Cc:     andrew@lunn.ch, Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200513190633.7815-1-rberg@berg-solutions.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d6107622-b0c2-5b07-e7b2-01a417596c8e@gmail.com>
Date:   Wed, 13 May 2020 12:17:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200513190633.7815-1-rberg@berg-solutions.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/13/2020 12:06 PM, Roelof Berg wrote:
> Microchip lan7431 is frequently connected to a phy. However, it
> can also be directly connected to a MII remote peer without
> any phy in between. For supporting such a phyless hardware setup
> in Linux we added the capability to the driver to understand
> the fixed-link and the phy-connection-type entries in the device
> tree.
> 
> If a fixed-link node is configured in the device tree the lan7431
> device will deactivate auto negotiation and uses the speed and
> duplex settings configured in the fixed-link node.
> 
> Also the phy-connection-type can be configured in the device tree
> and in case of a fixed-link connection the RGMII mode can be
> configured, all other modes fall back to the default: GMII.
> 
> Example:
> 
>  &pcie {
> 	status = "okay";
> 
> 	host@0 {
> 		reg = <0 0 0 0 0>;
> 
> 		#address-cells = <3>;
> 		#size-cells = <2>;
> 
> 		ethernet@0 {
> 			compatible = "weyland-yutani,noscom1", "microchip,lan743x";
> 			status = "okay";
> 			reg = <0 0 0 0 0>;
> 			phy-connection-type = "rgmii";
> 
> 			fixed-link {
> 				speed = <100>;
> 				full-duplex;
> 			};
> 		};
> 	};
> };
> 
> Signed-off-by: Roelof Berg <rberg@berg-solutions.de>
> ---
>  drivers/net/ethernet/microchip/lan743x_main.c | 94 +++++++++++++++++--
>  drivers/net/ethernet/microchip/lan743x_main.h |  4 +
>  2 files changed, 89 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index a43140f7b5eb..85f12881340b 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -9,9 +9,12 @@
>  #include <linux/microchipphy.h>
>  #include <linux/net_tstamp.h>
>  #include <linux/phy.h>
> +#include <linux/phy_fixed.h>
>  #include <linux/rtnetlink.h>
>  #include <linux/iopoll.h>
>  #include <linux/crc16.h>
> +#include <linux/of_mdio.h>
> +#include <linux/of_net.h>
>  #include "lan743x_main.h"
>  #include "lan743x_ethtool.h"
>  
> @@ -974,6 +977,8 @@ static void lan743x_phy_close(struct lan743x_adapter *adapter)
>  
>  	phy_stop(netdev->phydev);
>  	phy_disconnect(netdev->phydev);
> +	if (of_phy_is_fixed_link(adapter->pdev->dev.of_node))
> +		of_phy_deregister_fixed_link(adapter->pdev->dev.of_node);
>  	netdev->phydev = NULL;
>  }
>  
> @@ -982,18 +987,86 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
>  	struct lan743x_phy *phy = &adapter->phy;
>  	struct phy_device *phydev;
>  	struct net_device *netdev;
> +	struct device_node *phynode;
> +	u32 data;
> +	phy_interface_t phyifc = PHY_INTERFACE_MODE_GMII;
> +	bool fixed_link = false;
>  	int ret = -EIO;
>  
>  	netdev = adapter->netdev;
> -	phydev = phy_find_first(adapter->mdiobus);
> -	if (!phydev)
> -		goto return_error;
> +	phynode = of_node_get(adapter->pdev->dev.of_node);
> +	if (phynode)
> +		of_get_phy_mode(phynode, &phyifc);
> +
> +	/* check if a fixed-link is defined in device-tree */
> +	if (phynode && of_phy_is_fixed_link(phynode)) {
> +		fixed_link = true;
> +		netdev_dbg(netdev, "fixed-link detected\n");
> +
> +		ret = of_phy_register_fixed_link(phynode);
> +		if (ret) {
> +			netdev_err(netdev, "cannot register fixed PHY\n");
> +			goto return_error;
> +		}
>  
> -	ret = phy_connect_direct(netdev, phydev,
> -				 lan743x_phy_link_status_change,
> -				 PHY_INTERFACE_MODE_GMII);
> -	if (ret)
> -		goto return_error;
> +		phydev = of_phy_connect(netdev, phynode,
> +					lan743x_phy_link_status_change,
> +					0, phyifc);
> +		if (!phydev)
> +			goto return_error;
> +
> +		/* Configure MAC to fixed link parameters */
> +		data = lan743x_csr_read(adapter, MAC_CR);
> +		/* Disable auto negotiation */
> +		data &= ~(MAC_CR_ADD_ | MAC_CR_ASD_);
> +		/* Set duplex mode */
> +		if (phydev->duplex)
> +			data |= MAC_CR_DPX_;
> +		else
> +			data &= ~MAC_CR_DPX_;
> +		/* Set bus speed */
> +		switch (phydev->speed) {
> +		case 10:
> +			data &= ~MAC_CR_CFG_H_;
> +			data &= ~MAC_CR_CFG_L_;
> +			break;
> +		case 100:
> +			data &= ~MAC_CR_CFG_H_;
> +			data |= MAC_CR_CFG_L_;
> +			break;
> +		case 1000:
> +			data |= MAC_CR_CFG_H_;
> +			data |= MAC_CR_CFG_L_;
> +			break;
> +		}
> +		/* Set interface mode */
> +		if (phyifc == PHY_INTERFACE_MODE_RGMII ||
> +		    phyifc == PHY_INTERFACE_MODE_RGMII_ID ||
> +		    phyifc == PHY_INTERFACE_MODE_RGMII_RXID ||
> +		    phyifc == PHY_INTERFACE_MODE_RGMII_TXID)
> +			/* RGMII */
> +			data &= ~MAC_CR_MII_EN_;
> +		else
> +			/* GMII */
> +			data |= MAC_CR_MII_EN_;
> +		lan743x_csr_write(adapter, MAC_CR, data);

All of this should be done in your adjust_link callback, I believe you
did it here because you made phy_start_aneg() conditional on not finding
a fixed PHY, but the point of a fixed PHY is to provide a full
emulation, including that of the state machine transitions.

> +	} else {
> +		phydev = phy_find_first(adapter->mdiobus);
> +		if (!phydev)
> +			goto return_error;
> +
> +		ret = phy_connect_direct(netdev, phydev,
> +					 lan743x_phy_link_status_change,
> +					 PHY_INTERFACE_MODE_GMII);
> +		/* Note: We cannot use phyifc here because this would be SGMII
> +		 * on a standard PC.
> +		 */
> +		if (ret)
> +			goto return_error;
> +	}
> +
> +	if (phynode)
> +		of_node_put(phynode);
>  
>  	/* MAC doesn't support 1000T Half */
>  	phy_remove_link_mode(phydev, ETHTOOL_LINK_MODE_1000baseT_Half_BIT);
> @@ -1004,10 +1077,13 @@ static int lan743x_phy_open(struct lan743x_adapter *adapter)
>  	phy->fc_autoneg = phydev->autoneg;
>  
>  	phy_start(phydev);
> -	phy_start_aneg(phydev);
> +	if (!fixed_link)
> +		phy_start_aneg(phydev);

phy_start() should already trigger an auto-negotiation restart if
necessary, so this calls seems to be redundant if nothing else. If
someone it must be kept, it should not be made conditional on the fixed
link.
-- 
Florian
