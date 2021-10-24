Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31CE438B73
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 20:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhJXShQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 14:37:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229638AbhJXShQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 14:37:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IJ3ZoB4X6/oaDV2YHnsOAokbltPLJxapNXoUvRj7gDc=; b=nDnQPUNvBQgHqQOXF8Wd1L6KmK
        EsOTUpzMB8Me3M9hk/Ni4GuJb8zV7AkX5eCaAUpfCeZgfCVNJQZlrXHebL4JiX3Z1mVJIorIi3Y4p
        ICecdYET7ThYx40Y3TJM3iJ0YTSAINwI/bbkXZZXQDWsOsQ8lcG8zLR1Z3NCZxDbd6Ak=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1meiKZ-00Ba1O-8j; Sun, 24 Oct 2021 20:34:51 +0200
Date:   Sun, 24 Oct 2021 20:34:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v7 11/14] net: phy: add qca8081 config_init
Message-ID: <YXWnS7inUyE0vvp6@lunn.ch>
References: <20211024082738.849-1-luoj@codeaurora.org>
 <20211024082738.849-12-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024082738.849-12-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 04:27:35PM +0800, Luo Jie wrote:
> Add the qca8081 phy driver config_init function, which includes:
> 1. Enable fast restrain.
> 2. Add 802.3az configurations.
> 3. Initialize ADC threshold as 100mv.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
