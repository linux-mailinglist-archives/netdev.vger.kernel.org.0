Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 668A61C65D1
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 04:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgEFCRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 22:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgEFCRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 22:17:15 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFCCC061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 19:17:15 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o18so97736pgg.8
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 19:17:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EVXr1FNSgdcritQUv37Vahgqq4z7n5W7aJ5oRuU6BL0=;
        b=uCwCHf4CscadTCFfFfiDFSjbVO1wY2349ptZ9pU8xxUuCwYKtypGbmFhYmyYdpXxiu
         +j/X5P21tCiEgbBRbYtWnCnDFliUn0TkdAChBehuze/EMly7r71KB/bE5asKtThh332q
         w3CAYDD/dpYySvJYdwELvJHPuQFXx5DY2lt19Oy9pjj/4VMDUghNoLjcRfCxOA6Wr7fC
         j6hbXbKgt1Jwpwk/kVU0R9/JWMsWXU62nhy/bmsZbEEIDXwDY+joFnFyBW84p4SYHjh5
         Q7PoOpKpfeyQLdtPCEdHW5GHiToiFs7yNdvFiDHaD/Mp6l2s1cA1uvf1ZdFDZCapm562
         nKjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EVXr1FNSgdcritQUv37Vahgqq4z7n5W7aJ5oRuU6BL0=;
        b=tXGIUHQKT/lzZ/gCTE9PKzq+FBr8YGZjyhJO2RNv/OfjcPqRPcB+z8PbyGXwbBu1Ki
         OxEzB4HECNmJq0W8Ij1t3GkMlID3hfj+I8ShLzkjjV8r+2eLz++z3gNlgF/MVB2mIs7s
         1VEH7eEazVcjVSyRcfn+vH3GhcGY0B2JBm6X/sNVwrYXO7npNTO1EfFXi/311CCh5qAY
         EQ5Xjb/W7SZ53MgkxiFjRy9hfQsIxl1OiYXnDGR6XyxYkmkcz+4sXTH7p/ptcD/1K9go
         sjEkiuDxjlIS/QEiuOmWb+LtkY05kigOWnm9LLWBmhEU+anRvCCkvD1vwr5yUZXbgE+I
         Cf2Q==
X-Gm-Message-State: AGi0PubITIr/5x8g/lG4WTozjfQHHPsEAMa212NJ9Ryk8iSFzMbxSeQG
        qU4upJfSITzi+MbqNVRgb5rsEHE/Hjw=
X-Google-Smtp-Source: APiQypJ5rllBv5IPq0mpb9XcBal/HDWCmzNOtQTK0WNfBGAaYtccZfTcuLCj1MTqWoV+pd8OKwiq9w==
X-Received: by 2002:a63:7745:: with SMTP id s66mr5288147pgc.340.1588731435195;
        Tue, 05 May 2020 19:17:15 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.142.146.4])
        by smtp.gmail.com with ESMTPSA id ft14sm1751646pjb.46.2020.05.05.19.17.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 May 2020 19:17:14 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     paulb@mellanox.com, saeedm@mellanox.com, roid@mellanox.com,
        gerlitz.or@gmail.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH v2 3/3] net/mlx5e: Fix the code style
Date:   Wed,  6 May 2020 10:16:33 +0800
Message-Id: <1588731393-6973-3-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588731393-6973-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1588731393-6973-1-git-send-email-xiangxia.m.yue@gmail.com>
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
index 2de54d865dc8..39ad8c667da3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1367,7 +1367,7 @@ static bool mlx5e_rep_has_offload_stats(const struct net_device *dev, int attr_i
 {
 	switch (attr_id) {
 	case IFLA_OFFLOAD_XSTATS_CPU_HIT:
-			return true;
+		return true;
 	}
 
 	return false;
-- 
1.8.3.1

