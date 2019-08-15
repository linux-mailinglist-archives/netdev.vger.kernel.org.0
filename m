Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E11298EF5B
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbfHOPcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:32:31 -0400
Received: from mail-eopbgr20044.outbound.protection.outlook.com ([40.107.2.44]:11366
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729736AbfHOPca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 11:32:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUUgdS8FlX/B/Pup/rvqxvLlMBI2TeI5jHTszpp+uDB6G5RNTyq21kSGVb57w0lWr1G/ly7A8NQn3G9NuVd9eyj0PPW91/dJidube+/WlhQKn4ftStVYEsi86zjjD6OWhUD7cU3SBmVCmEDHsUz4YkCu1P4nY6R19LRdRewkCqkPOlrXeseE45/Er+a4FJUmDZPTQpP3oo5JknCEfRlkb8ag4rlIHTALdIR1R+lE79SPraq0gqyziXZXXuYcQkgBiBG6NB1JmVeedYFw1zUMMfNHFt3qO/86JjrzG0PwJIjgLGSonoWfDm4RdnO8BjXcU5iLPNFR8PDeXlULHLduHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDuuMbftz1X1zRQHW8/QaEwdrBAGYrjg+GUTaek3Pgw=;
 b=XL8X+aZ0ZSdIdxLfbY/VWzOdNaOrmB5QmLcHa7dq0wUV56EcvgXHY4YtqkLpSt5JiFALJe6h+mKR7j3dEMfBpfSknF7KqB0PL+1MnRzu5xJe6FtA0DUCVdAGFdLcuNRpZzukIqNZVp/JGzKCxDK+geOmJC74oJGI0bCUXt3QXXYYLIz6kmHbaWftYIVgmunjvIh75NWUVjh7m7iEuLbHYSL/m0pNIOU2+M2G/afqYPzdERXb8Tu3uBIglqZQ2cHrvW8lfMroMHVttNIuWplygsEKKEHToTtwAjtNeH0TUBD3exXzeABQSLk2x5la54b3E+5mAmMdhU+5DUg9Otq7Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDuuMbftz1X1zRQHW8/QaEwdrBAGYrjg+GUTaek3Pgw=;
 b=a+0Mzgg6nD2LaV8Lbem0K0Q6Bq/E2VsvbcdOTpBk3s7TgadxZPkXFGTaVLVCArgc/6g+vXZrnGBfQt9054Zu/2QTcWjkLwNaICtwe0cp/iPnACkQ1/vwKNnKey74UyeoxNkctFmb6c62kWVtZ2K3vlZGA0cbQbZWF3Flq5PhemU=
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com (52.133.29.29) by
 AM6PR0402MB3624.eurprd04.prod.outlook.com (52.133.18.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 15:32:27 +0000
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc]) by AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc%5]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 15:32:27 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>
Subject: [PATCH net-next 0/1] Add BASE-T1 PHY support
Thread-Topic: [PATCH net-next 0/1] Add BASE-T1 PHY support
Thread-Index: AQHVU36kB16+P8dNcke+XhJhYYGD7g==
Date:   Thu, 15 Aug 2019 15:32:27 +0000
Message-ID: <20190815153209.21529-1-christian.herber@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: AM0PR0102CA0030.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:14::43) To AM6PR0402MB3798.eurprd04.prod.outlook.com
 (2603:10a6:209:1a::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 116d2be0-c80e-4615-111a-08d72195c745
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0402MB3624;
x-ms-traffictypediagnostic: AM6PR0402MB3624:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR0402MB3624267286879D07E247938986AC0@AM6PR0402MB3624.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(136003)(39860400002)(376002)(199004)(189003)(8676002)(5640700003)(36756003)(2616005)(476003)(8936002)(50226002)(14454004)(54906003)(316002)(7736002)(5660300002)(2351001)(66066001)(478600001)(3846002)(6116002)(2906002)(81166006)(81156014)(71190400001)(71200400001)(1730700003)(2501003)(6512007)(1076003)(6486002)(44832011)(66556008)(64756008)(66446008)(66476007)(66946007)(53936002)(256004)(486006)(305945005)(6916009)(52116002)(6436002)(86362001)(55236004)(25786009)(6506007)(386003)(26005)(102836004)(99286004)(186003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3624;H:AM6PR0402MB3798.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nBnNlVu6frfDOC5MnziWX7f7MmXAI0n5Nrp6pX2gxSkxKxvndW46pDc3fcE0N45FXrXn3gcPE4NtXPp1jyn1QlvW7oMyFp2cD94gqWFPN1zbkaNJLVVU+qHIuoLcQNta0Nv/DSfcAWSJt6w61XTVG/lFF9NCiHPbR9yUxagNGfkKo0Jv81Dl6mWYsNRn1VjqVAtQY6WADoo/yQT8j1Am7xf15aNbGMNh1grbxye2s3uNwYvsIiq+c+Jn8aDn3/nU+phL0x0BVxHqXCxvUBMqkeoei+txvdr8YdmWczr4/7BqATQN2gSZL8re1sK38/lDGxqIFtt2t4UsqezTRniUpvWKFPiIgHV0tCzWhqHHG/nNyuw120X/TydZ+wPjI1Dlefs+0620NtIV8xmsLklCQgJuvehFkFcnl5cyBpXP9qA=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <49EE277D8854E045988BD790B4FD4B3C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 116d2be0-c80e-4615-111a-08d72195c745
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 15:32:27.4160
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E+IUpS+rNMizkWdLz4fJn/LsIUsyZIwgHIbFNwYYxe9ZGKwcSpRFUDuzhHpiKN2/OJLCE85OmGFD1CL90w0+Zx083xcTdl5wjpmOvzuGxXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3624
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds basic support for BASE-T1 PHYs in the framework.
BASE-T1 PHYs main area of application are automotive and industrial.
BASE-T1 is standardized in IEEE 802.3, namely
- IEEE 802.3bw: 100BASE-T1
- IEEE 802.3bp 1000BASE-T1
- IEEE 802.3cg: 10BASE-T1L and 10BASE-T1S

There are no products which contain BASE-T1 and consumer type PHYs like
1000BASE-T. However, devices exist which combine 100BASE-T1 and 1000BASE-T1
PHYs with auto-negotiation.

The intention of this patch is to make use of the existing Clause 45 functi=
ons.
BASE-T1 adds some additional registers e.g. for aneg control, which follow =
a
similiar register layout as the existing devices. The bits which are used i=
n
BASE-T1 specific registers are the same as in basic registers, thus the
existing functions can be resued, with get_aneg_ctrl() selecting the correc=
t
register address.

The current version of ethtool has been prepared for 100/1000BASE-T1 and wo=
rks
with this patch. 10BASE-T1 needs to be added to ethtool.

Christian Herber (1):
  Added BASE-T1 PHY support to PHY Subsystem

 drivers/net/phy/phy-c45.c    | 113 +++++++++++++++++++++++++++++++----
 drivers/net/phy/phy-core.c   |   4 +-
 include/uapi/linux/ethtool.h |   2 +
 include/uapi/linux/mdio.h    |  21 +++++++
 4 files changed, 129 insertions(+), 11 deletions(-)

--=20
2.17.1

