Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A54E27941F
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 00:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgIYWZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 18:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729041AbgIYWZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 18:25:05 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD99C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:05 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id k13so4617621pfg.1
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 15:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SRHUH+MM14I75V+EtuOr2IaNZ18HdvV2Ili51ytpF50=;
        b=D2i2bzaHjU+/Pr0XlsdpcjwUPbJHta5hEMoejJ/2WrT1uKcLjDqiYNV9mcUo/t0VTh
         2A6SsT1cw8IilKidmlOwqPr3IyNt7aNMRhB9UtepbYzmGyz5JqSaFLgmPdd0XQsPQy55
         a/qivhHEGOS+o9zfe18wHBZtacvGOraZTI198PypGbEvXwYuAnaU0fvLhaw2Gl92weYM
         39+JO+aptW7303/DJ5VKppxM52E77eugmeQy7rIWkz5v2L4CCm5kQ6OBP2rm3oYp6lnt
         noJ8bb4fRAHBMvBwnH67jw+YszzujAWLty3regvrXCuVZsmi8lvqxX5q6Jv7yBula79b
         rG2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SRHUH+MM14I75V+EtuOr2IaNZ18HdvV2Ili51ytpF50=;
        b=SOzXI64pp7HN7OYCyTBPKwhNd9I9iyjbq8H1iwhaqDwT8Zo0m1wAJuCSrz2B1jlR/o
         AxAl8Pe5hCGNdEM1MFhTRp1MCkKm9QNUw8exBazpWy3/hhtPypGZadOu74RnBfCxWsOr
         8B6ATH3WRDQ9F9I+5SEpWTeS/HT3XvbCI43Nsp4pC6nXrXP5tirgN0nqHE6rgPAR37o4
         Kfu01Do4LeyEMeLAcFS+uSwLJAgLcabJRvivq8wYu4SC5PcYePzNcLvx8Y4dopNq5gJS
         smFqiIH6Z3liqT93pFmsf2nzgr2SD4NYQdhrGSvf1O9lTObVK59TDnHcY3SdoAVkrYfd
         R07A==
X-Gm-Message-State: AOAM533IZrlDTB6Awkpa4eXQHuRh/Q7+iB4+zbDGRcjV1yqAFJJZqWl9
        xOVJAElqTupQB3xLWzIpQxGRxQPaGgNAUYr+
X-Google-Smtp-Source: ABdhPJzimmCjkzqBt/jsebPZuDo4ogl+V/gxLVSPJr6MeRN1cxI4h2dwo7BvQwd3czP7OlP9dAZ+Rg==
X-Received: by 2002:a62:2b52:0:b029:142:2501:39e9 with SMTP id r79-20020a622b520000b0290142250139e9mr639784pfr.56.1601072705010;
        Fri, 25 Sep 2020 15:25:05 -0700 (PDT)
Received: from jesse-ThinkPad-T570.lan (50-39-107-76.bvtn.or.frontiernet.net. [50.39.107.76])
        by smtp.gmail.com with ESMTPSA id q15sm169343pje.29.2020.09.25.15.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 15:25:04 -0700 (PDT)
From:   Jesse Brandeburg <jesse.brandeburg@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@gmail.com>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH net-next v3 6/9] drivers/net/ethernet: add some basic kdoc tags
Date:   Fri, 25 Sep 2020 15:24:42 -0700
Message-Id: <20200925222445.74531-7-jesse.brandeburg@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
References: <20200925222445.74531-1-jesse.brandeburg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

A couple of drivers had a "generic documentation" section that
would trigger a "can't understand" message from W=1 compiles.

Fix by using correct DOC: tags in the generic sections.

Fixed Warnings:
drivers/net/ethernet/arc/emac_arc.c:4: info: Scanning doc for c
drivers/net/ethernet/cadence/macb_pci.c:3: warning: missing initial short description on line:
 * Cadence GEM PCI wrapper.
drivers/net/ethernet/cadence/macb_pci.c:3: info: Scanning doc for Cadence

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
v3: add some warning detail
v2: first non-rfc version
---
 drivers/net/ethernet/arc/emac_arc.c     | 2 +-
 drivers/net/ethernet/cadence/macb_pci.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/arc/emac_arc.c b/drivers/net/ethernet/arc/emac_arc.c
index 1c7736b7eaf7..800620b8f10d 100644
--- a/drivers/net/ethernet/arc/emac_arc.c
+++ b/drivers/net/ethernet/arc/emac_arc.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /**
- * emac_arc.c - ARC EMAC specific glue layer
+ * DOC: emac_arc.c - ARC EMAC specific glue layer
  *
  * Copyright (C) 2014 Romain Perier
  *
diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index cd7d0332cba3..35316c91f523 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /**
- * Cadence GEM PCI wrapper.
+ * DOC: Cadence GEM PCI wrapper.
  *
  * Copyright (C) 2016 Cadence Design Systems - https://www.cadence.com
  *
-- 
2.25.4

