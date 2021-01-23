Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 848373013E8
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 09:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbhAWI1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 03:27:38 -0500
Received: from m12-11.163.com ([220.181.12.11]:34286 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725940AbhAWI1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 03:27:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=xCn6p9NJsojGDEOK0g
        fOq+HkZhp0fhqQy2JmR2QKavs=; b=OCnBLxei5NPW0LcSnM4fFbcyAngSJ1/Ga1
        Lj7CTjYKuhSqJnzvmmKNnsjcLIqdInnPxb3XudKQ+he7mfDokrpQFk/jaJ5qzUq/
        sq34n7ToUFRuK5rd9vj1aQlelvZeLgkfXDfjwW4ODskMspGZGYO7wCSB5YvryjZY
        ZyoPnJQQI=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp7 (Coremail) with SMTP id C8CowAAXFZ2E3Qtgrj7KKA--.11235S2;
        Sat, 23 Jan 2021 16:25:41 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     mgreer@animalcreek.com, linux-nfc@lists.01.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nfc: fix typo
Date:   Sat, 23 Jan 2021 16:25:50 +0800
Message-Id: <20210123082550.3748-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: C8CowAAXFZ2E3Qtgrj7KKA--.11235S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrW7Cw4DArW7tr1UXrWxCrg_yoWxKwbE9r
        1kXrW7Xr97ur1jkr1UC3Z0vFyFy3W5WF9a9Fsa9FWSkryFyF47uw18uF1fXw15JrW5JFnr
        uwnFg34Syw13WjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYylk3UUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiRQUjsVl906sOlAAAsU
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

change 'regster' to 'register'

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/trf7970a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index c70f62fe..3397802 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -169,7 +169,7 @@
 
 /* Bits determining whether its a direct command or register R/W,
  * whether to use a continuous SPI transaction or not, and the actual
- * direct cmd opcode or regster address.
+ * direct cmd opcode or register address.
  */
 #define TRF7970A_CMD_BIT_CTRL			BIT(7)
 #define TRF7970A_CMD_BIT_RW			BIT(6)
-- 
1.9.1

