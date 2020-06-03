Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CB51ED80F
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 23:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgFCV21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 17:28:27 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39729 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgFCV21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 17:28:27 -0400
Received: by mail-wr1-f66.google.com with SMTP id t18so3905552wru.6
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 14:28:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yqk0FVZ/D5PwLrGDFJgkdVnK/uadJaMYeZjNAeD1XNo=;
        b=Q/ldZnyQRKgob/c67jt7nvyZfgRQ3S4hb7fsIjtwJPQ+L0eepjNGgH5wW70rAi9/PD
         Eysg2K37ZrSgh2b/TP9rvjHK2dPTnWbweizad48FbJa7sUoMtOw/QO3ucW8lHJpiESgd
         rRV+ow5ylTb9OgJ1S37io+2o3nvEkbXl5+Y/RiazBGfJ/xryBx+belIKdVGHg10olVtd
         bR4bMCVGeSW60lx1JOb8T5jKz+8vJqTunYPz5wDPd+LRNqo1AxCfTw0W09SYuuBaULRb
         Z7si83VrZSHY5uNj0QjQLv0YbWK84Zil5c/sIO04A4JSNjRiqSqb5y/TLjCa0pfCPkXK
         ynvw==
X-Gm-Message-State: AOAM5338VC32tFF6wf+smqdicVfJJBe8gg5q9ewFg5EQiQxi9XgF2W6N
        v5LqpNtV4fMGBloJitizoTtaPiJwd3tS0OjC
X-Google-Smtp-Source: ABdhPJwVyVWtHeupxCIKvT11fO03o9CCm5TElNLYwioF9aqGQeDDtJoTfowJt0QAmVHmFalhOy4eaw==
X-Received: by 2002:a5d:4b47:: with SMTP id w7mr1209655wrs.234.1591219705444;
        Wed, 03 Jun 2020 14:28:25 -0700 (PDT)
Received: from zenbook-val.localdomain (bbcs-65-74.pub.wingo.ch. [144.2.65.74])
        by smtp.gmail.com with ESMTPSA id z9sm4364583wmi.41.2020.06.03.14.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 14:28:24 -0700 (PDT)
From:   Valentin Longchamp <valentin@longchamp.me>
To:     netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org, kuba@kernel.org, leoyang.li@nxp.com,
        Valentin Longchamp <valentin@longchamp.me>
Subject: [PATCH] net: ethernet: freescale: remove unneeded include for ucc_geth
Date:   Wed,  3 Jun 2020 23:28:23 +0200
Message-Id: <20200603212823.12501-1-valentin@longchamp.me>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/sch_generic.h does not need to be included, remove it.

Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 552e7554a9f8..db791f60b884 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -42,7 +42,6 @@
 #include <soc/fsl/qe/ucc.h>
 #include <soc/fsl/qe/ucc_fast.h>
 #include <asm/machdep.h>
-#include <net/sch_generic.h>
 
 #include "ucc_geth.h"
 
-- 
2.25.1

