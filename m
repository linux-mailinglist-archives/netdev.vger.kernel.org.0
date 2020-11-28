Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC312C6E6E
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 03:27:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbgK1CXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 21:23:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729695AbgK1BgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 20:36:17 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48F462224C;
        Sat, 28 Nov 2020 01:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606526870;
        bh=E/3+tSH78Oi7cmPtL/PZF2uymXTd8zQjg8NtS/x/fgE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=y70oIjaEYrlm9EmKai368c2Aguaiq7Nnb6/g0NKHLp3hh9/DQ7GyZdmNunHT21DBt
         pqbxhsVNBAbsIR59zwX1wA2EMnH7Uh5BRT4JLm9kRhPs8vKDsnQ83jH/UaMciwYhD2
         1pFK1J+RHDlzgukD3PhUM0u9ZEqaaQ9uMKmYrMHQ=
Date:   Fri, 27 Nov 2020 17:27:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v1] net: phy: micrel: fix interrupt handling
Message-ID: <20201127172746.330ad772@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201127151106.y34rmjc6xysbv2re@skbuf>
References: <20201127123621.31234-1-o.rempel@pengutronix.de>
        <20201127144545.GO2073444@lunn.ch>
        <20201127151106.y34rmjc6xysbv2re@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Nov 2020 15:11:08 +0000 Ioana Ciornei wrote:
> On Fri, Nov 27, 2020 at 03:45:45PM +0100, Andrew Lunn wrote:
> > On Fri, Nov 27, 2020 at 01:36:21PM +0100, Oleksij Rempel wrote:  
> > > After migration to the shared interrupt support, the KSZ8031 PHY with
> > > enabled interrupt support was not able to notify about link status
> > > change.
> > > 
> > > Fixes: 59ca4e58b917 ("net: phy: micrel: implement generic .handle_interrupt() callback")
> > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>  
> > 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > 
> > I took a quick look at all the other patches like this. I did not spot
> > any other missing the !
> > 
> >     Andrew  
> 
> Uhh, really sorry for this!
> 
> Thanks for double checking.

Applied, thanks!
