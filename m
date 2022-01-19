Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2638D493421
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 05:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351579AbiASExv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 23:53:51 -0500
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:48472 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351335AbiASExu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 23:53:50 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 20J4qDKk018584; Wed, 19 Jan 2022 13:52:14 +0900
X-Iguazu-Qid: 34trXZuAsxlohqpaPS
X-Iguazu-QSIG: v=2; s=0; t=1642567933; q=34trXZuAsxlohqpaPS; m=0yidoEs59p9yDaB5qifBWEqQ4TxJweLoniwSrs5tqCI=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1513) id 20J4qBLp037215
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 19 Jan 2022 13:52:12 +0900
X-SA-MID: 31820870
From:   Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp
Subject: [PATCH v2 0/2] net: stmmac: dwmac-visconti: Fix bit definitions and clock configuration for RMII mode
Date:   Wed, 19 Jan 2022 13:46:46 +0900
X-TSB-HOP: ON
X-TSB-HOP2: ON
Message-Id: <20220119044648.18094-1-yuji2.ishikawa@toshiba.co.jp>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series is a fix for RMII/MII operation mode of the dwmac-visconti driver.
It is composed of two parts:

* 1/2: fix constant definitions for cleared bits in ETHER_CLK_SEL register
* 2/2: fix configuration of ETHER_CLK_SEL register for running in RMII operation mode.

Best regards,
  Yuji

  net: stmmac: dwmac-visconti: Fix bit definitions for ETHER_CLK_SEL
    v1 -> v2:
      - added Fixes tag to commit message

  net: stmmac: dwmac-visconti: Fix clock configuration for RMII mode
    v1 -> v2:
      - added Fixes tag to commit message

Yuji Ishikawa (2):
  net: stmmac: dwmac-visconti: Fix bit definitions for ETHER_CLK_SEL
  net: stmmac: dwmac-visconti: Fix clock configuration for RMII mode

 .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 42 ++++++++++++-------
 1 file changed, 26 insertions(+), 16 deletions(-)

-- 
2.17.1


