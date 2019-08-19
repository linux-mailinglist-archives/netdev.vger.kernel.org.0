Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35AD29283A
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 17:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfHSPT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 11:19:56 -0400
Received: from mail-eopbgr60046.outbound.protection.outlook.com ([40.107.6.46]:14616
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726784AbfHSPT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 11:19:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eaBXYgTX6gns752ZMRes+JP7NvisJah7SyDgsRgP8aqG3jgMw28Obn6lW0IPr/utIopyUenchXQBG1K+85jrWosXJpqJELHncYmanFI6jhwWLnz8bygQSwsMPX1rm5qS3cEiu4JcCGhMh4leQ8v73me/SiMlMxsAHZMynVC8HnQkUDymAhS5MH4Afl4fqr/T2re8JBhit91c/KwXc86LJCsEyL7BuwuCHzxVvlJ43Y2JQ6qQ+lw80qEllhUyZMzKWGSVbU2hOhT3A1dKBHoH96QELOe5JkjpNryBhyG7wqfazbe717RUSdbbxBn/w9GyNE+s/WKUS/vFFqal6EgAOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJr+9r6PAI0OPouOaQuOCrlC9PyNqXyWm3DieCpVw/I=;
 b=SDpS7WkVFRsNAmXDP8McDC8Ff5+CI+80S1hC1sg+SSVzdUW8IY124cx+ft0+fC5H6nmPRHCRma9m8+870420mIe5VYo8V5byxyOzrZyH9OiZGozjnYPEjrtdQCSvbNtoHHnf8cITrd3JCTr2Tjc1zDJeRkQ4kk2r6rckJS3nHVNKDCYMsyrCqptmtilHxWUOi4erlqPofNwWB/lXI9GJBXcihG7pKpwgP3pxMPisDZ3VLmGHywDOyFBTN73lWWRYPForQ65FF6qQWtFEfR8MEQ75RUNFJk5DJTU+oTjKGid8SwaU9G4h5T9MmF4llWlz7ll3pGmu6ofHbrHK4TSI+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gJr+9r6PAI0OPouOaQuOCrlC9PyNqXyWm3DieCpVw/I=;
 b=XDr7kr62dgqkpB1o2XVSHd2st/3mIrtA1r5N7ixbKWsZDJOkl5UxsTb3M69veNv8UFCSrcxu3GEwJZYPTcYLLcsHPS7537ga2Z9GY2q68J/2uOlFuRX+n6fyW9BAlXl9dsjGCS5TPzuXsZk6M6R0udYFXQnLj4IvLgPMdbx0fIg=
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com (52.133.29.29) by
 AM6PR0402MB3896.eurprd04.prod.outlook.com (52.133.29.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 19 Aug 2019 15:19:52 +0000
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc]) by AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc%5]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 15:19:52 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>
Subject: [PATCH v2 net-next 0/1] Add BASE-T1 PHY support
Thread-Topic: [PATCH v2 net-next 0/1] Add BASE-T1 PHY support
Thread-Index: AQHVVqGMjvL6toQm9kOREoLwavWcNQ==
Date:   Mon, 19 Aug 2019 15:19:52 +0000
Message-ID: <20190819151940.27756-1-christian.herber@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: AM3PR07CA0103.eurprd07.prod.outlook.com
 (2603:10a6:207:7::13) To AM6PR0402MB3798.eurprd04.prod.outlook.com
 (2603:10a6:209:1a::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 37bbad65-c160-4355-8e17-08d724b8af08
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0402MB3896;
x-ms-traffictypediagnostic: AM6PR0402MB3896:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0402MB389670CDC60F3411DB158C4B86A80@AM6PR0402MB3896.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(189003)(199004)(478600001)(305945005)(4326008)(52116002)(26005)(486006)(99286004)(71200400001)(6506007)(966005)(256004)(6512007)(6306002)(36756003)(186003)(53936002)(55236004)(6486002)(386003)(7736002)(44832011)(14454004)(25786009)(71190400001)(2501003)(102836004)(81166006)(81156014)(1076003)(6436002)(5660300002)(8936002)(64756008)(8676002)(54906003)(110136005)(316002)(66946007)(6116002)(3846002)(66446008)(66556008)(66476007)(2201001)(66066001)(2616005)(476003)(2906002)(86362001)(50226002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3896;H:AM6PR0402MB3798.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Kc5HrOze7+QqnNJCA4IVHt+mVaZx0rlKUrhsgf6yf+Xf/nPQY6geqc323C+YoJRBYktoyST7c3kLgiaMB2Wkdkl4t7Ux8U171eUKNMcTewVwR4h4SOHsCeX7CMDvb+JqsuB1QD8vJWlQ3XpTpo6fuvxBbyd1tnZ9Q/ODsk9ECwaRqzAzBQXZHEu2NI2nZHhHpX+cAW7ucnNZEgKounDAlOD2y+EXcnON61x6swGok05sQORUjZTHJJ3tKo1QlmZ7eWjvV6OZ9q2qo/OjjbxiBTn0kUWBKLOp8zmJ7mypVkzGNEsfz9PWSxI+2SygP6Y7bxhvTuVNHXSg8OvdCieviHczbhy+yiAhPRLKHus1l5JycaH4+HcgsLh9efCFBasZ96Um8ddy9B3ioAhuCQFa8qBtLpzbOA3xsQ3reJo69g4=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <7DDAD439220CE449BC9C57440A82D065@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bbad65-c160-4355-8e17-08d724b8af08
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 15:19:52.7449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kj+whpJJqyYbXv68UVfSAUYXTzUSyt0ra3JWcH29y0KrNmB6s48mqXiyG+09LvSBWFoM/2e1gkaH7s2IXJX7qn68z82bFqzZISJOrXFoGyg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3896
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1 patchset can be found here: https://lkml.org/lkml/2019/8/15/626

This patch adds basic support for BASE-T1 PHYs in the framework.
BASE-T1 PHYs main area of application are automotive and industrial.
BASE-T1 is standardized in IEEE 802.3, namely
- IEEE 802.3bw: 100BASE-T1
- IEEE 802.3bp 1000BASE-T1
- IEEE 802.3cg: 10BASE-T1L and 10BASE-T1S

There are no products which contain BASE-T1 and consumer type PHYs like
1000BASE-T. However, devices exist which combine 100BASE-T1 and
1000BASE-T1 PHYs with auto-negotiation.

The intention of this patch is to make use of the existing Clause 45
functions. BASE-T1 adds some additional registers e.g. for aneg control,
which follow a similar register layout as the existing devices. The
bits which are used in BASE-T1 specific registers are the same as in basic
registers, thus the existing functions can be resued, with get_aneg_ctrl()
selecting the correct register address.

The current version of ethtool has been prepared for 100/1000BASE-T1 and
works with this patch. 10BASE-T1 needs to be added to ethtool. The fixed-
speed and auto-negotiation functions are extended for 100/1000BASE-T1.
For 10BASE-T1S/L, only discovery of ability is added with this patchset.

Christian Herber (1):
  net: phy: Added BASE-T1 PHY support to PHY Subsystem

 drivers/net/phy/phy-c45.c    | 106 +++++++++++++++++++++++++++++++----
 drivers/net/phy/phy-core.c   |   4 +-
 drivers/net/phy/phy_device.c |  12 ++++
 include/linux/phy.h          |   1 +
 include/uapi/linux/ethtool.h |   2 +
 include/uapi/linux/mdio.h    |  21 +++++++
 6 files changed, 135 insertions(+), 11 deletions(-)

--=20
2.17.1

