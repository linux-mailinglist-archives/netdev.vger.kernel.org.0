Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDBD123067
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfLQPgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:36:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57642 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727729AbfLQPgD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 10:36:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tm3fmLbBBTdHXDC9vn1/2V/innrs6o/W/fYxX53gIgM=; b=AWMGw1xwUZiMbXo9ZewgSXNATm
        OqP9Hf3ESwb0MJl6Wj5uO2FzS/MBQtBkViQ6DEp586Sdxc1Rj9f3Ww4WJl0khWrjbiYCshwIYs2UX
        xi6HW8BeGIzAL0FqmoGJBQxkRt92/sRB1Ki/fBG12g6UiNKrfMAAuQ2m8qIxDFo7VzmY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ihEtD-0002Zy-D0; Tue, 17 Dec 2019 16:35:59 +0100
Date:   Tue, 17 Dec 2019 16:35:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 01/11] net: phy: remove redundant .aneg_done
 initialisers
Message-ID: <20191217153559.GI17965@lunn.ch>
References: <20191217133827.GQ25745@shell.armlinux.org.uk>
 <E1ihD40-0001yI-Ss@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1ihD40-0001yI-Ss@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 01:39:00PM +0000, Russell King wrote:
> Remove initialisers that set .aneg_done to genphy_aneg_done - this is
> the default for clause 22 PHYs, so the initialiser is redundant.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
