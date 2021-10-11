Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F5C4284B6
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhJKBdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbhJKBc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:32:58 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92FCEC06177A;
        Sun, 10 Oct 2021 18:30:54 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id ec8so11445827edb.6;
        Sun, 10 Oct 2021 18:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rMP3P5zozCXV/t6fvCx4z79ja0Mg8ZMQVvb40Sw+2ds=;
        b=VNUsnEKcl6f9KRRyJElYSwi9klw+fOkoJdop7q9oC2uaTeYAlYl0m/dYs0+PmJjbsX
         PHwpaNGSJyDf8UY0/iWYN3bEfxboizd8fyZwltBO3gyts0Z0J1S8bubbl65B6yV3deRL
         G0d789hX6HIW7LLTz3MW5JuoJaKEC/xgOQmhcBvo+37asR/I+ClQoB8EIbkrqPxENUzs
         buVCEcu2+PL24PuRISCzYzobE8b2BuJmTaKq8r8/EfEHm9axLQJkdhUcIRWQU4n2qw8V
         nDBJ39Cu43exqx5VexMOMebvmw1qmIu3az2dEJ0S5/PyTmOreJ0Sy7GVyw8yI7ibBDb7
         yhVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rMP3P5zozCXV/t6fvCx4z79ja0Mg8ZMQVvb40Sw+2ds=;
        b=gXBmRmX1WFDOrubHnw7siPVvYvCt7tcpYk8E03FOt3E4bgGftloQhb7J1TCu5Hf2mI
         Edb4crD48jd9WjNdFaZJ5mhAHrgl76fvzTG/qW7tMAGDQD85ZKe952nzyQ1yzIPkgOCq
         2cFCUMU8lMYs4CN67ki+lRdBakpyn84ZPByXNRlij0VILlblV7ggBVBGyTcm0L9R2mOT
         KwWjQ6KTHiKFnECQlsPqTr+DdA9zVhivlPXtUKkRrpR1rRyOM1gTk84FYGojqODM79NA
         sAK89hW3P/gTh9TmWxVU9WQ9DJVtpC3SPqnb96gXxt02ozc2UTKcvQf+bdiSRyMQE9hH
         vaMA==
X-Gm-Message-State: AOAM530bCf6oTqEoHKqrkANjiseXU8ZERPHnx7mDdp/CTPyw7gM0nlVQ
        1yhF9wJc1M4FpduHKZwE3mM=
X-Google-Smtp-Source: ABdhPJygWO7n0u1T9pMZX93qbo25+CJfng2Fzg/T6lIWpl59v0jqa/a/VdwmLUA7C2y0kLqXzRoKyA==
X-Received: by 2002:a05:6402:3586:: with SMTP id y6mr4374757edc.292.1633915853044;
        Sun, 10 Oct 2021 18:30:53 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m15sm21314edd.5.2021.10.10.18.30.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 18:30:52 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v5 09/14] dt-bindings: net: dsa: qca8k: Document qca,led-open-drain binding
Date:   Mon, 11 Oct 2021 03:30:19 +0200
Message-Id: <20211011013024.569-10-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211011013024.569-1-ansuelsmth@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document new binding qca,ignore-power-on-sel used to ignore
power on strapping and use sw regs instead.
Document qca,led-open.drain to set led to open drain mode, the
qca,ignore-power-on-sel is mandatory with this enabled or an error will
be reported.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 05a8ddfb5483..9e6748ec13da 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -13,6 +13,17 @@ Required properties:
 Optional properties:
 
 - reset-gpios: GPIO to be used to reset the whole device
+- qca,ignore-power-on-sel: Ignore power on pin strapping to configure led open
+                           drain or eeprom presence. This is needed for broken
+                           devices that have wrong configuration or when the oem
+                           decided to not use pin strapping and fallback to sw
+                           regs.
+- qca,led-open-drain: Set leds to open-drain mode. This requires the
+                      qca,ignore-power-on-sel to be set or the driver will fail
+                      to probe. This is needed if the oem doesn't use pin
+                      strapping to set this mode and prefers to set it using sw
+                      regs. The pin strapping related to led open drain mode is
+                      the pin B68 for QCA832x and B49 for QCA833x
 
 Subnodes:
 
-- 
2.32.0

