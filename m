Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36B2018E2FF
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 17:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgCUQu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 12:50:27 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49180 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgCUQu1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 12:50:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3i4jtKDijIiewr8m+uZlezeua+B1nFKyeJkRAfB/8Pc=; b=xYMSxw9EWu/wZUn2D9nhCftCKA
        xXCLQWc3ubM+Zh4uqpCBW2QL/Qk6QjFq04QkN/LRK6eYTWBGa8qAWPRkhb0fmbScv0ZaoPrXGIbFe
        JcaQ2wojs5bQdD3Xr2+tQHZXA0KVhaYdCezVQlt8Qf7/yq741ZXmBS6L6TzU9hyEwZRI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jFhKA-00069T-Gg; Sat, 21 Mar 2020 17:50:14 +0100
Date:   Sat, 21 Mar 2020 17:50:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, allison@lohutok.net, corbet@lwn.net,
        alexios.zavras@intel.com, broonie@kernel.org, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/7] introduce read_poll_timeout
Message-ID: <20200321165014.GD22639@lunn.ch>
References: <20200320133431.9354-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320133431.9354-1-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 09:34:24PM +0800, Dejin Zheng wrote:
> This patch sets is introduce read_poll_timeout macro, it is an extension
> of readx_poll_timeout macro. the accessor function op just supports only
> one parameter in the readx_poll_timeout macro, but this macro can
> supports multiple variable parameters for it. so functions like
> phy_read(struct phy_device *phydev, u32 regnum) and
> phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum) can
> use this poll timeout framework.
> 
> the first patch introduce read_poll_timeout macro, and the second patch
> redefined readx_poll_timeout macro by read_poll_timeout(), and the other
> patches are examples using read_poll_timeout macro.

You missed lan87xx_read_status(), tja11xx_check(), and mv3310_reset().

If you convert all these, your diffstat might look better.

   Andrew
