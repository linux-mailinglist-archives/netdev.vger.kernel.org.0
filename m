Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75545665237
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 04:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbjAKDR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 22:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjAKDRU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 22:17:20 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FB813D29
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:20 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cp9-20020a17090afb8900b00226a934e0e5so2647982pjb.1
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 19:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JuJ0jyh9SuVXUDjBJeCc/AYMZcQQVMpyLQtigbol/jo=;
        b=BW1IBRyp6xdkdg5tweSkCWbW+Hc27v+OrNxp8oBUSa/79PS3Ix3dEiaJ+cTgpA6nDP
         tcp8RULdLAQ57nuWDPyhZWu0hA+yHpCM51qgsc1tqUVgkbjQfZyAzIL6ZKNT8WZcufaO
         A4f8PJd7u3Jjmir/F0ypKeDCrfV/eA7FFeBlOjyu2zHMpMazAQdkA+WAdgJBMKDB82rN
         cpg5vlgj4dh6cYak/NfaJvVkKW2n0BiY5gHtYzGNj7l63sjF7v7F6U91eMnfU8EYF8aO
         BhfxJoEvVT2DQqjq7XrKNw/T6xUnEDFqVQeCMj8XoVXJy8SKDafNZOpMnZXuZTZ4vlaQ
         Q1LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JuJ0jyh9SuVXUDjBJeCc/AYMZcQQVMpyLQtigbol/jo=;
        b=CbeibXuHsN276SiZs8tr8g2g/mE1RgvfNu1A0PelkYV6qp6v0F7U8wi+kCinXRbXS8
         /DRBS/aUl9IPDP6eZ8Cc5u+nqyh9vQPvjbLaAxwUxZ8GZv85u9e9ZP/Ran6oFzZRoOcP
         HeomfEn0KUAHbhz49o+9oZ+nJVrQAxv4BYYi7TzSU1gw+GYiO/3I0V6RFORQJuBfZjNb
         4UnEQlvYU1e4brEo7JMsvO9T4MT3N8RzI1Scjet/bKZEwoPXriJkiHJIoHnzcD6IuQh4
         7eDwzJw2KLTBMdnw7bvtI38kDpaI2e5VYgfAuyjuzhzm6tGfFxzLztpheA9ONcQ7HPBH
         6d9w==
X-Gm-Message-State: AFqh2ko6q46dQIMy626mubDkUZSI5BmN8bwXo6sHzfy42wMUBb1iTlR+
        3CC82uCtlGgAmt4k9DCJU4jFVU+afHCti3KKTXY=
X-Google-Smtp-Source: AMrXdXucT+OlcGFgLLSWGxNsjybJv09i9bE74p1BL8TAGVcZigrJni3f5XN1LsgJjNrzolCSsuiP3w==
X-Received: by 2002:a17:902:e491:b0:192:a470:2c0b with SMTP id i17-20020a170902e49100b00192a4702c0bmr933384ple.49.1673407039564;
        Tue, 10 Jan 2023 19:17:19 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id h5-20020a170902f7c500b0019337bf957dsm4226756plw.296.2023.01.10.19.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 19:17:19 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 06/10] testsuite: use SPDX
Date:   Tue, 10 Jan 2023 19:17:08 -0800
Message-Id: <20230111031712.19037-7-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111031712.19037-1-stephen@networkplumber.org>
References: <20230111031712.19037-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace boilerplate with SPDX tag.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 testsuite/tools/generate_nlmsg.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/testsuite/tools/generate_nlmsg.c b/testsuite/tools/generate_nlmsg.c
index fe96f2622047..106dca63686f 100644
--- a/testsuite/tools/generate_nlmsg.c
+++ b/testsuite/tools/generate_nlmsg.c
@@ -1,11 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
  * generate_nlmsg.c	Testsuite helper generating nlmsg blob
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
  * Authors:	Phil Sutter <phil@nwl.cc>
  */
 
-- 
2.39.0

