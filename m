Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A860308583
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 07:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbhA2GL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 01:11:28 -0500
Received: from m12-14.163.com ([220.181.12.14]:56035 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230121AbhA2GL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 01:11:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=DyTPjUOQqGfQiWxuxf
        Z3mJqKKyZRDIcPBWvisZNPE/U=; b=bAzgSzH8axssCHgTC1FTI67vQg98Yos88o
        pCb0QxcXroUH++P+z2OhnY+XLKTHppUbJpjc3ccIAEc+vqi2o7XkXpuIvwQSdq51
        Je8yzcysNZug90TTNZStFtQFp/ELazCfjD/XpEygBac/YynbIpgg6DOip25w/Wi1
        zzS/dos4U=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.52.46])
        by smtp10 (Coremail) with SMTP id DsCowAAnLhrJYhNgYLViiQ--.9590S2;
        Fri, 29 Jan 2021 09:20:11 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] rtl8xxxu: assign value when defining variables
Date:   Fri, 29 Jan 2021 09:20:19 +0800
Message-Id: <20210129012019.11348-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DsCowAAnLhrJYhNgYLViiQ--.9590S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrWruw48ZFyfZrWkXF4fZrb_yoWfGrb_ua
        40qan7Zry8Jr4Fyr4Yyr47ZrWFyFZ8J3Z5Ca42grW5Ww45JrWFkwn5X343Jr4fXw4rZF98
        G3Z7G3W0y34kXjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5aAp5UUUUU==
X-Originating-IP: [119.137.52.46]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiRQspsVl91ALJWgAAs3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

define ret and then assign value to it, which we should do one time.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index 9f1f93d..b2ee168 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1505,9 +1505,7 @@ static int rtl8192eu_power_on(struct rtl8xxxu_priv *priv)
 {
 	u16 val16;
 	u32 val32;
-	int ret;
-
-	ret = 0;
+	int ret = 0;
 
 	val32 = rtl8xxxu_read32(priv, REG_SYS_CFG);
 	if (val32 & SYS_CFG_SPS_LDO_SEL) {
-- 
1.9.1


