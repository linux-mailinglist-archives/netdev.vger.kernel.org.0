Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010B654F440
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 11:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380907AbiFQJ2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 05:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235798AbiFQJ21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 05:28:27 -0400
Received: from esa8.hc1455-7.c3s2.iphmx.com (esa8.hc1455-7.c3s2.iphmx.com [139.138.61.253])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97D95AA58
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 02:28:25 -0700 (PDT)
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="64839518"
X-IronPort-AV: E=Sophos;i="5.92,306,1650898800"; 
   d="scan'208";a="64839518"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa8.hc1455-7.c3s2.iphmx.com with ESMTP; 17 Jun 2022 18:28:23 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
        by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id AC148D6252
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 18:28:22 +0900 (JST)
Received: from m3002.s.css.fujitsu.com (msm3.b.css.fujitsu.com [10.128.233.104])
        by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 051DDCFAB8
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 18:28:17 +0900 (JST)
Received: from spinoza.localdomain (unknown [10.124.196.240])
        by m3002.s.css.fujitsu.com (Postfix) with ESMTP id DD1AD2020B24;
        Fri, 17 Jun 2022 18:28:16 +0900 (JST)
From:   Yuki Inoguchi <inoguchi.yuki@fujitsu.com>
To:     netdev@vger.kernel.org
Cc:     Yuki Inoguchi <inoguchi.yuki@fujitsu.com>
Subject: [PATCH iproute2] man: tc-fq_codel: Fix a typo.
Date:   Fri, 17 Jun 2022 18:28:12 +0900
Message-Id: <1655458092-26996-1-git-send-email-inoguchi.yuki@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In tc-fq_codel man page, "length .B interval" should be "length interval."

Signed-off-by: Yuki Inoguchi <inoguchi.yuki@fujitsu.com>
---
 man/man8/tc-fq_codel.8 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/man/man8/tc-fq_codel.8 b/man/man8/tc-fq_codel.8
index 84340fe..43f6508 100644
--- a/man/man8/tc-fq_codel.8
+++ b/man/man8/tc-fq_codel.8
@@ -66,7 +66,8 @@ the local minimum queue delay that packets experience. Default value is 5ms.
 has the same semantics as
 .B codel
 and is used to ensure that the measured minimum delay does not become too stale.
-The minimum delay must be experienced in the last epoch of length .B interval.
+The minimum delay must be experienced in the last epoch of length 
+.BR interval .
 It should be set on the order of the worst-case RTT through the bottleneck to
 give endpoints sufficient time to react. Default value is 100ms.
 
-- 
1.8.3.1

