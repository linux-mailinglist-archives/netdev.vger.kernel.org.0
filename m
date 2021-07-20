Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA573CFBCE
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 16:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239556AbhGTNei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 09:34:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36262 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237470AbhGTNb0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 09:31:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=aaNQCO3A0dZqrJVTgbLOhGXCXGsA3lJIwxtnnh2oyEI=; b=NDElhtN1BB0W2iJJzvmAWjfH3m
        cY40UMrtinRBZ7J0ieE+wMFbEsRzoszx+zbT/wyWVyrJM2rSWP/JtDoGfIiQkDkcYucrZKVL2BTJt
        9Igrduzw+ym1zWvHuSJN0uauA38RH6wEZ5NSB+fECxN5Xzp3m3ctYBxymcZv6lcdrgFw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5qTT-00E3w4-0j; Tue, 20 Jul 2021 16:11:55 +0200
Date:   Tue, 20 Jul 2021 16:11:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xu Liang <lxu@maxlinear.com>
Cc:     hkallweit1@gmail.com, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, vee.khee.wong@linux.intel.com,
        linux@armlinux.org.uk, hmehrtens@maxlinear.com,
        tmohren@maxlinear.com, mohammad.athari.ismail@intel.com
Subject: Re: [PATCH v6 2/2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YPbZqxJZiblKzoZi@lunn.ch>
References: <20210719053212.11244-1-lxu@maxlinear.com>
 <20210719053212.11244-2-lxu@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719053212.11244-2-lxu@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 01:32:12PM +0800, Xu Liang wrote:
> Add driver to support the Maxlinear GPY115, GPY211, GPY212, GPY215,
> GPY241, GPY245 PHYs. Separate from XWAY PHY driver because this series
> has different register layout and new features not supported in XWAY PHY.
> 
> Signed-off-by: Xu Liang <lxu@maxlinear.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
