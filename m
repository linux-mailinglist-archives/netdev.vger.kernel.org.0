Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B72FD64C4
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 16:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732416AbfJNOI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 10:08:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44780 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732117AbfJNOI0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 10:08:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EFN+bVverqHieHFWvEhh6qvCOizBaeC3Bs7uMIKfMcU=; b=azfP/N+AxTLj3aPRXo+0y6/21w
        LzqggcsMbYJ14W20ZQkE3tQNamMe0ta9uvxLAf2doKAYkudWsYo8/MEZg51pzS58BD7LlCxBU2j4E
        q3jfvqBvdvGNC5QQ+ubvmm+PMbzpbzHsVwQUYxncYtKjghKO/VTsf8cDUb+T63JvpTUY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iK11L-0005hd-Rr; Mon, 14 Oct 2019 16:08:23 +0200
Date:   Mon, 14 Oct 2019 16:08:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Sean Nyekjaer <sean.nyekjaer@prevas.dk>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH net V4 2/2] net: phy: micrel: Update KSZ87xx PHY name
Message-ID: <20191014140823.GC21165@lunn.ch>
References: <20191013212404.31708-1-marex@denx.de>
 <20191013212404.31708-2-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013212404.31708-2-marex@denx.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 13, 2019 at 11:24:04PM +0200, Marek Vasut wrote:
> The KSZ8795 PHY ID is in fact used by KSZ8794/KSZ8795/KSZ8765 switches.
> Update the PHY ID and name to reflect that, as this family of switches
> is commonly refered to as KSZ87xx
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
