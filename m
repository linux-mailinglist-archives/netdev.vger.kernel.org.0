Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1B3464490
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 02:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241264AbhLABid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 20:38:33 -0500
Received: from inva020.nxp.com ([92.121.34.13]:33944 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240869AbhLABic (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 20:38:32 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 2D73C1A1968;
        Wed,  1 Dec 2021 02:35:10 +0100 (CET)
Received: from aprdc01srsp001v.ap-rdc01.nxp.com (aprdc01srsp001v.ap-rdc01.nxp.com [165.114.16.16])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id E695E1A1971;
        Wed,  1 Dec 2021 02:35:09 +0100 (CET)
Received: from localhost.localdomain (mega.ap.freescale.net [10.192.208.232])
        by aprdc01srsp001v.ap-rdc01.nxp.com (Postfix) with ESMTP id D41A6183AC4E;
        Wed,  1 Dec 2021 09:35:07 +0800 (+08)
From:   Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kuba@kernel.org, qiangqing.zhang@nxp.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        yannick.vignon@nxp.com, boon.leong.ong@intel.com,
        Jose.Abreu@synopsys.com, mst@redhat.com, Joao.Pinto@synopsys.com,
        mingkai.hu@nxp.com, leoyang.li@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 0/2] multiple queues support on imx8mp-evk
Date:   Wed,  1 Dec 2021 09:47:03 +0800
Message-Id: <20211201014705.6975-1-xiaoliang.yang_1@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series configures five multiple queues for RX and TX on
imx8mp-evk, and uses Strict Priority as scheduling algorithms.

Make stmmac-tx-timeout configurable so that users can disable it in the
SP queue scheduling algorithm.

Xiaoliang Yang (2):
  arm64: dts: imx8mp-evk: configure multiple queues on eqos
  net: stmmac: make stmmac-tx-timeout configurable in Kconfig

 arch/arm64/boot/dts/freescale/imx8mp-evk.dts  | 41 +++++++++++++++++++
 drivers/net/ethernet/stmicro/stmmac/Kconfig   | 12 ++++++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 ++
 3 files changed, 57 insertions(+)

-- 
2.17.1

