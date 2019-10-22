Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B871E0256
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 12:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbfJVKxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 06:53:03 -0400
Received: from mail-eopbgr140082.outbound.protection.outlook.com ([40.107.14.82]:12158
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730166AbfJVKxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 06:53:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYfiqJvTDtByMVqstcksrYkNlCD1bHre0II6Q/oJlsfagwjWhTl8rATHO2lKGGxKsOG1pAOINVFRCdckkL2J+OgkSBOioyNfjZQraQ/PXFzfapjpFMLKxY6xlyRQcIB4Sf71zbH6r2NiKa4DxUW45xAqLhiHQY6lEkK/sxDdGWT+A1YPny5lNeCNjkvBy14emiMed58gECmHgO+gZll+ZEcTEjY/OWTEWiQeE8Lajl8WXXzAbbUy9TVmgINTrbNms8sgxcS6FdMzj7Ma53B2B6zqJQWS5Dfq8WUSadTU9rXaAO/4Dephu7LW2y0sICfrpboHI0KDfR91kkcpsA8Y6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8DD8pKo+qespu+laRDwp6oByR80DBP+fzs+6fNj9uw=;
 b=O0q4jhIOq0F9/zWw2rMYBrfPc4Vqvl/AjD6YQhzpWXFl+4awLd8dEzSUK64fLqyzzutXOnxvThc/F4UKO4lV1Z9oEQFgk4vKKxce1z+/Sor8FL4cMlnbnwq2gaVZ+dE4rNyx1A4YLrs/ySKPjT1wMBPg8jQieUNa4ZWixQkGijg0bAVPr2O4HS5spCeR/8xKrlRUHSTgWqYF4SQWfS0txs569jZbQeVL/pZ304HTd9viR28/R8B7Q/xB/Zpt0gAQ33n2iFdA+MumU/TRMu06AT+57k8qPk+0CbVY0xzqOAzizv9IVmY66j/RtRjZchZb/V1AILn3e2qPz//fzBTdvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8DD8pKo+qespu+laRDwp6oByR80DBP+fzs+6fNj9uw=;
 b=jBD7VH1YJlwLIOa9+St4UDkQvah4L1clPPIffwR/u2Rw3lnTXUcCjzyx+GQWpCAvYG03o6Ie7czyeC9voXoxKzKEZpORYpiai+DvsIhYL1LocYbZyk3AiivOWzftSkTmvxUZRw/tmEHIOS63/SX7pG3dj9M3VD1GZkry2NF5nbc=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB2848.eurprd04.prod.outlook.com (10.175.23.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Tue, 22 Oct 2019 10:53:00 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2367.022; Tue, 22 Oct
 2019 10:53:00 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: RE: [PATCH net-next 3/4] dpaa2-eth: add MAC/PHY support through
 phylink
Thread-Topic: [PATCH net-next 3/4] dpaa2-eth: add MAC/PHY support through
 phylink
Thread-Index: AQHViGH4/x1MeFbNhEKBEYDO4/J2jadmeTYAgAACE2A=
Date:   Tue, 22 Oct 2019 10:52:59 +0000
Message-ID: <VI1PR0402MB2800C58886EC9AF01853EA00E0680@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1571698228-30985-1-git-send-email-ioana.ciornei@nxp.com>
 <1571698228-30985-4-git-send-email-ioana.ciornei@nxp.com>
 <20191022103932.GS25745@shell.armlinux.org.uk>
In-Reply-To: <20191022103932.GS25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 791d7e38-682a-4f4e-3082-08d756de014b
x-ms-traffictypediagnostic: VI1PR0402MB2848:|VI1PR0402MB2848:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB28482D9C50830E0D01EBFE05E0680@VI1PR0402MB2848.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(136003)(376002)(39860400002)(366004)(199004)(189003)(81156014)(3846002)(71190400001)(81166006)(74316002)(316002)(8676002)(54906003)(14454004)(71200400001)(8936002)(66556008)(7736002)(64756008)(66446008)(66946007)(66476007)(305945005)(2906002)(966005)(86362001)(33656002)(6116002)(5660300002)(52536014)(7696005)(229853002)(99286004)(186003)(256004)(6246003)(11346002)(26005)(6506007)(4326008)(66066001)(476003)(44832011)(6306002)(4744005)(55016002)(76116006)(76176011)(6916009)(6436002)(486006)(25786009)(478600001)(9686003)(102836004)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2848;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F1B6S85T7MzF/MuBRRLby4L8e1MMp1Q/Q7+VYu7ysuzhqihdGw6zt8ZXqeDEl6G+vR9u7sXFYAQpJjn+GpkmG98Ad1U0gE0CKvb0ASd8+9Pe3g3LiUzld2EvR3R3J8AJxMahlkYMj0AfzFITAIeIjw0bCG0zuVZO/mqDdEPCEmiWkYvov9dbaz8jk29wjwv8mItVOks06Ei9UOxx0nsoxgPkwC5cwmv7WOLm8hxqhR4Q34acWT0uh6P8wghAaPWPrxJZmBHV/b5U5bXruIYKffRpqw3k0zg5Um6yV7vx7luGvY2LVxUD6htbjG1crlr8x1d5v9YplSxEgvXc1EXh3V1ZjPRUEQ2lpL+/lSBVbTs6asSoTSpT6UAeYmffq92xOCW5OOY95eO80LTr6WoZpKfSScgeCSaK4mvYp7Y9dOcq6IGq/hby6YcPLo9PC4F2UukmppR3szAW2mHQtSeRPhfTYAregp77NtEqpwWptRk=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 791d7e38-682a-4f4e-3082-08d756de014b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 10:52:59.8838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ulQ1cQNsm6+Ia4OUH2AFLPFUX0ipUPoi+wXc+hE2w95nc9G55uuGwL4G+Icwkr2sR13KkKQRlgYM7V/sPbJ5Gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2848
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next 3/4] dpaa2-eth: add MAC/PHY support through
> phylink
>=20
> On Tue, Oct 22, 2019 at 01:50:27AM +0300, Ioana Ciornei wrote:
> > +	mac->phylink_config.dev =3D &net_dev->dev;
> > +	mac->phylink_config.type =3D PHYLINK_NETDEV;
> > +
> > +	phylink =3D phylink_create(&mac->phylink_config,
> > +				 of_fwnode_handle(dpmac_node), mac-
> >if_mode,
> > +				 &dpaa2_mac_phylink_ops);
>=20
> Does this mean we didn't need to go through the removal of netdev from
> phylink after all?
>=20

No, it doesn't mean that.

The change was accepted because it added support for multi-gbps speeds on
DSA CPU ports by using a phylink instance based on the dsa_switch device.
Maxime's initial mail is here - https://www.spinics.net/lists/netdev/msg570=
450.html.

Ioana

