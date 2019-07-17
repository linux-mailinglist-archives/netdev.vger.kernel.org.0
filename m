Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 904906C1AD
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 21:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfGQTqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 15:46:48 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:38539 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfGQTqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 15:46:48 -0400
Received: by mail-pf1-f182.google.com with SMTP id y15so11354559pfn.5
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 12:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=7lJLO2f7sUbmPmmNVeD3rAr1/Rsn85WwYcdLa3zGdTk=;
        b=f4fLQotU4ZBJLd9mSuNnkQOdtakTlWOr/zrIASyxTj+QjilSfVgMYYSc1OvXu+GJEq
         VmpXYUBW/E+Rc1+C6rB17fwjPrCc4uEDueOwzVrrMe+EXy1aI4HLz9lsbx/99LohWEZL
         yx527o6Niu5/XPxvn11UpsC/zVPQv1UdYyVfA+Z9hQgMhAb6PgOfppVXuii8ahpsDNVv
         CyxhTNbFy/GhSpbBbs1PZU2Id4AJnjuBxJB5t5HsNe9BM6WA8eEZ5qjrr0B8iCN6Kith
         BtZ9R83PDj/wwUacXf4SxCc8/w5tabyeoPlh6STlZAUny5l7COsnb/pqWwdfCWTKtooI
         ECgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=7lJLO2f7sUbmPmmNVeD3rAr1/Rsn85WwYcdLa3zGdTk=;
        b=jbmwnCX8H2fJCcsYV9+XqNr+TZLiDSHjuqzCnKcktIoBmN8W6dbrC4q0GekCt6vV1s
         U5Z9yaNFbsV/M8DJ4H9SBMzWeZa7hnFOKuD1bPzFQWgyeBxgdBjDSAu1puJzJxMTrviR
         UPclpEcCuNzDEOHlf07kPfAMY2kJ4/QXStzy4wmNMAZzMrgDeU2C838PceHVG6WGh6UT
         3XTwonaXq5QW6wUSAwp45Ep+/RhGzQNMahF8pom0uZlB2OIjAlnkSH2kjec14hCtJ8Kr
         JCMkEFyDZA4Ayuaj/LwnOjoVLdjeEGl8iSA18vjhJfkqGYDEYarFrEB5nWktekFubLaR
         z06w==
X-Gm-Message-State: APjAAAWfx6WiIv8Vg/1amuxdViblVIu95vAErr8/IX1aQGeM9pl/ZbTS
        yUuc8R+NROyuSPsyb+ULHzfwV8+A9V8=
X-Google-Smtp-Source: APXvYqx1Pa9ksf2yocjZ5prvWvzHHt8iT4uAj9j9v6CWWfJOVbdKKJ23sDKS2/DJqUA90U1LotU1sg==
X-Received: by 2002:a65:6081:: with SMTP id t1mr43762799pgu.9.1563392807319;
        Wed, 17 Jul 2019 12:46:47 -0700 (PDT)
Received: from localhost.localdomain (76-14-106-55.rk.wavecable.com. [76.14.106.55])
        by smtp.gmail.com with ESMTPSA id u7sm22007305pgr.94.2019.07.17.12.46.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 12:46:46 -0700 (PDT)
From:   Rosen Penev <rosenp@gmail.com>
To:     netdev@vger.kernel.org
Subject: [PATCHv2] net: ag71xx: Add missing header
Date:   Wed, 17 Jul 2019 12:46:45 -0700
Message-Id: <20190717194645.24239-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ag71xx uses devm_ioremap_nocache. This fixes usage of an implicit function

Fixes: d51b6ce441d356369387d20bc1de5f2edb0ab71e

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: Target net instead of net-next
 drivers/net/ethernet/atheros/ag71xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 72a57c6cd254..8f450a03a885 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -35,6 +35,7 @@
 #include <linux/regmap.h>
 #include <linux/reset.h>
 #include <linux/clk.h>
+#include <linux/io.h>
 
 /* For our NAPI weight bigger does *NOT* mean better - it means more
  * D-cache misses and lots more wasted cycles than we'll ever
-- 
2.17.1

