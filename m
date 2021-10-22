Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE0F437EBB
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 21:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbhJVTkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 15:40:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53506 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234090AbhJVTkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 15:40:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=npLDeeKezSJSIPo+3xxZFs91kdmA9Ool3n0yzTC39Zk=; b=A3Mu7CxAkCqTs+j9mOUyUb5qtA
        zhHzOuo8x4pgvXeT1mjJBxbFmky0uvVpNI2Pe3S++8Z2DlOQ4Ps47HG9Jz9rZw1T3y2+UKT/dzAqC
        oZndolJx8Zc70M2l/59ZvERTOzbIhXnknWw1oYHwC1TPVnIfqvHX6WlamuuOgrv/AdQI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1me0MS-00BQJj-KZ; Fri, 22 Oct 2021 21:37:52 +0200
Date:   Fri, 22 Oct 2021 21:37:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [net-next PATCH 1/2] dt-bindings: net: macb: Add mdio bus child
 node
Message-ID: <YXMTEDopXc5tDZ3z@lunn.ch>
References: <20211022163548.3380625-1-sean.anderson@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022163548.3380625-1-sean.anderson@seco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 22, 2021 at 12:35:47PM -0400, Sean Anderson wrote:
> This adds an optional mdio bus child node. If present, the mac will
> look for PHYs there instead of directly under the top-level node. This
> eliminates any ambiguity about whether child nodes are PHYs, and allows
> the MDIO bus to contain non-PHY devices.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
