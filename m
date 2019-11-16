Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 346C2FEB21
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 08:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726679AbfKPHeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 02:34:12 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:6685 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726034AbfKPHeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 02:34:11 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A112E191C2DAC77CA412;
        Sat, 16 Nov 2019 15:34:06 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sat, 16 Nov 2019
 15:34:00 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <stas.yakovlev@gmail.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
Subject: [PATCH -next 1/2] ipw2x00: remove set but not used variable 'reason'
Date:   Sat, 16 Nov 2019 15:41:22 +0800
Message-ID: <1573890083-33761-2-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573890083-33761-1-git-send-email-zhengbin13@huawei.com>
References: <1573890083-33761-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/intel/ipw2x00/ipw2200.c: In function ipw_wx_set_mlme:
drivers/net/wireless/intel/ipw2x00/ipw2200.c:6805:9: warning: variable reason set but not used [-Wunused-but-set-variable]

It is introduced by commit 367a1092b555 ("ipw2x00:
move under intel vendor directory"), but never used, so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index ed0f065..31e43fc 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -6788,9 +6788,6 @@ static int ipw_wx_set_mlme(struct net_device *dev,
 {
 	struct ipw_priv *priv = libipw_priv(dev);
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
-	__le16 reason;
-
-	reason = cpu_to_le16(mlme->reason_code);

 	switch (mlme->cmd) {
 	case IW_MLME_DEAUTH:
--
2.7.4

