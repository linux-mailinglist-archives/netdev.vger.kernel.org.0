Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4752539C5B
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 06:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349594AbiFAE5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 00:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347921AbiFAE5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 00:57:53 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C662369CB;
        Tue, 31 May 2022 21:57:51 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id c5-20020a1c3505000000b0038e37907b5bso2339049wma.0;
        Tue, 31 May 2022 21:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=l/WpQ47qC66FQkGPOa6v5NluTq5zQ5/G7omwoIbA6Tc=;
        b=d6p6RSKWoGa4vbJhb/Ddqm/C2B6MjpoOy78vjoGpdh63ppuCLqeBTuaNA8QREaaOWw
         kvhq+lJzy3kL7fj57Sv/kBgwZW3wYlqJp0KnlSqgzwDF5g2q/ySOMQhoW2TjUJbqOmhk
         yGKcsR9QO2xKVEjNDmelo2/10Y/HCvrDQi539ShiJ8GA2utsMBqC4EWK4w9lRXe37qb9
         XrbQP/7eGm8lAL27Ud+iG7n8edsP2iR5vk6taacS3e87OddCFh289RA2hQYFBB2QgA89
         0IUmrWoezUFs0KeCpo0cZODyhx628wHqH/zZc9ZVVlfsOE9dPVWos0Xx25VZvdIQ8Rk+
         1rUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l/WpQ47qC66FQkGPOa6v5NluTq5zQ5/G7omwoIbA6Tc=;
        b=6KPwkcIbUK0qIvv+ub7THDUZIyzRTCkXGdl4yeOzJQOmKispj8TXb2jxX7BCpLX8eQ
         ZIrTWSXojyrfaLR7HGOiVCGmTvYlsnfsb/ijEpjtbl9G+VsJ042T5/Owot3BULIgLJJ4
         178cM3yefTWh9N5C7Y7Gkfl7940+KDxpHUghTu7QMiFtusybQpAKt79nmJpIneN7DBm3
         YUZ7Xlc5ICuMG0aXQJKzTGwhG4Zf9dl4ckKHWxElEXvrqAfKy1Bmra8bSHtF5ZEw5d/B
         Z5LXvZTNA75wUWsO6uec21wcCdzJ5Hm5lnTbxoDxEWm0fpbWCwbZmOg63dqHNCsqhAKC
         TEhg==
X-Gm-Message-State: AOAM533lQ3aTA/3fc9Xg86cdZP0kwqfaGUNguYqu5866JYaddn7nWxY2
        83W9JCxKBUyRLck38hy6W2E=
X-Google-Smtp-Source: ABdhPJyhzfkkwWM99a36mxqyxLyHI0ThAxMU6LO/2L2usEKWdjTIoUp/aSohfy2cIs0zkBdUdbqKnA==
X-Received: by 2002:a05:600c:3595:b0:399:fd8f:2c00 with SMTP id p21-20020a05600c359500b00399fd8f2c00mr17660148wmq.97.1654059469983;
        Tue, 31 May 2022 21:57:49 -0700 (PDT)
Received: from felia.fritz.box (200116b82620c00028af88788fa7d286.dip.versatel-1u1.de. [2001:16b8:2620:c000:28af:8878:8fa7:d286])
        by smtp.gmail.com with ESMTPSA id u18-20020a5d5152000000b0020cdcb0efa2sm443372wrt.34.2022.05.31.21.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 21:57:49 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: adjust MELLANOX ETHERNET INNOVA DRIVERS to TLS support removal
Date:   Wed,  1 Jun 2022 06:57:38 +0200
Message-Id: <20220601045738.19608-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 40379a0084c2 ("net/mlx5_fpga: Drop INNOVA TLS support") removes all
files in the directory drivers/net/ethernet/mellanox/mlx5/core/accel/, but
misses to adjust its reference in MAINTAINERS.

Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
broken reference.

Remove the file entry to the removed directory in MELLANOX ETHERNET INNOVA
DRIVERS.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Leon, please pick this minor non-urgent clean-up patch on top of the commit
above.

 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 88fdf39e6bb4..8ccdd7727840 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12695,7 +12695,6 @@ L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.mellanox.com
 Q:	https://patchwork.kernel.org/project/netdevbpf/list/
-F:	drivers/net/ethernet/mellanox/mlx5/core/accel/*
 F:	drivers/net/ethernet/mellanox/mlx5/core/en_accel/*
 F:	drivers/net/ethernet/mellanox/mlx5/core/fpga/*
 F:	include/linux/mlx5/mlx5_ifc_fpga.h
-- 
2.17.1

