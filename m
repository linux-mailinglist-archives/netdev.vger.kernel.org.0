Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9EA2CA35
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 17:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfE1PTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 11:19:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35634 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbfE1PTi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 11:19:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SzCOtUFWXHaLUkBYCJCjFY05InJHenOWnyvApt/2S3w=; b=pe6hS6yPWnac4925DpGOS7mh38
        CxKNM1bgClGgsjv4mPjk75m9Az2NSJrh3twcB1GjQ/TXTF1O9Ahlc48AyG4CemErzFyVk+LMLJDaU
        f3vWJDhlwPyeWBLTc32S3U8yCXnL5T2c1jmy0UTbxIId36bsglW9M3jXmCmkthuOfRyM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVdt0-0007mE-Dg; Tue, 28 May 2019 17:19:34 +0200
Date:   Tue, 28 May 2019 17:19:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/5] net: phylink: remove netdev from phylink
 mii ioctl emulation
Message-ID: <20190528151934.GJ18059@lunn.ch>
References: <20190528095639.kqalmvffsmc5ebs7@shell.armlinux.org.uk>
 <E1hVYr8-0005Yu-GI@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1hVYr8-0005Yu-GI@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 10:57:18AM +0100, Russell King wrote:
> The netdev used in the phylink ioctl emulation is never used, so let's
> remove it.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
