Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9AAA6E4C6
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 13:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfGSLKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 07:10:54 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43602 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727486AbfGSLKy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 07:10:54 -0400
Received: by mail-pl1-f195.google.com with SMTP id 4so8501691pld.10
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 04:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=pwS7P5TIt/JsDPbn/Wqhn2NHhUPFmyaKIcnCGFzzlHg=;
        b=Y9XnuhEHCwqrD+VnqN/I5dNL/nd27wLnf9HxZqu7Yg2OM1ueZeS0/g2KRiBLPiV5Vh
         4hUu/+Ylr0yt14FXLo5Gnu89VyujtGPnuS2GUYGP+RvCaSbVGqbmoMF46xJdSqWg65kR
         lUxhZhGb5kyGVIdh5UtVFHCKFDcb6DOXGmGDMcarVX71y4MR1lM5CHPX7vMzCvC/h1/X
         vhIlL78rYc9lkY30caXgi3S90FSEKQ+NViFOe/5mpqr67xd80u7OIRJZk84D9M858TKX
         bXCkzHwtY1xHxPOZhooFOOddV2kD+CxEPXtdsmidWv4IhJjIPUOvE99NM3ob8e3sLHxf
         FucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pwS7P5TIt/JsDPbn/Wqhn2NHhUPFmyaKIcnCGFzzlHg=;
        b=bFuYeWRlGXBnGTxslKmY9Ny/iLz4Xwu2SPbiQW901GY0kRYguBZrjh+LCrUAvYKSSt
         oS8pR0VY45G3+hg6PZFDaBPwUjBOaLNXNOgaAdnSD/M2ZkYiBUOA8Ecg8chd9w6IXZ/Z
         Shl5qnlCwpQ3q0HZN5TRk920NIuAspGgdWRT4s18WNsUp9l5AE9utPqfgj6cwUiygO9Y
         7SNChp8q5cFZiXd34Sg+W3rJmZeu84frYuI1iQj+B4rjJelnNFXgl9RNQ+8LFJwwNOT9
         2MZtUi9UnOs9pLoBUym6+EpoYSsUcNtfUk69QFFezKZC+m/WjNFPf3SBAHxu/+W9S2Ve
         8fTA==
X-Gm-Message-State: APjAAAWlsaPqZv0GH0NgLo/eV4yHBSTmn4qY0QafQRWwyT599wrUWje1
        QcFPVx8viKzQcyjcKTTw1tx2JQ==
X-Google-Smtp-Source: APXvYqyEfzz9Y8lJVBzXseZAguoF4LfnLNuKFVbuRz6dNbLVuhE/7V+E74719q73vO5yqLfAW8EZSQ==
X-Received: by 2002:a17:902:9f8e:: with SMTP id g14mr10404199plq.67.1563534653921;
        Fri, 19 Jul 2019 04:10:53 -0700 (PDT)
Received: from buildserver-90.open-silicon.com ([114.143.65.226])
        by smtp.googlemail.com with ESMTPSA id i9sm10196872pgg.38.2019.07.19.04.10.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 19 Jul 2019 04:10:53 -0700 (PDT)
From:   Yash Shah <yash.shah@sifive.com>
To:     davem@davemloft.net, robh+dt@kernel.org, paul.walmsley@sifive.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Cc:     mark.rutland@arm.com, palmer@sifive.com, aou@eecs.berkeley.edu,
        nicolas.ferre@microchip.com, ynezz@true.cz,
        sachin.ghadi@sifive.com, Yash Shah <yash.shah@sifive.com>
Subject: [PATCH 1/3] macb: bindings doc: update sifive fu540-c000 binding
Date:   Fri, 19 Jul 2019 16:40:29 +0530
Message-Id: <1563534631-15897-1-git-send-email-yash.shah@sifive.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As per the discussion with Nicolas Ferre, rename the compatible property
to a more appropriate and specific string.
LINK: https://lkml.org/lkml/2019/7/17/200

Signed-off-by: Yash Shah <yash.shah@sifive.com>
---
 Documentation/devicetree/bindings/net/macb.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 63c73fa..0b61a90 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -15,10 +15,10 @@ Required properties:
   Use "atmel,sama5d4-gem" for the GEM IP (10/100) available on Atmel sama5d4 SoCs.
   Use "cdns,zynq-gem" Xilinx Zynq-7xxx SoC.
   Use "cdns,zynqmp-gem" for Zynq Ultrascale+ MPSoC.
-  Use "sifive,fu540-macb" for SiFive FU540-C000 SoC.
+  Use "sifive,fu540-c000-gem" for SiFive FU540-C000 SoC.
   Or the generic form: "cdns,emac".
 - reg: Address and length of the register set for the device
-	For "sifive,fu540-macb", second range is required to specify the
+	For "sifive,fu540-c000-gem", second range is required to specify the
 	address and length of the registers for GEMGXL Management block.
 - interrupts: Should contain macb interrupt
 - phy-mode: See ethernet.txt file in the same directory.
-- 
1.9.1

