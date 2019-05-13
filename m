Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 503E11B210
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 10:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbfEMIrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 04:47:20 -0400
Received: from mail-eopbgr130052.outbound.protection.outlook.com ([40.107.13.52]:39325
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726103AbfEMIrU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 04:47:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QAJM/zIm3oR1DH0QGsGnmXBGDMY8hzY/MJ16Pr9JwxE=;
 b=QZbyjCgLCoMJb4B15z8CyxjTEjhhOGUb8qSHPZEqEbUHmoyHTKF/5apGWWeZF4B/jkIJKhl/LHM/6c6dwvLJU5vWa6J9ibuk40iB4BiPatk+WaRl8GTjEKfaMCn2wZ1l2y4QZF9U/x29GIcdVc50ni2WWDSCK3vg+F+aOuO7XD0=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB3871.eurprd04.prod.outlook.com (52.134.16.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.25; Mon, 13 May 2019 08:47:15 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df%6]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 08:47:15 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     =?iso-8859-2?Q?Petr_=A9tetiar?= <ynezz@true.cz>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: RE: [EXT] Re: [PATCH net 2/3] of_net: add property
 "nvmem-mac-address" for of_get_mac_addr()
Thread-Topic: [EXT] Re: [PATCH net 2/3] of_net: add property
 "nvmem-mac-address" for of_get_mac_addr()
Thread-Index: AQHVBwm64QpngfTPuUW2xDFkk+Lk06Zkq1AAgAO5ZzCAAFD7AIAADJuA
Date:   Mon, 13 May 2019 08:47:15 +0000
Message-ID: <VI1PR0402MB360046D827C19279B3000810FF0F0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
 <20190510181758.GF11588@lunn.ch>
 <VI1PR0402MB3600DCD22084A6A0D5190859FF0F0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <20190513080010.GV81826@meh.true.cz>
In-Reply-To: <20190513080010.GV81826@meh.true.cz>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7b96fd9-25ec-44ac-f3ae-08d6d77f9991
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3871;
x-ms-traffictypediagnostic: VI1PR0402MB3871:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <VI1PR0402MB387153B4321177349978135BFF0F0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(366004)(346002)(39860400002)(376002)(189003)(199004)(45080400002)(486006)(446003)(66066001)(8936002)(8676002)(4326008)(6246003)(55016002)(73956011)(66946007)(86362001)(966005)(478600001)(26005)(14454004)(52536014)(6916009)(102836004)(11346002)(476003)(186003)(76116006)(66446008)(64756008)(66556008)(66476007)(5660300002)(6506007)(305945005)(54906003)(7736002)(6116002)(316002)(2906002)(99286004)(74316002)(33656002)(25786009)(76176011)(9686003)(71200400001)(71190400001)(81156014)(68736007)(6306002)(81166006)(256004)(53936002)(3846002)(6436002)(7696005)(229853002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3871;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Wjmyzcx3c1s0d0gXpYVslR3oD6dvHU075kFEAE0FHJbVSl3iNsNRr5+5o1YA8/7wHgO7hppvhfKgD+fYha/MLGN02Vsi02locOEjCBt1REOwta8ZOmfSS7DcA3ZkaEgIw03PKqfz8jk4S9AmKvb9okR/jfbMKxWj7doKtVqD9W1wlcVdXiUugOOh/osNVa4m5W4u7Ou2ug3w618Y5oFvUHUe5iUPWwUf4mbBTx7KAeXHuLmQCl2qGTmU2I29KP+FwhTZELRJVx59bcKcpGclLd4bR5bbTZ5QluOibMGNla+apDNmO0KS0tKKZorQZPnfC2yMeuemTXF2EvJiQjfAvPYCh20KKEHbOVSK2C+lpSGc4An3iEf0Ve689pqWT7vbRlsDKwVWjdF/A7B7b1KukyiJv+r8x3ha8tQodbNZkCA=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7b96fd9-25ec-44ac-f3ae-08d6d77f9991
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 08:47:15.5130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3871
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr =A9tetiar <ynezz@true.cz> Sent: Monday, May 13, 2019 4:00 PM
> Andy Duan <fugang.duan@nxp.com> [2019-05-13 03:31:59]:
>=20
> > From: Andrew Lunn <andrew@lunn.ch> Sent: Saturday, May 11, 2019 2:18
> > AM
> > > On Fri, May 10, 2019 at 08:24:03AM +0000, Andy Duan wrote:
> > > > If MAC address read from nvmem cell and it is valid mac address,
> > > > .of_get_mac_addr_nvmem() add new property "nvmem-mac-address"
> in
> > > > ethernet node. Once user call .of_get_mac_address() to get MAC
> > > > address again, it can read valid MAC address from device tree in di=
rectly.
> > >
> > > I suspect putting the MAC address into OF will go away in a follow
> > > up patch. It is a bad idea.
> > >
> > >        Andrew
> >
> > I don't know the history why does of_get_mac_addr_nvmem() add the new
> > property "nvmem-mac-address" into OF. But if it already did that, so
> > the patch add the property check in . of_get_mac_address() to avoid
> multiple read nvmem cells in driver.
>=20
> it was removed[1] already, more details[2].
>=20
> 1.
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgit.k=
er
> nel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fdavem%2Fnet.git%2Fco
> mmit%2F%3Fid%3D265749861a2483263e6cd4c5e305640e4651c110&amp;d
> ata=3D02%7C01%7Cfugang.duan%40nxp.com%7Ca9620569af74418a6a1d08d6
> d779076b%7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C6369333
> 12147303481&amp;sdata=3Db2BB49WSZDqUfMhCeHobjI%2FLcXLed5sBkXhcR
> uM3mg4%3D&amp;reserved=3D0
> 2.
> https://eur01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fpatch
> work.ozlabs.org%2Fpatch%2F1092248%2F%232167609&amp;data=3D02%7C01
> %7Cfugang.duan%40nxp.com%7Ca9620569af74418a6a1d08d6d779076b%7C
> 686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C0%7C636933312147313486
> &amp;sdata=3DXu7CJyxmOC476k2RiMu2lm6h9juvjEflbztzp1wryuk%3D&amp;re
> served=3D0
>=20
> -- ynnezz

Got it, thanks for your information.
So the patch also can be ignored.

Thanks, Petr =A9tetiar.
