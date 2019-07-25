Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCE875082
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 16:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbfGYODy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 10:03:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37310 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbfGYODy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 10:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RMWiyOGfJh0Naszf7VgkGkyoPKUigwSk+d7hmIoAHsA=; b=tDbCAU9n48G/6QYUs/nvCinhRa
        m3NqfQK4HzCDbXe3EyUPhIflM6gvgcILLmswEIBPFz9zru9czFPfjGQ1YLjtWC/l5oOV3ROUZ/kjW
        xB54P0+4oZTb3S78Ou31elc9FC2vy/Iw0QeR9IkMixaPiCxsGm6cyQNuRetiy2LXJEOI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqeLX-0006TT-Dz; Thu, 25 Jul 2019 16:03:51 +0200
Date:   Thu, 25 Jul 2019 16:03:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH 3/3] net: dsa: ksz: Add Microchip KSZ8795 DSA driver
Message-ID: <20190725140351.GG21952@lunn.ch>
References: <20190724134048.31029-1-marex@denx.de>
 <20190724134048.31029-4-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724134048.31029-4-marex@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 03:40:48PM +0200, Marek Vasut wrote:
> From: Tristram Ha <Tristram.Ha@microchip.com>
> +static void ksz8795_phy_setup(struct ksz_device *dev, int port,
> +			      struct phy_device *phy)
> +{
> +	if (port < dev->phy_port_cnt) {
> +		/*
> +		 * SUPPORTED_Asym_Pause and SUPPORTED_Pause can be removed to
> +		 * disable flow control when rate limiting is used.
> +		 */
> +		linkmode_copy(phy->advertising, phy->supported);
> +	}
> +}

Hi Marek

Do you know why this is needed?

Thanks
	Andrew
