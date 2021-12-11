Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E9147164D
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 22:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhLKVAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 16:00:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51010 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229489AbhLKVAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Dec 2021 16:00:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+Z/izRbjaaTaao1T4X8P+IrDXsjVDOIZN0b1oAKxqts=; b=KFZybSFYvxjqGmjifozFhiVE4Z
        RsbhUC5C8FY9A9fqRrVoq/sBeBGSB0TfhGzZfOaIlfD43GXSGM1RrIt4rUfn3HxS0CfZmDhsDMCtI
        GZ+9KuSGLO76xPnQc53S+9OF90C2DrCMaOnpttsws28gtCIt7gNJZc8xHEc3WIQJczA8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mw9U0-00GHkG-KW; Sat, 11 Dec 2021 22:00:40 +0100
Date:   Sat, 11 Dec 2021 22:00:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     alexandru.tachici@analog.com
Cc:     o.rempel@pengutronix.de, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, robh+dt@kernel.org
Subject: Re: [PATCH v4 3/7] net: phy: Add BaseT1 auto-negotiation registers
Message-ID: <YbUReGxNuAwEIzfF@lunn.ch>
References: <20211210110509.20970-1-alexandru.tachici@analog.com>
 <20211210110509.20970-4-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211210110509.20970-4-alexandru.tachici@analog.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 01:05:05PM +0200, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Added BASE-T1 AN advertisement register (Registers 7.514, 7.515, and
> 7.516) and BASE-T1 AN LP Base Page ability register (Registers 7.517,
> 7.518, and 7.519).
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
