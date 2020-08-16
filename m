Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0338245619
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 07:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730074AbgHPF0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 01:26:01 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40679 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730068AbgHPF0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 01:26:00 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yanjunz@mellanox.com)
        with SMTP; 16 Aug 2020 08:25:58 +0300
Received: from bc-vnc02.mtbc.labs.mlnx (bc-vnc02.mtbc.labs.mlnx [10.75.68.111])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07G5Pv36011207;
        Sun, 16 Aug 2020 08:25:58 +0300
Received: from bc-vnc02.mtbc.labs.mlnx (localhost [127.0.0.1])
        by bc-vnc02.mtbc.labs.mlnx (8.14.4/8.14.4) with ESMTP id 07G5PvN7026333;
        Sun, 16 Aug 2020 13:25:57 +0800
Received: (from yanjunz@localhost)
        by bc-vnc02.mtbc.labs.mlnx (8.14.4/8.14.4/Submit) id 07G5Pr1l026332;
        Sun, 16 Aug 2020 13:25:53 +0800
From:   Zhu Yanjun <yanjunz@mellanox.com>
To:     zyjzyj2000@gmail.com, yanjunz@nvidia.com,
        linux-rdma@vger.kernel.org, dledford@redhat.com, jgg@ziepe.ca,
        leon@kernel.org, netdev@vger.kernel.org
Cc:     Zhu Yanjun <yanjunz@mellanox.com>
Subject: [PATCH 1/1] MAINTAINERS: SOFT-ROCE: Change Zhu Yanjun's email address
Date:   Sun, 16 Aug 2020 13:25:50 +0800
Message-Id: <1597555550-26300-1-git-send-email-yanjunz@mellanox.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I prefer to use this email address for kernel related work.

Signed-off-by: Zhu Yanjun <yanjunz@mellanox.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e02479a..065225f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15833,7 +15833,7 @@ F:	drivers/infiniband/sw/siw/
 F:	include/uapi/rdma/siw-abi.h
 
 SOFT-ROCE DRIVER (rxe)
-M:	Zhu Yanjun <yanjunz@mellanox.com>
+M:	Zhu Yanjun <yanjunz@nvidia.com>
 L:	linux-rdma@vger.kernel.org
 S:	Supported
 F:	drivers/infiniband/sw/rxe/
-- 
1.7.1

