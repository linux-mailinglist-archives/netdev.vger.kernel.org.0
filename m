Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A40333889B
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 13:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbfFGLKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 07:10:41 -0400
Received: from laurent.telenet-ops.be ([195.130.137.89]:45408 "EHLO
        laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728290AbfFGLKk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 07:10:40 -0400
Received: from ramsan ([84.194.111.163])
        by laurent.telenet-ops.be with bizsmtp
        id MnAe2000Q3XaVaC01nAepp; Fri, 07 Jun 2019 13:10:38 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hZCla-0004A5-BV; Fri, 07 Jun 2019 13:10:38 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hZCla-0003Ot-A0; Fri, 07 Jun 2019 13:10:38 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jiri Kosina <trivial@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH trivial] net/mlx5e: Spelling s/configuraion/configuration/
Date:   Fri,  7 Jun 2019 13:10:26 +0200
Message-Id: <20190607111026.12995-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
index 633b117eb13e8143..7b672ada63a39733 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port_buffer.c
@@ -175,7 +175,7 @@ static int update_xoff_threshold(struct mlx5e_port_buffer *port_buffer,
  *	@port_buffer: <output> port receive buffer configuration
  *	@change: <output>
  *
- *	Update buffer configuration based on pfc configuraiton and
+ *	Update buffer configuration based on pfc configuration and
  *	priority to buffer mapping.
  *	Buffer's lossy bit is changed to:
  *		lossless if there is at least one PFC enabled priority
-- 
2.17.1

