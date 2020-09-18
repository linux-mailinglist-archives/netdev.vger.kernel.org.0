Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490F12703C6
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgIRSLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbgIRSLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 14:11:25 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A846C0613CE;
        Fri, 18 Sep 2020 11:11:24 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k15so6514661wrn.10;
        Fri, 18 Sep 2020 11:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+ALrwdNETU2MxK86SGthSKgE8MUMcPyrI0lP0CVqjQI=;
        b=C5sqb2yxcvsNocPhY2Lt3IwIlIROvFB5l5wNHYnGsMCGx9n+mMxLjFgVBddP5hBPCT
         yY3ecasFwG1FymqjnUMeSkZ/bEtd5QDDKud901OlHdDIdUhaPQHonwK7ECAeCD39iGzo
         1ceBzNiaEq5YGLyRWnZ73Sycp6czdV7kbXa4acm1kpyvzNrzxkb9lDCiaW+tqRYxLugN
         WOxtIBRfR9PMygYkUZObTRnxLppsgc3A01wLrB2gKfcjPhbogE+ebXlgJy9hAmL9dswg
         WdZojnwDp94191WZEhe8+W5lPfw5iN/HT4g+o81iXlgjUdMAWKFwB689QEIYiagiFbxj
         mF/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ALrwdNETU2MxK86SGthSKgE8MUMcPyrI0lP0CVqjQI=;
        b=oNuPlL+A/HvRAnqA89UKXAYEP1sRMr8lwbZmKlI4hePHNxAp/KjhrGeWJU3G5ZysZ3
         3vSxaVgAPoS1lGAtseZt9dVXKqHVzZTonhRabpk41pf2NqgNIVT2mpeSduZQxM3ZHSMh
         u7P+mEFDGitm+celQYbnP4odY+hRz59f/0rWSXAvaubzMJxUyhmg7+roB9S37E/rXfQc
         uQqGmlLWbBL1xOn9JoYUhBZVnrbpxPujuhbCTENs8EBu0WrpqVgLFA8ioxizaN/ECPUK
         0pR/kNdvSJ1io/Cf4xGB908pZhy0g8ARXGdkoONRRpSG5lkd+4jwdtLIy2rS1wvoztWU
         2GrQ==
X-Gm-Message-State: AOAM533II/SL+qLDPUmcfcGGqaW25nxYYtDs4rNkQczWmtGKnKOjLrFc
        iN6R9qhdzwPBO2lvD0+b6dA=
X-Google-Smtp-Source: ABdhPJwDlGeI6/TcQ1Yi8Z/1litjaMhehBdyMUqomeNKRCP/fWUFevqhp2m/vY3A2LUYX6AyOu/7xw==
X-Received: by 2002:a5d:5261:: with SMTP id l1mr38534694wrc.193.1600452682915;
        Fri, 18 Sep 2020 11:11:22 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (host-95-248-206-89.retail.telecomitalia.it. [95.248.206.89])
        by smtp.googlemail.com with ESMTPSA id f23sm21461466wmc.3.2020.09.18.11.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 11:11:21 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: [PATCH v2 2/2] dt: bindings: ath10k: Document qcom,ath10k-pre-calibration-data-mtd
Date:   Fri, 18 Sep 2020 20:11:03 +0200
Message-Id: <20200918181104.98-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200918181104.98-1-ansuelsmth@gmail.com>
References: <20200918181104.98-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document use of qcom,ath10k-pre-calibration-data-mtd bindings used to
define from where the driver will load the pre-cal data in the defined
mtd partition.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 .../devicetree/bindings/net/wireless/qcom,ath10k.txt | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index b61c2d5a0..568364243 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -15,9 +15,9 @@ and also uses most of the properties defined in this doc (except
 "qcom,ath10k-calibration-data"). It uses "qcom,ath10k-pre-calibration-data"
 to carry pre calibration data.
 
-In general, entry "qcom,ath10k-pre-calibration-data" and
-"qcom,ath10k-calibration-data" conflict with each other and only one
-can be provided per device.
+In general, entry "qcom,ath10k-pre-calibration-data",
+"qcom,ath10k-calibration-data-mtd" and "qcom,ath10k-calibration-data" conflict with
+each other and only one can be provided per device.
 
 SNOC based devices (i.e. wcn3990) uses compatible string "qcom,wcn3990-wifi".
 
@@ -63,6 +63,12 @@ Optional properties:
 				 hw versions.
 - qcom,ath10k-pre-calibration-data : pre calibration data as an array,
 				     the length can vary between hw versions.
+- qcom,ath10k-pre-calibration-data-mtd :
+	Usage: optional
+	Value type: <phandle offset size>
+	Definition: pre calibration data read from mtd partition. Take 3 value, the
+		    mtd to read data from, the offset in the mtd partition and the
+		    size of data to read.
 - <supply-name>-supply: handle to the regulator device tree node
 			   optional "supply-name" are "vdd-0.8-cx-mx",
 			   "vdd-1.8-xo", "vdd-1.3-rfa", "vdd-3.3-ch0",
-- 
2.27.0

