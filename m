Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA4E1B214B
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 10:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgDUIRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 04:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgDUIRH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 04:17:07 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCE3C061A0F;
        Tue, 21 Apr 2020 01:17:06 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id e25so13035558ljg.5;
        Tue, 21 Apr 2020 01:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I5j2meaXqfCQg6EDK5Yc89bHLLGnzZUOQwGDeJZNWgA=;
        b=E1+nB5uBJ2Lvjqr0F2R2j0bbl3P9N2oY6AHBJZnv+/GOutnQoJb15Y0NW2HiQ6cxRI
         my4chhnr8EQXJIog2d5xI1Dpg2A0bLatoQ85g/NAKsmGjnJ/aEe6aEVLQHyn1abwkRE1
         svd91vjSfOWroeAPilW3Kj8YD2iCU8vRJ53F4PhItDzhHrA70emZX8el+lHqiqHltbzH
         iua38U2ghEIQJ7L3vNh58/1gsgf+Z8Rxn+RxpLJUPX9eEn9aObgfETlEez4llz6gMve6
         V/+Mwa+LXgbbK0WQRMDzxG7JkGMtxlyYRLjlLA8rFhdvI9ajqsSb0py/GPnfYCsK/HlM
         QaXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I5j2meaXqfCQg6EDK5Yc89bHLLGnzZUOQwGDeJZNWgA=;
        b=XU/kBZmSukjmyfVPXpSP4yk19pW5GG+GHngSB9DtJMHoBQRE64CiSeGmtINk2Y6qet
         hSEUhHg2Dy9yKWACzObex/ROlVFIRPiiKAlv97BjeDf/AsurXGE7QDJBi5YAQYRuA7wp
         8UYXNXM+EOBGHRAlpX7Qb5bmSRMfvQJkiTwyKMjo1Hq4yG7ApJuqyc+g5Wlv/69h9wF9
         U3uyBggEGkmrbuVK6wBSzgtBtGGY1AUVja2b/RbWP38iFuwGkz4PB9by27CQlgiRZDwa
         Yne/BTG2n8TRzUAJV5HvmjiTsPdJI8aNpAQbYU8UoacAKzqTS10uN6ExrqWunIipFsVt
         SH8w==
X-Gm-Message-State: AGi0PuZJf8TDPa+11Ar2P1gzlUYQ5h2cYK/8NrXTrKIq/SGz8U8+mll1
        I3Qyarzrzi+wNlfgH0S/RBw=
X-Google-Smtp-Source: APiQypKUA5C705+SoOWtEmSGF73au/UD7TbUtttQo3xwBmnBpYc2nLQjSuRpGgkARK/BASUxJDxPwQ==
X-Received: by 2002:a05:651c:20f:: with SMTP id y15mr8030841ljn.230.1587457025160;
        Tue, 21 Apr 2020 01:17:05 -0700 (PDT)
Received: from localhost.localdomain ([87.200.95.144])
        by smtp.gmail.com with ESMTPSA id j13sm1472756lfb.19.2020.04.21.01.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 01:17:04 -0700 (PDT)
From:   Christian Hewitt <christianshewitt@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
Subject: [PATCH 1/3] dt-bindings: net: bluetooth: Add device tree bindings for QCA9377
Date:   Tue, 21 Apr 2020 08:16:54 +0000
Message-Id: <20200421081656.9067-2-christianshewitt@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421081656.9067-1-christianshewitt@gmail.com>
References: <20200421081656.9067-1-christianshewitt@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QCA9377 is a QCA ROME device frequently found in Android TV boxes.

Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
---
 Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
index d2202791c1d4..2fec6912e160 100644
--- a/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
+++ b/Documentation/devicetree/bindings/net/qualcomm-bluetooth.txt
@@ -10,6 +10,7 @@ device the slave device is attached to.
 Required properties:
  - compatible: should contain one of the following:
    * "qcom,qca6174-bt"
+   * "qcom,qca9377-bt"
    * "qcom,wcn3990-bt"
    * "qcom,wcn3991-bt"
    * "qcom,wcn3998-bt"
@@ -20,6 +21,10 @@ Optional properties for compatible string qcom,qca6174-bt:
  - clocks: clock provided to the controller (SUSCLK_32KHZ)
  - firmware-name: specify the name of nvm firmware to load
 
+Optional properties for compatible string qcom,qca9377-bt:
+
+ - max-speed: see Documentation/devicetree/bindings/serial/serial.yaml
+
 Required properties for compatible string qcom,wcn399x-bt:
 
  - vddio-supply: VDD_IO supply regulator handle.
-- 
2.17.1

