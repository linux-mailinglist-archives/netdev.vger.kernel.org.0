Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4715646099
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 18:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiLGRsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 12:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiLGRsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 12:48:15 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7C1654C8;
        Wed,  7 Dec 2022 09:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=b6WLhD+PnTypQlZbVHDcD5fVsl+hiijx+vNoemLYbyQ=; b=LxVvk0+YFrTSJmNOhh2TqGO7TD
        nZQlggmTyUV4Gqn9zGNXwySY01QhmlJExqa86qvxOMFsdbYGZtkRetku4SAYlw4298IKWifYASgvo
        6l+h4OaJFEqkIE1M0T2tk88hi4ui2Z2pJdQcnp5DfG//YrAJlWdo2KLbA/u5wVp4+6kE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2yWZ-004fxP-Rq; Wed, 07 Dec 2022 18:48:03 +0100
Date:   Wed, 7 Dec 2022 18:48:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 1/5] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y5DR01UWeWRDaLdS@lunn.ch>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
 <350e640b5c3c7b9c25f6fd749dc0237e79e1c573.1670371013.git.piergiorgio.beruto@gmail.com>
 <20221206195014.10d7ec82@kernel.org>
 <Y5CQY0pI+4DobFSD@gvm01>
 <Y5CgIL+cu4Fv43vy@lunn.ch>
 <Y5C0V52DjS+1GNhJ@gvm01>
 <Y5C6EomkdTuyjJex@lunn.ch>
 <Y5C8mIQWpWmfmkJ0@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5C8mIQWpWmfmkJ0@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > And only return the actual version value, not the 0x0A.
> About this, at the moment I am reporting the 0x0A to allow in the future
> possible extensions of the standard. A single byte for the version may
> be too limited given this technology is relatively fresh.
> What you think of this?

What does the standards document say about this 0x0A?

     Andrew
