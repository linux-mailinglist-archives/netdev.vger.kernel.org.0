Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A196420022
	for <lists+netdev@lfdr.de>; Sun,  3 Oct 2021 07:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhJCFFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Oct 2021 01:05:02 -0400
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:53608 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhJCFFA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Oct 2021 01:05:00 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by smtp.orange.fr with ESMTPA
        id WtdMmhDZXsoWhWteYm9Qcm; Sun, 03 Oct 2021 07:03:12 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Sun, 03 Oct 2021 07:03:12 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [RFC PATCH v1 3/3] uapi: can: netlink: add new field to struct can_ctrlmode to report capabilities
Date:   Sun,  3 Oct 2021 14:01:47 +0900
Message-Id: <20211003050147.569044-4-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211003050147.569044-1-mailhol.vincent@wanadoo.fr>
References: <20211003050147.569044-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is for your convinience. iproute2-next normally directly
pulls the uapi changes but I think it will be more convinient for
people who want to test to just be able to directly apply this series
and have things working.

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
Please do not pull!
---
 include/uapi/linux/can/netlink.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/can/netlink.h b/include/uapi/linux/can/netlink.h
index 00c763df..fa1cab72 100644
--- a/include/uapi/linux/can/netlink.h
+++ b/include/uapi/linux/can/netlink.h
@@ -88,7 +88,10 @@ struct can_berr_counter {
  * CAN controller mode
  */
 struct can_ctrlmode {
-	__u32 mask;
+	union {
+		__u32 mask;		/* Userland to kernel */
+		__u32 supported;	/* Kernel to userland */
+	};
 	__u32 flags;
 };
 
-- 
2.32.0

