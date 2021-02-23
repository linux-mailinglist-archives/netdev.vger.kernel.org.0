Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265473226B7
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 08:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbhBWH7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 02:59:37 -0500
Received: from m12-11.163.com ([220.181.12.11]:43084 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229961AbhBWH7g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 02:59:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=Cqg2tfDAyG9gUkQICL
        2EEDUEWWRv38aK2GdMgtbwE7c=; b=guJnL843fWgen70r8LUxLWQrXwvEiMavaC
        CerXCrmnExhi7Qfeu983DxdG9Z3a17IDpAZ41w9z/R03SZ+nPY0nDh4b1D7r74KY
        cWelbotCIPccsuX2iCNQVJ161HSHckX98L3vjg/H4pxTaR7XSG7odR8NFxsCd5Vh
        q6RDCaV6o=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.54.165])
        by smtp7 (Coremail) with SMTP id C8CowAB3bJTDtDRglzn_Ow--.63394S2;
        Tue, 23 Feb 2021 15:54:44 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     tony0620emma@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        inux-kernel@vger.kernel.org, wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] rtw88: remove unnecessary variable
Date:   Tue, 23 Feb 2021 15:54:38 +0800
Message-Id: <20210223075438.13676-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: C8CowAB3bJTDtDRglzn_Ow--.63394S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrtrWxAFyDurW7CrWrtry7Jrb_yoW8Jr1Dpa
        yYg345Aay3Kr4UWa15Jan7AFy3Way7JrW2krZYy3y5Z3yxXa4fJFZ0gFyjvrn0gryUCF9I
        qrs0q3ZrGas8WFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jjD73UUUUU=
X-Originating-IP: [119.137.54.165]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiEQM2sV7+2yasZQADsC
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

The variable ret is defined at the beginning and initialized
to 0 until the function returns ret, and the variable ret is
not reassigned.Therefore, we do not need to define the variable
ret, just return 0 directly at the end of the function.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/realtek/rtw88/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index e6989c0..4c7e3e4 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1393,7 +1393,6 @@ static int rtw_chip_parameter_setup(struct rtw_dev *rtwdev)
 	struct rtw_chip_info *chip = rtwdev->chip;
 	struct rtw_hal *hal = &rtwdev->hal;
 	struct rtw_efuse *efuse = &rtwdev->efuse;
-	int ret = 0;
 
 	switch (rtw_hci_type(rtwdev)) {
 	case RTW_HCI_TYPE_PCIE:
@@ -1431,7 +1430,7 @@ static int rtw_chip_parameter_setup(struct rtw_dev *rtwdev)
 
 	hal->bfee_sts_cap = 3;
 
-	return ret;
+	return 0;
 }
 
 static int rtw_chip_efuse_enable(struct rtw_dev *rtwdev)
-- 
1.9.1

