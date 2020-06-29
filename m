Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838B120E4AB
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 00:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391127AbgF2V1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 17:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729057AbgF2Smo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 14:42:44 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D4BC031C73;
        Mon, 29 Jun 2020 11:05:55 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id h28so13687243edz.0;
        Mon, 29 Jun 2020 11:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hJ7bwzBcJdJpIqyIZcO1uCM9Pw8AFzZZQdo+BMkM/wI=;
        b=SLRB44N0JiC73+18YWv4FOQgCRuo9RDcXbGvKQN9AK5bgYKeK4KBNdylz0TGW704q2
         mVyX0kOwJ8f2lhJVD6O4pvcH9fRnRamZAQ4k2fOeJ9y2nqv801LHCj9c+V0sV41kCYsl
         qOafEoFtNGiraeC+62ve5Q59dPv05KWkzenF6UtDAvTfLOJ8t0jMRpEZVgx7oYfji6dv
         v2ilBNMlssGpE2qqwUoAIXeCwvBfO7RUGvFARu0t1xZvlEsmJvpyT37fMHmkjAwEf0ky
         St6mxRNAtxjV6tDEOEMHg9zhX0rdM4wWf6P11Y2tCyzxsFdhqUS0nP/fBPyeSefcVE7V
         Vjtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hJ7bwzBcJdJpIqyIZcO1uCM9Pw8AFzZZQdo+BMkM/wI=;
        b=gkEPeX7IT/kW6jasTz2HjoOAxirrQ7RhIbgyCGXVOkUGXsUEXvxbc/HRtzkbw+3YRg
         XK6ZGcAErWq6Dxlo8K5ClZaAonN8X8OUjjoNRlU5TcEA5kF4aIdNFIP0TKZ7RYDqmkt0
         /ju96LajN73bXeJmqNq+joOW9D72DSwJ0zjd1bzlwy/KPbwhHy9nSWDafDdH7ZLKhRLg
         BhoFrqdN+RPPgtB/FXo1vPlko6qzglnWzXEAmE4BF7wbnrvsvSMnWCZ4wpvZorIgxdYL
         rEaZPFr1jyiPUiZidlsap0qiwnM+o7HurCzkkLz5cCh1xt8hQbJLT1lcSoH8S3pNPMgy
         9EIA==
X-Gm-Message-State: AOAM533GFQoiVImqgCtrBYMl9GxcX8BTaicCKgE/ALswIzUyqBtET0G6
        wCCTfOZPd+0i7aEw9dMeLBaSld6s
X-Google-Smtp-Source: ABdhPJxCsPnKAQk2H0DnK6TPDN2TMKek+xOMmP/lSIUI54dR+E3eobWScl1UkHE91a2hvf1KvmltdA==
X-Received: by 2002:aa7:c80d:: with SMTP id a13mr19225286edt.327.1593453954340;
        Mon, 29 Jun 2020 11:05:54 -0700 (PDT)
Received: from localhost.localdomain (p200300f137396800428d5cfffeb99db8.dip0.t-ipconnect.de. [2003:f1:3739:6800:428d:5cff:feb9:9db8])
        by smtp.googlemail.com with ESMTPSA id w18sm232937ejc.62.2020.06.29.11.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 11:05:53 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     devicetree@vger.kernel.org, robh+dt@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        marcel@holtmann.org, alistair@alistair23.me, anarsoul@gmail.com,
        kuba@kernel.org, davem@davemloft.net,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH] dt-bindings: net: bluetooth: realtek: Fix uart-has-rtscts example
Date:   Mon, 29 Jun 2020 20:05:45 +0200
Message-Id: <20200629180545.2879272-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

uart-has-rtscts is a boolean property. These are defined as present
(which means that this property evaluates to "true") or absent (which
means that this property evaluates to "false"). Remove the numeric value
from the example to make it comply with the boolean property bindings.

Fixes: 1cc2d0e021f867 ("dt-bindings: net: bluetooth: Add rtl8723bs-bluetooth")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
index f15a5e5e4859..c488f24ed38f 100644
--- a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
+++ b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
@@ -44,7 +44,7 @@ examples:
     uart1 {
         pinctrl-names = "default";
         pinctrl-0 = <&uart1_pins>, <&uart1_rts_cts_pins>;
-        uart-has-rtscts = <1>;
+        uart-has-rtscts;
 
         bluetooth {
             compatible = "realtek,rtl8723bs-bt";
-- 
2.27.0

