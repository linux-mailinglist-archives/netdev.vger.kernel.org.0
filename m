Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0967530303
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfE3TxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:53:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42548 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbfE3TxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 15:53:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uXhdYIlvEH5G60+3PCmXX7ytiSiAS57Pw5gDIZeK/io=; b=52VCIWO/Vd8E1uGigO/aQo9rBZ
        9OvM4hBooYiVdYxvPCWcuhEFLGwfjesbIh2DNQ/OjouM4WLQcC0dx8iJicaxbgIOptcr/j0wGJCwC
        8YykSbbKT2JWRzL8W/e4nPhgmdzoFzH17KAtBfyvZQBRDydSrcu6pw7mYPAirTxA3uTE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWR6f-0001D0-AG; Thu, 30 May 2019 21:52:57 +0200
Date:   Thu, 30 May 2019 21:52:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 1/3] net: phy: enable interrupts when PHY is
 attached already
Message-ID: <20190530195257.GB1561@lunn.ch>
References: <52f1a566-9c1d-2a3d-ce7b-e9284eed65cb@gmail.com>
 <883a0161-0c16-d538-464e-ee35348c9970@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <883a0161-0c16-d538-464e-ee35348c9970@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 03:09:15PM +0200, Heiner Kallweit wrote:
> This patch is a step towards allowing PHY drivers to handle more
> interrupt sources than just link change. E.g. several PHY's have
> built-in temperature monitoring and can raise an interrupt if a
> temperature threshold is exceeded. We may be interested in such
> interrupts also if the phylib state machine isn't started.
> Therefore move enabling interrupts to phy_request_interrupt().
> 
> v2:
> - patch added to series
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
