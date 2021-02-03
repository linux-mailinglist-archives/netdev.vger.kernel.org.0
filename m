Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A2330D678
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 10:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhBCJjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 04:39:48 -0500
Received: from m12-12.163.com ([220.181.12.12]:34717 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231355AbhBCJjq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 04:39:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=g8PWqoI20i8BSk2IAz
        VGLC769qLzNVxCHDwI8LL+ATk=; b=ahRXfSbkODICFxecWmv72xBVf9b4pQtQIK
        HB9XHSj76grbe5wbbDklOmqX0UgkjPbf/JxjoU6FHQGoochujxxMuqYXqqlDdume
        PyAcferc/iCdfN37swp/eZCs82ZtqaPqrNNBFIrj//DUBDW9Noo1lxUOiCXb45+5
        j5WSyxav4=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp8 (Coremail) with SMTP id DMCowADn74cXbxpgDlgPPA--.114S2;
        Wed, 03 Feb 2021 17:38:32 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] nfc: pn533: Fix typo issue
Date:   Wed,  3 Feb 2021 17:38:42 +0800
Message-Id: <20210203093842.11180-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: DMCowADn74cXbxpgDlgPPA--.114S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr18Wry5Wr17Gr1rWFyUJrb_yoW8JFykpF
        ZF9ryayr18C3yqya1DGF4UZ345WFsrArySgFs0q347XF45JFykJFs5Kayq9r1xXrWktF1a
        va9IgFs8Wa45JFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bO0PhUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/1tbiHRgusVSIpQXFOAAAsb
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

change 'piority' to 'priority'
change 'succesfult' to 'successful'

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/nfc/pn533/pn533.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index f7464bd..f1469ac 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -513,7 +513,7 @@ static int pn533_send_cmd_async(struct pn533 *dev, u8 cmd_code,
 /*
  * pn533_send_cmd_direct_async
  *
- * The function sends a piority cmd directly to the chip omitting the cmd
+ * The function sends a priority cmd directly to the chip omitting the cmd
  * queue. It's intended to be used by chaining mechanism of received responses
  * where the host has to request every single chunk of data before scheduling
  * next cmd from the queue.
@@ -615,7 +615,7 @@ static int pn533_send_sync_complete(struct pn533 *dev, void *_arg,
  *     as it's been already freed at the beginning of RX path by
  *     async_complete_cb.
  *
- *  3. valid pointer in case of succesfult RX path
+ *  3. valid pointer in case of successful RX path
  *
  *  A caller has to check a return value with IS_ERR macro. If the test pass,
  *  the returned pointer is valid.
-- 
1.9.1


