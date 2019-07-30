Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 627DF7A96B
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbfG3NXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:23:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47634 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfG3NXG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 09:23:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rXRe9kHDGGLyA6ncp3ZI9KHQuqcnVK8NrDCC7iqaddA=; b=w6sW6BpyS5l6hMWAd9l8xOA83D
        H4NPG9IckFh697Pl9FN1XsESmkSY3d9IgHRS679ncIkR21uK/Zevu4ZNgYWSfH7NCP01kaGc7FYfZ
        KMTdhxY2Ec0urBfRCqMNodkUBet+58Cl5eZbFngzGr0R3XWr3Sw/zsGUbvaJ3Tq9aeV4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hsS5h-0007de-Fc; Tue, 30 Jul 2019 15:22:57 +0200
Date:   Tue, 30 Jul 2019 15:22:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 2/4] enetc: Add mdio bus driver for the PCIe
 MDIO endpoint
Message-ID: <20190730132257.GB28552@lunn.ch>
References: <1564479919-18835-1-git-send-email-claudiu.manoil@nxp.com>
 <1564479919-18835-3-git-send-email-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564479919-18835-3-git-send-email-claudiu.manoil@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 12:45:17PM +0300, Claudiu Manoil wrote:
> ENETC ports can manage the MDIO bus via local register
> interface.  However there's also a centralized way
> to manage the MDIO bus, via the MDIO PCIe endpoint
> device integrated by the same root complex that also
> integrates the ENETC ports (eth controllers).
> 
> Depending on board design and use case, centralized
> access to MDIO may be better than using local ENETC
> port registers.  For instance, on the LS1028A QDS board
> where MDIO muxing is required.  Also, the LS1028A on-chip
> switch doesn't have a local MDIO register interface.
> 
> The current patch registers the above PCIe endpoint as a
> separate MDIO bus and provides a driver for it by re-using
> the code used for local MDIO access.  It also allows the
> ENETC port PHYs to be managed by this driver if the local
> "mdio" node is missing from the ENETC port node.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
