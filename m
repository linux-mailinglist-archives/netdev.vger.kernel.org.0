Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AA761EDE9
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 09:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbiKGI5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 03:57:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbiKGI5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 03:57:00 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D370815836;
        Mon,  7 Nov 2022 00:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667811419; x=1699347419;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JUuttcam/kX5WhwOtREgD468JIzImAX+Wko5azZ7EXU=;
  b=xA4k4noBOekVHY3rgobcasOaSQfrE9bJKqYijQAQQHbRBr8hZMuDiz+Z
   ZZC61lIkpObYKFZ5DLmV6jO9WF6lhaeJwi8fhDamZRc1EXevVPZbVf2dB
   MRHmz0bMZ4mAx4+uI1w1gizYsNJbU9FZlCiuCO5t6qTHvmqQ1Hv5nuhqE
   xypt3mdDnEfwfOEgZf+1j8/tiKhVB3GQ5690ZtfNBVd83apJErgjNm9OW
   JpQdLgd7pWy3wkAd39FCLJ3VzqT1qTtd8JjFS1hNV9QXlVlFtYi9IKxdc
   N8ey/jaxDcWjowKOD4fSIZq9RirkvmEjktq1q54s0wo3RqCLXgY0XYoZO
   A==;
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="185662505"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Nov 2022 01:56:59 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 7 Nov 2022 01:56:57 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Mon, 7 Nov 2022 01:56:53 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <pabeni@redhat.com>, <edumazet@google.com>, <olteanv@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V7 0/2] net: lan743x: PCI11010 / PCI11414 devices Enhancements
Date:   Mon, 7 Nov 2022 14:26:48 +0530
Message-ID: <20221107085650.991470-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series continues with the addition of supported features for the
Ethernet function of the PCI11010 / PCI11414 devices to the LAN743x driver.

Raju Lakkaraju (2):
  net: lan743x: Remove unused argument in lan743x_common_regs( )
  net: lan743x: Add support to SGMII register dump for PCI11010/PCI11414
    chips

 .../net/ethernet/microchip/lan743x_ethtool.c  | 113 +++++++++++++++++-
 .../net/ethernet/microchip/lan743x_ethtool.h  |  71 ++++++++++-
 drivers/net/ethernet/microchip/lan743x_main.c |   2 +-
 drivers/net/ethernet/microchip/lan743x_main.h |   1 +
 4 files changed, 179 insertions(+), 8 deletions(-)

-- 
2.25.1

