Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9F20D1911
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 21:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731883AbfJIThM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 15:37:12 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40809 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729535AbfJIThM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 15:37:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id b24so3826475wmj.5;
        Wed, 09 Oct 2019 12:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y7r5Z69fE1yE+XsafCfc/oZ4rs1PL76oFBNneE1EVE8=;
        b=bXhDVAbBSH3nu0+3VBqanYJaQtnG98xE7SV1K8c3DHjr98GUJ2+XwhgVwnX+OVbGb5
         vwG2VeyXxgj38EIhXlxDNJVyYx/APSFtH3OAgpD1mq1CKGv/QJeqgeZiiK9uPJrUMQCj
         5PD4B/kL1tmrvJGSduuDAb37gYg7XQrD9dIL30kq9HUqm9/xYxk1mQ3RUzn4gkgu1u4K
         LcFOQ9lCFeXvPl8gDkS5yXQ1jYE49yuEoRAXR1klzwqq+r34taKXdbrXOv8SZv3X0Vel
         01RUeYDU9UeZ3D9RZyCwOoPNg6b0PfriaEsUHbrq05tWR3qrxQLo7MJHVOOejjKveqHB
         Roeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y7r5Z69fE1yE+XsafCfc/oZ4rs1PL76oFBNneE1EVE8=;
        b=E7Kp2/OJvOVbCSlco9DMIg1oNv1V7PkvIMIY2Lug70INw/ZAi3UY1TnLvgkagkTyII
         6shbW18NaO8DxjVUyh+s+RUlNE+9Nwrf+Y0sPETuGS7+dZN+DkMDH98ld4Q6YirPUHnS
         M+Qi9u38/9+d3sWFpnnjkwoTcNxHlb3m4lEhKYrIaP3uE2dDHgTW5xd7bxM2PLgg5eDE
         ewnSkKslSYccpQ+pb6Zs4F95f3C5WLqhYn0q1K/XIVDtwfJkilhZKigOHM51Go9ElJGT
         414WxSlr7YLqWmv1gj14Eq3pE/5wUQKt+ZUUiE2WWFvPIRiWDfP4fCEzF5lIqjTdncIS
         urFg==
X-Gm-Message-State: APjAAAU/nDEemE/427FnfSTlwvbeYvQxdpTctCMDkPjCFKkT2XHjExDz
        YFl4aGZ6nR4et+6qbvlMyA==
X-Google-Smtp-Source: APXvYqzZKRGEjsUvJFQOI0BXJvpGfq7FfTl+zFZ1bDADWZ6SAvKJ/nfywHK3MAPrtqMLk3UxYci22Q==
X-Received: by 2002:a1c:dcd6:: with SMTP id t205mr4005907wmg.10.1570649829007;
        Wed, 09 Oct 2019 12:37:09 -0700 (PDT)
Received: from ninjahub.lan (host-2-102-13-201.as13285.net. [2.102.13.201])
        by smtp.googlemail.com with ESMTPSA id n26sm1603548wmd.42.2019.10.09.12.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 12:37:08 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     outreachy-kernel@googlegroups.com
Cc:     grekh@linuxfoundation.org, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jules Irenge <jbi.octave@gmail.com>
Subject: [PATCH] staging: qlge: correct misspelled word
Date:   Wed,  9 Oct 2019 20:36:56 +0100
Message-Id: <20191009193656.5209-1-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct misspelled word " check
 issued by checkpatch.pl tool:
"CHECK: serveral may be misspelled - perhaps several?".

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/staging/qlge/qlge_dbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index 086f067fd899..097fab7b4287 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -354,7 +354,7 @@ static int ql_get_xgmac_regs(struct ql_adapter *qdev, u32 *buf,
 
 	for (i = PAUSE_SRC_LO; i < XGMAC_REGISTER_END; i += 4, buf++) {
 		/* We're reading 400 xgmac registers, but we filter out
-		 * serveral locations that are non-responsive to reads.
+		 * several locations that are non-responsive to reads.
 		 */
 		if ((i == 0x00000114) ||
 			(i == 0x00000118) ||
-- 
2.21.0

