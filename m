Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F32CA2FABB7
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437160AbhARUky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:40:54 -0500
Received: from esa4.fujitsucc.c3s2.iphmx.com ([68.232.151.214]:9043 "EHLO
        esa4.fujitsucc.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390209AbhARKef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 05:34:35 -0500
IronPort-SDR: y1Uypx9t79j6M5vvPniTG7zWylppOM4EqlipMVtJUvZHu3unFNbDXvuxv7LUy2vGpbW5RKVG9O
 O/yZk4RpnEWylqX9KnG2ZTYHJUTUF9AvsMa3YjrDm0/uL7wOaIHrp7auzaIQ+Dh2qadOMHNeOq
 YsQ0UKjGQX1acEHoULKLWb8q85gyq49DhjJ22Ry2pHnEYf6nYFM4ZUZba/ShBCMpJS/FOVolrh
 d7cNfCATcUBOBf+bPaF40jhadmP0iWxXYS8KXUSKcDa3sfxvYuA6wPkwM65GWHslkQ94/qostQ
 V8c=
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="32482899"
X-IronPort-AV: E=Sophos;i="5.79,356,1602514800"; 
   d="scan'208";a="32482899"
Received: from mail-os2jpn01lp2053.outbound.protection.outlook.com (HELO JPN01-OS2-obe.outbound.protection.outlook.com) ([104.47.92.53])
  by ob1.fujitsucc.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 19:17:07 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dT4aoTLpZNeCUZRZYGxJRRJb3/H+vi3uzR3Mjm1rM2P9uvTFcQZKReaitEa5LKyYHxAfogzbinTH+bNAixx16R6stcs2XeeKQMdIgDuCiGHuMX9emxAUQ3U8Gc10c+zDzqKRgUYQRlB111oMQ7l9vSeONxUodEgExJUDhnWtnkoukvDZOTzH1R5QvU5ZJAVlr6ybPtCKdml1mJfi9lfmQ7hwsCZ3nW0XTUIKQy1e7ApHSAMctqFQgyQFBV28E1U80FuPtXpBUk7F6km9ZUhcmEhyVM35DEF8cmuv1Y9yI7J94Svs65oArerpN0LQil/UM4xkfWSFxp26hPJRI6pkuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jx/t5Pm2Ng2y1Kna4hRfV5Km3KSyqdsQTj/kT9+mcYg=;
 b=STghc3dCdPmelTmJDBrNUVZ7YzAv9/1O86XNVfTGchTcz1Sc0DKtqbq1vfV6fJEi9tDtqFtLzfC7fRdzRZJ8eZsGPmy8d3EcIIAvRqnhnDcn8iZS739xTzJFrdsTYb2QwgRL2FYC1zB0Mc8AsNDaMhmx09hLY9guqmpB2ud0uoECdIEfrwfg50SJlNNS8Dm/Rhx+MuGHGPXBPPRaZbxICl58vROnd3WqnOLP/g9rb2JqEeOrNFaoT3OKOL0Y6MuVuWh9lAlZgLxQg/HTNXsMo39kfKnghh6nXXLDii1mLciEZgeaeuiHxBi9RMYJLjVFcHOBRf0gJGxJA9KWB1IOSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fujitsu.com; dmarc=pass action=none header.from=fujitsu.com;
 dkim=pass header.d=fujitsu.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fujitsu.onmicrosoft.com; s=selector2-fujitsu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jx/t5Pm2Ng2y1Kna4hRfV5Km3KSyqdsQTj/kT9+mcYg=;
 b=qzIxqkhQLHgCJ31K40MUTCjL92XFCQkm7mT4rLTXOIR+CxtMe44L+jGJwFUm3xhsnGcxVG7RdqKwiZt9Su8Huh6M/ijJa89RSZFmCe1F8yiITvTJunr4pdWC9u7+AAbenlyTlLY3uzxBO4f20ZHuPm+m/Do3opAxf07SeoDzoQo=
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com (2603:1096:604:5d::13)
 by OSAPR01MB2115.jpnprd01.prod.outlook.com (2603:1096:603:19::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Mon, 18 Jan
 2021 10:17:04 +0000
Received: from OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::a555:499e:e445:e0dd]) by OSAPR01MB3844.jpnprd01.prod.outlook.com
 ([fe80::a555:499e:e445:e0dd%3]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 10:17:04 +0000
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
Thread-Index: AQHW5y31ARgi0NV/wE25+9nETrMkFKohCyYAgAXFg4CAAPQjgIAADo6Q
Date:   Mon, 18 Jan 2021 10:17:04 +0000
Message-ID: <OSAPR01MB3844F07254AB8B1164086D7FDFA40@OSAPR01MB3844.jpnprd01.prod.outlook.com>
References: <20210110085221.5881-1-ashiduka@fujitsu.com>
 <X/sptqSqUS7T5XWR@lunn.ch>
 <OSAPR01MB38441EE1695CCAD1FE3476DEDFA80@OSAPR01MB3844.jpnprd01.prod.outlook.com>
 <YADN77NvrpnZYUVo@lunn.ch>
In-Reply-To: <YADN77NvrpnZYUVo@lunn.ch>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v2.6.2
x-shieldmailcheckerpolicyversion: FJ-ISEC-20181130-VDI-enc
x-shieldmailcheckermailid: 085687f74ae44a308c4eff4fadd55286
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=fujitsu.com;
x-originating-ip: [218.44.52.176]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f175477-cbdf-4811-b2e2-08d8bb9a33e8
x-ms-traffictypediagnostic: OSAPR01MB2115:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSAPR01MB211517AC2F3DA1450D9BB99CDFA40@OSAPR01MB2115.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:176;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2qE/YRhy6Xh6FB6puchvzTlTpJOkzZpuWtQLpYPDhuj/rrhzD7gaJZFwtmj1bsi+uQyBXqXpZDYoFSRmmpKLH2/jBI/HVBD9BwxifReNMh4oXIEldYsFI8uARsh5QZ+WMVtj2euxPVMskN9ln8UV4kfmczmfZAzbvCsuQPWV7iuCajR91IBVPIrVhRDAw2ELsETH4NVQZRIoEWQIFSy6tuzJ8g3rFeLoCS8M78S7x2XTtKvTrzt98Cc+573RaFD2aXUGp3GTek3r3xEVRpzJVFT70di+frfSBwVy0nF/XaUAPmSEoA/jNBodzZbjSNG8xCLy9s+pNpVieEBaKHkVCxiT56GBbSvLfwu6qQKuaM9I7ZMgFTNBDI83T2g5dgBGIsdphnXHwBED6ppQFrLiQSR+2kDLJfjtFCpra4wdCksxdjbt7ZmUzD+/I4A4ok34
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB3844.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(54906003)(64756008)(8676002)(5660300002)(85182001)(4744005)(66946007)(52536014)(66446008)(2906002)(86362001)(71200400001)(316002)(4326008)(107886003)(478600001)(8936002)(7696005)(33656002)(186003)(6506007)(6916009)(55016002)(9686003)(76116006)(66556008)(66476007)(26005)(777600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-2022-jp?B?QUpLWG9JdGQzRXFkN0U0dlM2OXVnWXJXVmkvWU1hQWFXb3ovVDhwVUdP?=
 =?iso-2022-jp?B?M1cwK2w5WjZmQkVucHMxdjFCTHlLL3kwVUdQTW9aTmYzZWpqYjVhVlAr?=
 =?iso-2022-jp?B?TENZSlZmK2NXcGRaNi95UjFhaWU3aGUzY2k1U0x2aitiejZEZ2hOenJh?=
 =?iso-2022-jp?B?TEV6RXRuZUZWdFBnQlZXTUdPcmltUjl2M1pVa20xZURCV3JkU1pSTTgx?=
 =?iso-2022-jp?B?THZYYTQzZjdKR3FRK2VtZUdEOUFHenlyaGtaa25UTU4yVHd5cHZ5Y0lG?=
 =?iso-2022-jp?B?VmUwMjFvVnV1Z0VQUkNLTFlkSTF4VUdkRkxmL0pEZ2hSeHZpMG4xNGFh?=
 =?iso-2022-jp?B?V0hPTVBINkJCMlJnaXdpeUY0V2dQSXMxVmp2RndIUnFZRTVKK1B4Znhu?=
 =?iso-2022-jp?B?RFdxUjdJYjkwTGVFenQ5djZ0M3BoNHZkbUdZdndsQ2tlSWlUbG1SZ2xx?=
 =?iso-2022-jp?B?bXc3UXAvVkt1VjM4bG1aVGFJNkcvZmRPWFducHltVHFFNG9zanR1Z0tO?=
 =?iso-2022-jp?B?WEJ5RjEwZ0M5bEFPNWJkOTB2QW50VGFwNkNzM2JnUVVsSDNwQ0FTWDNm?=
 =?iso-2022-jp?B?UzB4REVDVG9Ba2lGYjVVYzNINmwxOG85MTdTNEhYYy9WZDJsdzRLdUJR?=
 =?iso-2022-jp?B?K2ZxamNVNmFqVnJpcXJ2UUZTaVA3UXFEUEMzekpNeW9VeTlVN3VHUWYw?=
 =?iso-2022-jp?B?S1FmK2laOXZHVEp5U2oxcUZ5ZlRma0x6c1VuVE1zenQvY3IrZ0dkVlBZ?=
 =?iso-2022-jp?B?V3RhUWdEK01SRjZsUjlxTUpVVGpPdXBVZHc2ejhsQlRWQ0l6T25UcGxI?=
 =?iso-2022-jp?B?blhUbXJXSDZDeXJPem9Ya1RxVXI5aU40VXNhTXdtaWUrQnBrOUxDVWd4?=
 =?iso-2022-jp?B?QWhMa1lONG5GVy9BeVp2amxKclZSMGltaFlDK0pPYTlFKzJHNXZRUWdP?=
 =?iso-2022-jp?B?Mml3NFM0T1p0V0tSSzhXdm9RYjk5b1hmMGRxYjU4RnIxRzViMFl0cmhD?=
 =?iso-2022-jp?B?dHpFeVNiWDVIWFRWY0F0K3hhMSt5UEZabUkvMHlldVlmM3l6T1ZTdGpk?=
 =?iso-2022-jp?B?QUxFWkpWdUxuaGhCQ3p2Q1FGNU1kV1l5VWxkb3RJem13cDRjRlZwUDl5?=
 =?iso-2022-jp?B?Yk9nUkRGYnlJVEVSdXlpd3Vud1Q2cEViekVTNmFXcGlXSVQrbEdaSmlm?=
 =?iso-2022-jp?B?Y2cwZlBXaU54U0hvbEtjbW0wOUJJN0h0K3J4bFhtOXdTdnl5NXBOeFp4?=
 =?iso-2022-jp?B?K09aK3NodVA1YjZ2Ulg2bFhUZk55dFVCdkZQYUVuYkRzU1BOc25DSkVW?=
 =?iso-2022-jp?B?ZytETTZJVm9DWFY3Smp6dElhQTM1SkNrYWpTdWV4NHJIYjJjTDFMRStl?=
 =?iso-2022-jp?B?ejR5cmpQNDN6ajRtRmQrYThDUVFsamdXM3REWjRVR2JrbHlGTT0=?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: fujitsu.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB3844.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f175477-cbdf-4811-b2e2-08d8bb9a33e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 10:17:04.2521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a19f121d-81e1-4858-a9d8-736e267fd4c7
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z0uIEp4jiUOH0qalwIGP++TG4o4ywmTO3AXElWid6c83/5YwMrefpsc+DTI5oV3ESezwySSTGtPV0LPQusz4SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2115
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew

> > Do you know how to switch between master/slave?
>=20
> There was a patch to ethtool merged for this:
>=20
> commit 558f7cc33daf82f945af432c79db40edcbe0dad0
> Author: Oleksij Rempel <o.rempel@pengutronix.de>
> Date:   Wed Jun 10 10:37:43 2020 +0200
>=20
>     netlink: add master/slave configuration support

I know this.
--
# ./ethtool --version
ethtool version 5.10
# ./ethtool -s eth1 master-slave slave-force=20
ethtool (-s): invalid value 'slave-force' for parameter 'master-slave'
--

As I wrote in the previous e-mail, it doesn't work because it doesn't=20
include the process to parse the master-slave argument.

> The help of the ethtool command can show about the "master-slave"=20
> option, but it doesn't seem to handle the arguments.
> I checked ethtool.c and it seems that do_sset () doesn't implement the=20
> process of parsing master-slave arguments...

Once ethtool works properly, I will test the master-slave switching behavio=
r.
