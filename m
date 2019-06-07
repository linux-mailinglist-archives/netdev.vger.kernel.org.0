Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB4138ACC
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 15:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfFGNAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 09:00:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35784 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727512AbfFGNAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 09:00:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=iIlLwUu02kfIWxrQEr828mn4J/QdjaW6PSFOu34hFBo=; b=4aqJRdCwL/I3zRQz4/2QoXCPXv
        IuBen0MkqoMrFDSxinU8AP0i4NzdnAXrA4YwcB3zwXkkK1xbQ7lc5ZPHOTirNUWeMZxDt/oOvWrfP
        2s64arE8KDv72qCpPDQsrOA559n/LqCt3B/oMX+WKeswBmvXGzny9hiKswtuyWpJE1A4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hZETe-0006wJ-AP; Fri, 07 Jun 2019 15:00:14 +0200
Date:   Fri, 7 Jun 2019 15:00:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     netdev@vger.kernel.org, netdev@vger.kernel-org,
        anders.roxell@linaro.org, davem@davemloft.net, sfr@canb.auug.org.au
Subject: Re: [PATCH net v3] net: phy: rename Asix Electronics PHY driver
Message-ID: <20190607130014.GL20899@lunn.ch>
References: <20190514105649.512267cd@canb.auug.org.au>
 <1559885854-15904-1-git-send-email-schmitzmic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559885854-15904-1-git-send-email-schmitzmic@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 07, 2019 at 05:37:34PM +1200, Michael Schmitz wrote:
> [Resent to net instead of net-next - may clash with Anders Roxell's patch
> series addressing duplicate module names]
> 
> Commit 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
> introduced a new PHY driver drivers/net/phy/asix.c that causes a module
> name conflict with a pre-existiting driver (drivers/net/usb/asix.c).
> 
> The PHY driver is used by the X-Surf 100 ethernet card driver, and loaded
> by that driver via its PHY ID. A rename of the driver looks unproblematic.
> 
> Rename PHY driver to ax88796b.c in order to resolve name conflict. 
> 
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
> Tested-by: Michael Schmitz <schmitzmic@gmail.com>
> Fixes: 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
