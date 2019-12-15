Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4364511F886
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 16:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfLOPeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 10:34:15 -0500
Received: from mta-p8.oit.umn.edu ([134.84.196.208]:36876 "EHLO
        mta-p8.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfLOPeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 10:34:15 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p8.oit.umn.edu (Postfix) with ESMTP id 47bT396kLwz9vYVr
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 15:34:13 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p8.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p8.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JUzmL8WVMqIi for <netdev@vger.kernel.org>;
        Sun, 15 Dec 2019 09:34:13 -0600 (CST)
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com [209.85.219.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p8.oit.umn.edu (Postfix) with ESMTPS id 47bT395bv1z9vYVX
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 09:34:13 -0600 (CST)
Received: by mail-yb1-f199.google.com with SMTP id o85so4533173yba.13
        for <netdev@vger.kernel.org>; Sun, 15 Dec 2019 07:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i1SA+jg2gGa3dwFVvbbudYqmdZ+Mqv92RS/q1DFUgTQ=;
        b=pTBjmvigNCVOvqSiZs1hBHOH1Kzfu4TiQaO2S0qrEPHn1tHHhGT49FjrQ+SeQL63xn
         K0tFGUreLj+YUsPDcK+tM3zOZR3BywZb6PDe9JJcJLvfT1KwxuvchO5lb4pLSMpiiznS
         8TUTnerRlDIURs3zOt3ocKL5nuhR6/SNLM9XWdOzC/bafAio9kdR9YXZvxBkF28YeSXm
         RQS8xlzhDSTfSyQfXu49fMu21CD1m34o/H1AEJpDkdjXpwgqDL+URwLcMGHhIHIsgoWB
         4rrKboRDWUWdZjflcMybZhKxTxKejLNUliPLFFpn+GTYSSslJBMcGVC2UW8aW4XfNt8q
         aCHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i1SA+jg2gGa3dwFVvbbudYqmdZ+Mqv92RS/q1DFUgTQ=;
        b=CZdywkMQnIH2YA1bsrITVKWaLsP/ItXWHZAlwRihL4Pv4Q5o5Jot1U/QSmetXKC5Z+
         SjfTtm6TkMO4kNi8DzBYbYTaWQMj3GhvTAYU1/WYB50WlKSEFXCNt2JXPOZmgeRDXqyw
         VlcbUpJEFkwLEcn+FhUVUFH5OZGU+hrxbOTA/nFv5Krv4JSmlZoQk1ImaLKumvuq/jfd
         cL1CE1UagXAke/RFCDjfaFWIx2QLJI4f1UwPWvqmMYgNPIkd/8iQYi8ubfGvAgf82Nj9
         L7x76xlAx/8F6fZekJrmv1Equ3SZcqQJIdlggokalLHQe8Xhrpgy6s/aY9FwVTYmsqT2
         wkXg==
X-Gm-Message-State: APjAAAWb5DYMk0G8XvaY/Ayowq61FFo+k5q8npBjELw3FmyzPVKyRota
        BVg5Bdn6W+8cRQrEJzr0M/PtudJywh+Y0dCCGdafYp5bxakUx2qZUpXi2JksW8Eiay3tw0+PDmn
        xg11/QB+Nq7YNqRWMuLKI
X-Received: by 2002:a25:c203:: with SMTP id s3mr10302775ybf.248.1576424053209;
        Sun, 15 Dec 2019 07:34:13 -0800 (PST)
X-Google-Smtp-Source: APXvYqzWR0ABIY4j4gOHYOR/m/1iY5qE/oV04KBsDfR0PSl9Tz4QWfFmO9sfezqVLhY/DQiBQmeiKg==
X-Received: by 2002:a25:c203:: with SMTP id s3mr10302762ybf.248.1576424052990;
        Sun, 15 Dec 2019 07:34:12 -0800 (PST)
Received: from cs-u-syssec1.dtc.umn.edu (cs-u-syssec1.cs.umn.edu. [128.101.106.66])
        by smtp.gmail.com with ESMTPSA id d126sm776365ywf.28.2019.12.15.07.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Dec 2019 07:34:12 -0800 (PST)
From:   Aditya Pakki <pakki001@umn.edu>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rfkill: Fix incorrect check to avoid NULL pointer dereference
Date:   Sun, 15 Dec 2019 09:34:08 -0600
Message-Id: <20191215153409.21696-1-pakki001@umn.edu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rfkill_register, the struct rfkill pointer is first derefernced
and then checked for NULL. This patch removes the BUG_ON and returns
an error to the caller in case rfkill is NULL.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 net/rfkill/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 461d75274fb3..971c73c7d34c 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -1002,10 +1002,13 @@ static void rfkill_sync_work(struct work_struct *work)
 int __must_check rfkill_register(struct rfkill *rfkill)
 {
 	static unsigned long rfkill_no;
-	struct device *dev = &rfkill->dev;
+	struct device *dev;
 	int error;
 
-	BUG_ON(!rfkill);
+	if (!rfkill)
+		return -EINVAL;
+
+	dev = &rfkill->dev;
 
 	mutex_lock(&rfkill_global_mutex);
 
-- 
2.20.1

