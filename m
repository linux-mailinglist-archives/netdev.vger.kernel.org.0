Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC65512A1F9
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 15:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726879AbfLXOJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 09:09:00 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:46942 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726201AbfLXOI7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 09:08:59 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 761BB5CDB7E83DF093F0;
        Tue, 24 Dec 2019 22:08:55 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Tue, 24 Dec 2019
 22:08:45 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <yhchuang@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next 0/6] net/wireless: use true,false for bool variable
Date:   Tue, 24 Dec 2019 22:16:00 +0800
Message-ID: <1577196966-84926-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zhengbin (6):
  rtw88: use true,false for bool variable
  cw1200: use true,false for bool variable
  ath9k: use true,false for bool variable
  ath10k: use true,false for bool variable
  wil6210: use true,false for bool variable
  brcmfmac: use true,false for bool variable

 drivers/net/wireless/ath/ath10k/htt_rx.c                    | 2 +-
 drivers/net/wireless/ath/ath9k/ar9003_aic.c                 | 2 +-
 drivers/net/wireless/ath/wil6210/main.c                     | 2 +-
 drivers/net/wireless/ath/wil6210/txrx.c                     | 2 +-
 drivers/net/wireless/ath/wil6210/wmi.c                      | 8 ++++----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 2 +-
 drivers/net/wireless/realtek/rtw88/phy.c                    | 2 +-
 drivers/net/wireless/st/cw1200/txrx.c                       | 2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

--
2.7.4

