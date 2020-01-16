Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9C713FAE2
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 21:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388201AbgAPUwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 15:52:07 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43154 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726994AbgAPUwH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 15:52:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cL8sSq+085xm0aYn+d1KDCSQUmsQXZOzpRIBQ4nDL+k=; b=uD0iZoJ3OXNAwnBdgI5lG0O99I
        NXyzsYWMj5m2Zi2RvGWIoTL+DkSfva4SPttKuGydygHsCMFw/NxhW5ob4eXgW8wmuAUbOuI1QNjYX
        5nHVwb73w+qMawyC6YDTTKKqvTdoxG2rHcebaw/E1ub3qfIrHl8mw/0WJ/35DIU0WFEM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1isC7Y-0000rC-K2; Thu, 16 Jan 2020 21:52:04 +0100
Date:   Thu, 16 Jan 2020 21:52:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, linux@armlinux.org.uk,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandru.marginean@nxp.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next] net: dsa: felix: Don't error out on disabled
 ports with no phy-mode
Message-ID: <20200116205204.GO2475@lunn.ch>
References: <20200116184153.12301-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116184153.12301-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 16, 2020 at 08:41:53PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The felix_parse_ports_node function was tested only on device trees
> where all ports were enabled. Fix this check so that the driver
> continues to probe only with the ports where status is not "disabled",
> as expected.
> 
> Fixes: bdeced75b13f ("net: dsa: felix: Add PCS operations for PHYLINK")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
