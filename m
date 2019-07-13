Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB2267799
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 04:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727513AbfGMCJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 22:09:24 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:41706 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbfGMCJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 22:09:24 -0400
Received: by mail-pf1-f175.google.com with SMTP id m30so5074688pff.8
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 19:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=B2mOTfPDfthdfd9+Z/iton6RlD547BCOzLupGX7jepE=;
        b=Pzt+juCYUzAFcAil2w7OiW4ZBJuYgXiBltLsLj0r+ADIJCg+l3s1L09E7B2gvN+upB
         CCMFm8SRCrfGY8V+GjPHdb01SJqeV4pfCXoxEssykQhFtpvd8jsiiK+tt6lv/EbwJe1V
         LpMtvd/feNlH/OfA2wW6fFceaQjNmt1uOX8ukRRyra54VfNxqWfWuMZKqCGossUo0dq4
         9FAifCaf25dq+90GsDm0vs1zPi+UgPS+tTUQ4ndFaXsPmoVHvNl1kb///YF5kQ23Vpie
         Wg8DoGY4cI+QKuGK6lu0d7ZlCy60xTIsIYJO1xwpBu1gC9j8WvJa9jmFgjIqvJbHC9gF
         EZgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=B2mOTfPDfthdfd9+Z/iton6RlD547BCOzLupGX7jepE=;
        b=PdQiBmV0gE1gZ0/T5TPLHp1OGwjC/IxPckinebGFTq6V3Gb/a2iHNi8VlRFWYp9ELY
         jDsmPeCi2dQk4i0YK1PyrDGBLTdt6PkSe184hRvSWv4qonfXY/25cnRhpXMkwU5vd5a5
         LtfAqE0rQ1kLdjEYUWxmBgfzM1AaQVwlDZ2Na6Hf0+gqmOU2Of8ld8E/jTbmCmT/yN3d
         K/qZkMtLGBs2cogUBm94IQzCJ1x2xjW1AIlPXVTBgDZitoaam+E2XZVDMTigoQnAWMzY
         oultyUJzuJCNjsya/KmsLHsQMWhhv9xtWL3yCiqUE4mXpx8rpjD+unvVsAUAY86K02M/
         0luw==
X-Gm-Message-State: APjAAAW+b8ZtoGhwIEdLHmAmG7ET1dvdQ1J0VEiFYsrZ5CWpibXVVEeB
        v9+YAuR1z25viPul/pZxlrkAplsysFg=
X-Google-Smtp-Source: APXvYqwfZDxtwzQfhnbelTL+oxKbLOsws7glFc4r/gcm2SX4HXDjyOneKOa6rsQu2DwiccTvXVvIpA==
X-Received: by 2002:a63:2323:: with SMTP id j35mr14505063pgj.166.1562983762912;
        Fri, 12 Jul 2019 19:09:22 -0700 (PDT)
Received: from localhost.localdomain (76-14-106-55.rk.wavecable.com. [76.14.106.55])
        by smtp.gmail.com with ESMTPSA id x24sm669860pgl.84.2019.07.12.19.09.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 12 Jul 2019 19:09:22 -0700 (PDT)
From:   Rosen Penev <rosenp@gmail.com>
To:     netdev@vger.kernel.org
Subject: [PATCH 1/2] net-next: ag71xx: Add missing header
Date:   Fri, 12 Jul 2019 19:09:20 -0700
Message-Id: <20190713020921.18202-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ag71xx uses devm_ioremap_nocache. This fixes usage of an implicit function

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
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

