Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C4A1B51D9
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 03:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgDWBel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 21:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgDWBek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 21:34:40 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61598C03C1AA;
        Wed, 22 Apr 2020 18:34:40 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id t11so3396032lfe.4;
        Wed, 22 Apr 2020 18:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DsCsLkML8vM9o9JxjC1JcTLr6rGiyK9/YPUi2mV+hHw=;
        b=YdTGzAGkjEBzcnx49rbGvNS1WOd+XJ8J9lgxA6IPs6gu4S+tg+tEYFwjVKgcUBvoHk
         1oLNnIxmP+G/Y1fJpSkLvUMj2QrhyORezRtkJK1lMolyNl5JPHwZ0FleA8o+BEyGTdOY
         WRfjsvdnGxSG52uUlmxNtGJe+szGQUWDuM/B9Tm2/z74WET6j/GRGi/yKWcwI7rCm6TZ
         8O1Ygk3E09cp+lbJ4Z+hmQ2iKyYbnXlSmwvU8TJ5/h/IKM3Q/A7DSnXqVf47EiWcyclT
         GeUvUyk6s50zwP5+lWTAkN3CTA51O890tDWZbj7r/+W1iau8gF7W9s6u8uS8vz+lvjw2
         aRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DsCsLkML8vM9o9JxjC1JcTLr6rGiyK9/YPUi2mV+hHw=;
        b=FLVGGw06El8WdwdViqQBzGAt0N0pq9PXGb4Q4aB+j9ezzdySzGy+e69aE/si5VSSHH
         ww91SfvZN8fhfSBure6uobKj6jwK7PB598AOcjfdciZK+6oO3VarW+UEysbIOQB6Pf6L
         xBkxO5dkG/fBe7oWseh6EpgQxHX9HTnQSb3K01iKPAF1Fv84HH5PkxMzEak9PLMNpUXq
         ZloV60uEwW6xzHIzG9/lR7g2AOVxm0wU86zJVYFFjDAajKKA6CF5hoBpgEtrnuxR/vJS
         qdaaDcVO2Yu30oWY3qSm2qgvWISBH0Okb7SvVz5oRHrHXBv8Vi+gZecqeaUG2yQFLh7C
         XHUg==
X-Gm-Message-State: AGi0PuYCijrLaIA81qNtJE+EwC68RmJrNyyeJkF8HU/+dmSNJGd9mzXT
        w7vEuI/pY6+SVA7J78qlfQU=
X-Google-Smtp-Source: APiQypKpOxCqGo2vEH5cRAwTfl60WT+Lj+sRkrcgjF4/zfgt2tmFvQw3sVSr9hLuEXo/Vw1v+NKg9A==
X-Received: by 2002:a19:5f04:: with SMTP id t4mr825926lfb.208.1587605678890;
        Wed, 22 Apr 2020 18:34:38 -0700 (PDT)
Received: from localhost.localdomain ([87.200.95.144])
        by smtp.gmail.com with ESMTPSA id h21sm564967lfp.1.2020.04.22.18.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 18:34:38 -0700 (PDT)
From:   Christian Hewitt <christianshewitt@gmail.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        Christian Hewitt <christianshewitt@gmail.com>
Subject: [PATCH v2 1/3] dt-bindings: net: bluetooth: Add device tree bindings for QCA9377
Date:   Thu, 23 Apr 2020 01:34:28 +0000
Message-Id: <20200423013430.21399-2-christianshewitt@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423013430.21399-1-christianshewitt@gmail.com>
References: <20200423013430.21399-1-christianshewitt@gmail.com>
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
index aad2632c6443..709ca6d51650 100644
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
@@ -21,6 +22,10 @@ Optional properties for compatible string qcom,qca6174-bt:
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

