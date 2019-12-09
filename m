Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54DAE1172FB
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 18:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfLIRmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 12:42:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:42758 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbfLIRmA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 12:42:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BEG7NwPdOZ/b+xumDPs+d59K6Y+Hea620AYSvbvYYnY=; b=RlUtXD2/kjU8GlCtb1lXgzjjch
        vMyMySDfEv0FP8x9X/BVjWpV1EHBY8kQ+105gvOJoF4q+zbp9qy3M6aN1FDwSSrcojeHP7Tnd8Fa3
        6vZDO19YhaFp3E+9JNyhEHV7+HKiZoUXiZccj78EhFwCsSc8x4V1EfgHt2i5NkxxGnpQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ieN2g-0006pD-Ol; Mon, 09 Dec 2019 18:41:54 +0100
Date:   Mon, 9 Dec 2019 18:41:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     FlorianFainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sfp: avoid tx-fault with Nokia GPON module
Message-ID: <20191209174154.GF9099@lunn.ch>
References: <E1ieJGx-0003kX-4p@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ieJGx-0003kX-4p@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 01:40:23PM +0000, Russell King wrote:
> The Nokia GPON module can hold tx-fault active while it is initialising
> which can take up to 60s. Avoid this causing the module to be declared
> faulty after the SFP MSA defined non-cooled module timeout.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
