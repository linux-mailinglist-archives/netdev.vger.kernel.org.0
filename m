Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0259C1FEDC5
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 10:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgFRIhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 04:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728752AbgFRIhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 04:37:35 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDABC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 01:37:35 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id q14so3774947qtr.9
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 01:37:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NZEZKpyWhPA6yGR63CK/vh5TKUAQ+5lvK6MXVLUbqQM=;
        b=klkSF2NAYXbomoQJ6nc88LIjnYTiknac9cU+85VTQB+wvsq2Cboak01mZfc8kfdRop
         xJU6aOexgldzUWTjfc34HsqkgmR9y0v6q4U3cmB5Ard9HOUdwH1mRET17HweLM1Ddths
         6qB5cyMJpiCMcGHJzvmUE4kCZ7TztTD4/N6zJFpQJs2DT3MDImZ37u9VEMW3o6jSiEEQ
         n2BVpQrElQLGegrmt0pOwhhTFou2HJJgDLAvIRXd10pHjat6xfYrmzHgULzd9oIcQrBg
         4ayKhH/bPGff8Mz+WWKNJSV0Yd4ppuVULL6Fu2ar5mhPMYM2QNV3Ugb1d62M3Nl5GhB3
         ePKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NZEZKpyWhPA6yGR63CK/vh5TKUAQ+5lvK6MXVLUbqQM=;
        b=FsPZfdHs/uKrE3GqIX03JHr945T7kZFNcDb1Uh5kIePGHHHrr/N1zMEhen6DdfQOQf
         BcnFkhmGakslB5G5NsAphXv1FPsrEM0/AuQISodzojNmBS493Cyy0frvfRBJUmK8fj3d
         RL1webvdsOFSk1SLjiUiqZoATjXLq2PZR06PFuqSED+5P/VfgpKx4k8t79VhZRUJeJgq
         eDy6dpBwuziuWboqOmAOnOffPTH0pq4nfwP6mFICSko21GlG9dAXYYLoID+CnIYjIH1P
         mDqJN5M9siIYIbU5pNkXOwwkJK4lE1rcRCEq8vK2qIjdOSWcJD8H2AZkWermsrh2Pe2d
         8DQg==
X-Gm-Message-State: AOAM533ii6d+lZM4UqhDMDZHw6RD8W8Q38NUPbfq7mDZ/8GlxHorftnS
        DZ+9VFaxLc020al3uc/F9xTxFRAgJcEeJg==
X-Google-Smtp-Source: ABdhPJypbOXt8l8F0fyJHo0K9qJMzI5ZgnBf1G63pJKz+EqUFf/0TAN9WanZndeFL9NaIiUcNoKzpQ==
X-Received: by 2002:ac8:6a08:: with SMTP id t8mr3230749qtr.271.1592469454458;
        Thu, 18 Jun 2020 01:37:34 -0700 (PDT)
Received: from localhost.localdomain ([111.205.198.3])
        by smtp.gmail.com with ESMTPSA id l69sm2131551qke.112.2020.06.18.01.37.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jun 2020 01:37:33 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     paulb@mellanox.com, saeedm@mellanox.com, gerlitz.or@gmail.com,
        roid@mellanox.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 3/3] net/mlx5e: Fix the code style
Date:   Thu, 18 Jun 2020 16:36:46 +0800
Message-Id: <20200618083646.59507-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20200618083646.59507-1-xiangxia.m.yue@gmail.com>
References: <20200618083646.59507-1-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 006807e04eda..795dda1a5e8a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -533,7 +533,7 @@ static bool mlx5e_rep_has_offload_stats(const struct net_device *dev, int attr_i
 {
 	switch (attr_id) {
 	case IFLA_OFFLOAD_XSTATS_CPU_HIT:
-			return true;
+		return true;
 	}
 
 	return false;
-- 
2.26.1

