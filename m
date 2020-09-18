Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2967270226
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgIRQ3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgIRQ3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:29:39 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2B7C0613CE;
        Fri, 18 Sep 2020 09:29:38 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id x23so5889499wmi.3;
        Fri, 18 Sep 2020 09:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+ALrwdNETU2MxK86SGthSKgE8MUMcPyrI0lP0CVqjQI=;
        b=Il95zl7ds9a5Wa/+A3ecWvYzrSZ+BLTqfj6ec6fYPbvqhhdmJVYxEZzqRc9s9v/yP2
         4m4R4HC+r9fa7HBll/1tev5GP4Bjq/AaAPYaGzfbpTCEF7ibb/gsMgFbIbQ/WBJcC5ee
         woI+46IAtNgGvB/Nj6BfLGomZmU5ngVz+pqPO02a1iVbRydvRydQqCj7Jby1G6R3yCb1
         /WScm3GI19p5i0BhBzU7+4GN6PDp9B8Rm1iEcS6qckXfU6hf621shoGLV2zYv/gfIqS9
         w3YMCAa/ZdDbPiPz957p3OFF83IzcNHRrAWKezqElxGFg5UDXiYgO3LlVaZ7iudwLXkO
         MfvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ALrwdNETU2MxK86SGthSKgE8MUMcPyrI0lP0CVqjQI=;
        b=XbxGB2ilTCyB3uYiEGJLXI4UoavwEA7TvQMlfWhdXqw4/HPJY6YVPHFkgufJJzGqWl
         2RX8PcHLWVqz4sG+jDUnjO/MCkWIInCbVyt0jXDiu/Fe3EarHpp89QRECdjshpMcTyJ7
         5UTdgdFZtAhTjFlewRVNKQyibarpa1OamiGXZpCMuSoTAOXFvr2JkUWCWSnIxQ5VK5zw
         dJcO82a8RIoAGEQHP56jldXyI7INXZ1y5Q7ESIZLOX1IH86b+pTKPRWLLeefz8Ec9nBK
         caFgMDwdCixiVGZMSPBH8uj+Qhax2D2RRkqe9beNFQjWjgiGDxLzfd6iZFTrum6j2s2l
         I0lA==
X-Gm-Message-State: AOAM530AVTw5fcErBJ7pXzJHyFeUzr/3AZt8EGtCx4W+LkgTeKfW7oDW
        dRvXc/vhZl9qqdGnpHJ3fiY=
X-Google-Smtp-Source: ABdhPJwhMLFx/NFsWruwmp6xyVAv5jlnAK8e/0Ui5smBeskjIRpqc6rufsaW1nM9w8xzSUglIbmcnQ==
X-Received: by 2002:a7b:cc8f:: with SMTP id p15mr16559476wma.18.1600446577309;
        Fri, 18 Sep 2020 09:29:37 -0700 (PDT)
Received: from Ansuel-XPS.localdomain (93-39-149-95.ip76.fastwebnet.it. [93.39.149.95])
        by smtp.googlemail.com with ESMTPSA id b11sm6028921wrt.38.2020.09.18.09.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 09:29:36 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: [PATCH 2/2] dt: bindings: ath10k: Document qcom,ath10k-pre-calibration-data-mtd
Date:   Fri, 18 Sep 2020 18:29:28 +0200
Message-Id: <20200918162928.14335-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200918162928.14335-1-ansuelsmth@gmail.com>
References: <20200918162928.14335-1-ansuelsmth@gmail.com>
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

