Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDAF818E9AB
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 16:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgCVPe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 11:34:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50308 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgCVPe0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 11:34:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=s4KFQDd4eawKJE0/3oZUP1iM0XwdGMsfHIRqHpKxyX4=; b=0RpHDXnckZ7FpvcUzCGyLRkBBQ
        MsvP3J6JQaNoXOGqBFrqZoKGOJQQuDfvf3731Vw6enZ3SidPSuk5YOwsbmRxqRhMz6D/tXVP33oA2
        Quk2VPIy1lJ645xPCnp0apAiV5Q7fqR6W4x/6+7ctMIcZMYh1WMCc/LktqVZod+okfGQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jG2cD-0000YM-DB; Sun, 22 Mar 2020 16:34:17 +0100
Date:   Sun, 22 Mar 2020 16:34:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        broonie@kernel.org, alexios.zavras@intel.com, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 5/9] net: phy: aquantia: use
 phy_read_mmd_poll_timeout() to simplify the code
Message-ID: <20200322153417.GN11481@lunn.ch>
References: <20200322065555.17742-1-zhengdejin5@gmail.com>
 <20200322065555.17742-6-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200322065555.17742-6-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 22, 2020 at 02:55:51PM +0800, Dejin Zheng wrote:
> use phy_read_mmd_poll_timeout() to replace the poll codes for
> simplify aqr107_wait_reset_complete() function.
> 
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
