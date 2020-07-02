Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E063212437
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgGBNLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:11:36 -0400
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:58262
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729062AbgGBNLf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 09:11:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=krO/w/aHSdI9ama8BjrRdUaPOZXn/fFEIzbmrEx8Go9MFeOp7PIV7WKl/Pwe5yJzLjrRvKf/5M0TOEWc052Kw9/NgycQra4JGAtpVPwoLdw1q0QIQIj0kUW/jv9CXW9azvG3yIXiCcWNj1cFALAWy0IIlB5CSmmIbAkVmd1CicMnjeSCMXXMjK5Y6LNx5OvnW8gHWLQFXTcwfJbtJySaJaAjJDzDLdUnpvmBW6/ngbsG9GoUmbbeWJ8HkNbirI8OdnDUxie5htMNak22hOBmanBr8e1k8onYQu4rH4WX/hgZw4w/tXbdF1piv49RKQQv3bPMfL+V69nakpD4YI5TPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8LVfeUdzsVA72lefXhhjFFXQSwK51QtLey4rcG7D6Q=;
 b=g1RtQVAk76rq6YfkveoqufDd8cHvliZLdrqOWsWtAOLl3jpTFWjfMOo4wCKfJt0xMIvRXK63VC9Jzra/QbAoBHA7/7Oilc3LiN8vdRIrEbVsHSoqE8hizeeYxwkf3H7CQoJ/I655zFNLbEgSTyGGdyHfzkuLP8anM5s+d4KVfiE21rRt9DmNSOY+FS0bWmFJXXnZaDm/ctvGhWR4GEcCkOcQ+6wWdwhEoYnr/QARpNs8jseT4KihhundYoqS6zQTj09OYK6m+jhB4j39kwbLpTAu9YcQqqAd/JbdXbuxvZELf7U6Tps5I6YCOgXynLtBKjH+nu6wAiBZyGbdIDu2vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y8LVfeUdzsVA72lefXhhjFFXQSwK51QtLey4rcG7D6Q=;
 b=anucjCQybxWetTe7YsZ5otw0m2RNxrV3kEb76k8ryC56A98ec0K7UlTvRvDCCMattL+5IrrLrdh4oiTOaXu8Yr5L0WCNdwaVLw2zH+4YkgZuWNv3qAijpP5UMwlLpN2rXN3tv2nJYWLcDrLN1BqdMtzpPVM2pOsIhHZHYBuafFE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR0502MB3834.eurprd05.prod.outlook.com (2603:10a6:7:83::17)
 by HE1PR05MB3353.eurprd05.prod.outlook.com (2603:10a6:7:2f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Thu, 2 Jul
 2020 13:11:30 +0000
Received: from HE1PR0502MB3834.eurprd05.prod.outlook.com
 ([fe80::7c6f:47a:35a4:ffa2]) by HE1PR0502MB3834.eurprd05.prod.outlook.com
 ([fe80::7c6f:47a:35a4:ffa2%5]) with mapi id 15.20.3153.021; Thu, 2 Jul 2020
 13:11:30 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, o.rempel@pengutronix.de, andrew@lunn.ch,
        f.fainelli@gmail.com, jacob.e.keller@intel.com, mlxsw@mellanox.com,
        Amit Cohen <amitc@mellanox.com>
Subject: [PATCH ethtool v2 1/3] uapi: linux: update kernel UAPI header files
Date:   Thu,  2 Jul 2020 16:11:09 +0300
Message-Id: <20200702131111.23105-2-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200702131111.23105-1-amitc@mellanox.com>
References: <20200702131111.23105-1-amitc@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0117.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::22) To HE1PR0502MB3834.eurprd05.prod.outlook.com
 (2603:10a6:7:83::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR01CA0117.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Thu, 2 Jul 2020 13:11:28 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: edf22d3d-2f48-455f-7c35-08d81e896f41
X-MS-TrafficTypeDiagnostic: HE1PR05MB3353:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3353BF685B9E57924D37FBD0D76D0@HE1PR05MB3353.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:136;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tAEMTTBzuKb3TfM+/X6e/uxLNctFqQqdLdjsrgjGVf5h5gHQ6gcS8pKMsNeE8XkAkkXVWljZ/mVRLWMpYuFSM9gl/1TDX2VDV7sy+B0EH1rIuQU08/z+ojy6IMYnOCvqQswJAjnRCK9PV0mgl6FazVYGseQrLcLAN5OCEvXGDirCCL+6tfdm5mHtEewYBJj2A1aVMf2yltSJH877r1w+SxEN/ihThh6VPz9euIB9yzi1yrdXBTrRFyhQ4EotCqrmqNwioznvpZJ9glcV71KtEMQPcLxD5anYncLCDlSa5XGdlsp8GzCmAwnwDE9KnxUCAZ3z8WM89Xg25W+uNkj9ig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0502MB3834.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(52116002)(8936002)(66946007)(5660300002)(6486002)(4326008)(478600001)(2616005)(186003)(316002)(6916009)(66556008)(66476007)(16526019)(107886003)(956004)(1076003)(36756003)(6666004)(83380400001)(26005)(6512007)(8676002)(6506007)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: uw7HX8qDydwbul7kXtysuD5MUPcsBgtymr1uJOwQLIt+5I5uapA+SZeHyo75I3+KnZAO0A4WtTO+2XNjRvFZSdYNrVmYfc2JzH6qY846c9Xec4C/SulkRTM+AOTka3MoIcXIlphKlI6qLnIjjszy63uUBn23WgINMdlc9WlguSdksXBlmtl4R68Qzd0RLQBrxeFMG58YHZNnb1gyIPTdHP3yXE2TN918aGV32pyaoQJb5ZPl/++8BUi3FAzk10kR6Iizc0dw5OmPDVTDnbl9403QuxEKvgfHCyK9TnH6R4fKWZt3CsiXQ+Gt3d9ownKa6MgcJfpSSAXwDWtiTljkC0nz/ru/ehkcJaevTuueoHIOVOrnZSQFwaZHDnbb8PV2k+U4U8HOMDV49pr85sOPTf955FTvrxh1nKjevTBaMDm/E3v8Rp9qEJJ+7kF2n1OBo3nw3Vpm7Vq7F5LOM4pMKfqtMv2/wPTzGodSG/oPCoMJexWPxlVhg/RwMcnYSPtJ
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edf22d3d-2f48-455f-7c35-08d81e896f41
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0502MB3834.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 13:11:30.0999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4a6r32WAiPh3fNrJYLfy7nPWFsidrsC6MwKw9tDto7DrLFo5IPw/DiIBcZuwBZe9A4h9Mr22+X6PNX5ZkDRg5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3353
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add copies of kernel UAPI header files needed for link extended state:
	uapi/linux/ethtool.h
	uapi/linux/ethtool_netlink.h

The copies are taken from net-next tree,
commit ecc31c60240b ("ethtool: Add link extended state")

Signed-off-by: Amit Cohen <amitc@mellanox.com>
---
 uapi/linux/ethtool.h         | 70 ++++++++++++++++++++++++++++++++++++
 uapi/linux/ethtool_netlink.h |  2 ++
 2 files changed, 72 insertions(+)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index 6074caa..a1cfbe2 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -577,6 +577,76 @@ struct ethtool_pauseparam {
 	__u32	tx_pause;
 };
 
+/**
+ * enum ethtool_link_ext_state - link extended state
+ */
+enum ethtool_link_ext_state {
+	ETHTOOL_LINK_EXT_STATE_AUTONEG,
+	ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+	ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+	ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+	ETHTOOL_LINK_EXT_STATE_NO_CABLE,
+	ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+	ETHTOOL_LINK_EXT_STATE_EEPROM_ISSUE,
+	ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE,
+	ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED,
+	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
+};
+
+/**
+ * enum ethtool_link_ext_substate_autoneg - more information in addition to
+ * ETHTOOL_LINK_EXT_STATE_AUTONEG.
+ */
+enum ethtool_link_ext_substate_autoneg {
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE,
+	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD,
+};
+
+/**
+ * enum ethtool_link_ext_substate_link_training - more information in addition to
+ * ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE.
+ */
+enum ethtool_link_ext_substate_link_training {
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY,
+	ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT,
+};
+
+/**
+ * enum ethtool_link_ext_substate_logical_mismatch - more information in addition
+ * to ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH.
+ */
+enum ethtool_link_ext_substate_link_logical_mismatch {
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_AM_LOCK,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_GET_ALIGN_STATUS,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED,
+	ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED,
+};
+
+/**
+ * enum ethtool_link_ext_substate_bad_signal_integrity - more information in
+ * addition to ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY.
+ */
+enum ethtool_link_ext_substate_bad_signal_integrity {
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
+};
+
+/**
+ * enum ethtool_link_ext_substate_cable_issue - more information in
+ * addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE.
+ */
+enum ethtool_link_ext_substate_cable_issue {
+	ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE = 1,
+	ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE,
+};
+
 #define ETH_GSTRING_LEN		32
 
 /**
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index b18e7bc..0922ca6 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -236,6 +236,8 @@ enum {
 	ETHTOOL_A_LINKSTATE_LINK,		/* u8 */
 	ETHTOOL_A_LINKSTATE_SQI,		/* u32 */
 	ETHTOOL_A_LINKSTATE_SQI_MAX,		/* u32 */
+	ETHTOOL_A_LINKSTATE_EXT_STATE,		/* u8 */
+	ETHTOOL_A_LINKSTATE_EXT_SUBSTATE,	/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_LINKSTATE_CNT,
-- 
2.20.1

