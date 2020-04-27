Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C1D1BA3AD
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 14:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgD0Mhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 08:37:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38050 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbgD0Mhy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 08:37:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=a2qSFE3ObXrkclbvJ9WGUazFLxwZX/lQafmNLeOPmhA=; b=dVd8wc4bQxp1x88Xdn3JUhIjB9
        8+skijAsHRHIYCleP8iRGvD26aGVcAmqMZy+LoCNGqEUbz4IASVlIJAA1ScZcBAwwsOe0fzG724d7
        De5aGO5PgLNJhrNxHgwpsnm7U0WDuiUPlPdGp991UXHt6Dowa92DV+ECUL+wubtJotMU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jT315-005Cqo-Si; Mon, 27 Apr 2020 14:37:43 +0200
Date:   Mon, 27 Apr 2020 14:37:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Anthony Felice <tony.felice@timesys.com>
Cc:     Akshay Bhat <akshay.bhat@timesys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: tc35815: Fix phydev supported/advertising mask
Message-ID: <20200427123743.GD1183480@lunn.ch>
References: <20200427020101.3059-1-tony.felice@timesys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427020101.3059-1-tony.felice@timesys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 10:00:59PM -0400, Anthony Felice wrote:
> Commit 3c1bcc8614db ("net: ethernet: Convert phydev advertize and
> supported from u32 to link mode") updated ethernet drivers to use a
> linkmode bitmap. It mistakenly dropped a bitwise negation in the
> tc35815 ethernet driver on a bitmask to set the supported/advertising
> flags.
> 
> Found by Anthony via code inspection, not tested as I do not have the
> required hardware.
> 
> Fixes: 3c1bcc8614db ("net: ethernet: Convert phydev advertize and supported from u32 to link mode")
> Signed-off-by: Anthony Felice <tony.felice@timesys.com>
> Reviewed-by: Akshay Bhat <akshay.bhat@timesys.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Thanks.

    Andrew
