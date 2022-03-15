Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E72D4D9DD8
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 15:40:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349241AbiCOOkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 10:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349240AbiCOOkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 10:40:47 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393FE5549F
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 07:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IwJb91hhUl6I+4n+v9SL4tUYlHQGF/LOhIG7X6GbkZU=; b=ygpSThlae4rTxmLFQqKgq0PPWC
        7KvzaJHZxDYOalSds3fWEcEODF8CbMMfcbPQT/az7QMDP4VJLyqFkP0Q/ko0MZTDfMPrwl2jJFMSn
        twA16GsJ4lPiLWdQCoMVjYWmcAiMmb8pamIdMoPk9JGJQXch1PQImjX2v8Kotp8JJImY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nU8Ki-00AyhX-Qq; Tue, 15 Mar 2022 15:39:32 +0100
Date:   Tue, 15 Mar 2022 15:39:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stefan Roese <sr@denx.de>, '@lunn.ch
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: phy: marvell: Add errata section 5.1 for Alaska PHY
Message-ID: <YjClJNaRrvqDI3t6@lunn.ch>
References: <20220315074827.1439941-1-sr@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315074827.1439941-1-sr@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 08:48:27AM +0100, Stefan Roese wrote:
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
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: David S. Miller <davem@davemloft.net>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
