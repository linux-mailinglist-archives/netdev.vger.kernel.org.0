Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C3149B9B
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 09:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbfFRH67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 03:58:59 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41271 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfFRH67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 03:58:59 -0400
Received: by mail-pf1-f195.google.com with SMTP id m30so7171209pff.8
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 00:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KNKUdapm3qNhe7MOmKoE4hXvbJ/LomCozufosFqpC3o=;
        b=MND8vxaDJbYE1BrCgIXbMpEu9+Rt1KUTQ5E7VltY+/32k2ApcT4xKFQEjjrMzz8z9d
         6/kd8Ykct6sP4CnWhstkw0+maJmuiwXA/qbVuFUQDVoQgKR9kMcsuhyjnZX6o5sKf1Lo
         CR01oHYMybhZcfIHN8YqUs3xGAmjnIFIoWPvMudHOUwR7XNDRGB4sj7DNMFN0V2fwhg5
         76D8Mnip0gAVdxVXdwnNQagborQ7lvU+c4XFtPfHJbIUcpRJ/j5deqKg1/NgfQumZI3r
         Al4Hm3kyD8l8eJt0u6r+LujqQWAWgMi6GJzXqyvI7R1gUsufdzDHj1hcEU4XDEwTdLfU
         7IRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KNKUdapm3qNhe7MOmKoE4hXvbJ/LomCozufosFqpC3o=;
        b=YxK3+JNf7zUv9NOl6UpvMo6s678CzeQ2w9zl+5+b0+tZCPJFBmPh+c0+UgKKWj2FPO
         FqBvCYBK2SxmTUwPe2Z7685ffNbUEJg+UfnMhTdOzZLKTUj7Zq/GqoNKI+mI1PdyYM8c
         JemGJsr5ZafJ7+7/5n6G+8hm9bXoOKb/Jyl2Bc0T813lEDXEsoF6t1C1tkIrRDzMf3Gg
         fZPfLYcwHr76QZes9MRXdsxJhrscrLBQm2GCLSp7AFFFTSxZd3CN9WxPZBRFR0r1y6YO
         4yApmUw+8bUhBZpmBHdQ2F+M/yV58mZOJGdpN8ONYP+SFozDw8EkNqLUhEhRJxeMekZR
         LDEg==
X-Gm-Message-State: APjAAAVrT7e0cB0KPm0B/cOBFTQJmciRNJAq656zCBZ2Re0xBoL/KgpO
        9Q7F/0FgcvRrane8ReOe9FMywOTrUqg=
X-Google-Smtp-Source: APXvYqzcXM1piGFfZULbOjP6OTb3aCFfIxUeCDqceRMd3JQYSPXGy8BeEYnBvuiaVYY8kAyDUUZbeg==
X-Received: by 2002:a17:90a:228b:: with SMTP id s11mr3597672pjc.23.1560844738927;
        Tue, 18 Jun 2019 00:58:58 -0700 (PDT)
Received: from buildserver-90.open-silicon.com ([114.143.65.226])
        by smtp.googlemail.com with ESMTPSA id b23sm15780499pfi.6.2019.06.18.00.58.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 18 Jun 2019 00:58:58 -0700 (PDT)
From:   Yash Shah <yash.shah@sifive.com>
To:     davem@davemloft.net, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        nicolas.ferre@microchip.com, palmer@sifive.com,
        aou@eecs.berkeley.edu, paul.walmsley@sifive.com, ynezz@true.cz,
        sachin.ghadi@sifive.com, Yash Shah <yash.shah@sifive.com>
Subject: [PATCH v3 1/2] macb: bindings doc: add sifive fu540-c000 binding
Date:   Tue, 18 Jun 2019 13:26:07 +0530
Message-Id: <1560844568-4746-2-git-send-email-yash.shah@sifive.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1560844568-4746-1-git-send-email-yash.shah@sifive.com>
References: <1560844568-4746-1-git-send-email-yash.shah@sifive.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the compatibility string documentation for SiFive FU540-C0000
interface.
On the FU540, this driver also needs to read and write registers in a
management IP block that monitors or drives boundary signals for the
GEMGXL IP block that are not directly mapped to GEMGXL registers.
Therefore, add additional range to "reg" property for SiFive GEMGXL
management IP registers.

Signed-off-by: Yash Shah <yash.shah@sifive.com>
Reviewed-by: Paul Walmsley <paul.walmsley@sifive.com>
---
 Documentation/devicetree/bindings/net/macb.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 9c5e944..63c73fa 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -15,8 +15,11 @@ Required properties:
   Use "atmel,sama5d4-gem" for the GEM IP (10/100) available on Atmel sama5d4 SoCs.
   Use "cdns,zynq-gem" Xilinx Zynq-7xxx SoC.
   Use "cdns,zynqmp-gem" for Zynq Ultrascale+ MPSoC.
+  Use "sifive,fu540-macb" for SiFive FU540-C000 SoC.
   Or the generic form: "cdns,emac".
 - reg: Address and length of the register set for the device
+	For "sifive,fu540-macb", second range is required to specify the
+	address and length of the registers for GEMGXL Management block.
 - interrupts: Should contain macb interrupt
 - phy-mode: See ethernet.txt file in the same directory.
 - clock-names: Tuple listing input clock names.
-- 
1.9.1

