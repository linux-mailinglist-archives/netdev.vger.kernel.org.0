Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AACC52FCB59
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 08:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbhATHOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 02:14:04 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:56736 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726423AbhATHN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 02:13:58 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UMJ.w4A_1611126765;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UMJ.w4A_1611126765)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 20 Jan 2021 15:12:50 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     marcel@holtmann.org
Cc:     johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] net/bluetooth:  Fix the follow coccicheck warnings
Date:   Wed, 20 Jan 2021 15:12:44 +0800
Message-Id: <1611126764-34416-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

./net/bluetooth/hci_debugfs.c: WARNING: sniff_min_interval_fops
should be defined with DEFINE_DEBUGFS_ATTRIBUTE

Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci Robot<abaci@linux.alibaba.com>
---
 net/bluetooth/hci_debugfs.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index 4626e02..65cad9f 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -237,7 +237,7 @@ static int conn_info_min_age_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(conn_info_min_age_fops, conn_info_min_age_get,
+DEFINE_DEBUGFS_ATTRIBUTE(conn_info_min_age_fops, conn_info_min_age_get,
 			conn_info_min_age_set, "%llu\n");
 
 static int conn_info_max_age_set(void *data, u64 val)
@@ -265,7 +265,7 @@ static int conn_info_max_age_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(conn_info_max_age_fops, conn_info_max_age_get,
+DEFINE_DEBUGFS_ATTRIBUTE(conn_info_max_age_fops, conn_info_max_age_get,
 			conn_info_max_age_set, "%llu\n");
 
 static ssize_t use_debug_keys_read(struct file *file, char __user *user_buf,
@@ -419,7 +419,7 @@ static int voice_setting_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(voice_setting_fops, voice_setting_get,
+DEFINE_DEBUGFS_ATTRIBUTE(voice_setting_fops, voice_setting_get,
 			NULL, "0x%4.4llx\n");
 
 static ssize_t ssp_debug_mode_read(struct file *file, char __user *user_buf,
@@ -476,7 +476,7 @@ static int min_encrypt_key_size_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(min_encrypt_key_size_fops,
+DEFINE_DEBUGFS_ATTRIBUTE(min_encrypt_key_size_fops,
 			min_encrypt_key_size_get,
 			min_encrypt_key_size_set, "%llu\n");
 
@@ -491,7 +491,7 @@ static int auto_accept_delay_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(auto_accept_delay_fops, auto_accept_delay_get,
+DEFINE_DEBUGFS_ATTRIBUTE(auto_accept_delay_fops, auto_accept_delay_get,
 			auto_accept_delay_set, "%llu\n");
 
 static ssize_t force_bredr_smp_read(struct file *file,
@@ -558,7 +558,7 @@ static int idle_timeout_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(idle_timeout_fops, idle_timeout_get,
+DEFINE_DEBUGFS_ATTRIBUTE(idle_timeout_fops, idle_timeout_get,
 			idle_timeout_set, "%llu\n");
 
 static int sniff_min_interval_set(void *data, u64 val)
@@ -586,7 +586,7 @@ static int sniff_min_interval_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(sniff_min_interval_fops, sniff_min_interval_get,
+DEFINE_DEBUGFS_ATTRIBUTE(sniff_min_interval_fops, sniff_min_interval_get,
 			sniff_min_interval_set, "%llu\n");
 
 static int sniff_max_interval_set(void *data, u64 val)
@@ -614,7 +614,7 @@ static int sniff_max_interval_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(sniff_max_interval_fops, sniff_max_interval_get,
+DEFINE_DEBUGFS_ATTRIBUTE(sniff_max_interval_fops, sniff_max_interval_get,
 			sniff_max_interval_set, "%llu\n");
 
 void hci_debugfs_create_bredr(struct hci_dev *hdev)
@@ -706,7 +706,7 @@ static int rpa_timeout_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(rpa_timeout_fops, rpa_timeout_get,
+DEFINE_DEBUGFS_ATTRIBUTE(rpa_timeout_fops, rpa_timeout_get,
 			rpa_timeout_set, "%llu\n");
 
 static int random_address_show(struct seq_file *f, void *p)
@@ -869,7 +869,7 @@ static int conn_min_interval_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(conn_min_interval_fops, conn_min_interval_get,
+DEFINE_DEBUGFS_ATTRIBUTE(conn_min_interval_fops, conn_min_interval_get,
 			conn_min_interval_set, "%llu\n");
 
 static int conn_max_interval_set(void *data, u64 val)
@@ -897,7 +897,7 @@ static int conn_max_interval_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(conn_max_interval_fops, conn_max_interval_get,
+DEFINE_DEBUGFS_ATTRIBUTE(conn_max_interval_fops, conn_max_interval_get,
 			conn_max_interval_set, "%llu\n");
 
 static int conn_latency_set(void *data, u64 val)
@@ -925,7 +925,7 @@ static int conn_latency_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(conn_latency_fops, conn_latency_get,
+DEFINE_DEBUGFS_ATTRIBUTE(conn_latency_fops, conn_latency_get,
 			conn_latency_set, "%llu\n");
 
 static int supervision_timeout_set(void *data, u64 val)
@@ -953,7 +953,7 @@ static int supervision_timeout_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(supervision_timeout_fops, supervision_timeout_get,
+DEFINE_DEBUGFS_ATTRIBUTE(supervision_timeout_fops, supervision_timeout_get,
 			supervision_timeout_set, "%llu\n");
 
 static int adv_channel_map_set(void *data, u64 val)
@@ -981,7 +981,7 @@ static int adv_channel_map_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(adv_channel_map_fops, adv_channel_map_get,
+DEFINE_DEBUGFS_ATTRIBUTE(adv_channel_map_fops, adv_channel_map_get,
 			adv_channel_map_set, "%llu\n");
 
 static int adv_min_interval_set(void *data, u64 val)
@@ -1009,7 +1009,7 @@ static int adv_min_interval_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(adv_min_interval_fops, adv_min_interval_get,
+DEFINE_DEBUGFS_ATTRIBUTE(adv_min_interval_fops, adv_min_interval_get,
 			adv_min_interval_set, "%llu\n");
 
 static int adv_max_interval_set(void *data, u64 val)
@@ -1037,7 +1037,7 @@ static int adv_max_interval_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(adv_max_interval_fops, adv_max_interval_get,
+DEFINE_DEBUGFS_ATTRIBUTE(adv_max_interval_fops, adv_max_interval_get,
 			adv_max_interval_set, "%llu\n");
 
 static int min_key_size_set(void *data, u64 val)
@@ -1065,7 +1065,7 @@ static int min_key_size_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(min_key_size_fops, min_key_size_get,
+DEFINE_DEBUGFS_ATTRIBUTE(min_key_size_fops, min_key_size_get,
 			min_key_size_set, "%llu\n");
 
 static int max_key_size_set(void *data, u64 val)
@@ -1093,7 +1093,7 @@ static int max_key_size_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(max_key_size_fops, max_key_size_get,
+DEFINE_DEBUGFS_ATTRIBUTE(max_key_size_fops, max_key_size_get,
 			max_key_size_set, "%llu\n");
 
 static int auth_payload_timeout_set(void *data, u64 val)
@@ -1121,7 +1121,7 @@ static int auth_payload_timeout_get(void *data, u64 *val)
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(auth_payload_timeout_fops,
+DEFINE_DEBUGFS_ATTRIBUTE(auth_payload_timeout_fops,
 			auth_payload_timeout_get,
 			auth_payload_timeout_set, "%llu\n");
 
-- 
1.8.3.1

