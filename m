Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5FD18BBBD
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 16:58:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgCSP6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 11:58:16 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45390 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727377AbgCSP6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 11:58:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yE1NFJcE5krlUa9FgrGPKy80AyO4EMe719xrJPy3izQ=; b=6AH3qy+lM+hJVUzQ/QzW1k0zs2
        sWHm+MvrdO5G8ZnZJz5uMC38705xWIGXbVwWqOiWy8BNRZXzSPi46TkCzzKzAO1FdE9Jv7bRUdN9/
        4AI1ZsgFTy06ZBaN62K64/LFLlbnRPJVeTkTMsn/FH15i7gLkASSLiZgodITmEzGMsRs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jExYj-0007YU-2o; Thu, 19 Mar 2020 16:58:13 +0100
Date:   Thu, 19 Mar 2020 16:58:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/2] net: phy: mscc: add support for RGMII
 MAC mode
Message-ID: <20200319155813.GD27807@lunn.ch>
References: <20200319141958.383626-1-antoine.tenart@bootlin.com>
 <20200319141958.383626-2-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319141958.383626-2-antoine.tenart@bootlin.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 03:19:57PM +0100, Antoine Tenart wrote:
> This patch adds support for connecting VSC8584 PHYs to the MAC using
> RGMII.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

