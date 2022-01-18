Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6EC491F3E
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 07:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240061AbiARGFP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 01:05:15 -0500
Received: from mo-csw-fb1115.securemx.jp ([210.130.202.174]:43516 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiARGFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 01:05:14 -0500
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1115) id 20I5k6bN007806; Tue, 18 Jan 2022 14:46:07 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 20I5jXKj029185; Tue, 18 Jan 2022 14:45:34 +0900
X-Iguazu-Qid: 2wHHIL40QtV8NW2CLi
X-Iguazu-QSIG: v=2; s=0; t=1642484733; q=2wHHIL40QtV8NW2CLi; m=yz8q50yz9Zps8BdmZbXaoX+nNcTm3OkiNrwjlcmatLE=
Received: from imx12-a.toshiba.co.jp (imx12-a.toshiba.co.jp [61.202.160.135])
        by relay.securemx.jp (mx-mr1110) id 20I5jVqx037499
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 18 Jan 2022 14:45:32 +0900
X-SA-MID: 31741573
From:   Yuji Ishikawa <yuji2.ishikawa@toshiba.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        nobuhiro1.iwamatsu@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp
Subject: [PATCH 0/2] net: stmmac: dwmac-visconti: Fix bit definitions and clock configuration for RMII mode
Date:   Tue, 18 Jan 2022 14:39:48 +0900
X-TSB-HOP: ON
X-TSB-HOP2: ON
Message-Id: <20220118053950.2605-1-yuji2.ishikawa@toshiba.co.jp>
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

Yuji Ishikawa (2):
  net: stmmac: dwmac-visconti: Fix bit definitions for ETHER_CLK_SEL
  net: stmmac: dwmac-visconti: Fix clock configuration for RMII mode

 .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 42 ++++++++++++-------
 1 file changed, 26 insertions(+), 16 deletions(-)

-- 
2.17.1


