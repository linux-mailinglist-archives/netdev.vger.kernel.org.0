Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165D36CAACD
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 18:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjC0Qla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 12:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjC0Ql2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 12:41:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A7512F;
        Mon, 27 Mar 2023 09:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=yRGIuLhfmTVv+hrrCN7uKZXXgE2tRW298bQdoran36c=; b=n2YjiDehjB4ucTgQyKljKorfKF
        gmuvQS4yitRqS/Gp1NLBDUGxWLuLRxlooTsqs3EEfjqIofDUhzDpevLYueuzYgvhfL27SZ9XXoiiD
        O/073UOgH2UNh3cBygrrd9qPKVFwrM5uoeDLdE6nOESJbSi1EQinRknWfCjLf9l/o1Ws=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pgpuE-008Xj4-Rj; Mon, 27 Mar 2023 18:41:14 +0200
Date:   Mon, 27 Mar 2023 18:41:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Wei Fang <wei.fang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Amit Cohen <amcohen@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        Alexandru Tachici <alexandru.tachici@analog.com>,
        Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next v2 1/8] net: phy: Add driver-specific
 get/set_eee support for non-standard PHYs
Message-ID: <47e5176b-3d9a-4583-98d2-73aaf7e4903c@lunn.ch>
References: <20230327142202.3754446-1-o.rempel@pengutronix.de>
 <20230327142202.3754446-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327142202.3754446-2-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 04:21:55PM +0200, Oleksij Rempel wrote:
> Not all PHYs are implemented fully according to the IEEE 802.3
> specification and cannot be handled by the generic
> phy_ethtool_get/set_eee() functions. To address this, this commit adds
> driver-specific get/set_eee support, enabling better handling of such
> PHYs. This is particularly important for handling PHYs with SmartEEE
> support, which requires specialized management.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
