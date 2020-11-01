Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2669A2A1E6D
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 15:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbgKAOFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 09:05:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726458AbgKAOFi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 09:05:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604239536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=aWuZ6CNcX73ZRXvjOOgvWKSO2p04g3cpgBeEkZo1Tfs=;
        b=iNhip/XE7whz6XZlukyr7LjzpuRMhXyXewJ/gd6Xp74KMTwgH9+B21IptDWTOFAQQk/8MC
        JQT5eGhLHH12Ji3Lc7j4V0EYoosE+f4zRMQG5zjBUP2z4iQnvPzRGzjfNUqfNRmdOtLLkC
        kvre9tVyqx0kT96Wud8PVsyRZ8MiO3s=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-oxxOX5VkNPeCeMXC9YnDGQ-1; Sun, 01 Nov 2020 09:05:35 -0500
X-MC-Unique: oxxOX5VkNPeCeMXC9YnDGQ-1
Received: by mail-ot1-f70.google.com with SMTP id 5so5115025oti.20
        for <netdev@vger.kernel.org>; Sun, 01 Nov 2020 06:05:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aWuZ6CNcX73ZRXvjOOgvWKSO2p04g3cpgBeEkZo1Tfs=;
        b=n2CjHvfw0+WxEydbYEqMIPLolWCXJUuj0/IlRT4U8FF0fYOEIp1YlVbNKQCi8OVwjh
         NiD5LGpyZXXPvBhB2XzRxqIceO3XTD8dLghE9vOgPLpQDa+xBqFEBKj5w8W/KLcBWy9I
         boEscPgXdGGx98jYq7uL5IpVA90LkysyDZkDEicggUTFVqw/3rTjYQROSLasj/wV5CAi
         OTQtfEsKpxAN4GSWrqp7MYvN3GRzu13siIjrgpi+R7TUp48nG740R58YtYJg/eiPLsHp
         Qgze29ozltjoC3F71avbYkb8w6fjz7FYxFJqbyJD8pJ4P98r8fVwFjtG45dB4isblZmq
         zEuA==
X-Gm-Message-State: AOAM532HnZePbJD356aCS0yacGzqJgmN/DbAZlPdf4Key1ZmTTcIfhfZ
        JWeokYX9twyTbJyALgSmOB/1/B07wUI2bsTa2wrNBEdPUykD0VViKxYJPJAVqW7lTjjUY87tMUn
        LI5vTBv0MLvNqLHdq
X-Received: by 2002:a9d:6c0e:: with SMTP id f14mr8738009otq.275.1604239534470;
        Sun, 01 Nov 2020 06:05:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw4WDgKv4A+XxRMymr7Yk4a/1H3WY29ZBfgtBiE1ZxZk/R2BNNIqV4/zyl4X5ZA7JzAKIVmtA==
X-Received: by 2002:a9d:6c0e:: with SMTP id f14mr8737996otq.275.1604239534306;
        Sun, 01 Nov 2020 06:05:34 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id s27sm2923193otg.80.2020.11.01.06.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 06:05:33 -0800 (PST)
From:   trix@redhat.com
To:     tariqt@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] net/mlx4_core : remove unneeded semicolon
Date:   Sun,  1 Nov 2020 06:05:28 -0800
Message-Id: <20201101140528.2279424-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

A semicolon is not needed after a switch statement.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx4/resource_tracker.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 1187ef1375e2..394f43add85c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -300,7 +300,7 @@ static const char *resource_str(enum mlx4_resource rt)
 	case RES_FS_RULE: return "RES_FS_RULE";
 	case RES_XRCD: return "RES_XRCD";
 	default: return "Unknown resource type !!!";
-	};
+	}
 }
 
 static void rem_slave_vlans(struct mlx4_dev *dev, int slave);
-- 
2.18.1

