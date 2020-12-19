Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEED22DECA9
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 02:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgLSBtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 20:49:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725965AbgLSBtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 20:49:43 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391FAC0617B0;
        Fri, 18 Dec 2020 17:49:03 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id s21so2575104pfu.13;
        Fri, 18 Dec 2020 17:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2j49Gx9LYlDWXbgch6bH1paojmD1EOzxW+XQY6MZRdo=;
        b=bfKeBCz6ASxeMkwKtCqauSuFWOsC2RQF6Fma4qvpVyhG3PHWbW1jalMFcH7BSLybSP
         vMbZGR6G+ehSGm1k7R++SCqNbBu5NurHc6xfrNi/mgcLfChuluKFAdavXS5F4K3zPI6s
         oFtYyLC26pHvjY8qjDVCRBxuNTvFeLSyD48RJ0T4o6GAhYLWdoYlGyO9GESEk7/DdNKo
         ttZXtvmmUlRmSRc9WINAA66u+0HD7zCHvFFzYosnzp46MUsXcuB5pLNuc4Fl+ZySyqOD
         VpdEL6snhkyn74uJ/KgSJ2YGzSoudRu4qPK2vR2/sUcdB8GQ+OQM76FNW6gcvDnJrEdJ
         pN/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2j49Gx9LYlDWXbgch6bH1paojmD1EOzxW+XQY6MZRdo=;
        b=Od6RRNMzwtWszr+czFcYS7wyhQVSNH3I5oY5mgOwocsOfEmU3aPYJTUzrnCnjQH0wB
         w3XzjzaP1K4tm80rW9NPUFnYKTHcIa4Vm8wsP/9t0jch8y07w7/MVfB4pbqsFHmwMo6Q
         PM6E1FhOFGXvbRN96/phc1MVsCiGFdc+O87LveUotRUjU0ud4AlMFPE4q/8W/G5sYp8v
         JK2IpIVZl9z3k+xRBOiYxqhDo8Kmg4p52KftoueuJ5V5JT/s4faiNQgVlZgZhgW6zBeX
         rW5MmREdPKBAy4RSDa+qc86a5nEMJiDZ6jpWSQ46NpbnXsxCjtOkTW+qTgRrEmR9ii6j
         V7Cw==
X-Gm-Message-State: AOAM532vy1u/mDGB/3RcXA5NAdlsGLVjsFjBfq7U6eGzindQOsnhHjyT
        jRW75Yip72WY+50r9uslT+s=
X-Google-Smtp-Source: ABdhPJxh1ZyRmnzJIDbIIKxPR2KDP7jR0TIBiZ9oyDFQeNX+VgI5+/z9Q2KyLmPTlqS/JxskGE1q5A==
X-Received: by 2002:a63:d62:: with SMTP id 34mr6675669pgn.276.1608342542752;
        Fri, 18 Dec 2020 17:49:02 -0800 (PST)
Received: from localhost.localdomain (c-24-16-167-223.hsd1.wa.comcast.net. [24.16.167.223])
        by smtp.gmail.com with ESMTPSA id 77sm10084904pfx.156.2020.12.18.17.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 17:49:02 -0800 (PST)
From:   Daniel West <daniel.west.dev@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com
Cc:     gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Daniel West <daniel.west.dev@gmail.com>,
        Daniel West <daniel.s.west.dev@gmail.com>
Subject: [PATCH] staging: qlge: Removed duplicate word in comment.
Date:   Fri, 18 Dec 2020 17:48:29 -0800
Message-Id: <20201219014829.362810-1-daniel.west.dev@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the checkpatch warning:

WARNING: Possible repeated word: 'and'

Signed-off-by: Daniel West <daniel.s.west.dev@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index e6b7baa12cd6..22167eca7c50 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3186,7 +3186,7 @@ static void ql_enable_msix(struct ql_adapter *qdev)
 		     "Running with legacy interrupts.\n");
 }
 
-/* Each vector services 1 RSS ring and and 1 or more
+/* Each vector services 1 RSS ring and 1 or more
  * TX completion rings.  This function loops through
  * the TX completion rings and assigns the vector that
  * will service it.  An example would be if there are
-- 
2.25.1

