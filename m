Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAA6CC203
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 19:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388625AbfJDRwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 13:52:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33166 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729291AbfJDRwc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 13:52:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GjkUemf66RqujS4OgGuAy5dPQA6zRNCF5j1XQ3wUVMY=; b=VasWnnOw3AyHtS1+AXv5gHlLDj
        3kvJwnGk1SLnzdV2L+VrxO9tcaYieelG98kNYtViuU/shmU6WWExUxluXlhpU2TpxJHUIOCUOWfDF
        TZR4YsBIi7i2ZpeD2272V+vRz6y72FfE/nyfBaAymupjlB5ldHTRCdnUheeVx0SOoRpQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iGRkf-0002dT-U3; Fri, 04 Oct 2019 19:52:25 +0200
Date:   Fri, 4 Oct 2019 19:52:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 2/4] net: phy: extract link partner advertisement
 reading
Message-ID: <20191004175225.GA9935@lunn.ch>
References: <20191004160525.GZ25745@shell.armlinux.org.uk>
 <E1iGQ5k-0001Qg-5X@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iGQ5k-0001Qg-5X@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 05:06:04PM +0100, Russell King wrote:
> Move reading the link partner advertisement out of genphy_read_status()
> into its own separate function.  This will allow re-use of this code by
> PHY drivers that are able to read the resolved status from the PHY.
> 
> Tested-by: tinywrkb <tinywrkb@gmail.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
