Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81A4682845
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbjAaJKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjAaJJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:09:40 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD8A19F37
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:06:20 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id n6so11065572edo.9
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bWrX9SkIivyz/G8l34kDmvVlJWCmC5g6Fo8uT/mNizA=;
        b=j+Fzv+n8xhjLPm236CGYggzxGkx4Jb6qdwtQqehayts066/exXl7hpIJV2CqrWWhHJ
         XiK3aBmbwjFGFMfuFN7FWus0UuORwb6UJJC/umL4yB2ZjWdCPdyscSwbebFkibWs//iG
         YMBs8Vx0H8fs4umS9WDScwkbFiUzvYSL1UlbTyN3gAKul0NYt6koKffcqc6ALOatt/sR
         SnBp822pIl1tG2cN0Gm9y9FpNwSfAKhZiWFnpvRB0YNe4JhvmGbmFXrdqSLMyX6DaHkv
         sUUV2wMXSF0NhGh/KwC/agTEBcvIWL7K4eRURGMN1QnOdzgB16i4ep2vrsD12rHL7AV5
         W4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bWrX9SkIivyz/G8l34kDmvVlJWCmC5g6Fo8uT/mNizA=;
        b=6HjmScznCT1nLlAC10b3k0oFOGKRoTrAJ3qt15DNnZB+RcoaAMgPdeOCdGRmaVXVjn
         E8x4mfrD87jM+8EJ6JosvdVkiP33+ERLRGObdK2Zf7QdJx/9brf9mmHb1KFkA7fHBuTk
         kGblQHn3HOJ4dHJEBavL99UpaYQiGpHEo8duB6xTHILlcs7xeCBwPSx1MBVWNgApEHA5
         bHEYtUcYk1vVZfVgjgoHWj+hq6sVe5byumYvyDUA89oS4+I4DSbW+qihaGp8zafrtOc8
         1xb1OJNtkADrU+/4xpQ5LZ+g7X4G0QxocP7ZSQ2UkXDiJivPN01OuzmNbeVFMnw92c0y
         EeAg==
X-Gm-Message-State: AFqh2kp15l0w4nqbIRAfgmSVfARKnhrZhQXdFChXOEd4FMZ0te1rz8MY
        qpoTwyYwvnkHvZqIqLVR430jdUkdw8Hmp4bld2M=
X-Google-Smtp-Source: AMrXdXsg6fysPDNtiHZoO0NUtcUBRelmnqtfbKkHkafG1gTR4wIegkwnxcvqXjgVaLk94qIDLV3b8g==
X-Received: by 2002:a05:6402:3909:b0:499:bcd7:a968 with SMTP id fe9-20020a056402390900b00499bcd7a968mr56535625edb.22.1675155975938;
        Tue, 31 Jan 2023 01:06:15 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id d22-20020a50f696000000b00495f4535a33sm5096652edn.74.2023.01.31.01.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 01:06:14 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jacob.e.keller@intel.com
Subject: [patch net-next 0/3] devlink: trivial names cleanup
Date:   Tue, 31 Jan 2023 10:06:10 +0100
Message-Id: <20230131090613.2131740-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

This is a follow-up to Jakub's devlink code split and dump iteration
helper patchset. No functional changes, just couple of renames to makes
things consistent and perhaps easier to follow.

Jiri Pirko (3):
  devlink: rename devlink_nl_instance_iter_dump() to "dumpit"
  devlink: remove "gen" from struct devlink_gen_cmd name
  devlink: rename and reorder instances of struct devlink_cmd

 net/devlink/devl_internal.h | 41 ++++++++++++------------
 net/devlink/leftover.c      | 64 ++++++++++++++++++-------------------
 net/devlink/netlink.c       | 42 ++++++++++++------------
 3 files changed, 73 insertions(+), 74 deletions(-)

-- 
2.39.0

