Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53D010489A
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 03:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726351AbfKUCkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 21:40:19 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48838 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfKUCkT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 21:40:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1ng35hBhaUDBYTom+nDA0Ti/FTfGwJn/479YyUYhNSM=; b=OjJrvknUEWPt0PquoxRmbHm5qI
        PzjBHEXnSknN1ncsQNkLj41h3elVPFgWsVyst52LEuHULVW/f5ivzKh4SUjJX9QDgM0fsmMGw8QSD
        hNY8apzS4cmOqXImzg9oyaWh3Och7CtMnZFuFgwlBE5jIO1eYBuefQoUBDzcf3ViV1ho=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iXcKd-00075Q-J4; Thu, 21 Nov 2019 03:36:31 +0100
Date:   Thu, 21 Nov 2019 03:36:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: sfp: soft status and control support
Message-ID: <20191121023631.GJ18325@lunn.ch>
References: <E1iXP7P-0006DS-47@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1iXP7P-0006DS-47@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 12:29:59PM +0000, Russell King wrote:
> Add support for the soft status and control register, which allows
> TX_FAULT and RX_LOS to be monitored and TX_DISABLE to be set.  We
> make use of this when the board does not support GPIOs for these
> signals.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
