Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0682069B738
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 01:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjBRAz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 19:55:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjBRAz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 19:55:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F295F263;
        Fri, 17 Feb 2023 16:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tUjRxf87+ZZjnZ/gxtcCDyxRBwBJu21IacdG/o5+D1M=; b=5SCbU/h+mIg9w6LIHWRZsC8KCP
        Wfay/z92sUbsQpHQldey5isMPzMK09lV5ZbQce3ZvQCkIlFKLOy9gyAP0k5J6PA262AuaYf4vcBtE
        CyVBwzb4k0z3cb7Yrp69TgIoFvNtv19ZgkTLBMyVF+mJSThzZ/Ic28NYa4PR3G4F+NCA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pTBVc-005M45-Gz; Sat, 18 Feb 2023 01:55:24 +0100
Date:   Sat, 18 Feb 2023 01:55:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH net-next] net: phy: micrel: Add support for PTP_PF_PEROUT
 for lan8841
Message-ID: <Y/Ah/MRYKdohtXZH@lunn.ch>
References: <20230217075213.2366042-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230217075213.2366042-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static void lan8841_ptp_update_target(struct kszphy_ptp_priv *ptp_priv,
> +				      const struct timespec64 *ts);
> +

Please avoid this. Move the code around so everything is in
order. Generally, i do such moves in an initial patch which only moves
code, making it easy to review.

      Andrew
