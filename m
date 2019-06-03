Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBBF3264B
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 03:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfFCB62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 21:58:28 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:9859 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726587AbfFCB62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 21:58:28 -0400
X-UUID: 883802220f714c1b96c41c46de9ef1f6-20190603
X-UUID: 883802220f714c1b96c41c46de9ef1f6-20190603
Received: from mtkcas09.mediatek.inc [(172.21.101.178)] by mailgw01.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 95759638; Mon, 03 Jun 2019 09:58:20 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 3 Jun 2019 09:58:18 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 3 Jun 2019 09:58:17 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jose Abreu <joabreu@synopsys.com>,
        <andrew@lunn.ch>
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
        <boon.leong.ong@intel.com>
Subject: [v2, PATCH 0/4] complete dwmac-mediatek driver and fix flow control issue
Date:   Mon, 3 Jun 2019 09:58:02 +0800
Message-ID: <1559527086-7227-1-git-send-email-biao.huang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: EC69FD41C9E8FD24660C96396E7791983B1B28FC35671685A2509970C2084FF82000:8
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v2:                                                                  
        patch#1: there is no extra action in mediatek_dwmac_remove, remove it            
                                                                                
v1:                                                                             
This series mainly complete dwmac-mediatek driver:                              
        1. add power on/off operations for dwmac-mediatek.                      
        2. disable rx watchdog to reduce rx path reponding time.                
        3. change the default value of tx-frames from 25 to 1, so               
           ptp4l will test pass by default.                                     
                                                                                
and also fix the issue that flow control won't be disabled any more             
once being enabled.                                                             
                                                                                
Biao Huang (4):                                                                 
  net: stmmac: dwmac-mediatek: enable Ethernet power domain                     
  net: stmmac: dwmac-mediatek: disable rx watchdog                              
  net: stmmac: modify default value of tx-frames                                
  net: stmmac: dwmac4: fix flow control issue                                   
                                                                                
 drivers/net/ethernet/stmicro/stmmac/common.h       |    2 +-                   
 .../net/ethernet/stmicro/stmmac/dwmac-mediatek.c   |    8 ++++++++             
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |    8 ++++++--             
 3 files changed, 15 insertions(+), 3 deletions(-)                              
                                                                                
--                                                                              
1.7.9.5

