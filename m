Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68BC3D3AE0
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 15:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbhGWM04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 08:26:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42302 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232851AbhGWM0z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 08:26:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kp9/hrLWlzboWqshpLU+HHX29zRctIDSVcKMaAgsnEg=; b=UHterZXPd6SqZm6uNcqTvybK6h
        pHBoEPnfnMD0/ohU3NLLm1oqQTpfahkFWxBht8+4zIAxxR4aCRIJnD2LWJX8UhJn509Dzp2+h87XH
        oDlMuNZNVHClAWh8mse+FvlPHeNpj/C9izwAXFlxSqnxLIhcXGxZgUyiOekI5aTS8/k0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m6utU-00EUif-NL; Fri, 23 Jul 2021 15:07:12 +0200
Date:   Fri, 23 Jul 2021 15:07:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     lxu@maxlinear.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: Remove unused including <linux/version.h>
Message-ID: <YPq/AGrCS+s7Qicj@lunn.ch>
References: <1627036707-73334-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1627036707-73334-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 06:38:27PM +0800, Jiapeng Chong wrote:
> From: chongjiapeng <jiapeng.chong@linux.alibaba.com>
> 
> Eliminate the follow versioncheck warning:
> 
> ./drivers/net/phy/mxl-gpy.c: 9 linux/version.h not needed.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: chongjiapeng <jiapeng.chong@linux.alibaba.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
