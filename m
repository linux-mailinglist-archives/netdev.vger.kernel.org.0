Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35E2F31A4CB
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 19:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbhBLSxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 13:53:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229611AbhBLSxq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 13:53:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA92364DCE;
        Fri, 12 Feb 2021 18:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613155985;
        bh=28+q91IXolOgYDBLbjpILE3azonyF8EsQxWpXxOihv8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sk67gmRabImpFk07ZTBcaLmJ1dqZOWHLWpl1Bk1gM1wGZDu8BhDolRkogEDcqoqp3
         +WOD0s9J4QWusNX7HWGFoN5DhsKKFNWbgBPw0A2Y7Da2RnM8jI6bsFvwmexvZO7TTF
         O+QXNiFWX55/hs4UZuAUPMsYIPgi3Jfa7j9mjHTrDEB9TziV7Nkd6f+7RjRcAp95Vp
         5ZIqDMuUn3ZPX2a8A/S9+CJ5a3s0LSTenTlJ80OzbaixA52zm/11D/jaYSr8TJuzy1
         +Y/Yyh8eQNGcH01YJqKYKcQE1Uovrq+5Bi6qFLhpWMeykwx2Ls4o2OwTUw3pMYL0qM
         9oyT6SeK/k9ow==
Date:   Fri, 12 Feb 2021 10:53:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>
Subject: Re: [PATCH net v1 1/3] net: phy: mscc: adding LCPLL reset to
 VSC8514
Message-ID: <20210212105303.5c653799@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
References: <20210212140643.23436-1-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Feb 2021 15:06:41 +0100 Bjarni Jonasson wrote:
> At Power-On Reset, transients may cause the LCPLL to lock onto a
> clock that is momentarily unstable. This is normally seen in QSGMII
> setups where the higher speed 6G SerDes is being used.
> This patch adds an initial LCPLL Reset to the PHY (first instance)
> to avoid this issue.
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> Fixes: e4f9ba642f0b ("net: phy: mscc: add support for VSC8514 PHY.")

Please make sure each commit builds cleanly with W=1 C=1.

This one appears to not build at all?
