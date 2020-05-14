Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECEF1D3733
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgENQ7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 12:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbgENQ7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 12:59:46 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D509AC061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 09:59:45 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z72so24092735wmc.2
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 09:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eAX7gpmF0UnCkHoN2iXHQmoGmy8q2rcynSEgVQObiis=;
        b=xfbLUg+P7fleiOX59Muih2DpZDUYTCOghJaOg87Yp3eymeIdv/DJ8ELLCH8YbuwH7U
         ynADSqdccBZ0benYeg1FEBUKSFAVL8aUQzoG9LfSlI7maLNuuluxCpyw5nImsoamzaJS
         TyJeTc4Ufs7WJ7ipEVIzrslyy/braWeBnXK3BpHNscvBRwV7+hfE71KcbUxGVIfNV32N
         4DGi+Tp71HhfF6WYl/6PsQKTnDNV5w5uCf8jJgHgcDwDkvsn5ZzkB0dX44lRjUGpGRnq
         f1PuivBfnw2NOVjezMsUOXzrMTXhyI12g8lC7xJgFkBLVdeSc5zmNzGkbg/16CTGtwwr
         hViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eAX7gpmF0UnCkHoN2iXHQmoGmy8q2rcynSEgVQObiis=;
        b=LXI0y4EFDpN1tt3O2Oj1fvmI5rksq7ntR0rlPaPR80ENfBgEc+QYHCOfwozuSSiRxu
         2od8p6xW4yMxMjRZGA8IZHYXSj7oV0nyeiWz3+SPEl4y8dfxYEsaZ0IElz3miwBxDf04
         Mk9xssJktbOo6jJDHkm/PXEFfagzSpQZ3mncoEBurMj09etl8++UD/2NnBlmA2CgnTwb
         L1fJ1+V5/iPQZ9/GV2GaTdnnM8HqB6HVa1Nu9HmDz1FmBeiiWcjdyEZSmE2zLKETU8TH
         ekn++aOEaGgbE9Vtzl7VcEyC1cQfmbyuC4Iy5KKymqUb0lwY9zyUNOGL/ZRBdL0RX2l4
         OUWQ==
X-Gm-Message-State: AGi0PuY2Cv6B8a4meriF6CmP+mtwQJ1wVNj9u6TMUEurG1ATzarr0qen
        dDcHfF4cWNg5YeEVA/XG0A6+sg==
X-Google-Smtp-Source: APiQypJXwW4bMxdrz1XTj4O2wz2iHy1Vb7odBH9Sr2FK5n9yMLjLxX87IGclvxzZ4cfBIhv3AugxPA==
X-Received: by 2002:a1c:1b0d:: with SMTP id b13mr27066878wmb.171.1589475584582;
        Thu, 14 May 2020 09:59:44 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id b14sm29744078wmb.18.2020.05.14.09.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 09:59:44 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH] net: phy: mdio-moxart: remove unneeded include
Date:   Thu, 14 May 2020 18:59:38 +0200
Message-Id: <20200514165938.21725-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

mdio-moxart doesn't use regulators in the driver code. We can remove
the regulator include.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/phy/mdio-moxart.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/mdio-moxart.c b/drivers/net/phy/mdio-moxart.c
index 2d16fc4173c1..b72c6d185175 100644
--- a/drivers/net/phy/mdio-moxart.c
+++ b/drivers/net/phy/mdio-moxart.c
@@ -12,7 +12,6 @@
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
-#include <linux/regulator/consumer.h>
 
 #define REG_PHY_CTRL            0
 #define REG_PHY_WRITE_DATA      4
-- 
2.25.0

