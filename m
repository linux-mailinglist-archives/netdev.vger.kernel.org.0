Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C5E161632
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 16:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgBQPaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 10:30:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728292AbgBQPai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 10:30:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZqCsK9WpL7hYGvHC1Si6X9RclQ+pdX4CLpRu3V2wUfo=; b=Tx5/9Z592EPYVeVU1jZteqzyuC
        IbaZaicU2+hftxYtFfqHCcr8sHGqM5LcymkzfxZ9gpIJiYxYZqbQMfMh+MaVkyUMMojAza8/gjIYq
        jgCjl4y4eLkoOjRUb+189EDlnJBdNj3RCXAl/LFCtyheegboB1ODmZGndjXrOoiCg+1o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j3iLw-0005Lq-R5; Mon, 17 Feb 2020 16:30:32 +0100
Date:   Mon, 17 Feb 2020 16:30:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH devicetree 4/4] arm64: dts: fsl: ls1028a: enable switch
 PHYs on RDB
Message-ID: <20200217153032.GF31084@lunn.ch>
References: <20200217144414.409-1-olteanv@gmail.com>
 <20200217144414.409-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217144414.409-5-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 04:44:14PM +0200, Vladimir Oltean wrote:
> From: Claudiu Manoil <claudiu.manoil@nxp.com>
> 
> Link the switch PHY nodes to the central MDIO controller PCIe endpoint
> node on LS1028A (implemented as PF3) so that PHYs are accessible via
> MDIO.
> 
> Enable SGMII AN on the Felix PCS by telling PHYLINK that the VSC8514
> quad PHY is capable of in-band-status.
> 
> The PHYs are used in poll mode due to an issue with the interrupt line
> on current revisions of the LS1028A-RDB board.
> 
> Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
> Signed-off-by: Alex Marginean <alexandru.marginean@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
