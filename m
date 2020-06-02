Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9338E1EBA46
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 13:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726342AbgFBLWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 07:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgFBLWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 07:22:41 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405CCC061A0E;
        Tue,  2 Jun 2020 04:22:41 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id n9so1240223plk.1;
        Tue, 02 Jun 2020 04:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LFCYo6Ppo4sEF/Ge4xWjhzf5GS4llSMO5W63JlrM7KQ=;
        b=bKZCM1vPpptfyYMSXvgRkpuRDbMki1FhOPMqlwbLnVstbWg0qiqkCS1O57oOXwQuQd
         +ilqEQ3DcHER6lECOK0foKhzOkTLOSYYit6+mH2EPqtG6maZexBnUAhVwi21cWColo0Q
         LNLXHyjqDkZ+BpqzSA4rD7zFYqK9asLhlURmRvN5Clt2uOtW5gk+oJJMZgIKxdV4HfME
         XLZ+iDkilPNPZAN39AAfIUzJ1nHvXIMVEWwTbpZ+ZKUPESlWucThCvXB2gDmpRwMTDSu
         6UJDn0pcZiK9LrY8sUHbLAI4FD7gQnKG+9tZ7dDHfESkcuIw0qdBa9KR49+mZTrYxGwB
         DLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LFCYo6Ppo4sEF/Ge4xWjhzf5GS4llSMO5W63JlrM7KQ=;
        b=W1I5D3653Iy6hxd+zG13t5VuSXLERO31JyAK4HArgnjUAT515TtgtPa1I+pE5n4Kqe
         0fjzC9QI2HnQpjcAM8hmnTXchdKY112JkOH3fs871uEkpiQbHcphDgenwzuC0UcRjY1v
         6d+4vjXFCTfdJob9QJWF2Xwjcy+wMRUxhyoc1QcfIn7yIsULoEqPgWtanzAlm8+LUoCJ
         4bWJ2IcRT7zb2MfEM/12E58GsgxvNSPNSg1WnqjFhbid3JZKk87PwbDkCcKorv6Lb1Ct
         zCMJEcQ6z2wj6TYtBYPf4XiLqMSA456sW1FERShdAHKDkDCgeah8NkVTfIu0hu6B+qMS
         CtYg==
X-Gm-Message-State: AOAM531Udhb/OXNjIdpom/7njC5K+9SiSuxfvArt1u6PrdZMr7jf0aM3
        VSwcli1Big9e1jh83eTixBk=
X-Google-Smtp-Source: ABdhPJwfTFUI1HfGsYg4wx0v6+YoLTxCwj7X0smn80Ce1gQdJ41svgwZ/rNmBwG0aIWD24XxuXXlDA==
X-Received: by 2002:a17:902:bb95:: with SMTP id m21mr12586768pls.262.1591096960561;
        Tue, 02 Jun 2020 04:22:40 -0700 (PDT)
Received: from localhost.localdomain ([2409:4072:189:c86a:7149:74ab:b584:ecf8])
        by smtp.gmail.com with ESMTPSA id j9sm2238172pje.28.2020.06.02.04.22.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 04:22:39 -0700 (PDT)
From:   Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
To:     Rain River <rain.1986.08.12@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     aishwaryarj100@gmail.com
Subject: [PATCH] net: nvidia: forcedeth: Drop a condition with no effect
Date:   Tue,  2 Jun 2020 16:52:28 +0530
Message-Id: <20200602112228.30333-1-aishwaryarj100@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As the "else if" and "else" branch body are identical the
condition has no effect. So removing "else if" condition.

Signed-off-by: Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
---
 drivers/net/ethernet/nvidia/forcedeth.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 2fc10a36afa4..87ed7e192ce9 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -3476,9 +3476,6 @@ static int nv_update_linkspeed(struct net_device *dev)
 	} else if (adv_lpa & LPA_10FULL) {
 		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
 		newdup = 1;
-	} else if (adv_lpa & LPA_10HALF) {
-		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
-		newdup = 0;
 	} else {
 		newls = NVREG_LINKSPEED_FORCE|NVREG_LINKSPEED_10;
 		newdup = 0;
-- 
2.17.1

