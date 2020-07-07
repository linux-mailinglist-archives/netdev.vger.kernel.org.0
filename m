Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEEC2167D2
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 09:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgGGHxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 03:53:49 -0400
Received: from mail-eopbgr60085.outbound.protection.outlook.com ([40.107.6.85]:23806
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725766AbgGGHxs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 03:53:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DprhM3IOz/fW7THiUKt9El6cXkHRA6Xz7N7C9UZjgBh6lP7MDYStIt30HVn5OJ07szgCfbCtSf5kErsLMNC5eO7vQwdhjKLVHkMnO7lK6TYm49p1MgamfmHEkRPUaOhrgjECQhenE9HoKL6ozf2HPBsiqfeDWzFoZw/hs9EGfzQ08YjjvnJo7ZO0S48D7IrowwnFcMvm5O4ExyNyWQF4fFl0D8/dpgKMtIpxL6lp7DJnKNPvYws5d7BL2q0ezlE9xiUmGVOV0z+xXa7j3Nj6Wk/60NIor0qNT22SfhaYboWl6WoP5PKfak14tpFPeLcO7UZx2G5zkX9ee05t3kMvgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4CadFWR5dj6yibSn4NikLwsO8Dlc6RgvqkG+usc67C8=;
 b=OsZyKojSrFAVhYS5mvdRICBHhZaJfsupZLSO1gwQ318mPl37dtVPYk6ItFdG+DLESd40noZ7EkiNVYG/yDld5IT6Nmv3Z05l99CKaIXb66SlMc81WKP6pXuljAejJM5ffBWQRqTixGGvAImvFSIJ84x/91OY/XjwFzfXEkgpT5/vlFQRr1dbJNML5v38gU6+P1Nfb+UeGDqV9iyE7DCKviReda7HsNrevNK87ov5HXazffxh1FQYh1gBioh1ldB6P951ZkNCChDcZBJvuOtVRf1xp+J1lQwx16CnpHBcjC/EyPqcQE+FMSQJWoaG6PUWPYp9Qvbx9MAn6GVE5zreUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4CadFWR5dj6yibSn4NikLwsO8Dlc6RgvqkG+usc67C8=;
 b=VtwHsJ7VnIl7mAgBk3eOtgBMqq/3nCQHstigs9OsXOg+qgRvbEy5i9HK3fivCOezQLY0YJ7ns3mC0b5RTj12FaOTovqklXSO6VTbsi2rjC80kLy68GOwgNmATwd2VNfePOOpsVzvuYNr6Qa/I9IxGX/+V5sbH25RIol+cmAy5zA=
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB6324.eurprd04.prod.outlook.com (2603:10a6:208:13f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Tue, 7 Jul
 2020 07:53:46 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::41d8:c1a9:7e34:9987]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::41d8:c1a9:7e34:9987%3]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 07:53:46 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Michael Walle <michael@walle.cc>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: RE: [PATCH net-next v4 1/3] net: dsa: felix: move USXGMII defines to
 common place
Thread-Topic: [PATCH net-next v4 1/3] net: dsa: felix: move USXGMII defines to
 common place
Thread-Index: AQHWU+E8m7d28/V01EedBiZGjqeZk6j7vk+A
Date:   Tue, 7 Jul 2020 07:53:45 +0000
Message-ID: <AM0PR04MB6754BD71B86911A613AB944596660@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <20200706220255.14738-1-michael@walle.cc>
 <20200706220255.14738-2-michael@walle.cc>
In-Reply-To: <20200706220255.14738-2-michael@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: walle.cc; dkim=none (message not signed)
 header.d=none;walle.cc; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.76.66.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a90054ee-08ef-4b86-6c4c-08d8224ae05f
x-ms-traffictypediagnostic: AM0PR04MB6324:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB6324085C990EAFAAB5D94BAF96660@AM0PR04MB6324.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Xu14ZkbeXeScVS03/eHZ48JMa0Yd3YfUGfrZDeaQ2znjXEFHGLAVXNJsShd/+gCCB7Ua4s0zRXhjuZcluvr6EqMqCF958j/o6LXC+yKpbLGeyYWu15BUGh1k0rCzVL4hksc6EXegPpsw07RZg2JmZ6sXtA3cccxqsYoLdoEr1kvnIQ5wWtbeYO9x13g9HrvhTeC5VJ3DtmQTkoyWESP6rwhSCCFPYBheF6BEg3UtL2GIJnY3IsjuQ+YgUI1miPENwad4pwNW7NV4k9jLs164Un90Vd3dPOwCok+zeoPBX7lvsRKHJRYR3Q32Ib7SRr6l
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(39860400002)(136003)(366004)(376002)(66446008)(64756008)(478600001)(26005)(6506007)(66946007)(66556008)(66476007)(4326008)(186003)(83380400001)(2906002)(110136005)(54906003)(9686003)(316002)(55016002)(76116006)(44832011)(4744005)(86362001)(5660300002)(8936002)(8676002)(52536014)(33656002)(71200400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vxjR04bhCNdvPOsvQ855xL9/jw9CwNQsMwg/5Rjv+q7pI/1IuFRnskIxsbIewNF2IBiKwVb9uErm38L7cgdDSw4gy7GYmTRN9oY1awMLexGzWrk52qY44zBfiOh2t76HLUASOFXo87a0az7wvpY0nNdpsK6WLPT7cCOOYtCSJGj6EwjHgmDqbZvMm8ltpqxlfscAYXLpzBxLPxOgM9FT99tKoIxtZBFgor4SC0luPSd5oVfs/qcA26rjo5Qe4WkVnwNsEWb9IAELFFJL7HLyZva4kz9LpX4iTdFffpOuIuOUsxrZaMQSWCpe4EGm+meKBXI6J3E3gLIjAvrfMwwrgQbITaeFkJlg/UjGWnqTa+ue4eZEN7AEz1sQaF9wFyD6yot6bTb7+EB5DBaGNA32bd3lWWvzQcItVTu2F4LlCwm8A89KOHZ4/5rEKj5zg1A3sj0LOQnQjuvUVe+X8W8baKuZ5UbrxXHbsduY4UUYtyc=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a90054ee-08ef-4b86-6c4c-08d8224ae05f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 07:53:45.9000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CutkTlCu88fNQTB1aM0BWDWoMXoKx0fj8AfIeyBHYungsmk4HQpF7x6BVBE/SyV7h1tw4BtezyjtXRadufV8pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6324
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Michael Walle <michael@walle.cc>
>Sent: Tuesday, July 7, 2020 1:03 AM
[...]
>Subject: [PATCH net-next v4 1/3] net: dsa: felix: move USXGMII defines to
>common place
>
>The ENETC has the same PCS PHY and thus needs the same definitions. Move
>them into the common enetc_mdio.h header which has already the macros
>for the SGMII PCS.
>
>Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
