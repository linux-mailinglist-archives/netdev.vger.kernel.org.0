Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C24F7F6AB1
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 19:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfKJSKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 13:10:50 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59298 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbfKJSKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 13:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uoIsWos++SmtbIA7hwvlMOHj/zYK8C6DT1rPUxXTIGE=; b=1qtrHNxcYsfPc0D/aRkzcoMxTy
        BgXSrAb/RmdqOtFDc4jQ39AXCc+MbO/4bNj3ZgPCMt+Sb0m212QsmiwtWi1rmEp05VnqII0HFRMBZ
        cSruK/1WW2y9pzUEDV/ND5c3xdf4y/hJAxJ6olKYZdQDf26x8+UQLs1sN0rg4SIaxt2k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTrfi-0007Fm-8g; Sun, 10 Nov 2019 19:10:46 +0100
Date:   Sun, 10 Nov 2019 19:10:46 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 06/17] net: sfp: parse SFP power requirement
 earlier
Message-ID: <20191110181046.GR25889@lunn.ch>
References: <20191110140530.GA25745@shell.armlinux.org.uk>
 <E1iTnrT-0005AH-1u@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iTnrT-0005AH-1u@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 10, 2019 at 02:06:39PM +0000, Russell King wrote:
> Parse the SFP power requirement earlier, in preparation for moving the
> power level setup code.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

