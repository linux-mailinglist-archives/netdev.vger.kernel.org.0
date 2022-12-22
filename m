Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7683653B98
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 06:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235084AbiLVFLW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 00:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbiLVFK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 00:10:57 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3131743F;
        Wed, 21 Dec 2022 21:10:56 -0800 (PST)
From:   Thomas =?utf-8?q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1671685851;
        bh=lmzuDjULh3kowLm3TMvFkxEVatyBx6FhtKbQzT2W7mU=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=G92vc5fD4RJzAzO3nxwjQcNGLwYlPe5rQt5aoEUC4Yo5uPkn85VtzUGr7fATtFEao
         uJxAejwNs6/4m9WPN5CaaTGv2km78lm/0Uza7oi0s7DetP8qCgv+3gt00/NYnC6UGw
         N+WDQCC4KS4N8SL4GvqLAW5kV5hZxYUxfs9a4aIg=
Date:   Thu, 22 Dec 2022 05:10:51 +0000
Subject: [PATCH 8/8] HID: Make lowlevel driver structs const
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <20221222-hid-v1-8-f4a6c35487a5@weissschuh.net>
References: <20221222-hid-v1-0-f4a6c35487a5@weissschuh.net>
In-Reply-To: <20221222-hid-v1-0-f4a6c35487a5@weissschuh.net>
To:     Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org,
        Thomas =?utf-8?q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.11.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1671685845; l=2830;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=lmzuDjULh3kowLm3TMvFkxEVatyBx6FhtKbQzT2W7mU=;
 b=TrQRzvbiBIvM2hqcwA7qpilAY+5M4CjJABKmBOKmkVq49p7hE4I+VDC3iUmLrbzWhmg2T4XH45CP
 y6z/aG0rDAmHo/VUlI35Tx/LuQemT+fmoDni2btjQBfTBNztHI7S
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nothing is nor should be modifying these structs so mark them as const.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 2 +-
 drivers/hid/uhid.c                 | 2 +-
 drivers/hid/usbhid/hid-core.c      | 2 +-
 include/linux/hid.h                | 2 +-
 net/bluetooth/hidp/core.c          | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index fc5a0dd4eb92..af98ac31c8d4 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -842,7 +842,7 @@ static void i2c_hid_close(struct hid_device *hid)
 	clear_bit(I2C_HID_STARTED, &ihid->flags);
 }
 
-static struct hid_ll_driver i2c_hid_ll_driver = {
+static const struct hid_ll_driver i2c_hid_ll_driver = {
 	.parse = i2c_hid_parse,
 	.start = i2c_hid_start,
 	.stop = i2c_hid_stop,
diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 6cec0614fc98..f161c95a1ad2 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -387,7 +387,7 @@ static int uhid_hid_output_report(struct hid_device *hid, __u8 *buf,
 	return uhid_hid_output_raw(hid, buf, count, HID_OUTPUT_REPORT);
 }
 
-static struct hid_ll_driver uhid_hid_driver = {
+static const struct hid_ll_driver uhid_hid_driver = {
 	.start = uhid_hid_start,
 	.stop = uhid_hid_stop,
 	.open = uhid_hid_open,
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 4143bab3380a..257dd73e37bf 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1318,7 +1318,7 @@ static bool usbhid_may_wakeup(struct hid_device *hid)
 	return device_may_wakeup(&dev->dev);
 }
 
-static struct hid_ll_driver usb_hid_driver = {
+static const struct hid_ll_driver usb_hid_driver = {
 	.parse = usbhid_parse,
 	.start = usbhid_start,
 	.stop = usbhid_stop,
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 60a092150bc6..39a374c7fbac 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -595,7 +595,7 @@ struct hid_device {							/* device report descriptor */
 	struct device dev;						/* device */
 	struct hid_driver *driver;
 
-	struct hid_ll_driver *ll_driver;
+	const struct hid_ll_driver *ll_driver;
 	struct mutex ll_open_lock;
 	unsigned int ll_open_count;
 
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index c4a741f6ed5c..bed1a7b9205c 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -739,7 +739,7 @@ static void hidp_stop(struct hid_device *hid)
 	hid->claimed = 0;
 }
 
-static struct hid_ll_driver hidp_hid_driver = {
+static const struct hid_ll_driver hidp_hid_driver = {
 	.parse = hidp_parse,
 	.start = hidp_start,
 	.stop = hidp_stop,

-- 
2.39.0
