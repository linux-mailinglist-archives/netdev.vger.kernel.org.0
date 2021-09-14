Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D77040AE2A
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 14:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbhINMvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 08:51:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40396 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232664AbhINMvL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 08:51:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hZ5pXX0ixUxHBbBv3lE5Lu2a3o0sDCIW7EA8W88bxDQ=; b=hhlcWndq2AjAy6gUllDW5/7Mp8
        BUkSMKTrDOlfvtaouCN0Qqu+VbLUkOL2KJsQAfprfwCHjKvluKTwK5RYKftbSNrvOwTEpcUHLwTCh
        Wu0Xcfbx2Mti2/0cbXJLxtRouB1+vJoNDLV4oeYrwfhkgtyqGYnVkl2qXwQxCPRaeTZE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mQ7sl-006aRE-En; Tue, 14 Sep 2021 14:49:51 +0200
Date:   Tue, 14 Sep 2021 14:49:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Subject: Re: [PATCH net-next v2] net: phy: at803x: add support for qca 8327
 internal phy
Message-ID: <YUCab+ZOeDczrb8I@lunn.ch>
References: <20210914123345.6321-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914123345.6321-1-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 14, 2021 at 02:33:45PM +0200, Ansuel Smith wrote:
> Add support for qca8327 internal phy needed for correct init of the
> switch port. It does use the same qca8337 function and reg just with a
> different id.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Tested-by: Rosen Penev <rosenp@gmail.com>

Tested-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
