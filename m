Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D9461F4B6
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 14:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbiKGN6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 08:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbiKGN6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 08:58:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA12A1D0ED
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 05:58:07 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1os2dS-0003FS-KS; Mon, 07 Nov 2022 14:57:58 +0100
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1os2dQ-002rm8-DG; Mon, 07 Nov 2022 14:57:57 +0100
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1os2dQ-00BBIl-Hk; Mon, 07 Nov 2022 14:57:56 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com
Subject: [PATCH net-next v2 0/3] net: dsa: microchip: add MTU support for KSZ8 series 
Date:   Mon,  7 Nov 2022 14:57:52 +0100
Message-Id: <20221107135755.2664997-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v2:
- add ksz_rmw8() helper
- merge all max MTUs to one location

Oleksij Rempel (3):
  net: dsa: microchip: move max mtu to one location
  net: dsa: microchip: add ksz_rmw8() function
  net: dsa: microchip: ksz8: add MTU configuration support

 drivers/net/dsa/microchip/ksz8.h        |  1 +
 drivers/net/dsa/microchip/ksz8795.c     | 57 ++++++++++++++++++++++++-
 drivers/net/dsa/microchip/ksz8795_reg.h |  3 ++
 drivers/net/dsa/microchip/ksz9477.c     |  5 ---
 drivers/net/dsa/microchip/ksz9477.h     |  1 -
 drivers/net/dsa/microchip/ksz9477_reg.h |  2 -
 drivers/net/dsa/microchip/ksz_common.c  | 28 +++++++++---
 drivers/net/dsa/microchip/ksz_common.h  | 12 +++++-
 8 files changed, 93 insertions(+), 16 deletions(-)

-- 
2.30.2

