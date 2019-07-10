Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B5964669
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 14:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbfGJMkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 08:40:01 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37222 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726458AbfGJMj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 08:39:59 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 10 Jul 2019 15:39:57 +0300
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.12.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x6ACdtr7020922;
        Wed, 10 Jul 2019 15:39:55 +0300
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org, jiri@mellanox.com,
        Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next iproute2 v2 1/2] devlink: Update kernel header to commit
Date:   Wed, 10 Jul 2019 07:39:51 -0500
Message-Id: <20190710123952.6877-1-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190701183017.25407-1-parav@mellanox.com>
References: <20190701183017.25407-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update kernel header to commit:
e41b6bf3cdd4 ("devlink: Introduce PCI VF port flavour and port attribute")

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 include/uapi/linux/devlink.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 6544824a..fc195cbd 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -169,6 +169,14 @@ enum devlink_port_flavour {
 	DEVLINK_PORT_FLAVOUR_DSA, /* Distributed switch architecture
 				   * interconnect port.
 				   */
+	DEVLINK_PORT_FLAVOUR_PCI_PF, /* Represents eswitch port for
+				      * the PCI PF. It is an internal
+				      * port that faces the PCI PF.
+				      */
+	DEVLINK_PORT_FLAVOUR_PCI_VF, /* Represents eswitch port
+				      * for the PCI VF. It is an internal
+				      * port that faces the PCI VF.
+				      */
 };
 
 enum devlink_param_cmode {
@@ -337,6 +345,9 @@ enum devlink_attr {
 	DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE,	/* u64 */
 	DEVLINK_ATTR_FLASH_UPDATE_STATUS_TOTAL,	/* u64 */
 
+	DEVLINK_ATTR_PORT_PCI_PF_NUMBER,	/* u16 */
+	DEVLINK_ATTR_PORT_PCI_VF_NUMBER,	/* u16 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.19.2

