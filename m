Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCEC6994C6
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjBPMuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjBPMuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:50:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E48E2799E;
        Thu, 16 Feb 2023 04:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=u6PLR4aGm0Thr3erl+EHjaOs4JZ/zhLiI27PgnccLD0=; b=0sT5yFScIQJpUvSw6D7jb/y582
        XZLUciU3zO4zo+lGqwzGBo1emF8DvyIdzJtJIIlaT2z/rVFP7pe6/HPIL7zhgWEuXR2bB79nk/+Wa
        +8y80Rx+ckF56boS8HDc/+ejaLBIpxO5tlejwb8cx2sz7bA0Cl2AOMxagePtjllO4u5o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pSdhr-005B67-TC; Thu, 16 Feb 2023 13:49:47 +0100
Date:   Thu, 16 Feb 2023 13:49:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Larysa Zaremba <larysa.zaremba@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>
Subject: Re: [PATCH net-next v1 7/7] net: fec: add support for PHYs with
 SmartEEE support
Message-ID: <Y+4ma61Gf3G3D6Bh@lunn.ch>
References: <20230214090314.2026067-1-o.rempel@pengutronix.de>
 <20230214090314.2026067-8-o.rempel@pengutronix.de>
 <Y+uMDEyWW15gerN0@lunn.ch>
 <20230216091142.GA1974@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216091142.GA1974@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I would prefer to not touch phy_init_eee(). At least not in this patch
> set. With this function we have following situation:

We have a complete mess :-(

I spent yesterday re-writing the MAC driver side of EEE. Most get it
completely wrong, as you point out. So i changed the API a bit, making
it more like other negotiated things, so i hope developers will get it
correct in the future.  I will post an RFC/RFT series soon.

> Hm.. I need to admit, EEE should not be advertised by default. Only
> if MAC driver calls something like phy_support_eee(), we should start doing it.

This i've not looked at yet. But i agree.

     Andrew
