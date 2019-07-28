Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA1B77FC3
	for <lists+netdev@lfdr.de>; Sun, 28 Jul 2019 16:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfG1OHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 10:07:50 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46138 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfG1OHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 10:07:50 -0400
Received: by mail-pg1-f193.google.com with SMTP id k189so7871837pgk.13;
        Sun, 28 Jul 2019 07:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7wNNlwp2VDKWKwFNYxDQX6TM/koZM7zLealIeSa2nWo=;
        b=lglvxf6IFqg4KOs3L7Hgc1exqBk5UIajBrbFkfGJCajnwHThNg+5TfNwhRcNuqtMh2
         tJSGfi/x9jWq8GTvn9Vmn1Le4eQgIRnFaJa5Z6Dgj9rDPbXOVKCcePcmhQtZjV/kINR2
         eIa8X70S914rkym7+7zOye8b9YdQRHqFdLSrmpOgpHSs2mtHsUQSIVPyqghh2ZytAxV1
         GmiV4geAf+b9uoJwi8EG0/Ren3Cz2/GR+wdac62YdhW+ilFmnNNJTJ05Ih/mwDx9bGKj
         hlVBhIglW1X9HKW5exw/qvb21zo/L3lEG7DUyDPz5CnhjLNvuzqRRhzIsk6mH+wM9bxW
         SOmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7wNNlwp2VDKWKwFNYxDQX6TM/koZM7zLealIeSa2nWo=;
        b=E5CSRTZBdxgC25eblOWlKJTcGnOdJu3ZReebfdayaaz8S+8eRrCmh1yRP1PuaDXoLI
         W5opT12o4tnb6ylbcsxirMhQjIUXs57gbO6EBzxPf9ykkWbbOmn+YCKsTFX/4vEutKYX
         JaoQ9EV5Af5pgu+atmDopgXhni9coof6lsytHKAee3+PPPIolZUhew5ZX9ar60JTrwyt
         ktZiNXVTSzDUSdpG+Xdq3O79L7sjTOF5XehieeYwRltotLvciqGfygNFtOya+iwvYdfK
         8Cl5FZknuIfTIIU6e2cGDSPFRSY4fQdanmlxP1WxbGf7X4WJZxrF2nor9INzc4002GjF
         kYdg==
X-Gm-Message-State: APjAAAVZoI+h4kX5dD1qTMrvDbVCD3KeAZNrffKJlH0/BIyaYgZW15Wk
        L9O+LvZSBKljO29vlAy7clE=
X-Google-Smtp-Source: APXvYqytnwBFUYq3/VG+6Frww3/CYoTZ5mDbacg8sN2qCZqthO/WHGi2MvIfdTfgDAboq0INPfBw6A==
X-Received: by 2002:a65:64cf:: with SMTP id t15mr96941158pgv.88.1564322869755;
        Sun, 28 Jul 2019 07:07:49 -0700 (PDT)
Received: from masabert (i118-21-156-233.s30.a048.ap.plala.or.jp. [118.21.156.233])
        by smtp.gmail.com with ESMTPSA id a16sm64495033pfd.68.2019.07.28.07.07.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 07:07:48 -0700 (PDT)
Received: by masabert (Postfix, from userid 1000)
        id 0C920201190; Sun, 28 Jul 2019 23:07:46 +0900 (JST)
From:   Masanari Iida <standby24x7@gmail.com>
To:     sgruszka@redhat.com, helmut.schaa@googlemail.com,
        kvalo@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH net-next] rt2800usb: Add new rt2800usb device PLANEX GW-USMicroN
Date:   Sun, 28 Jul 2019 23:07:42 +0900
Message-Id: <20190728140742.3280-1-standby24x7@gmail.com>
X-Mailer: git-send-email 2.22.0.545.g9c9b961d7eb1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add a device ID for PLANEX GW-USMicroN.
Without this patch, I had to echo the device IDs in order to
recognize the device.

# lsusb |grep PLANEX
Bus 002 Device 005: ID 2019:ed14 PLANEX GW-USMicroN

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index fdf0504b5f1d..0dfb55c69b73 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -1086,6 +1086,7 @@ static const struct usb_device_id rt2800usb_device_table[] = {
 	{ USB_DEVICE(0x0846, 0x9013) },
 	{ USB_DEVICE(0x0846, 0x9019) },
 	/* Planex */
+	{ USB_DEVICE(0x2019, 0xed14) },
 	{ USB_DEVICE(0x2019, 0xed19) },
 	/* Ralink */
 	{ USB_DEVICE(0x148f, 0x3573) },
-- 
2.22.0.545.g9c9b961d7eb1

