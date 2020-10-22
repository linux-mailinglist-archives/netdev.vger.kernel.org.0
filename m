Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5DE295CB6
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 12:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896555AbgJVKaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 06:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896507AbgJVK37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 06:29:59 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D55C0613CE;
        Thu, 22 Oct 2020 03:29:59 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id lw21so1517980ejb.6;
        Thu, 22 Oct 2020 03:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=mLOjMToPC+vq/ytA+HcNqKbb7CD2IltbM/VtiBMs1Fc=;
        b=giz0AX7mIjr7TbH44zxZQ/0Kkny+UXCGN66/+fg2Y9vfm1/7cmAD6FM3kTlmK8dEvi
         CdrbTprEk7bCSW44RNXCzfeLVSuvR7OxCORJOh0h6wSEPM9ocxOObWb06mcffSYtjI5I
         bU7+Oo+Dtu03Wvo58483sXKZSEMcyF3RDgyc4N8tP3Uqq4o1YvrDpt4Ek/qxJ8FQpJzu
         l23UAUiAvff6lScHli2PZ75LU1csgjevLXLJHTAeUQQ8r0IokDQMh31kr9SC9kpRRlRy
         1LmR2io/e2exzUYcC3zTFdddcUVcrW1/RLA/qzqsG1kJeBR4/pSGqMeFWDoPXAQvaJw5
         p2JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=mLOjMToPC+vq/ytA+HcNqKbb7CD2IltbM/VtiBMs1Fc=;
        b=CRUmNsiMVZi902ieZeAopxTtO38ltQe2YEiuvJivGY/6ciMavHgcqcXkinzDipmuaT
         NSmn/NiWMhUb8KRT6jt+AhIYHTWkb/sUOndqah4YKgQZA0Gg+mYSP2EC+BHSOiHLdHAH
         zOGZhl70reNkmcAXpHtdZpfMwakW4hwt4YZsCyrHZ9hIhdvZME6dZN3u+Z9k9AsyzUVH
         btTFEof6qbT9J8yOUkGbjYfjefjB15pOz5lfYb+Mn13G4NIOyguB8SD7rxHoIrJgUAtW
         dYZB+pDfFZww7WuHsLgVmEB/9eB3A+f9drQeZjJxS2Ng7WsEXOh+C63CuIi19+z19vv/
         G+ZQ==
X-Gm-Message-State: AOAM532q2/KtRx3V22J14ftiZWlYfSf9e6aYL/5Y0Vb8MrYOUXZgOqDH
        cUaPW3QHVY4vmPenj5IPiwV9oqfMvlA=
X-Google-Smtp-Source: ABdhPJzVp1T6BPqlMXIztxQdag6GratV9kD9wv4rfPcsiCLem2S0E9zJ/bunFoC9hn7Z5yPyMkcuWg==
X-Received: by 2002:a17:906:3ed0:: with SMTP id d16mr1601085ejj.477.1603362597880;
        Thu, 22 Oct 2020 03:29:57 -0700 (PDT)
Received: from development1.visionsystems.de (mail.visionsystems.de. [213.209.99.202])
        by smtp.gmail.com with ESMTPSA id u23sm594751ejy.87.2020.10.22.03.29.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Oct 2020 03:29:57 -0700 (PDT)
From:   yegorslists@googlemail.com
To:     linux-can@vger.kernel.org
Cc:     mkl@pengutronix.de, netdev@vger.kernel.org,
        Yegor Yefremov <yegorslists@googlemail.com>
Subject: [PATCH] can: j1939: convert PGN structure to a table
Date:   Thu, 22 Oct 2020 12:29:46 +0200
Message-Id: <20201022102946.18916-1-yegorslists@googlemail.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

Use table markup to show the PGN structure.

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 Documentation/networking/j1939.rst | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/j1939.rst b/Documentation/networking/j1939.rst
index faf2eb5c5052..f3fb9d880910 100644
--- a/Documentation/networking/j1939.rst
+++ b/Documentation/networking/j1939.rst
@@ -71,10 +71,14 @@ PGN
 
 The PGN (Parameter Group Number) is a number to identify a packet. The PGN
 is composed as follows:
-1 bit  : Reserved Bit
-1 bit  : Data Page
-8 bits : PF (PDU Format)
-8 bits : PS (PDU Specific)
+
+  ============  ==============  ===============  =================
+  PGN
+  ----------------------------------------------------------------
+  25            24              23 ... 16        15 ... 8
+  ============  ==============  ===============  =================
+  R (Reserved)  DP (Data Page)  PF (PDU Format)  PS (PDU Specific)
+  ============  ==============  ===============  =================
 
 In J1939-21 distinction is made between PDU1 format (where PF < 240) and PDU2
 format (where PF >= 240). Furthermore, when using the PDU2 format, the PS-field
-- 
2.17.0

