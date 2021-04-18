Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF153637C0
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhDRVMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:12:24 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35198 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhDRVMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:12:23 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id E076E63E34;
        Sun, 18 Apr 2021 23:11:23 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, john@phrozen.org,
        nbd@nbd.name, sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        dqfext@gmail.com, frank-w@public-files.de
Subject: [PATCH net-next 0/3] mtk_ppe_offload fixes
Date:   Sun, 18 Apr 2021 23:11:42 +0200
Message-Id: <20210418211145.21914-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

A few incremental fixes for the initial flowtable offload support
and this driver:

1) Fix undefined reference to `dsa_port_from_netdev' due to missing
   dependencies in Kconfig, reported by Kbuild robot.

2) Missing mutex to serialize flow events via workqueue to the driver.

3) Handle FLOW_ACTION_VLAN_POP tag action.

Please apply, thanks!

Pablo Neira Ayuso (3):
  net: ethernet: mtk_eth_soc: fix undefined reference to `dsa_port_from_netdev'
  net: ethernet: mtk_eth_soc: missing mutex
  net: ethernet: mtk_eth_soc: handle VLAN pop action

 drivers/net/ethernet/mediatek/Kconfig         |  1 +
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 21 ++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

-- 
2.20.1

