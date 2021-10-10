Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CF84280B1
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbhJJLST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbhJJLSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:18:11 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8559FC061764;
        Sun, 10 Oct 2021 04:16:12 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g10so54617201edj.1;
        Sun, 10 Oct 2021 04:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4esTCtJZXuuOiwPupffGXoBpgDSTRt7QTWWMeZINX1g=;
        b=AYAVNZJStbnx3GjqBuEUFuJ4pXJBu08i4Obn/+aO+t7pq7ZITfdt7/EDO+KmYWIPPz
         Llho++KHq2ywlhc4taB8avJ3zR1AVqVsbWmLyhkyadQNAaMOFvc8/wdBOHMKrZbh1bVn
         z+JdGIZhQYm6oSaNhq1ZarJ7cnMspiSDQOMRJ5OR/6QtkHhGhqmOUTSkW7Go46e6Bbqq
         Ck2tZ4onh9AQb8qf3SP0ZftsSCz8MBwhfCHxgWPat9njfjJsB0oS6E0UJBIpHCyTQYkX
         M3F/6ai/+yWUurI0kqshvtb2FY7+06/vqVByy0qGXeOBgof6IRuj9vdRxmugLrvEPY5S
         QGYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4esTCtJZXuuOiwPupffGXoBpgDSTRt7QTWWMeZINX1g=;
        b=Dw80Z1jZFe39FavV6CjQ43WxRF39s+aanYK2/+kIIZVLFNSUTjt4/HJZE6gqJ+lrtJ
         pHo+3xsx2pSVJs1fN5ISPYUPZl4YVaoH2pDGPWywJad6aG5kwkBJrlO+HdiHjMhBaKFL
         Q0NRuifg9e4ID6WsN0k16wEhUg6QjZCUeKuW31c2vfQ6POM5GfS38oj3OWfutk7njzl0
         mUSjlyXVNL/A1eFRyCYpp7E0Njwr5SKGnRmoF0kE/MUhbqfLdMPkN2q70ethk3CgwWVF
         JSzH+WKavvGVhZRV7novG1k3vKPOSY0tlcExURP8wWgjJ7bgH56qiKRFo5c/JQN27nJY
         IuVg==
X-Gm-Message-State: AOAM533LHuIJOZrA773GDPYS3Grhce1lvxdVsjZHvNTpqE3ZT90KNdI+
        xptdIOGa0BiXlceC0gNOmsc=
X-Google-Smtp-Source: ABdhPJwAuwKtxgsM+CJJom9U93ZxlF/DyueiB/7sHwn/io5JlF6OdY85JSj7fQFUzrsan+ZEWCmCrA==
X-Received: by 2002:a17:906:8893:: with SMTP id ak19mr18088211ejc.124.1633864570956;
        Sun, 10 Oct 2021 04:16:10 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z5sm2414438edm.82.2021.10.10.04.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:16:10 -0700 (PDT)
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
Subject: [net-next PATCH v4 05/13] dt-bindings: net: dsa: qca8k: Document support for CPU port 6
Date:   Sun, 10 Oct 2021 13:15:48 +0200
Message-Id: <20211010111556.30447-6-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010111556.30447-1-ansuelsmth@gmail.com>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The switch now support CPU port to be set 6 instead of be hardcoded to
0. Document support for it and describe logic selection.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index cc214e655442..aeb206556f54 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -29,7 +29,11 @@ the mdio MASTER is used as communication.
 Don't use mixed external and internal mdio-bus configurations, as this is
 not supported by the hardware.
 
-The CPU port of this switch is always port 0.
+This switch support 2 CPU port. Normally and advised configuration is with
+CPU port set to port 0. It is also possible to set the CPU port to port 6
+if the device requires it. The driver will configure the switch to the defined
+port. With both CPU port declared the first CPU port is selected as primary
+and the secondary CPU ignored.
 
 A CPU port node has the following optional node:
 
-- 
2.32.0

