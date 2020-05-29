Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A431E8029
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 16:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgE2OZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 10:25:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56786 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726999AbgE2OZ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 10:25:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/KEt914Lfmg/kfLLPvZ372pybumtNMS1Z24gsTSrvcY=; b=2UJTo3w2BDgz+9WoW2+7CCTBSw
        M7HT3X8S25vF+lAfHvZcp9GXy8CegZ4nQpQYTPu7MChW3hvu0JNkCp8RMUJ3WqB09qoh6dhERn0R1
        ceKJ4SAY+GF5vMdbA9wemWaFzj9y+VADg8kRJXW3jvgSj1+G64/ieFq3KCNNtT8Z9hRk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jefxB-003eSx-IU; Fri, 29 May 2020 16:25:45 +0200
Date:   Fri, 29 May 2020 16:25:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: marvell: unlock after
 phy_select_page() failure
Message-ID: <20200529142545.GB869823@lunn.ch>
References: <20200529100207.GB1304852@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529100207.GB1304852@mwanda>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 01:02:07PM +0300, Dan Carpenter wrote:
> We need to call phy_restore_page() even if phy_select_page() fails.
> Otherwise we are holding the phy_lock_mdio_bus() lock.  This requirement
> is documented at the start of the phy_select_page() function.
> 
> Fixes: a618e86da91d ("net : phy: marvell: Speedup TDR data retrieval by only changing page once")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
