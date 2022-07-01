Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F58D5630D6
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 11:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233002AbiGAJ7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 05:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiGAJ7b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 05:59:31 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AABB6B279
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 02:59:29 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id e40so2308857eda.2
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 02:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ri98ypmJZ7g2CKn/e80LNMmoZ2ulVGc4ehtOZllBYMU=;
        b=bbDWPrRKyZc2b6AqsEGpsOoYN9YazcT55BaCjA9A9AluOARxueUmRmWGf1CMFEsmLI
         MsYmnUl2jpX0vLABH9Rskz/+C6ag4BuPby91bQyk84DQWnj2O6IFzw2gKImTVG/bzagl
         Tt2onzhyUFv4Vn7Y3ZE25ozbfB9LgLDMX8m5HtS2qSlZn8jBTH+IywPoinUqT7u3ElsE
         jBqpWF+NCp/LTzyveQmKtYJ8HGQMF/CEm8Q2NNgddRF6rKRbSCcwEfhry6J+IFOOLrjA
         sF75QvSyLcbVJ2FVhPiOUCoafPB6JqDFX9BGJSRFi0abV8PGC7vEHxjDNq4kbNR4pCWM
         Bavw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ri98ypmJZ7g2CKn/e80LNMmoZ2ulVGc4ehtOZllBYMU=;
        b=XjmnAyE0AatSZ5opU0oBdqsP/AieLVnDpjS1llfW8rLynsbxEYioMHtZl7Ab8pCN2T
         NZ8C8CB+0NtxpBV5LfGu4bo3jqzxtSfZ9LoBn1Q9s2Z3qLWgfw5tR0POxGteEXXfGB1n
         2YFBw8ciMyerPMTjuzPxSV5+0Vf9cnzLE69PO/vKl/FwAxo8sQCf0WADkL/VTsS2rytn
         oLsQSMao/1tO18a+zfln5TCi50IvQ4DIRGie2yrnJq8mTiAar6L1go2SMW8ACO6w1CQ+
         +JYZTJLA7mO2VVo9LmlTuv0asdhgAeJYBc2nnJfpnyy3quZx6HwHUTcE6auOGMIBTQRw
         w0vg==
X-Gm-Message-State: AJIora84sr796S4uZDyYzXJWOT4g1iFLfC8Gq04x//WYwD9PJkJpHnWH
        iJi4oaDrlc9/mANmSRjGiMwT9Ygtv2xIb6cM
X-Google-Smtp-Source: AGRyM1tjLUZp3NhqBDClqw5K5I1u6rWRksEVC+SJWzuYgKIkNg+Y5+YQaDkjPhufZwnjNsDaVjNCfg==
X-Received: by 2002:a05:6402:c95:b0:435:8113:1276 with SMTP id cm21-20020a0564020c9500b0043581131276mr17782292edb.193.1656669567747;
        Fri, 01 Jul 2022 02:59:27 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id n6-20020a509346000000b004319b12371asm15051253eda.47.2022.07.01.02.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 02:59:27 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next 0/3] net: devlink: devl_* cosmetic fixes
Date:   Fri,  1 Jul 2022 11:59:23 +0200
Message-Id: <20220701095926.1191660-1-jiri@resnulli.us>
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
  net: devlink: move unlocked function prototypes alongside the locked
    ones
  net: devlink: call lockdep_assert_held() for devlink->lock directly
  net: devlink: fix unlocked vs locked functions descriptions

 include/net/devlink.h | 16 +++++++---------
 net/core/devlink.c    | 42 +++++++++++++++++++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 12 deletions(-)

-- 
2.35.3

