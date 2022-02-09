Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4FB4AE6F7
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 03:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243270AbiBICjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 21:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241422AbiBIAz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 19:55:28 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD41C061576
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 16:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7j8xaiDHKLuYSfbxSytsLDdL2ZEdsyuWOW5B7d955Do=; b=afEZDx0ANsXGYGDdr9/Pa9Ivju
        3/Oai6ykTkEx2NNhliPjMiYBz9/sA5G2NSVwncw4fTOG/vig1W3y9paYklyxS5F3KkqrEYLc2akkZ
        1v+XB4+5r3mwjU7PvSSorVh6pLzl6+4dI/TuRfuqWl3R1pcmWPFj/KN5ZOMq5nfSeGx4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHbGP-004zSK-Iy; Wed, 09 Feb 2022 01:55:17 +0100
Date:   Wed, 9 Feb 2022 01:55:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org
Subject: Re: [PATCH net] net: mdio: aspeed: Add missing MODULE_DEVICE_TABLE
Message-ID: <YgMQ9e6MZ2h8i73/@lunn.ch>
References: <20220209000359.372978-1-joel@jms.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209000359.372978-1-joel@jms.id.au>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 09, 2022 at 10:33:59AM +1030, Joel Stanley wrote:
> Fix loading of the driver when built as a module.
> 
> Fixes: f160e99462c6 ("net: phy: Add mdio-aspeed")
> Signed-off-by: Joel Stanley <joel@jms.id.au>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
