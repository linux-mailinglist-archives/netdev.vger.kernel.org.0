Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEA81F4F8A
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 09:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgFJHsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 03:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbgFJHr7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 03:47:59 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A569EC08C5C2
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:47:58 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x22so757029pfn.3
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mBmy6hb5a23KMKQCkK27hu5NhYaoTF5cRzQ7jlandjM=;
        b=dp78FMTkX/1hJTaR4QYkcHQUaUVIESR4j5kc63tOAbf8hOuzjuBzZFRWA0YGERKt1q
         Fe+frKwucez80KwyDfZZhvqQ43xy385tpF1u3N1dUcrGgXUnhmSuOgypFwPorgFp/EE1
         x5k1cy/YYVD9vjPMqhXe44SNx7RmE4yLW+x0e1bQIEsKlEDZH+vvW6KgntpZFTDdDNOg
         CxEWx4C19RqCWnHyGto6GJxHQzYTINLSpdxjiRdHvZWdQL9f7VO1x+yLdVkz3iubkSvB
         OIoPprlM3jlTcDXIOMAxCFC/fK1u+pI49c+RO7r94JS8/SsoaDAz/kxUU7jdUEfHxJAD
         JSmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mBmy6hb5a23KMKQCkK27hu5NhYaoTF5cRzQ7jlandjM=;
        b=qOg0fh8vQZrs5EBnRjH+GWoTTiwpiT1cr2K29vq0Fg70Fg4KK31nZDryqqr6BfsBcl
         lB89t7o09oqqqueteabKrbRrDWvaxQgPMSi3AOkNnOglQpX8PfZKBsvq+NncwV9LgGnZ
         SUdB4pthUnONb3vOS+EiOWSKb5WahSpT/wLaGAyy6aec/cCC9T5g5DvHsgaZ9vXkiwq5
         drvUH+SQihOdRjAnadFN+1ZsMuAG6kLw78j212GRLgCjZ9qxI4VaTp7+cUwPR+I6H4Wg
         L/XjzDZ70pDg/C0DC0GYFUp+BpmnYUMYrGOq92h/kmMcY2cMgQFN0b05BWjvmEairD6F
         IJOQ==
X-Gm-Message-State: AOAM531OLzfHvMWhYvB3DHA6YMOl03FDnntOJumZgKw4UNdIJMu7MseG
        xArx39wDyELpe3Om+1BDdqJV
X-Google-Smtp-Source: ABdhPJyKw3UJzSTMp9lhzgNqf67W/XlxmmABmAg82mh6fgAO8XDUkxzjD7gXIfEdOVKdAMsBrIFLJw==
X-Received: by 2002:a63:f854:: with SMTP id v20mr1693743pgj.0.1591775278160;
        Wed, 10 Jun 2020 00:47:58 -0700 (PDT)
Received: from Mani-XPS-13-9360.localdomain ([2409:4072:630f:1dba:c41:a14e:6586:388a])
        by smtp.gmail.com with ESMTPSA id u1sm10075040pgf.28.2020.06.10.00.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 00:47:57 -0700 (PDT)
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     wg@grandegger.com, mkl@pengutronix.de, robh+dt@kernel.org
Cc:     kernel@martin.sperl.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [RESEND PATCH 6/6] MAINTAINERS: Add entry for Microchip MCP25XXFD CAN network driver
Date:   Wed, 10 Jun 2020 13:17:11 +0530
Message-Id: <20200610074711.10969-7-manivannan.sadhasivam@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200610074711.10969-1-manivannan.sadhasivam@linaro.org>
References: <20200610074711.10969-1-manivannan.sadhasivam@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add MAINTAINERS entry for Microchip MCP25XXFD CAN network driver.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b816a453b10e..591b6fc2d83a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10360,6 +10360,14 @@ L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/hid/hid-mcp2221.c
 
+MCP25XXFD CAN NETWORK DRIVER
+M:	Martin Sperl <kernel@martin.sperl.org>
+M:	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
+L:	linux-can@vger.kernel.org
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/can/microchip,mcp25xxfd.yaml
+F:	drivers/net/can/mcp25xxfd/
+
 MCP4018 AND MCP4531 MICROCHIP DIGITAL POTENTIOMETER DRIVERS
 M:	Peter Rosin <peda@axentia.se>
 L:	linux-iio@vger.kernel.org
-- 
2.17.1

