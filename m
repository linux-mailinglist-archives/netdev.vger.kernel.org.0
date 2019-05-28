Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A35D2CA43
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 17:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfE1PVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 11:21:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35664 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726719AbfE1PVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 11:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dj5bcvP5XXVnFbmP3yk3M7WSps4eDTjmZZDNAyLwfFI=; b=AehTb5i6YpUuHATo2TJyqd28Go
        fa92EA9YmgJrI8+PaedNrO50WEAd0EfucJMX5mORuj8w+YSqqVhABBDuMTjpd44XXjYS49psDkAdR
        0I6fKmzujaiUEgVSjAWiFE39FS/1XExUtYpvrOM0c0n+x0Xvltz9YuRLYEuSm7gmsw0k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVdv1-0007rN-2R; Tue, 28 May 2019 17:21:39 +0200
Date:   Tue, 28 May 2019 17:21:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] net: sfp: remove sfp-bus use of netdevs
Message-ID: <20190528152139.GL18059@lunn.ch>
References: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
 <E1hVYrT-0005ZO-Nz@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1hVYrT-0005ZO-Nz@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 10:57:39AM +0100, Russell King wrote:
> The sfp-bus code now no longer has any use for the network device
> structure, so remove its use.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
