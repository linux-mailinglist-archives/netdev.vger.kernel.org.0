Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E57B52FED4
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 20:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344687AbiEUSjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 14:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235790AbiEUSjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 14:39:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278DB3D1E8;
        Sat, 21 May 2022 11:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=u+CCaJtF3iQl0PRzlEodOhhTq5AcNipDkc0XAaATyi0=; b=ONMMw/MGS0FsktEeV6XBMh4zpm
        mq4qFsrb3uv2tsgbybKYfixXr2NjV04SwtZTLV8qYhWnC9abWn7LlOJ3Iz6M2gyUckfOYuKgQXBkY
        /KsvUSfZ2vnsoOpR+Iyvw98k3Drr+HrQ0vXbUEaW19cmlgfaSRLG3/L2/lyRaYOq+P8o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nsU0E-003nDX-CU; Sat, 21 May 2022 20:39:02 +0200
Date:   Sat, 21 May 2022 20:39:02 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
Cc:     michael@amarulasolutions.com, alberto.bianchi@amarulasolutions.com,
        linux-amarula@amarulasolutions.com, linuxfancy@googlegroups.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: phy: DP83822: enable rgmii mode if
 phy_interface_is_rgmii
Message-ID: <YokxxlyFTJZ8c+5y@lunn.ch>
References: <20220520235846.1919954-1-tommaso.merciai@amarulasolutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520235846.1919954-1-tommaso.merciai@amarulasolutions.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 21, 2022 at 01:58:46AM +0200, Tommaso Merciai wrote:
> RGMII mode can be enable from dp83822 straps, and also writing bit 9
> of register 0x17 - RMII and Status Register (RCSR).
> When phy_interface_is_rgmii rgmii mode must be enabled, same for
> contrary, this prevents malconfigurations of hw straps
> 
> References:
>  - https://www.ti.com/lit/gpn/dp83822i p66
> 
> Signed-off-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
> Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
> Suggested-by: Alberto Bianchi <alberto.bianchi@amarulasolutions.com>
> Tested-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

If you want to, you could go further. If bit 9 is clear, bit 5 defines
the mode, either RMII or MII. There are interface modes defined for
these, so you could get bit 5 as well.

    Andrew
