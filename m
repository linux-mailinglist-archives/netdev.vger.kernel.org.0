Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C032B4C019
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfFSRqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:46:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45486 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFSRqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:46:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id s21so53002pga.12;
        Wed, 19 Jun 2019 10:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p6IVXYlVuJlQoN/6JHd/VdIa8V+ZBuYUYvcRcdxvjmc=;
        b=FWD2WZR2a6aCqLNWA4CVeNGKJ5VvhBFFDm0ZAdUwXz3R9FSQ12bYlqksxiii2kjgqe
         agbkxgn3gVW7izsRKIssCdPo8GjWuJe9+Kx2QDWISbIMv8tQsoRfUeccrNOvK5dDk7kp
         rFR95TnHoLAIChdtvjiY94Vz6ay4bt+1iaUfg8likg1e3VCRWDgPzdUIV5QV30SCez+L
         OyaE4fCDOl1GjWlc/qWeiS22CmIHB1mSRjay3o7RmsihCeu4S6z6U7Tc5/FGYexolpRT
         jMf2kCgbmjYqc3sMFz5gKmHTaH7wG/9y4+547nDAADE+dfS2wNnGOWbQdnz6PJJ9vJVb
         crCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p6IVXYlVuJlQoN/6JHd/VdIa8V+ZBuYUYvcRcdxvjmc=;
        b=Vq2puSPxVXcn6cvSDg3RJFo4DwbG59HKufJEN/qmQf4dUHfWac3YVCSsSZ990vNkqV
         GfjYIyG0KG0DXupDcP/Az0e1KpcrfvPnW4Y3WBsdCN8YG8uhxQfwKPAVI0Z7AbqIIEH8
         eEq1dD46P7KXZ5JTwrdFlQWhItj53NtYuYugroMVE9Ps+t9Hjwv6ZTqDiV0qNTHNXq+H
         Kjwf0+pRrg1Dnnn2iyEqERR+K5sdUaPhWjfgAB/W36iHiJadFRkmqs/KMVdjycdBr2S6
         kTfzypiyvU0aGZ8jjovXEhMkaPHlRqeS+yHGgTVL7e82k9x1QaXcbPwTEsGgDppvXkFp
         bIvw==
X-Gm-Message-State: APjAAAXSPA2UcDSt8DbGve2N8pIGbypSLZfUAqLRz1xcKMJnRAyDFL0o
        z0Wcdk2tOcJNtLIXELAuo+Q=
X-Google-Smtp-Source: APXvYqwchSELuYw6pQpPrFApF0j7wFDCeTlzJ0Ut8rec5FtZAYKF0FkC2we8VuMezYLqpdToBJZXbA==
X-Received: by 2002:a63:1516:: with SMTP id v22mr9055232pgl.204.1560966384086;
        Wed, 19 Jun 2019 10:46:24 -0700 (PDT)
Received: from localhost.localdomain ([112.196.181.13])
        by smtp.googlemail.com with ESMTPSA id n89sm12664301pjc.0.2019.06.19.10.46.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 10:46:23 -0700 (PDT)
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     Puranjay Mohan <puranjay12@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bjorn@helgaas.com>,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [PATCH] net: fddi: skfp: Include generic PCI definitions from pci_regs.h
Date:   Wed, 19 Jun 2019 23:15:56 +0530
Message-Id: <20190619174556.21194-1-puranjay12@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include the generic PCI definitions from include/uapi/linux/pci_regs.h
change PCI_REV_ID to PCI_REVISION_ID to make it compatible with the
generic define.
This driver uses only one generic PCI define.

Signed-off-by: Puranjay Mohan <puranjay12@gmail.com>
---
 drivers/net/fddi/skfp/drvfbi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/fddi/skfp/drvfbi.c b/drivers/net/fddi/skfp/drvfbi.c
index bdd5700e71fa..38f6d943385d 100644
--- a/drivers/net/fddi/skfp/drvfbi.c
+++ b/drivers/net/fddi/skfp/drvfbi.c
@@ -20,6 +20,7 @@
 #include "h/supern_2.h"
 #include "h/skfbiinc.h"
 #include <linux/bitrev.h>
+#include <uapi/linux/pci_regs.h>
 
 #ifndef	lint
 static const char ID_sccs[] = "@(#)drvfbi.c	1.63 99/02/11 (C) SK " ;
@@ -127,7 +128,7 @@ static void card_start(struct s_smc *smc)
 	 *	 at very first before any other initialization functions is
 	 *	 executed.
 	 */
-	rev_id = inp(PCI_C(PCI_REV_ID)) ;
+	rev_id = inp(PCI_C(PCI_REVISION_ID)) ;
 	if ((rev_id & 0xf0) == SK_ML_ID_1 || (rev_id & 0xf0) == SK_ML_ID_2) {
 		smc->hw.hw_is_64bit = TRUE ;
 	} else {
-- 
2.21.0

