Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32DD951B153
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 23:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358934AbiEDVtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 17:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378950AbiEDVtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 17:49:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978F6E0F9
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 14:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eM5K24bCCqwqRkmHRHvfL0NSYVLMch8KVrzFWD/X2TI=; b=KxBF+yBxKyOvNDhw1HMIKpziFw
        CdNpdNzEW9dmgCzNjXmd0VzP8KDktpbi95HavMIGnQCQJNJq9ivlYgswRPLtnUnbXe2vQEaWvtgOn
        1wGe/TNW7/iLt0M5wa6BLNDs3cW4WKlbORQAlz23SMCLHDjvaXkorj7bltXsCgE6IQQ0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmMoW-001Gb7-1j; Wed, 04 May 2022 23:45:40 +0200
Date:   Wed, 4 May 2022 23:45:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     woojung.huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, ravi.hegde@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH v3 net-next 2/2] net: phy: smsc: add LAN8742 phy support.
Message-ID: <YnL0BFPIbRbz9DMY@lunn.ch>
References: <20220504152822.11890-1-yuiko.oshino@microchip.com>
 <20220504152822.11890-3-yuiko.oshino@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220504152822.11890-3-yuiko.oshino@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	/* Statistics */
> +	.get_sset_count = smsc_get_sset_count,
> +	.get_strings	= smsc_get_strings,
> +	.get_stats	= smsc_get_stats,
> +
> +	.suspend	= genphy_suspend,
> +	.resume	= genphy_resume,

Is the white space wrong here, or is it how tabs are displayed in my
mailer?

	Andrew
