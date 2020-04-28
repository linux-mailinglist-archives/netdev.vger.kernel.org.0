Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C1F1BCEC8
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbgD1VdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:33:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58074 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgD1VdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 17:33:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SSBdsfKzoa+pWRpdd/TC5A8IAtxlP8hPJ+9MlzTHrsY=; b=v7N91KKpRXmQ7QSDM7Gt6U048m
        iuAl8UJIyp7w0edHieu5uuaDgnoinu44ykgOOEHr3yEkkHYw8g7qBL3B2WX1Hc1jumsIMUhNe3VWO
        cVrvY1UkGnPmmmt08uaZBLCRb/UMmFsIvS5amnvobPsfMz4CknDV/Lj1uinYvhEJn138=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTXr0-000AEG-1L; Tue, 28 Apr 2020 23:33:22 +0200
Date:   Tue, 28 Apr 2020 23:33:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next] net: phy: at803x: add downshift support
Message-ID: <20200428213322.GF30459@lunn.ch>
References: <20200428211502.1290-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428211502.1290-1-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:15:02PM +0200, Michael Walle wrote:
> The AR8031 and AR8035 support the link speed downshift. Add driver
> support for it. One peculiarity of these PHYs is that it needs a
> software reset after changing the setting, thus add the .soft_reset()
> op and do a phy_init_hw() if necessary.
> 
> This was tested on a custom board with the AR8031.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
