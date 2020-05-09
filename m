Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8461CC2F1
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 18:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgEIQ5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 12:57:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51118 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727863AbgEIQ5p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 12:57:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=s4l4ppmaAlOA2KqoNi3aCZGr1qJEGebzLGEBcTTCtFs=; b=l7BurDe+PXvj7dwwBjRqTAPGRQ
        /P/6lckyZp4JIcW0BPGwCnSNcEueD59BZ7WA1KOkLhbCoWKOdtEvvGtXZg5HT+3ispESQg6yBcXXE
        iArjS4dXRRdrYcWf9CYyECveph2IQrkJmzvwRdgxBHimeF7xtEzN2ql569O41mLYzff8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXSnG-001WWX-Bv; Sat, 09 May 2020 18:57:42 +0200
Date:   Sat, 9 May 2020 18:57:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 2/5] dt-bindings: net: mdio-gpio: add compatible for
 microchip,mdio-smi0
Message-ID: <20200509165742.GD362499@lunn.ch>
References: <20200508154343.6074-1-m.grzeschik@pengutronix.de>
 <20200508154343.6074-3-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200508154343.6074-3-m.grzeschik@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 08, 2020 at 05:43:40PM +0200, Michael Grzeschik wrote:
> Microchip SMI0 Mode is a special mode, where the MDIO Read/Write
> commands are part of the PHY Address and the OP Code is always 0. We add
> the compatible for this special mode of the bitbanged mdio driver.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
