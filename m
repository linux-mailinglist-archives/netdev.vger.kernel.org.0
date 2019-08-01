Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC0F17D419
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 05:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbfHAD4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 23:56:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52884 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726641AbfHADz7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 23:55:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Y1QlX2yE7yvhO9Y6IQdrLu7V2tiqtVgXwBkJSh4jYHg=; b=yNJoXUHia1doAfiLkZ7DnjfnK2
        DlsR52pVLSHbKp0s/pjmV6L1gaWDbQ6nlSfwl47jeGtYrwsMa5QfRALq7DLdZpyzf4zab2Fw/KOPb
        Lo0lyATAVgDSUowhIZ9zC7yAt0IT7zszT23ki4epttXDyxDLlDZQaJAl9ouyLcDfL5BE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1ht2Bx-0001OG-16; Thu, 01 Aug 2019 05:55:49 +0200
Date:   Thu, 1 Aug 2019 05:55:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, robh+dt@kernel.org,
        mark.rutland@arm.com, joel@jms.id.au, f.fainelli@gmail.com,
        hkallweit1@gmail.com, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/4] net: ftgmac100: Add support for DT
 phy-handle property
Message-ID: <20190801035549.GH2713@lunn.ch>
References: <20190731053959.16293-1-andrew@aj.id.au>
 <20190731053959.16293-4-andrew@aj.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731053959.16293-4-andrew@aj.id.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 03:09:58PM +0930, Andrew Jeffery wrote:
> phy-handle is necessary for the AST2600 which separates the MDIO
> controllers from the MAC.
> 
> I've tried to minimise the intrusion of supporting the AST2600 to the
> FTGMAC100 by leaving in place the existing MDIO support for the embedded
> MDIO interface. The AST2400 and AST2500 continue to be supported this
> way, as it avoids breaking/reworking existing devicetrees.
> 
> The AST2600 support by contrast requires the presence of the phy-handle
> property in the MAC devicetree node to specify the appropriate PHY to
> associate with the MAC. In the event that someone wants to specify the
> MDIO bus topology under the MAC node on an AST2400 or AST2500, the
> current auto-probe approach is done conditional on the absence of an
> "mdio" child node of the MAC.
> 
> Signed-off-by: Andrew Jeffery <andrew@aj.id.au>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
