Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A0C2024E1
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 17:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgFTPoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 11:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727855AbgFTPoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 11:44:07 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF10C0613EF
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:07 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id k8so10140552edq.4
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 08:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SMvhU6wvK0JvvaWHNp0IKihXkHeaeRg/yD+tPhqv2fs=;
        b=HOHf0rEuSePtm6AUWrb1keoUnnxNFo+FnEGkSKMEaXdjo+2W47q+BdIyfmx4yE4nch
         K2PgxJpmlpEnZ8Wc1JXkJ37Oeeuy+GRxtLTHb4SXlI4ji9JicORCouuR2v70Ltj1ykh+
         xMZVrZOuQgf3NVjNtirJSqjQs+5KAdbkz8NFwDQVEJq+oxqHZLQnmglXf2XhaylrOvom
         yAVbc4D16ojczww/BWbWkhOfP8GJ4W1qcWKNkct7/Npq7R/vNEG360hpKzPCUduLJlj8
         T7D24z489Sct5kssgRvXGl4TDvL4YgGbgog0PRgeN9az6OtksDDcu5GM6c4UXpXNOV6F
         G9JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SMvhU6wvK0JvvaWHNp0IKihXkHeaeRg/yD+tPhqv2fs=;
        b=XmBtzxK5+kqNX9yh+VQPLO8p7jvmmF4FsztonDLnmeAEWyiSSYWN8ru9ms93Z9H+tM
         7OWXM6igZQzuo1uDM1w0Y9DjUMQCRM56HyUcCTonlFfMCGTuktDquV4mYzaZcSjmJ0ru
         Iah100m7z40/OXhfbYLhc8EAmIesZbEOuU9MjUbppECTLLRWFDbmdoSzISTIKwXdwZqe
         AZm7xNPihVkJvwq4jiLwCq9yKUL1JZ+IVZHAsG6brOH4frBSTZM4AAQSf2v2o0eqTF1v
         NEUM3ImdIzQCQ5ZDAaM992QisZCRBYsiJe3gqAkdarN8sP4cpDz62zRW0G1xQYhwlrmQ
         07qQ==
X-Gm-Message-State: AOAM531V81Sq1VyZM6WCtZnOxHnj6qcXGHnWkqr5f8rBeBkxE8U2DKyD
        4oIvthctoTnmIuFrgTsYkvE=
X-Google-Smtp-Source: ABdhPJxHdaiRAB5mT1sxjI0OcKyAWeHIqMX8DsIBCuoKc+ADosdej2s0axV5GdBbTDTFf6FYlTuurg==
X-Received: by 2002:a05:6402:1217:: with SMTP id c23mr8562025edw.270.1592667845992;
        Sat, 20 Jun 2020 08:44:05 -0700 (PDT)
Received: from localhost.localdomain ([188.26.56.128])
        by smtp.gmail.com with ESMTPSA id n25sm7721222edo.56.2020.06.20.08.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 08:44:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com
Subject: [PATCH net-next 10/12] net: mscc: ocelot: rename ocelot_ace.{c,h} to ocelot_vcap.{c,h}
Date:   Sat, 20 Jun 2020 18:43:45 +0300
Message-Id: <20200620154347.3587114-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200620154347.3587114-1-olteanv@gmail.com>
References: <20200620154347.3587114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Access Control Lists (and their respective Access Control Entries) are
specifically entries in the VCAP IS2, the security enforcement block,
according to the documentation.

Let's rename the files that deal with generic operations on the VCAP
TCAM, so that VCAP IS1 and ES0 can reuse the same code without
confusion.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/Makefile                        | 2 +-
 drivers/net/ethernet/mscc/ocelot.c                        | 2 +-
 drivers/net/ethernet/mscc/ocelot_flower.c                 | 2 +-
 drivers/net/ethernet/mscc/ocelot_net.c                    | 2 +-
 drivers/net/ethernet/mscc/{ocelot_ace.c => ocelot_vcap.c} | 2 +-
 drivers/net/ethernet/mscc/{ocelot_ace.h => ocelot_vcap.h} | 0
 6 files changed, 5 insertions(+), 5 deletions(-)
 rename drivers/net/ethernet/mscc/{ocelot_ace.c => ocelot_vcap.c} (99%)
 rename drivers/net/ethernet/mscc/{ocelot_ace.h => ocelot_vcap.h} (100%)

diff --git a/drivers/net/ethernet/mscc/Makefile b/drivers/net/ethernet/mscc/Makefile
index 7ab3bc25ed27..58f94c3d80f9 100644
--- a/drivers/net/ethernet/mscc/Makefile
+++ b/drivers/net/ethernet/mscc/Makefile
@@ -4,7 +4,7 @@ mscc_ocelot_switch_lib-y := \
 	ocelot.o \
 	ocelot_io.o \
 	ocelot_police.o \
-	ocelot_ace.o \
+	ocelot_vcap.o \
 	ocelot_flower.o \
 	ocelot_ptp.o
 obj-$(CONFIG_MSCC_OCELOT_SWITCH) += mscc_ocelot.o
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 5c2b5a2e8608..d4ad7ffe6f6e 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -6,7 +6,7 @@
  */
 #include <linux/if_bridge.h>
 #include "ocelot.h"
-#include "ocelot_ace.h"
+#include "ocelot_vcap.h"
 
 #define TABLE_UPDATE_SLEEP_US 10
 #define TABLE_UPDATE_TIMEOUT_US 100000
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index ad4e8e0d62a4..d57d6948ebf2 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -6,7 +6,7 @@
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_gact.h>
 
-#include "ocelot_ace.h"
+#include "ocelot_vcap.h"
 
 static int ocelot_flower_parse_action(struct flow_cls_offload *f,
 				      struct ocelot_ace_rule *ace)
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 1ce444dff983..80cb1873e9d9 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -6,7 +6,7 @@
 
 #include <linux/if_bridge.h>
 #include "ocelot.h"
-#include "ocelot_ace.h"
+#include "ocelot_vcap.h"
 
 int ocelot_setup_tc_cls_flower(struct ocelot_port_private *priv,
 			       struct flow_cls_offload *f,
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
similarity index 99%
rename from drivers/net/ethernet/mscc/ocelot_ace.c
rename to drivers/net/ethernet/mscc/ocelot_vcap.c
index dbfb2666e211..33b5b015e8a7 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -8,7 +8,7 @@
 
 #include <soc/mscc/ocelot_vcap.h>
 #include "ocelot_police.h"
-#include "ocelot_ace.h"
+#include "ocelot_vcap.h"
 #include "ocelot_s2.h"
 
 #define OCELOT_POLICER_DISCARD 0x17f
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
similarity index 100%
rename from drivers/net/ethernet/mscc/ocelot_ace.h
rename to drivers/net/ethernet/mscc/ocelot_vcap.h
-- 
2.25.1

