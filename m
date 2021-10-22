Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF70437ECC
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbhJVTqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:46:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53540 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233545AbhJVTqA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 15:46:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HfAVyDwz0/Vc1cPhosUtWSX6jwgPJ7NpYgZsmeIYdkA=; b=J82s6vyhOAQsW5ReH+bowlR63E
        FaDSyW0Sv+dH6lNDCJMb9POqEpYMkyiYl9Mg9JtfHB8SOddQQpzF8gNCn+cZVqzskctZn8+6n4lxp
        worSaktu6QYA9cOg3dxxtBONObBFa49WbXxs1ZcUIO7VPe4kxKjf+gbJ34SU1Fm6BVN0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1me0S0-00BQNX-B8; Fri, 22 Oct 2021 21:43:36 +0200
Date:   Fri, 22 Oct 2021 21:43:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 2/2] net: macb: Use mdio child node for MDIO bus
 if it exists
Message-ID: <YXMUaPFYRUZYyKK6@lunn.ch>
References: <20211022163548.3380625-1-sean.anderson@seco.com>
 <20211022163548.3380625-2-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022163548.3380625-2-sean.anderson@seco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 12:35:48PM -0400, Sean Anderson wrote:
> This allows explicitly specifying which children are present on the mdio
> bus. Additionally, it allows for non-phy MDIO devices on the bus.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
