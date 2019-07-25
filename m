Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81F0E753B7
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 18:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387708AbfGYQSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 12:18:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37804 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387564AbfGYQSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 12:18:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lx19xN5HOcY4MichJkaW84T4RkuDarVrltBvht+N9+g=; b=WEzp+tvXyJBMQar1LibJESklMJ
        ero1g60as9Aenl5pkcP8wP6puit1q8JYc+f+LlP+JCJtYO8vBnd+Qcix9eT7oCBlXbBLpACBYATJ5
        aOfgxYyH7UAuw1fgzehGM3Wk9z+HmtEgdxuC3E5LWat6pLTJ92RO4asU7jpLF9sVHA+Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hqgRq-0007VG-5g; Thu, 25 Jul 2019 18:18:30 +0200
Date:   Thu, 25 Jul 2019 18:18:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH V2 3/3] net: dsa: ksz: Add Microchip KSZ8795 DSA driver
Message-ID: <20190725161830.GI21952@lunn.ch>
References: <20190725150552.6901-1-marex@denx.de>
 <20190725150552.6901-4-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725150552.6901-4-marex@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 25, 2019 at 05:05:52PM +0200, Marek Vasut wrote:

Hi Marek

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

Please could you drop this, since your testing seems to indicate it is
not needed.

    Thanks
	Andrew
