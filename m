Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7ADF273E2
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 03:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbfEWBUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 21:20:50 -0400
Received: from mail-eopbgr140079.outbound.protection.outlook.com ([40.107.14.79]:16354
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729451AbfEWBUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 21:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E4SMmMLBda6rfk6x4+ck/5XTiTZGJvii0y1lKndeIj4=;
 b=B/JjzN+HAwiBe7IdiDQ4DCBSF4k29uKabvLlGfjC9FbsHTmpTfjpulXl/4VZaxe1rNUEwgs5MmsPD9rpg+ii9xUZ23XRK23gRDLpfr23D6ZeVaQBaLadBuUQ1obr7y4XlgDxBLCddqKlFbH5xmNw/J5FtzY0+WrBBo1x3doiNAY=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3677.eurprd04.prod.outlook.com (52.134.15.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Thu, 23 May 2019 01:20:39 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 01:20:39 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC PATCH net-next 3/9] net: phy: Add phy_standalone sysfs entry
Thread-Topic: [RFC PATCH net-next 3/9] net: phy: Add phy_standalone sysfs
 entry
Thread-Index: AQHVEQW7wDCFQR6sQUWynBU/WT9lsQ==
Date:   Thu, 23 May 2019 01:20:39 +0000
Message-ID: <20190523011958.14944-4-ioana.ciornei@nxp.com>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
In-Reply-To: <20190523011958.14944-1-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1P18901CA0009.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:801::19) To VI1PR0402MB2800.eurprd04.prod.outlook.com
 (2603:10a6:800:b8::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0
x-originating-ip: [5.12.225.227]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc7e1da0-b263-4fdc-2eae-08d6df1cdd77
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3677;
x-ms-traffictypediagnostic: VI1PR0402MB3677:
x-microsoft-antispam-prvs: <VI1PR0402MB3677B9B27373C1E8C17B2866E0010@VI1PR0402MB3677.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(25786009)(6512007)(316002)(2201001)(26005)(186003)(86362001)(2501003)(1076003)(36756003)(71200400001)(256004)(71190400001)(5660300002)(4326008)(66066001)(6486002)(5024004)(6436002)(3846002)(7736002)(305945005)(71446004)(99286004)(52116002)(50226002)(81156014)(8676002)(81166006)(8936002)(54906003)(110136005)(2906002)(6116002)(478600001)(68736007)(102836004)(76176011)(53936002)(486006)(2616005)(66446008)(6506007)(386003)(66946007)(73956011)(66556008)(44832011)(14454004)(476003)(11346002)(66476007)(64756008)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3677;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7lB4HZV4stnPEkom/G9P/PgHso//Ro3phxVzfGfaLxyWzU10WJttRM1JZl8di7nPif9gawWIoajXNpmbSleCEYbgPG/RT9iudaXhVp8GB9mWi9X4pfmc6QYmKM0vnuLdGdXgYPVao+IULYgF6IeTF56gn2nRB6P9lW3aY80SBThSc60o0HtpTkB0CHcLWTVNMwOowJBOpXQGIPrTTc7bJcflLTl+hlJ5awt+or3k6HufE+Wmuv+QVXT+SaI7i608uR5qms9rXaBPnk/yiSXEYTJ+8pDK/ne9IzLpjkGK786mMkpEkHyc0eNZ9asSRevale985t1HVvWLvrJegt1ZYsNrtNy4ObzxvQBXZVVhGdm+OqmQK3OSU9ZjOBXXPaxGjWPpwGjdSaj94IKjJwA2LJSwQ7o/3ei/JqoGtzi/KmU=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <33E3276CA698984A85EE38FC362475A8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc7e1da0-b263-4fdc-2eae-08d6df1cdd77
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 01:20:39.1651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export a phy_standalone device attribute that is meant to give the
indication that this PHY lacks an attached_dev and its corresponding
sysfs link.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/phy_device.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 25cc7c33f8dd..30e0e73d5f86 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -537,10 +537,22 @@ phy_has_fixups_show(struct device *dev, struct device=
_attribute *attr,
 }
 static DEVICE_ATTR_RO(phy_has_fixups);
=20
+static ssize_t phy_standalone_show(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	struct phy_device *phydev =3D to_phy_device(dev);
+
+	return sprintf(buf, "%d\n", !phydev->attached_dev);
+}
+
+static DEVICE_ATTR_RO(phy_standalone);
+
 static struct attribute *phy_dev_attrs[] =3D {
 	&dev_attr_phy_id.attr,
 	&dev_attr_phy_interface.attr,
 	&dev_attr_phy_has_fixups.attr,
+	&dev_attr_phy_standalone.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(phy_dev);
--=20
2.21.0

