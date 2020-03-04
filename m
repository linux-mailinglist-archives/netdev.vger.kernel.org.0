Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E489A17895D
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 05:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgCDEGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 23:06:41 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54825 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725861AbgCDEGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 23:06:41 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from parav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 4 Mar 2020 06:06:37 +0200
Received: from sw-mtx-036.mtx.labs.mlnx (sw-mtx-036.mtx.labs.mlnx [10.9.150.149])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02446XJR014213;
        Wed, 4 Mar 2020 06:06:35 +0200
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@kernel.org, jiri@mellanox.com,
        parav@mellanox.com
Subject: [PATCH net-next iproute2 1/2] Update devlink kernel header
Date:   Tue,  3 Mar 2020 22:06:25 -0600
Message-Id: <20200304040626.26320-2-parav@mellanox.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200304040626.26320-1-parav@mellanox.com>
References: <20200304040626.26320-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update devlink kernel header to commit:
acf1ee44ca5d ("devlink: Introduce devlink port flavour virtual")

Signed-off-by: Parav Pandit <parav@mellanox.com>
---
 include/uapi/linux/devlink.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 3f82dedd..1b412281 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -187,6 +187,7 @@ enum devlink_port_flavour {
 				      * for the PCI VF. It is an internal
 				      * port that faces the PCI VF.
 				      */
+	DEVLINK_PORT_FLAVOUR_VIRTUAL, /* Any virtual port facing the user. */
 };
 
 enum devlink_param_cmode {
@@ -252,6 +253,8 @@ enum devlink_trap_type {
 enum {
 	/* Trap can report input port as metadata */
 	DEVLINK_ATTR_TRAP_METADATA_TYPE_IN_PORT,
+	/* Trap can report flow action cookie as metadata */
+	DEVLINK_ATTR_TRAP_METADATA_TYPE_FA_COOKIE,
 };
 
 enum devlink_attr {
-- 
2.19.2

