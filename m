Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0496131B4F6
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 06:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhBOFJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 00:09:48 -0500
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:39632 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbhBOFJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 00:09:37 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 11F577A3015166; Mon, 15 Feb 2021 14:07:07 +0900
X-Iguazu-Qid: 34tKUV8MimxR7ZIuD6
X-Iguazu-QSIG: v=2; s=0; t=1613365626; q=34tKUV8MimxR7ZIuD6; m=MS7teCp+O8x8PHbRPtbPQMWlgpxAEzzRds7XFt0rzvg=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1510) id 11F575WI005028;
        Mon, 15 Feb 2021 14:07:05 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 11F575I4029837;
        Mon, 15 Feb 2021 14:07:05 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 11F574E5021262;
        Mon, 15 Feb 2021 14:07:04 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, leon@kernel.org,
        arnd@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, punit1.agrawal@toshiba.co.jp,
        yuji2.ishikawa@toshiba.co.jp, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH v3 0/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
Date:   Mon, 15 Feb 2021 14:06:51 +0900
X-TSB-HOP: ON
Message-Id: <20210215050655.2532-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.30.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series is the ethernet driver for Toshiba's ARM SoC, Visconti[0].
This provides DT binding documentation, device driver, MAINTAINER files,
and updates to DT files.

Best regards,
  Nobuhiro

[0]:
https://toshiba.semicon-storage.com/ap-en/semiconductor/product/image-recognition-processors-visconti.htmli

Updates:

  dt-bindings: net: Add DT bindings for Toshiba Visconti TMPV7700 SoC
    v2 -> v3: Change to the correct dwmac version.
              Remove description of reg property.
              Update examples, drop dma-coherent, add snps,tso, fix phy-mode.
    v1 -> v2: No update.

  net: stmmac: Add Toshiba Visconti SoCs glue driver
    v2 -> v3: Remove code that is no longer needed by using compatible string.
              Drop def_bool y in Kconfig
    v1 -> v2: Use reverse christmas tree ordering for local variable declarations.

  MAINTAINERS: Add entries for Toshiba Visconti ethernet controller
    v2 -> v3: No update.
    v1 -> v2: No update.

  arm: dts: visconti: Add DT support for Toshiba Visconti5 ethernet controller
    v2 -> v3: Add "snps,dwmac-4.20a" as compatible string.
              Add snps,tso.
    v1 -> v2: No update.

Nobuhiro Iwamatsu (4):
  dt-bindings: net: Add DT bindings for Toshiba Visconti TMPV7700 SoC
  net: stmmac: Add Toshiba Visconti SoCs glue driver
  MAINTAINERS: Add entries for Toshiba Visconti ethernet controller
  arm: dts: visconti: Add DT support for Toshiba Visconti5 ethernet
    controller

 .../bindings/net/toshiba,visconti-dwmac.yaml  |  85 ++++++
 MAINTAINERS                                   |   2 +
 .../boot/dts/toshiba/tmpv7708-rm-mbrc.dts     |  18 ++
 arch/arm64/boot/dts/toshiba/tmpv7708.dtsi     |  25 ++
 drivers/net/ethernet/stmicro/stmmac/Kconfig   |   8 +
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
 .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 285 ++++++++++++++++++
 7 files changed, 424 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c

-- 
2.30.0.rc2

