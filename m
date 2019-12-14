Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8595D11EF40
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbfLNAeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:34:14 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:41283 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfLNAeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 19:34:14 -0500
Received: by mail-lf1-f67.google.com with SMTP id m30so531151lfp.8
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 16:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=AcKpSh1z8nexb80XCULmvBhMzvVCXcH0i/wbt+zGUhM=;
        b=lK+yU5+bFuHaU9D3W6qUlPNk8AOj4NREd87YAzkJ6aYmKJIM2/QYqq2R2hkOGh6KPv
         3q/yU7JUS23gE0olzVlBatTDM50fNZYaBjaETH23XoHylecROnklEkESAS76EpqdT70P
         /dhkb4vT36tbmylUCmYZ9ezX9UU9sSGYRvzSFHP2jltZ7CZ9jJA98BpxpjOg/VPdZtBU
         s4B5odIpY9nWRdp2NHwNJd0E5jt0TxsbYoldhf2oY3OljEOjMXmxmS6kBKVuKRLrSOTG
         n8LyAki+kY2hsM3UomuEMBjmQMEqdPdonVdNw7SMrCIUk0cFVSmhqYPUj1nExJ1eV935
         KxnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=AcKpSh1z8nexb80XCULmvBhMzvVCXcH0i/wbt+zGUhM=;
        b=czUGbFKL4dPP4OIf8N8yiyuvWerF1AxB71ZjFa9j6be/H/1FuO92B/70nX3Q94gG3d
         CQst5W68YeqxQ4gU99lUVfO/Zn0UUDRhHkM0bq3FGIgnzKEAl71PHdwU2gqCbfeoXSAL
         OgIF6ylCiWqC3eVzbfBFA8OfS+HRaUSKTprdLqABszjo0suuo2AD7EwgR3RlQEGVwmow
         a41NcH04k5itFWNNcznW4E8w8G+oXLqFvJYfRzARMzm1yJrROpnOTrCUBCRbts7XAC2e
         3cz0llombYbz/8T1rX1dLDdLOkFw2w8xI9N48pwqQdeYSbheAw70Pgdtrw/ZzAc4mrbN
         e2fg==
X-Gm-Message-State: APjAAAVpiafBcTxKmDpO0Qb5CDFD69YifHU8sgRJJvX7W+ZDPs74WUYg
        7WD6Z7eh5mjS0dXkqHul3WbD/A==
X-Google-Smtp-Source: APXvYqyPhtKh1Kb3nOzkfa72SVdezx6QGgtN1MFmoihXUZRaDylBiZhiVDUFt59vZIi5CyWD8Y4DKg==
X-Received: by 2002:ac2:4946:: with SMTP id o6mr10591734lfi.170.1576283651956;
        Fri, 13 Dec 2019 16:34:11 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z3sm5658532ljh.83.2019.12.13.16.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 16:34:11 -0800 (PST)
Date:   Fri, 13 Dec 2019 16:34:03 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Willy Tarreau <w@1wt.eu>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        maxime.chevallier@bootlin.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: marvell: mvpp2: phylink requires the link
 interrupt
Message-ID: <20191213163403.2a054262@cakuba.netronome.com>
In-Reply-To: <E1ieo41-00023K-2O@rmk-PC.armlinux.org.uk>
References: <E1ieo41-00023K-2O@rmk-PC.armlinux.org.uk>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Dec 2019 22:33:05 +0000, Russell King wrote:
> phylink requires the MAC to report when its link status changes when
> operating in inband modes.  Failure to report link status changes
> means that phylink has no idea when the link events happen, which
> results in either the network interface's carrier remaining up or
> remaining permanently down.
> 
> For example, with a fiber module, if the interface is brought up and
> link is initially established, taking the link down at the far end
> will cut the optical power.  The SFP module's LOS asserts, we
> deactivate the link, and the network interface reports no carrier.
> 
> When the far end is brought back up, the SFP module's LOS deasserts,
> but the MAC may be slower to establish link.  If this happens (which
> in my tests is a certainty) then phylink never hears that the MAC
> has established link with the far end, and the network interface is
> stuck reporting no carrier.  This means the interface is
> non-functional.
> 
> Avoiding the link interrupt when we have phylink is basically not
> an option, so remove the !port->phylink from the test.
> 
> Tested-by: Sven Auhagen <sven.auhagen@voleatech.de>
> Tested-by: Antoine Tenart <antoine.tenart@bootlin.com>
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Fixes: 4bb043262878 ("net: mvpp2: phylink support") ?

Seems like you maybe didn't want this backported to stable hence 
no fixes tag?

Please advise :)

> diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> index 111b3b8239e1..ef44c6979a31 100644
> --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> @@ -3674,7 +3674,7 @@ static int mvpp2_open(struct net_device *dev)
>  		valid = true;
>  	}
>  
> -	if (priv->hw_version == MVPP22 && port->link_irq && !port->phylink) {
> +	if (priv->hw_version == MVPP22 && port->link_irq) {
>  		err = request_irq(port->link_irq, mvpp2_link_status_isr, 0,
>  				  dev->name, port);
>  		if (err) {

