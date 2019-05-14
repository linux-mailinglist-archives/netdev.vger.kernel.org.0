Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80A061C101
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 05:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbfENDhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 23:37:37 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:12278 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726663AbfENDhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 23:37:37 -0400
X-UUID: b62509f4f7f1449eb455896f0889dd70-20190514
X-UUID: b62509f4f7f1449eb455896f0889dd70-20190514
Received: from mtkmrs01.mediatek.inc [(172.21.131.159)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 2073391937; Tue, 14 May 2019 11:37:30 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 14 May 2019 11:37:29 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 14 May 2019 11:37:28 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     Jose Abreu <joabreu@synopsys.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <biao.huang@mediatek.com>, <jianguo.zhang@mediatek.comi>,
        <boon.leong.ong@intel.com>
Subject: [v3, PATCH 0/4] fix some bugs in stmmac
Date:   Tue, 14 May 2019 11:37:22 +0800
Message-ID: <1557805046-306-1-git-send-email-biao.huang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes in v3:                                                                  
        add a Fixes:tag for each patch                                          
                                                                                
changes in v2:                                                                  
        1. update rx_tail_addr as Jose's comment                                
        2. changes clk_csr condition as Alex's proposition                      
        3. remove init lines in dwmac-mediatek, get clk_csr from dts instead.   
                                                                                
v1:                                                                             
This series fix some bugs in stmmac driver                                      
3 patches are for common stmmac or dwmac4:                                      
        1. update rx tail pointer to fix rx dma hang issue.                     
        2. change condition for mdc clock to fix csr_clk can't be zero issue.   
        3. write the modified value back to MTL_OPERATION_MODE.                 
1 patch is for dwmac-mediatek:                                                  
        modify csr_clk value to fix mdio read/write fail issue for dwmac-mediatek
                                                                                
Biao Huang (4):                                                                 
  net: stmmac: update rx tail pointer register to fix rx dma hang               
    issue.                                                                      
  net: stmmac: fix csr_clk can't be zero issue                                  
  net: stmmac: write the modified value back to MTL_OPERATION_MODE              
  net: stmmac: dwmac-mediatek: modify csr_clk value to fix mdio                 
    read/write fail                                                             
                                                                                
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |    2 --                   
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |    2 ++                   
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    7 ++++---              
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |    5 ++++-                
 4 files changed, 10 insertions(+), 6 deletions(-)                              
                                                                                
--                                                                              
1.7.9.5

