Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8659666108A
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 18:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbjAGRbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 12:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjAGRbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 12:31:45 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFE3A3590A;
        Sat,  7 Jan 2023 09:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Y2md5FJlnuIjLlt81uSQeNIVq/QBrdixv80lSRfyvQw=; b=wijDr0fsxh3iwY0lT28QsKe4U9
        Y99H3AJYoWn34FrfhyzHL8/KysObBfBO8ayUFnufvch2icBW8WP34gaWvIMjjF/XEmRRnYwnywk6c
        1fEj2PHeKdwwLhJ5jose11aSe1iEr8o0JrVsxC6F1r3dlThm8fpnxBZ/qIBZ7oSyfV0s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pED2f-001R5Q-K8; Sat, 07 Jan 2023 18:31:37 +0100
Date:   Sat, 7 Jan 2023 18:31:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org
Subject: Re: [PATCH v2 net-next 2/5] drivers/net/phy: add the link modes for
 the 10BASE-T1S Ethernet PHY
Message-ID: <Y7mseQIqVMybWjYm@lunn.ch>
References: <cover.1673030528.git.piergiorgio.beruto@gmail.com>
 <d7d3501203849891c884e8b7b7803f1cedfa1c97.1673030528.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7d3501203849891c884e8b7b7803f1cedfa1c97.1673030528.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 07:44:44PM +0100, Piergiorgio Beruto wrote:
> This patch adds the link modes for the IEEE 802.3cg Clause 147 10BASE-T1S
> Ethernet PHY. According to the specifications, the 10BASE-T1S supports
> Point-To-Point Full-Duplex, Point-To-Point Half-Duplex and/or
> Point-To-Multipoint (AKA Multi-Drop) Half-Duplex operations.
> 
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
