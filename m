Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABEE2EB5DE
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbhAEXGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:06:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:57430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727425AbhAEXG0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 18:06:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E67D230FD;
        Tue,  5 Jan 2021 23:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609887909;
        bh=tuGhuLZwx/voF3heNMIk/GUzkny+sFbD/TgDKU4hlnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bj2A6RvUDV6gHHmCQd2QHv1YHH+zg6UiNBiVHi10VowsOVk0FGxJxriydymtlJU6t
         B/UNsjeGC5xASjepcvqIsaeBotzD0x4QECWS/gpkch5WY/C05KRaPzRCeG6KjeWDGR
         Yzb/HsSzlDmNRheyZ0jpqKWCAVQVEorBaORq6AQnCTA5sgO80ozDY9sxAtpLUDRDnm
         MRaqmVI/IUCd3fNwS0yyF+bUSatBJEG9k1HQ2Bs8TrsLdoZmL6HtTc2zaUhuZ0zCoN
         Dr8R5QNXzrxcYCGVvGeb2XZ5Lnt9qa2MmjDy7akli4a5bIWWDUI5kn6fVbvM88Hi+m
         MVmv72N5y8Lhg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 05/16] net/mlx5: DR, Remove unused macro definition from dr_ste
Date:   Tue,  5 Jan 2021 15:03:22 -0800
Message-Id: <20210105230333.239456-6-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
index 64c387860f79..2cb9406a0364 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_ste.c
@@ -5,8 +5,6 @@
 #include <linux/crc32.h>
 #include "dr_ste.h"
 
-#define DR_STE_CRC_POLY 0xEDB88320L
-
 #define DR_STE_ENABLE_FLOW_TAG BIT(31)
 
 enum dr_ste_tunl_action {
-- 
2.26.2

