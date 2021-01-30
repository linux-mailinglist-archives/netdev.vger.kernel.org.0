Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34612309538
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 14:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbhA3ND1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 08:03:27 -0500
Received: from m12-11.163.com ([220.181.12.11]:39610 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhA3NDZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 08:03:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=brTi98KYrf7biHo0Yw
        HGNh8Yu8nQX0FxJDmIDrvdGxA=; b=fCRf3YEfQosarwTRLGiP4P9OnEuija+7nX
        Y/GcOP11eB6++Esc+zmmn4XzaL2XDRreLCPvb4JfxF46vDLg8TSzQVt+yRCWFNbO
        YNTv7lBLKRO3hTFCMGos2+dbgHooFoZmYqT/PATlXSs5JdIhwJc0Ddk7FMH9WDHq
        m0Tbu6XR4=
Received: from wengjianfeng.ccdomain.com (unknown [119.137.55.243])
        by smtp7 (Coremail) with SMTP id C8CowACHsqxTCRVgZyo8LQ--.30869S2;
        Sat, 30 Jan 2021 15:23:00 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH v2] rtl8xxxu: remove unused assignment value
Date:   Sat, 30 Jan 2021 15:23:10 +0800
Message-Id: <20210130072310.17252-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: C8CowACHsqxTCRVgZyo8LQ--.30869S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrWrtw4DXF4rGr4fJrWxCrg_yoWfuwb_uw
        1Iv3ZrZry8Jr1Fyr43KrsrArWFyFWDJ3Z5Cay29FW3Ww43JayFvwnYv343Gr4fWw4ruryU
        WwnrGa48trW8XjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5ku4UUUUUU==
X-Originating-IP: [119.137.55.243]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiHRQqsVSIpMzD7AAAsJ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

at first, ret was assigned to zero, but later assigned to
a funciton,so the assignment to zero is no use, which can
simple be removed instead.

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index 9f1f93d..cfe2dfd 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1507,8 +1507,6 @@ static int rtl8192eu_power_on(struct rtl8xxxu_priv *priv)
 	u32 val32;
 	int ret;
 
-	ret = 0;
-
 	val32 = rtl8xxxu_read32(priv, REG_SYS_CFG);
 	if (val32 & SYS_CFG_SPS_LDO_SEL) {
 		rtl8xxxu_write8(priv, REG_LDO_SW_CTRL, 0xc3);
-- 
1.9.1

