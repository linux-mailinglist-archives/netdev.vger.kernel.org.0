Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 518F3173CA0
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 17:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgB1QOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 11:14:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbgB1QOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 11:14:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Qflm7OrKUjYWnq6cm+MuYcbhzkhPxEoWP0RSirpduAs=; b=sCUwvJFKGpL5RN1pG5+HhwpTHm
        PBK6+bncoGPpLWHzdPd//9LgeFT65fnpZLqxIkgbdtxdBU2RnmoTMLPfFaDDSZ1snlLxOIwl1O5wL
        XeB5VAPeMVA9kwDj1grxFLP47+FmJGO+R4RQbN3375AIzOscra/LlS68CvhUjCbskYRE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j7iHL-00052K-HS; Fri, 28 Feb 2020 17:14:19 +0100
Date:   Fri, 28 Feb 2020 17:14:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        foss@0leil.net
Subject: Re: [PATCH net-next v2 1/3] net: phy: mscc: add support for RGMII
 MAC mode
Message-ID: <20200228161419.GE29979@lunn.ch>
References: <20200228155702.2062570-1-antoine.tenart@bootlin.com>
 <20200228155702.2062570-2-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228155702.2062570-2-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 28, 2020 at 04:57:00PM +0100, Antoine Tenart wrote:
> This patch adds support for connecting VSC8584 PHYs to the MAC using
> RGMII.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
