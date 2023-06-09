Return-Path: <netdev+bounces-9457-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A62137293BF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:53:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 604B2281892
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 08:53:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F84EBA33;
	Fri,  9 Jun 2023 08:53:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AA0BA32
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:53:00 +0000 (UTC)
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71236210D;
	Fri,  9 Jun 2023 01:52:58 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VkhQf38_1686300772;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VkhQf38_1686300772)
          by smtp.aliyun-inc.com;
          Fri, 09 Jun 2023 16:52:53 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: simon.horman@corigine.com
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH net-next 2/3] tools: ynl: Remove duplicated include in handshake-user.c
Date: Fri,  9 Jun 2023 16:52:48 +0800
Message-Id: <20230609085249.131071-2-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
In-Reply-To: <20230609085249.131071-1-yang.lee@linux.alibaba.com>
References: <20230609085249.131071-1-yang.lee@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

./tools/net/ynl/generated/handshake-user.c: stdlib.h is included more than once.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=5464
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 tools/net/ynl/generated/handshake-user.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/net/ynl/generated/handshake-user.c b/tools/net/ynl/generated/handshake-user.c
index fe99c4ef7373..7a1f0364b88f 100644
--- a/tools/net/ynl/generated/handshake-user.c
+++ b/tools/net/ynl/generated/handshake-user.c
@@ -8,7 +8,6 @@
 #include "ynl.h"
 #include <linux/handshake.h>
 
-#include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <libmnl/libmnl.h>
-- 
2.20.1.7.g153144c


