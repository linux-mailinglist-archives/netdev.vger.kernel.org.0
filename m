Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26E6419EB9B
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 15:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgDENuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 09:50:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38407 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgDENuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 09:50:06 -0400
Received: by mail-wm1-f67.google.com with SMTP id f20so3902393wmh.3
        for <netdev@vger.kernel.org>; Sun, 05 Apr 2020 06:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:reply-to
         :mime-version:content-transfer-encoding;
        bh=aBPW0ikbvridXXEyZFzXqY5ifC1XaKtdSC74aEjA+go=;
        b=Rz+6lVjT71sn/yFlmE5QJc2xkxIys4L1C2rba3kkfkWd5m39D95p5YGxDO8UPjIUam
         ZG9+UYKyhNPG9jP/QrzhhNyGd57vnIbHDuTtOq5+HvV0R3nhszBMYVT41NI//iC0CvkP
         ePM2YOTnPTxp/i360+egSXzOdXAmdEJc7mOw9YWG5phKCWfdsH8dYjK2jkf2JDI6Hsfj
         jtztv3p/WHf7pmNkl6PS9UcyPe5LvstexgugPutxhJxPyUMaxr/6Ladlq7UkG9Or6+VJ
         FAiaJN4/ikDKPd0oRGQdXc31aBwGJ7w4mSZDhnWm0RQNfjPvZxoNuwugOXxMuwna5hfd
         CUug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:reply-to:mime-version:content-transfer-encoding;
        bh=aBPW0ikbvridXXEyZFzXqY5ifC1XaKtdSC74aEjA+go=;
        b=iZF8ALxsTPAlJyGz3uNhro1EnimAWZzF0TmmTZTqYiiCTxxPhet8654eojN7JgvGIL
         2eqv/MKIe9XN2z/WSvwLDM/JBggmrY8JdEDQxUM3YqwbIk9O4VNwumk/2ZWlCef0vSZ1
         jZzqZ91ttcFmIxmSEEkbR5oh1IxV0Yh+Cb6p0Utnqdsb3E/rMGdJHldMlJ4jnra9vG/L
         sWkpJkjsbn0E3qUHZKY0+eriIIydWinlaepDQuQRrlpBASpgs6aiPBIWISzjmTkh9yG4
         mvAPQsDiBfm+gYWMAitnaf2epVjEyIvygMtQOqHUxZNAr3tm8Wkv0MajbPNw+VM5hQ1j
         eObw==
X-Gm-Message-State: AGi0PubU/wtil6c6vrIbhi3x8HQSO4l+ynsz1hwzzNO6Whb92BnhxX19
        3kIH0ddUmXGQn4ZnIlIjOSxY/XBy
X-Google-Smtp-Source: APiQypKRssPVM5sfrLU2cAVCYqu7B4Nr7mTmH//+Q0WvwgYbdoxQYuY0gonDJmf5U5uc6aBVudgZ8Q==
X-Received: by 2002:a1c:b144:: with SMTP id a65mr19059263wmf.54.1586094603810;
        Sun, 05 Apr 2020 06:50:03 -0700 (PDT)
Received: from localhost ([2a01:e35:2f01:a61:fc49:14b:88c:2a9c])
        by smtp.gmail.com with ESMTPSA id o9sm21056126wrx.48.2020.04.05.06.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2020 06:50:02 -0700 (PDT)
From:   "=?UTF-8?q?Bastien=20Roucari=C3=A8s?=" <roucaries.bastien@gmail.com>
X-Google-Original-From: =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
To:     netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bastien=20Roucari=C3=A8s?= <rouca@debian.org>
Subject: [PATCH iproute2 4/6] Better documentation of BDPU guard
Date:   Sun,  5 Apr 2020 15:48:56 +0200
Message-Id: <20200405134859.57232-5-rouca@debian.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200405134859.57232-1-rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
Reply-To: rouca@debian.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document that guard disable the port and how to reenable it

Signed-off-by: Bastien Roucariès <rouca@debian.org>
---
 man/man8/bridge.8 | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index c8e15416..53aebb60 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -340,7 +340,18 @@ STP BPDUs.
 .BR "guard on " or " guard off "
 Controls whether STP BPDUs will be processed by the bridge port. By default,
 the flag is turned off allowed BPDU processing. Turning this flag on will
-cause the port to stop processing STP BPDUs.
+disables
+the bridge port if a STP BPDU packet is received.
+
+If running Spanning Tree on bridge, hostile devices on the network
+may send BPDU on a port and cause network failure. Setting
+.B guard on
+will detect and stop this by disabling the port.
+The port will be restarted if link is brought down, or
+removed and reattached.  For example if guard is enable on
+eth0:
+
+.B ip link set dev eth0 down; ip link set dev eth0 up
 
 .TP
 .BR "hairpin on " or " hairpin off "
-- 
2.25.1

