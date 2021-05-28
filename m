Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1FB53942BE
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235548AbhE1Mnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:43:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42485 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhE1Mnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:43:45 -0400
Received: from mail-vs1-f72.google.com ([209.85.217.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmboY-0007wh-18
        for netdev@vger.kernel.org; Fri, 28 May 2021 12:42:10 +0000
Received: by mail-vs1-f72.google.com with SMTP id b24-20020a67d3980000b029022a610fc6f2so951153vsj.22
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 05:42:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rFH/OkxJX+1bf3RA1MwdAa7s8lhCFQ3NsGd/fHMtrBU=;
        b=BOufQhyayIbkix7XHyyg8enzkYL8B7a4rtCjA1PfdulJLv6FJL8pXO4WIv6yDeN6pc
         ZROpeXnY8M15JyA8uGjS5N+b1HL6UzY4jp/akf/oR+nezdxeDKku8ZdRbHhd3h20qnXM
         N5rUpL5S9HqlsppuSzAE3PLlWdNCU/7CnFsmGQ3SvwWyxE7xPBNDJW8H2pBByas+4EpG
         R08RpCBRqd2WoBFCuQS5WyE7DOlP8PCby4ei5JSpefPpLd6MP4PrHfFwpR6+g69fbmqg
         GTNClDFM5hhq4mhw9A3APUf6UQJmRBhY030nfyEsXrM17yp8ot5Vn16G8bBb178ZoRSi
         F7Dg==
X-Gm-Message-State: AOAM530RoY3r8y/gUKEm5ywuOavN/OP/IyvP+T5lxUWPjPPUEn6BPR+3
        0fK2We9M1iljM+c3HSjNvGI16kMXAgF1vjaKCxfwv+QfBohmooSO+eTHf9FbGBdQidVV+vbDNSx
        t/EbFR05vwY1DEwF6tjNULReEs6945RR9Pw==
X-Received: by 2002:a05:6102:5d0:: with SMTP id v16mr7076731vsf.31.1622205728639;
        Fri, 28 May 2021 05:42:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEVlZcqgPeeaF4dSVhZblaqkKUAk6rrB1qIKVtSVM+CD1gahWuLY4xUCoT2Axwd6Dn2W6LIg==
X-Received: by 2002:a05:6102:5d0:: with SMTP id v16mr7076718vsf.31.1622205728478;
        Fri, 28 May 2021 05:42:08 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.6])
        by smtp.gmail.com with ESMTPSA id b35sm782328uae.20.2021.05.28.05.42.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 05:42:07 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] nfc: fdp: correct kerneldoc for structure
Date:   Fri, 28 May 2021 08:41:49 -0400
Message-Id: <20210528124200.79655-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since structure comments are not kerneldoc, remove the double ** to fix
W=1 warnings:

    warning: This comment starts with '/**', but isn't a kernel-doc comment.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/fdp/fdp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/fdp/fdp.c b/drivers/nfc/fdp/fdp.c
index fe0719ed81a0..125d71c27b8b 100644
--- a/drivers/nfc/fdp/fdp.c
+++ b/drivers/nfc/fdp/fdp.c
@@ -149,7 +149,7 @@ static void fdp_nci_send_patch_cb(struct nci_dev *ndev)
 	wake_up(&info->setup_wq);
 }
 
-/**
+/*
  * Register a packet sent counter and a callback
  *
  * We have no other way of knowing when all firmware packets were sent out
@@ -167,7 +167,7 @@ static void fdp_nci_set_data_pkt_counter(struct nci_dev *ndev,
 	info->data_pkt_counter_cb = cb;
 }
 
-/**
+/*
  * The device is expecting a stream of packets. All packets need to
  * have the PBF flag set to 0x0 (last packet) even if the firmware
  * file is segmented and there are multiple packets. If we give the
-- 
2.27.0

