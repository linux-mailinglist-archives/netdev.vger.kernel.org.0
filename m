Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FEF6DBBDE
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 17:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjDHP22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Apr 2023 11:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjDHP21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 11:28:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A019A10C3
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 08:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:From:Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:
        Content-Type:Content-Transfer-Encoding:Content-ID:Content-Description:
        Content-Disposition:In-Reply-To:References;
        bh=1qZ4TpCRmg2TEJajicVO8BShYslDoibdZyBbwyL6r68=; b=1tS3WijXyIZMeD2qpCy39a0+QX
        zkYgpzVpbza1yTL3GS9rchsvV2jQ91tHBmv4bKcDTow0MbhxSMOzVtGEiHGQio/yAZs5RDgmCajJH
        WDw9RmvdmjleyUMvZnZ/qd4wWb/kIl2SRhx5QLaIGK38oyy7VBfoWjN2M7af8eO32ww0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1plAUD-009niH-U4; Sat, 08 Apr 2023 17:28:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     shawnguo@kernel.org
Cc:     s.hauer@pengutronix.de, Russell King <rmk+kernel@armlinux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        arm-soc <arm@kernel.org>, netdev <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 0/3] Add missing DSA properties for marvell switches
Date:   Sat,  8 Apr 2023 17:27:58 +0200
Message-Id: <20230408152801.2336041-1-andrew@lunn.ch>
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

v2:
Use rev-mii or rev-rmii for the side of the MAC-MAC link which plays
PHY.

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

