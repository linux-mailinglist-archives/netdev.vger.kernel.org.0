Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99CD7DBD8
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 08:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfD2GQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 02:16:20 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:61139 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727460AbfD2GQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 02:16:17 -0400
X-UUID: 0137bd44709e48a0b763906698862109-20190429
X-UUID: 0137bd44709e48a0b763906698862109-20190429
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 625703698; Mon, 29 Apr 2019 14:16:07 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 29 Apr 2019 14:16:05 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 29 Apr 2019 14:16:04 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jose Abreu <joabreu@synopsys.com>, <davem@davemloft.net>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <biao.huang@mediatek.com>, <jianguo.zhang@mediatek.com>
Subject: [PATCH 0/4] fix some bugs in stmmac
Date:   Mon, 29 Apr 2019 14:15:52 +0800
Message-ID: <1556518556-32464-1-git-send-email-biao.huang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 29BA39CCF686AAB9215B307A05FAB453ECA786A1640899DC7C3C5E6100E51E9E2000:8
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fix some bugs in stmmac driver.               
3 patches are for common stmmac or dwmac4:                                      
        1. update rx tail pointer to fix rx dma hang issue.                     
        2. change condition for mdc clock to fix csr_clk can't be zero issue.   
        3. write the modified value back to MTL_OPERATION_MODE.                 
1 patche is for dwmac-mediatek:                                                 
        1. modify csr_clk value to fix mdio read/write fail issue for dwmac-mediatek.
                                                                                
                                                                                
Biao Huang (4):                                                                 
  net: stmmac: update rx tail pointer register to fix rx dma hang               
    issue.                                                                      
  net: stmmac: fix csr_clk can't be zero issue                                  
  net: stmmac: write the modified value back to MTL_OPERATION_MODE              
  net: stmmac: dwmac-mediatek: modify csr_clk value to fix mdio                 
    read/write fail                                                             
                                                                                
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |    4 ++--                 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |    2 ++                   
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    5 ++++-                
 3 files changed, 8 insertions(+), 3 deletions(-)                               
                                                                                
--                                                                              
1.7.9.5

