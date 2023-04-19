Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7BA6E82FF
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 23:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjDSVGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 17:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjDSVGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 17:06:05 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1B359D8
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 14:06:05 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-63b5c830d77so167006b3a.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 14:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681938364; x=1684530364;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jKNaeM2qEEQE2N6l0zhnkw5MRiIWrtYf5MSyVzaJqTw=;
        b=SKvorINvxWJONgSbsnWoMgRyQzGUxCR+r1/Aie73Hpho0E85lXhICzWoK4hEbUdvae
         aI70d0MO6hdhTqyxBcFPXR8CZXl+db4CuWwCIbfBFCeDwInWcq37Hk2/YhvqDt8w1fqh
         xhGAxOofWA3Te2idlgEHI8AAIZ6lPMb0XNQk93wtWWvYWkLAc7/uIOrZ0i1oWWvCG1u5
         M9w5lv+jAWHNUfqHbTX9Id3xGC6gzxtK/KXv/2uf3J03+T1VRgf8klVApGr+mbAW1rY1
         nQdqFasWu2H9VM6k7mV8puLUWh805vXPUmuJcUd2cgME3h9Cyys0980loiGUz4EYPC9V
         eY5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681938364; x=1684530364;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jKNaeM2qEEQE2N6l0zhnkw5MRiIWrtYf5MSyVzaJqTw=;
        b=icRw6fSehmCVcwWkzBQmeJuSZupliRSXQiVV/RKW8Hh26Wo44N39ue3OtTL5UPB7TX
         WgdmaYC/9ae6Xya29wH9zCW9efRyDc68Br2XeDUYTfdtDZ/i/CeWZUqgOpnevYm1Len0
         QW/WVk++ECADEJKYQnn8OY5MIFb1OzG38LGg32yM+6HxIgn5yK8rboyyP8KPLt6wE6i3
         QOvDO9yCAtQYmOrvZMKuk0JEeruVzMi8kwgjUft1HMv2a/o3F/HK5z1bQmT9va2VWv0U
         KqGq38Z0jVD6GM2h7r7ofc+vnR+eEjRJ6G/7DpPshGRswIyTPmLal3iTRQafBvUk60no
         uUEg==
X-Gm-Message-State: AAQBX9en2GE+08EGva07/54PoOhs5nyEedgE57HKuAVLqGqaIovkrKIp
        MyZAJQUje8tLlhTnyhlG5E63+CPIBXNxyNj+v1Jd5hb8cqqf+DNMsH2xjwKUY+pMAt9umKagHOh
        iRVR4zdPj63IuV8X/6ndai0cLSmArETA3TZT+Mis5mBLoZHfjb5q/W73mjzkG4NIg71g=
X-Google-Smtp-Source: AKy350Y1J63qKf8UwbYIywa7Roo7V3NPwTUDK6T71ASNey/5Wd2J90den3LnR+uZcZgPISUeSbbxw5Txqfqucg==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:597b:54fd:b74:86ff])
 (user=jeroendb job=sendgmr) by 2002:a05:6a00:9a8:b0:63d:3f94:8c3a with SMTP
 id u40-20020a056a0009a800b0063d3f948c3amr2323897pfg.6.1681938364406; Wed, 19
 Apr 2023 14:06:04 -0700 (PDT)
Date:   Wed, 19 Apr 2023 14:05:58 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230419210558.1893400-1-jeroendb@google.com>
Subject: [PATCH net-next] gve: update MAINTAINERS
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jeroen de Borst <jeroendb@google.com>,
        Praveen Kaligineedi <pkaligineedi@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reflects role changes in our team.

Signed-off-by: Jeroen de Borst <jeroendb@google.com>
Signed-off-by: Praveen Kaligineedi <pkaligineedi@google.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2cf9eb43ed8f..d690238df51a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8820,7 +8820,7 @@ F:	drivers/input/touchscreen/goodix*
 
 GOOGLE ETHERNET DRIVERS
 M:	Jeroen de Borst <jeroendb@google.com>
-M:	Catherine Sullivan <csully@google.com>
+M:	Praveen Kaligineedi <pkaligineedi@google.com>
 R:	Shailend Chand <shailend@google.com>
 L:	netdev@vger.kernel.org
 S:	Supported
-- 
2.40.0.634.g4ca3ef3211-goog

