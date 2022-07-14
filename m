Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA7C2574D54
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 14:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238850AbiGNMVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 08:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239007AbiGNMVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 08:21:03 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0320F402C0
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 05:21:03 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r18so2147036edb.9
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 05:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=iLw4PnyDgxQXBO7vP0k8Qq31GC4PTjLZIP0746xMMSY=;
        b=BZJgF1hE6E7r0Z2+wteo2fP+txQstk38Yrfvmiuk6rD+PDShGzzPfRgwx6OGoDTpLx
         3P1W2ZxiLpwuGQE0CJZjqWe1joOG2dAWqzcqSrgRRiHN7Iw8lBt+CMgZ8cuKbAhBgtfT
         O+FTpd4DS4qQGUCcJXLOr4s0zPbsExEZerdIAdXdEcQTdRRzbx1mjnNl6SJ1cH+zFlL+
         x1GRc7Col3xAiguvYfbHU4EGMJ6OHwmPbkC1KNQmI69z0qIXccd79mTtSbrtQNEvzZjc
         oRXCySsAU2VZZyScZofLhVOxGpVyh5qmS2gyx+GuaKBooT1Ee9zuXDVCg5PXC1tocPJy
         yV3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iLw4PnyDgxQXBO7vP0k8Qq31GC4PTjLZIP0746xMMSY=;
        b=zt6n30Ske0C3vrhFaWcuZnE/Y+WAYjfKtH13c0ByScChYVM9gM0ff5LaagT8dVGyRv
         px07ffA8Tlrh3eCAybLuu/vCRF3yUjRiw7tOPYJviaDdUAD5Eb/h5DFmPAypQpB/oAct
         J2aTgcywnuGVoj00oZGClGdYGunO0cH8W7ChR3vS15509JeGvWTBBumibVXhy5Z3lSN9
         TiWEPi6LdSP3hCF6s9nmT0JiqOOkNDXIUUH0DBevy7KAQNfnbTW2HGuYLPDyTozkEqUJ
         fV5lIzTObbV+sa5sHLoJA+MIvgJsbXtv2rVOnZSTE5sEDY/niw9H4JglWEJGVBEnswA9
         uIaA==
X-Gm-Message-State: AJIora8DDLqGBWCEAuDVGJSIFaOX9pG/Xf4yoY7rcaxQMidQTSm7oA0g
        ohYb9lD/PP6u3+DPE5VWgaMXjLdNkGwECQ==
X-Google-Smtp-Source: AGRyM1u9ZGjdKzdJNf71DvWgJYGUA8YBpKGXg6aKzoAUxm895h4X3Dg4/HA2EVRkc4G97MnQqqV6iQ==
X-Received: by 2002:a05:6402:11c7:b0:43a:c61c:21cd with SMTP id j7-20020a05640211c700b0043ac61c21cdmr11866800edw.108.1657801261398;
        Thu, 14 Jul 2022 05:21:01 -0700 (PDT)
Received: from development1.visionsystems.de (mail.visionsystems.de. [213.209.99.202])
        by smtp.gmail.com with ESMTPSA id gr19-20020a170906e2d300b0072b2f95d5d1sm647402ejb.170.2022.07.14.05.21.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Jul 2022 05:21:00 -0700 (PDT)
From:   yegorslists@googlemail.com
To:     bhutchings@solarflare.com
Cc:     netdev@vger.kernel.org, Yegor Yefremov <yegorslists@googlemail.com>
Subject: [ethtool][PATCH] gitignore: ignore ctags generated tags file
Date:   Thu, 14 Jul 2022 14:20:50 +0200
Message-Id: <20220714122050.7997-1-yegorslists@googlemail.com>
X-Mailer: git-send-email 2.17.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yegor Yefremov <yegorslists@googlemail.com>

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 0b7a71b..2679fae 100644
--- a/.gitignore
+++ b/.gitignore
@@ -31,3 +31,4 @@ test-*.trs
 .*.swp
 *.patch
 .dirstamp
+tags
-- 
2.17.0

