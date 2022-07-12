Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A08057173D
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiGLKYb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:24:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231991AbiGLKYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:24:30 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6972ADD6A
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:24:27 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id fd6so9498428edb.5
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K/cnNE9ZZMZ07pCp5AuI8b7IQAPHwvFLLDoRhgNELrY=;
        b=SZGudEleh5laReToRg/vOZ/EiSbg6M9+U0zI4gwS5EYcDo4FHBnkozYatd6kPeaT6d
         mPR9Trl9RQuPH64JezLUgzQ3F0JCa/ypddaV1+XtH6SUwlhbRIKJ6yVmkacfQooI5bZ8
         PiOwepi7wIdAYWwQDX3d5egGkaHZcNlCH/MCziEa/LA4KrmEKtkG450nY0UvTDqCmrJv
         7W3hGysT1nzM/NZ5SknLeZ4lTv1fAy7iCAeaxka1wdDRuN/9Py4kRYzLr7cfONpGxGKB
         /XP/ZaP9yc5JLKpmUTr4j+h1GvFxxko+FWjzwvIrZ59T9Ze8+p49XF2IUPdV/jYvtKRw
         Kphw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K/cnNE9ZZMZ07pCp5AuI8b7IQAPHwvFLLDoRhgNELrY=;
        b=JK4FUKEiW+9vM20jeimfbeglG3sOT7+2/+CzZGlDiGeOFnui0pqViBCiYqVQqoZkaD
         +dLJ2Tz2MZ5i0dYcm+mv+80F9XH2PdhTaNtzWr+PV3rm1BBH4lolJxBtXejZmW94+L0m
         0Y5YHVPRhgiCIe0ifwOX7uvvNU5x1XR+5oxl9cQAIFMy1BtJ6Ul83wfxW/rpn/UPHtYT
         BGmvT0Qm1K0jOSFuA5N4I0pMr/BUhCiIlM1KXZzPmtGbzjZP1WGoGIRivJe9ZpTMD9WA
         BaS70iukmqwMxcQoFLbw3fVt97rcdSzAchxMvGJolSj3sxyBOXJYN6nNswdnQ64bDDk7
         +B+w==
X-Gm-Message-State: AJIora89eT0GTlC8AXx3t++wg5Y3S938Rcg0//ts8X6yTjejMQNAxp+b
        AN+us5dEL0YITEoaMdGfrKHy2Mqsl4zZLTD0RaI=
X-Google-Smtp-Source: AGRyM1tgvsNOmQJQTn9q1nbp0PbnVhHq9QrBz6QtYKKKx7FLCEJg8CH3N/xu9odPbIdkQtnnJvhwdw==
X-Received: by 2002:a05:6402:2742:b0:43a:bd75:5e82 with SMTP id z2-20020a056402274200b0043abd755e82mr22907830edd.274.1657621466438;
        Tue, 12 Jul 2022 03:24:26 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906310900b0072b7b317aadsm774961ejx.150.2022.07.12.03.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:24:25 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v4 0/3] net: devlink: devl_* cosmetic fixes
Date:   Tue, 12 Jul 2022 12:24:21 +0200
Message-Id: <20220712102424.2774011-1-jiri@resnulli.us>
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
  net: devlink: move unlocked function prototypes alongside the locked
    ones

 include/net/devlink.h |  16 ++-
 net/core/devlink.c    | 252 +++++++++++++++++++++++-------------------
 2 files changed, 144 insertions(+), 124 deletions(-)

-- 
2.35.3

