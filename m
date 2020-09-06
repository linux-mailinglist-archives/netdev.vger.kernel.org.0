Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5EC25EE4C
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 16:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728785AbgIFOnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 10:43:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45598 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728902AbgIFOkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Sep 2020 10:40:08 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kEvpZ-00DUNC-GQ; Sun, 06 Sep 2020 16:39:45 +0200
Date:   Sun, 6 Sep 2020 16:39:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>
Subject: Re: [net-next PATCH v2] net: gemini: Clean up phy registration
Message-ID: <20200906143945.GL3164319@lunn.ch>
References: <20200905204257.51044-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200905204257.51044-1-linus.walleij@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 05, 2020 at 10:42:57PM +0200, Linus Walleij wrote:
> It's nice if the phy is online before we register the netdev
> so try to do that first.
> 
> Stop trying to do "second tried" to register the phy, it
> works perfectly fine the first time.
> 
> Stop remvoving the phy in uninit. Remove it when the
> driver is remove():d, symmetric to where it is added, in
> probe().
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Reported-by: David Miller <davem@davemloft.net>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
