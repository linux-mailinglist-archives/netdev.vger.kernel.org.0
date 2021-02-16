Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006BD31C6BC
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 08:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhBPHTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 02:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhBPHTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 02:19:35 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C123CC061574
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 23:18:54 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id t25so5707784pga.2
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 23:18:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kpavRPMaQW2ggEMzwpAGuzmX7gv2kYubpxcv451IleE=;
        b=CXlZuebfVZAGkdeLEWrADk8HrJ74/HQwIBaJkZXM74YBBdeqQ7gCoMOdyA551pUZHR
         eq/9PWTps4wQLtVWxn/eUjEiiP33lw4qYDawfV8BaI7cA2UvmnnZeEKGmybvYoIhEv22
         KCtRkcUCEy2XI7Xb0Ttpw5+q8s7P41/3HBH7jbep8dFH6V03ICx1K3W6vK87Kkhvf5JO
         xsp4uEbUHfyUbGuN/mbJASxtDQpp3YWU78+s+fFQqoS6gBFr1QQqXZbxHnIsCsQE7zW+
         T7V6mrVDRn+3D+y20wH0audnHuU4xxmRA5Sxa54AB7sx+w1LCXJfqOUTLo6No6AMlBbk
         VdLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kpavRPMaQW2ggEMzwpAGuzmX7gv2kYubpxcv451IleE=;
        b=aLuE9Qy1iPbauywWm/zVRYkTcuRXqO77ERzH8/yJOJRSQLM1F+dqgX1YUoxf08ZdT9
         nEJc48coqTgiVimUj+FyKyuvcRLnyIXhHfLrdUR4Rb+Z8knyaDySgQ9jzpFfF+/IM3zz
         lYijlSNdit6cqF/xWSyInz/55o6Ea2JDdBw2hc8ccqfaylSwPcwFfmincg1Gnt0Ej2w0
         L5CPj7PzDmnOIf1Cr8oLl3nLvxe4ksl5jSpAc7zM+4ziPZW0wsgHe3ivvgCVY/tO5Wnf
         XnUHcZvLvBjUijcHC7r6r9hlMzf8UTy+5HOEwJuWGISEK6BzOuG+HpEzRmwBodSpSpqn
         A6fQ==
X-Gm-Message-State: AOAM533Nrl05UcC1oT83J11VlLPfoV+vz/oi2iy65PvIkTJf9XtOQAL2
        FW0kW9hjtA1IMdEJ4uGw5X8=
X-Google-Smtp-Source: ABdhPJwz74wApvc3vd+UM+hguIMIBcd0hF7oq51jtVwV79ZDVZI0WZ/27SunXqVj/aKjoYdy+lVzdw==
X-Received: by 2002:a63:ed58:: with SMTP id m24mr18272266pgk.45.1613459934226;
        Mon, 15 Feb 2021 23:18:54 -0800 (PST)
Received: from ThinkCentre-M83.c.infrastructure-904.internal ([202.133.196.154])
        by smtp.gmail.com with ESMTPSA id o14sm22077561pgr.44.2021.02.15.23.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 23:18:53 -0800 (PST)
From:   Du Cheng <ducheng2@gmail.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Du Cheng <ducheng2@gmail.com>
Subject: [PATCH] fix coding style in driver/staging/qlge/qlge_main.c
Date:   Tue, 16 Feb 2021 15:18:49 +0800
Message-Id: <20210216071849.174077-1-ducheng2@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

align * in block comments on each line

Signed-off-by: Du Cheng <ducheng2@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 5516be3af898..bfd7217f3953 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3816,7 +3816,7 @@ static int qlge_adapter_down(struct qlge_adapter *qdev)
 	qlge_tx_ring_clean(qdev);
 
 	/* Call netif_napi_del() from common point.
-	*/
+	 */
 	for (i = 0; i < qdev->rss_ring_count; i++)
 		netif_napi_del(&qdev->rx_ring[i].napi);
 
-- 
2.27.0

