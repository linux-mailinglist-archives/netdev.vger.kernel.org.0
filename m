Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C29CDDE3C5
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 07:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfJUFfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 01:35:02 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45435 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfJUFfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 01:35:01 -0400
Received: by mail-pf1-f193.google.com with SMTP id y72so7652108pfb.12
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 22:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kTqK9t2LRs5UqtsJuoYNwtBvl+nzZARrzgqf8FNHCbg=;
        b=a1bouNf/LUvFfNEHS30P6s36P0b/R/f21PYJGOfSfbUtkPQ5zN09inLHbFu4OcBlpJ
         DoAmhDkwpNg1n6WigXL17M4rcrNBQvQxiZaAj+1YXA/ce/Jl9Ilkrh4VwUaVH95NP58Y
         ARMo3aCjjrE/K7hKUrdnXLxKW+gZ70GgYPplk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kTqK9t2LRs5UqtsJuoYNwtBvl+nzZARrzgqf8FNHCbg=;
        b=G4sSCXvmXXkqLh0YHC/9P5SBZVVzVGI9iP7NMamrOJM9sG0/pq7sVsjff5zmBvtA2o
         FPQSzvqBHpKJE/WVzZ5F0RW/27YcrHdp7VirrLXWBZs9Ew47UlUfmBDGX6eViQG59dXO
         3OFBEnjPSesELP/fwsDHXS5+vow9yEOS+ANKb7Z8yK0XrzTqfb8PtCAnekMg4y3sgYSB
         Y/Nm7UkZwl8G0/ry3wZjBAVxjGyjSSyYLB8d1DhoPfF9UjAgj0KJ4gP3TLRdYSFSYDpj
         GAd4CepXLy+l0UFkA32+FeWk9lgV2S0weEdYHF+JDhQT0FDx1uqVICfoqbnh7TKtQYWj
         f7KQ==
X-Gm-Message-State: APjAAAVgDZrcnWfiTq3+ZjkQ9/l9JNYbRLM7yHp2EnGIiDexzlwj5vv5
        3sT5+0wXLFugV348Yeq6k7KQ807vt64=
X-Google-Smtp-Source: APXvYqwrlQ2y3JFkgNIzJdv5hhlnoeuUsDyaBS3SrzAVNAj++6vWGM0DHvHwm6rKaunHj0O8LyV5yQ==
X-Received: by 2002:aa7:9842:: with SMTP id n2mr21087333pfq.258.1571636100447;
        Sun, 20 Oct 2019 22:35:00 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w2sm14713255pfn.57.2019.10.20.22.34.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Oct 2019 22:35:00 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, vasundhara-v.volam@broadcom.com,
        Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net 4/5] bnxt_en: Minor formatting changes in FW devlink_health_reporter
Date:   Mon, 21 Oct 2019 01:34:28 -0400
Message-Id: <1571636069-14179-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
References: <1571636069-14179-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

Minor formatting changes to diagnose cb for FW devlink health
reporter.

Suggested-by: Jiri Pirko <jiri@mellanox.com>
Cc: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
index bd4b9f3..7151244 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
@@ -29,25 +29,20 @@ static int bnxt_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
 	val = bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG);
 	health_status = val & 0xffff;
 
-	if (health_status == BNXT_FW_STATUS_HEALTHY) {
-		rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
-						  "Healthy;");
-		if (rc)
-			return rc;
-	} else if (health_status < BNXT_FW_STATUS_HEALTHY) {
-		rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
-						  "Not yet completed initialization;");
+	if (health_status < BNXT_FW_STATUS_HEALTHY) {
+		rc = devlink_fmsg_string_pair_put(fmsg, "Description",
+						  "Not yet completed initialization");
 		if (rc)
 			return rc;
 	} else if (health_status > BNXT_FW_STATUS_HEALTHY) {
-		rc = devlink_fmsg_string_pair_put(fmsg, "FW status",
-						  "Encountered fatal error and cannot recover;");
+		rc = devlink_fmsg_string_pair_put(fmsg, "Description",
+						  "Encountered fatal error and cannot recover");
 		if (rc)
 			return rc;
 	}
 
 	if (val >> 16) {
-		rc = devlink_fmsg_u32_pair_put(fmsg, "Error", val >> 16);
+		rc = devlink_fmsg_u32_pair_put(fmsg, "Error code", val >> 16);
 		if (rc)
 			return rc;
 	}
-- 
2.5.1

