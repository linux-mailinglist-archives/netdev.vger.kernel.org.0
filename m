Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134064249D7
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239994AbhJFWix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239864AbhJFWif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:38:35 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02B2C061771;
        Wed,  6 Oct 2021 15:36:41 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id z20so15409189edc.13;
        Wed, 06 Oct 2021 15:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZCaNobBwRDoHpwFarZH3ixrL5LCb9D8Eryar/KUu2HM=;
        b=mICIRycRdLZG+Tk5RQLSYC3PWRLzHO2L8lfQ8b7uGIB/9UMehNy5+aiGcFrk3zd9Ng
         URW18Ku9aYwhQcG5uDFQDhGY/i+OpvVZfLid6fNt9tMsau1wJrBnDC8LB6Ef6wyemDM2
         snJ+DcrNypmSRc8rUsCcBu9L1JYa0Qcn4y4xmgJDR6zGDgKrgJMPhTL/IwCINcQpH+hj
         ni5SB7IEGlIaX/ng/VaiA9DiTu0esHk2H+P7IewnXd++kQFsogqVhoIiO+I7Uh13hJma
         6NK3B7GIf4oWmH9dLJuBKtuEmqdCFjdqUDh9cVbLeQoUBtyLS7UApChvqjwIkwIh2sIZ
         sAlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZCaNobBwRDoHpwFarZH3ixrL5LCb9D8Eryar/KUu2HM=;
        b=qYWq2v/IBlO/P+XnMD+8aj4FiJvjp0SHZM+DOoD0W0X4QpFRBs+ORoWhQ65rqA2yfO
         C3oAxWx7qBjIQdI47mGOGfICjtL6gF+S+TzwPA8MBZ6amZ9CwGCPSMS+xQJ0h43Gtz5h
         +7ADnoIbBRwo4nZncCvEdgThZQihDhX/bYOvH8UcuZu8ivrSHOpuGdtNz62l0C8x4Vl7
         gxNQsRVdQCHtS/Mu+3FQuYk7sXumPqlt2LO6kRjCJD1tRaBjEXf2L2JcocwHynTaIY0n
         YslnPChP6Qg3OWoImGsWSQiH6qxPs3XNVKVLrqJE0fIQqczicIrqoM9uiQW/bcWU6KYn
         pK0A==
X-Gm-Message-State: AOAM530+QSrNtjOHRNSC3Bfk8Nb958G3hYOcmeIQJ+mliwNAcHCchIiP
        DslLmMxkyxeImgD/S+cQBHo=
X-Google-Smtp-Source: ABdhPJzcXi1kyzLXUSJNcRwS31p9lRnRqQk1c0r/RNJq3CGHIWEmCm+iW90GwPMtbGm5SRt4ZhyF1w==
X-Received: by 2002:a17:906:1553:: with SMTP id c19mr1141217ejd.266.1633559800139;
        Wed, 06 Oct 2021 15:36:40 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z8sm9462678ejd.94.2021.10.06.15.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:36:39 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH 11/13] devicetree: net: dsa: qca8k: Document qca,sgmii-enable-pll
Date:   Thu,  7 Oct 2021 00:36:01 +0200
Message-Id: <20211006223603.18858-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006223603.18858-1-ansuelsmth@gmail.com>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document qca,sgmii-enable-pll binding used in the CPU nodes to
enable SGMII PLL on MAC config.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 780d1e60c425..550f4313c6e0 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -42,6 +42,8 @@ A CPU port node has the following optional node:
                           managed entity. See
                           Documentation/devicetree/bindings/net/fixed-link.txt
                           for details.
+- qca,sgmii-enable-pll  : For SGMII CPU port, explicitly enable PLL, TX and RX
+                          chain along with Signal Detection.
 
 For QCA8K the 'fixed-link' sub-node supports only the following properties:
 
-- 
2.32.0

