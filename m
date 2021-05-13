Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F193B37F7C6
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 14:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbhEMMYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 08:24:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38584 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230526AbhEMMX7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 08:23:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xLMVguoQ+WwOwbw4bvkvN9oAzYjx5YfN/vAa8NY+De0=; b=ZT9uF500ybpTTuInRkFL7teEGD
        PCVXeFgFzNCPWAVHQlo1zfnrd0JaRn8pvUIXEj1aNs4DkQAgiDC574zs2uVij2gonP2ITdxQQMZj2
        AWX/jY1FQRHIaMYqESpGaGr4oB2+xhIyAIXzd4O0O+XmB/pphqVrzF6o5vLgaI50PgG4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lhAMS-0043eQ-9c; Thu, 13 May 2021 14:22:40 +0200
Date:   Thu, 13 May 2021 14:22:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, f.fainelli@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] net: mdio: octeon: Fix some double free issues
Message-ID: <YJ0aEOiH8FLYtphx@lunn.ch>
References: <7adc1815237605a0b774efb31a2ab22df51462d3.1620890610.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7adc1815237605a0b774efb31a2ab22df51462d3.1620890610.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 13, 2021 at 09:24:55AM +0200, Christophe JAILLET wrote:
> 'bus->mii_bus' has been allocated with 'devm_mdiobus_alloc_size()' in the
> probe function. So it must not be freed explicitly or there will be a
> double free.
> 
> Remove the incorrect 'mdiobus_free' in the error handling path of the
> probe function and in remove function.
> 
> Suggested-By: Andrew Lunn <andrew@lunn.ch>
> Fixes: 35d2aeac9810 ("phy: mdio-octeon: Use devm_mdiobus_alloc_size()")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
