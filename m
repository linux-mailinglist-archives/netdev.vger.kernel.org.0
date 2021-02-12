Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8B8319884
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:02:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhBLDBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 22:01:50 -0500
Received: from mo-csw1515.securemx.jp ([210.130.202.154]:32832 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhBLDBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 22:01:05 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 11C2wKej016608; Fri, 12 Feb 2021 11:58:20 +0900
X-Iguazu-Qid: 34tKUV8MihhtQgcHLv
X-Iguazu-QSIG: v=2; s=0; t=1613098700; q=34tKUV8MihhtQgcHLv; m=gpvUeawsXclZN4YQhPpKttHVr6pf75YS4CpRjjvDrSA=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1510) id 11C2wIiT024951;
        Fri, 12 Feb 2021 11:58:19 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 11C2wIIM017954;
        Fri, 12 Feb 2021 11:58:18 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11C2wIhW003971;
        Fri, 12 Feb 2021 11:58:18 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, punit1.agrawal@toshiba.co.jp,
        yuji2.ishikawa@toshiba.co.jp, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH v2 0/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
Date:   Fri, 12 Feb 2021 11:58:02 +0900
X-TSB-HOP: ON
Message-Id: <20210212025806.556217-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.30.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series is the ethernet driver for Toshiba's ARM SoC, Visconti[0].
This provides DT binding documentation, device driver, MAINTAINER files, and updates to DT files.

Best regards,
  Nobuhiro

[0]: https://toshiba.semicon-storage.com/ap-en/semiconductor/product/image-recognition-processors-visconti.htmli

Updates:

  dt-bindings: net: Add DT bindings for Toshiba Visconti TMPV7700 SoC
    v1 -> v2: No update.

  net: stmmac: Add Toshiba Visconti SoCs glue driver
    v1 -> v2: Use reverse christmas tree ordering for local variable declarations.

  MAINTAINERS: Add entries for Toshiba Visconti ethernet controller
    v1 -> v2: No update.

  arm: dts: visconti: Add DT support for Toshiba Visconti5 ethernet controller
    v1 -> v2: No update.

Nobuhiro Iwamatsu (4):
  dt-bindings: net: Add DT bindings for Toshiba Visconti TMPV7700 SoC
  net: stmmac: Add Toshiba Visconti SoCs glue driver
  MAINTAINERS: Add entries for Toshiba Visconti ethernet controller
  arm: dts: visconti: Add DT support for Toshiba Visconti5 ethernet
    controller

 .../bindings/net/toshiba,visconti-dwmac.yaml  |  87 ++++++
 MAINTAINERS                                   |   2 +
 .../boot/dts/toshiba/tmpv7708-rm-mbrc.dts     |  18 ++
 arch/arm64/boot/dts/toshiba/tmpv7708.dtsi     |  24 ++
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   8 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 288 ++++++++++++++++++
 7 files changed, 428 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c

-- 
2.30.0.rc2
