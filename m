Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123CF262F2D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 15:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbgIIN2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 09:28:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11720 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730356AbgIINV6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 09:21:58 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C2CC8973CFAD018ABD1F;
        Wed,  9 Sep 2020 21:21:40 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 21:21:39 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <jirislaby@kernel.org>, <mickflemm@gmail.com>, <mcgrof@kernel.org>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] ath5k: fix 'mode' kernel-doc warning in ath5k_hw_pcu_init()
Date:   Wed, 9 Sep 2020 21:18:58 +0800
Message-ID: <20200909131858.70391-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

drivers/net/wireless/ath/ath5k/pcu.c:955: warning: Excess function parameter 'mode' description in 'ath5k_hw_pcu_init'

This parameter is not in use. Remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/wireless/ath/ath5k/pcu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 05140d8baa36..3df5f27708fc 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -945,7 +945,6 @@ ath5k_hw_set_opmode(struct ath5k_hw *ah, enum nl80211_iftype op_mode)
  * ath5k_hw_pcu_init() - Initialize PCU
  * @ah: The &struct ath5k_hw
  * @op_mode: One of enum nl80211_iftype
- * @mode: One of enum ath5k_driver_mode
  *
  * This function is used to initialize PCU by setting current
  * operation mode and various other settings.
-- 
2.17.1

