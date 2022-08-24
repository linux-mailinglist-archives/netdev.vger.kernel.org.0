Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99E2F59F457
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 09:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbiHXHaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 03:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiHXHaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 03:30:09 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 105081AF10;
        Wed, 24 Aug 2022 00:30:08 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id j21so26421308ejs.0;
        Wed, 24 Aug 2022 00:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:subject:cc:to:from:from:to:cc;
        bh=frTSU7CT1BzKyl2InjoRMay3h4xHHePZ35QzJ/J4sjo=;
        b=BVW7Uv3LPCF4OiITg6jwY/hWzYJm2zmQ3+tyS0uUK0jTEuOsdLdOGe1TR8NzKaf95E
         ijSAtOYkCSEqkR0itf5RFz68l0RUqnBaIX5mgTS1dHZLej3cTNkC2cgA3b1mFr7nBHGj
         UE/L2E4IsAYzXC36PC4oZwy1RBnOUytrPgmYnXLSXorLTk1uWbk4SNOYngkr5rISySdi
         JLMomZZEXZTrMPVttVXbnxBwCMgK6hVUwgrDivOXP8LRYDI/KbO1W+fAO5obJp+LpAGE
         T7g4Xta3oaTeiteELHw3wOGd/mevPG75LpLC8TnEdW+F6Cay26/OOJNolh4/mxfYckrQ
         zCnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=frTSU7CT1BzKyl2InjoRMay3h4xHHePZ35QzJ/J4sjo=;
        b=azKSzew70rz34V5UFcY/fqgs8niAyNHDzm3Ukx2cWZkXejpDYkC0JWbJgeDXHUHdPR
         UblglhAB2YhaFBj3skSJbkjHNYy40HvbFPh2V5rVZESyVmXRZn3DYMjRckhQyL5iJ+zV
         9rICFEy8ncnIZLCdIXNjzYfuz0V35dzcis6ItRxklyxbxh62jZMZdpwoiKcumk9JN43x
         Uv+62wDG9UzWPHyIBuDiLOOcfRIYxPjHoOqpSAFh9fZeA6RfDYDDsDDMIrIay+uGfwKe
         mWCkTBAj1aMi5i74DjGwZB8kLje+ua34oYtBR8AifP0/ZoLFpQgvI1cHznTmBkyr7wGk
         j0eQ==
X-Gm-Message-State: ACgBeo3uWct61CHUgbSXS3a4Yy6d07LyCio9oYpJOGoQZhEI2jzJrcnv
        X/s7lJIoP1OGGuULdIAjKqY=
X-Google-Smtp-Source: AA6agR4rttHJ3vF3gaXt7ZgoL4xA3Vm4qmQtJTGKi29tFwmhMMZPk4Ay9kkPe8Mz7gGLfJg1L4dMJA==
X-Received: by 2002:a17:907:2894:b0:73d:9072:ade5 with SMTP id em20-20020a170907289400b0073d9072ade5mr2081859ejc.2.1661326206434;
        Wed, 24 Aug 2022 00:30:06 -0700 (PDT)
Received: from felia.fritz.box (200116b82606de00690367f10e5093c9.dip.versatel-1u1.de. [2001:16b8:2606:de00:6903:67f1:e50:93c9])
        by smtp.gmail.com with ESMTPSA id i23-20020aa7c9d7000000b004463b99bc09sm2531537edt.88.2022.08.24.00.30.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 00:30:05 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Jonathan Toppins <jtoppins@redhat.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: rectify file entry in BONDING DRIVER
Date:   Wed, 24 Aug 2022 09:29:45 +0200
Message-Id: <20220824072945.28606-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit c078290a2b76 ("selftests: include bonding tests into the kselftest
infra") adds the bonding tests in the directory:

  tools/testing/selftests/drivers/net/bonding/

The file entry in MAINTAINERS for the BONDING DRIVER however refers to:

  tools/testing/selftests/net/bonding/

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
broken file pattern.

Repair this file entry in BONDING DRIVER.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Jonathan, please ack.
Jakub, please pick this on top of the commit above.

 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2ce15257725b..7d2141516758 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3671,7 +3671,7 @@ F:	Documentation/networking/bonding.rst
 F:	drivers/net/bonding/
 F:	include/net/bond*
 F:	include/uapi/linux/if_bonding.h
-F:	tools/testing/selftests/net/bonding/
+F:	tools/testing/selftests/drivers/net/bonding/
 
 BOSCH SENSORTEC BMA400 ACCELEROMETER IIO DRIVER
 M:	Dan Robertson <dan@dlrobertson.com>
-- 
2.17.1

