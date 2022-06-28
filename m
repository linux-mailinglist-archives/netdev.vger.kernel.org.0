Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E382855E0E8
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344825AbiF1KNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbiF1KNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:13:10 -0400
Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8B3C3F
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 03:13:05 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="78715690"
X-IronPort-AV: E=Sophos;i="5.92,227,1650898800"; 
   d="scan'208";a="78715690"
Received: from unknown (HELO yto-r1.gw.nic.fujitsu.com) ([218.44.52.217])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP; 28 Jun 2022 19:13:03 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
        by yto-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 575C2DAFD0
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 19:13:02 +0900 (JST)
Received: from m3003.s.css.fujitsu.com (m3003.s.css.fujitsu.com [10.128.233.114])
        by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id A9711E6625
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 19:13:01 +0900 (JST)
Received: from spinoza.localdomain (unknown [10.124.196.240])
        by m3003.s.css.fujitsu.com (Postfix) with ESMTP id 7F2A1203EF1A;
        Tue, 28 Jun 2022 19:13:01 +0900 (JST)
From:   Yuki Inoguchi <inoguchi.yuki@fujitsu.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, edumazet@google.com,
        Yuki Inoguchi <inoguchi.yuki@fujitsu.com>
Subject: [PATCH iproute2] man: tc-fq_codel: add drop_batch
Date:   Tue, 28 Jun 2022 19:12:51 +0900
Message-Id: <1656411171-6314-1-git-send-email-inoguchi.yuki@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's describe the drop_batch parameter added to tc command
by Commit 7868f802e2d9 ("tc: fq_codel: add drop_batch parameter")

Signed-off-by: Yuki Inoguchi <inoguchi.yuki@fujitsu.com>
---
 man/man8/tc-fq_codel.8 | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/man/man8/tc-fq_codel.8 b/man/man8/tc-fq_codel.8
index 43f6508..7859063 100644
--- a/man/man8/tc-fq_codel.8
+++ b/man/man8/tc-fq_codel.8
@@ -101,6 +101,13 @@ result of this masking equals VALUE, will the
 .B ce_threshold
 logic be applied to the packet.
 
+.SS drop_batch
+sets the maximum number of packets to drop when
+.B limit
+or
+.B memory_limit
+is exceeded. Default value is 64.
+
 .SH EXAMPLES
 #tc qdisc add   dev eth0 root fq_codel
 .br
-- 
1.8.3.1

