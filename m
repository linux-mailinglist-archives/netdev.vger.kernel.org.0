Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97DDC1696B7
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 09:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgBWIGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 03:06:02 -0500
Received: from mx58.baidu.com ([61.135.168.58]:19324 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725980AbgBWIGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 03:06:01 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id 7DAE011C0034
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 16:05:43 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH][net-next] igmp: remove unused macro IGMP_Vx_UNSOLICITED_REPORT_INTERVAL
Date:   Sun, 23 Feb 2020 16:05:43 +0800
Message-Id: <1582445143-12129-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 2690048c01f3 ("net: igmp: Allow user-space
configuration of igmp unsolicited report interval"), they
are not used now

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/ipv4/igmp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 3b9c7a2725a9..47f0502b2101 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -107,8 +107,6 @@
 #ifdef CONFIG_IP_MULTICAST
 /* Parameter names and values are taken from igmp-v2-06 draft */
 
-#define IGMP_V2_UNSOLICITED_REPORT_INTERVAL	(10*HZ)
-#define IGMP_V3_UNSOLICITED_REPORT_INTERVAL	(1*HZ)
 #define IGMP_QUERY_INTERVAL			(125*HZ)
 #define IGMP_QUERY_RESPONSE_INTERVAL		(10*HZ)
 
-- 
2.16.2

