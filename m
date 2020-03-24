Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33FE019035B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 02:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbgCXBkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 21:40:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53254 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727064AbgCXBkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 21:40:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yyJHkxxGFMVCEvDUsgTqwAsjjJ3fxb9UD7AsdyFNx4w=; b=oq+Ji3pOYgkwi7zYES+cKFSzlE
        vUnB2VhyjgkF+mAx58JROpXQ9UdQAqt/enYOtw3emOhVIYOQNOMOzqh/NWZhsBmfPFZktXUlqHB8n
        RjZ1usJxc6UWZEQ9ZW4sACjoL46kP/BnVTGDEmf9Z+TOGS97pXOznQMD5V5ulxS+vxAU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGYXx-0005am-9V; Tue, 24 Mar 2020 02:40:01 +0100
Date:   Tue, 24 Mar 2020 02:40:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH 07/14] net: ks8851: Use 16-bit writes to program MAC
 address
Message-ID: <20200324014001.GN3819@lunn.ch>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-8-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323234303.526748-8-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 12:42:56AM +0100, Marek Vasut wrote:
> On the SPI variant of KS8851, the MAC address can be programmed with
> either 8/16/32-bit writes. To make it easier to support the 16-bit
> parallel option of KS8851 too, switch both the MAC address programming
> and readout to 16-bit operations.
> 
> Remove ks8851_wrreg8() as it is not used anywhere anymore.
> 
> There should be no functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
