Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB68349C5D9
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 10:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238802AbiAZJIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 04:08:54 -0500
Received: from mail-dm6nam08on2121.outbound.protection.outlook.com ([40.107.102.121]:29984
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238779AbiAZJIt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 04:08:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TD/2Fe96lBPp7zdWRKgxptFIZMx79qsVPvw1wh3Z6ZVGvcFhQJ+RBhcz6tT9RKGfnKSVzBhsr0La1mGaLwV3Qr7lmBSQ5Uctwvv6q+j5SQf/HAQQc8lnGHPmiD3tviAbGudHSzdCs35Ed/HKJf6+GsFV/VGde7wNVXIljfDk8eR1B18T3c5cYwMYwOVIACrf4T2x3CuvpejaLGXefjAzsNZnnlrNvc68pbkFg/gtiurdcERWpxNHrP2HhrOMTSIxqkFH31WtmKefregDb07Nu9KxIeuOgHCAn4VZ1qFnmz74LtcXhPW9kUo5zD0lSG7PPEM8+cAv5txoFuW/tSI5xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AIPWtj0xYLefmwGa+wmlmS8UhNF62t0rabHik1ROeAM=;
 b=OWpD1yiEPrJJZrFeQWRZ2mCnl8AKlVraNThTDqOW/xop7PIOBJKwwvOV3h8odkiU3R/vE1lSKqoMCxuuGh8fHoDX8FYMRjqp/LH4haseNlWK4t4cjou3de12owszP5aOLN79WSsDOfi60+3QN958E3aS4XCo5AteC3VT3ilFJiw8H2slUG29anv1IZUfq+lkvS66abSS6e+NOtS+9xLBANJABU9n7ppAgCfRhAnNWgSPNSQc6c/QO88LYB+0MOyDsF4Qv8b3EWyhxeVLBSccEy6J1AfEZOIDy0cneQVexWFKABUSOS28a/fP5VuKwdAMdu1wC4jV3QbcLnDqPp29LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AIPWtj0xYLefmwGa+wmlmS8UhNF62t0rabHik1ROeAM=;
 b=Y3f/f0ORqs3VGXEknZFzS1vb3UC2SmO2enIeMfLJ82oETVNjINnvBqFHXY5z/EXqMz5TuMLs5twRrhO0G+s/mz9QtnVflrbkd6RHXnE7uS7rHDNgjCqhmSQM7R4hYUfO3z+X2h3hemctTobtJ4NFNNtWQX8cVUKgQucy0WcEQ0c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BYAPR13MB2312.namprd13.prod.outlook.com (2603:10b6:a02:c0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.14; Wed, 26 Jan
 2022 09:08:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f486:da6a:1232:9008]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f486:da6a:1232:9008%3]) with mapi id 15.20.4930.015; Wed, 26 Jan 2022
 09:08:45 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next] nfp: only use kdoc style comments for kdoc
Date:   Wed, 26 Jan 2022 10:08:03 +0100
Message-Id: <20220126090803.5582-1-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0008.eurprd02.prod.outlook.com
 (2603:10a6:200:89::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16e71ff7-e6da-4cd4-6fe9-08d9e0ab74e3
X-MS-TrafficTypeDiagnostic: BYAPR13MB2312:EE_
X-Microsoft-Antispam-PRVS: <BYAPR13MB23126F72D1CACF252B21DCDAE8209@BYAPR13MB2312.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +j5dzuzHJ7MmuR//TDmvlToFDeUHhR7jjKL9G3JCxl+x6/BHX3/LLrMBFVVZZlbiakJ4UWxkkDMELdIQf702lAMW76nAyBeG6tWSj6WngVixrxk1VkhtrCOHoOncG5JuPo/ZfC1bkg5HFEoXRPPFmt34mhdX0BWjL4gIbrG2eFnzygAW1ZLEY94bvbstYUIN+0nktd9Ay46pO33kc7SZqoOMpp6hPhbipX0xH3dKYG5iMforHbsUfRHRRVcC9TyyjzdsXGxH4Km3GR/pkb9hWOuajbNb987lDC2ma4LzQT2BYyYwumjk2mqP5CdqEWW62QRn8DjJ7iCkeXTbmpIdyXaDL3Xyh7RHtjFWufXmVsQqadYrGZycEgT1f/yAbByPj63SELi4VednGDO7lgwgvmDdhZ0M+0BSlE/Gt0Lzf9PIl4YSINtKRY9KyeVbtsukiCpVWPQHH+A7+o0nzuNGA6MRajIQgKuvjeTD3xhO6HWhsN+R/28RBsVGQziGh5N9uOBRmgdv6Yj01kUYkUZ3pfA5bMXHaDuc6A2D0fntm9CHDACMN1nE6waGNTByLUmMxcgoNzRIonzuJx6yBnDEQH0FJykDMvk4VwmvrxPYvvlGho9zbqUHWRF1iSe5/ei5v7zagM9kIICVq/cVmbv8FA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(136003)(366004)(376002)(346002)(396003)(2906002)(2616005)(38100700002)(186003)(107886003)(44832011)(1076003)(508600001)(52116002)(110136005)(36756003)(316002)(8936002)(6666004)(8676002)(86362001)(66946007)(6512007)(5660300002)(66476007)(6486002)(4326008)(66556008)(83380400001)(6506007)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dicmclr+aaeotWu8DrrlIpzRz1ehkynmqPt9cM52ynBWLsAsN7v6uSM3zXwQ?=
 =?us-ascii?Q?4yLxwtEm2MyXJS0b4IOocv6cvS8PPcKyNyhFU6pn2GshPVtCzwbYO+3vrAeR?=
 =?us-ascii?Q?1XKmH03fxqkhXgPl0yPVNKeogNahWqHdlOhxlidagKRdS2yPh3wCm2DA7p92?=
 =?us-ascii?Q?kKt466rL10QPnxeLvOemKXsFzUnf+ojRjfcK5vkVj6vNE7rHUn+3QBW+4UKD?=
 =?us-ascii?Q?0tafGn5VNpkRtfLMY4EdtMblTmB8o9O9I+n9gXF8qGpvE73gbLQXVtdhGbYR?=
 =?us-ascii?Q?PcuZJ9xMifSQjtpnrINyoUNLdz6xmJg+xz049o0aPWMANan+dGWC+GimpACX?=
 =?us-ascii?Q?HpeCYjqFF2v817flzI06zrT1lQD3FbAlDMI9T1cUqGk3rlhIizDMg3ro18TM?=
 =?us-ascii?Q?KgAhhBg44Ic4m1uk3t82hX/zUpmPJTAwv8fNKhahL+/cZtyKr1W35lIopuTA?=
 =?us-ascii?Q?ijzm+lXx7dhF4TTu86ChtT90+imIPyKmXtsnBbsmgwOUmvPecqGmENVPpjaY?=
 =?us-ascii?Q?qCcPnHBg4HVJlFyCMIe4g2sCjZMdPe+ynUboq7+pzU7YSZ3Dhi9fj7tmtL4G?=
 =?us-ascii?Q?4bPsHqtHk8g9sNy7XcE+hW78le4nIU7t0u0v8UyNqv57w0Lm1n7sHdMt+CPA?=
 =?us-ascii?Q?qUDp3Auwl1fPUs30WOlu8NULCELTJst8kw4Q7iWS+NxhnwyFsKpnHIh9Nhjj?=
 =?us-ascii?Q?eEgX/UkQ0JDmPcqRGqbGPlBpfjb7FUn/WD0H277tGbVV2qhvyNojNvPIXPpt?=
 =?us-ascii?Q?q2Ac5ZzvXFE5eEkaSEGAb7pGUVaZCnyb5eAEZ1F6kfT4RQj1JNnvFdgTCyqR?=
 =?us-ascii?Q?YK6dL7/vNK/WZRWTr9IsQHYnYBwB+2XZ+afqXX2ArWVif9yroKNGRs/FwaKA?=
 =?us-ascii?Q?u5t+EqZLi2b77Z8f0mGiHNwtxIFMOk8P88ZCTOCLxuVOFF98nGr0HEbbOwAW?=
 =?us-ascii?Q?rWsBkUuMYTdifM+qy1c4Nu1rotvjrb9HL/xQbyOP8q+HFDk83qCcE/qIzbDd?=
 =?us-ascii?Q?P1fnlfzyMtHB6cdQNStFjXu9QRFliue5QS1T1F/nIk/o4uI5BNSweueSpKTh?=
 =?us-ascii?Q?PjXtxtvJT0ojdSu6mkER2TXyahEeFIHmk/q6JMpTiQnwJveQ6lTC5cONkGO0?=
 =?us-ascii?Q?ImpEeE8FApkWG7L/SSY/5KMn3NyryQ5vKhWe1yIseJxBAcCzL9pFt7YJ6gA8?=
 =?us-ascii?Q?K7h2XCiuLbNBz3aNzqz0Ie2iFGfi1J2yIhFQBo62IPQZsRS3iq2n8nLcMTDz?=
 =?us-ascii?Q?tJ/ByHlTSGfDg6ZwuGsKeo8J/wa7Bdaf8QI9iG8EBA/hh2orGcZARDifM/x4?=
 =?us-ascii?Q?wMwPech93mNTQHA4pIG4b1rqPJaI4OUwaiIyLOZnRdodtbnFOCtYEZTVYxDR?=
 =?us-ascii?Q?3vgOQ9SxLW8J7OPaVyf0qk9stpUyxlbe3onTT+nNnGxxvsHdkoRbmIllij4p?=
 =?us-ascii?Q?YsjOlMptLUMbLHOgox5/QLNxGYc57pmwrjCecYbnWfQmpxVSxRSPVuVqBYYD?=
 =?us-ascii?Q?BN0DFyypFt3EEXi7WEbDO0btQAvqc+9faLQ/yt1VE7tuX6BHYH6T9RpJ+m+Z?=
 =?us-ascii?Q?Bdx7LzxnbfL/7IrxbTmPS/etadHVZu5UlhCmRInpvXkUQVHp/IrpAe3QHxq9?=
 =?us-ascii?Q?wU7n2rEPXuirWR2wOmw1aYdsYUlSatRJrb6Ny1deL2Dz8uqOBJTK3W4fqkkv?=
 =?us-ascii?Q?RdI24x4eXahVO7ydyf3sfA3dEdho9840ZAT3TVt3npOt041J5COczMIduE0g?=
 =?us-ascii?Q?hK2I5G46YA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16e71ff7-e6da-4cd4-6fe9-08d9e0ab74e3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2022 09:08:45.7852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TVi/DWnnNQWQBf3THGZZot8uxzyiUEaDgX6vNVk8BR1MZCMnEfi0UBBqCOukbDzS6XMZWvTzUEqck+jSNna0xxCxUfec716xmo6Y9ucYG7o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR13MB2312
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update comments to only use kdoc style comments, starting with '/**',
for kdoc.

Flagged by ./scripts/kernel-doc

Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h | 81 ++++++-------------
 .../ethernet/netronome/nfp/nfp_net_sriov.h    |  3 +-
 drivers/net/ethernet/netronome/nfp/nfp_port.h |  3 +-
 3 files changed, 28 insertions(+), 59 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index 3d61a8cb60b0..50007cc5b580 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -1,8 +1,7 @@
 /* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */
 /* Copyright (C) 2015-2018 Netronome Systems, Inc. */
 
-/*
- * nfp_net_ctrl.h
+/* nfp_net_ctrl.h
  * Netronome network device driver: Control BAR layout
  * Authors: Jakub Kicinski <jakub.kicinski@netronome.com>
  *          Jason McMullan <jason.mcmullan@netronome.com>
@@ -15,30 +14,24 @@
 
 #include <linux/types.h>
 
-/**
- * Configuration BAR size.
+/* Configuration BAR size.
  *
  * The configuration BAR is 8K in size, but due to
  * THB-350, 32k needs to be reserved.
  */
 #define NFP_NET_CFG_BAR_SZ		(32 * 1024)
 
-/**
- * Offset in Freelist buffer where packet starts on RX
- */
+/* Offset in Freelist buffer where packet starts on RX */
 #define NFP_NET_RX_OFFSET		32
 
-/**
- * LSO parameters
+/* LSO parameters
  * %NFP_NET_LSO_MAX_HDR_SZ:	Maximum header size supported for LSO frames
  * %NFP_NET_LSO_MAX_SEGS:	Maximum number of segments LSO frame can produce
  */
 #define NFP_NET_LSO_MAX_HDR_SZ		255
 #define NFP_NET_LSO_MAX_SEGS		64
 
-/**
- * Prepend field types
- */
+/* Prepend field types */
 #define NFP_NET_META_FIELD_SIZE		4
 #define NFP_NET_META_HASH		1 /* next field carries hash type */
 #define NFP_NET_META_MARK		2
@@ -49,9 +42,7 @@
 
 #define NFP_META_PORT_ID_CTRL		~0U
 
-/**
- * Hash type pre-pended when a RSS hash was computed
- */
+/* Hash type pre-pended when a RSS hash was computed */
 #define NFP_NET_RSS_NONE		0
 #define NFP_NET_RSS_IPV4		1
 #define NFP_NET_RSS_IPV6		2
@@ -63,16 +54,14 @@
 #define NFP_NET_RSS_IPV6_UDP		8
 #define NFP_NET_RSS_IPV6_EX_UDP		9
 
-/**
- * Ring counts
+/* Ring counts
  * %NFP_NET_TXR_MAX:	     Maximum number of TX rings
  * %NFP_NET_RXR_MAX:	     Maximum number of RX rings
  */
 #define NFP_NET_TXR_MAX			64
 #define NFP_NET_RXR_MAX			64
 
-/**
- * Read/Write config words (0x0000 - 0x002c)
+/* Read/Write config words (0x0000 - 0x002c)
  * %NFP_NET_CFG_CTRL:	     Global control
  * %NFP_NET_CFG_UPDATE:      Indicate which fields are updated
  * %NFP_NET_CFG_TXRS_ENABLE: Bitmask of enabled TX rings
@@ -147,8 +136,7 @@
 #define NFP_NET_CFG_LSC			0x0020
 #define NFP_NET_CFG_MACADDR		0x0024
 
-/**
- * Read-only words (0x0030 - 0x0050):
+/* Read-only words (0x0030 - 0x0050):
  * %NFP_NET_CFG_VERSION:     Firmware version number
  * %NFP_NET_CFG_STS:	     Status
  * %NFP_NET_CFG_CAP:	     Capabilities (same bits as %NFP_NET_CFG_CTRL)
@@ -193,36 +181,31 @@
 #define NFP_NET_CFG_START_TXQ		0x0048
 #define NFP_NET_CFG_START_RXQ		0x004c
 
-/**
- * Prepend configuration
+/* Prepend configuration
  */
 #define NFP_NET_CFG_RX_OFFSET		0x0050
 #define NFP_NET_CFG_RX_OFFSET_DYNAMIC		0	/* Prepend mode */
 
-/**
- * RSS capabilities
+/* RSS capabilities
  * %NFP_NET_CFG_RSS_CAP_HFUNC:	supported hash functions (same bits as
  *				%NFP_NET_CFG_RSS_HFUNC)
  */
 #define NFP_NET_CFG_RSS_CAP		0x0054
 #define   NFP_NET_CFG_RSS_CAP_HFUNC	  0xff000000
 
-/**
- * TLV area start
+/* TLV area start
  * %NFP_NET_CFG_TLV_BASE:	start anchor of the TLV area
  */
 #define NFP_NET_CFG_TLV_BASE		0x0058
 
-/**
- * VXLAN/UDP encap configuration
+/* VXLAN/UDP encap configuration
  * %NFP_NET_CFG_VXLAN_PORT:	Base address of table of tunnels' UDP dst ports
  * %NFP_NET_CFG_VXLAN_SZ:	Size of the UDP port table in bytes
  */
 #define NFP_NET_CFG_VXLAN_PORT		0x0060
 #define NFP_NET_CFG_VXLAN_SZ		  0x0008
 
-/**
- * BPF section
+/* BPF section
  * %NFP_NET_CFG_BPF_ABI:	BPF ABI version
  * %NFP_NET_CFG_BPF_CAP:	BPF capabilities
  * %NFP_NET_CFG_BPF_MAX_LEN:	Maximum size of JITed BPF code in bytes
@@ -247,14 +230,12 @@
 #define   NFP_NET_CFG_BPF_CFG_MASK	7ULL
 #define   NFP_NET_CFG_BPF_ADDR_MASK	(~NFP_NET_CFG_BPF_CFG_MASK)
 
-/**
- * 40B reserved for future use (0x0098 - 0x00c0)
+/* 40B reserved for future use (0x0098 - 0x00c0)
  */
 #define NFP_NET_CFG_RESERVED		0x0098
 #define NFP_NET_CFG_RESERVED_SZ		0x0028
 
-/**
- * RSS configuration (0x0100 - 0x01ac):
+/* RSS configuration (0x0100 - 0x01ac):
  * Used only when NFP_NET_CFG_CTRL_RSS is enabled
  * %NFP_NET_CFG_RSS_CFG:     RSS configuration word
  * %NFP_NET_CFG_RSS_KEY:     RSS "secret" key
@@ -281,8 +262,7 @@
 					 NFP_NET_CFG_RSS_KEY_SZ)
 #define NFP_NET_CFG_RSS_ITBL_SZ		0x80
 
-/**
- * TX ring configuration (0x200 - 0x800)
+/* TX ring configuration (0x200 - 0x800)
  * %NFP_NET_CFG_TXR_BASE:    Base offset for TX ring configuration
  * %NFP_NET_CFG_TXR_ADDR:    Per TX ring DMA address (8B entries)
  * %NFP_NET_CFG_TXR_WB_ADDR: Per TX ring write back DMA address (8B entries)
@@ -301,8 +281,7 @@
 #define NFP_NET_CFG_TXR_IRQ_MOD(_x)	(NFP_NET_CFG_TXR_BASE + 0x500 + \
 					 ((_x) * 0x4))
 
-/**
- * RX ring configuration (0x0800 - 0x0c00)
+/* RX ring configuration (0x0800 - 0x0c00)
  * %NFP_NET_CFG_RXR_BASE:    Base offset for RX ring configuration
  * %NFP_NET_CFG_RXR_ADDR:    Per RX ring DMA address (8B entries)
  * %NFP_NET_CFG_RXR_SZ:      Per RX ring ring size (1B entries)
@@ -318,8 +297,7 @@
 #define NFP_NET_CFG_RXR_IRQ_MOD(_x)	(NFP_NET_CFG_RXR_BASE + 0x300 + \
 					 ((_x) * 0x4))
 
-/**
- * Interrupt Control/Cause registers (0x0c00 - 0x0d00)
+/* Interrupt Control/Cause registers (0x0c00 - 0x0d00)
  * These registers are only used when MSI-X auto-masking is not
  * enabled (%NFP_NET_CFG_CTRL_MSIXAUTO not set).  The array is index
  * by MSI-X entry and are 1B in size.  If an entry is zero, the
@@ -334,8 +312,7 @@
 #define   NFP_NET_CFG_ICR_RXTX		0x1
 #define   NFP_NET_CFG_ICR_LSC		0x2
 
-/**
- * General device stats (0x0d00 - 0x0d90)
+/* General device stats (0x0d00 - 0x0d90)
  * all counters are 64bit.
  */
 #define NFP_NET_CFG_STATS_BASE		0x0d00
@@ -368,8 +345,7 @@
 #define NFP_NET_CFG_STATS_APP3_FRAMES	(NFP_NET_CFG_STATS_BASE + 0xc0)
 #define NFP_NET_CFG_STATS_APP3_BYTES	(NFP_NET_CFG_STATS_BASE + 0xc8)
 
-/**
- * Per ring stats (0x1000 - 0x1800)
+/* Per ring stats (0x1000 - 0x1800)
  * options, 64bit per entry
  * %NFP_NET_CFG_TXR_STATS:   TX ring statistics (Packet and Byte count)
  * %NFP_NET_CFG_RXR_STATS:   RX ring statistics (Packet and Byte count)
@@ -381,8 +357,7 @@
 #define NFP_NET_CFG_RXR_STATS(_x)	(NFP_NET_CFG_RXR_STATS_BASE + \
 					 ((_x) * 0x10))
 
-/**
- * General use mailbox area (0x1800 - 0x19ff)
+/* General use mailbox area (0x1800 - 0x19ff)
  * 4B used for update command and 4B return code
  * followed by a max of 504B of variable length value
  */
@@ -399,8 +374,7 @@
 #define NFP_NET_CFG_MBOX_CMD_PCI_DSCP_PRIOMAP_SET	5
 #define NFP_NET_CFG_MBOX_CMD_TLV_CMSG			6
 
-/**
- * VLAN filtering using general use mailbox
+/* VLAN filtering using general use mailbox
  * %NFP_NET_CFG_VLAN_FILTER:		Base address of VLAN filter mailbox
  * %NFP_NET_CFG_VLAN_FILTER_VID:	VLAN ID to filter
  * %NFP_NET_CFG_VLAN_FILTER_PROTO:	VLAN proto to filter
@@ -411,8 +385,7 @@
 #define  NFP_NET_CFG_VLAN_FILTER_PROTO	 (NFP_NET_CFG_VLAN_FILTER + 2)
 #define NFP_NET_CFG_VLAN_FILTER_SZ	 0x0004
 
-/**
- * TLV capabilities
+/* TLV capabilities
  * %NFP_NET_CFG_TLV_TYPE:	Offset of type within the TLV
  * %NFP_NET_CFG_TLV_TYPE_REQUIRED: Driver must be able to parse the TLV
  * %NFP_NET_CFG_TLV_LENGTH:	Offset of length within the TLV
@@ -438,8 +411,7 @@
 #define NFP_NET_CFG_TLV_HEADER_TYPE	0x7fff0000
 #define NFP_NET_CFG_TLV_HEADER_LENGTH	0x0000ffff
 
-/**
- * Capability TLV types
+/* Capability TLV types
  *
  * %NFP_NET_CFG_TLV_TYPE_UNKNOWN:
  * Special TLV type to catch bugs, should never be encountered.  Drivers should
@@ -512,8 +484,7 @@
 
 struct device;
 
-/**
- * struct nfp_net_tlv_caps - parsed control BAR TLV capabilities
+/* struct nfp_net_tlv_caps - parsed control BAR TLV capabilities
  * @me_freq_mhz:	ME clock_freq (MHz)
  * @mbox_off:		vNIC mailbox area offset
  * @mbox_len:		vNIC mailbox area length
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
index a3db0cbf6425..786be58a907e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_sriov.h
@@ -4,8 +4,7 @@
 #ifndef _NFP_NET_SRIOV_H_
 #define _NFP_NET_SRIOV_H_
 
-/**
- * SRIOV VF configuration.
+/* SRIOV VF configuration.
  * The configuration memory begins with a mailbox region for communication with
  * the firmware followed by individual VF entries.
  */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.h b/drivers/net/ethernet/netronome/nfp/nfp_port.h
index ae4da189d955..df316b9e891d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.h
@@ -132,8 +132,7 @@ void nfp_devlink_port_unregister(struct nfp_port *port);
 void nfp_devlink_port_type_eth_set(struct nfp_port *port);
 void nfp_devlink_port_type_clear(struct nfp_port *port);
 
-/**
- * Mac stats (0x0000 - 0x0200)
+/* Mac stats (0x0000 - 0x0200)
  * all counters are 64bit.
  */
 #define NFP_MAC_STATS_BASE                0x0000
-- 
2.20.1

