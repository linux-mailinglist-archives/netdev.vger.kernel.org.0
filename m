Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4896426FA56
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgIRKS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:18:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56640 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725882AbgIRKSX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 06:18:23 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 377FDE9BA030F1202494;
        Fri, 18 Sep 2020 18:18:20 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Fri, 18 Sep 2020
 18:18:11 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next 0/9] rtlwifi: fix comparison to bool warnings
Date:   Fri, 18 Sep 2020 18:24:56 +0800
Message-ID: <20200918102505.16036-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheng Bin (9):
  rtlwifi: rtl8192ee: fix comparison to bool warning in hw.c
  rtlwifi: rtl8192c: fix comparison to bool warning in phy_common.c
  rtlwifi: rtl8192cu: fix comparison to bool warning in mac.c
  rtlwifi: rtl8821ae: fix comparison to bool warning in hw.c
  rtlwifi: rtl8821ae: fix comparison to bool warning in phy.c
  rtlwifi: rtl8192cu: fix comparison to bool warning in hw.c
  rtlwifi: rtl8192ce: fix comparison to bool warning in hw.c
  rtlwifi: rtl8192de: fix comparison to bool warning in hw.c
  rtlwifi: rtl8723be: fix comparison to bool warning in hw.c

 .../net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c    | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c       | 8 ++++----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c       | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c      | 8 ++++----
 drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c       | 8 ++++----
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/hw.c       | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c       | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c       | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c      | 6 +++---
 9 files changed, 20 insertions(+), 20 deletions(-)

--
2.26.0.106.g9fadedd

