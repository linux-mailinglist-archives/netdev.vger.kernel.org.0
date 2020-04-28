Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B551BCEA6
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgD1V32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:29:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58054 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgD1V32 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 17:29:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uABev7ksk/0LGLL6iZYY0qzPu2ypUoSvYM+d38tXkO4=; b=tmwLjMTI8z7U5RVmyDF9p85bjQ
        Pvb82bC+E3tqss6iIHRFCYujnpZIqR/Cyf15qRpdykkROC7zTGwfXb8AkNxklkflQcEFNcRP0qmZs
        ZVMRB7YWeWBQ1Bd4tTbPD20poZvpAK8H4JlK+BSBaifUyqqnEKbr/pJPsSfSbZQk7dYs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jTXnC-000ABM-2n; Tue, 28 Apr 2020 23:29:26 +0200
Date:   Tue, 28 Apr 2020 23:29:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 4/4] net: phy: bcm54140: add second PHY ID
Message-ID: <20200428212926.GE30459@lunn.ch>
References: <20200428210854.28088-1-michael@walle.cc>
 <20200428210854.28088-4-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200428210854.28088-4-michael@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 11:08:54PM +0200, Michael Walle wrote:
> This PHY have to PHY IDs depending on its mode. Adjust the mask so that
> it includes both IDs.

Hi Michael

I don't have a strong opinion, but maybe list it as two different
PHYs? I do sometimes grep for PHY IDs, and that would not work due to
the odd mask.

    Andrew
