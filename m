Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F213A6CF3
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 19:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbhFNRUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 13:20:04 -0400
Received: from out28-193.mail.aliyun.com ([115.124.28.193]:59975 "EHLO
        out28-193.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233653AbhFNRUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 13:20:03 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.3305371|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00425795-0.000892991-0.994849;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047208;MF=zhouyanjie@wanyeetech.com;NM=1;PH=DS;RN=21;RT=21;SR=0;TI=SMTPD_---.KSAJpVJ_1623691068;
Received: from localhost.localdomain(mailfrom:zhouyanjie@wanyeetech.com fp:SMTPD_---.KSAJpVJ_1623691068)
          by smtp.aliyun-inc.com(10.147.41.121);
          Tue, 15 Jun 2021 01:17:57 +0800
From:   =?UTF-8?q?=E5=91=A8=E7=90=B0=E6=9D=B0=20=28Zhou=20Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        matthias.bgg@gmail.com
Cc:     alexandre.torgue@st.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, dongsheng.qiu@ingenic.com,
        aric.pzqi@ingenic.com, rick.tyliu@ingenic.com,
        sihui.liu@ingenic.com, jun.jiang@ingenic.com,
        sernia.zhou@foxmail.com
Subject: [PATCH v3 0/2] Add Ingenic SoCs MAC support.
Date:   Tue, 15 Jun 2021 01:15:35 +0800
Message-Id: <1623690937-52389-1-git-send-email-zhouyanjie@wanyeetech.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2->v3:
1.Add "ingenic,mac.yaml" for Ingenic SoCs.
2.Change tx clk delay and rx clk delay from hardware value to ps.
3.return -EINVAL when a unsupported value is encountered when
  parsing the binding.
4.Simplify the code of the RGMII part of X2000 SoC according to
  Andrew Lunn’s suggestion.
5.Follow the example of "dwmac-mediatek.c" to improve the code
  that handles delays according to Andrew Lunn’s suggestion.

周琰杰 (Zhou Yanjie) (2):
  dt-bindings: dwmac: Add bindings for new Ingenic SoCs.
  net: stmmac: Add Ingenic SoCs MAC support.

 .../devicetree/bindings/net/ingenic,mac.yaml       |  76 ++++
 .../devicetree/bindings/net/snps,dwmac.yaml        |  15 +
 drivers/net/ethernet/stmicro/stmmac/Kconfig        |  12 +
 drivers/net/ethernet/stmicro/stmmac/Makefile       |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac-ingenic.c    | 401 +++++++++++++++++++++
 5 files changed, 505 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ingenic,mac.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-ingenic.c

-- 
2.7.4

