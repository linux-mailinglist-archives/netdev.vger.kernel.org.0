Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04011E4557
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 16:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387800AbgE0OLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 10:11:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52114 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387414AbgE0OLv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 10:11:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=flzj/lngT18DPTCvNH2h32gcN6Il8dJnbGf7g1daBg8=; b=SgdRnKgI/MIjcHegg74DUMxNHV
        8C6j3H4oU/p1Dy371+McZfwjm9PEa5SfgYMkaMdQ2HTb3h47w/9TjV/gsjUf63ZX8lUps22xe9Za3
        OI6I6WmsXSk2J6I9/ZwDvCLrhNszXNo/YJ5LE/TfM3HFjTF9Q6o9UJ2U0h0RmLEk7H/c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jdwma-003PZI-He; Wed, 27 May 2020 16:11:48 +0200
Date:   Wed, 27 May 2020 16:11:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next 2/2] net: mscc: allow offloading timestamping
 operations to the PHY
Message-ID: <20200527141148.GD812580@lunn.ch>
References: <20200526150149.456719-1-antoine.tenart@bootlin.com>
 <20200526150149.456719-3-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526150149.456719-3-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 05:01:49PM +0200, Antoine Tenart wrote:
> This patch adds support for offloading timestamping operations not only
> to the Ocelot switch (as already supported) but to compatible PHYs.
> When both the PHY and the Ocelot switch support timestamping operations,
> the PHY implementation is chosen as the timestamp will happen closer to
> the medium.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
