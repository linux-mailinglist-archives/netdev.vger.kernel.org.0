Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E554CBCD7
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 12:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbiCCLhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 06:37:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiCCLg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 06:36:56 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4E21179B4;
        Thu,  3 Mar 2022 03:35:36 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V67YFpk_1646307327;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V67YFpk_1646307327)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 03 Mar 2022 19:35:27 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next] net/smc: fix document build WARNING from smc-sysctl.rst
Date:   Thu,  3 Mar 2022 19:35:27 +0800
Message-Id: <20220303113527.62047-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen reported the following warning messages from smc-sysctl.rst

Documentation/networking/smc-sysctl.rst:3: WARNING: Title overline
too short.
Documentation/networking/smc-sysctl.rst: WARNING: document isn't
included in any toctree

Fix the title overline and add smc-sysctl entry into
Documentation/networking/index.rst

Fixes: 12bbb0d163a9 ("net/smc: add sysctl for autocorking")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
---
 Documentation/networking/index.rst      | 1 +
 Documentation/networking/smc-sysctl.rst | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 58bc8cd367c6..ce017136ab05 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -96,6 +96,7 @@ Contents:
    sctp
    secid
    seg6-sysctl
+   smc-sysctl
    statistics
    strparser
    switchdev
diff --git a/Documentation/networking/smc-sysctl.rst b/Documentation/networking/smc-sysctl.rst
index c53f8c61c9e4..0987fd1bc220 100644
--- a/Documentation/networking/smc-sysctl.rst
+++ b/Documentation/networking/smc-sysctl.rst
@@ -1,11 +1,11 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-=========
+==========
 SMC Sysctl
-=========
+==========
 
 /proc/sys/net/smc/* Variables
-==============================
+=============================
 
 autocorking_size - INTEGER
 	Setting SMC auto corking size:
-- 
2.19.1.3.ge56e4f7

