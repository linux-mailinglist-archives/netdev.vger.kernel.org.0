Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E5D1AEA2D
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 08:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725869AbgDRGgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 02:36:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2403 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725782AbgDRGga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Apr 2020 02:36:30 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A37E3AAD4B0559094263;
        Sat, 18 Apr 2020 14:36:23 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Sat, 18 Apr 2020
 14:36:17 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <amade@asmblr.net>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>
Subject: [PATCH 0/5] rtlwifi: use true,false for bool variables
Date:   Sat, 18 Apr 2020 15:02:31 +0800
Message-ID: <20200418070236.9620-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix some coccicheck warnings.

Jason Yan (5):
  rtlwifi: rtl8188ee: use true,false for bool variables
  rtlwifi: rtl8723ae: use true,false for bool variables
  rtlwifi: rtl8192ee: use true,false for bool variables
  rtlwifi: rtl8723be: use true,false for bool variables
  rtlwifi: rtl8821ae: use true,false for bool variables

 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/sw.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/sw.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/sw.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8723be/sw.c | 4 ++--
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 4 ++--
 5 files changed, 10 insertions(+), 10 deletions(-)

-- 
2.21.1

