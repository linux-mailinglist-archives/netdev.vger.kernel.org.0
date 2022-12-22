Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB67D653BA1
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 06:11:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235075AbiLVFLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 00:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234968AbiLVFK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 00:10:57 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D39217067;
        Wed, 21 Dec 2022 21:10:55 -0800 (PST)
From:   Thomas =?utf-8?q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1671685848;
        bh=aJ7IVJ34rJu4bypYe1rv5vqdZ+Bmi73wBdQLIivw4ts=;
        h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
        b=nzvPq4V4YM3yepefWrKQUEa+Nby91i6BGB4MbAPtZ9zCehBQTP7ZpumFTXCngMTPy
         b/oKA3a98bIv/t3N+WjrRDOIWjX0AM5Bteqs1FSAEd1sR+WrLz4MJY0m4sqxC8tKlc
         3jCIbs3NbFjQ/GhUp0eDBxj0UZWf7KtbgF29MyM4=
Date:   Thu, 22 Dec 2022 05:10:46 +0000
Subject: [PATCH 3/8] HID: Remove unused function hid_is_using_ll_driver()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <20221222-hid-v1-3-f4a6c35487a5@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1671685845; l=761;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=aJ7IVJ34rJu4bypYe1rv5vqdZ+Bmi73wBdQLIivw4ts=;
 b=CO/ajOHSL68RVBZncIxSRsKPvD1NB0gAon57+ErnZ3WV+3ZsBndBhdn4vhj39QQXFDdBmKBW3Fnl
 n/fw2GoHClUGZswPDlzct7sDSUC125wbm+rYgxjPxpSxQNl9uN37
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

As the last user was removed we can delete this function.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 include/linux/hid.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/hid.h b/include/linux/hid.h
index e8400aa78522..7c5fce6a189e 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -858,12 +858,6 @@ extern struct hid_ll_driver hidp_hid_driver;
 extern struct hid_ll_driver uhid_hid_driver;
 extern struct hid_ll_driver usb_hid_driver;
 
-static inline bool hid_is_using_ll_driver(struct hid_device *hdev,
-		struct hid_ll_driver *driver)
-{
-	return hdev->ll_driver == driver;
-}
-
 extern bool hid_is_usb(const struct hid_device *hdev);
 
 #define	PM_HINT_FULLON	1<<5

-- 
2.39.0
