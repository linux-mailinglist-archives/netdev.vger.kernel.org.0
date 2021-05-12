Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 829D037C07E
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231332AbhELOoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:44:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60075 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbhELOop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 10:44:45 -0400
Received: from mail-vs1-f69.google.com ([209.85.217.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lgq5I-00057h-AI
        for netdev@vger.kernel.org; Wed, 12 May 2021 14:43:36 +0000
Received: by mail-vs1-f69.google.com with SMTP id e12-20020a67d80c0000b029022a88436f30so6325652vsj.11
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:43:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aHEFEHQf81OxnlkSXxvYbUIWj0W6Yj6Lp4ml2UG7+00=;
        b=itiC5pH1oxZxHjD642BvFBJu7Au8Y4oAY4y8u0XnVivY9g2YaNzf0I64z4Quvxe3Yc
         VdsGAc2xApGF7JKm26xw01zWCbgoOMyC1NzGPTmdOAjoAk5OLVMi3Uu7xmuP360xZLkX
         yvJqK37/QotceCP/VYgsnhgnjNheGiW9Vg5f7e+5gqOxQbztSno+oO9pnL0DCFFvt7gs
         TPywJb1vE7Ayu8V+NiWYe1oj7CT6dpKkpaE7r0YrLNykKEIG+8Zdgbv03IZnbBAApbEZ
         GixzFbjbUCaxWRD8TmQlzYpSHsMDn8k5i8AVnQHnlHJHTJJyOtRWIgkvJjeXpzR4gJUJ
         r25A==
X-Gm-Message-State: AOAM532A4tL3wJL8etepWIG6PBGPRofOeS9ax+zoM+2+Y5exT/wL0s99
        GtSSB4qqiGbXmAbkKgRxXvWpdX1gz0Zz8ut/r/TcpTOAOBWkFssQQp3v1uFi4qYk8aSc+xZkfZL
        sSMqO9YBy/beaEV0gzeBWklwWjm3VF+v+Pw==
X-Received: by 2002:ab0:278e:: with SMTP id t14mr29084970uap.25.1620830615489;
        Wed, 12 May 2021 07:43:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw02cwj0oM9HIUpM6IquUx2L8g6c9yDPzMDV6dCDUYq+xnie/xTTLmMlBr0NRCMxpHHUjFIXA==
X-Received: by 2002:ab0:278e:: with SMTP id t14mr29084941uap.25.1620830615269;
        Wed, 12 May 2021 07:43:35 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id a5sm1641vkl.19.2021.05.12.07.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 07:43:34 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linux-nfc@lists.01.org
Subject: [PATCH 1/2] MAINTAINERS: nfc: add Krzysztof Kozlowski as maintainer
Date:   Wed, 12 May 2021 10:43:18 -0400
Message-Id: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NFC subsystem is orphaned.  I am happy to spend some cycles to
review the patches, send pull requests and in general keep the NFC
subsystem running.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

---

I admit I don't have big experience in NFC part but this will be nice
opportunity to learn something new.  I am already maintainer of few
other parts: memory controller drivers, Samsung ARM/ARM64 SoC and some
drviers.  I have a kernel.org account and my GPG key is:
https://git.kernel.org/pub/scm/docs/kernel/pgpkeys.git/tree/keys/1B93437D3B41629B.asc

Best regards,
Krzysztof
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cc81667e8bab..adc6cbe29f78 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12899,8 +12899,9 @@ F:	include/uapi/linux/nexthop.h
 F:	net/ipv4/nexthop.c
 
 NFC SUBSYSTEM
+M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
 L:	netdev@vger.kernel.org
-S:	Orphan
+S:	Maintained
 F:	Documentation/devicetree/bindings/net/nfc/
 F:	drivers/nfc/
 F:	include/linux/platform_data/nfcmrvl.h
-- 
2.25.1

