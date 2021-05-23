Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7358138DD0B
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 23:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbhEWVKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 17:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhEWVKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 17:10:48 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C007C061574;
        Sun, 23 May 2021 14:09:21 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f22so10813992pfn.0;
        Sun, 23 May 2021 14:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IB9O/onuOCJfiGo3cCn1xQC6qADxQorwK+ixiVlG76Q=;
        b=lRIrsodFwZZAENLZ5mkS+tGezVajr5a5iNeVhU7v0QZta/bQKCxso0vPWl+R3Jobir
         bTIy/+nulorVCQIVWgNhIKzOGMW1D/9Z9gCG+LYk/NOiGLBCJ025jlEUXfuIJAjhoWMJ
         jSzTZ09frJfemTn5wKY3ZeqWQSqqC2vLGkqzZ2ZYr3tZuADTaIJIQAbszytaA4KpBdxS
         gcyVlUK/9pcZXI04a6G1RnVbJHryPwkqv4By6fVQHGjKEcIRe5rZLlicibiDuLfJA/lh
         dstSQyn2kodjqlCjLdvXHgnmwb712qb6CWXjTuEu/0tw6iS0xZp+GW+7wd7Us1pdKEKo
         HDaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IB9O/onuOCJfiGo3cCn1xQC6qADxQorwK+ixiVlG76Q=;
        b=hSLcyR5jBE2GLfsOK5dma+SAGFrxYHGExWSo0cgwxppGh3kzRUAmUKLhDyvS1klfRF
         kgmdYDHYle3hkjIfTC9Y1uVbpQjpgJR0WDf08SAUXfpwqTxqR1msfkPRpk9Nd6wnuMcE
         R16vLpo3AOR4AcnOHDwzGTWu1ADEIeOiDqnG8Aqx0MtxAOqinhWOqwm5Xl4nn/84GJlb
         DEk6HqY5RU0TizrkxIzD+Y7E9GBXE8D/BNyNupZW9MAe19Ik0L2PJFXJXnxwPBmrMu+1
         rpZL5NHT4R1KnPJExXL27gh8Zpt2tPNP81A+xzTWtxvyJzcpc+/Ui7lLpsknfS11oROB
         91Ww==
X-Gm-Message-State: AOAM5334RbyR2oXJ9NfgDZ1MsGPuEgNOSuJXofXHZ+ITBdb+opj0wF9u
        8HgOsjlQ3++Exvb5kWrR96Q=
X-Google-Smtp-Source: ABdhPJy7ij8n3XWFurV3WYaYbh1UADV8mZC5Io4JLFY9Tx7UiOM/EArFULzv1ijxNEu+28Jmo/eqAQ==
X-Received: by 2002:a63:34cc:: with SMTP id b195mr10033021pga.449.1621804159685;
        Sun, 23 May 2021 14:09:19 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a93f:c492:941f:bc2a:cc89])
        by smtp.googlemail.com with ESMTPSA id n6sm10034854pgm.79.2021.05.23.14.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 14:09:19 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     krzysztof.kozlowski@canonical.com
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        rdunlap@infradead.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] NFC: nfcmrvl: fix kernel-doc syntax in file headers
Date:   Mon, 24 May 2021 02:39:09 +0530
Message-Id: <20210523210909.5359-1-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.
The header for drivers/nfc/nfcmrvl follows this syntax, but the content
inside does not comply with kernel-doc.

This line was probably not meant for kernel-doc parsing, but is parsed
due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
causes unexpected warnings from kernel-doc.
For e.g., running scripts/kernel-doc -none on drivers/nfc/nfcmrvl/spi.c
causes warning:
warning: expecting prototype for Marvell NFC(). Prototype was for SPI_WAIT_HANDSHAKE() instead

Provide a simple fix by replacing such occurrences with general comment
format, i.e. '/*', to prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/nfc/nfcmrvl/fw_dnld.h | 2 +-
 drivers/nfc/nfcmrvl/i2c.c     | 2 +-
 drivers/nfc/nfcmrvl/nfcmrvl.h | 2 +-
 drivers/nfc/nfcmrvl/spi.c     | 2 +-
 drivers/nfc/nfcmrvl/uart.c    | 2 +-
 drivers/nfc/nfcmrvl/usb.c     | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/fw_dnld.h b/drivers/nfc/nfcmrvl/fw_dnld.h
index ee4a339c05fd..058ce77b3cbc 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.h
+++ b/drivers/nfc/nfcmrvl/fw_dnld.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell NFC driver: Firmware downloader
  *
  * Copyright (C) 2015, Marvell International Ltd.
diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index 18cd96284b77..c5420616b7bc 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell NFC-over-I2C driver: I2C interface related functions
  *
  * Copyright (C) 2015, Marvell International Ltd.
diff --git a/drivers/nfc/nfcmrvl/nfcmrvl.h b/drivers/nfc/nfcmrvl/nfcmrvl.h
index de68ff45e49a..e84ee18c73ae 100644
--- a/drivers/nfc/nfcmrvl/nfcmrvl.h
+++ b/drivers/nfc/nfcmrvl/nfcmrvl.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell NFC driver
  *
  * Copyright (C) 2014-2015, Marvell International Ltd.
diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
index 8e0ddb434770..dec0d3eb3648 100644
--- a/drivers/nfc/nfcmrvl/spi.c
+++ b/drivers/nfc/nfcmrvl/spi.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell NFC-over-SPI driver: SPI interface related functions
  *
  * Copyright (C) 2015, Marvell International Ltd.
diff --git a/drivers/nfc/nfcmrvl/uart.c b/drivers/nfc/nfcmrvl/uart.c
index e5a622ce4b95..7194dd7ef0f1 100644
--- a/drivers/nfc/nfcmrvl/uart.c
+++ b/drivers/nfc/nfcmrvl/uart.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell NFC-over-UART driver
  *
  * Copyright (C) 2015, Marvell International Ltd.
diff --git a/drivers/nfc/nfcmrvl/usb.c b/drivers/nfc/nfcmrvl/usb.c
index 888e298f610b..bcd563cb556c 100644
--- a/drivers/nfc/nfcmrvl/usb.c
+++ b/drivers/nfc/nfcmrvl/usb.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Marvell NFC-over-USB driver: USB interface related functions
  *
  * Copyright (C) 2014, Marvell International Ltd.
-- 
2.17.1

