Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61449CF79E
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730595AbfJHK4x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:56:53 -0400
Received: from mail-eopbgr790080.outbound.protection.outlook.com ([40.107.79.80]:64603
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730016AbfJHK4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 06:56:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n0OiEoccke3YCidsMN5bBnAVIhs6WCWxMbIrIeUfIgFmta0OjrR8cQHJOPUP/bi6UTMzmjQwKYrUsZR/2liLmJyTf2Kc8ondwu+rUdDxOLB/p+sIpK7TSyDa7LSGwn/1CUHMsak+NT1/gJtelhq8xJqbIWCAvAOlMmBU7ea8DsquTISzjBPzeGDdmsxGpY1LRwbKF46f+5A2eegsR9ZQy2oh0MWyj79s49+axwp5bPEvKjhgoMCMqdLV53R0/j9yYRhyp+xt9QCkAt4I2GctRGXiXZ1vG7UXB66AYliboYFrtlXTeBA9sPckcVV14qMKK/JytccpheWKn8yFjQqExg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYVKIC5RSto32twFzoDesnzGen56aUVLRtTOc8STp8c=;
 b=SBBKLVh4PXVx8ytly5+cBHi7BPQe13nwFtuzCUnXoMv8cxp1l2Fq5LkEhk1pPvmGcW5YgMO1v1wEK4mhJp+bpcZRCBN7PZrdy7nxfGsZyTuNjORxObVzVCdzl82wlb9MGC/ub4jQf2y9NDrkfEe3jZeI7PkfCqq7VQj4xd1ZBqpLiLz+snOWnnchtTp7LZ2uMVWXacGfOWpa8BpdasrFFZjDcfa3AhwuJrkAc5WogmJtDNgnRgRRu3a98WShweLlIt5/NC65DHDlaHQDJQYLEyGdwOE9UZWaWNKQS2uSCZD6P3787EP4AsoOLP8qol2oale+sbu1L6rbqAFvkY6dFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYVKIC5RSto32twFzoDesnzGen56aUVLRtTOc8STp8c=;
 b=SlJ6UXDSEW2Ur2H/ownms2fr7jmGrEsyOZrxCPCkDxJgBqizXUu0OY55V00Z3ih7clkfUfUjUXokba3vulxEFpN1S7VSfgzB/YtJPqfzu/H0WJhOX2hD68IgTWmwOaQU2rFI9py7TQ42LewrgRF+kH/h1D43+DC/ujCmRP2B6sY=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3666.namprd11.prod.outlook.com (20.178.221.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 10:56:45 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 10:56:45 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH v2 net-next 05/12] net: aquantia: styling fixes on ptp related
 functions
Thread-Topic: [PATCH v2 net-next 05/12] net: aquantia: styling fixes on ptp
 related functions
Thread-Index: AQHVfccTTnrcolat2Ey9cdI3fWtOWA==
Date:   Tue, 8 Oct 2019 10:56:45 +0000
Message-ID: <b0458485113dc9ad80769f6328edec881f5f1655.1570531332.git.igor.russkikh@aquantia.com>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1570531332.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0215.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::35) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccc822c6-aa36-4e40-3329-08d74bde3582
x-ms-traffictypediagnostic: BN8PR11MB3666:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB36665E6C9D70AD6F726685BB989A0@BN8PR11MB3666.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:79;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(346002)(376002)(396003)(39850400004)(136003)(189003)(199004)(118296001)(71190400001)(71200400001)(2501003)(256004)(6916009)(305945005)(316002)(107886003)(2351001)(4326008)(2906002)(44832011)(6116002)(7736002)(3846002)(54906003)(6486002)(6436002)(11346002)(5640700003)(6512007)(99286004)(25786009)(66556008)(50226002)(76176011)(52116002)(5660300002)(8936002)(2616005)(81156014)(66446008)(102836004)(81166006)(8676002)(386003)(6506007)(508600001)(14454004)(26005)(36756003)(86362001)(446003)(64756008)(476003)(486006)(66946007)(186003)(66476007)(66066001)(1730700003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3666;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WX7LghM2La+JNvxDawWm/toZoOlGT9tEuFoerKDK5uSYCLZJzcdmE+MlaqdIv/lkBT2zODUwrhXJjSJn6XNDQ0PR2u2DC4ywWTwoYx+JXZiNjnN2QqAMqrbII2LW7EcQuo8vIvFqu9Mn9bZBigaBnZwqb+ApshnW70FI5i8drtLi8k5xdriUWRBQZPxqRGWtM5m5T+9dyBpy+Di+sYd1YDj1kBEKmy37RO0naBtTvMgKtfoxNFqJoC8vUdSHa6oo37VeZHgFCTcD6eI1rxooz2BSP3TT3gRVQQKfFl+ix14gSL4ZGLsruU5GqKVnkpbBS2CQjLY0Yx1043DsMHHWeWnO60YFrQoPl/zkYh/ialq3LUqkqjFWxZNK8OMWQ0N4yblQFqldcwE3Zzchhk/0Z1IQ0LmW3VHv+YzJPLb3GmY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc822c6-aa36-4e40-3329-08d74bde3582
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 10:56:45.2110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kBGHn/xKdyXPCMU/1EjLcvyMkTNRLhpNcGh3tcH/KG0Jo2AXJe/0bkeSwSvjqlJjrh3D50pMFMfdkuGm8Svjkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>

Checkpatch and styling fixes on parts of code touched by ptp

Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c   | 4 ++--
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h   | 9 ++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index e3c5e2b30c09..255572f00bbc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -630,8 +630,8 @@ void hw_atl_rpb_rx_pkt_buff_size_per_tc_set(struct aq_h=
w_s *aq_hw,
 			    rx_pkt_buff_size_per_tc);
 }
=20
-void hw_atl_rpb_rx_xoff_en_per_tc_set(struct aq_hw_s *aq_hw, u32 rx_xoff_e=
n_per_tc,
-				      u32 buffer)
+void hw_atl_rpb_rx_xoff_en_per_tc_set(struct aq_hw_s *aq_hw,
+				      u32 rx_xoff_en_per_tc, u32 buffer)
 {
 	aq_hw_write_reg_bit(aq_hw, HW_ATL_RPB_RXBXOFF_EN_ADR(buffer),
 			    HW_ATL_RPB_RXBXOFF_EN_MSK,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
index d5042cc7ffeb..00b41fe5f1eb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
@@ -309,7 +309,8 @@ void hw_atl_rpb_rx_buff_lo_threshold_per_tc_set(struct =
aq_hw_s *aq_hw,
 					 u32 buffer);
=20
 /* set rx flow control mode */
-void hw_atl_rpb_rx_flow_ctl_mode_set(struct aq_hw_s *aq_hw, u32 rx_flow_ct=
l_mode);
+void hw_atl_rpb_rx_flow_ctl_mode_set(struct aq_hw_s *aq_hw,
+				     u32 rx_flow_ctl_mode);
=20
 /* set rx packet buffer size (per tc) */
 void hw_atl_rpb_rx_pkt_buff_size_per_tc_set(struct aq_hw_s *aq_hw,
@@ -320,7 +321,8 @@ void hw_atl_rpb_rx_pkt_buff_size_per_tc_set(struct aq_h=
w_s *aq_hw,
 void hw_atl_rdm_rx_dma_desc_cache_init_set(struct aq_hw_s *aq_hw, u32 init=
);
=20
 /* set rx xoff enable (per tc) */
-void hw_atl_rpb_rx_xoff_en_per_tc_set(struct aq_hw_s *aq_hw, u32 rx_xoff_e=
n_per_tc,
+void hw_atl_rpb_rx_xoff_en_per_tc_set(struct aq_hw_s *aq_hw,
+				      u32 rx_xoff_en_per_tc,
 				      u32 buffer);
=20
 /* rpf */
@@ -626,7 +628,8 @@ void hw_atl_tpb_tx_dma_sys_lbk_en_set(struct aq_hw_s *a=
q_hw, u32 tx_dma_sys_lbk_
=20
 /* set tx packet buffer size (per tc) */
 void hw_atl_tpb_tx_pkt_buff_size_per_tc_set(struct aq_hw_s *aq_hw,
-					    u32 tx_pkt_buff_size_per_tc, u32 buffer);
+					    u32 tx_pkt_buff_size_per_tc,
+					    u32 buffer);
=20
 /* set tx path pad insert enable */
 void hw_atl_tpb_tx_path_scp_ins_en_set(struct aq_hw_s *aq_hw, u32 tx_path_=
scp_ins_en);
--=20
2.17.1

