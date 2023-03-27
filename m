Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461486CB17E
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 00:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjC0WPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 18:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjC0WPg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 18:15:36 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5DA10D
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 15:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YmxfS8CCBG+PM6xoZMx+Q/KC+uMhCMBR1d6pvObKjuk=; b=6Auuy977lWzyhP47l8eQUrtN7s
        rLlSnq873PmjwA1qtSx2vNeKUzlXi4SpBMjRwH1k0G4uVeFt2gxuNdb+KXmuoMPDqbkRoGLn4Hy3A
        opJNjcQWpHl7j8JjSxLpwzvgkdkrrWqWXD2Udcknsj7REzLRh7RRMysybWC80znFFDdE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgv7m-008Zc1-BV; Tue, 28 Mar 2023 00:15:34 +0200
Date:   Tue, 28 Mar 2023 00:15:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [RFC/RFT 20/23] net: phylink: Add MAC_EEE to mac_capabilites
Message-ID: <f33a5ff2-1c0b-410d-a1ab-a746792720ca@lunn.ch>
References: <20230327170201.2036708-1-andrew@lunn.ch>
 <20230327170201.2036708-21-andrew@lunn.ch>
 <ZCIR1/TSonhMSGKF@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCIR1/TSonhMSGKF@shell.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 10:59:51PM +0100, Russell King (Oracle) wrote:
> On Mon, Mar 27, 2023 at 07:01:58PM +0200, Andrew Lunn wrote:
> > If the MAC supports Energy Efficient Ethernet, it should indicate this
> > by setting the MAC_EEE bit in the config.mac_capabilities
> > bitmap. phylink will then enable EEE in the PHY, if it supports it.
> 
> I know it will be a larger patch, but I would prefer to add it after
> MAC_ASYM_PAUSE and shuffle the speeds up. I'm sure network speeds will
> continue to increase, resulting in more bits added in the future.

O.K, i can make the new symbol BIT(2).

Thanks
	Andrew
