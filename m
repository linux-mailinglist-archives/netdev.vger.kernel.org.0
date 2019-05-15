Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273EA1F765
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 17:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfEOPYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 11:24:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36313 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbfEOPYM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 11:24:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DmUD800ht2Oovg7nnym6UZMCMbRrV+gkU6cBHgb8fWo=; b=OQudQ5nuA7ENf2kMDsPN5loRs6
        lvk0od/yxUMJcOd0jareK24oZb28CzirJS/KllL9Axtxiqa0rhZJX39EsZ8sg5PbwoUmz7CDxH+jd
        vViiW6A4DHAON6Eh5g8AV6hUdzSAzTDkHaaW8AJi2rhHTwoRbF9FOJ51Rb+YXHe4pBTc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hQvlH-0007jr-DM; Wed, 15 May 2019 17:24:07 +0200
Date:   Wed, 15 May 2019 17:24:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dinh Nguyen <dinguyen@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, joabreu@synopsys.com,
        Wei Liang Lim <wei.liang.lim@intel.com>
Subject: Re: [PATCH net-next] net: stmmac: socfpga: add RMII phy mode
Message-ID: <20190515152407.GA24455@lunn.ch>
References: <20190515144631.5490-1-dinguyen@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515144631.5490-1-dinguyen@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
> @@ -251,6 +251,9 @@ static int socfpga_dwmac_set_phy_mode(struct socfpga_dwmac *dwmac)
>  	case PHY_INTERFACE_MODE_SGMII:
>  		val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_GMII_MII;
>  		break;
> +	case PHY_INTERFACE_MODE_RMII:
> +		val = SYSMGR_EMACGRP_CTRL_PHYSEL_ENUM_RMII;
> +		break;

What about PHY_INTERFACE_MODE_RMII_ID, PHY_INTERFACE_MODE_RMII_RXID,
PHY_INTERFACE_MODE_RMII_TXID?

	Andrew
