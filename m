Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9233352839C
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237527AbiEPL5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiEPL5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:57:52 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCB513D4C
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 04:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=71oPJOrXFQg3HMQBC5IjtxXdpV93SI1rNl+QiWuiz1Q=; b=1M
        XaxHpjSNaIPDIG+qmAQy5WNkPj7X3cah3XxeCFjkBxaSZQiDEfd6KChJGKnQTpMB5mdqfWrVSIZI5
        Tf/V9UdFTPVNN3BQvhswzU0rihb5j8motcwzf3rJHtb8pqiBv4u8ttpGWYLNBby9fF7uOkIwJ5QVg
        mD55pph/xtve+7U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nqZMB-0030RE-Hi; Mon, 16 May 2022 13:57:47 +0200
Date:   Mon, 16 May 2022 13:57:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Roese <sr@denx.de>
Cc:     netdev@vger.kernel.org, Leszek Polak <lpolak@arri.de>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] net: phy: marvell: Add errata section 5.1 for Alaska
 PHY
Message-ID: <YoI8O/joRfdiGFkV@lunn.ch>
References: <20220516070859.549170-1-sr@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220516070859.549170-1-sr@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 16, 2022 at 09:08:59AM +0200, Stefan Roese wrote:
> From: Leszek Polak <lpolak@arri.de>
> 
> As per Errata Section 5.1, if EEE is intended to be used, some register
> writes must be done once after every hardware reset. This patch now adds
> the necessary register writes as listed in the Marvell errata.
> 
> Without this fix we experience ethernet problems on some of our boards
> equipped with a new version of this ethernet PHY (different supplier).
> 
> The fix applies to Marvell Alaska 88E1510/88E1518/88E1512/88E1514
> Rev. A0.
> 
> Signed-off-by: Leszek Polak <lpolak@arri.de>
> Signed-off-by: Stefan Roese <sr@denx.de>
> Cc: Marek Behún <kabel@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: David S. Miller <davem@davemloft.net>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
