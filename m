Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47FA81657F7
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 07:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgBTGtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 01:49:19 -0500
Received: from mx56.baidu.com ([61.135.168.56]:54557 "EHLO
        tc-sys-mailedm02.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725962AbgBTGtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 01:49:19 -0500
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm02.tc.baidu.com (Postfix) with ESMTP id 3418B11C0034
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 14:49:02 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org
Subject: [PATCH][net-next] net: neigh: remove unused NEIGH_SYSCTL_MS_JIFFIES_ENTRY
Date:   Thu, 20 Feb 2020 14:49:02 +0800
Message-Id: <1582181342-6498-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this macro is never used, so remove it

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 net/core/neighbour.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 789a73aa7bd8..5bf8d22a47ec 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -3553,9 +3553,6 @@ static int neigh_proc_base_reachable_time(struct ctl_table *ctl, int write,
 #define NEIGH_SYSCTL_USERHZ_JIFFIES_ENTRY(attr, name) \
 	NEIGH_SYSCTL_ENTRY(attr, attr, name, 0644, neigh_proc_dointvec_userhz_jiffies)
 
-#define NEIGH_SYSCTL_MS_JIFFIES_ENTRY(attr, name) \
-	NEIGH_SYSCTL_ENTRY(attr, attr, name, 0644, neigh_proc_dointvec_ms_jiffies)
-
 #define NEIGH_SYSCTL_MS_JIFFIES_REUSED_ENTRY(attr, data_attr, name) \
 	NEIGH_SYSCTL_ENTRY(attr, data_attr, name, 0644, neigh_proc_dointvec_ms_jiffies)
 
-- 
2.16.2

