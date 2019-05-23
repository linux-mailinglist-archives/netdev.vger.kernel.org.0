Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E189B27C11
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 13:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbfEWLqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 07:46:30 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41482 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730477AbfEWLq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 07:46:29 -0400
Received: by mail-pl1-f196.google.com with SMTP id f12so2651038plt.8
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 04:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L7jtC9YLwA0closzFKH5J5lT2qmKzUMNqjaIDumr77w=;
        b=J7/qws0Qxp3NVZLnHy2qXlZRe+iDyhBpqBA9UAirr+0rrSH2reViAepFM/UquHryeC
         kAfTHH/I2AeboDE6avThPcLAVsl+d70CrgbKZv4GCmnyhp/O9i/jUh4XNUledWpIYKa9
         cLJR1D40KnLdmwRxxicn8hbF+jHu5jHp85TZS050DNv4WRRgUT3Qac1/3NA+d++p9U46
         MtK7xisAUL0tNQld94DBPXeHZOma/juwPjqawte5LaeeUJMiarRZhg31h2LdPf8SxCgx
         XHOVHNtiTM+J4TP/KWakDpvTm7KuBLCG7royYQ0lMAsmSol24XTrpoWMOTcQ4JPwC/Gd
         5zJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L7jtC9YLwA0closzFKH5J5lT2qmKzUMNqjaIDumr77w=;
        b=n+QdkZmmFzJTDgQFVjj+OgzNQyMHl4BZR1QjzaTefa/BPimCXRlna9G78kbkysgDKE
         tQVV8dGYd+5BJBbDg0RHMrmu5bXx/3Jpjb+mc02PeV6qZiDSlFsTz6zOT3UvhmoaIVD3
         qehpxIBwOfo4AOsNWuMCkX/384i+iJJ5KJBtb5+VOG8IUkd37htI22yTcAUtTBTk5BMZ
         2FRkYfh+IgwgRR2dh9XFBsrMssK5v+o/yASXa8SZT0tkH6vMVFhG1izS7UqG3cZ36dhT
         3QM34WFBZZrvkXFrmWnT0WgIVrlS2gnHILyUuWSBlbP5GwtXBdsz8dBLTJUDQyhDMpfJ
         50cw==
X-Gm-Message-State: APjAAAW2ieYetjOfERbvtUgs5i+76XqQ6oKmziOU9qZikg7mP0snp70c
        88O9uRl6N6Y9bWKJ9getYwLYyg==
X-Google-Smtp-Source: APXvYqzYfysVuLot60OmXdN5I7JacwSrGu0ekg3Gy2uMSozgIxzrs6RFjWap2hpiFOPQOvuCvlVNqg==
X-Received: by 2002:a17:902:1121:: with SMTP id d30mr2953751pla.153.1558611989302;
        Thu, 23 May 2019 04:46:29 -0700 (PDT)
Received: from buildserver-90.open-silicon.com ([114.143.65.226])
        by smtp.googlemail.com with ESMTPSA id l43sm565045pjb.7.2019.05.23.04.46.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 23 May 2019 04:46:28 -0700 (PDT)
From:   Yash Shah <yash.shah@sifive.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
        devicetree@vger.kernel.org
Cc:     robh+dt@kernel.org, mark.rutland@arm.com,
        nicolas.ferre@microchip.com, palmer@sifive.com,
        aou@eecs.berkeley.edu, ynezz@true.cz, paul.walmsley@sifive.com,
        sachin.ghadi@sifive.com, Yash Shah <yash.shah@sifive.com>
Subject: [PATCH 1/2] net/macb: bindings doc: add sifive fu540-c000 binding
Date:   Thu, 23 May 2019 17:15:51 +0530
Message-Id: <1558611952-13295-2-git-send-email-yash.shah@sifive.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1558611952-13295-1-git-send-email-yash.shah@sifive.com>
References: <1558611952-13295-1-git-send-email-yash.shah@sifive.com>
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
---
 Documentation/devicetree/bindings/net/macb.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
index 9c5e944..91a2a66 100644
--- a/Documentation/devicetree/bindings/net/macb.txt
+++ b/Documentation/devicetree/bindings/net/macb.txt
@@ -4,6 +4,7 @@ Required properties:
 - compatible: Should be "cdns,[<chip>-]{macb|gem}"
   Use "cdns,at91rm9200-emac" Atmel at91rm9200 SoC.
   Use "cdns,at91sam9260-macb" for Atmel at91sam9 SoCs.
+  Use "cdns,fu540-macb" for SiFive FU540-C000 SoC.
   Use "cdns,sam9x60-macb" for Microchip sam9x60 SoC.
   Use "cdns,np4-macb" for NP4 SoC devices.
   Use "cdns,at32ap7000-macb" for other 10/100 usage or use the generic form: "cdns,macb".
@@ -17,6 +18,8 @@ Required properties:
   Use "cdns,zynqmp-gem" for Zynq Ultrascale+ MPSoC.
   Or the generic form: "cdns,emac".
 - reg: Address and length of the register set for the device
+	For "cdns,fu540-macb", second range is required to specify the
+	address and length of the registers for GEMGXL Management block.
 - interrupts: Should contain macb interrupt
 - phy-mode: See ethernet.txt file in the same directory.
 - clock-names: Tuple listing input clock names.
-- 
1.9.1

