Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805241AD243
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 23:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgDPVyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 17:54:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42718 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgDPVyW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Apr 2020 17:54:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sJoGlhke6RR1kM1TPJ0UiaTv4A4MkV9oORpm3epxYVo=; b=nZ3mWs5Mhk/fuDnxYopkcIKFaE
        LshpNurBHLFjJUZxbiuJacFvfKjdEEOgJeVcPm7Rrn1WS20bJJ8PUwAXd+IKXuBFVpnS3sWr91Hfr
        G2BtgK95aGgvhkCtY0nDAau4JvHXufNdeHebUHj4R4BqodB35M2iPaivoSO7q07zPp6k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jPCSa-0039j7-Qz; Thu, 16 Apr 2020 23:54:12 +0200
Date:   Thu, 16 Apr 2020 23:54:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jernej Skrabec <jernej.skrabec@siol.net>
Cc:     robh+dt@kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux@armlinux.org.uk, mripard@kernel.org,
        linux-kernel@vger.kernel.org, wens@csie.org, lee.jones@linaro.org,
        davem@davemloft.net, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/4] net: mfd: AC200 Ethernet PHY
Message-ID: <20200416215412.GD744226@lunn.ch>
References: <20200416185758.1388148-1-jernej.skrabec@siol.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416185758.1388148-1-jernej.skrabec@siol.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 08:57:54PM +0200, Jernej Skrabec wrote:
> This is attempt to support Ethernet PHY on AC200 MFD chip. I'm sending
> this as RFC because I stumbled on a problem how to properly describe it
> in DT. Proper DT documentation will be added later, once DT issue is
> solved.
> 
> Before Ethernet PHY can be actually used, few things must happen:
> 1. 24 MHz clock must be enabled and connected to input pin of this
>    chip. In this case, PWM is set to generate 24 MHz signal with 50%
>    duty cycle.
> 2. Chip must be put out of reset through I2C
> 3. Ethernet PHY must be enabled and configured through I2C

Hi Jernej

This is going to be interesting to describe in DT.

At what point does the PHY start responding to MDIO request? In
particular, you can read the ID registers 2 and 3? You list above what
is needed to make it usable. But we are also interested in what is
required to make is probe'able on the MDIO bus. We have more
flexibility if we can first probe it, and then later make it usable.

Thanks
	Andrew
