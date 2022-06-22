Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9F55549D4
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbiFVMQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 08:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbiFVMQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 08:16:09 -0400
X-Greylist: delayed 183 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 22 Jun 2022 05:16:05 PDT
Received: from cmccmta2.chinamobile.com (cmccmta2.chinamobile.com [221.176.66.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4C6C340C5;
        Wed, 22 Jun 2022 05:16:05 -0700 (PDT)
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from spf.mail.chinamobile.com (unknown[172.16.121.11])
        by rmmx-syy-dmz-app06-12006 (RichMail) with SMTP id 2ee662b3074ae76-a6237;
        Wed, 22 Jun 2022 20:12:58 +0800 (CST)
X-RM-TRANSID: 2ee662b3074ae76-a6237
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.108.79.98])
        by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee662b30737662-b18ab;
        Wed, 22 Jun 2022 20:12:58 +0800 (CST)
X-RM-TRANSID: 2ee662b30737662-b18ab
From:   liujing <liujing@cmss.chinamobile.com>
To:     jhs@mojatatu.com
Cc:     xiyou.wangcong@gmail.com, jiri@resnulli.us, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        liujing <liujing@cmss.chinamobile.com>
Subject: [PATCH] tc-testing: gitignore, delete plugins directory
Date:   Wed, 22 Jun 2022 08:12:37 -0400
Message-Id: <20220622121237.5832-1-liujing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.18.2
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

when we modfying kernel, commit it to our environment building. we find a error
that is "tools/testing/selftests/tc-testing/plugins" failed: No such file or directory"

we find plugins directory is ignored in
"tools/testing/selftests/tc-testing/.gitignore", but the plugins directory
is need in "tools/testing/selftests/tc-testing/Makefile"

Signed-off-by: liujing <liujing@cmss.chinamobile.com>
---
 tools/testing/selftests/tc-testing/.gitignore | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/tc-testing/.gitignore b/tools/testing/selftests/tc-testing/.gitignore
index d52f65de23b4..9fe1cef72728 100644
--- a/tools/testing/selftests/tc-testing/.gitignore
+++ b/tools/testing/selftests/tc-testing/.gitignore
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 __pycache__/
 *.pyc
-plugins/
 *.xml
 *.tap
 tdc_config_local.py
-- 
2.18.2



