Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC6A11BCCC
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 20:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfLKTXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 14:23:09 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42942 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726487AbfLKTXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 14:23:09 -0500
Received: by mail-oi1-f196.google.com with SMTP id j22so14271541oij.9;
        Wed, 11 Dec 2019 11:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bCTr7fmrdCM12DG9npwXco6rWsJDAoPjlBHUqV/P72g=;
        b=Yu3O0jeojH9Zes6n3MGhRv6Z2hJetFnAU0HFzlmpIeQ8tXn5icPQNhoDBNAfiDjYi+
         C4qFwFSudaOksvVtGhfIi3a7yjQ7Lvx/FjlpKW4eVFQzsJZa9NPBjLJ7O9RQzMHp8axa
         K1OqSEFo60qKYj0d1CwGYjFadxgSp1iY0J/HrrGXkgIAlNZkUc6M0beuVU0PeBqT3gCO
         H3lKCqhvE1EPBRccaubq0e4EUy5Q4W7eSYx8xTUGF209Ee/IXh4KvwRuJUlLohhCVEIh
         O4ydXScx5up4u3BoBOT6DgCOoQsOswD/dhDFe60lmoq2CVtHZwWYhXokBqVvRRg1VriV
         TFLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bCTr7fmrdCM12DG9npwXco6rWsJDAoPjlBHUqV/P72g=;
        b=N8lGH1kBmkb7z6yWBwL9eXcXdiSlnbjDKDfuVzitz4uSMKkgjVjE8q+/FN0zHvgv8i
         h50gAHS539MVq2ZUL25UXZBiRJ2gT2lFx4IAEEnlxaqhcC/z8Zi0iCoWpNmG9dq9dD77
         sIyOTq+UvC0wXr3zKD7vv5Gy7uNPzjcxnH4UmGpID521u+Y1ca7f9l2wtgviIKu52fCD
         vI75Y71hp5wtkRabPzsAfz1UtbUjuAmZWurC9P2Wmv1InvJmc3J5Zg4lSWO8ezh7lkK1
         Ne3y+eyBOOcP+FS+KwoPBonxivZlaq6xjtifuJGBjICOkCA0XF9qa9PWyfqcMYovtVPj
         EOeg==
X-Gm-Message-State: APjAAAXn+1GPKuwDoCRJ0oJ2/UH6gAv/pXZ6Dfb1QIQQu4cc9p0ylQzI
        UMSQwsu3HiZtxyu1kLM8aQ0=
X-Google-Smtp-Source: APXvYqyUDGwkPUj7a4qQgGxJBjJeSklRA8D/d1M6Ib+kCUZaHC8bp/tqkEhAmR7AONWoA/pnQT2REQ==
X-Received: by 2002:a54:4407:: with SMTP id k7mr4200950oiw.56.1576092188199;
        Wed, 11 Dec 2019 11:23:08 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id a74sm1112930oii.37.2019.12.11.11.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 11:23:07 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] ath11k: Remove unnecessary enum scan_priority
Date:   Wed, 11 Dec 2019 12:22:52 -0700
Message-Id: <20191211192252.35024-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

drivers/net/wireless/ath/ath11k/wmi.c:1827:23: warning: implicit
conversion from enumeration type 'enum wmi_scan_priority' to different
enumeration type 'enum scan_priority' [-Wenum-conversion]
        arg->scan_priority = WMI_SCAN_PRIORITY_LOW;
                           ~ ^~~~~~~~~~~~~~~~~~~~~
1 warning generated.

wmi_scan_priority and scan_priority have the same values but the wmi one
has WMI prefixed to the names. Since that enum is already being used,
get rid of scan_priority and switch its one use to wmi_scan_priority to
fix this warning.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Link: https://github.com/ClangBuiltLinux/linux/issues/808
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/wireless/ath/ath11k/wmi.h | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index 4a518d406bc5..756101656391 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -2896,15 +2896,6 @@ struct wmi_bcn_offload_ctrl_cmd {
 	u32 bcn_ctrl_op;
 } __packed;
 
-enum scan_priority {
-	SCAN_PRIORITY_VERY_LOW,
-	SCAN_PRIORITY_LOW,
-	SCAN_PRIORITY_MEDIUM,
-	SCAN_PRIORITY_HIGH,
-	SCAN_PRIORITY_VERY_HIGH,
-	SCAN_PRIORITY_COUNT,
-};
-
 enum scan_dwelltime_adaptive_mode {
 	SCAN_DWELL_MODE_DEFAULT = 0,
 	SCAN_DWELL_MODE_CONSERVATIVE = 1,
@@ -3056,7 +3047,7 @@ struct scan_req_params {
 	u32 scan_req_id;
 	u32 vdev_id;
 	u32 pdev_id;
-	enum scan_priority scan_priority;
+	enum wmi_scan_priority scan_priority;
 	union {
 		struct {
 			u32 scan_ev_started:1,
-- 
2.24.0

