Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5B76B2367
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 12:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbjCILt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 06:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231626AbjCILtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 06:49:21 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2759BE7757
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 03:49:14 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id az36so950743wmb.1
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 03:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678362552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tgCFf5XV3x9+3s4HTB0VHI0rwAbl2funwACw7r+gOq8=;
        b=nIqX5i37OseTS8g474e8FAyGmo27gwWrF7ywLcsidjWKYMyEkFTjzq4QlC+nFvMPed
         //bWTg3XQlcg5GNPXBXwKqyV0TD806tWyJTkeB5r0nXXYcoOBUkf8W1klP2JmzkvPYNT
         qwydh/GSEaD6nI/jCf5Rlq7gbk7ivUa+Q+qS2YVdghOlokifAqdJ5CjSshFzoJxXu+we
         35X4ecS2kjF0X8laGUVmvf1wyAF1WQXrmrMPr0BYtcimD8t2ebjm/xg3IWF/8KWprhyV
         cdvok5AUuI/M6/7u+hZrvNl9jHTyKOTlvyKSFwvkCearzq4cs/PaA+9O3UCAWCygS7FR
         nglA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678362552;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tgCFf5XV3x9+3s4HTB0VHI0rwAbl2funwACw7r+gOq8=;
        b=NPkvgPpsYPvfv7m6MMynb6qtaUc4wIJWfxaq8ZfLF3jGSz1gO6sfOUUSFpVKTSkLoM
         uft8nl9sSa6H7c79nv4kEQsE9in9je8CjKAv973p1eeBgFJtOGDb697S318Cmx4YHiqE
         wnW9tzRR1/rI2bNY1uCU+voctQwuNLD7VDLRSL18M13BeN8whL0gKg9qF24K6ykIP16n
         PXsuRwjFd15MgMRwZyPp7tnvOqIdAsD1mGOvcwqHGPDdlJnAzJ0NMg0iBSvfYwWLv6BG
         /wAVQtxve0FkBABIf+mWCwTZv8GGZ9zh1Nb1aVcLdnB5uPBxKhAlm/BFyWE9V1WLMi2j
         v0Bg==
X-Gm-Message-State: AO0yUKVrFrWqk9K9hTrpytzhK86p8jsGW1wpGz1RB+XAxosBA5RzCvKB
        BlzahSUmUjjiEZQ5Z4UFbeJ8h22ngDLpL6BItvI=
X-Google-Smtp-Source: AK7set/SC3nSa/q2MzDRf/C+m16g40QfD/rwUlNEa7tm9EsV4/+tSshJgYAGkyI3vkUzod3YjnRNBA==
X-Received: by 2002:a05:600c:1c83:b0:3ea:f6c4:5f3c with SMTP id k3-20020a05600c1c8300b003eaf6c45f3cmr18717198wms.7.1678362552557;
        Thu, 09 Mar 2023 03:49:12 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id az5-20020a05600c600500b003eaf666cbe0sm2465815wmb.27.2023.03.09.03.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 03:49:12 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Subject: [patch net-next] MAINTAINERS: make my email address consistent
Date:   Thu,  9 Mar 2023 12:49:11 +0100
Message-Id: <20230309114911.923460-1-jiri@resnulli.us>
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

Use jiri@resnulli.us in all MAINTAINERS entries and fixup .mailmap
so all other addresses point to that one.

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
---
 .mailmap    | 3 +++
 MAINTAINERS | 6 +++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/.mailmap b/.mailmap
index a872c9683958..48b17d110dbe 100644
--- a/.mailmap
+++ b/.mailmap
@@ -208,6 +208,9 @@ Jens Axboe <axboe@suse.de>
 Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
 Jernej Skrabec <jernej.skrabec@gmail.com> <jernej.skrabec@siol.net>
 Jessica Zhang <quic_jesszhan@quicinc.com> <jesszhan@codeaurora.org>
+Jiri Pirko <jiri@resnulli.us> <jiri@nvidia.com>
+Jiri Pirko <jiri@resnulli.us> <jiri@mellanox.com>
+Jiri Pirko <jiri@resnulli.us> <jpirko@redhat.com>
 Jiri Slaby <jirislaby@kernel.org> <jirislaby@gmail.com>
 Jiri Slaby <jirislaby@kernel.org> <jslaby@novell.com>
 Jiri Slaby <jirislaby@kernel.org> <jslaby@suse.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index edd3d562beee..4566bd9eeff6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5971,7 +5971,7 @@ F:	include/linux/dm-*.h
 F:	include/uapi/linux/dm-*.h
 
 DEVLINK
-M:	Jiri Pirko <jiri@nvidia.com>
+M:	Jiri Pirko <jiri@resnulli.us>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/devlink
@@ -15084,7 +15084,7 @@ F:	Documentation/hwmon/nzxt-smart2.rst
 F:	drivers/hwmon/nzxt-smart2.c
 
 OBJAGG
-M:	Jiri Pirko <jiri@nvidia.com>
+M:	Jiri Pirko <jiri@resnulli.us>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	include/linux/objagg.h
@@ -15858,7 +15858,7 @@ F:	drivers/video/logo/logo_parisc*
 F:	include/linux/hp_sdc.h
 
 PARMAN
-M:	Jiri Pirko <jiri@nvidia.com>
+M:	Jiri Pirko <jiri@resnulli.us>
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	include/linux/parman.h
-- 
2.39.0

