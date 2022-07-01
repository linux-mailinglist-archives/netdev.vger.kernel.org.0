Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA7AB563825
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbiGAQkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiGAQkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:40:12 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06CC44339C
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 09:40:10 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id o16-20020a05600c379000b003a02eaea815so4313493wmr.0
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 09:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ri98ypmJZ7g2CKn/e80LNMmoZ2ulVGc4ehtOZllBYMU=;
        b=jZC/0fRQ/N3l40ZJDq/pIpcmtCZcbmkNzTuz7rverX43fv/34rOzPiA15MCmc+xbuq
         0kpkNzvBmDa3lN70fPPfxA+bBzW9JcJyozsUPVlB99T7pHD4Zp5j08WgjJ7kvKllfd68
         tBbyT0cI3W/aucKV1S9qCs8nACrGSZ0BxPhWoQwnu189SY3c8J0SnBah+YKyUcJeUqwI
         m/nk/a2wytNCffW0cVncOTOske/+vhV6/Fvreri0NzMBlceONHX56D6ZBD3TIJRBgqoM
         s6I6bSin0t85z1Vzjgon7aQ/DHM5d+/mUIJ/R1UOaK52ViepQzyLtkw3Bb/aSeID9/ZB
         QJvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ri98ypmJZ7g2CKn/e80LNMmoZ2ulVGc4ehtOZllBYMU=;
        b=vFGNpmvSImG4B2r94+Gl8VXPmAzIKp+PtitnoCt+gLxVgnQgFGxVBj9DBMB1ZrrdE/
         ou/aXY0pGwvg6VAEonZCHsmlToYjX21pXBLjklLBJxDtbge8T+mIxKHHYVCbvQp/VQKj
         IuWKAtmyQ2F9ttfldk+26UAM2lCprf7G4S7YSrvfIcYNRdIYsvCO+5TZvLYdg9RrdE1a
         TQoLiDpPnSTpczgVYVMR3SfoX7JwQzNZdHmhGfuwr6vFWn7BE7DvxSatqXWI5stdwXRk
         bSVGQx0amtXEtzKxN5CidX7qitac6PALYuQE33GjuTw/FkAZ/oeZ/Fh1RqO4u2iesT59
         ECTA==
X-Gm-Message-State: AJIora8PqmBwQ/ks+JUPRNk82JDPlZjWQWwVDQF2HcSbNzcSg76FxyFO
        IAFyMNgCDNl++bmWfAb3LiOdNd2dtQiCoiec
X-Google-Smtp-Source: AGRyM1v0X8+2gZ0lDPL6mS0fkQpGJG6V6uGUfgV5gbGgskHVoCUqBN9UEyg2hRThnOS6Vcy9zAI4ww==
X-Received: by 2002:a05:600c:210a:b0:3a0:3be1:718f with SMTP id u10-20020a05600c210a00b003a03be1718fmr19221166wml.181.1656693609419;
        Fri, 01 Jul 2022 09:40:09 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z18-20020a05600c0a1200b0039c45fc58c4sm11009880wmp.21.2022.07.01.09.40.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 09:40:08 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v2 0/3] net: devlink: devl_* cosmetic fixes
Date:   Fri,  1 Jul 2022 18:40:04 +0200
Message-Id: <20220701164007.1243684-1-jiri@resnulli.us>
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

