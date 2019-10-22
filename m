Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 216ADE0133
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731623AbfJVJxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:53:39 -0400
Received: from mail-eopbgr780047.outbound.protection.outlook.com ([40.107.78.47]:41694
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731615AbfJVJxi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:53:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBbf/Z+AGIPen3pC8R9SW9iWnI12n6lPTN6v8C+O4kb35iRy7N0u8PBJ5trx3iOCmjsYlP74/uuCbHCy3c/zjVtSA8foX5ZdPaaGbnhl60YOIHVE9kTEMZN0zFjMYoamO5X0m7tN83wkU8YnR/IySu0X0v+Gu+VM9r4u+BiDCsqjRkI4SIVLu+eJjHK2hG5Aw6e2D9Lba6HRas8X+7QOD0WTt8mqzRSyBJztqX4YXuWygUemNrH2rDauFOeYlpIrinCDp6XNWGKHttvpl/n3KuKJgPslbe8wf57jUPxwgF0bFiGocbKhpVbIU+mbeQuo3NuOuCP5OtQxZoJLLYRl9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsPBHvrWK+7CbjnX1BK01cg6V0/Yom2RiA5K0juMqCo=;
 b=MakKD0v3GmLAvU4KjgRoo3zd7pPENrVZTMBjJqaZnPipFKVWILX3LTz3ilv3mB8xl9KBqMTgxkZrITX4ptsI6bNYG7OvYto1okbQcFANQip+iTHUWepoZGbAocIp30Q0L2h70ISco5177jQwNjY3lJ/OfGnAppb2/0oYTsm8gzagonkxtPGlmTjxnGbe6SdJoT6abFD5LjLGxLh36d4f38Z9doOQcHSbkV5/fO5Pmked7yu2nQVtof6pewntWPX9mjOpzvScsjOhlMsPu2BOHxfkN+kDLCxJUEA4iK1vXSJuLzsc5EwQipJI/wEPxGqsVCW8xYUzfbUNOMLgqkPXGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsPBHvrWK+7CbjnX1BK01cg6V0/Yom2RiA5K0juMqCo=;
 b=tt51YywuxIk1kfJG0INUqE1C4eMgqSSwum6/dZ1oE/9XV40lZUIUVcZI/RlxG+pYme0KTTyFEY7KAqB6vIqfeNMBOXX06w4NvNNpduxrZY1IAi0pe3yqlnJFDpk3bnuwD16kWvLYchIZkXL68HjVxPFkXPlHeeDz0uzSIluZakU=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3732.namprd11.prod.outlook.com (20.178.218.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Tue, 22 Oct 2019 09:53:32 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.028; Tue, 22 Oct 2019
 09:53:32 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "epomozov@marvell.com" <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH v3 net-next 05/12] net: aquantia: styling fixes on ptp related
 functions
Thread-Topic: [PATCH v3 net-next 05/12] net: aquantia: styling fixes on ptp
 related functions
Thread-Index: AQHViL6QAVfIQndMXky9RbO+Uz32bA==
Date:   Tue, 22 Oct 2019 09:53:32 +0000
Message-ID: <c099b2285e5b81a009dfc55fa87b17a9ea99d72b.1571737612.git.igor.russkikh@aquantia.com>
References: <cover.1571737612.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1571737612.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MR2P264CA0092.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::32) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5fd26471-c1b4-4c1c-a7ca-08d756d5b258
x-ms-traffictypediagnostic: BN8PR11MB3732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB373247EED1B00EA1353C7A6C98680@BN8PR11MB3732.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:79;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(366004)(376002)(396003)(199004)(189003)(2616005)(25786009)(8936002)(81166006)(86362001)(486006)(81156014)(1730700003)(44832011)(476003)(8676002)(50226002)(186003)(71190400001)(11346002)(446003)(256004)(71200400001)(3846002)(2906002)(118296001)(66556008)(64756008)(66446008)(6116002)(66476007)(5660300002)(66946007)(6512007)(99286004)(5640700003)(4326008)(54906003)(316002)(107886003)(6486002)(7736002)(305945005)(6436002)(66066001)(26005)(6506007)(386003)(14454004)(102836004)(508600001)(6916009)(52116002)(76176011)(36756003)(2351001)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3732;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oX5fkiZg2wbdHdpoiAp08XfHNnruuXZQVLAOtg1rlQam9hdvZFYcHIJBA7FN+hEz4JUSxO+9GPcRlO/b5CgPqAy8klVf1FJ5rhoiwpFhEZIegOdv9NTyAeaLgUiO93w/zmi0oBY5oj357Sg4j8294N0NhOTAPS3QgccpN6saKdm4KTiMaZtXaV6vZ1Aib4L5ik6BnTYg6OhGJPAaq80+qC1d7jqLQWuUwxpgvT+Wx30uGx5A56FFKrJN8zq5uWyCf1LOlQjx3OHwKG0kqgs3F9FzJEiL7RfoNLCysdMZW66RZuXllLgraKgmXNUTvqxKY6B267TmZJrkjrKNNFcAKaVjtU49YWChsHf+CRMr16hJjV1ROFReBhBulzu4Q9hBzy+dbogXUllUES0EfZs6F8co4fEIufln2HbpKtLgiaojLuw1MKFBrdSMwG2f5ha6
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fd26471-c1b4-4c1c-a7ca-08d756d5b258
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 09:53:32.4277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xlH+6n985Vvy9NgR5ewoRIdVZ2uYBa2a4Ws9rs7MMeF1RHKyMiQeeNTc4l0h7TP/zo/S4Pax7mw0160tQIZVOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3732
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>

Checkpatch and styling fixes on parts of code touched by ptp

Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c   | 4 ++--
 .../net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h   | 9 ++++++---
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index 368b5caf3c49..d83f1a34a537 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -643,8 +643,8 @@ void hw_atl_rpb_rx_pkt_buff_size_per_tc_set(struct aq_h=
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
index a579864b6ba1..b192702a7b8b 100644
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
@@ -323,7 +324,8 @@ void hw_atl_rdm_rx_dma_desc_cache_init_tgl(struct aq_hw=
_s *aq_hw);
 u32 hw_atl_rdm_rx_dma_desc_cache_init_done_get(struct aq_hw_s *aq_hw);
=20
 /* set rx xoff enable (per tc) */
-void hw_atl_rpb_rx_xoff_en_per_tc_set(struct aq_hw_s *aq_hw, u32 rx_xoff_e=
n_per_tc,
+void hw_atl_rpb_rx_xoff_en_per_tc_set(struct aq_hw_s *aq_hw,
+				      u32 rx_xoff_en_per_tc,
 				      u32 buffer);
=20
 /* rpf */
@@ -629,7 +631,8 @@ void hw_atl_tpb_tx_dma_sys_lbk_en_set(struct aq_hw_s *a=
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

