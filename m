Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F351E6F1E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 00:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437207AbgE1Wdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 18:33:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436867AbgE1Wdo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 18:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kRLYzle0qEcfSatzncZpKCD5/+kry5Fmoim4DyhTkgA=; b=EldCGzl9GFgGf8m3LheUwbMlxC
        /VVDX/V6KQNYgCWJBj++ARCsF6t9/VZlEDOhqOj+B/ODztUF/TdawECvkoboX9eCNZmA8kAjYWvj5
        JBcwoKcnHA9DghyIkE38yogfp0hPhq8cSzzGL75xtfGzuw02v6GccVXsqLxe092PHxmo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jeR5q-003aXn-JW; Fri, 29 May 2020 00:33:42 +0200
Date:   Fri, 29 May 2020 00:33:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V7 19/19] net: ks8851: Remove ks8851_mll.c
Message-ID: <20200528223342.GG853774@lunn.ch>
References: <20200528222146.348805-1-marex@denx.de>
 <20200528222146.348805-20-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528222146.348805-20-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 12:21:46AM +0200, Marek Vasut wrote:
> The ks8851_mll.c is replaced by ks8851_par.c, which is using common code
> from ks8851.c, just like ks8851_spi.c . Remove this old ad-hoc driver.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
