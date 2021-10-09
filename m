Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388CF427B0C
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 16:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbhJIPBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 11:01:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58236 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233657AbhJIPBD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 11:01:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=os3WK2G0bIPldJCXZhrJz1BSqOsIIIPXDk2jiotbce8=; b=QseFm9Q7fls5EVpvOXBfcGJ/3d
        8TCYxfmzBwpoKWX8bcO4xssIYRtYEtBvJOTGlNrAaJ2dFoiDqLC29QtXTCfEGUT5lR5yNC6CSftq7
        /a2SJRVc36Ca0iQdn5+ZbkTh078f1MWGlGiUbHqPsiNc5VqH19S7UDttGg+oZV+Wewek=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mZDoN-00A9ti-7Z; Sat, 09 Oct 2021 16:58:55 +0200
Date:   Sat, 9 Oct 2021 16:58:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net PATCH 1/2] drivers: net: phy: at803x: fix resume for
 QCA8327 phy
Message-ID: <YWGuL+/E4xHdNsQD@lunn.ch>
References: <20211008233426.1088-1-ansuelsmth@gmail.com>
 <20211008164750.4007f2d9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YWDZPfWOe+C2abWz@Ansuel-xps.localdomain>
 <20211008171355.74ea6295@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YWDfXyuvmFYwywJW@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YWDfXyuvmFYwywJW@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It's ok. We got all confused with the Fixes tag. Pushing stuff too
> quickly... I should have notice they were not present in net and
> reporting that. Sorry for the mess.

It would still be good to post those fixes separate from the rest of
the series. I think the DT binding will need more discussion.

    Andrew
