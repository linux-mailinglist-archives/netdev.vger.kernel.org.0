Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4D9316BA3
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhBJQsT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:48:19 -0500
Received: from mo-csw-fb1115.securemx.jp ([210.130.202.174]:47380 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbhBJQsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 11:48:13 -0500
X-Greylist: delayed 913 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Feb 2021 11:48:12 EST
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1115) id 11AGYw23013277; Thu, 11 Feb 2021 01:34:59 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 11AGUCSL006843; Thu, 11 Feb 2021 01:30:12 +0900
X-Iguazu-Qid: 2wGr679RaFze44qkqG
X-Iguazu-QSIG: v=2; s=0; t=1612974612; q=2wGr679RaFze44qkqG; m=gIDcb4kkM1O+D3JQdk8N2k7LylMYkPKopE0RIriw17g=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1113) id 11AGU8JO026471;
        Thu, 11 Feb 2021 01:30:08 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 11AGU84n001510;
        Thu, 11 Feb 2021 01:30:08 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 11AGU7MD013085;
        Thu, 11 Feb 2021 01:30:07 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        punit1.agrawal@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 0/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
Date:   Thu, 11 Feb 2021 01:29:50 +0900
X-TSB-HOP: ON
Message-Id: <20210210162954.3955785-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.27.0
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
 .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 292 ++++++++++++++++++
 7 files changed, 432 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/toshiba,visconti-dwmac.yaml
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c

-- 
2.27.0
