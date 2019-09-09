Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D991ADA18
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 15:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbfIINiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 09:38:52 -0400
Received: from mail-eopbgr770052.outbound.protection.outlook.com ([40.107.77.52]:40429
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729805AbfIINit (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 09:38:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M0t2a5mFtJUFr9GQH3/WqGBX7BLMRk+mIqG/i2BSQtAmD7Jb0kI6Z1G/1jurf5iAfkcCKy2wBt3oPOFzQ0GbiM15zK4ip1PhuqdUCoOGWfjJ3ZA/0j9Pnx6Vm7y0MH4VcQiF1zXIGr0jEkkCYagxL64zY2oiKPkpIy+lFByYChURs21udT6uWdSYRIhXMvboV77k6j9VoYBkOFx7+M6AraOTiJVcoABS5HidJCMLB7DOja+aVEh3X0/B/lBm5oAdcXIueQpxfPGoTaTDNgE9uo55C5ru4MRTgoiR1W6MMW7DGh0/Jo66z2DGq18axQGLFJwvPJZw3iadsAWU4/kWwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYVKIC5RSto32twFzoDesnzGen56aUVLRtTOc8STp8c=;
 b=ofNFK5nJOaURU2o7MeVqofuPbA13n7u6nOpwqCMQHTw4k3Tp4BRGh5RwZ3qSMxVrI2kgByNrTXYsr3AcbwfKqL+TqRxJVtOEUTcxnF6rV+hZtFz0SsGvPSuVCKcqEh2nO/9ROJN9lQ0+XlFWpVfvaAx5pmkmM3FwTe9gdFddvj5JLntCIRIE1BZfZihFpeHf5Mclw74gL31taWuq83AvNt3THB8bjI+zbU6QdyaE/ccB4nM8i40jvIGi+xdKPW2NleorpaqZ/bgIit1vDDPOUt2TC3vR+qM3/L69VXP94CGtFphl4J+muagSnoZAj7JT69SoF19VI0DrDwBZCiV36w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYVKIC5RSto32twFzoDesnzGen56aUVLRtTOc8STp8c=;
 b=jMs4QyRPNaB62nY7K9S/V0P3UkgCxkC3PdPlvoFIPLyZ5gxIUlh84hmb2Dfb4k03BqIeTun2k8yV2tOWBjxnSsXWVkGZcdsdOZiX18XWfz+MwW6vbadixKFimFzf8qvfNprBaBswsHM2NNYQV0QZ+NM7bmkW6YQlbvwpiq1+Lyo=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB1747.namprd11.prod.outlook.com (10.175.99.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.20; Mon, 9 Sep 2019 13:38:46 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 13:38:46 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 05/11] net: aquantia: styling fixes on ptp related
 functions
Thread-Topic: [PATCH net-next 05/11] net: aquantia: styling fixes on ptp
 related functions
Thread-Index: AQHVZxPnam43/gd170ySPPzNaCN23Q==
Date:   Mon, 9 Sep 2019 13:38:46 +0000
Message-ID: <6b887464f01bfb00e7ec70a817eb51ddc214f00d.1568034880.git.igor.russkikh@aquantia.com>
References: <cover.1568034880.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1568034880.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0298.eurprd05.prod.outlook.com
 (2603:10a6:7:93::29) To BN6PR11MB4081.namprd11.prod.outlook.com
 (2603:10b6:405:78::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e3ed0da-2bc2-4c94-9431-08d7352b0a1f
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1747;
x-ms-traffictypediagnostic: BN6PR11MB1747:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB17470677EE3E2A137C746DBD98B70@BN6PR11MB1747.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:79;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39840400004)(346002)(366004)(376002)(136003)(189003)(199004)(26005)(25786009)(6436002)(6486002)(118296001)(305945005)(99286004)(5640700003)(256004)(64756008)(1730700003)(107886003)(81166006)(81156014)(66446008)(316002)(478600001)(66476007)(76176011)(4326008)(8676002)(86362001)(52116002)(66556008)(53936002)(186003)(2501003)(6506007)(386003)(476003)(11346002)(5660300002)(2616005)(44832011)(66066001)(36756003)(3846002)(8936002)(6512007)(2906002)(486006)(6116002)(71190400001)(14454004)(7736002)(66946007)(6916009)(54906003)(102836004)(50226002)(2351001)(446003)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB1747;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: p3QFZxN/HpA9dgdwAKBqm9T8LGctu8CejNvOOhnaQRkpQiL26/xTTXKcePALZozllgoBz0gdju5IEjETEfov3PE6xA37uShh1nRMdsSKR+JgU3BmZuJtRRcshKbEXAUt6iK98t/J9FFe6UexU85YlHk4BJZw+E59V9slX+2CNC80VF7KOVz+Q2o11Mwn2yvirXSdwNGAe9dNqP5lmVSatWxYNiTNUbRbOb5mnlhAXDoGNfQDVynnA3FKNIvSAzuCL0kZ2n8rKc4eV2gtZiDtvkkRgmATxgWHF3Cj8917gnORg/xiW95rBkGmtN5P8ck7gax9QiMUx1FVuX+Z0oBVaQab5t/L6INZIqjEW2MFVs6Y/ATxUx7VRE18/Iz7qNNjmgeeuy+eHOJpZw0SGoSlUVfisUEm9Kerx+8FVhMdknI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e3ed0da-2bc2-4c94-9431-08d7352b0a1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 13:38:46.7081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FuTH2B/hunN+TSjAdKEdF6ZMdrGWCxoVGxIb6tOl6gaATmagnAFGeyaMGUxo+nOUfuo+/GzIak9O9LLw72YR0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1747
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

