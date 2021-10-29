Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98F0543F809
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbhJ2Hu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbhJ2Huv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 03:50:51 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8555C0613B9
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:21 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q2-20020a17090a2e0200b001a0fd4efd49so6894402pjd.1
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bYc6nc043lMezBMaRZAGThBgnQ65oB9d7DBftkj2/pM=;
        b=fvInT8kDnHI7pCWkyRShWYscmU8lnysNT2QFt8XQR1lnoyYbrJAUBPH/1d/TdX8dZn
         eNkAzq7uZmXWbRUgztDpgeSGhDsXmZRy8Z+M+CyCdzZjq92LxBkoiYHfQTcUjVDSSLat
         H0Lgw8sQ8c3X089MpzCvS9xi30mX5pkfpxrtg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bYc6nc043lMezBMaRZAGThBgnQ65oB9d7DBftkj2/pM=;
        b=0KO9G5lwXCruTwA7F5fBGZwSfqRmIwLeINUc9Jr/MryDJ7ESTdQMtdm+IcvwOlp28p
         f+NroOmpr/6bXQw8y7z7VqcTRYWK8o5wPb2mWGwSFMGtqkVJbmI/p6UJQlYF32d62Khs
         3/LIm1kwTrGYRxA2N3QGU3Z/y3jNoJlBn6x5CneYnagTJ8OaIwvUuGbx2nDYU7nuJQ66
         XlIwuBAWSzuZI1NXxqSJDYrZI4RLIaPpxQEVzslJJv5LCmtTYfCJEmK91Udx6gPkKQSH
         PHpFmOU3ZfbAFztPJGeQh1nOu+fvcBY4SI5u3MGmqZAl4x2eeeXDN36kqprs3MrUvjNa
         aT6w==
X-Gm-Message-State: AOAM530eggb5yaiqTEQMmUCJ0G1LfATl8EqliPLMLkrJdQTj0/Rl5Yn7
        VkmR3d+KCYM9ceHwWYZKCiV+GQ==
X-Google-Smtp-Source: ABdhPJwqoN0BKJqWcmYyV25z+SVoRdRgy5/YPPRLBRzSZCQE4TgYQSaEkIbCdoKfcGvR5zvRLuP7nw==
X-Received: by 2002:a17:902:c115:b0:141:690a:863b with SMTP id 21-20020a170902c11500b00141690a863bmr8376042pli.73.1635493700697;
        Fri, 29 Oct 2021 00:48:20 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s18sm5721186pfc.87.2021.10.29.00.48.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Oct 2021 00:48:20 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next v2 07/19] bnxt_en: remove fw_reset devlink health reporter
Date:   Fri, 29 Oct 2021 03:47:44 -0400
Message-Id: <1635493676-10767-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
References: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001a0ad105cf790db0"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000001a0ad105cf790db0

From: Edwin Peer <edwin.peer@broadcom.com>

Firmware resets initiated by the user are not errors and should not
be reported via devlink. Once only unsolicited resets remain, it is no
longer sensible to maintain a separate fw_reset reporter.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  33 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  12 +-
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.c | 118 ++++--------------
 .../net/ethernet/broadcom/bnxt/bnxt_devlink.h |   6 +-
 4 files changed, 53 insertions(+), 116 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 517ce16ff7eb..1251d78ffd46 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2122,7 +2122,7 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		set_bit(BNXT_RESET_TASK_SILENT_SP_EVENT, &bp->sp_event);
 		break;
 	case ASYNC_EVENT_CMPL_EVENT_ID_RESET_NOTIFY: {
-		char *fatal_str = "non-fatal";
+		char *type_str = "Solicited";
 
 		if (!bp->fw_health)
 			goto async_event_process_exit;
@@ -2137,12 +2137,16 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		if (EVENT_DATA1_RESET_NOTIFY_FW_ACTIVATION(data1)) {
 			set_bit(BNXT_STATE_FW_ACTIVATE_RESET, &bp->state);
 		} else if (EVENT_DATA1_RESET_NOTIFY_FATAL(data1)) {
-			fatal_str = "fatal";
+			type_str = "Fatal";
 			set_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
+		} else if (data2 && BNXT_FW_STATUS_HEALTHY !=
+			   EVENT_DATA2_RESET_NOTIFY_FW_STATUS_CODE(data2)) {
+			type_str = "Non-fatal";
+			set_bit(BNXT_STATE_FW_NON_FATAL_COND, &bp->state);
 		}
 		netif_warn(bp, hw, bp->dev,
-			   "Firmware %s reset event, data1: 0x%x, data2: 0x%x, min wait %u ms, max wait %u ms\n",
-			   fatal_str, data1, data2,
+			   "%s firmware reset event, data1: 0x%x, data2: 0x%x, min wait %u ms, max wait %u ms\n",
+			   type_str, data1, data2,
 			   bp->fw_reset_min_dsecs * 100,
 			   bp->fw_reset_max_dsecs * 100);
 		set_bit(BNXT_FW_RESET_NOTIFY_SP_EVENT, &bp->sp_event);
@@ -11737,13 +11741,17 @@ static void bnxt_sp_task(struct work_struct *work)
 	if (test_and_clear_bit(BNXT_RST_RING_SP_EVENT, &bp->sp_event))
 		bnxt_rx_ring_reset(bp);
 
-	if (test_and_clear_bit(BNXT_FW_RESET_NOTIFY_SP_EVENT, &bp->sp_event))
-		bnxt_devlink_health_report(bp, BNXT_FW_RESET_NOTIFY_SP_EVENT);
+	if (test_and_clear_bit(BNXT_FW_RESET_NOTIFY_SP_EVENT, &bp->sp_event)) {
+		if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state) ||
+		    test_bit(BNXT_STATE_FW_NON_FATAL_COND, &bp->state))
+			bnxt_devlink_health_fw_report(bp);
+		else
+			bnxt_fw_reset(bp);
+	}
 
 	if (test_and_clear_bit(BNXT_FW_EXCEPTION_SP_EVENT, &bp->sp_event)) {
 		if (!is_bnxt_fw_ok(bp))
-			bnxt_devlink_health_report(bp,
-						   BNXT_FW_EXCEPTION_SP_EVENT);
+			bnxt_devlink_health_fw_report(bp);
 	}
 
 	smp_mb__before_atomic();
@@ -12079,7 +12087,7 @@ static void bnxt_fw_reset_abort(struct bnxt *bp, int rc)
 	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 	if (bp->fw_reset_state != BNXT_FW_RESET_STATE_POLL_VF) {
 		bnxt_ulp_start(bp, rc);
-		bnxt_dl_health_status_update(bp, false);
+		bnxt_dl_health_fw_status_update(bp, false);
 	}
 	bp->fw_reset_state = 0;
 	dev_close(bp->dev);
@@ -12178,6 +12186,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 			}
 		}
 		clear_bit(BNXT_STATE_FW_FATAL_COND, &bp->state);
+		clear_bit(BNXT_STATE_FW_NON_FATAL_COND, &bp->state);
 		if (test_and_clear_bit(BNXT_STATE_FW_ACTIVATE_RESET, &bp->state) &&
 		    !test_bit(BNXT_STATE_FW_ACTIVATE, &bp->state))
 			bnxt_dl_remote_reload(bp);
@@ -12230,9 +12239,11 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 		bnxt_vf_reps_alloc(bp);
 		bnxt_vf_reps_open(bp);
 		bnxt_ptp_reapply_pps(bp);
-		bnxt_dl_health_recovery_done(bp);
-		bnxt_dl_health_status_update(bp, true);
 		clear_bit(BNXT_STATE_FW_ACTIVATE, &bp->state);
+		if (test_and_clear_bit(BNXT_STATE_RECOVER, &bp->state)) {
+			bnxt_dl_health_fw_recovery_done(bp);
+			bnxt_dl_health_fw_status_update(bp, true);
+		}
 		rtnl_unlock();
 		break;
 	}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 16d33d00973e..e640df62d296 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -494,6 +494,10 @@ struct rx_tpa_end_cmp_ext {
 	  ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_MASK) ==\
 	ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA1_REASON_CODE_FW_ACTIVATION)
 
+#define EVENT_DATA2_RESET_NOTIFY_FW_STATUS_CODE(data2)			\
+	((data2) &							\
+	ASYNC_EVENT_CMPL_RESET_NOTIFY_EVENT_DATA2_FW_STATUS_CODE_MASK)
+
 #define EVENT_DATA1_RECOVERY_MASTER_FUNC(data1)				\
 	!!((data1) &							\
 	   ASYNC_EVENT_CMPL_ERROR_RECOVERY_EVENT_DATA1_FLAGS_MASTER_FUNC)
@@ -1537,7 +1541,6 @@ struct bnxt_fw_health {
 	u32 last_fw_reset_cnt;
 	u8 enabled:1;
 	u8 primary:1;
-	u8 fatal:1;
 	u8 status_reliable:1;
 	u8 tmr_multiplier;
 	u8 tmr_counter;
@@ -1548,14 +1551,9 @@ struct bnxt_fw_health {
 	u32 echo_req_data1;
 	u32 echo_req_data2;
 	struct devlink_health_reporter	*fw_reporter;
-	struct devlink_health_reporter *fw_reset_reporter;
 	struct devlink_health_reporter *fw_fatal_reporter;
 };
 
-struct bnxt_fw_reporter_ctx {
-	unsigned long sp_event;
-};
-
 #define BNXT_FW_HEALTH_REG_TYPE_MASK	3
 #define BNXT_FW_HEALTH_REG_TYPE_CFG	0
 #define BNXT_FW_HEALTH_REG_TYPE_GRC	1
@@ -1894,6 +1892,8 @@ struct bnxt {
 #define BNXT_STATE_PCI_CHANNEL_IO_FROZEN	8
 #define BNXT_STATE_NAPI_DISABLED	9
 #define BNXT_STATE_FW_ACTIVATE		11
+#define BNXT_STATE_RECOVER		12
+#define BNXT_STATE_FW_NON_FATAL_COND	13
 #define BNXT_STATE_FW_ACTIVATE_RESET	14
 
 #define BNXT_NO_FW_ACCESS(bp)					\
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index 8673f3c4b581..2c72f3b3708f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -19,6 +19,15 @@
 #include "bnxt_ulp.h"
 #include "bnxt_ptp.h"
 
+static void __bnxt_fw_recover(struct bnxt *bp)
+{
+	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state) ||
+	    test_bit(BNXT_STATE_FW_NON_FATAL_COND, &bp->state))
+		bnxt_fw_reset(bp);
+	else
+		bnxt_fw_exception(bp);
+}
+
 static int
 bnxt_dl_flash_update(struct devlink *dl,
 		     struct devlink_flash_update_params *params,
@@ -106,42 +115,14 @@ static const struct devlink_health_reporter_ops bnxt_dl_fw_reporter_ops = {
 	.diagnose = bnxt_fw_reporter_diagnose,
 };
 
-static int bnxt_fw_reset_recover(struct devlink_health_reporter *reporter,
-				 void *priv_ctx,
-				 struct netlink_ext_ack *extack)
-{
-	struct bnxt *bp = devlink_health_reporter_priv(reporter);
-
-	if (!priv_ctx)
-		return -EOPNOTSUPP;
-
-	bnxt_fw_reset(bp);
-	return -EINPROGRESS;
-}
-
-static const
-struct devlink_health_reporter_ops bnxt_dl_fw_reset_reporter_ops = {
-	.name = "fw_reset",
-	.recover = bnxt_fw_reset_recover,
-};
-
 static int bnxt_fw_fatal_recover(struct devlink_health_reporter *reporter,
 				 void *priv_ctx,
 				 struct netlink_ext_ack *extack)
 {
 	struct bnxt *bp = devlink_health_reporter_priv(reporter);
-	struct bnxt_fw_reporter_ctx *fw_reporter_ctx = priv_ctx;
-	unsigned long event;
-
-	if (!priv_ctx)
-		return -EOPNOTSUPP;
 
-	bp->fw_health->fatal = true;
-	event = fw_reporter_ctx->sp_event;
-	if (event == BNXT_FW_RESET_NOTIFY_SP_EVENT)
-		bnxt_fw_reset(bp);
-	else if (event == BNXT_FW_EXCEPTION_SP_EVENT)
-		bnxt_fw_exception(bp);
+	set_bit(BNXT_STATE_RECOVER, &bp->state);
+	__bnxt_fw_recover(bp);
 
 	return -EINPROGRESS;
 }
@@ -159,24 +140,6 @@ void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 	if (!health)
 		return;
 
-	if (!(bp->fw_cap & BNXT_FW_CAP_HOT_RESET) || health->fw_reset_reporter)
-		goto err_recovery;
-
-	health->fw_reset_reporter =
-		devlink_health_reporter_create(bp->dl,
-					       &bnxt_dl_fw_reset_reporter_ops,
-					       0, bp);
-	if (IS_ERR(health->fw_reset_reporter)) {
-		netdev_warn(bp->dev, "Failed to create FW fatal health reporter, rc = %ld\n",
-			    PTR_ERR(health->fw_reset_reporter));
-		health->fw_reset_reporter = NULL;
-		bp->fw_cap &= ~BNXT_FW_CAP_HOT_RESET;
-	}
-
-err_recovery:
-	if (!(bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY))
-		return;
-
 	if (!health->fw_reporter) {
 		health->fw_reporter =
 			devlink_health_reporter_create(bp->dl,
@@ -186,7 +149,6 @@ void bnxt_dl_fw_reporters_create(struct bnxt *bp)
 			netdev_warn(bp->dev, "Failed to create FW health reporter, rc = %ld\n",
 				    PTR_ERR(health->fw_reporter));
 			health->fw_reporter = NULL;
-			bp->fw_cap &= ~BNXT_FW_CAP_ERROR_RECOVERY;
 			return;
 		}
 	}
@@ -213,12 +175,6 @@ void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all)
 	if (!health)
 		return;
 
-	if ((all || !(bp->fw_cap & BNXT_FW_CAP_HOT_RESET)) &&
-	    health->fw_reset_reporter) {
-		devlink_health_reporter_destroy(health->fw_reset_reporter);
-		health->fw_reset_reporter = NULL;
-	}
-
 	if ((bp->fw_cap & BNXT_FW_CAP_ERROR_RECOVERY) && !all)
 		return;
 
@@ -233,43 +189,23 @@ void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all)
 	}
 }
 
-void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event)
+void bnxt_devlink_health_fw_report(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
-	struct bnxt_fw_reporter_ctx fw_reporter_ctx;
-
-	fw_reporter_ctx.sp_event = event;
-	switch (event) {
-	case BNXT_FW_RESET_NOTIFY_SP_EVENT:
-		if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state)) {
-			if (!fw_health->fw_fatal_reporter)
-				return;
-
-			devlink_health_report(fw_health->fw_fatal_reporter,
-					      "FW fatal async event received",
-					      &fw_reporter_ctx);
-			return;
-		}
-		if (!fw_health->fw_reset_reporter)
-			return;
 
-		devlink_health_report(fw_health->fw_reset_reporter,
-				      "FW non-fatal reset event received",
-				      &fw_reporter_ctx);
+	if (!fw_health)
 		return;
 
-	case BNXT_FW_EXCEPTION_SP_EVENT:
-		if (!fw_health->fw_fatal_reporter)
-			return;
-
-		devlink_health_report(fw_health->fw_fatal_reporter,
-				      "FW fatal error reported",
-				      &fw_reporter_ctx);
+	if (!fw_health->fw_fatal_reporter) {
+		__bnxt_fw_recover(bp);
 		return;
 	}
+
+	devlink_health_report(fw_health->fw_fatal_reporter,
+			      "FW fatal error reported", NULL);
 }
 
-void bnxt_dl_health_status_update(struct bnxt *bp, bool healthy)
+void bnxt_dl_health_fw_status_update(struct bnxt *bp, bool healthy)
 {
 	struct bnxt_fw_health *health = bp->fw_health;
 	u8 state;
@@ -279,25 +215,15 @@ void bnxt_dl_health_status_update(struct bnxt *bp, bool healthy)
 	else
 		state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
 
-	if (health->fatal)
-		devlink_health_reporter_state_update(health->fw_fatal_reporter,
-						     state);
-	else
-		devlink_health_reporter_state_update(health->fw_reset_reporter,
-						     state);
-
-	health->fatal = false;
+	devlink_health_reporter_state_update(health->fw_fatal_reporter, state);
 }
 
-void bnxt_dl_health_recovery_done(struct bnxt *bp)
+void bnxt_dl_health_fw_recovery_done(struct bnxt *bp)
 {
 	struct bnxt_fw_health *hlth = bp->fw_health;
 	struct bnxt_dl *dl = devlink_priv(bp->dl);
 
-	if (hlth->fatal)
-		devlink_health_reporter_recovery_done(hlth->fw_fatal_reporter);
-	else
-		devlink_health_reporter_recovery_done(hlth->fw_reset_reporter);
+	devlink_health_reporter_recovery_done(hlth->fw_fatal_reporter);
 	bnxt_hwrm_remote_dev_reset_set(bp, dl->remote_reset);
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
index 456e18c4badf..a715458abc30 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.h
@@ -71,9 +71,9 @@ enum bnxt_dl_version_type {
 	BNXT_VERSION_STORED,
 };
 
-void bnxt_devlink_health_report(struct bnxt *bp, unsigned long event);
-void bnxt_dl_health_status_update(struct bnxt *bp, bool healthy);
-void bnxt_dl_health_recovery_done(struct bnxt *bp);
+void bnxt_devlink_health_fw_report(struct bnxt *bp);
+void bnxt_dl_health_fw_status_update(struct bnxt *bp, bool healthy);
+void bnxt_dl_health_fw_recovery_done(struct bnxt *bp);
 void bnxt_dl_fw_reporters_create(struct bnxt *bp);
 void bnxt_dl_fw_reporters_destroy(struct bnxt *bp, bool all);
 int bnxt_dl_register(struct bnxt *bp);
-- 
2.18.1


--0000000000001a0ad105cf790db0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFtYSrcE7SLB3WN69aArDUOKJso+/Eu9
SlesaQQ4Hun5MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
OTA3NDgyMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAztk5f19UMwuQ9d8oi6SOwYACxvDHLhu1J2lFfAMafapN3zeph
rthQI1qC5nDWKRJ7FTyN0MiKiQtvGL7Y1yvWCor/z2Us9wY02XPVdXTVpqB1aUH3TwuTqMuQz91d
ZhNFxXuarbLEkgMgGSn+YfEYZ4aPcOYRNsDWBL4p0i04dBCxV0GgLucRPWXlSOZRifVTz1938MtP
+pQdkgkJ8TRUOUva0qCm7Jww5X6Wj5gQE6Sn8wknIJbjKZ9TzmLpWDcVNEWOLc6E12ip9Lv2jreg
UbINozpQAMJTPmUNSCvK8pakZZ3qHx6fBeBYusutJ1n7pHwcfLfhwt4iYwnkru3r
--0000000000001a0ad105cf790db0--
