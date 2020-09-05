Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1628525E8E8
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 17:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgIEPv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 11:51:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44876 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIEPuz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 11:50:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kEaSq-00DMpV-SI; Sat, 05 Sep 2020 17:50:52 +0200
Date:   Sat, 5 Sep 2020 17:50:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>
Subject: Re: [net-next PATCH] net: gemini: Try to register phy before netdev
Message-ID: <20200905155052.GI3164319@lunn.ch>
References: <20200905104530.29998-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200905104530.29998-1-linus.walleij@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 05, 2020 at 12:45:30PM +0200, Linus Walleij wrote:
> It's nice if the phy is online before we register the netdev
> so try to do that first.

Hi Linus

The PHY handling in this driver is all a bit odd.

gmac_open() will also try to connect the PHY if it has not already
been found. gmac_stop() does not seem to have a symmetrical
phy_disconnect. However, gmac_uninit does?

I do wonder if more cleanup should be done while you are at it?

    Andrew
