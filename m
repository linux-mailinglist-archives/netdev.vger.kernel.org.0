Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8AD548D1B
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242723AbiFMPI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 11:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386784AbiFMPIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 11:08:37 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676BC55352;
        Mon, 13 Jun 2022 05:18:40 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l126-20020a1c2584000000b0039c1a10507fso2987952wml.1;
        Mon, 13 Jun 2022 05:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=EjcXvUgbV0BizKDV5ZMAaJIOCl44q9DK9phUniCJ9WA=;
        b=Z5oC8Q4vDMBhEWSeQHy+BSVKYHI7MQ69iAAp9fQTqZMqRBt2L8hODjEtRWS53kK3sC
         ayiAQSjdm1/wdhzIX/U8QAspFT3o9f4mleLRTJABYMDHGtku1FxrWhXaAp6HR74ADtgb
         KHods7pStS1QO5zgpbzXeIR+XuXJ2tUk2lsiWsgxqTrBTTChVrFoJtkD6I+3xzKR2BRN
         +YXU800PEL77ekt+GrhBd8ZeSeWHm47ueAy9DIYvh7OvksbFstFcPsKth0ngsWaC0ksz
         sc1IYsA5dMzwCC4Us7vkMOjzMZ0Ud14JaVZTscsYFwQpYh3VNtx7QUFi+p8QX8qQgcdC
         M3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EjcXvUgbV0BizKDV5ZMAaJIOCl44q9DK9phUniCJ9WA=;
        b=ZOqDGaSQS3P6jdUdxFhwPjOewiD7rBP4rR6Vri+icjdclKP0BgzsOQRWE9qbov89E3
         YR1GOxQeLw3XkEfeNE9rl8JGnIYOkQ3imtvfNhs7IQJNLQQPan/VYgYr+wq0qqe/zrmF
         hJLNSYzoyTv6qq2nD55yiVmXtrxe6Q6fkbVrMSltnj9XaozmxE04FsKdcBss2+Yda9v+
         FSYzKDvH3gXCV91OE/f6pBkhRH8VIhVA6bJiR6cCUKjpK5KUR023WEw8N32rc5+5QfAy
         SLkP7Rca7cVpXj45ORFoN0NkurMKuH+0sLU2rFrY1Ta+HS2keOBT2WP0cAFXfKIaowQe
         dqiA==
X-Gm-Message-State: AOAM531p5qFjRUb5NbDf041v7513JmmI5uTmTtZMfQPoQOs0r0yBWfTC
        47W+G9xNsi0xQrFkeRt6Bag=
X-Google-Smtp-Source: ABdhPJzkW71et/oNTf9zQrLlteUGEe7q964KCfykwMojUNjG/zlIoi1TNyv3IJfHsijBCiVrOlzrbQ==
X-Received: by 2002:a05:600c:511e:b0:397:60e4:8ceb with SMTP id o30-20020a05600c511e00b0039760e48cebmr14650103wms.204.1655122718827;
        Mon, 13 Jun 2022 05:18:38 -0700 (PDT)
Received: from felia.fritz.box (200116b8260df50011e978c0f780de03.dip.versatel-1u1.de. [2001:16b8:260d:f500:11e9:78c0:f780:de03])
        by smtp.gmail.com with ESMTPSA id h9-20020a05600c350900b0039c4d022a44sm9833413wmq.1.2022.06.13.05.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 05:18:38 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: add include/dt-bindings/net to NETWORKING DRIVERS
Date:   Mon, 13 Jun 2022 14:18:26 +0200
Message-Id: <20220613121826.11484-1-lukas.bulwahn@gmail.com>
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

Maintainers of the directory Documentation/devicetree/bindings/net
are also the maintainers of the corresponding directory
include/dt-bindings/net.

Add the file entry for include/dt-bindings/net to the appropriate
section in MAINTAINERS.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
David, Eric, Jakub, Paolo, please pick this MAINTAINERS addition to your section.

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6bf0c0ff935f..42fe1352137e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13868,6 +13868,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
 F:	Documentation/devicetree/bindings/net/
 F:	drivers/connector/
 F:	drivers/net/
+F:	include/dt-bindings/net/
 F:	include/linux/etherdevice.h
 F:	include/linux/fcdevice.h
 F:	include/linux/fddidevice.h
-- 
2.17.1

