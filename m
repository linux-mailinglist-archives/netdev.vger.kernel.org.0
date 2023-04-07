Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60D46DAF92
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjDGPRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231129AbjDGPRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:17:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A3B1FE8
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=rVaXxmXNb4s7HJ6Jvbv9Hrymj5X+mTAGI3oQZp7C4aU=; b=i5Kb9TbCP1zXDZYdblGtLEvC0L
        VVAXzSZPsQjqxOnW0s+HIIhJzJ97rc4nevgokbb6no3XxZuOHOMJe1caAtQe2jG6uvjpdjTJBPh9i
        4VqHtdBeyNnuwkYtADZdSQncKZ+gmrHyG36pRnzMWNMkMlhLscW84dR/YKDjlh/FG+ds=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pknqH-009jfI-VX; Fri, 07 Apr 2023 17:17:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gregory Clement <gregory.clement@bootlin.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 0/3] Add missing DSA properties for marvell switches
Date:   Fri,  7 Apr 2023 17:17:19 +0200
Message-Id: <20230407151722.2320481-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The DSA core has become more picky about DT properties. This patchset
add missing properties and removes some unused ones, for Marvell ARM
boards.

Once all the missing properties are added, it should be possible to
simply phylink and the mv88e6xxx driver.

Andrew Lunn (3):
  ARM: dts: kirkwood: Add missing phy-mode and fixed links
  ARM: dts: orion5: Add missing phy-mode and fixed links
  ARM: dts: armada: Add missing phy-mode and fixed links

 arch/arm/boot/dts/armada-370-rd.dts               | 2 +-
 arch/arm/boot/dts/armada-381-netgear-gs110emx.dts | 2 +-
 arch/arm/boot/dts/armada-385-clearfog-gtr-l8.dts  | 7 ++++++-
 arch/arm/boot/dts/armada-385-clearfog-gtr-s4.dts  | 7 ++++++-
 arch/arm/boot/dts/armada-385-linksys.dtsi         | 2 +-
 arch/arm/boot/dts/armada-385-turris-omnia.dts     | 2 --
 arch/arm/boot/dts/armada-xp-linksys-mamba.dts     | 2 +-
 arch/arm/boot/dts/kirkwood-dir665.dts             | 3 ++-
 arch/arm/boot/dts/kirkwood-l-50.dts               | 2 +-
 arch/arm/boot/dts/kirkwood-linksys-viper.dts      | 3 ++-
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts    | 3 ++-
 arch/arm/boot/dts/kirkwood-rd88f6281.dtsi         | 2 +-
 arch/arm/boot/dts/orion5x-netgear-wnr854t.dts     | 7 ++++++-
 13 files changed, 30 insertions(+), 14 deletions(-)

-- 
2.40.0

