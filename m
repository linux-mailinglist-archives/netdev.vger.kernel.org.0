Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15B0F827A5
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 00:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbfHEWaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 18:30:14 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33652 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728922AbfHEWaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 18:30:13 -0400
Received: by mail-pg1-f195.google.com with SMTP id n190so5319802pgn.0
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 15:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PGWNj2hnGrZPeVHBwp5izSIakGhCcuJhREEHm7QJkG4=;
        b=eY+JeZXidXf1OkBlXT0bbRprtB+vOUPvpOslq8PsVdRZeUJ6gl+f2yc6aNs2/ODbzD
         ZILy1M/6cuZeUYmGBW34cAfIY00TnLXvlDFrE6QRqfUjVWicKUcN8auUL+eqiWU5N3DQ
         +yQJVZLJMdUiEW+b3V4leIcQxWJEJgGot2BYfqGCBEvPJ9LpBWaRJN4+En8E/F5MH8s5
         /8pLhdwmShBvndYwSoXAEtPuOyBDYUUCeuWFK8/YXThWVkwhXWbvaLNHYud29GHJS8cc
         wjNJgBvRYnZdeW3J6v4BkHYfuDraZ0CnAFqjF3+1fMT1xFCdx5BuIbrh81igSKltD5GU
         Eu0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PGWNj2hnGrZPeVHBwp5izSIakGhCcuJhREEHm7QJkG4=;
        b=Soj0SRD8oA3IfreGeoq27IumNYiiMTxfBZth3ElTIRYBj7b4c/YElwBIX9WC2cETwK
         rS7M7aYyyHjkiMkGwZklogETTF/yI3QdG/ijJ3phFFnG8ysgI8T3qZ+rqPppaavdtWTp
         vmYjlkJWEm2JTciP3rmEX62M3mArSzhAKvnqO/B+6Z5j/55+W2uyxE1VMnGOOd6OghmC
         ufrPrgXkHaNgxCK6MqC11wQ35TBMf5blsrYneqa1dmU9lCfpZ1OElyueHjNJFKNG2xky
         lRf3WgymbSoNaa4UmTym1BwrWIbR+j3cCTC2mU7JlSqp7jOfh2VycG1gqLXkG6yb2o/j
         TScw==
X-Gm-Message-State: APjAAAXcCwi7UfbqwJIJ8sDwevo/fX/6vYUgB2l5zIvoXky486KU1C62
        Xs7ah2PoRyYv7on7esiXR2mjKQ==
X-Google-Smtp-Source: APXvYqysSh5dF0G4tnAnnIkkwChxLK+Qb7w9vo/FjyfnySj0P2o7tcCfap2SU41YNp8xXXdOzWhEYQ==
X-Received: by 2002:a62:26c1:: with SMTP id m184mr299025pfm.200.1565044212660;
        Mon, 05 Aug 2019 15:30:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x9sm60024281pgp.75.2019.08.05.15.30.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 15:30:11 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     davem@davemloft.net, corbet@lwn.net
Cc:     linux-dog@vger.kernel.org, netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net 2/2] net: docs: replace IPX in tuntap documentation
Date:   Mon,  5 Aug 2019 15:30:03 -0700
Message-Id: <20190805223003.13444-2-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190805223003.13444-1-stephen@networkplumber.org>
References: <20190805223003.13444-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPX is no longer supported, but the example in the documentation
might useful. Replace it with IPv6.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 Documentation/networking/tuntap.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/tuntap.txt b/Documentation/networking/tuntap.txt
index 949d5dcdd9a3..0104830d5075 100644
--- a/Documentation/networking/tuntap.txt
+++ b/Documentation/networking/tuntap.txt
@@ -204,8 +204,8 @@ Ethernet device, which instead of receiving packets from a physical
 media, receives them from user space program and instead of sending 
 packets via physical media sends them to the user space program. 
 
-Let's say that you configured IPX on the tap0, then whenever 
-the kernel sends an IPX packet to tap0, it is passed to the application
+Let's say that you configured IPv6 on the tap0, then whenever
+the kernel sends an IPv6 packet to tap0, it is passed to the application
 (VTun for example). The application encrypts, compresses and sends it to 
 the other side over TCP or UDP. The application on the other side decompresses
 and decrypts the data received and writes the packet to the TAP device, 
-- 
2.20.1

