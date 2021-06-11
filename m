Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9D13A4442
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 16:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhFKOnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 10:43:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59392 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231231AbhFKOnj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 10:43:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PctqywyQaTyp3GxUhbRavvs5auoD/kaVLbsOu6ac/8A=; b=p0d2RA02JY+x01nbB3gAL1AhfJ
        CGzEFJHia+xUHEq/S1gLjeX8/3RvQRxNM3XywebCWC4hktAPgcTkFHr2cSttJQqTFE3G33xwotdAP
        DKtEh+TcSiNNwa2cr0Qg2vbOMYkNSodgqtDDUx7JfqudCpNtDGYXTcSk5COt2QVPBPyc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lriLq-008rpz-Cg; Fri, 11 Jun 2021 16:41:38 +0200
Date:   Fri, 11 Jun 2021 16:41:38 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linuxarm@huawei.com,
        Wenpeng Liang <liangwenpeng@huawei.com>
Subject: Re: [PATCH net-next 4/8] net: phy: fixed formatting issues with
 braces
Message-ID: <YMN2ItFGaZkKs0H9@lunn.ch>
References: <1623393419-2521-1-git-send-email-liweihang@huawei.com>
 <1623393419-2521-5-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623393419-2521-5-git-send-email-liweihang@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID) {
> +	if (phydev->interface == PHY_INTERFACE_MODE_RGMII_ID)
>  		delay = MII_M1111_RGMII_RX_DELAY | MII_M1111_RGMII_TX_DELAY;
> -	} else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID) {
> +	else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_RXID)
>  		delay = MII_M1111_RGMII_RX_DELAY;
> -	} else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> +	else if (phydev->interface == PHY_INTERFACE_MODE_RGMII_TXID)
>  		delay = MII_M1111_RGMII_TX_DELAY;
> -	} else {
> +	else
>  		delay = 0;
> -	}

Or turn it into a switch statement?

   Andrew
