Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F40231C84
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 12:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgG2KJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 06:09:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgG2KJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 06:09:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F49DC061794;
        Wed, 29 Jul 2020 03:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=9VLx7XLhsIIS2PJl5PxWQxoij3g76m8f2RROcdU7zfY=; b=nBqrzgJcR0aO5Ce+T9pbh2c+X
        zmV1XVvZcxiZuLzb5NfQ5GmuOVFw3ZDqxFC4g52+HZcnS65k/aF2cN8bQtqLiSvwsQB/B3xDD99hh
        uUngJ6Zu9LOZRYpGlpgO7Zu37AmiI4f5eVlHfHYwdfTxlnRkJTIX/oS4cMCWq7BtnXg+/xpKjR11U
        FoGZ+7vdbG1cNWWjiWHXcSkDHHaZMhVgGm7afAKoVapHXmt6vM2iWpTcy00IVthd2kGuX/qd1n4Lc
        CgXcpA31KbQLEubPjhEhg08unOPdlqjGNzH1j632ODkfrOqAGEX50vfRDdE1QKyt0VM7qGlJ2YuNl
        vnHNTr4AA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45634)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1k0j1o-0005H2-Va; Wed, 29 Jul 2020 11:09:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1k0j1o-0005bG-GN; Wed, 29 Jul 2020 11:09:40 +0100
Date:   Wed, 29 Jul 2020 11:09:40 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: mvneta: fix comment about
 phylink_speed_down
Message-ID: <20200729100940.GY1551@shell.armlinux.org.uk>
References: <20200729174909.276590fb@xhacker.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729174909.276590fb@xhacker.debian>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 05:49:09PM +0800, Jisheng Zhang wrote:
> mvneta has switched to phylink, so the comment should look
> like "We may have called phylink_speed_down before".
> 
> Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>

Reviewed-by: Russell King <rmk+kernel@armlinux.org.uk>

> ---
> Since v1:
>   - drop patch2 which tries to avoid link flapping when changing mtu
>     I need more time on the change mtu refactoring.
> 
>  drivers/net/ethernet/marvell/mvneta.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 2c9277e73cef..c9b6b0f85bb0 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -3637,7 +3637,7 @@ static void mvneta_start_dev(struct mvneta_port *pp)
>  
>  	phylink_start(pp->phylink);
>  
> -	/* We may have called phy_speed_down before */
> +	/* We may have called phylink_speed_down before */
>  	phylink_speed_up(pp->phylink);
>  
>  	netif_tx_start_all_queues(pp->dev);
> -- 
> 2.28.0.rc0
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
