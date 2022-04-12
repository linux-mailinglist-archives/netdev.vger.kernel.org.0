Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0723E4FE675
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357942AbiDLRDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357937AbiDLRDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:03:33 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417BB5AA7D;
        Tue, 12 Apr 2022 10:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ZobwdKDR8UFpxo0I04piMgWRCYUu3TUJlS17j3rNz7s=; b=y3ElFikfZUSkkLGbo8Rm2tcTQn
        Jn8xViy8TPgEirODUrwanG+HVm5EJ9E8QxZgDLPxQ2+tH8foKvbPz86jNQGdPPPG20cYaLdcvjkBk
        C+eISWmNp+GHuQPHBiA05hdj/ybil/AIywmLwR4vArtn//3t6Nb/8ixMqz9ak/U+nbco=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1neJtB-00FUHh-6y; Tue, 12 Apr 2022 19:01:13 +0200
Date:   Tue, 12 Apr 2022 19:01:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [Patch net-next 1/3] net: phy: LAN937x: added
 PHY_POLL_CABLE_TEST flag
Message-ID: <YlWwWd3HuT47GIGp@lunn.ch>
References: <20220412063317.4173-1-arun.ramadoss@microchip.com>
 <20220412063317.4173-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412063317.4173-2-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 12, 2022 at 12:03:15PM +0530, Arun Ramadoss wrote:
> Added the phy_poll_cable_test flag for the lan937x phy driver.
> Tested using command -  ethtool --cable-test <dev>

Does this need back porting? Cable test has been in this driver for a
while. If so, please separate it out, and submit it for net, not
next-next.

Fixes: 788050256c41 ("net: phy: microchip_t1: add cable test support for lan87xx phy")

       Andrew
