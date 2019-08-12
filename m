Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1F28A0B9
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 16:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfHLOV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 10:21:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53508 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbfHLOV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 10:21:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Z/HBAAdVzJjxPcR3Fpa0Bj/dMGp3a7DDAeyxrRuUx+U=; b=DVXmRu46PcxYsFuo2VV1To2Jl/
        BbQEqql4SCvhQFU3R6KirxTLmIHxPjjPiDSroFnI5O0RXQKlR1uef2MtYhvmUT0L6KppQzoC6FDoc
        0Apyj7k+YF/UUvGGyoxXIRa/w0PqB6HIdqAI6eQAkwvcbaIAOZAXV5b3UiXhgg2ohW2k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxBCN-0000oi-5x; Mon, 12 Aug 2019 16:21:23 +0200
Date:   Mon, 12 Aug 2019 16:21:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH v4 12/14] net: phy: adin: implement downshift
 configuration via phy-tunable
Message-ID: <20190812142123.GQ14290@lunn.ch>
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
 <20190812112350.15242-13-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812112350.15242-13-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 02:23:48PM +0300, Alexandru Ardelean wrote:
> Down-speed auto-negotiation may not always be enabled, in which case the
> PHY won't down-shift to 100 or 10 during auto-negotiation.
> 
> This change enables downshift and configures the number of retries to
> default 4 (which is also in the datasheet
> 
> The downshift control mechanism can also be controlled via the phy-tunable
> interface (ETHTOOL_PHY_DOWNSHIFT control).
> 
> The change has been adapted from the Aquantia PHY driver.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
