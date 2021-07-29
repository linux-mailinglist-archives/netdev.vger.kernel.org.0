Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757F43DA7E4
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 17:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237932AbhG2PxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 11:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhG2PxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 11:53:17 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB190C061765
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 08:53:12 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id y10-20020a0cd98a0000b029032ca50bbea1so4140586qvj.12
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 08:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=kDD2D16B95ZL1/X+mpmMETrCt9sLHK8AzoYNaSvwW54=;
        b=GX6r/G+XWZyrwsjcyMyk7ceXaER6LXX6Y4o4o1IYzO4rJwNS/V53jSkToVt4OqFbtb
         /L5In5pYhnZTPwqDnMV+wqETzz/t2SxFM8gZgKbedf5c43bkfX1Q2EaxFqe+y1mJlJ6M
         PawN/SAw1uQShNDyMfkLBUz4KX0Ad/RD6VpcIkbGe3uthW428c2zMJNjuf8uUekQoXPN
         +gcQpVRSliiDz8Ky9fR84wBx7A4xojbXh+/qNKnFiLGZpKYf4dyjJ74MXJg4FMXKzLIN
         Mh+mpAUhCIzR1l4P25gVU0Dn2rxplZXMT5YMN+ykznUX3X7E/Mc5h8aHkE0a4wVoUiLq
         //hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=kDD2D16B95ZL1/X+mpmMETrCt9sLHK8AzoYNaSvwW54=;
        b=FgxTFgiZFTKUft1a7c9Kz7anP99XxLZ8eJobxR+9D4Kei7h2AYfoq+BFhxVp6lt5T3
         gYdy2LsIa1twbUQQWOnHnJCtVc90NtbLMRC/b/ONbtepbepUOyldLIJ7A5rQDiy+6adQ
         TK+66ocrgtvvDwONouUEEFovvdS8m1Nxsz9omYeAiWW3alnZxT2chTEY8I3Z7yWvYe8i
         QMDzTNTSmiafbMzvC4VD4XMgC3bM3w12UgTazUqH1PpjGfZx7xwSPxaz8EmdEOW44ijU
         SLE6GB5EWQd5uTdr9uNeKg7EesIPR3o8XSdnQKoTzcXXMT2H8PCFINMC+AkqDWqYJd1M
         VBhg==
X-Gm-Message-State: AOAM533zPj0PZWhuiJ48sKR/76gie44DALpchixNSwR7G+fCHwx8NS82
        RP/cUX8vkBOMhFPcVNFas3aZPjr2ez+CJAdd2ynWP4NFpm59+Y8ohJTW9+q5hZd3x1CTNqdwQ9t
        HFdyrSGYH8AQqayVoCPtqStykcLShRlEW5SAZeDystm4d1gxjcQxHoBhB9zmoQQ==
X-Google-Smtp-Source: ABdhPJyOxoyiMTI7Z6dbMyoDu7bmGhgohaQVBNbE6VZmNPOb/ZHqZbpOmTdAyxwE8gizAO3KzDQtyZH8vGo=
X-Received: from csully2.sea.corp.google.com ([2620:15c:100:202:a024:b8f7:be66:748c])
 (user=csully job=sendgmr) by 2002:ad4:57c6:: with SMTP id y6mr2736354qvx.33.1627573991935;
 Thu, 29 Jul 2021 08:53:11 -0700 (PDT)
Date:   Thu, 29 Jul 2021 08:52:58 -0700
Message-Id: <20210729155258.442650-1-csully@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH net-next] gve: Update MAINTAINERS list
From:   Catherine Sullivan <csully@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Catherine Sullivan <csully@google.com>,
        Jon Olson <jonolson@google.com>,
        David Awogbemila <awogbemila@google.com>,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The team maintaining the gve driver has undergone some changes,
this updates the MAINTAINERS file accordingly.

Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: Jon Olson <jonolson@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 73beb91891ee..6502f0ddf464 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7859,9 +7859,9 @@ S:	Maintained
 F:	drivers/input/touchscreen/goodix.c
 
 GOOGLE ETHERNET DRIVERS
-M:	Catherine Sullivan <csully@google.com>
-R:	Sagi Shahar <sagis@google.com>
-R:	Jon Olson <jonolson@google.com>
+M:	Jeroen de Borst <jeroendb@google.com>
+R:	Catherine Sullivan <csully@google.com>
+R:	David Awogbemila <awogbemila@google.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/device_drivers/ethernet/google/gve.rst
-- 
2.32.0.432.gabb21c7263-goog

