Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC2472BC5
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 11:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfGXJxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 05:53:21 -0400
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:53314
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726667AbfGXJxT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 05:53:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9gkJ8Hcy+kbGvKAX2jzNKiEPqtyQaVYm/tBVEYDdpNi9FDjv83sKBntR6bkhma3U9vo0JY8S9JHa+eVYbqT2zXTuFxjztEt6iaeESOr5zwvcCEdrGJaQfNFDWeAKVnQV/hB5o8S4tF9jwXsXRlBgFlsgHSPDjXtfoFoPZ5nZu3+m820qh3121iwfamTNjgBMbKplVRtlowrpzcCjq9lH+tFb2YKbnOUD4QxxG6j5LBp7KYpheWZ66pfoH+ZBoLLVXQ91345Qhcb6BdFV8vr7UzwVIEqbPzNjuEN/qPSajdBHn+/8UA8M0cd5m7B4wWCdo+WDU9rc0EUzpLppSnX8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlJUGkDvj60iDKEM242eqpc4TePTT3N6hyEQgX3fxuU=;
 b=NeP+PiOzhhNRoDiRjeiD663gM2zdOIGqPQbtKptvCc+yGqWR/CZu8FjbN8tHQJdzpAxu8/HzMNWRiJ/3ZHdBEEEGRtgRDn5teeD9CoUO7PieEMst3yHAfgCK8xwMZqpU0jjDcXV87uF4nnC9YayCYDGmP52pCZxSO5z+hcj5PggGZ5BRQRwDQP358fooFWv1w0dB+Z+7g7ZbsBGe7cgeGeUfzo2GHcoCLO1CZgCzNey8VrB/xPC8R8/7w0ijBKaYikOLGu2msFKYvhZjbhNzXe9dXWWyIlk6zUFoOTadARxMA4HoT+MGCpRTAgVNMuOlIbAm3rslRN1T6HRg06+/Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jlJUGkDvj60iDKEM242eqpc4TePTT3N6hyEQgX3fxuU=;
 b=EaXRVWMiT5sXDPtu4cUDmLGeat+bjnM0Ml6BiMEm7nyGEeuC5tg0No4GWu0X1mjQdgphKdBf5JuF0lBJvpYWNlgv4XzBDfUw9wG45XErBbzGWc9VEhyVHD80oyHBulunrd1etnavusEhC07koYyjrwFiuf38v8CeshQ2bsQiTLU=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB6062.eurprd04.prod.outlook.com (20.179.25.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Wed, 24 Jul 2019 09:53:15 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::e401:6546:3729:47c0]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::e401:6546:3729:47c0%6]) with mapi id 15.20.2115.005; Wed, 24 Jul 2019
 09:53:15 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Leo Li <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH net-next 1/3] enetc: Add mdio bus driver for the PCIe MDIO
 endpoint
Thread-Topic: [PATCH net-next 1/3] enetc: Add mdio bus driver for the PCIe
 MDIO endpoint
Thread-Index: AQHVQWmTb9jG7sYluUe4Xi/RkNWlU6bYyBMAgAC+B+A=
Date:   Wed, 24 Jul 2019 09:53:15 +0000
Message-ID: <VI1PR04MB4880DAE881769F6DC845CEEF96C60@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <1563894955-545-1-git-send-email-claudiu.manoil@nxp.com>
 <1563894955-545-2-git-send-email-claudiu.manoil@nxp.com>
 <20190723222454.GE13517@lunn.ch>
In-Reply-To: <20190723222454.GE13517@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eca3931c-ae45-48e7-503e-08d7101cbfa3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB6062;
x-ms-traffictypediagnostic: VI1PR04MB6062:
x-microsoft-antispam-prvs: <VI1PR04MB6062FCBD292BFB79713F253996C60@VI1PR04MB6062.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(396003)(366004)(13464003)(189003)(199004)(33656002)(55016002)(44832011)(2906002)(6436002)(486006)(66066001)(9686003)(25786009)(6116002)(8936002)(68736007)(7696005)(6506007)(478600001)(102836004)(76176011)(53936002)(52536014)(81166006)(64756008)(446003)(66476007)(74316002)(186003)(3846002)(99286004)(316002)(8676002)(14454004)(81156014)(305945005)(26005)(4326008)(7736002)(256004)(6246003)(76116006)(5660300002)(54906003)(11346002)(66946007)(66556008)(86362001)(476003)(71200400001)(66446008)(71190400001)(6916009)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6062;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lkkyZvLWoNRRW0JSgafroJReIhbberx9NGIvVWAB2env4u9RNks3yj4gys0OMSnDn/ssNScCtQGNA6BsR8kRCUoYF3xk4n4rbrMeVAxA1bMDq6t78zyVtNe7cYOm9hny8qeNogH9HSMI4lXX/gYnAi87QoRIo/U3i076efcuCcU9j46cgikml2hOV75maHwaTTTQrsKXvrgERujJ+5z+RKcJdZLm0eHGZpQUUQPfsW7Ou5ICJ6Ds1pVAEGsdX1l/bA+L53DS4uktbBDjBoJtTWKVdMVAIR5fu5A51DdizlMbrLtXz20EX37dtTPgVsxM6ENaRW5bSIhrOnOGwUkT/MloCFzWRV+TV7QOaLVOYZchL6eK79cZiHUia9MqWGZn5LfexOplOriAXJojk2qJ/808ftQy94kCAZGfT9Bv+Ns=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eca3931c-ae45-48e7-503e-08d7101cbfa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 09:53:15.4665
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: claudiu.manoil@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6062
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Wednesday, July 24, 2019 1:25 AM
>To: Claudiu Manoil <claudiu.manoil@nxp.com>
>Cc: David S . Miller <davem@davemloft.net>; devicetree@vger.kernel.org;
>netdev@vger.kernel.org; Alexandru Marginean
><alexandru.marginean@nxp.com>; linux-kernel@vger.kernel.org; Leo Li
><leoyang.li@nxp.com>; Rob Herring <robh+dt@kernel.org>; linux-arm-
>kernel@lists.infradead.org
>Subject: Re: [PATCH net-next 1/3] enetc: Add mdio bus driver for the PCIe =
MDIO
>endpoint
>
>> +	bus =3D mdiobus_alloc_size(sizeof(u32 *));
>> +	if (!bus)
>> +		return -ENOMEM;
>> +
>
>> +	bus->priv =3D pci_iomap_range(pdev, 0, ENETC_MDIO_REG_OFFSET, 0);
>
>This got me confused for a while. You allocate space for a u32
>pointer. bus->priv will point to this space. However, you are not
>using this space, you {ab}use the pointer to directly hold the return
>from pci_iomap_range(). This works, but sparse is probably unhappy,
>and you are wasting the space the u32 pointer takes.
>

Thanks Andrew,
This is not what I wanted to do, don't ask me how I got to this, it's
confusing indeed.
What's needed here is mdiobus_alloc() or better, devm_mdiobus_alloc().
I've got to do some cleanup in the local mdio bus probing too.
Will send v2.

Thanks,
Claudiu

