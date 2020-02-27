Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D63717222F
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 16:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgB0PYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 10:24:31 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:37038 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728205AbgB0PYb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 10:24:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZNyJGZGNQOnsKqhA9PaFG5s83F9H7391o7tmAahh0wU=; b=nb5LAGGzvLxSopaUohlVrZRsFK
        JpwXJAzZ9L3F1r8Ea7TzDmvIzaLepf2fq/omNUyuvqZPSCie4HUD2B8eTe5aEz+x2qCrst0tv76Tc
        dYZneCBJz6vVKZ5iKG/79dmhIiv941haM5tZYpuxJ4lC2kGbYRCmTEw2qqAfy5S+6hDQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j7L1Y-0005lA-2h; Thu, 27 Feb 2020 16:24:28 +0100
Date:   Thu, 27 Feb 2020 16:24:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] dpaa2-eth: add support for nway reset
Message-ID: <20200227152428.GE19662@lunn.ch>
References: <E1j7HrW-0004HW-Pz@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1j7HrW-0004HW-Pz@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 12:01:54PM +0000, Russell King wrote:
> Add support for ethtool -r so that PHY negotiation can be restarted.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
