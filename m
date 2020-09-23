Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55DF8275162
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 08:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbgIWGYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 02:24:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgIWGYr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 02:24:47 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFA1621D43;
        Wed, 23 Sep 2020 06:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600842287;
        bh=5ezjZk+reMMGxCZo9F9UpEkKghKO6yW6iVSA1TFOyVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+uVJtSCR8rzDTpXQt4tWvXNoE+8MjkLAVBgTlgo9kcJS+RH8OgB1/YdozZ/k+idJ
         wtfwwYmKhSEfrF0Jeo5rM4E+PaaRF8iZyw1vY8KJewW26GiiQMvLsnstZQrd5H7TbL
         n8ngevVws4qZAZO+rfkJ6LytizdMuaTFYuE7KOB4=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "Pavel Machek (CIP)" <pavel@denx.de>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5: remove unreachable return
Date:   Tue, 22 Sep 2020 23:24:38 -0700
Message-Id: <20200923062438.15997-16-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200923062438.15997-1-saeed@kernel.org>
References: <20200923062438.15997-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Pavel Machek (CIP)" <pavel@denx.de>

The last return statement is unreachable code. I'm not sure if it will
provoke any warnings, but it looks ugly.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 7fc59e01a353..c70c1f0ca0c1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -435,8 +435,6 @@ static int mlx5_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 	default:
 		return -EOPNOTSUPP;
 	}
-
-	return -EOPNOTSUPP;
 }
 
 static const struct ptp_clock_info mlx5_ptp_clock_info = {
-- 
2.26.2

