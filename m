Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31FF71EA64
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 10:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbfEOIq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 04:46:29 -0400
Received: from mail-eopbgr40079.outbound.protection.outlook.com ([40.107.4.79]:47598
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725902AbfEOIq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 04:46:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SBOITs3j7df7hR+nAza6mGulYpuO55qq1vLHqetv37M=;
 b=EYZ+u0icf7AhEKfbBDSS6kx76VlIolQnGucmqW9MWs5FyRCI9AeyUhe8ye1gTYuE+4SpgJP92IYvjo/VX5jDw7E6Gxd99Tc7tGKz+3OEX1KbzP7nlO7JxceK5pPFioz8k5nUBkKxwvuiwavBeBytF/a46hhb6co34yO8qwjG8Fw=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB4848.eurprd04.prod.outlook.com (20.177.49.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Wed, 15 May 2019 08:46:26 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::8fa:dc19:e4c0:4dfb]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::8fa:dc19:e4c0:4dfb%8]) with mapi id 15.20.1900.010; Wed, 15 May 2019
 08:46:26 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: FW: [PATCH] net: phy: aquantia: readd XGMII support for AQR107
Thread-Topic: [PATCH] net: phy: aquantia: readd XGMII support for AQR107
Thread-Index: AdUK+h3EadEn3nk0T0a6gOF7a3LzWAAADfpg
Date:   Wed, 15 May 2019 08:46:26 +0000
Message-ID: <VI1PR04MB5567FAF88B84E9C77B93A40EEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <VI1PR04MB5567F06E7A9B5CC8B2E4854CEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR04MB5567F06E7A9B5CC8B2E4854CEC090@VI1PR04MB5567.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f416687e-342e-4f72-6a05-08d6d911d0f1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB4848;
x-ms-traffictypediagnostic: VI1PR04MB4848:
x-microsoft-antispam-prvs: <VI1PR04MB4848129384CF98997AE90FC7EC090@VI1PR04MB4848.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(366004)(346002)(376002)(199004)(189003)(26005)(33656002)(66476007)(66556008)(64756008)(305945005)(73956011)(486006)(66446008)(7736002)(74316002)(66946007)(76116006)(66066001)(102836004)(68736007)(4326008)(186003)(478600001)(316002)(229853002)(6436002)(53936002)(5640700003)(81156014)(81166006)(14454004)(1730700003)(8676002)(9686003)(2473003)(2906002)(25786009)(55016002)(5660300002)(446003)(76176011)(2351001)(4744005)(6116002)(3846002)(7696005)(476003)(11346002)(54906003)(2940100002)(99286004)(86362001)(256004)(71200400001)(71190400001)(6916009)(8936002)(52536014)(6506007)(2501003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4848;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UPN/5qGnVnDklErGZxp3JoB9kiMJR5fZlEyL5gRuPFK9ULRG4vsAK3Q8VgAXBlq14nakkd0OzEd0ZISez4qo9Ov73mkHTHuWDcy8z5/HIgq6uvC9FetmcE49/bIYXMcFonI3bbU6O6t3ZPwQl01AxqYJf9rlixQkY0JTc8vRIeR1+wzHww6iQNU+CcwvOz8muQ5Ic5wCh212mM5ZLdZz++S89INx81VUneJVObSehBTg3s8ZPW2N7eQz6z/U7+W6D/vFl3BVYEIpUpxNZkOHP8Q3Fd+Vuu4yOPiTBr3mX4P2GGWrOaR4TCr+EcO81nJICljqh1lzxvxQZ0IxkXnYNpuiC2vpqCBcTE2/KEX4uk7Vqr9Sr+5+ap+Y3ewBPfj/DUtVbvLLtO8LEDF1C9tDjuf1pp9oQ6ghHz/u+FK/+E8=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f416687e-342e-4f72-6a05-08d6d911d0f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 08:46:26.1997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4848
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XGMII interface mode no longer works on AQR107 after the recent changes,
adding back support.

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
