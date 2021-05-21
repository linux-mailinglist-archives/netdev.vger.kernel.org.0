Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E76238C3B7
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 11:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbhEUJrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 05:47:04 -0400
Received: from m12-18.163.com ([220.181.12.18]:40003 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229973AbhEUJrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 05:47:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=jKcZD
        Gi/PliNSSwNY6eBUv9vESsaE54FhbOYWqI8pbs=; b=Ng73Y3pkEFjzrEPbLXGSm
        +57o5I976cBKqAfFivkuxwzYGK2nlO54cM2bexAexeqNJ48uWc9ZsS6xfKROcmSU
        xhVznMEFnIdbxMVYWarsgJx5ZTq7ZqNnBAdTV0aY1rRE1vlQMj88t2j26R+GLgwP
        9Nz77PKSMf4MtZFG6XnunA=
Received: from COOL-20201210PM.ccdomain.com (unknown [218.94.48.178])
        by smtp14 (Coremail) with SMTP id EsCowAAnLwMpgadgmJ7ekg--.21621S2;
        Fri, 21 May 2021 17:45:17 +0800 (CST)
From:   zuoqilin1@163.com
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zuoqilin <zuoqilin@yulong.com>
Subject: [PATCH] atm: Fix typo
Date:   Fri, 21 May 2021 17:45:22 +0800
Message-Id: <20210521094522.1862-1-zuoqilin1@163.com>
X-Mailer: git-send-email 2.28.0.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowAAnLwMpgadgmJ7ekg--.21621S2
X-Coremail-Antispam: 1Uf129KBjvdXoWruFyUuw4kKw4fGF48uw4xXrb_yoWxArg_CF
        4xZ3s3WFZ5Cryktwn7Ar9avaySyF4rZrn7ZF1Yg3ZI9Fs0vrW3WryDu3yxAw1jgr4rCF17
        Zw1jgryrZw17KjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1OtxPUUUUU==
X-Originating-IP: [218.94.48.178]
X-CM-SenderInfo: 52xr1xpolqiqqrwthudrp/1tbiZQSZiV8ZOoXrewACsa
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zuoqilin <zuoqilin@yulong.com>

Change 'contol' to 'control'.

Signed-off-by: zuoqilin <zuoqilin@yulong.com>
---
 drivers/atm/zeprom.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/zeprom.h b/drivers/atm/zeprom.h
index 88e01f8..8e8819a 100644
--- a/drivers/atm/zeprom.h
+++ b/drivers/atm/zeprom.h
@@ -12,7 +12,7 @@
 #define ZEPROM_V1_REG	PCI_VENDOR_ID	/* PCI register */
 #define ZEPROM_V2_REG	0x40
 
-/* Bits in contol register */
+/* Bits in control register */
 
 #define ZEPROM_SK	0x80000000	/* strobe (probably on raising edge) */
 #define ZEPROM_CS	0x40000000	/* Chip Select */
-- 
1.9.1


