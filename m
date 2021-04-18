Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE3D3637CF
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbhDRV02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:26:28 -0400
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:34314 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbhDRV01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:26:27 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d25 with ME
        id uMRt2400521Fzsu03MRuCc; Sun, 18 Apr 2021 23:25:56 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 18 Apr 2021 23:25:56 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     tj@kernel.org, jiangshanlai@gmail.com, saeedm@nvidia.com,
        leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        bvanassche@acm.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 0/2] workqueue: Have 'alloc_workqueue()' like macros accept a  format specifier
Date:   Sun, 18 Apr 2021 23:25:52 +0200
Message-Id: <cover.1618780558.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve 'create_workqueue', 'create_freezable_workqueue' and
'create_singlethread_workqueue' so that they accept a format
specifier and a variable number of arguments.

This will put these macros more in line with 'alloc_ordered_workqueue' and
the underlying 'alloc_workqueue()' function.

This will also allow further code simplification.

Patch 1 is the modification of the macro.
Patch 2 is an example of simplification possible with this patch

Christophe JAILLET (2):
  workqueue: Have 'alloc_workqueue()' like macros accept a  format
    specifier
  net/mlx5: Simplify workqueue name creation

 drivers/net/ethernet/mellanox/mlx5/core/health.c |  9 +--------
 include/linux/workqueue.h                        | 14 +++++++-------
 2 files changed, 8 insertions(+), 15 deletions(-)

-- 
2.27.0

