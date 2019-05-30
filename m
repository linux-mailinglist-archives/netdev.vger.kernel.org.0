Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E15042F970
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 11:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbfE3Jaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 05:30:55 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:15383 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727356AbfE3Jay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 05:30:54 -0400
X-UUID: ba85fada50304ce3abf857842f0278d5-20190530
X-UUID: ba85fada50304ce3abf857842f0278d5-20190530
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1710745226; Thu, 30 May 2019 17:30:30 +0800
Received: from mtkcas09.mediatek.inc (172.21.101.178) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 30 May 2019 17:30:29 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas09.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Thu, 30 May 2019 17:30:28 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jose Abreu <joabreu@synopsys.com>
CC:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <yt.shen@mediatek.com>,
        <biao.huang@mediatek.com>, <jianguo.zhang@mediatek.com>,
        <boon.leong.ong@intel.com>, <andrew@lunn.ch>
Subject: [v7, PATCH] add some features in stmmac
Date:   Thu, 30 May 2019 17:30:25 +0800
Message-ID: <1559208626-3218-1-git-send-email-biao.huang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v7:                                                                  
        complete the selftest output log in v6.                                       
                                                                                
Changes in v6:                                                                  
        update commit message with selftest output log when flow control on        
                                                                                
Changes in v5:                                                                  
        1. run checkpatch.pl to fix coding style issue.                         
        2. apply reverse xmas tree.                                             
        3. add output log of "ethtool -t eth0" to commit message.               
                                                                                
Changes in v4:                                                                  
        retain the reverse xmas tree ordering.                                  
                                                                                
Changes in v3:                                                                  
        rewrite the patch base on serires in                                    
        https://patchwork.ozlabs.org/project/netdev/list/?series=109699         
                                                                                
Changes in v2;                                                                  
        1. reverse Christmas tree order in dwmac4_set_filter.                   
        2. remove clause 45 patch, waiting for cl45 patch from Boon Leong          
                                                                                
v1:                                                                             
This series add some features in stmmac driver.                                 
        1. add support for hash table size 128/256                              
        2. add mdio clause 45 access from mac device for dwmac4.                
                                                                                
Biao Huang (1):                                                                 
  net: stmmac: add support for hash table size 128/256 in dwmac4                
                                                                                
 drivers/net/ethernet/stmicro/stmmac/common.h      |    7 +--                   
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      |    4 +-                    
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |   49 ++++++++++++--------- 
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c  |    1 +                     
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    6 +++                   
 5 files changed, 42 insertions(+), 25 deletions(-)                             
                                                                                
--                                                                              
1.7.9.5

