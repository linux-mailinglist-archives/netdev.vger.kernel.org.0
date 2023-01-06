Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E1565F98F
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 03:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjAFC1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 21:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjAFC1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 21:27:52 -0500
Received: from out30-7.freemail.mail.aliyun.com (out30-7.freemail.mail.aliyun.com [115.124.30.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152E063F40;
        Thu,  5 Jan 2023 18:27:50 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VYxlMJx_1672972055;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VYxlMJx_1672972055)
          by smtp.aliyun-inc.com;
          Fri, 06 Jan 2023 10:27:48 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     stf_xl@wp.pl
Cc:     helmut.schaa@googlemail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH v2] wifi: rt2x00: Remove useless else if
Date:   Fri,  6 Jan 2023 10:27:31 +0800
Message-Id: <20230106022731.111243-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The assignment of the else and else if branches is the same, so the else
if here is redundant, so we remove it.

./drivers/net/wireless/ralink/rt2x00/rt2800lib.c:8927:9-11: WARNING:
possible condition with no effect (if == else).

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3631
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  -Remove useful comment and modify commit message.

 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 12b700c7b9c3..1226a883cd67 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -8924,8 +8924,6 @@ static void rt2800_rxiq_calibration(struct rt2x00_dev *rt2x00dev)
 
 				if (i < 2 && (bbptemp & 0x800000))
 					result = (bbptemp & 0xffffff) - 0x1000000;
-				else if (i == 4)
-					result = bbptemp;
 				else
 					result = bbptemp;
 
-- 
2.20.1.7.g153144c

