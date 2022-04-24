Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9DC750CE7A
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 04:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbiDXCdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 22:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235794AbiDXCdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 22:33:37 -0400
X-Greylist: delayed 400 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 23 Apr 2022 19:30:38 PDT
Received: from smtp2.emailarray.com (smtp.emailarray.com [69.28.212.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD2927FE9
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 19:30:38 -0700 (PDT)
Received: (qmail 42047 invoked by uid 89); 24 Apr 2022 02:23:57 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTc0LjIxLjE0NC4yOQ==) (POLARISLOCAL)  
  by smtp2.emailarray.com with SMTP; 24 Apr 2022 02:23:57 -0000
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH net-next v1 0/4] Broadcom PTP PHY support
Date:   Sat, 23 Apr 2022 19:23:52 -0700
Message-Id: <20220424022356.587949-1-jonathan.lemon@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds PTP support for the Broadcom PHY BCM54210E (and the
specific variant BCM54213PE that the rpi-5.15 branch uses).

This has only been tested on the RPI CM4, which has one port.

There are other Broadcom chips which may benefit from using the 
same framework here, although with different register sets.

Jonathan Lemon (4):
  net: phy: broadcom: Add PTP support for some Broadcom PHYs.
  net: phy: broadcom: Add Broadcom PTP hooks to bcm-phy-lib
  net: phy: broadcom: Hook up the PTP PHY functions
  net: phy: Kconfig: Add broadcom PTP PHY library

 drivers/net/phy/Kconfig       |  10 +
 drivers/net/phy/Makefile      |   1 +
 drivers/net/phy/bcm-phy-lib.c |  13 +
 drivers/net/phy/bcm-phy-lib.h |   3 +
 drivers/net/phy/bcm-phy-ptp.c | 736 ++++++++++++++++++++++++++++++++++
 drivers/net/phy/broadcom.c    |  23 +-
 6 files changed, 782 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/phy/bcm-phy-ptp.c

-- 
2.31.1

