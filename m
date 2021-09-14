Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7CB40A1E0
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 02:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238025AbhINA0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 20:26:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39224 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236554AbhINA0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 20:26:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vme2rvRhTg6vWG3v7eTJTvBQUUHlLeSFIX468MdIe0s=; b=Wb2lkZs1UIXEbJ8h9myU7iosMk
        OL4ulKtXcA9l5WkCNc755uAwGGzbKti6S0XEIYAPHvp3gB27Mx62s5LiO7AA1PQg0GvR1nK8G1SBQ
        2aS26UpyItyq1zLMmY8ra3Heh1vbiiUn/n7sZpQml+j3xwfwlHEWreNoLoZIGWNx3ZdM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mPwFc-006UEW-AU; Tue, 14 Sep 2021 02:24:40 +0200
Date:   Tue, 14 Sep 2021 02:24:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Richard Cochran <richard.cochran@omicron.at>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH -net] ptp: dp83640: don't define PAGE0
Message-ID: <YT/ryFmv/T95UJqn@lunn.ch>
References: <20210913220605.19682-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913220605.19682-1-rdunlap@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 13, 2021 at 03:06:05PM -0700, Randy Dunlap wrote:
> Building dp83640.c on arch/parisc/ produces a build warning for
> PAGE0 being redefined. Since the macro is not used in the dp83640
> driver, just make it a comment for documentation purposes.
> 
> In file included from ../drivers/net/phy/dp83640.c:23:
> ../drivers/net/phy/dp83640_reg.h:8: warning: "PAGE0" redefined
>     8 | #define PAGE0                     0x0000
>                  from ../drivers/net/phy/dp83640.c:11:
> ../arch/parisc/include/asm/page.h:187: note: this is the location of the previous definition
>   187 | #define PAGE0   ((struct zeropage *)__PAGE_OFFSET)
> 
> Fixes: cb646e2b02b2 ("ptp: Added a clock driver for the National Semiconductor PHYTER.")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Richard Cochran <richard.cochran@omicron.at>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
