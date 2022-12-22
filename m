Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A502653B85
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 06:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbiLVFK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 00:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiLVFKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 00:10:53 -0500
Received: from todd.t-8ch.de (todd.t-8ch.de [IPv6:2a01:4f8:c010:41de::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12959167EA;
        Wed, 21 Dec 2022 21:10:50 -0800 (PST)
From:   Thomas =?utf-8?q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=weissschuh.net;
        s=mail; t=1671685848;
        bh=0453VDQMas3wzKqIyLohx5n71ZFMChZfy4arzHwtRes=;
        h=From:Subject:Date:To:Cc:From;
        b=U7HBuKeJ5i4EX7wUylFkiAHnl1f3RpDqejjXskNL6OiypyU7jAF3z2zu9pLvh5qUH
         4SklyXuN90pOkjWuoxDYkndbqcVFRwtvDaVOVm3CrpP0yCGCM/h82sF4Xxjhrnof1N
         nyXcaDDKSwzeO87AD6MBrcF6Y7ukrq8W4I8FpBxo=
Subject: [PATCH 0/8] HID: remove some unneeded exported symbols from hid.h
Date:   Thu, 22 Dec 2022 05:10:44 +0000
Message-Id: <20221222-hid-v1-0-f4a6c35487a5@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIANTmo2MC/x2MQQqAIBAAvxJ7TsiNgvpKdNBcc0EslCKQ/t7Sc
 YZhKhTKTAXmpkKmmwsfSUC3DWzBpJ0UO2HADlEjogrslJ2GQfvJG+xHkNKaQspmk7YgbbpiFHlm
 8vz862V93w/PlUFSagAAAA==
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1671685844; l=1655;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=0453VDQMas3wzKqIyLohx5n71ZFMChZfy4arzHwtRes=;
 b=UEW9J5h8xA21rKQnW8+3rDycmx36CZWyTIZ1aT3QhxmBfaPk55tlGKBzP0cAsc7Qokuw2YBn0eU1
 ZGj5kp4fCIjcqWWyHO+RRkz/w4oqGlVjnPMAoxSyjhhTz2M8phYc
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

Small cleanup to get rid of exports of the lowlevel hid drivers and to make
them const.

To: Hans de Goede <hdegoede@redhat.com>
To: Jiri Kosina <jikos@kernel.org>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: David Rheinsberg <david.rheinsberg@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
To: Johan Hedberg <johan.hedberg@gmail.com>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: linux-bluetooth@vger.kernel.org
Cc: netdev@vger.kernel.org

---
Thomas Weißschuh (8):
      HID: letsketch: Use hid_is_usb()
      HID: usbhid: Make hid_is_usb() non-inline
      HID: Remove unused function hid_is_using_ll_driver()
      HID: Unexport struct usb_hid_driver
      HID: Unexport struct uhid_hid_driver
      HID: Unexport struct hidp_hid_driver
      HID: Unexport struct i2c_hid_ll_driver
      HID: Make lowlevel driver structs const

 drivers/hid/hid-letsketch.c        |  2 +-
 drivers/hid/i2c-hid/i2c-hid-core.c |  3 +--
 drivers/hid/uhid.c                 |  3 +--
 drivers/hid/usbhid/hid-core.c      |  9 +++++++--
 include/linux/hid.h                | 18 ++----------------
 net/bluetooth/hidp/core.c          |  3 +--
 6 files changed, 13 insertions(+), 25 deletions(-)
---
base-commit: d264dd3bbbd16b56239e889023fbe49413a58eaf
change-id: 20221222-hid-b9551f9fa236

Best regards,
-- 
Thomas Weißschuh <linux@weissschuh.net>
