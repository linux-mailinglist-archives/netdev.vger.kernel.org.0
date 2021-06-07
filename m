Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7438939E55A
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 19:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhFGRaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 13:30:12 -0400
Received: from out28-197.mail.aliyun.com ([115.124.28.197]:42575 "EHLO
        out28-197.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhFGRaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 13:30:11 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.5632897|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00534723-0.0028745-0.991778;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047206;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=20;RT=20;SR=0;TI=SMTPD_---.KP.FCzB_1623086888;
Received: from zhouyanjie-virtual-machine.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KP.FCzB_1623086888)
          by smtp.aliyun-inc.com(10.147.40.44);
          Tue, 08 Jun 2021 01:28:16 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com, paul@crapouillou.net
Subject: [PATCH 0/2] Add Ingenic SoCs MAC support.
Date:   Tue,  8 Jun 2021 01:27:45 +0800
Message-Id: <1623086867-119039-1-git-send-email-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1.Add the dwmac bindings for the JZ4775 SoC, the X1000 SoC,
  the X1600 SoC, the X1830 SoC and the X2000 SoC from Ingenic.
2.Add support for Ingenic SoC MAC glue layer support for the stmmac
  device driver. This driver is used on for the MAC ethernet controller
  found in the JZ4775 SoC, the X1000 SoC, the X1600 SoC, the X1830 SoC,
  and the X2000 SoC.

周琰杰 (Zhou Yanjie) (2):
  dt-bindings: dwmac: Add bindings for new Ingenic SoCs.
  net: stmmac: Add Ingenic SoCs MAC support.

 .../devicetree/bindings/net/snps,dwmac.yaml        |  15 +
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |  16 +-
 drivers/net/ethernet/stmicro/stmmac/Makefile       |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-ingenic.c    | 367 +++++++++++++++++++++
 4 files changed, 397 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c

-- 
2.7.4

