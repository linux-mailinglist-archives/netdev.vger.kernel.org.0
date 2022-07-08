Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5433656B3CF
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 09:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237157AbiGHHsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 03:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237142AbiGHHsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 03:48:13 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06157D1E9
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 00:48:11 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dn9so31049864ejc.7
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 00:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fqHBe3bLKAunTEKFpLY6699tjNwNqF6vDrbdzNMuLHg=;
        b=djYI3R7Z2FVAwRcm/mqqeWmHBOXn+OYa5FdcU7083hnXebqb+to1SD3PxCDr7RXMqY
         ivC0ig58vgE1NkIG7h+AZ10ya/StOGTSGHneDB6DdmfcxHF2CAiaaxsVb2Aby3I48c8j
         vX5yeLTvSZSHqJeIb462sZd1NS0puIZyt9pS+M8dOcudQv5PkUK2KN4HMoBKXH/pO4Yj
         nREzLmX0DZAUKCHN2yctFxwTQSgM/tHnL/0Z2XQyxBbG9z1SeTRer52tkQAEfiUY8UY3
         1CwrMuhcvmB686WdaMFaZ5CcU/poRUtXbCa0kka4e0EPNk9ISVGQV9nYy8n+1A4iOLL2
         hpRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fqHBe3bLKAunTEKFpLY6699tjNwNqF6vDrbdzNMuLHg=;
        b=3mVvAGbqI2pHRgEmcMKO4IC6kZzWl0KP131T3mdjj+iyeCPi0Zg7PdsJq2oR6eDjia
         BFkfh+s4n/shD7HWfFXaVD+nLvMwoKupbaSMFoPaN5ab6y5lAk4TvAQhPmHy2hsjPHcP
         RbstP8oqzY4GhABMjDPevdMCUTltZiYHjTChS4d69IhFNQUinz6zaZYyLetpJp+v1Q4r
         y4ObPdizlE7UTFMkPjXGzl+miAzOklpB3twOdt/fKlfL+O+W278ABNUK1a3IKOmTkQ3v
         rUuUeJVJjUSRjo9A6TAmlcd9I3tmnJq8e4M1mI9eZfuXTJ7XTNUDTv+q7x3tya5ObMwn
         IFdQ==
X-Gm-Message-State: AJIora/u69E4E6oiz4HfKUMDNefoLvSSkLjHXUOkZehRUmXNDH8FHyM+
        y/KFFQ1FAOB4XVUyDQ0ic+FfkC33ueyZ8qcevNo=
X-Google-Smtp-Source: AGRyM1sMKraSz1SgLdB2OIItJraS3cznu4jC68z+ISL6CBbaFDgYLP+8ucnNwK81RVfmTJTwjL0D0A==
X-Received: by 2002:a17:907:8a14:b0:72a:facd:c058 with SMTP id sc20-20020a1709078a1400b0072afacdc058mr2244265ejc.666.1657266490420;
        Fri, 08 Jul 2022 00:48:10 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d11-20020a1709064c4b00b0070cac22060esm19850033ejw.95.2022.07.08.00.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 00:48:09 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v3 0/3] net: devlink: devl_* cosmetic fixes
Date:   Fri,  8 Jul 2022 09:48:02 +0200
Message-Id: <20220708074808.2191479-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Hi. This patches just fixes some small cosmetic issues of devl_* related
functions which I found on the way.

Jiri Pirko (3):
  net: devlink: fix unlocked vs locked functions descriptions
  net: devlink: use helpers to work with devlink->lock mutex
  net: devlink: make devlink_dpipe_headers_register() return void

 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |   6 +-
 include/net/devlink.h                         |   2 +-
 net/core/devlink.c                            | 289 ++++++++++--------
 3 files changed, 165 insertions(+), 132 deletions(-)

-- 
2.35.3

