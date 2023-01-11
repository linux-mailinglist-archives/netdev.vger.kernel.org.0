Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C3966631D
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238218AbjAKSwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:52:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235757AbjAKSwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:52:36 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AA33C71C
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:35 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b9-20020a17090a7ac900b00226ef160dcaso16477033pjl.2
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:52:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JuJ0jyh9SuVXUDjBJeCc/AYMZcQQVMpyLQtigbol/jo=;
        b=74+kTEJ9WsORWRLTThdPdZTktWtY2VD9vZwCWBhhxmMuUWIZsWdz9NPBbKIw75mmEN
         noh9wXDm4/bvEdkDiLxPHij2AYZVygmN1vTbm+4+lfSwy9ZcFU1ce8Q4v+yqh8eV/efR
         /soEkleeFa2TlsNx8IvM/AfOscnefR8vptFVPvyjStQ8ypyDlqQ8pZbiLqu9CbBhGoFk
         7AOuJUfDHHRN9e3B6hWtv0JOWY4sX/G0ENpc1JslX49zmFsWBLM190woqPWlpJFpUxrT
         5kQHDxIS1w2bdoFdd3HqKF5OFn/z+os12eSCsjbsK0gQXlQytNsqJhklsGArY6XtIA0J
         27KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JuJ0jyh9SuVXUDjBJeCc/AYMZcQQVMpyLQtigbol/jo=;
        b=VU7NfH9s8kyqy02nd6H1KMZa7EyJn4Kyi8SldX4gd2wHcZd/jSf/nwgOHQgBPpSgdg
         Hde2z15HVhKV4Vc2HzVflM9z1xlTR2z23ePdHXvRWjOl0YZB7UOi+Dyx62w0n6vy2m+T
         tuXLkETKPEn929FU3OaHwioORsAOj4/oIVABt7KETy+I39toupHHWQYYR6m4xl8FFIxt
         yKv/E3HlPzsYlXv8v/GrgsGffaybBgLCncHXyFWUjCvg0D52J81YW3p31KJhGkc7VaOr
         2axulx0zMlAshLJVaC8/w06uGeU7LW896RDcvvlkjXv9rINVrNJ3HztSnuBsqY/R8eKY
         LpYQ==
X-Gm-Message-State: AFqh2kotda6e+VmS+EXSPeO+SFO/HKbYVejvboluOOOZIpultMDI2fXI
        yNoLs/FtRY7UtalpT0m2C06gbmR7cUe5v1OSAB0=
X-Google-Smtp-Source: AMrXdXubTs6tp9Gx5CbIneRUcqProqJnyj1xBGouFakCZ7GIvJoE9m6heUG7wnDVCA2gC8vtKVlvkw==
X-Received: by 2002:a05:6a21:9218:b0:9d:efbf:787d with SMTP id tl24-20020a056a21921800b0009defbf787dmr87247339pzb.50.1673463154412;
        Wed, 11 Jan 2023 10:52:34 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id d7-20020a631d47000000b004a849d3d9c2sm8650447pgm.22.2023.01.11.10.52.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 10:52:34 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2 iproute2 06/11] testsuite: use SPDX
Date:   Wed, 11 Jan 2023 10:52:22 -0800
Message-Id: <20230111185227.69093-7-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230111185227.69093-1-stephen@networkplumber.org>
References: <20230111185227.69093-1-stephen@networkplumber.org>
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

