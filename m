Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18AE33D7118
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 10:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbhG0IWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 04:22:00 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:5647 "EHLO
        relmlie5.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235740AbhG0IWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 04:22:00 -0400
X-IronPort-AV: E=Sophos;i="5.84,272,1620658800"; 
   d="scan'208";a="88892215"
Received: from unknown (HELO relmlir5.idc.renesas.com) ([10.200.68.151])
  by relmlie5.idc.renesas.com with ESMTP; 27 Jul 2021 17:21:59 +0900
Received: from localhost.localdomain (unknown [10.166.14.185])
        by relmlir5.idc.renesas.com (Postfix) with ESMTP id 2B307400D4FF;
        Tue, 27 Jul 2021 17:21:59 +0900 (JST)
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     sergei.shtylyov@gmail.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 0/2] ravb and sh_eth: Fix descriptor counters' conditions
Date:   Tue, 27 Jul 2021 17:21:45 +0900
Message-Id: <20210727082147.270734-1-yoshihiro.shimoda.uh@renesas.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When we change the type of {cur,dirty}_tx from u32 to u8, we can
reproduce this issue easily.

Yoshihiro Shimoda (2):
  ravb: Fix descriptor counters' conditions
  sh_eth: Fix descriptor counters' conditions

 drivers/net/ethernet/renesas/ravb_main.c | 22 +++++++++++++++-------
 drivers/net/ethernet/renesas/sh_eth.c    | 16 ++++++++++++----
 2 files changed, 27 insertions(+), 11 deletions(-)

-- 
2.25.1

