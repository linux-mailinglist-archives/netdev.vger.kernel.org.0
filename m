Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC89519F6A
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 14:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349596AbiEDMcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 08:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349540AbiEDMb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 08:31:26 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755543057C;
        Wed,  4 May 2022 05:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=PZuKIQ/6fK2IF1ChGatGwypGtSEXFs4ELDYnkndY5IA=; b=maCXYfqxQcIAeIpSEEUckTK/Gh
        9RmGwa2dJij1h6xjkyT6dM4vxy/mLyNHyOVKz5dFk7w8WNW5AF2/0Y6MMXgtlkmTkAJrU2uNJwMPL
        5arS7OpcRx/us5/qh2DOVguB7IzMMvM7mLHngt9e/vVsFy0eVBR/gsaTGkr2WE75p/Is=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmE6T-001Cvd-OR; Wed, 04 May 2022 14:27:37 +0200
Date:   Wed, 4 May 2022 14:27:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] net: phy:
 genphy_c45_baset1_an_config_aneg: do no set unknown configuration
Message-ID: <YnJxOXcSVGW+g0ZP@lunn.ch>
References: <20220504110655.1470008-1-o.rempel@pengutronix.de>
 <20220504110655.1470008-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504110655.1470008-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 04, 2022 at 01:06:54PM +0200, Oleksij Rempel wrote:
> Do not change default master/slave autoneg configuration if no
> changes was requested.
> 
> Fixes: 3da8ffd8545f ("net: phy: Add 10BASE-T1L support in phy-c45")
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Hi Oleksij

I'm i right in saying 3da8ffd8545f is only in net-next?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
