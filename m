Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6F95B7A5B
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 20:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbiIMS7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 14:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbiIMS7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 14:59:15 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AD230D
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 11:53:27 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3456f5246a2so109668297b3.2
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 11:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=drAx9HubthNj/Kb7Ke97XrK88MZ4SRc9eVdY+Rb/Yto=;
        b=DheuZnibhRau92agY1jQErSMbaYGMtM3NDx32MFSihuQxDJ4YPqdlu5Ef0xZroPDOH
         AN8bC1g8vCRmrWK3/328g1SvL54YP7lw/Jnp+rbopRQJJYpwdAJlMjtmF9bnC/F6Ckjj
         dY7MSRk+tR0ljukuKf21y5Tx1xDrBdI++DAVZ9t2K+O4XZcNu8S4Nest6Q4aEt+V3Phl
         REUjxtyCAhrSmny5EGKr1ELoA7x8jR01898SKqBBh8bIOzjyrxU9Ag9yYLYY0K6VijGr
         /5rnsGoVOkNXEPnqSRorYYKVIRvvnggblWkNXIheypgjFKMSmW7KUPMNsQqlYXcW1Lts
         M7Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=drAx9HubthNj/Kb7Ke97XrK88MZ4SRc9eVdY+Rb/Yto=;
        b=lMjpuUFgDKF1EGNxa/5zf/hanxEy4pDQJzD/489PhejVxRPmO8tvRylYzpxIdeICSf
         SdcDrCFFbEMrNwBmGb5fSfnotDXy+/Sb48+AuW4mtTMxuaJDZEmygoNymuVxKQ+n0cgV
         JVK4rhGLAImrpO9RkoMxuLy5dewmFiCydMCVPwWioAqo0VHTraDfctp/AuLrWGyMRcOf
         hoqfmq648tlOJOqKVUscYufEEAFnJQP1hPkworXoMazkDwwXLVbv3VPZy/KpSFMEefgy
         E6PwZ1WSXs2qn/gvXmBmh6cw9UCYeWRUm7InwqCoBxprk3cDdZo5kawiuXtluqUjehkI
         vdrA==
X-Gm-Message-State: ACgBeo04VEXmr1edaaRZ7S7wURAOrGWTAp7In6wfEZQdLt1iskDUMZwN
        AdqNh/6Bf48z92zEVrl4+q+M3iukFbxaGySZSGkALFjf8Xkym9NEySnAb742bw1duLsSZAqxsf+
        MKoTQhjvK2RgmzQSeLioxJXysaiMK7O8/QLQAglg3Ip6+jmuQEY7RDUjMDsmeUFsUbRI=
X-Google-Smtp-Source: AA6agR4ALoeyoDiN/Xg65uXN/3a8Jn2vUzHuSMIgFAGLCKdP1KXLhZ7n6oF3pjPjoHPsIkr8ZhbMhU+q6yGXrA==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:1504:9ca0:f340:6160])
 (user=jeroendb job=sendgmr) by 2002:a0d:edc2:0:b0:338:957:a719 with SMTP id
 w185-20020a0dedc2000000b003380957a719mr27963621ywe.132.1663095206940; Tue, 13
 Sep 2022 11:53:26 -0700 (PDT)
Date:   Tue, 13 Sep 2022 11:53:19 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220913185319.1061909-1-jeroendb@google.com>
Subject: [PATCH] MAINTAINERS: gve: update developers
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jeroen de Borst <jeroendb@google.com>
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

Updating active developers.

Signed-off-by: Jeroen de Borst <jeroendb@google.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 74036b51911d..0a8354e31455 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8652,8 +8652,8 @@ F:	drivers/input/touchscreen/goodix*
 
 GOOGLE ETHERNET DRIVERS
 M:	Jeroen de Borst <jeroendb@google.com>
-R:	Catherine Sullivan <csully@google.com>
-R:	David Awogbemila <awogbemila@google.com>
+M:	Catherine Sullivan <csully@google.com>
+R:	Shailend Chand <shailend@google.com>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/device_drivers/ethernet/google/gve.rst
-- 
2.37.2.789.g6183377224-goog

