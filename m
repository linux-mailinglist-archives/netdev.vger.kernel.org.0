Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22023645086
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLGAn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiLGAnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:43:55 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27BA2F659;
        Tue,  6 Dec 2022 16:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=qSRlmxFiW/u/I0+7+hyvY/fyZuvvYpaLHCmoJB9SgDw=; b=5fpLBPC2REkQCRIgo9rb0q2w6G
        ujcdHfCsPL1IJlss52ADwkKLXbv149BNPR30e2krg51tsxuzc9S5wiGV+sPGrNDQY3sh4nsZg8acC
        fa43Wkh6jeuYNLV0auDpp1VBf4+t+x1DvAb1Dz6iqkB5nPIyvl51s7+M/7uMDZNC5gV0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p2iXF-004aXA-23; Wed, 07 Dec 2022 01:43:41 +0100
Date:   Wed, 7 Dec 2022 01:43:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v5 net-next 0/5] add PLCA RS support and onsemi NCN26000
Message-ID: <Y4/hvercnlTtFCMd@lunn.ch>
References: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670371013.git.piergiorgio.beruto@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 01:00:58AM +0100, Piergiorgio Beruto wrote:
> This patchset adds support for getting/setting the Physical Layer 
> Collision Avoidace (PLCA) Reconciliation Sublayer (RS) configuration and
> status on Ethernet PHYs that supports it.
> 
> PLCA is a feature that provides improved media-access performance in terms
> of throughput, latency and fairness for multi-drop (P2MP) half-duplex PHYs.
> PLCA is defined in Clause 148 of the IEEE802.3 specifications as amended
> by 802.3cg-2019. Currently, PLCA is supported by the 10BASE-T1S single-pair
> Ethernet PHY defined in the same standard and related amendments. The OPEN
> Alliance SIG TC14 defines additional specifications for the 10BASE-T1S PHY,
> including a standard register map for PHYs that embeds the PLCA RS (see
> PLCA management registers at https://www.opensig.org/about/specifications/).
> 
> The changes proposed herein add the appropriate ethtool netlink interface
> for configuring the PLCA RS on PHYs that supports it. A separate patchset
> further modifies the ethtool userspace program to show and modify the
> configuration/status of the PLCA RS.
> 
> Additionally, this patchset adds support for the onsemi NCN26000
> Industrial Ethernet 10BASE-T1S PHY that uses the newly added PLCA
> infrastructure.

You should be listing what has changed since the previous
version. Either here, or in each patch, below the --- marker. It helps
reviewers know their comments have been acted up.

	 Andrew
