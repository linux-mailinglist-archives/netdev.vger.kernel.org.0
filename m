Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DC04249D2
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239967AbhJFWir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239771AbhJFWia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:38:30 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D248C061766;
        Wed,  6 Oct 2021 15:36:36 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id x7so14800717edd.6;
        Wed, 06 Oct 2021 15:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=vzVlobWW8Uyng6cC2eO6ydPjsxlzKVvWal8zjQElWKE=;
        b=ClzuQJRJG6IgSZoLKmj7SNZLvhm8KDgLB+7pS/BKRS9+pJoE/8oDa4blyLXTvYSQBw
         cBc0gEajyg6tBpFeg71VJpKpnbdAPvYbKMuPPzOfsedV62nEjn4SDW4ycu7Akdofks5c
         wEo3BTA+bjniFTwy3cVWvJdsx6W3xkwfbtsyo+sEk//pXOe556TAGdcOrtBX3dnGiIN5
         43wYMVamHZbnYMPnJ3GZ/M545oNhKPqw8/ccMgmrF8tN+MXe/BbeNvzTrW2AMPWLHxyZ
         o7si2d52uT2LBbzmZPmEr/Gr3fld+MdxUFhGbjbWXzJsVZ8C1RQu8ZSsCVouO1I+QEe9
         lO4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vzVlobWW8Uyng6cC2eO6ydPjsxlzKVvWal8zjQElWKE=;
        b=fcOrR4Ox83BmaFodPHR38iOJrfGGy1I7ZUpxouWCDKotBrNL/MJPo4awivKqknfX7y
         e/JoKEQoPuOmAj7/1xub6exC0+uKw0ABYsXxhx9ndYk+j+81X6Nha556Ne0Io5iUYFDl
         4USryBtjW1M+zdyLV0GJ1ZeWOg4o617aQUp/OZcd2zBeQl48ib3bFtMqts7Z2hpbjz97
         PSurpaACIgyM2NcdHQh34E+p1MD/4B7eVqWpbbssHEoS7s4FA5iE6gzfL5vAJO6wVrs6
         FKW4vB58ge87EUwkEck4VlliexbkaxgEizgAX9pNZlSJQ0ko1Ar9sro5+xawoc7/hWdX
         2Mrg==
X-Gm-Message-State: AOAM533ulN1bJSFyeYBXS5IyuysNO50Ksb9bkavJ0WUNitKZXTnKXV2J
        MeBFFsBs9Y5WhJpCV1sDqNc=
X-Google-Smtp-Source: ABdhPJzbMV+SDzjotsyJWQk4BeC8xZ9HamgBbVySJIaN+Cedd3YvHdJaFXWWKV8dh+83S2xYJ27GfA==
X-Received: by 2002:a17:906:1f09:: with SMTP id w9mr1176303ejj.472.1633559794785;
        Wed, 06 Oct 2021 15:36:34 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z8sm9462678ejd.94.2021.10.06.15.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:36:34 -0700 (PDT)
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
Subject: [net-next PATCH 06/13] Documentation: devicetree: net: dsa: qca8k: document rgmii_1_8v bindings
Date:   Thu,  7 Oct 2021 00:35:56 +0200
Message-Id: <20211006223603.18858-7-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006223603.18858-1-ansuelsmth@gmail.com>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document new qca,rgmii0_1_8v and qca,rgmii56_1_8v needed to setup
mac_pwr_sel register for ar8327 switch.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 8c73f67c43ca..1f6b7d2f609e 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -13,6 +13,8 @@ Required properties:
 Optional properties:
 
 - reset-gpios: GPIO to be used to reset the whole device
+- qca,rgmii0-1-8v: Set the internal regulator to supply 1.8v for MAC0 port
+- qca,rgmii56-1-8v: Set the internal regulator to supply 1.8v for MAC5/6 port
 
 Subnodes:
 
-- 
2.32.0

