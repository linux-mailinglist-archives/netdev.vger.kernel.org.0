Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B746DAFA2
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 17:25:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjDGPZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 11:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbjDGPZ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 11:25:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE80976F
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 08:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=ZFBso+eT10UAQzgLzmLiHVl3qeSSr/FZm3nhGMtx6CE=; b=cpe0b4Yg9bzEjXbrfbKB3Ze3f8
        3oY3MhQLyxRJQWroYkTj0L7erTx42ut46yXcc4U2ikEGRvnpqFeA9RHPui7RUzTr+ppBq1hGg01C7
        IN3fn0b/WTF9Npym1ayTLrX9p5zbaI/RqhxI2MaZnMO7vK6tqi8BpGY2DGZkXe8cOog4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pknxp-009jjY-OE; Fri, 07 Apr 2023 17:25:21 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     shawnguo@kernel.org
Cc:     s.hauer@pengutronix.de, Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 0/3] Add missing DSA properties for marvell switches
Date:   Fri,  7 Apr 2023 17:25:00 +0200
Message-Id: <20230407152503.2320741-1-andrew@lunn.ch>
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
add missing properties and removes some unused ones, for iMX boards.

Once all the missing properties are added, it should be possible to
simply phylink and the mv88e6xxx driver.

Andrew Lunn (3):
  ARM: dts: imx51: ZII: Add missing phy-mode
  ARM: dts: imx6qdl: Add missing phy-mode and fixed links
  ARM64: dts: freescale: ZII: Add missing phy-mode

 arch/arm/boot/dts/imx51-zii-rdu1.dts                | 2 +-
 arch/arm/boot/dts/imx51-zii-scu2-mezz.dts           | 2 +-
 arch/arm/boot/dts/imx51-zii-scu3-esb.dts            | 1 -
 arch/arm/boot/dts/imx6qdl-gw5904.dtsi               | 7 ++++++-
 arch/arm/boot/dts/imx6qdl-zii-rdu2.dtsi             | 2 +-
 arch/arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi | 2 +-
 6 files changed, 10 insertions(+), 6 deletions(-)

-- 
2.40.0

