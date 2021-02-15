Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCAAA31BC69
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhBOP2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 10:28:16 -0500
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:41008 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhBOP1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:27:16 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 11FFOi05026353; Tue, 16 Feb 2021 00:24:44 +0900
X-Iguazu-Qid: 34tMYNXf5ebGia1lCa
X-Iguazu-QSIG: v=2; s=0; t=1613402684; q=34tMYNXf5ebGia1lCa; m=cj+MCU1y1W/fWNXIpwKsSHzvZL35tStosPJKR3uWZEE=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1512) id 11FFOgaS037437;
        Tue, 16 Feb 2021 00:24:43 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 11FFOgX0008332;
        Tue, 16 Feb 2021 00:24:42 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11FFOfSP017693;
        Tue, 16 Feb 2021 00:24:42 +0900
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
Subject: [PATCH v4 0/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
Date:   Tue, 16 Feb 2021 00:24:34 +0900
X-TSB-HOP: ON
Message-Id: <20210215152438.4318-1-nobuhiro1.iwamatsu@toshiba.co.jp>
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
    v3 -> v4: No update. Resend the correct patch series.
    v2 -> v3: Change to the correct dwmac version.
              Remove description of reg property.
              Update examples, drop dma-coherent, add snps,tso, fix phy-mode.
    v1 -> v2: No update.

  net: stmmac: Add Toshiba Visconti SoCs glue driver
    v3 -> v4: No update. Resend the correct patch series.
                https://lore.kernel.org/netdev/20210215050655.2532-3-nobuhiro1.iwamatsu@toshiba.co.jp/
                did not contain the following fixes:
                  - Drop def_bool y in Kconfig
                  - Change from bool to tristate in Kconfig option.
                  - Add 'default ARCH_VISCONTI' to Kconfig option.
                
    v2 -> v3: Remove code that is no longer needed by using compatible string.
              Drop def_bool y in Kconfig
              Change from bool to tristate in Kconfig option.
              Add 'default ARCH_VISCONTI' to Kconfig option.
    v1 -> v2: Use reverse christmas tree ordering for local variable declarations.

  MAINTAINERS: Add entries for Toshiba Visconti ethernet controller
    v3 -> v4: No update. Resend the correct patch series.
    v2 -> v3: No update.
    v1 -> v2: No update.

  arm: dts: visconti: Add DT support for Toshiba Visconti5 ethernet controller
    v3 -> v4: No update
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

