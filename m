Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC4A97FCE
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 18:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbfHUQQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 12:16:40 -0400
Received: from mail-eopbgr10045.outbound.protection.outlook.com ([40.107.1.45]:8117
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726828AbfHUQQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 12:16:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BE86Kyq/B1nkGEtSlIJbc1n4pJRMbEaxYTYuIve5hH+c22LgO+fgnZ0RojRbfLCBM7lt8l+4EiEH3EqiqFFHpI9j1Vyg/avT1d2Nk+NUMlGFtFV7LmXwTpdGDsa/Aac6REGfCRslQqLmIKZWBefMTFiAwfWIahJRLfjn/vnCEC6oh1yGZRrdUYSmTAkDW597BfLZO8uFaICXm7OXeXHrJTwQ6jdglLWagoj6Aa3mVXmQlig84jJRnesIuyW3GvG/eW3irjiGymcHyxmDNyJWPiynkXQ/O/cv4gMWXh0ii49Ezglcg3WPbjQyUYku8S6r5MzdxtCS4vDmVazwnrrn9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TGkgoElw0knAwgl5PTJkk82A64yXG7L4CgduFmH6xE=;
 b=VhhhqqkobPCAUwAut/04Wy87XdAuIBqcg/dKlnF0r87bkH8Z/NpInIGpjzXenldSrEfhxB/PsjJO1dkWPlsdx6Sx/IYuCli5UB1u0KtRF18qZM1JjN0wRKoCpbNYU9D5pGRvF8L+TOwURxRJhLC5tUwBweQGCawpsdGMvcX278GOZXr3ydzDrIBXkMBd3uO+u+gsF/lRt6uYmisMRLJ+1r6ZspcmkgnbgMqKbfcv0iF7QlJgoHvWy6SGZnu2VdgX53yA1+xdYOeQOaIpdx+NKlFZr+jF+2kp24SK8kEEUFmEJ+urmXGfFpWlw/fpDqxLD9179OynC91NxXfRaOwF0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TGkgoElw0knAwgl5PTJkk82A64yXG7L4CgduFmH6xE=;
 b=eFukYABAW9o4OTNtMlKzSyY7/Q6ZnbhOpcnOnE1JCeRQFlphFe8CQlA0R+y/CIAnw5BEh8YX8/HXNGskBlPrM/8aR/1+1QEoSjH3VEpKYkNz6BV9sOwJGAO2Gf0UUpYTil3YOLKmX5JikwPdUcBQR97M7bemZ2ZzKA/ldAx0NpA=
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com (52.133.29.29) by
 AM6PR0402MB3349.eurprd04.prod.outlook.com (52.133.18.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Wed, 21 Aug 2019 16:16:32 +0000
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc]) by AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::9de1:26ec:59e5:32fc%5]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 16:16:32 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     David Miller <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH v2 net-next 0/1] Add BASE-T1 PHY support
Thread-Topic: Re: [PATCH v2 net-next 0/1] Add BASE-T1 PHY support
Thread-Index: AQHVWDvLLmDgCDHYx0GZluZJmkZkZA==
Date:   Wed, 21 Aug 2019 16:16:32 +0000
Message-ID: <AM6PR0402MB37983B7CA4DC2EF962D75D0886AA0@AM6PR0402MB3798.eurprd04.prod.outlook.com>
References: <20190819151940.27756-1-christian.herber@nxp.com>
 <20190820.122234.1290995026664280862.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c37c23ca-4fcf-4d7a-a1b7-08d72652ee67
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR0402MB3349;
x-ms-traffictypediagnostic: AM6PR0402MB3349:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR0402MB334909E7847EB8219207093286AA0@AM6PR0402MB3349.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(189003)(199004)(8676002)(71190400001)(74316002)(55016002)(7736002)(305945005)(6306002)(9686003)(71200400001)(33656002)(25786009)(3846002)(44832011)(14454004)(110136005)(486006)(52536014)(2501003)(5660300002)(476003)(54906003)(4744005)(76116006)(91956017)(66946007)(66476007)(53936002)(66446008)(26005)(55236004)(6436002)(186003)(102836004)(2906002)(45080400002)(229853002)(446003)(6506007)(53546011)(966005)(7696005)(4326008)(8936002)(256004)(76176011)(86362001)(99286004)(66556008)(66066001)(6246003)(64756008)(498600001)(6116002)(81156014)(81166006)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3349;H:AM6PR0402MB3798.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: M5WDIabyHLJpcmqy6Zi7RagFAkg/kIRzxqn8YqPMJfpJ3AcPeHj4V1Ke2We1SLfoTvAtF821oEo5wOeHmTvfy0vvJqFkEOLAY16NVC4sMT1YJTm7WdWdS2p/4LiXi7eJ24QGlv0BDpv36WiWc8SqKD5d1gI0HteXis5Y+IzXx0QYbpiZevvBURbKwNSkRLdcLo75TsMZgUHxBJcEBVFY7VbSsQwTLIbQYgLaPLQY5Eq0jhgchI/rusypx9GE8A38/LIAQBf2Gn/xZryMqMbi95viAYKKcYeGScFFQrh9z1z9Lkuv/0hK6bOcXUdpVA1ZDXRmsn5eN0YVH9d7kdtuZelQy59mQ4Lmn1gOshonEBl2iHWdYDHxQpr70TauxsUYqQwMdtY0phLr3BX9quyvvSY+ixPI86fZ21U+xh5gCQk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c37c23ca-4fcf-4d7a-a1b7-08d72652ee67
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 16:16:32.3288
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZvtGO8F90X3V5fQdIqlIZZVwhjcuX7vzxlWJCQvaAFERNWLZKCjLgMLAo2LZsW8fPnEjCExWsZ3Uhy2ZULyb4KytP1JBCI90wHuJvPN//uc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3349
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.08.2019 21:22, David Miller wrote:=0A=
> =0A=
> From: Christian Herber <christian.herber@nxp.com>=0A=
> Date: Mon, 19 Aug 2019 15:19:52 +0000=0A=
> =0A=
>> v1 patchset can be found here: https://eur01.safelinks.protection.outloo=
k.com/?url=3Dhttps%3A%2F%2Flkml.org%2Flkml%2F2019%2F8%2F15%2F626&amp;data=
=3D02%7C01%7Cchristian.herber%40nxp.com%7Ccbb5f329425240eda10a08d725a3c305%=
7C686ea1d3bc2b4c6fa92cd99c5c301635%7C0%7C1%7C637019257604516613&amp;sdata=
=3DIdBZbqGgA0upPZZrBQSxPL%2Fh7Tn4BtYA4%2FfS6dZngWU%3D&amp;reserved=3D0=0A=
> =0A=
> Please expand and clarify your commit messages as requested by Heiner=0A=
> in his feedback to v1.=0A=
> =0A=
=0A=
Hi David, Heiner,=0A=
=0A=
could you please be specific what to add? The discussion was on various =0A=
topics. Agree that it would probably help to add some more clarity, but =0A=
it would be good if you can specify your expectation in this.=0A=
=0A=
Christian=0A=
