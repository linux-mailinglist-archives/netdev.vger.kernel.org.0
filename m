Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44E6C343CDF
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 10:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhCVJa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 05:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbhCVJaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 05:30:22 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED89BC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 02:30:21 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id e7so18356262edu.10
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 02:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gv/vF8ePQatEJhQ19O9eFZZ4RyJnM8zEipvGG7S13pg=;
        b=WBRp6j+rSE9AKv22mugn8Ufd1cPiYyOtwuaH24PcY7TdJs+y8nA+UOBy3tFmne29ZX
         k3/2BDAq//QR9g7rnltPBq0WaFdP2m1JIUtmH7V9VgjtqyzAPwup5hxtnmV2qoCpOXmx
         Pkp2dHs9rfBTI/Y8QMJgDZtt0IscSlDvFivSSeZQ1p+7UjCA+mU+TLzvIyGBddH27+1Y
         4PWGtc+1UevEvlutMj3IMPzUaFQBNUYZ4LRD/dgknTCTJGdkS49Qqxbf61UXlP0ZGu+I
         fAQ5LEjLqIhZrNBMERL7hJyZTf+/NpHBNlsH2JJlYybssHyI0EEl3TmTKtfyvURKBNiQ
         thzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gv/vF8ePQatEJhQ19O9eFZZ4RyJnM8zEipvGG7S13pg=;
        b=h+8SGXZQMIxffdkDMdwQBgDFSIpAXMHweseub19pqg7/mcULKnSJaKVSOZuhdUUiXq
         b/ZcjEv3Dgg2HJIVT296gdjOND8NsWl8MEvW+Vhnlfi4Pd5keAOf6TY1R+3ugSg6jsTP
         URHZ0LqU2Y1oBA2zH4T525qzkECodHvRGv9oK9oSNgkvUvmOiIw2eRw3fpMgRaOE5p7b
         1WLZ+74+FxybmDlDufaJmoKVwZ/xyrzipug7EXkjnVyWengE6E1Rox8jMgTsO7L+mGPC
         OL85AkZdc5IU4a2TjojkSt40omUQTRyZp/FT5fzmbkJkWUKvv1FXEzX/Z2kFsbM54xVN
         XHPg==
X-Gm-Message-State: AOAM533ZhRnyp4dglDy8m1Pbk8xEcqZ4/Q8BsZSq8ZD9bZeqgCyCZqb3
        H+XTEIyocvvhStzL/BuLVh4=
X-Google-Smtp-Source: ABdhPJzkPVGO+Fgxjxjpqto+DvMS+M0ThnK8MX/b1gyGcHC1j7ah/tMAGyzOdIfSE3b38BMtbIBAmg==
X-Received: by 2002:a05:6402:354d:: with SMTP id f13mr24875242edd.228.1616405420759;
        Mon, 22 Mar 2021 02:30:20 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t15sm11099230edw.84.2021.03.22.02.30.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 02:30:20 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: fix up kerneldoc some more
Date:   Mon, 22 Mar 2021 11:30:09 +0200
Message-Id: <20210322093009.3677265-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Commit 0b5294483c35 ("net: dsa: mv88e6xxx: scratch: Fixup kerneldoc")
has addressed some but not all kerneldoc warnings for the Global 2
Scratch register accessors. Namely, we have some mismatches between
the function names in the kerneldoc and the ones in the actual code.
Let's adjust the comments so that they match the functions they're
sitting next to.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/mv88e6xxx/global2_scratch.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/global2_scratch.c b/drivers/net/dsa/mv88e6xxx/global2_scratch.c
index 7c2c67405322..eda710062933 100644
--- a/drivers/net/dsa/mv88e6xxx/global2_scratch.c
+++ b/drivers/net/dsa/mv88e6xxx/global2_scratch.c
@@ -42,7 +42,7 @@ static int mv88e6xxx_g2_scratch_write(struct mv88e6xxx_chip *chip, int reg,
 }
 
 /**
- * mv88e6xxx_g2_scratch_gpio_get_bit - get a bit
+ * mv88e6xxx_g2_scratch_get_bit - get a bit
  * @chip: chip private data
  * @base_reg: base of scratch bits
  * @offset: index of bit within the register
@@ -67,7 +67,7 @@ static int mv88e6xxx_g2_scratch_get_bit(struct mv88e6xxx_chip *chip,
 }
 
 /**
- * mv88e6xxx_g2_scratch_gpio_set_bit - set (or clear) a bit
+ * mv88e6xxx_g2_scratch_set_bit - set (or clear) a bit
  * @chip: chip private data
  * @base_reg: base of scratch bits
  * @offset: index of bit within the register
@@ -240,7 +240,7 @@ const struct mv88e6xxx_gpio_ops mv88e6352_gpio_ops = {
 };
 
 /**
- * mv88e6xxx_g2_gpio_set_smi - set gpio muxing for external smi
+ * mv88e6xxx_g2_scratch_gpio_set_smi - set gpio muxing for external smi
  * @chip: chip private data
  * @external: set mux for external smi, or free for gpio usage
  *
-- 
2.25.1

