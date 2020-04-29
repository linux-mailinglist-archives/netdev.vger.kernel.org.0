Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5ADB1BD30A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 05:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgD2DnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 23:43:20 -0400
Received: from mail-eopbgr00070.outbound.protection.outlook.com ([40.107.0.70]:1826
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726530AbgD2DnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 23:43:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8QZ2ofXBsXUGoXOtL0pFbBGIlOFYrrDlmZ1hhpTrf4JSGf8yXDDHTV00uhreXS9r25qHLSj0/Rwrg0FdZ80HD+2szrhqLk5OdAzv9bGq/4MQADQJc7QvxbhH9uWkFRsbSjyBKJByLnVL5jfPNitXsqeOvMbBj9hY640WGqvFu8Y8rNWHUke0YFyEvDudoC1MvW6IuZUqgg/JOWLaBxRbPSH4a3BCDXHvLmNO2GoXPfDlAj9qXRMk8X6T1UhJA6N6pp6pWC0tFoENMgiVxfbPDDA1BQ2GJnmgJOhhPiIJfY0A/MDSYktcA0RQF9koJSsjYEcOo34pIBVo4/sOahKww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oD+PyB4u+ICAsF9ZnRCQBDp1VGJOLtrhJ2oAmqSweo=;
 b=e3sNCHjuNbXDp86IF8pWtPFE/2dDOBIBFLAd1AISyL821ZMAnwiQmi6O/O3iO6iY0tU5qN+3zzrbm3CNMucRrYqQfNzMAoTxBaFBtyqXyy3+5WD5WfMoj0fHck55qTuoCDffAATaiH/N0i8mIcrbcN5ZDb1lTQtSOnonAQlVaN3QZVzPo9/KQFmOR9AB980W0kr0BvhsFenOIaeQAnItXyzxDWS4lbXD9Trzzb67b9W8CGGvBM5qleK22pg4u7PvM2/5NAA51ACljlw/ruOQ3oDmpSyC9MxDaRgeUZHGlbifUkyE/+BQevFkSS4qC/5ZGc1M9KY3CfdjG1OJfNW2Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/oD+PyB4u+ICAsF9ZnRCQBDp1VGJOLtrhJ2oAmqSweo=;
 b=jmW/bVcfKfKRTwAsHMf/PU/Hi5JvkfOH/0TmZrhw9J8RwvEh8CElbrPDYrQDPCKo0bnJAva6oxAYzYPnO9V2Wm5HkCcG8Vw0345grBivOQJn4J2Id/F0R4OsHl2mAJs5g525gKjJ9UONymBM4vJdoB0HEhdgk4iCwQK4MR9vMDQ=
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com (2603:10a6:3:d7::12)
 by HE1PR0402MB3578.eurprd04.prod.outlook.com (2603:10a6:7:84::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Wed, 29 Apr
 2020 03:43:16 +0000
Received: from HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d]) by HE1PR0402MB2745.eurprd04.prod.outlook.com
 ([fe80::e802:dffa:63bb:2e3d%10]) with mapi id 15.20.2937.023; Wed, 29 Apr
 2020 03:43:15 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     David Miller <davem@davemloft.net>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "cphealy@gmail.com" <cphealy@gmail.com>,
        Leonard Crestez <leonard.crestez@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next] net: ethernet: fec: Prevent MII event
 after MII_SPEED write
Thread-Topic: [EXT] Re: [PATCH net-next] net: ethernet: fec: Prevent MII event
 after MII_SPEED write
Thread-Index: AQHWHaSxKxjYdl/WNkuZX+80YiGqOKiPVsMggAAcLICAAAI1EA==
Date:   Wed, 29 Apr 2020 03:43:15 +0000
Message-ID: <HE1PR0402MB2745963E2B675BAC95A61E55FFAD0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
References: <20200428175833.30517-1-andrew@lunn.ch>
        <20200428.143339.1189475969435668035.davem@davemloft.net>
        <HE1PR0402MB2745408F4000C8B2C119B9EDFFAD0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
 <20200428.203439.49635882087657701.davem@davemloft.net>
In-Reply-To: <20200428.203439.49635882087657701.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [101.86.0.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3df98783-620c-4f58-5d4a-08d7ebef7345
x-ms-traffictypediagnostic: HE1PR0402MB3578:|HE1PR0402MB3578:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <HE1PR0402MB35787217EFAFFD7A36C3483CFFAD0@HE1PR0402MB3578.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 03883BD916
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ypZFUxGP2QEFrXNbFH50++7VGNOpiab62IVadVDsU5YKEUokHRtm96lix7o0KFQx9fJPoG64ZjBZXnlFWM46tGbh9X0WAnV4DivzVfnlhfiJ/Rk2S1BkhjVtAKoQtclYeRwjJ25NdRyoOyQGCEYCCl49hyGgNf38S/C7IIQ6dRn0VMs9Pjc1cqmZTZULxBpqJiniNIje/idJNimzfjxFA8zg8eaeV1u4AWqqkhpAvOIeBD3wQ7ORMCSjYSuaXhctT9Z402z25QqqAYBsm7Hy2PY/p+7U8Vq5pK2v83pSYGxbHfVOXla/g+hcPjIpB2EbYOhaQ3ONKZ1oZvgM1D6cMuc1JBdkEm/RpsJ55HaC4RV8UxRYGZSin+nCYRDiV4axHwRJJu1PE48w1ZKLIa210639JcZVfCP8emtvbMF9heULGALNKEFuhvrlfu8kcXx8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2745.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(86362001)(6916009)(478600001)(7696005)(66476007)(66446008)(64756008)(52536014)(66556008)(76116006)(6506007)(26005)(8936002)(66946007)(186003)(316002)(8676002)(54906003)(33656002)(4326008)(2906002)(9686003)(55016002)(5660300002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: PMtwRTFWy4AAvI3LFS6J/2jcjuHaFPjXD6lx9s/IVP7zmTus3VfTn7kXBjbZnRqm6IKaPesB9vDPKP9BwndOdquxwm69PZyit+0yZCConsE4PbBabijoBrK/V/l/ChsJmLH/AuLsjqme63lbLv9ozBg6sbsS4J8WsfgGT4XiC2x7A4N/AKpX5RMmUXZ2blyeMp3EQRT3PbkAC6WsTk8qCRk263vRMZV+AYANvZCmIFDfImmE3RRi24KXcsvIKcvnEPstVZqRCq3zfHp3iFKRiNOz54TtxtREcDiOtckqdLMRt2anwLQCWFZO4lIO7zL2HoYuNG+eHuPnk++druBuAG7dt7g44Zix5dOiO7ohifkgP6KijiPTcJ2LJ4HT2CQJs1CV6I1FBTIc5fRNctmjzrClISLFWZ5pvQhugF7R/lASFwHvWyoC7zinWDLH4V/uqO/gd/EmFJmJMf4LrgGP7OZAZ/q7IAN4fEzTT3ykqfVVrpKAzlcE+SKjl7I9a3/5cr8ubQIS0zzVoiriYjZMd3pvPbWhhMO4UoFRL41uZEOZQcGTUvBFnrZ9JkKXsX1h2kTDcJAbzKaxs6Switscn8s9TkcNlzfvot4QXMO6q4DiezLdCs0wHHqNCVx34F0tPl55YGIL9sMHyYn5UWjQhzeBix+9NIRLD8DL86NMu/cxhnD+G10NV0OOipDOTWMOzP4oRIuHCKrUsOjEb98m4LYswMFXTz5wHvdaU72D7scMy0t0VRP5ZTos+aH1BhSgcu/vVrV3qls3yuvs03NASODaCQ0vuEJzaC0Jat6UJII=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df98783-620c-4f58-5d4a-08d7ebef7345
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 03:43:15.8491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3gg72n+bV4ULaglnxVDAq0OR1mhLQJFKUbRZ+GHVXF+tft7Sp9Vl8TCpMm6eO+/HcEq77lP3/wWoUVWrSFVk4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3578
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net> Sent: Wednesday, April 29, 2020 11=
:35 AM
> From: Andy Duan <fugang.duan@nxp.com>
> Date: Wed, 29 Apr 2020 01:55:35 +0000
>=20
> > From: David Miller <davem@davemloft.net> Sent: Wednesday, April 29,
> > 2020 5:34 AM
> >> From: Andrew Lunn <andrew@lunn.ch>
> >> Date: Tue, 28 Apr 2020 19:58:33 +0200
> >>
> >> > The change to polled IO for MDIO completion assumes that MII events
> >> > are only generated for MDIO transactions. However on some SoCs
> >> > writing to the MII_SPEED register can also trigger an MII event. As
> >> > a result, the next MDIO read has a pending MII event, and
> >> > immediately reads the data registers before it contains useful
> >> > data. When the read does complete, another MII event is posted,
> >> > which results in the next read also going wrong, and the cycle conti=
nues.
> >> >
> >> > By writing 0 to the MII_DATA register before writing to the speed
> >> > register, this MII event for the MII_SPEED is suppressed, and
> >> > polled IO works as expected.
> >> >
> >> > Fixes: 29ae6bd1b0d8 ("net: ethernet: fec: Replace interrupt driven
> >> > MDIO with polled IO")
> >> > Reported-by: Andy Duan <fugang.duan@nxp.com>
> >> > Suggested-by: Andy Duan <fugang.duan@nxp.com>
> >> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> >>
> >> Applied to net-next, thanks.
> >
> > David, it is too early to apply the patch, it will introduce another
> > break issue as I explain in previous mail for the patch.
>=20
> So what should I do, revert?

If you can revert the patch, please do it.=20
Thanks, David.
