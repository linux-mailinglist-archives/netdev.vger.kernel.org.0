Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 075B037C082
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 16:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbhELOou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 10:44:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60080 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbhELOor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 10:44:47 -0400
Received: from mail-vs1-f72.google.com ([209.85.217.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lgq5K-00058C-O7
        for netdev@vger.kernel.org; Wed, 12 May 2021 14:43:38 +0000
Received: by mail-vs1-f72.google.com with SMTP id e12-20020a67d80c0000b029022a88436f30so6325690vsj.11
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:43:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TdWB/Esx7MvhSHhrINPBmiVw2zi4y0P4I0ON0o9Ugro=;
        b=I+1RKzm12Zu79nizyV+nJ5Ht5CrcziNtc9gfXi/962RjnmkKvwuJGim3BasdgeeU11
         JzcPPQgSM2aQk2LpMWjXSyyoabv6Sd0m1SYQ4cELF4nFb9LmRQ5Dr0CyKQsmHcqXECli
         61v4ZKsDTP5XHNHjlDclUkaQGzepjkjo9SFNMbdwnUvtmafQB62MXv+83pQ/CGb8qneA
         Xab0Xn/6T95PX3VhTvRWcJrNm9HKJdfxYJPw4pAnam8z1+FUV7WWqx4E8L/ZshETBHQc
         zEK3dZlzu6zkBXdpkLKZKmIKsBnnkNtqo4RsZntJEQmtshE+aCdjmUNE5ZckcEJfF2GJ
         xz8w==
X-Gm-Message-State: AOAM530CGZrTZSz9Nr8/IDDUbAMNRG4ML4ZqICJQdLVPfrFwfmbe9VJt
        vg/UsrkxvI079u5vVJ4mQQs9xsMjGezEEdcWaId62D7ggN7Yg2VU6nhGAGmqyAgiMlZHGGaXvJM
        PBfntK3Eby4ROEgXkJeBeBjJgc26+I9GzOg==
X-Received: by 2002:ab0:2486:: with SMTP id i6mr32363603uan.51.1620830617952;
        Wed, 12 May 2021 07:43:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwmS3AcxaoVkRWOVvL8RHwnGNz+Q2MxoouobMXIqpUEwxbzAIjuzBVl5OO0VdTkhtYHNk9dQ==
X-Received: by 2002:ab0:2486:: with SMTP id i6mr32363581uan.51.1620830617806;
        Wed, 12 May 2021 07:43:37 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id a5sm1641vkl.19.2021.05.12.07.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 07:43:37 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linux-nfc@lists.01.org
Subject: [PATCH 2/2] MAINTAINERS: nfc: include linux-nfc mailing list
Date:   Wed, 12 May 2021 10:43:19 -0400
Message-Id: <20210512144319.30852-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Keep all NFC related patches in existing linux-nfc@lists.01.org mailing
list.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index adc6cbe29f78..83f18e674880 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12900,6 +12900,7 @@ F:	net/ipv4/nexthop.c
 
 NFC SUBSYSTEM
 M:	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
+L:	linux-nfc@lists.01.org (moderated for non-subscribers)
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/nfc/
-- 
2.25.1

