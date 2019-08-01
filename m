Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC1D7D41E
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbfHAD4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:56:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52912 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728150AbfHAD4h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:56:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0ftkQ50H0Q5kMGTL7ceL+8GzaH8L2e4CWla38W5PLJA=; b=PJXpslUg39PLYXATYaYeK4JXtA
        Zy1b+XuAb3Xwp5VzH+yRbUkUAUcSs8C7XfeH7ZslSFpBHm4kIAOWdPV6bmtXCH8Livb9luhhRoeft
        XGexq4Q9WkSBepUYcdHurtp8ax6awp4n2pEf+o/1aYDNWRMmrN473LGb4m5L1jBZ19P0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1ht2CZ-0001Qd-T6; Thu, 01 Aug 2019 05:56:27 +0200
Date:   Thu, 1 Aug 2019 05:56:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, robh+dt@kernel.org,
        mark.rutland@arm.com, joel@jms.id.au, f.fainelli@gmail.com,
        hkallweit1@gmail.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 4/4] net: ftgmac100: Select ASPEED MDIO
 driver for the AST2600
Message-ID: <20190801035627.GI2713@lunn.ch>
References: <20190731053959.16293-1-andrew@aj.id.au>
 <20190731053959.16293-5-andrew@aj.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731053959.16293-5-andrew@aj.id.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 03:09:59PM +0930, Andrew Jeffery wrote:
> Ensures we can talk to a PHY via MDIO on the AST2600, as the MDIO
> controller is now separate from the MAC.
> 
> Signed-off-by: Andrew Jeffery <andrew@aj.id.au>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
