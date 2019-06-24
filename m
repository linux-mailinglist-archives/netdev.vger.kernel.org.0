Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDA25002A
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 05:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbfFXDUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 23:20:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51424 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfFXDUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 23:20:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cKhx+mIkeviKG/DThCrqSVmM2QsoZLdSj4JyxKOm2Nc=; b=Asji/hB11NpdaFHz3ak6u9p1DJ
        tudqAtcBQlsjCSZ/SgJRdOE1msPKypO8O4VMmna19zcdlcjgiwnoCE3QCXrBwWbwBY5o0J0l7du8/
        YLVAILY2qT8/xO3+BsRWLqMiGQxxQyu4sW/k3g46MQERW1i/0KBjFvGWQ+1HqLzh+Ids=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hfFX2-0002Tf-Es; Mon, 24 Jun 2019 05:20:36 +0200
Date:   Mon, 24 Jun 2019 05:20:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <Woojung.Huh@microchip.com>
Subject: Re: [PATCH V3 05/10] net: dsa: microchip: Use PORT_CTRL_ADDR()
 instead of indirect function call
Message-ID: <20190624032036.GL28942@lunn.ch>
References: <20190623223508.2713-1-marex@denx.de>
 <20190623223508.2713-6-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190623223508.2713-6-marex@denx.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 12:35:03AM +0200, Marek Vasut wrote:
> The indirect function call to dev->dev_ops->get_port_addr() is expensive
> especially if called for every single register access, and only returns
> the value of PORT_CTRL_ADDR() macro. Use PORT_CTRL_ADDR() macro directly
> instead.

Hi Marek

Rather than change just one instance, it would be better to change
them all. And then remove dev_ops->get_port_addr().

     Andrew
