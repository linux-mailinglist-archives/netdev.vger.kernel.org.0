Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 942C21722A2
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 16:55:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbgB0Pyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 10:54:44 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37110 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727909AbgB0Pyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 10:54:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zHHu7uxl1TzDluMl9in9OmdrZA/yJJUaPHGV/HDELSI=; b=d2SWqEpTYc4/VsbeZu+W6FYy93
        0oZigveIoNEF5ttFeDl3Mm0PR1mPZOIhJdKZ3Xo8Ngu2SU0WwAE+G4UWjpqc6mXGrCe5akII2s4+C
        EI7hRTGKMJF4vNxIqrH1FCDbG9MUL7O1D6NxBmek7/COwzd2yOImqoezR7ave+vyirGE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j7LUm-0005xD-KW; Thu, 27 Feb 2020 16:54:40 +0100
Date:   Thu, 27 Feb 2020 16:54:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] net: phy: mscc: support LOS active low
Message-ID: <20200227155440.GC5245@lunn.ch>
References: <20200227154033.1688498-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227154033.1688498-1-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 04:40:31PM +0100, Antoine Tenart wrote:
> Hello,
> 
> This series adds a device tree property for the VSC8584 PHY family to
> describe the LOS pin connected to the PHY as being active low. This new
> property is then used in the MSCC PHY driver.

Hi Antoine

I think i'm missing the big picture.

Is this for when an SFP is connected directly to the PHY? The SFP
output LOS, indicating loss of received fibre/copper signal, is active
low?

	Andrew
