Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFADF1F723
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 17:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbfEOPHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 11:07:52 -0400
Received: from mail-eopbgr40060.outbound.protection.outlook.com ([40.107.4.60]:19639
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726583AbfEOPHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 11:07:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JPyHAVn1yjamIRuJl5bdRhc2MQ4we7qEF5t+Xy+R750=;
 b=ZIsTzJBn9u5MQpKHxe0JtyqnMpwA9kKJmpLymI4YskqGLXloAeIIA0kNZcZkS60I2uh+Tz7KXRm73n6YF6JDB4zVpUQ3tpbqhuGrSkVyQda11t5QqokNt5V+lGdVbs41YpORTKbJG7Gkn7G2wp7DGt+hl12mjSfCrrB3vWGxEcA=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB5344.eurprd04.prod.outlook.com (52.134.123.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 15 May 2019 15:07:44 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::8fa:dc19:e4c0:4dfb]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::8fa:dc19:e4c0:4dfb%8]) with mapi id 15.20.1900.010; Wed, 15 May 2019
 15:07:44 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: [PATCH v2] net: phy: aquantia: readd XGMII support for AQR107
Thread-Topic: [PATCH v2] net: phy: aquantia: readd XGMII support for AQR107
Thread-Index: AdULL9hzIkv6Hx5KRamBgupmL9w78Q==
Date:   Wed, 15 May 2019 15:07:44 +0000
Message-ID: <VI1PR04MB556702627553CF4C8B65EE9FEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5c8e40c7-63f6-4d31-d9bb-08d6d94715b8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB5344;
x-ms-traffictypediagnostic: VI1PR04MB5344:
x-microsoft-antispam-prvs: <VI1PR04MB53444E5E1B1CB5863A258AE2EC090@VI1PR04MB5344.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(366004)(396003)(376002)(346002)(189003)(199004)(53936002)(6436002)(2906002)(73956011)(2501003)(54906003)(14454004)(316002)(5640700003)(99286004)(9686003)(74316002)(4744005)(478600001)(86362001)(33656002)(2351001)(55016002)(5660300002)(8936002)(305945005)(81156014)(8676002)(1730700003)(81166006)(66066001)(476003)(52536014)(66446008)(64756008)(66556008)(76116006)(7736002)(66476007)(68736007)(66946007)(486006)(6916009)(186003)(26005)(7696005)(71190400001)(71200400001)(6116002)(3846002)(102836004)(4326008)(256004)(6506007)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5344;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kmBLsnoO64+VpCxtHYfo/GTXihMGpOaCbkHo/KpXJRvYdkR1sqrRomxqysFAuHpVV19xX4X9/fGTc/MRcA0U3kCrT3vuXVJqnI0cpBxjfFsyCrf8HPUigVpXQNvmTEHdmckiNxI2bd8/xoX3nPDuqfjWSBw92Fo649yUXpcC7qlbsvjuqq2ao97GwNp0LDyY3r0wgT8hjLVWr4E5qcZ66Gj4lJBEf6jLI0r6ni5bBXihnMsffI5i16J7soMvBn0vDgSGePsElCP02B/YMbOJcKfCykNT2XFPvhs6Salp59iTt5vzMxD7JNl1748I+lRblGIt2JiyDW0T8pgyoDxxZER3tlLiHI/JgW6wU5FJZs2Hb1a7PO9+yoAqHrDIlz41lH+kYQOQ9ezioiKmDxjlNRTledJhziEcxDsCi0aKzwE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8e40c7-63f6-4d31-d9bb-08d6d94715b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 15:07:44.8624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5344
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XGMII interface mode no longer works on AQR107 after the recent changes,
adding back support.

Fixes: 570c8a7d5303 ("net: phy: aquantia: check for supported interface mod=
es in config_init")

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/phy/aquantia_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/aquantia_main.c b/drivers/net/phy/aquantia_mai=
n.c
index eed4fe3d871f..0fedd28fdb6e 100644
--- a/drivers/net/phy/aquantia_main.c
+++ b/drivers/net/phy/aquantia_main.c
@@ -487,6 +487,7 @@ static int aqr107_config_init(struct phy_device *phydev=
)
 	/* Check that the PHY interface type is compatible */
 	if (phydev->interface !=3D PHY_INTERFACE_MODE_SGMII &&
 	    phydev->interface !=3D PHY_INTERFACE_MODE_2500BASEX &&
+	    phydev->interface !=3D PHY_INTERFACE_MODE_XGMII &&
 	    phydev->interface !=3D PHY_INTERFACE_MODE_10GKR)
 		return -ENODEV;
=20
--=20
2.1.0
