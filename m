Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC344259F4
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 19:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243359AbhJGRw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 13:52:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54760 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242977AbhJGRwz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 13:52:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=n+9Q0lnjSmnVTKyzJlqvdKH6GvqeAWthJKePHa0mVgA=; b=MnXdsji755W3XzL7MY71VZZOB+
        cpExZgr7+iNjLuPxbNhz9K4ojOslf8jadeR99ptZMo4/4pwISAEEi2iu/7tJr0LobpUZNi6Hxl26F
        KkpN0cT09aUV0NoOqUjA2sm6sh7xV4RSJBNFh11y3BQrmJA746FTcIVixFxbqxHXZK4k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYXXi-009yex-Dk; Thu, 07 Oct 2021 19:50:54 +0200
Date:   Thu, 7 Oct 2021 19:50:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        philippe.schenker@toradex.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: phy: micrel: ksz9131 led errata
 workaround
Message-ID: <YV8zfj3UUyq2WRPF@lunn.ch>
References: <20211007164535.657245-1-francesco.dolcini@toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007164535.657245-1-francesco.dolcini@toradex.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 06:45:35PM +0200, Francesco Dolcini wrote:
> Micrel KSZ9131 PHY LED behavior is not correct when configured in
> Individual Mode, LED1 (Activity LED) is in the ON state when there is
> no-link.
> 
> Workaround this by setting bit 9 of register 0x1e after verifying that
> the LED configuration is Individual Mode.
> 
> This issue is described in KSZ9131RNX Silicon Errata DS80000693B [*]
> and according to that it will not be corrected in a future silicon
> revision.
> 
> [*] https://ww1.microchip.com/downloads/en/DeviceDoc/KSZ9131RNX-Silicon-Errata-and-Data-Sheet-Clarification-80000863B.pdf
> 
> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
