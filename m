Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F238D273178
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 20:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727821AbgIUSGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 14:06:39 -0400
Received: from mail-eopbgr80055.outbound.protection.outlook.com ([40.107.8.55]:64982
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726915AbgIUSGi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 14:06:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMcFsxxLAHa9TF4TpAYTuLymWZAaHo3iF0vvxXR06Jgwa85saIMJKNzpw03m5Vi/zDkLF7KyIFSx5JLrHDahpUMw+BlgFUmWhoYH6FPrPKYUPaew0MIrcxpnBx3OKyluXfKV3duQLj3a3qKEyzsZWU40cesxhPLScgQObKvrmoLofRzVpAHQSUrZSsuLaK64IsbwfB+bGplJyvEYe88di6B4iQex0s6/C50Ag1LmyF/NhL1Heue1HBZ9vKAX2VKtJjyrEFtewPVGQ0W512BFHXLWJ5RjZ+y6hH+a9LXtPn6oGb7buyOcQ8WUAZVWg26iKK9y2O4As0HoGjq2bnT9Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHX1dX00b19irq/BaKzImtfZi4Cx7BYjIoSAepKJifM=;
 b=ksZYKie/XZl/LkTRJiUUpj0+HsLwgK7swwD1ROU1MPhVbtF7E5lPuCpzBarRtSAZt52DPyBMa/f/pOJ8KQJJjJ+Dr3c78o2GDYsJXQnld+X0NsCoDADQ7Cyj0vaYdbjUb4cNvFp8fe14Ywng3LDBHhnuWIlnmOBOsMFVirHxBv7G7vdwMDtgL35K9MWedrMkGcKFhfeGoYj4uMfRBT9MXMqbiwZZnswx6a0sV4bjaCkercK3WDXWpBQLSmui17ytvkqYrQ93JBcsevd8JTxCfWvkhb/sjvlV2cmYSVG3RPjt1qsoqm3HMoRKRSbhAzoyUFSxl3EQm3yihRSZa2PbFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lHX1dX00b19irq/BaKzImtfZi4Cx7BYjIoSAepKJifM=;
 b=dJOFCJGAhUjDj0C6b7hcrMcFdgbUDNo+0k6JFMFrQzkJySLNy4l7EfuITBx/J+IRmLKSY1Q8ydWSh/v7hkCG+3lrl4jsEDyAQQicKBN+8ddgcz7R1sFVLhuxW5RtyA+syXNNLWR5lRalk3PpVT/4mPoqwixmwCMEL3fl5naGb8k=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB7102.eurprd04.prod.outlook.com
 (2603:10a6:800:124::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 18:06:34 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::3c18:4bf1:4da0:a3bf%3]) with mapi id 15.20.3391.023; Mon, 21 Sep 2020
 18:06:34 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 3/3] dpaa2-mac: add PCS support through the Lynx
 module
Thread-Topic: [PATCH net-next 3/3] dpaa2-mac: add PCS support through the Lynx
 module
Thread-Index: AQHWkDMnctnYMnw/FUSvaQ4sBRdvUKlzUu+AgAAQjAA=
Date:   Mon, 21 Sep 2020 18:06:34 +0000
Message-ID: <20200921180634.icsurl6qoz4nmz3n@skbuf>
References: <20200921162031.12921-1-ioana.ciornei@nxp.com>
 <20200921162031.12921-4-ioana.ciornei@nxp.com>
 <20200921170721.GE3717417@lunn.ch>
In-Reply-To: <20200921170721.GE3717417@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 14c8f892-33ca-4f66-238e-08d85e5913a0
x-ms-traffictypediagnostic: VI1PR04MB7102:
x-microsoft-antispam-prvs: <VI1PR04MB7102156B695FDC66BBC348CCE03A0@VI1PR04MB7102.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mjliYRemNQYfAEwpZNf2OkRxsf+kpGI3/Ustvcf0JB1YnP8Ej4PkUZVs1v+0tFFGsVwQD8ipdC2o40Ks+wU/KPEPD3yRkmH77fsqWTd3jDyWKQXy63qXGKsWeXrgb1XMCCa2IwX6qnoWO+bO7GtYeR3jPbo8WzChVGI85s+VBu7NOXQsOSVoS4SFaNS5RXwdlq6YSczX9a+sUJPJdQ2JvpR10BkPQGP9JHa6hQuwdjDl8saZjR5EVTLOAIHV4gmzIWzWZIg/ygD50zkizA9zKf/MA0pZGAH7B0TGtbqY+keZMwJUQt3Vu1GLOrqFR21sV/OkyAUD2CBm7mI/n+Qf5Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(39860400002)(396003)(376002)(366004)(346002)(6506007)(8936002)(186003)(76116006)(5660300002)(44832011)(8676002)(6512007)(66446008)(2906002)(66946007)(26005)(64756008)(66556008)(66476007)(9686003)(6486002)(4326008)(71200400001)(1076003)(6916009)(316002)(4744005)(33716001)(478600001)(86362001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: DL8Kbf9q7fzMVqFzxmFvTk8DLBJCbRr8UtsYtUcpb+uzRoccYSIzcDtJEJtyBZsIYIxnTv3Nw+T3hoCv0huPm7PteYuwbrEFB3sywQqCb2W8obI8gxZfcY2y9tINHf1TwqztuseYNJIB83GkEpPl3UHBazDzugmnv9Tb4SNFH83UoJWSBExOk369iS5jsZG984Jt7agPs52ZrzDV8lIihSRJyqxST5WOoTRsF+QuXXJF9aGQs6uoGVv+yy2KtKFvXBD9iMw3MxWE39gu8c25g2tNqcwfsm8CZQVDpf3gzEak7yIe2wKRm/wTODFUJT7FrlfnQEWRtGqtriiyo459uHR11SRh2PUW5pnKS5Xq5+DjdARu4aT4UOL7NbmGll/n2ZGvJlcOtHgXMmc5ZwprDZ/pzGvqbSDlSVHHaH43GfrH7FRiFiIurV4cWZYGmAedJF7O0afrMPibktRpESYRKuc/iIn4swBl8QR32Bi/+NVCYBA1NR4rsuCLmal3K8688raj/+ArKBuUz6uo7Siikk/MuY903O/PikArdfCSW5iXkS0tg06+hGHQxXqYnOMAPdK7PbMJk5QXKbJlfIxkS9XvCroJyHcpE4rsxkNIu5RztzI+pELQo872XiqTz7WYtPONMa9bnYVIPOc0YxG3aQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A96C6335BE87BB42A95E1010257296AB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14c8f892-33ca-4f66-238e-08d85e5913a0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Sep 2020 18:06:34.6138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +dJ9V/qfr1idRVz7/d6oY2do60gErJTjr8K5MKvtd8DpjhVQQGNio9Q9QyB6vPPyQvKuEgxhtmjVLu6phndeAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 21, 2020 at 07:07:21PM +0200, Andrew Lunn wrote:
> On Mon, Sep 21, 2020 at 07:20:31PM +0300, Ioana Ciornei wrote:
> > +static void dpaa2_pcs_destroy(struct dpaa2_mac *mac)
> > +{
> > +	struct lynx_pcs *pcs =3D mac->pcs;
> > +
> > +	if (pcs) {
> > +		put_device(&pcs->mdio->dev);
> > +		lynx_pcs_destroy(pcs);
> > +		mac->pcs =3D NULL;
>=20
> Hi Ioana
>=20
> Maybe the put_device() should come after the destroy? It is then the
> reverse of the creation.
>=20
> 	Andrew

Hi Andrew,

The lynx_pcs_destroy() function doesn't do much with the pcs, just a
kfree on it. I did it this way to avoid keeping the device in a
temporary variable but if you think we should do this in a symetrical
way, I can make the change.

Ioana=
