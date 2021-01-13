Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA132F4109
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 02:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbhAMBUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 20:20:07 -0500
Received: from esa12.fujitsucc.c3s2.iphmx.com ([216.71.156.125]:6191 "EHLO
        esa12.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726631AbhAMBUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 20:20:06 -0500
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Jan 2021 20:20:03 EST
IronPort-SDR: ojoyjH+HFuqe/XgJEGYw6+0DJHv0Z1XsJnzJC1MNA0Vu5SS8z9Fal5JnVWCJ5CTY1pTdirsiyX
 uUULbt93HXCMchl67P99ctgISatzFNrWSdCKbm/heil/FiLohhZqVVGKocLPRu77SQ4DVKeskO
 38fltpqloa09g84GHrNv7czUYiebv/YNIZDOe3hlbgNJksmoQlTxNVnASlxWKD/tcCT8YCrU3T
 ZjhNbHvdZ4Mo3C07df+1eTS9n36gHpZ47RvIKlDyBBVWm8bXZZeNARgWeCWLEhK9LYHw8ZCRyL
 wyo=
X-IronPort-AV: E=McAfee;i="6000,8403,9862"; a="24300003"
X-IronPort-AV: E=Sophos;i="5.79,343,1602514800"; 
   d="scan'208";a="24300003"
Received: from mail-os2jpn01lp2059.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.59])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2021 10:10:10 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCFtyJ0qBesDULo2kbfLZamnruAaisPDriOAhkMOGfDnz5cyA75ExfFB0cIw2Ol+xT4+GXXmp8c7puOUSMnuGX+dlOkO9Ejgn9lhDsZxRwi1TljWpb18IbpCZ1zawJlGOHAGIw0z6ewUi6gW8+n8exnjKSGVA5felbUOsNWlegltwzdjqlT0rY/We4n7oy7I2/oylCH0Rt070XBlETyZP9Pn/kwUQ94utfJVVmM5Kkalf4g1466T+XJPtsHUKBIGnHmKS7stv8G2kt/8pggj5tcaUqTYImjDmYNEc2alvbphCarPDVxsyWd08s6dpAT95hmhWhjWTo6zLay2cYDEkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8e3lvydquJYdnPP6Zx9QROyfpXm5V12i4wefzuGrfyk=;
 b=be3eIB0nHI+EdWFvAtZ0cxC+JJEgsd55uJLCq6PlE7cbpmcWOZ87enhx8w9Rw3gelYqrw5wG+lRbuqn2kRNBTgpFNuP3iWu0CxZqI2Rc1gbb2mqrwuHPZDXOqz6XFyD9hXCY/rab1wDF8L07P3aWnYlnrtdiUyxS6PG36n/jY9s5DK2G+oXRQFV9B1x242+8c1tZGOT5YA9PDUGSd5tRdrWqjtE5T2n0PzqtJ8+zVTG4Bk8ZX/Ho5at17QpXv9TDNs6kzAEQB8zG1JiS0MpAWI4Qd+kU81sOCEslq1MAVz1quGI0hYvqqqyFgk7G0ApV7ZOd6OBfTYAaUkoGjAOl3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8e3lvydquJYdnPP6Zx9QROyfpXm5V12i4wefzuGrfyk=;
 b=jxA9ERgKgXpm60UmKEJCnGlPUSNiNXUWblt56iHI+igYHqwdGCSQFVnDehUi9jEz6w7C3SchVfnP89eGyY7YS1zFt2byd+NzOolBoFFykOMjsee8C8AZcqNxdcpCUxwMU4/Fs4AbJ4ExaELDdXhYEIJfr7GOH6Aexnb3wGN/csQ=
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com (2603:1096:604:5d::13)
 by OSAPR01MB1937.jpnprd01.prod.outlook.com (2603:1096:603:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Wed, 13 Jan
 2021 01:10:07 +0000
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::a555:499e:e445:e0dd]) by OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::a555:499e:e445:e0dd%3]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 01:10:07 +0000
From:   "ashiduka@fujitsu.com" <ashiduka@fujitsu.com>
To:     'Andrew Lunn' <andrew@lunn.ch>
CC:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "torii.ken1@fujitsu.com" <torii.ken1@fujitsu.com>
Subject: RE: [PATCH v2] net: phy: realtek: Add support for RTL9000AA/AN
Thread-Topic: [PATCH v2] net: phy: realtek: Add support for RTL9000AA/AN
Thread-Index: AQHW5y31ARgi0NV/wE25+9nETrMkFKohCyYAgAJo02CAAJKggIAAtysw
Date:   Wed, 13 Jan 2021 01:10:07 +0000
Message-ID: <OSAPR01MB38446846E9DCA49463F05BECDFA90@OSAPR01MB3844.jpnprd01.prod.outlook.com>
References: <20210110085221.5881-1-ashiduka@fujitsu.com>
 <X/sptqSqUS7T5XWR@lunn.ch>
 <OSAPR01MB3844F3CE410F7BB24BAA54B6DFAA0@OSAPR01MB3844.jpnprd01.prod.outlook.com>
 <X/2qI78PnWrpbWwP@lunn.ch>
In-Reply-To: <X/2qI78PnWrpbWwP@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v2.6.2
x-shieldmailcheckerpolicyversion: FJ-ISEC-20181130-VDI-enc
x-shieldmailcheckermailid: a7d18f4b23094daea96aaf0e72e21b2c
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=fujitsu.com;
x-originating-ip: [218.44.52.176]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d95c65ef-ccac-46f9-207a-08d8b75ff75b
x-ms-traffictypediagnostic: OSAPR01MB1937:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB193773CCC0A56BB9B41A69E8DFA90@OSAPR01MB1937.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8jDrCFw3RkqBOGzkkLPVHy+AdRZjqjgoCPXH1X43qu4QoxM6KNhoyIBRXBwyHclNOQkt+X2FiHJokISBIPHSusF4c0dQNhitMWTWzALauATHMshv3V2cfPsjxjVSIT4FqwNEuBbXZ9a6CNMyK7Xm7gnntZuE/0yeqYvPMUhMfVz9A0OQgxhbR6/2g5wbpN3I4N/Vm2bFC0cMQ2iNwH/8aoQlvHTly/q9/5ku66hCTDl8dZb709BrJC1zypRUcTuZOmZTSxzXqI9/bRDEk+JKFNOK4mJx4ZiqpQQxgSMDDYnKxjwkfvVo6ISfs8qn4hAm5+V+g0Xc8fk7E9wsN8pmIuRL6iEQvG1NnRzZHhY1lsZ5CrXx+aHx61XZGezBGT1dOah0WEwNIw8jcl1DYCl9VaY6II9loIRqkDjHKdlbHbd2cBsJkGC7ZTFmBpn6Cj8V
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB3844.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(64756008)(66556008)(66476007)(5660300002)(66446008)(2906002)(71200400001)(54906003)(316002)(76116006)(66946007)(8676002)(86362001)(52536014)(107886003)(4744005)(9686003)(6916009)(8936002)(6506007)(26005)(33656002)(4326008)(186003)(478600001)(7696005)(85182001)(55016002)(777600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-2022-jp?B?cUxpd0d5THhnLzNSN1VmZ09SUm1BVnUzMWxkT2dTWkpnYkR0YUY0eS9w?=
 =?iso-2022-jp?B?WUJMMUNUaDZodGhwbmZNTDRQOFRxZHFqQk00VFp2d3BjSGZ6bU5mUUlh?=
 =?iso-2022-jp?B?M0RPaHNvMGQwai9qZGRCVy9wb1BhVDhmNVVadk1xUC9La3MzWjh1bGtz?=
 =?iso-2022-jp?B?SHlaYVY5OW1MQTZmNHZlSmVLQ2RTVXNhUWFFV3U4V3NTM21HREhLK0tX?=
 =?iso-2022-jp?B?bDN6clMrRGtlTi9jK1dleVdGUmdJZndPSlBXSXFVajMzT3NaQW8xMHdE?=
 =?iso-2022-jp?B?ZlBOVzB2Q2VwYzg1Q0p4dVpibHFzcmlpUkhQUk5wU0JVcWtLSEVKbTVJ?=
 =?iso-2022-jp?B?VWpoKzFBRWxkYjR0UFFmWHQ2ZFFvVmJTMjd4RUhvcDZyZG5XL2l6M25q?=
 =?iso-2022-jp?B?TFRhcGJqZmIrdENyejFjb1FVTHd6N2p4NFBXekV4aUFoVFBZajBSeWNV?=
 =?iso-2022-jp?B?Z1Nyem5seUlsV1pkTkZ0YmUybGE0Ukt2cVErdGJNMEtjRVlhYjRScVh1?=
 =?iso-2022-jp?B?ZEg3Z1B4VWpKQWRyRk85TU43MGlwbkNVT1NPK3pWRXhIUU1neFg4QWR5?=
 =?iso-2022-jp?B?TE9XTlBlT0lTZ2ZDdmMxUHJOcmtXYzRDUjlpN1FCeEpQeWppb3drTTlR?=
 =?iso-2022-jp?B?NUVVMUMyR2RKbGhUKzNNSW8xNXVwY2hwWnpSaVd0bXNMWTV3Um1zMFU1?=
 =?iso-2022-jp?B?cFY4ckN6clFrL21rQjFueGtYZ3llVHFTbmtUUk9ZeHlmTVBqTE5ITlZF?=
 =?iso-2022-jp?B?L2NsS2MxbTMyYXBvancrU0JLUWlJb0ZOcHJrSE9zV0tqSlcwTUtuckcv?=
 =?iso-2022-jp?B?RzBpL2NRN3I1Yy8vaTlQRmF1cHR6UE1BQjdUaHpLWVk4ZnQ2OXFhZGFM?=
 =?iso-2022-jp?B?alZtNnMzUWx5Z0RqRzF2a21pVlNGVy8wSitvSy9kSTllOVFXMVhvbFk0?=
 =?iso-2022-jp?B?dHFRYjgvWkRjVDlKWGM2QTR1L2hxZTNUQUlMQW53VnlKVTMwZzlTY2dN?=
 =?iso-2022-jp?B?bUhSNkFyUllSVXdHeXd5NE1FcXQydmJ3ektNME9kRGR1b2p5MnFuaHly?=
 =?iso-2022-jp?B?b3Z0cGM2MXk1Zk8xVUNOU1pRYmk2SUVPYklJUEZObXJCd1UrRStNZ3U5?=
 =?iso-2022-jp?B?SFdoaUsxVmhpMFNUaDVYbUF2eTFVc0Jzc2hCcENzWTJURVR4Umo2cFJl?=
 =?iso-2022-jp?B?SzZZR0pYRWFKbzNrYVFvR3hrL2ZzMENrdk9IL3Yvd21xS3Z0QzVreGNY?=
 =?iso-2022-jp?B?QUdCbEV6Y05senBFbnhvNU1aQlowekNuSlBIelVTNTdZRExvSmJkV3Jq?=
 =?iso-2022-jp?B?VXBBVEdGNW1DOTVUZDNYdEo1T1EvMGFTc0prL2VjbXM0cERXTGhlTXVC?=
 =?iso-2022-jp?B?WDJiVXVvVjA3SWhPVHNaZ3Q3Mk1VZCtIZmZ5WjFzN1h1RE5qND0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB3844.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d95c65ef-ccac-46f9-207a-08d8b75ff75b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2021 01:10:07.1476
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 88dDGoWJnVy3T2hUIaeN3f0x/4FMxKxdjI47OsmVtq7SK4rwLrTtXfznxU88ZhOGsEQrHel0zTgepINfGTjQfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB1937
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I think it's possible to return a Master/Slave configuration.
>
> Great. It would be good to add it.

OK. I think it will take some time to implement this feature,=20
as we prioritize investigating comments from Russell.

> > By the way, do you need the cable test function as implementedin
> > nxp-tja11xx.c?
>=20
> We don't need it. But if you want to implement it, that would be
> great.

We also don't need the cable test feature.
However, we are interested in adding this feature, so we will consider=20
adding the cable test feature after the RTL9000AA/AN support are merged.

Thanks & Best Regards,
Yuusuke Ashiduka
