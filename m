Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA8EAD6DA8
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 05:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfJODYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 23:24:54 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:14026 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726259AbfJODYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 23:24:54 -0400
X-UUID: 393ef18c0579491aa4be4347007febbf-20191015
X-UUID: 393ef18c0579491aa4be4347007febbf-20191015
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <biao.huang@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1144212828; Tue, 15 Oct 2019 11:24:50 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n2.mediatek.inc (172.21.101.79) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 15 Oct 2019 11:24:45 +0800
Received: from localhost.localdomain (10.17.3.153) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 15 Oct 2019 11:24:45 +0800
From:   Biao Huang <biao.huang@mediatek.com>
To:     <davem@davemloft.net>, Jose Abreu <joabreu@synopsys.com>,
        <andrew@lunn.ch>
CC:     <jakub.kicinski@netronome.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
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
Subject: [v2, PATCH 0/1] net: stmmac: disable/enable ptp_ref_clk in suspend/resume flow
Date:   Tue, 15 Oct 2019 11:24:43 +0800
Message-ID: <20191015032444.15145-1-biao.huang@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: CC6E8CD566D83072A794819F506A48A0A2C08C4DFDCF94BFA6A02093CC44E1072000:8
X-MTK:  N
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes in v2:
        1. add Fixes in commit message
        2. replace clk_disable/clk_enable with clk_disable_unprepare/clk_prepare_enable
        to ensure the source pll can be closed/open in suspend/resume for power saving.

Biao Huang (1):
  net: stmmac: disable/enable ptp_ref_clk in suspend/resume flow

 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--
2.18.0


