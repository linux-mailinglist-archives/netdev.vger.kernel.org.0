Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98083522F97
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 11:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233573AbiEKJjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 05:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242221AbiEKJjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 05:39:02 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C05168F81;
        Wed, 11 May 2022 02:38:32 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id 185so1853161qke.7;
        Wed, 11 May 2022 02:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zlxey1v6je9JiDTrxPjvTOrItg+TKc2+BmMwb6IgesE=;
        b=J/iE3/1M1OxLC7Deq64THPOQ2hN3Vb+Bxoc8D0u4+1oMwy0BpZUdV3kAwWSlGhvGK6
         CcMKpBuAclAP3TItXYtD81S1VIH/JK7nmdfnp9JxA31dsaoqI/ViCj18CKifNsqkkiXs
         VonnDWsoQr/jBLRkOLrIyyu5hUfGvrC0CZ2FgRJ7UtvdM32zVI5DXDhzuPk796Tq4CNp
         kzfi+AskZm91HUwt6vznJpXKLtefDQPVNpbvdd53S/AR4NbS2+IqpPH1e08uLlpOJEKW
         JV6r7GNNDWrGD4haTVMPxHZFQ6T7cC0hhlJWe7ZW3AaBaZhC6diRfQT9mACt4mttT7j8
         3deA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Zlxey1v6je9JiDTrxPjvTOrItg+TKc2+BmMwb6IgesE=;
        b=Z7qpMZEWFYXNFmzGzRl7ha4w4zQ00GvqtaJgQY7Jcd2fXyJLyrA7HA1OQBzsj7z4+m
         5B5gghDcUuA7/bb0SDNvSMUdGaY3BU6vF6OGmlDWOQT1tTTugu6Y2kxbtUrRVwFX6RkL
         /sLgpKiVAICazT5/YNCF6ySX/9eC8DVKP9/8wwHZhdJ5XMZnqtD1vzc2b2LXXDj15sf7
         Ab9OTkBAr1ooNfJbQyrePBt51gELIjdk1YNceXzbE4ZPScLJoh7pBdEWIa3SSoZMYJr+
         uiWggR/OS3udAOLzCN2apn8PLKKIHObYvcCFDJySZD4urscU5x1Mvhs5a4juP3wdzMO5
         G/QQ==
X-Gm-Message-State: AOAM5322V2Hancf56MRUREdkAF4HZgtIvdNdvOo+NW26K8V0evkgGkia
        GWCLEhcarWXGClYQVOzPsjoEPlotzvZyQdUI
X-Google-Smtp-Source: ABdhPJwj+O2nbFAfs9Q4pY6EGj95+Wraj5S+M6fGcoHhi+xFSE0ozQhN6o6yXZ7DwK1SBmqMVU4Y9A==
X-Received: by 2002:a05:620a:4405:b0:6a0:30b7:7d5b with SMTP id v5-20020a05620a440500b006a030b77d5bmr17729100qkp.482.1652261911819;
        Wed, 11 May 2022 02:38:31 -0700 (PDT)
Received: from debian.lan ([98.97.182.206])
        by smtp.gmail.com with ESMTPSA id o20-20020a05622a139400b002f39b99f6a6sm885834qtk.64.2022.05.11.02.38.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 02:38:31 -0700 (PDT)
From:   David Ober <dober6023@gmail.com>
To:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, aaron.ma@canonical.com
Cc:     mpearson@lenovo.com, dober@lenovo.com,
        David Ober <dober6023@gmail.com>
Subject: [PATCH] Additions to the list of devices that can be used for Lenovo Pass-thru feature
Date:   Wed, 11 May 2022 05:38:26 -0400
Message-Id: <20220511093826.245118-1-dober6023@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net: usb: r8152: Add in new Devices that are supported for Mac-Passthru

Lenovo Thunderbolt 4 Dock, and other Lenovo USB Docks are using the original
Realtek USB ethernet Vendor and Product IDs
If the Network device is Realtek verify that it is on a Lenovo USB hub
before enabling the passthru feature

This also adds in the device IDs for the Lenovo USB Dongle and one other
USB-C dock

Signed-off-by: David Ober <dober6023@gmail.com>
---
 drivers/net/usb/r8152.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c2da3438387c..7d43c772b85d 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -771,6 +771,9 @@ enum rtl8152_flags {
 };
 
 #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
+#define DEVICE_ID_THINKPAD_THUNDERBOLT4_DOCK_GEN1	0x8153
+#define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3		0x3062
+#define DEVICE_ID_THINKPAD_USB_C_DONGLE		0x720c
 #define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
 
 struct tally_counter {
@@ -9644,10 +9647,19 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
 		switch (le16_to_cpu(udev->descriptor.idProduct)) {
+		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3:
+		case DEVICE_ID_THINKPAD_USB_C_DONGLE:
 		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
 		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
 			tp->lenovo_macpassthru = 1;
 		}
+        }
+	else if ((le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_REALTEK) &&
+                 (le16_to_cpu(udev->parent->descriptor.idVendor) == VENDOR_ID_LENOVO)) {
+		switch (le16_to_cpu(udev->descriptor.idProduct)) {
+		case DEVICE_ID_THINKPAD_THUNDERBOLT4_DOCK_GEN1:
+			tp->lenovo_macpassthru = 1;
+		}
 	}
 
 	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial &&
-- 
2.30.2

