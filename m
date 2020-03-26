Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFD91194D64
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 00:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbgCZXjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 19:39:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60458 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727345AbgCZXjD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 19:39:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LAeGIew8GG9xTFMtmWVgsw7oB/73mcRhXbstdxe+lU4=; b=GZYMqryvpqPz7dQmZ0kdiRn6QP
        dV/pWSmJtpvdKWEmIWATMHfjKBkEVpBxeKk2Zl5KjW7BZhSh6DXqxJRBAeXGxlAXYsuw+sncAkoiC
        ijIhkBNu1uECHn42HQ4YMSpIdfdtyZI/9D6AY/bBonDFKwJFzQAouLHXLQsbMuLALij4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHc5T-0004SQ-EX; Fri, 27 Mar 2020 00:38:59 +0100
Date:   Fri, 27 Mar 2020 00:38:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: phy: don't touch suspended flag if there's
 no suspend/resume callback
Message-ID: <20200326233859.GH3819@lunn.ch>
References: <313dae57-8c05-a82b-ea87-a0822e9462f0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <313dae57-8c05-a82b-ea87-a0822e9462f0@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 06:58:24PM +0100, Heiner Kallweit wrote:
> So far we set phydev->suspended to true in phy_suspend() even if the
> PHY driver doesn't implement the suspend callback. This applies
> accordingly for the resume path. The current behavior doesn't cause
> any issue I'd be aware of, but it's not logical and misleading,
> especially considering the description of the flag:
> "suspended: Set to true if this phy has been suspended successfully"
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
