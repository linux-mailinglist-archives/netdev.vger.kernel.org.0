Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735C560DAD5
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 07:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbiJZF7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 01:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232404AbiJZF7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 01:59:31 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2832655B6;
        Tue, 25 Oct 2022 22:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666763969; x=1698299969;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OPDRIT/NOY3NT0+5LfoVi5N4UHTzaLqe4zrXkJfQebs=;
  b=YVJG1Ku/z6kD3og0klRK5BsT+pT6oxQ3mUPi5IwSzDqlBbgnorsKUcos
   yecnOcFjrGHY9o//k8+nT+fEktKicPLDdKo3QGVRsDnHMw4PevSVir/KS
   iwRfVDfgZ3CtLrX2APa7O2+heh1ZfI4EKylRhTBGWogmE6OYINyRzcGFV
   VxZ3UFnBrr9h5XZ0XTINEK1DVfUCvqiyQMXnR+aX/lcgO80CW9QUxdI+Z
   Harqzxtcl4mq3XRiYyJ+nPHRzRueQ8n+nUU18EBs64rMyXwcEadifZD8S
   k3JlkanZmvPsW+wcPlzQUP9cX38jxpyfS+CkJcc0V6kR2wKVLGrQaGNgz
   w==;
X-IronPort-AV: E=Sophos;i="5.95,213,1661842800"; 
   d="scan'208";a="120382949"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Oct 2022 22:59:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 25 Oct 2022 22:59:27 -0700
Received: from localhost.localdomain (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 25 Oct 2022 22:59:23 -0700
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <lxu@maxlinear.com>,
        <hkallweit1@gmail.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: [PATCH net-next V1 0/2] net: phy: mxl-gpy: Add MDI-X 
Date:   Wed, 26 Oct 2022 11:29:16 +0530
Message-ID: <20221026055918.4225-1-Raju.Lakkaraju@microchip.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series add the MDI-X feature to GPY211 PHYs and
Also Change return type to gpy_update_interface() function

Raju Lakkaraju (2):
  net: phy: mxl-gpy: Change gpy_update_interface() function return type
  net: phy: mxl-gpy: Add PHY Auto/MDI/MDI-X set driver for GPY211 chips

 drivers/net/phy/mxl-gpy.c | 98 +++++++++++++++++++++++++++++++++++----
 1 file changed, 90 insertions(+), 8 deletions(-)

-- 
2.25.1

