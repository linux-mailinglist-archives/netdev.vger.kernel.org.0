Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD868C1BF
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 21:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbfHMT4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 15:56:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58152 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfHMT4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 15:56:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZjCsSWfN9G7Of10s0gDDcUZQG5Ub4aFGqWQWzCdBjqg=; b=fp16Kl6VPCWeY4P5HDmTyU4XsJ
        Skxnz2L6mBBSx/f2G4TuIoVHCYplB9/TgDBJCspR4mHVSVEE4VyJ+uzagg/upc0BWZVWgLkEeFlyc
        wMulNjp2Htyr/dYELR6sl5bovskiel9qOG7DVVDZlPDv8Sl365E6IWEooazkbDI0ULkg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxcuH-0004BZ-5Z; Tue, 13 Aug 2019 21:56:33 +0200
Date:   Tue, 13 Aug 2019 21:56:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v6 2/4] net: phy: Add support for generic LED
 configuration through the DT
Message-ID: <20190813195633.GJ15047@lunn.ch>
References: <20190813191147.19936-1-mka@chromium.org>
 <20190813191147.19936-3-mka@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813191147.19936-3-mka@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 12:11:45PM -0700, Matthias Kaehlcke wrote:
> For PHYs with a device tree node look for LED trigger configuration
> using the generic binding, if it exists try to apply it via the new
> driver hook .config_led.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
