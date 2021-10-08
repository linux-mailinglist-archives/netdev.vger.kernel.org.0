Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F98426140
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242849AbhJHAZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242819AbhJHAZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:25:10 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7731BC061760;
        Thu,  7 Oct 2021 17:23:16 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id i20so13532203edj.10;
        Thu, 07 Oct 2021 17:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7jirxa6ab8DNZBierFEzrcZahC2HB0KCCjUjPFf3EW4=;
        b=ml84SdRkTuctkU728YPxzQBhaMFUp60CeTuF5a3TAh/aLIduNAWF93zSTRusAO/v/5
         QJ1UW9k/ykq6w2B99N+Y+TsoRJo5tzrdo8moTBnVkO8cv8CPPVTNX11w6JqrFOWgTPJG
         yrh3Vidc0Az/pJ77cmtyGg7uvLcsQuwp6svXWkBUqJt6XyUQ/Kw16rAAB8q9tWt274Gb
         aIPOpsEOrkAXf70IU49gK378ycE18UCEOHje42DLp7kYXVzejSu/cYhVK8vBsgH7A5sh
         d6bLqS9QUdYUMQyGq4dD3C673LArb0bMov0knMUYjzn39jTMW8tLCLkkb+r3ByBjy/jL
         9vpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7jirxa6ab8DNZBierFEzrcZahC2HB0KCCjUjPFf3EW4=;
        b=honvZxEHpLlU49brlV5epTZJFj/KX2p6rLYFgNUz22qadHpC7LPurloAdvkMAViWVE
         aCHgQNcalmeulqPVVms/3xhzsFqwFeZIVzqQHc0Gle118tUiI2xU5j8OYln3pGbzOJ25
         AJJHgqVlWYjast0AY9a7+3/bzmz8IbjaaoxQ/m0auUH214RXgL3M+JoQOPL0yIWNysSm
         NcC9wgJsqjMBHZiV+oey/JRthqV0y4NWZkbE6G+xzPIPEzWFKwPPj6CDp6tFt7OA9lYv
         Uu+QMUXH+FaG5TDDLt4aEQFLaBON2zjDBd+hZIEazIQt3613FHUh1OVAFwyw/CZQlvWP
         ZL0w==
X-Gm-Message-State: AOAM531WV0wGCY+Aq3+q7vXFOvvs57UDsTDWL/pfHOkhfFYKUcOipVe9
        npxI4JHebi0vea+ZdblMeEk=
X-Google-Smtp-Source: ABdhPJzCbot7lBz/ZxVq93Zt4RmtGo/NgMhcnAee/2oa/JTtlMjRP+Yo4+1/wHcoDH+4mJaxoOY//A==
X-Received: by 2002:a17:906:2816:: with SMTP id r22mr166828ejc.158.1633652594962;
        Thu, 07 Oct 2021 17:23:14 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:14 -0700 (PDT)
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
Subject: [net-next PATCH v2 15/15] dt-bindings: net: dsa: qca8k: document support for qca8328
Date:   Fri,  8 Oct 2021 02:22:25 +0200
Message-Id: <20211008002225.2426-16-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QCA8328 is the birrget brother of 8327. Document the new compatible
binding.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 9fb4db65907e..0e84500b8db2 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -3,6 +3,7 @@
 Required properties:
 
 - compatible: should be one of:
+    "qca,qca8328"
     "qca,qca8327"
     "qca,qca8334"
     "qca,qca8337"
-- 
2.32.0

