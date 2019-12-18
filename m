Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAE3C125723
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 23:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfLRWpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 17:45:32 -0500
Received: from mga18.intel.com ([134.134.136.126]:51341 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfLRWpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 17:45:32 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 14:45:31 -0800
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="205992980"
Received: from aguedesl-mac01.jf.intel.com (HELO localhost) ([10.24.12.200])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 14:45:31 -0800
From:   Andre Guedes <andre.guedes@intel.com>
To:     netdev@vger.kernel.org
Cc:     Andre Guedes <andre.guedes@intel.com>
Subject: [PATCH 1/2] ether: Add ETH_P_OPCUA macro
Date:   Wed, 18 Dec 2019 14:44:47 -0800
Message-Id: <20191218224448.8066-1-andre.guedes@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds the ETH_P_OPCUA macro which defines the 'OPC UA over
TSN' ethertype assigned to 0xB62C, according to:

http://standards-oui.ieee.org/ethertype/eth.txt

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
---
 include/uapi/linux/if_ether.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index f6ceb2e63d1e..0752281ee05a 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -109,6 +109,7 @@
 #define ETH_P_QINQ1	0x9100		/* deprecated QinQ VLAN [ NOT AN OFFICIALLY REGISTERED ID ] */
 #define ETH_P_QINQ2	0x9200		/* deprecated QinQ VLAN [ NOT AN OFFICIALLY REGISTERED ID ] */
 #define ETH_P_QINQ3	0x9300		/* deprecated QinQ VLAN [ NOT AN OFFICIALLY REGISTERED ID ] */
+#define ETH_P_OPCUA	0xB62C		/* OPC UA over TSN */
 #define ETH_P_EDSA	0xDADA		/* Ethertype DSA [ NOT AN OFFICIALLY REGISTERED ID ] */
 #define ETH_P_DSA_8021Q	0xDADB		/* Fake VLAN Header for DSA [ NOT AN OFFICIALLY REGISTERED ID ] */
 #define ETH_P_IFE	0xED3E		/* ForCES inter-FE LFB type */
-- 
2.24.1

