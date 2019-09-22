Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE06FBA344
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 18:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388128AbfIVQxk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 12:53:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59202 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387815AbfIVQxk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Sep 2019 12:53:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AZ3KxnqGfQ/4Sd0Yw3qEdImhfH+hLhRzkk0V+VmfhCc=; b=b5PUg/Bm1yxeU7wzrLbq/+M5kf
        m/pSV3eR5asaaFQsDZZXI8x+iTf1DRGrixOgpXxZ/EPIXSkYgvAWn8wRlVZm56PGK5++lM6QOuyim
        zWsaTQPOyKH9TrpDYJs5s+uGlXIw9VnyL4REgwPCVgpUpQjRuiCAM8Da5UAWDTo0p0dw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iC579-0007Qf-Ow; Sun, 22 Sep 2019 18:53:35 +0200
Date:   Sun, 22 Sep 2019 18:53:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        tinywrkb <tinywrkb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 0/4] Attempt to fix regression with AR8035 speed downgrade
Message-ID: <20190922165335.GE27014@lunn.ch>
References: <20190922105932.GP25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190922105932.GP25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 22, 2019 at 11:59:32AM +0100, Russell King - ARM Linux admin wrote:
> Hi,
> 
> tinywrkb, please can you test this series to ensure that it fixes
> your problem - the previous version has turned out to be a non-starter
> as it introduces more problems, thanks!
> 
> The following series attempts to address an issue spotted by tinywrkb
> with the AR8035 on the Cubox-i2 in a situation where the PHY downgrades
> the negotiated link.

Hi Russell

This all looks sensible.

One things we need to be careful of, is this is for net and so stable.
But only some of the patches have fixes-tags. I don't know if we
should add fixes tags to all the patches, just to give back porters a
hint that they are all needed? It won't compile without the patches,
so at least it fails safe.

   Andrew
