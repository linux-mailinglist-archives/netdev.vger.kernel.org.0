Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9D6210C053
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 23:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfK0WpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 17:45:14 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36286 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbfK0WpO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 17:45:14 -0500
Received: by mail-pj1-f66.google.com with SMTP id cq11so10826544pjb.3
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 14:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=63jmzggHofWJgr5L+GFqxa+EPIblRXoAkXungwth2fI=;
        b=MGcWFCb0G0DykTImRQeb3TawUcMhqC9QSHIXhHlJYWD5JI749HJpVBWgXqg7daoiGA
         T7es9mluxMthSbpztiGoHaZthnsvDRErI7+DezwQi2RYIRCd9s2MHGxiEPnJ6zw1uwkb
         EndGbT1feeUF49ynd1MIXRupi0HFXWNJ3BgJ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=63jmzggHofWJgr5L+GFqxa+EPIblRXoAkXungwth2fI=;
        b=nZLkeYwxzwWhzKryinDze0C6zkw/IbMdlglJk2hK8MUtJg8eWMSHYC6uwFIoP1lNyu
         LRaddLsmREodsSwJf3j8xFmPTldx/Oxy735mU4pdDfYyPvAKKAtyGwxn9k+zMHS58CAY
         LOj04YFwMEV2iR8sfbX6+iMGITz1nK2/C5RGvV4rij8pF/GRzvYcPtQEF6+UZCjPsVTO
         lKHYq9QRtkoFkbyNx+Q6dMGB4ptBbEhENPU+pHi6CqYAWNAkpjIaNpoq5Y6yvaDn8SAa
         n3ja+cyDYXy2Equ6rbVDFk0UbQofNoSXm8F80kZ6PyyhdL3NexZxX4y5q9+04Jh9F20k
         mB6Q==
X-Gm-Message-State: APjAAAWubSiLtM4ZKs6plI6WBd5yaIUahuGOqhhtI9ZwqJX0FtXDl/mL
        wDCoFuCk3Aah4wXOvFY1yjKv0A==
X-Google-Smtp-Source: APXvYqxkiaNpRSKYO8TFXuDbKEa4C6rhv9HChTpAPsUa4ZwUsN9Kt+fIhYQ8z4o9sPgZF5ZN+rFnRQ==
X-Received: by 2002:a17:90a:b38c:: with SMTP id e12mr8827391pjr.89.1574894713609;
        Wed, 27 Nov 2019 14:45:13 -0800 (PST)
Received: from apsdesk.mtv.corp.google.com ([2620:15c:202:1:e09a:8d06:a338:aafb])
        by smtp.gmail.com with ESMTPSA id g18sm17756714pfr.165.2019.11.27.14.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 14:45:13 -0800 (PST)
From:   Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-bluetooth@vger.kernel.org,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Johan Hedberg <johan.hedberg@intel.com>,
        Ondrej Jirman <megous@megous.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Mohammad Rasim <mohammad.rasim96@gmail.com>
Subject: [PATCH] dt-bindings: net: bluetooth: Minor fix in broadcom-bluetooth
Date:   Wed, 27 Nov 2019 14:45:09 -0800
Message-Id: <20191127224509.3341-1-abhishekpandit@chromium.org>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The example for brcm,bt-pcm-int-params should be a bytestring and all
values need to be two hex characters.

Signed-off-by: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
---

 Documentation/devicetree/bindings/net/broadcom-bluetooth.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
index b02a53275c98..b5eadee4a9a7 100644
--- a/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
+++ b/Documentation/devicetree/bindings/net/broadcom-bluetooth.txt
@@ -47,6 +47,6 @@ Example:
        bluetooth {
                compatible = "brcm,bcm43438-bt";
                max-speed = <921600>;
-               brcm,bt-pcm-int-params = [1 2 0 1 1];
+               brcm,bt-pcm-int-params = [01 02 00 01 01];
        };
 };
-- 
2.24.0.432.g9d3f5f5b63-goog

