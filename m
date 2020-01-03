Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7341F12FDE0
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 21:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728373AbgACU0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 15:26:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47022 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727527AbgACU0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 15:26:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sWF7wO+KIJ9WXmall6ZZx0fVDk/Ldbd6ue/ONy4GM18=; b=Hb2rVFrzZryyuFlC2UHXyd6jsT
        mC8FEU6TXc7qtROejA8sdXhlFtdt0i3dEcBkTqRgUayyzKLb9hKHYkluKYv+4d9qU5ySuPb6AaYuQ
        836KYdmjjDOrTJIfDkkENkOLWhRO28Ga3u22U5AqyVJwMC9mfgaUKJ4jG+LhSH+Rzs0k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1inTW9-0002rA-0r; Fri, 03 Jan 2020 21:25:57 +0100
Date:   Fri, 3 Jan 2020 21:25:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: phylink: fix failure to register on x86 systems
Message-ID: <20200103202557.GR1397@lunn.ch>
References: <E1inOeC-00004q-18@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1inOeC-00004q-18@rmk-PC.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 03:13:56PM +0000, Russell King wrote:
> The kernel test robot reports a boot failure with qemu in 5.5-rc,
> referencing commit 2203cbf2c8b5 ("net: sfp: move fwnode parsing into
> sfp-bus layer"). This is caused by phylink_create() being passed a
> NULL fwnode, causing fwnode_property_get_reference_args() to return
> -EINVAL.
> 
> Don't attempt to attach to a SFP bus if we have no fwnode, which
> avoids this issue.
> 
> Reported-by: kernel test robot <rong.a.chen@intel.com>
> Fixes: 2203cbf2c8b5 ("net: sfp: move fwnode parsing into sfp-bus layer")
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
