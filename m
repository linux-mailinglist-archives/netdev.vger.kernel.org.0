Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDC948A380
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 00:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345687AbiAJXQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 18:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345681AbiAJXQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 18:16:06 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22675C061756
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 15:16:06 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id c3so14412439pls.5
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 15:16:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3m+MSLx1aWfmG9c9/zNheqVQNvN/1RiPSkKxDhXhUc8=;
        b=FAMQ5bXG1ZfRIjz22ZXOpXwVILq33lkpwxmtzGpBLjXF7+qgVHuUiHA0IqeOkC8bnf
         6mYOLEIUEemetr3Z3413MXhVtacNv8CjstL7k17KalyIrrEcMiYBqquu+0XESpYWrlyB
         bA36yrEmUwWyB0vAkd5sj8ujgXq2UelOE8jr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3m+MSLx1aWfmG9c9/zNheqVQNvN/1RiPSkKxDhXhUc8=;
        b=RePy2wzsg+EiL8wfp1T+YltfRhp2s7NpyDZqppO7K/s7MlHvtNG/JbbTWD8j3XUXOP
         8WEQKM//sZ+hMzT4aFxg9ol/SsCr42xYkvVcta1fROeqGzzaDAR/+8EUMCLR+4uvPBOJ
         4waQbF9TrlQKSJESHNIRR2m3u416mieFzL/4pZnxPKClGx9cjRpfbIDD722UB1ZUx9ZP
         1pKZ/bh3ljueHMVOBIhbR5kQmZLlfeaEqlX0YfmvDNZEef8IW+JDqQzNli9bVuoTYel5
         KOkYVJFFQz3yqZrv1JhDtje+Bzq27cSuYxbAre2f6GHScVoDBi+wAKRR+g2dlEWElDnY
         pbFA==
X-Gm-Message-State: AOAM531McwsexC6BpOSCFTqCMqSD4vQhqA8X33DbSbP/k13QikMRtn2s
        PJf6WVf16MH6cpW7RVbEPG+fuw==
X-Google-Smtp-Source: ABdhPJz6e6Ax9KoaHUu4OKn9vuzroT/JFuIVuYRtgwypH2Qm2t3A+TB6jFw/sR4u3TNPzw9d5v2lIg==
X-Received: by 2002:a17:902:bd05:b0:148:a2f7:9d87 with SMTP id p5-20020a170902bd0500b00148a2f79d87mr1720722pls.166.1641856565660;
        Mon, 10 Jan 2022 15:16:05 -0800 (PST)
Received: from kuabhs-cdev.c.googlers.com.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id z12sm6123924pga.28.2022.01.10.15.16.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 15:16:05 -0800 (PST)
From:   Abhishek Kumar <kuabhs@chromium.org>
To:     kvalo@codeaurora.org, ath10k@lists.infradead.org
Cc:     pillair@codeaurora.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuabhs@chromium.org,
        dianders@chromium.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 2/2] dt: bindings: add dt entry for ath10k default BDF name
Date:   Mon, 10 Jan 2022 23:14:15 +0000
Message-Id: <20220110231255.v2.2.Ia0365467994f8f9085c86b5674b57ff507c669f8@changeid>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
In-Reply-To: <20220110231255.v2.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
References: <20220110231255.v2.1.Ie4dcc45b0bf365077303c596891d460d716bb4c5@changeid>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is possible that BDF name with board-id+chip-id+variant
combination is not found in the board-2.bin. Such cases can
cause wlan probe to fail and completely break wifi. In such
case there can be an optional property to define a default
BDF name to search for in the board-2.bin file when none of
the combinations (board-id,chip-id,variant) match.
To address the above concern provide an optional proptery:
qcom,ath10k-default-bdf

Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
---

Changes in v2:
 - Changes in v2: none

 .../devicetree/bindings/net/wireless/qcom,ath10k.txt          | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
index b61c2d5a0ff7..d76d1392863d 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
@@ -63,6 +63,10 @@ Optional properties:
 				 hw versions.
 - qcom,ath10k-pre-calibration-data : pre calibration data as an array,
 				     the length can vary between hw versions.
+- qcom,ath10k-default-bdf : default board data file name to be searched in
+			    board-2.bin. This is searched if no BDF is found
+			    in board-2.bin that matches, chip-id, board-id and
+			    variant combination
 - <supply-name>-supply: handle to the regulator device tree node
 			   optional "supply-name" are "vdd-0.8-cx-mx",
 			   "vdd-1.8-xo", "vdd-1.3-rfa", "vdd-3.3-ch0",
-- 
2.34.1.575.g55b058a8bb-goog

