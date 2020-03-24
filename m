Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71CDB1912A8
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgCXOSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:18:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54584 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbgCXOSb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 10:18:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iiudcXcV5KyZKgZHu4DdR8/Rz3lxKSvcnYxJGgGLNHI=; b=emybY5hntf2hX7KxySg5FN3rbI
        NywcrVB8rqJzSAX8yAEzxLXCt4Ywgz8Ds96mpZdsocDc/MzqyOyK+DJOGn6ICcVrRplifWwtasQM2
        r6fNpRaZaP04Tg0a+DMJL1zZoKeLeloZtfDXP55CF9Nq4fRsx15mNjR+rKtxNEqqQhu8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGkNx-0002gw-AO; Tue, 24 Mar 2020 15:18:29 +0100
Date:   Tue, 24 Mar 2020 15:18:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, f.fainelli@gmail.com,
        hkallweit1@gmail.com, antoine.tenart@bootlin.com
Subject: Re: [PATCH net-next] net: phy: mscc: consolidate a common RGMII
 delay implementation
Message-ID: <20200324141829.GB14512@lunn.ch>
References: <20200324141358.4341-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324141358.4341-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 24, 2020 at 04:13:58PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> It looks like the VSC8584 PHY driver is rolling its own RGMII delay
> configuration code, despite the fact that the logic is mostly the same.
> 
> In fact only the register layout and position for the RGMII controls has
> changed. So we need to adapt and parameterize the PHY-dependent bit
> fields when calling the new generic function.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
