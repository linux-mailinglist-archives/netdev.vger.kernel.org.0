Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16D4526BFF4
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 10:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgIPI6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 04:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726243AbgIPI6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 04:58:42 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B7CC06174A;
        Wed, 16 Sep 2020 01:58:41 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z9so2130879wmk.1;
        Wed, 16 Sep 2020 01:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=2KTok6gVmhkLo7YM284bMYXzQlRqMVhC5bg8YBdyf6w=;
        b=upLP4VVgaeRWkY+1e0SALXRsKRhXSqfUDb6gjc3DHWn4pE5QGrTX8Y+iTwM7Z+m/c6
         sNdQMjxSGUCdcy649Fg7Cs5e51lHf4Xz5/GCyagvc9RN+2ZwZ8Z7KlljbNLZ92nBQldK
         fXn+Owq11zO4udSkOm+ptRwazSpZlYlVRvHRwmb16jKhS1AvCUPiOFVM43cc5SVZ75gN
         C9m1o/FDZTKT7hvRhtLCnbHQRmtxx+WxA83TYQNxGKmFE+vgkPqA7gor4NaogJ4MKWTx
         cKaBcAeu7SWyME2OH+tSfqUk54v4SC45vRl+YPz2rwUCog5Wfv2Y8KbV2RCuyu5Ec9aw
         LF4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2KTok6gVmhkLo7YM284bMYXzQlRqMVhC5bg8YBdyf6w=;
        b=O0f3YuudCnwz/rIo/Bls19dv8+m7QK/yGU01nL0Npd046oy5TNOX0Qt+B3PJ3/hkxw
         isJCxyUhEWchfTxsjtV21vRbIUYKzn0ZV/VQ79bbSqMBD6e8gqUGW4RJJz8aoAkrQdie
         b/8xxQ9E47LHXZQZdYe8Y92fISLR9Bz0RBNffhS44WZd5Ewfndig8At9bYdtniPWetC6
         kJQYXGERXjOnS1Zy9LYzIaomTMgOsbVzqI40SMDODNI0IdQ8ykkXqDrrjTSl/oGAPO/9
         NGxa5Hm3z5Ra53HGcNdOBdQIFvR27lmCmdgpiH59tE849QyLXBRqsvWlYJtsVECkHQgz
         oaBw==
X-Gm-Message-State: AOAM530enCSaF+2a8WyubTXcNaDVwB3ddtw70RRSDUWidsRb6l9n+bNq
        b+7ulHZQk7bvyMa/d/rr5gw=
X-Google-Smtp-Source: ABdhPJzVp+dN7D8wyCUv0heKGyY7kzaAEe3/quQpOKtdISAesnL2qExlTI9Zb1djSYjXVn511GPp/Q==
X-Received: by 2002:a1c:a949:: with SMTP id s70mr2386736wme.42.1600246719990;
        Wed, 16 Sep 2020 01:58:39 -0700 (PDT)
Received: from felia.fritz.box ([2001:16b8:2dec:c500:15b1:3554:3841:68b])
        by smtp.gmail.com with ESMTPSA id f14sm4184965wme.22.2020.09.16.01.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 01:58:39 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-spdx@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Boris Pismenny <borisp@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Raed Salem <raeds@mellanox.com>,
        Huy Nguyen <huyn@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] net/mlx5: IPsec: make spdxcheck.py happy
Date:   Wed, 16 Sep 2020 10:58:24 +0200
Message-Id: <20200916085824.30731-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 2d64663cd559 ("net/mlx5: IPsec: Add HW crypto offload support")
provided a proper SPDX license expression, but slipped in a typo.

Fortunately, ./scripts/spdxcheck.py warns:

  drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c: 1:39 \
  Invalid License ID: Linux-OpenIBt

Remove the typo and make spdxcheck.py happy.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---

Greg, please pick this minor non-urgent patch into your spdx tree.

 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
index 2f13a250aab3..d6667d38e1de 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec_offload.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIBt
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 /* Copyright (c) 2020, Mellanox Technologies inc. All rights reserved. */
 
 #include "mlx5_core.h"
-- 
2.17.1

