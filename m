Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC46C6493D4
	for <lists+netdev@lfdr.de>; Sun, 11 Dec 2022 12:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiLKLNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 06:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiLKLNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 06:13:41 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49718271D;
        Sun, 11 Dec 2022 03:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YvFRWUB7V7RNaiGH/ffN4u9im25DvH0UbGyf8qv2CzQ=; b=Hak88CFahfCAIYmSwRZuU3Ftgd
        SaUTNbMlrVcqIyde2UGyKMd1RzmKLk6WyCaKGHKtqRc4gM913+y47kiD3LZuDH13EN5pJN39IcePZ
        iXfYNrR3lpbQaoiskPHzxUYDM6WRzjqBznIoOiKySPq4cQip/gVg45Fg6lw547kVMUuw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p4KFr-0050oL-V1; Sun, 11 Dec 2022 12:12:23 +0100
Date:   Sun, 11 Dec 2022 12:12:23 +0100
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
Message-ID: <Y5W7F0mX1VvRsWjD@lunn.ch>
References: <20221206195014.10d7ec82@kernel.org>
 <Y5CQY0pI+4DobFSD@gvm01>
 <Y5CgIL+cu4Fv43vy@lunn.ch>
 <Y5C0V52DjS+1GNhJ@gvm01>
 <Y5C6EomkdTuyjJex@lunn.ch>
 <Y5C8mIQWpWmfmkJ0@gvm01>
 <Y5DR01UWeWRDaLdS@lunn.ch>
 <Y5DfDYr2egl/dZoy@gvm01>
 <Y5DokI3lm8U2eW+G@lunn.ch>
 <Y5IY6FLtndqXqzMn@gvm01>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5IY6FLtndqXqzMn@gvm01>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Given what I just said, what would you suggest to do?

I would return just the version part, not the whole register contents.

The nice thing about netlink is you can add extra attributes without
breaking the ABI. If that 0xA ever gains a meaning and more values, an
attribute for it can be added.

   Andrew
