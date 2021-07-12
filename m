Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2067A3C5D51
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhGLNgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbhGLNgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 09:36:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0E3C0613DD;
        Mon, 12 Jul 2021 06:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nFGGuHlvEXY4zdDRoyLf+swK2e480mjKXj4i1cAvTZ8=; b=eFFK3GxXel8RRkjH2Ov1oEsu6
        j9/cjSGdfXF1AsdV4R7XmXPTWgpnILTlEHPGEnovl+xttb9BZt9UKXNm2udHXS5B4dmOs4x+Q/a/w
        TCnabhaXv7qJxwZ4QzM5RVARhX1VWPZ8wXyIOB0wIkOkSQM3EzDRbNO5wTx6m57EsdHYfsMmxOcyv
        tMZDcl3wQJudJTLXC7Ni2gKUjrLOW0hd21tLgx8pbm/QJG3QUaDAwoWxWzn54TnbVmabqmYez84hr
        6qLgHjQMx7C3mB4yItOnXTgyo5spSXiEZU+SitscoWAwtIVuBt4Qzkdw7O9Ap1st2mCiqYwnuPsJm
        GJlfIsYdw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46016)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m2w4P-0004oI-4l; Mon, 12 Jul 2021 14:34:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m2w4N-0007o3-02; Mon, 12 Jul 2021 14:33:59 +0100
Date:   Mon, 12 Jul 2021 14:33:58 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     alexandru.tachici@analog.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH v2 0/7] net: phy: adin1100: Add initial support for
 ADIN1100 industrial PHY
Message-ID: <20210712133358.GD22278@shell.armlinux.org.uk>
References: <20210712130631.38153-1-alexandru.tachici@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712130631.38153-1-alexandru.tachici@analog.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 04:06:24PM +0300, alexandru.tachici@analog.com wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> The ADIN1100 is a low power single port 10BASE-T1L transceiver designed for
> industrial Ethernet applications and is compliant with the IEEE 802.3cg
> Ethernet standard for long reach 10 Mb/s Single Pair Ethernet.
> 
> Ethtool output:
>         Settings for eth1:
>         Supported ports: [ TP	 MII ]
>         Supported link modes:   10baseT1L/Full
>                                 2400mv
>                                 1000mv

The SI unit of voltage is V not v, so milli-volts is mV not mv. Surely,
at the very least, we should be using the SI designation in user
visible strings?

It may also be worth providing a brief description of 10BASE-T1L in the
cover letter so (e.g.) one doesn't have to look up the fact that the
voltage level is negotiated via bit 13 of the base page. I've found
that by searching google and finding dp83td510e.pdf

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
