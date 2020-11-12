Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B162AFF7D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgKLFu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:50:56 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:48258 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726096AbgKLFu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 00:50:56 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 12 Nov 2020 07:50:53 +0200
Received: from vnc1.mtl.labs.mlnx (vnc1.mtl.labs.mlnx [10.7.2.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AC5orl1030688;
        Thu, 12 Nov 2020 07:50:53 +0200
Received: from vnc1.mtl.labs.mlnx (localhost [127.0.0.1])
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4) with ESMTP id 0AC5orCr008538;
        Thu, 12 Nov 2020 07:50:53 +0200
Received: (from moshe@localhost)
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4/Submit) id 0AC5orLJ008537;
        Thu, 12 Nov 2020 07:50:53 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next 1/2] ethtool: Add CMIS 4.0 module type to UAPI
Date:   Thu, 12 Nov 2020 07:49:40 +0200
Message-Id: <1605160181-8137-2-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1605160181-8137-1-git-send-email-moshe@mellanox.com>
References: <1605160181-8137-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

CMIS 4.0 document describes a universal EEPROM memory layout, which is
used for some modules such as DSFP, OSFP and QSFP-DD modules. In order
to distinguish them in userspace from existing standards, add
corresponding values.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 include/uapi/linux/ethtool.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index 9ca87bc73c44..0ec4c0ea3235 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -1861,9 +1861,12 @@ static inline int ethtool_validate_duplex(__u8 duplex)
 #define ETH_MODULE_SFF_8636_LEN		256
 #define ETH_MODULE_SFF_8436		0x4
 #define ETH_MODULE_SFF_8436_LEN		256
+#define ETH_MODULE_CMIS_4		0x5
+#define ETH_MODULE_CMIS_4_LEN		256
 
 #define ETH_MODULE_SFF_8636_MAX_LEN     640
 #define ETH_MODULE_SFF_8436_MAX_LEN     640
+#define ETH_MODULE_CMIS_4_MAX_LEN	768
 
 /* Reset flags */
 /* The reset() operation must clear the flags for the components which
-- 
2.18.2

