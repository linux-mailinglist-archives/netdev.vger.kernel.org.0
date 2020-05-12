Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0211CE9CA
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbgELAvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:51:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54816 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbgELAvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 20:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LShQuoqlZ+XLoTKllfhTPEDKn/0lzvkQf/MfOEIVBaE=; b=DtZzqbeE+FFjojDA3LJLRpCThT
        66KM3heiH6q568GJJ2V/Rg0QbTzobGqpycPY8oXv3C89eaUidkLgKjarp8jpu9XB4isXGBYifE5d7
        GKBMdAicRpYPGL0A22+W7dqgvUJ6yxJd8QJ7FkBUQFjscWfpaVjA7+rMDmlzN8ioDnQE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jYJ8g-001vCF-80; Tue, 12 May 2020 02:51:18 +0200
Date:   Tue, 12 May 2020 02:51:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Doug Berger <opendmb@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] net: ethernet: introduce phy_set_pause
Message-ID: <20200512005118.GE409897@lunn.ch>
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-4-git-send-email-opendmb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1589243050-18217-4-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 05:24:09PM -0700, Doug Berger wrote:
> This commit introduces the phy_set_pause function to the phylib as
> a helper to support the set_pauseparam ethtool method.
> 
> It is hoped that the new behavior introduced by this function will
> be widely embraced and the phy_set_sym_pause and phy_set_asym_pause
> functions can be deprecated. Those functions are retained for all
> existing users and for any desenting opinions on my interpretation
> of the functionality.

It would be good to add comments to phy_set_sym_pause and
phy_set_asym_pause indicating they are deprecated and point to
phy_set_pause().

	Andrew
