Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9394746BBAE
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbhLGMvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:51:50 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:44522 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230328AbhLGMvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 07:51:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1638881294; x=1670417294;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SzVwhwLnt8ql7ii30Vxma29+2up071tdWQBl65HE5V4=;
  b=aSSSld7c05s8gtd+GM8/DMFxj8goDiUniu3k7nbk7gdJxuu+hDv0R9OZ
   cdMBLKNIbQzeZ30ktzqeHss2qeY1wgyXQxS5TFLUyKEUyGhRU+50GMjZD
   U9oUF7y6ZTg1jyf/vaEBePwO9Ozy0jQhHzP3+XFeD7vnTQevrlrTgPTFE
   1Qul8/OA+WTfZjqGIvtY7Mh96kQcjrC5vtAadFqvdSu4kHLBR2Omu9WlP
   /MwTTCpWyLpLnyjUTKJYA7FRzKZpJkbinO2luGPd0oWtXT4MGcr5LE+28
   V6vuHIHIH3zrMWpQquxZXeNae25exw7PsjChZhfNIu57uNssgTgZcRjac
   g==;
IronPort-SDR: Suzd+I+BJCIAkQHU/CpJqJCmNHaYW6wRwuxPF7l5lWbbqoicnwaEcU9SCJWMJhmMTOBadpRFDc
 fyAnQeYYi6LvO5Ly052JeW7HKVjo2Gi+m1Vl1oUsuwg1I8We8jZKb9aXjBULYWENSHHtouHsa0
 pzqwmOUo5HQPd8E9YYY8vhgLBqnqzywrmSizOjMhaIYJurrRtUozqpPn2LhB9lNy5wLVPJfKOd
 Kc41NNJHtJrZA6fnd7o6sQteFDK5CzDsKN7n/22UQUnsAwb73mFu8cXl3iA6BOG7Kv4w66kiLB
 T49lVKx3UIuvhXkUwwOEc6VR
X-IronPort-AV: E=Sophos;i="5.87,293,1631602800"; 
   d="scan'208";a="78754896"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2021 05:48:14 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 7 Dec 2021 05:48:13 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Tue, 7 Dec 2021 05:48:11 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 2/6] dt-bindings: net: lan966x: Extend with the analyzer interrupt
Date:   Tue, 7 Dec 2021 13:48:34 +0100
Message-ID: <20211207124838.2215451-3-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211207124838.2215451-1-horatiu.vultur@microchip.com>
References: <20211207124838.2215451-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend dt-bindings for lan966x with analyzer interrupt.
This interrupt can be generated for example when the HW learn/forgets
an entry in the MAC table.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../devicetree/bindings/net/microchip,lan966x-switch.yaml       | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
index 5bee665d5fcf..e79e4e166ad8 100644
--- a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
+++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
@@ -37,12 +37,14 @@ properties:
     items:
       - description: register based extraction
       - description: frame dma based extraction
+      - description: analyzer interrupt
 
   interrupt-names:
     minItems: 1
     items:
       - const: xtr
       - const: fdma
+      - const: ana
 
   resets:
     items:
-- 
2.33.0

