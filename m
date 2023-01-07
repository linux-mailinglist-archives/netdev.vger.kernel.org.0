Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29ED0661086
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 18:29:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbjAGR3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 12:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjAGR3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 12:29:38 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64162197;
        Sat,  7 Jan 2023 09:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OT78mzjiB2RDha/JbxUmO7OAn1GHdz9814ToiDBQSlQ=; b=kk5PCSE7IQgsrU/eowHn+J6YhV
        oNmk+OHrgGvNzy3QvwcliVsQlky1m+Zlm8qmDJ0RIbh0fvN2h3O3qQcTMk8NIQ4dV76EyfBrRl3pk
        Mjj+K/4fVWTFi1u+s2OyhpI7ZZ5IK7NR1Z6kodBUV+p2g/sIAPYGSPoDXoPwOC6zGjhU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pED0U-001R4r-8v; Sat, 07 Jan 2023 18:29:22 +0100
Date:   Sat, 7 Jan 2023 18:29:22 +0100
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
Subject: Re: [PATCH v2 net-next 1/5] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y7mr8kp1sgXembUr@lunn.ch>
References: <cover.1673030528.git.piergiorgio.beruto@gmail.com>
 <7d75e759e1073aad0fcc4571b6bc93a6667d104d.1673030528.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d75e759e1073aad0fcc4571b6bc93a6667d104d.1673030528.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 07:44:23PM +0100, Piergiorgio Beruto wrote:
> Add support for configuring the PLCA Reconciliation Sublayer on
> multi-drop PHYs that support IEEE802.3cg-2019 Clause 148 (e.g.,
> 10BASE-T1S). This patch adds the appropriate netlink interface
> to ethtool.
> 
> Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
