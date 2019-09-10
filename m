Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0C8AF123
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 20:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbfIJShU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 14:37:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38790 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbfIJShU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 14:37:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JTkbnv93gLuDmmH5p1691gshTY19q7OsYC9+NWDuBBU=; b=4qPPl99fBJ6gOfJHUQgScDhSiH
        4qbNMXF+pas/nE2AhMn4Uv7pOFjKZYbkWH8ecyWDWvIgLpq1AzyhKjAozojQC39pNZf0twMniNDPL
        /5W++1SkvDKKuiM+Tlg680sxxaW4JGzTD5ltC0Gu04qi0+01y3TELqVEPtR+yD1Lw+44=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i7l0s-00030O-EG; Tue, 10 Sep 2019 20:37:14 +0200
Date:   Tue, 10 Sep 2019 20:37:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, Woojung Huh <woojung.huh@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] net: dsa: microchip: remove
 NET_DSA_TAG_KSZ_COMMON
Message-ID: <20190910183714.GC9761@lunn.ch>
References: <20190910131836.114058-1-george.mccollister@gmail.com>
 <20190910131836.114058-4-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910131836.114058-4-george.mccollister@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 10, 2019 at 08:18:36AM -0500, George McCollister wrote:
> Remove the superfluous NET_DSA_TAG_KSZ_COMMON and just use the existing
> NET_DSA_TAG_KSZ. Update the description to mention the three switch
> families it supports. No functional change.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> Reviewed-by: Marek Vasut <marex@denx.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
