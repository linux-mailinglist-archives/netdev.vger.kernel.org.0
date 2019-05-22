Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17C3426A70
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729620AbfEVTDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:03:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:43656 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728533AbfEVTDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:03:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XJoZtimdgB+EH9wdXCPAmcGFb9M+rwAdu+b7oSmUxzQ=; b=xjGfVFQofgRgHwOpVt5sLLBO+j
        VCGnhwVQW1s+hZDqyCTydlyWtF5ek1RTRfwkziyFaXf4/8LpcQyJbU9VsEc4GkW0fHJ3Kaw8uwnD/
        UECk+pY+771l2U42JKLtYKCwLGmffACcs2fGfg9eMLIgn06pBFFXJWqTqq5lQzP1nJCw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTWW6-0002Iy-Pk; Wed, 22 May 2019 21:03:10 +0200
Date:   Wed, 22 May 2019 21:03:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Trent Piepho <tpiepho@impinj.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2 6/8] net: phy: dp83867: IO impedance is not
 dependent on RGMII delay
Message-ID: <20190522190310.GD7281@lunn.ch>
References: <20190522184255.16323-1-tpiepho@impinj.com>
 <20190522184255.16323-6-tpiepho@impinj.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522184255.16323-6-tpiepho@impinj.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 06:43:25PM +0000, Trent Piepho wrote:
> The driver would only set the IO impedance value when RGMII internal
> delays were enabled.  There is no reason for this.  Move the IO
> impedance block out of the RGMII delay block.
> 
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Trent Piepho <tpiepho@impinj.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
