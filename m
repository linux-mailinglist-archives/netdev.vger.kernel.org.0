Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547E217836B
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 20:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731296AbgCCTx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 14:53:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44312 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730488AbgCCTx4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 14:53:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+CvvI/2HwUcAB5G1tkD0ZVwZNO9VNReiovnR1d/lREM=; b=P83qKlkGvvqLSKKkEUBPbZ13Li
        GxkKn0baMPoY7tJzcgS8hCnD6i+ypgx27GHPxiY0984AhaVdqZnUjs4I1rOaWekB+U4w31HI21M8d
        f6pcCTJudz5mGg9FD74WWCMQm0WcbQSsLJz+fGVZPvCiof+vKiOCGzVnq6Jk+gnrphYw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j9Dc0-0000KN-A8; Tue, 03 Mar 2020 20:53:52 +0100
Date:   Tue, 3 Mar 2020 20:53:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/3] net: phy: marvell10g: add mdix control
Message-ID: <20200303195352.GC1092@lunn.ch>
References: <20200303180747.GT25745@shell.armlinux.org.uk>
 <E1j9By6-0003pB-UH@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j9By6-0003pB-UH@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 06:08:34PM +0000, Russell King wrote:
> Add support for controlling the MDI-X state of the PHY.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Hi Russell, David

It would be nice to have Antoine test this before it get merged, but:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
