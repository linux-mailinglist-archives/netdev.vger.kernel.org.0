Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A532A5015
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgKCT0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:26:52 -0500
Received: from mail-eopbgr10056.outbound.protection.outlook.com ([40.107.1.56]:39148
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725957AbgKCT0v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:26:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKeAoNkQbVnNDJD/KE0GtN2Wygj7QFRVW+r76Masx5b1RMgSuTUIUS8Vj1cltQJkIZUOE+U8hI+GVUrq4qYBBIAHUniS3HF7hTaA6VGV3iDTWvYZn2AjJDYiXnDUn16i6xF0SejkeS1bJQItk3Bh8ArY+2ZYdNiJfcFj7yZpTKZF0BFDBRbmfOUcm+LyFVt4wtxVG3gKQknQXOGx5oxddme//AuxcYGwmnSpL04vOZ/9TTM7f/eYEEAul+/gmuW3fjIwDfOLplAf86JIKrTL8DHLT3xoW0MxJAfUe1mKjBNAT3D1zuXtDKrfY3bDHDS4dC1rHEhlLxU3J9Qs5WWRjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3Aq7WvLL36LXEe20RCCxCbdDSXoKOdgxtC1OC9uDfY=;
 b=ErgzpMPfJcComoH5o/mT8pOp/5SEISWZbLm8FTtYVsf5uACuN4+VxXMKUyDBPb7PUis8OLoBJj+0vBW980WKe8dyZgbwYY5ftfDXFtvSS6lBAOOus9IqgmZ+G+BeoEaDlai5C0ZWI6TFzdb3EIMBLhmsDnkBnD3PTVMRgIrsDYmqEMmAYbeqxFcM10Nm7dcJjAR0hByFzGeOOMk3eAWw2NL8jT7UxzQOhM7cKEDmiIGpuBsYFUlozYx/UHLuK0U/ETxxcgZR8ocIjMUp1Fb1/FINib22afbnuOMlvUspFI153PRO11F9uqMOn6zOfcWGJoLYt0kCDJmOYDuQ/0g0rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v3Aq7WvLL36LXEe20RCCxCbdDSXoKOdgxtC1OC9uDfY=;
 b=Bx19HKXXERxW/DeoRsisI2EKyJqPQ55XobGs/rllILv/Zi9f6wx3Sgj47qCdGba3uWrseBgX0zjyMw2xonYGlu1/Vi4WDH4U7NRNcvtMGWjpyIYvLAwPl/jNDwq0p+BX+Ugeo/DT/3thfKRFjbF66UhLomg/2iIZmEKoOKZXN4w=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB3199.eurprd04.prod.outlook.com (2603:10a6:802:3::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Tue, 3 Nov
 2020 19:26:45 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 19:26:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Pujin Shi <shipujin.t@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] net: ethernet: mscc: fix missing brace warning for old
 compilers
Thread-Topic: [PATCH V2] net: ethernet: mscc: fix missing brace warning for
 old compilers
Thread-Index: AQHWsYzUZKuYzdPB3kGCvYd2O8gSwam2xWWAgAAGCAA=
Date:   Tue, 3 Nov 2020 19:26:45 +0000
Message-ID: <20201103192644.5amowv4yvjclhway@skbuf>
References: <20201103025519.1916-1-shipujin.t@gmail.com>
 <20201103110509.6bb18273@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201103110509.6bb18273@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bf66fb1c-0288-4d18-f073-08d8802e66d3
x-ms-traffictypediagnostic: VI1PR04MB3199:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB319911DCB6D01F34F7A31CB1E0110@VI1PR04MB3199.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1013;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a58Sj/rNdK7Ui5DBYEy5bGofBd01DKGQNOa8SA4IeL0MuDMlbzjr+Bpc36nbJhrNc+J0YFI8NXI5VMAZ4xNSs+kCfMH4/cnmAm2oUMZfZc1753mfSrEY+rg3f7B7RZZGN7/V7g0u/HwOL/H+wKESCWQ3OrS0uZa0S4aqxMAjdQ1MT2NFW/A9VDFWTBn7+7FIaEwm8CUfQ0AJSIkC649NtPLUPKEgCkDMtCEnUKO7G+2KLvERW1HQPH24my3rVZDhV471v/sgo+udeIPd4GLoU7gyMNesplzSlhLnHujZpu5W8CV9uG1TM10GXHQGypM4dSB9g3R51S1WSkss6DzoCw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(396003)(366004)(346002)(39830400003)(376002)(9686003)(8676002)(6512007)(508600001)(71200400001)(26005)(6506007)(66946007)(66556008)(66476007)(6486002)(76116006)(8936002)(558084003)(66446008)(91956017)(5660300002)(64756008)(6916009)(86362001)(1076003)(33716001)(4326008)(44832011)(186003)(54906003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 0yp+NbIK6c1kjJ/b8HWZMQHmhKvaVU71IAVjgxdzPiYzzkRRIlAbHIgVu/eX5XJt4nIHBponwBpT04wzkngw1XsPlfCfEWhI5bP2xpS/pwcFfnlLHbRPSdFaENOfFYEHVzowhb5+g9G6PPzM7wBa6H+7hZG3UBIOCfcVxmc4akMCNqczKnuTejL5tlFvHVAD1oTJPbFVmOFXNGltiMe3WDD6yupmOBYpkQtCgQ0n7uScT339reFIm7JAhoqE5+rwN4bwUwRwBh8NwRvgDX2FuFUxGQdTIfMf4HEo55dLpBLV9r/xZK5max3G0SIax1Ey8rPqSJr49HxAs+aGjx6m6rHm+cGSk0pgsvtY9gE4sIwqe3HhzbACxiKn2dbcbYduTGXApfbHUULuRvUcpIMGVyPqIoLXsScg3mjcUVAwKsMq4G5SsTw05WXEHYUWFdV8F3kinVs8FOOKaVyzgiBOSIbdcauBx9hNMkrulazcn3pizFxClESHSfk9qH8UJJV90zX9DU4ULPWFCrI7B/QgCQeT7k8fiidTW23XXwz8NQWVA2LIgXtJW3eUt8ZrllwLlITBhbNc8coz61zpCcl4S26PFIuLN1oz1cgI6mKNyXpxZbFDdliXgpYVSnP+2RXXB46dVzs6luqR8K6uV/Q/eg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A0520637BCE35C489717ECD298978427@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf66fb1c-0288-4d18-f073-08d8802e66d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2020 19:26:45.3752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NbyyeNV6a+O/6M6MWsnHEoV+e1lT2eP1LA4D7bybo3ywH/2xDVt+o/GT2wTH7/E4WOVU/PIxeV9osprU6ofOjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3199
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 11:05:09AM -0800, Jakub Kicinski wrote:
> I believe Vladimir asked to use a memset instead;
>=20
> 			struct ocelot_vcap_u16 etype;
>=20
> 			memset(&etype, 0, sizeof(etype));

Thanks, Jakub.=
