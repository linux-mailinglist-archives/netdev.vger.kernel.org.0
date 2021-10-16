Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7425430077
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 07:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239709AbhJPGAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 02:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbhJPGAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 02:00:34 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A27E4C061570;
        Fri, 15 Oct 2021 22:58:26 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id d198-20020a1c1dcf000000b00322f53b9b89so86990wmd.0;
        Fri, 15 Oct 2021 22:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=68eNOtWppTlKiNDzdJ7rYhaZj7B9d5e+FYeQLVcNMSo=;
        b=D+nlQfc9DYD5+coGuBtTTUZqQFt/wx4ryYCCFquF9XNFWO1QbZlhkldAK9VdHKVtKb
         5ddbqnhObEXe5UgDqw5G+VtgReb9wdJqBixOIHgoB6zqEtsd6JpATx7Knh1DoK+IEoKg
         gr0uP1w6wry+fmPoSjkpUYfN5p1UhHwNEmU5jW7KVvgmTL97ogxkdULB3w4Dp0okFBlV
         YJZdtB4K/TjDA9OYDMAFcruwdv53iFGDc/567GE2hZdJHRbVJMaI0Aepwbt5vDAnX5La
         8IgZULKjwtelcOb7lSSkjKI3lyQcNuZu+M28SkQKyliOvY5mbR1SqpWa5XdyRt0tTw0O
         BNTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=68eNOtWppTlKiNDzdJ7rYhaZj7B9d5e+FYeQLVcNMSo=;
        b=fAu5r+kBBF8sFgESrfZBDLXOFcw9sWtJ/KLRRdLHY7w/8shcioF5hlofI4FOzeaJuE
         A/Se8Td7XAvlZHxxBPGfDriWxd0BIWa75khNDG6UgJKCKGAFx7z7Pk9bZ4UqpKTloRML
         KUXFHF61X/2P2oGrxghvi66bmvqWEks8jwmkMa4aSB2ZXqRghak0BDoj6e92tMYBrdQv
         Yc9jgAQSplKVVFIiWyvPxf11tE6T5H+fmuO/JegufM3WA+nt3T9Rf5sH2jMeovDXYmGg
         loTsJjWk4CLdK4A0LhATjQYLhf65E1ZftunTLTPTgzMkHofIQDqerSfjO9arTsRJighV
         xx3A==
X-Gm-Message-State: AOAM530TO1+H3KJHJ9/ibWf+LXLBAMDzzK4OAqs8SvMA1sZ/Gc3eowcn
        GgugXe2HRtHalI1jw83MB3I=
X-Google-Smtp-Source: ABdhPJwU5Fum1Kw7UkbSQHzfGpIqocSyY0NqH3rqkuvQXub5yuDceyboyg7DhZSOPO17hhUSFqjnFQ==
X-Received: by 2002:a1c:1f0e:: with SMTP id f14mr1246663wmf.65.1634363905217;
        Fri, 15 Oct 2021 22:58:25 -0700 (PDT)
Received: from localhost.elektrobit.com (eth1-fw1-nbg6.eb.noris.de. [213.95.148.172])
        by smtp.gmail.com with ESMTPSA id z2sm6487523wrh.44.2021.10.15.22.58.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 22:58:24 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: adjust file entry for of_net.c after movement
Date:   Sat, 16 Oct 2021 07:58:15 +0200
Message-Id: <20211016055815.14397-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit e330fb14590c ("of: net: move of_net under net/") moves of_net.c
to ./net/core/, but misses to adjust the reference to this file in
MAINTAINERS.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains:

   warning: no file matches    F:    drivers/of/of_net.c

Adjust the file entry after this file movement.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on next-20211015

Jakub, David, please pick this minor non-urgent clean-up patch.

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 932699757201..0b69e613112c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7085,7 +7085,6 @@ F:	drivers/net/mdio/fwnode_mdio.c
 F:	drivers/net/mdio/of_mdio.c
 F:	drivers/net/pcs/
 F:	drivers/net/phy/
-F:	drivers/of/of_net.c
 F:	include/dt-bindings/net/qca-ar803x.h
 F:	include/linux/*mdio*.h
 F:	include/linux/mdio/*.h
@@ -7097,6 +7096,7 @@ F:	include/linux/platform_data/mdio-gpio.h
 F:	include/trace/events/mdio.h
 F:	include/uapi/linux/mdio.h
 F:	include/uapi/linux/mii.h
+F:	net/core/of_net.c
 
 EXEC & BINFMT API
 R:	Eric Biederman <ebiederm@xmission.com>
-- 
2.26.2

