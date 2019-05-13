Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5E9A1AF21
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 05:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727282AbfEMDcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 23:32:04 -0400
Received: from mail-eopbgr10079.outbound.protection.outlook.com ([40.107.1.79]:50818
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727167AbfEMDcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 May 2019 23:32:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlGsj4ueqEj1Fa+w6gLEYNi4Trer+HwWp7+5HKmbi9g=;
 b=I7njBkhuulx3QdEDv1EmXmLEDANNuGDcXRvK6SXDu5pzcPu+rA8aerwOKHoI/HgwSQKIdDOFS8784H4zK8EeFggTnNc5Fc2nDPF5keWIfzDE3L2utd0eL2++6116vm5oDI4JZRAsWhSRJfBbbAPRZ5rhWmUgPa0d0a2uM3wEcvo=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB2752.eurprd04.prod.outlook.com (10.175.22.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Mon, 13 May 2019 03:31:59 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df%6]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 03:31:59 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ynezz@true.cz" <ynezz@true.cz>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        =?iso-8859-2?Q?Petr_=A9tetiar?= <ynezz@true.cz>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: RE: [EXT] Re: [PATCH net 2/3] of_net: add property
 "nvmem-mac-address" for of_get_mac_addr()
Thread-Topic: [EXT] Re: [PATCH net 2/3] of_net: add property
 "nvmem-mac-address" for of_get_mac_addr()
Thread-Index: AQHVBwm64QpngfTPuUW2xDFkk+Lk06Zkq1AAgAO5ZzA=
Date:   Mon, 13 May 2019 03:31:59 +0000
Message-ID: <VI1PR0402MB3600DCD22084A6A0D5190859FF0F0@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
 <20190510181758.GF11588@lunn.ch>
In-Reply-To: <20190510181758.GF11588@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0902c604-de6a-4e72-f395-08d6d7538e9b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2752;
x-ms-traffictypediagnostic: VI1PR0402MB2752:
x-microsoft-antispam-prvs: <VI1PR0402MB2752A38352565CA458A1FA62FF0F0@VI1PR0402MB2752.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(396003)(366004)(346002)(189003)(199004)(26005)(25786009)(99286004)(6116002)(229853002)(3846002)(6246003)(4744005)(8676002)(33656002)(305945005)(446003)(81166006)(74316002)(5660300002)(81156014)(7736002)(66946007)(76116006)(73956011)(64756008)(476003)(66446008)(66476007)(9686003)(2906002)(6436002)(66556008)(11346002)(186003)(52536014)(66066001)(478600001)(68736007)(256004)(53936002)(102836004)(7696005)(54906003)(8936002)(55016002)(6506007)(76176011)(71200400001)(14454004)(71190400001)(486006)(6916009)(316002)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2752;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 6fezfzpFmQl9nwgKfzE0wm/CrnbKubgR32WKQVwWUCu/WaLXHW3cRqGVu3Hy2M5aPm8ueMi/Rw8EnAYts5anv0S5oM2uHDu32yZ7oVoC5wdvzd+H1a9emPg2b608L9q7dQZnonftbvEjXQRSOapvaB0xLe7Q96rarwaSnTInc408ua4emTcdw23FfFk/Qk5s01jU925U+RrllKAE1mzbEN/RrxraKCcNqSykuKeB6yfq/8Jurr8kt2oe2f9Sx8SRuTxgQr+jLmpSC86gbZJyZjAjsiMl6H3+zgLXk0eM4m+0YK6IPMz/RhDhINgjsNIDCZ4lnVZFp1p5bvYnEVPXrcnA8NYHa0MkB9BPHf27wiEjYFSOyAzfjBIrQJKzjGLYfdZf3D59aPSL6w2hbMA8M1kZB/NY1RcztbFIEyWOkYg=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0902c604-de6a-4e72-f395-08d6d7538e9b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 03:31:59.3265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2752
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Saturday, May 11, 2019 2:18 AM
> On Fri, May 10, 2019 at 08:24:03AM +0000, Andy Duan wrote:
> > If MAC address read from nvmem cell and it is valid mac address,
> > .of_get_mac_addr_nvmem() add new property "nvmem-mac-address" in
> > ethernet node. Once user call .of_get_mac_address() to get MAC address
> > again, it can read valid MAC address from device tree in directly.
>=20
> I suspect putting the MAC address into OF will go away in a follow up pat=
ch. It
> is a bad idea.
>=20
>        Andrew

I don't know the history why does of_get_mac_addr_nvmem() add the new prope=
rty
"nvmem-mac-address" into OF. But if it already did that, so the patch add t=
he property
check in . of_get_mac_address() to avoid multiple read nvmem cells in drive=
r.

Andy
