Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF482673FD8
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 18:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjASRZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 12:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjASRZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 12:25:46 -0500
Received: from dilbert.mork.no (dilbert.mork.no [IPv6:2a01:4f9:c010:a439::d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8242548637
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 09:25:41 -0800 (PST)
Received: from canardo.dyn.mork.no ([IPv6:2a01:799:c9a:3200:0:0:0:1])
        (authenticated bits=0)
        by dilbert.mork.no (8.15.2/8.15.2) with ESMTPSA id 30JHDBZ12320859
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 17:13:12 GMT
Received: from canardo.dyn.mork.no (ip6-localhost [IPv6:0:0:0:0:0:0:0:1])
        by canardo.dyn.mork.no (8.15.2/8.15.2) with ESMTPS id 30JHD6mA3882097
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=OK);
        Thu, 19 Jan 2023 18:13:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1674148386; bh=3M77ua0XQkmr+zsIbAEyz3vp5+v89MydrFMIqwukvHw=;
        h=From:To:Cc:Subject:Date:Message-Id:From;
        b=hFo6K42Zx1zABjpl+Gi1ohJw0fjoVnrPKculC2eEJGhnjwn+c/uVWTfxCiiyUUVaQ
         RrV+/J0EFKgKCIBsu/SwCLO0LvSPSCgSU3IVUnddTAXTo7eRBYyTsP1xO4gxDEhhCn
         o3i+i6A5RLQt9PgMblpnI1HC/rKj151TYCQmj2G4=
Received: (from bjorn@localhost)
        by canardo.dyn.mork.no (8.15.2/8.15.2/Submit) id 30JHD4gX3882094;
        Thu, 19 Jan 2023 18:13:04 +0100
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Daniel Golle <daniel@makrotopia.org>,
        Alexander Couzens <lynxis@fe80.eu>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH net 0/3] fixes for mtk_eth_soc
Date:   Thu, 19 Jan 2023 18:12:45 +0100
Message-Id: <20230119171248.3882021-1-bjorn@mork.no>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Virus-Scanned: clamav-milter 0.103.7 at canardo
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix mtk_eth_soc sgmii configuration.

This has been tested on a MT7986 with a Maxlinear GPY211C phy
permanently attached to the second SoC mac.

Alexander Couzens (1):
  net: mediatek: sgmii: ensure the SGMII PHY is powered down on
    configuration

Bjørn Mork (2):
  net: mediatek: sgmii: autonegotiation is required
  net: mediatek: sgmii: fix duplex configuration

 drivers/net/ethernet/mediatek/mtk_eth_soc.h |  2 +-
 drivers/net/ethernet/mediatek/mtk_sgmii.c   | 35 ++++++++++++---------
 2 files changed, 22 insertions(+), 15 deletions(-)

-- 
2.30.2

