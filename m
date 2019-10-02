Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA20C8E5B
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 18:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfJBQ3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 12:29:13 -0400
Received: from mail-eopbgr690086.outbound.protection.outlook.com ([40.107.69.86]:33349
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbfJBQ3N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 12:29:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeG8pnKI27sED2lt/Cm3LhfUHRpszzgv3bo/NiSoPaic/dGPOdSUFeZ1sA8I6TIW+kWKd1/+/oie8iT2DyxVe1ljbjj7ZlSKO4vJy2x1vSjnKi+TuXHJlAZaSuOf/q/AmNwJ/c7bHmGVFNhNte6fNZtpJcycpw0KfbM8qjn06BrMj1h10GqFaCaYTLP2+2Us1sLTnexbMcBGs1gmrfjNhVf4wr/vrOoYf65FLahd2aUFXUf1y+31MGlpKZTTXW/MVHaqLzP7DMzoK0dKKeAtzeJYB58E4JUYifsnvmeT0iuLXSRbsKQj9fISUQfEKTJnaxRD6u5CL3HWeyJW6EkheQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TqsS9yAkHZKgkTTaiYIT3edGEKPEbqJuGoXtqtPCSvs=;
 b=aFL2h0/8vLQkmJqUiGL24GCzeKZIVi23+Evg4CPebqTvwfUvfOGGJDCARjTANL4ysN+iyMEt8y10phOEDlFJi3Rz8Gjwg6eJlYbzorpllQbUPG7NbQPUBTR74slBFM8FdLgUs7862eWpvpKmirydEx9xcxujvAZ6X7SE+CRePTa9mL3gXaD9q2YwkATzkseB7u+1RnSoNyG963VM4WmuLjCHf+Pd1mygZvFPxeazBwauhwIHHJEwP4V4d7++TBT9tJ7rv1Y0OCxcge6A0IyKxjAmG9GQcAbWZyC67BJWUPnNl97gaM/layGaokhbP3jHGfIJzK7d87tiriYAHvSWlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TqsS9yAkHZKgkTTaiYIT3edGEKPEbqJuGoXtqtPCSvs=;
 b=jDllI+cwSsvLD4jw+GDof5ttQyYQsl18kr9JmpbER+s1SUuEg4Ins8u/shLAF0aIqoZ/kugqAhQk37FgJ/eCNWJ1OsuzMShP69J2LpeRPwoGJd0r5y1ArvAFbKzhbER7ATr+c6nuhUldCcXjTZ2FFP6ew7xX84eE0cCd6tZjR6I=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3791.namprd11.prod.outlook.com (20.178.254.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.20; Wed, 2 Oct 2019 16:29:09 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ac8c:fc55:d1e2:465f]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ac8c:fc55:d1e2:465f%5]) with mapi id 15.20.2305.017; Wed, 2 Oct 2019
 16:29:09 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Le Goff <David.Legoff@silabs.com>
Subject: Re: [PATCH 02/20] staging: wfx: add support for I/O access
Thread-Topic: [PATCH 02/20] staging: wfx: add support for I/O access
Thread-Index: AQHVbthYAz5BV9jhoUCLDh42xNi6RaczMoaAgBRsfQA=
Date:   Wed, 2 Oct 2019 16:29:09 +0000
Message-ID: <4024590.nSQgSsaaFe@pc-42>
References: <20190919105153.15285-1-Jerome.Pouiller@silabs.com>
 <20190919105153.15285-3-Jerome.Pouiller@silabs.com>
 <20190919163429.GB27277@lunn.ch>
In-Reply-To: <20190919163429.GB27277@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2eb31fd8-11e1-46e2-4d21-08d74755a6fb
x-ms-traffictypediagnostic: MN2PR11MB3791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3791ED0AF9533F49D20B82FE939C0@MN2PR11MB3791.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0178184651
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(366004)(39850400004)(346002)(396003)(136003)(376002)(199004)(189003)(256004)(26005)(14444005)(33716001)(9686003)(6512007)(6916009)(14454004)(478600001)(4326008)(6246003)(107886003)(229853002)(71200400001)(71190400001)(6436002)(6486002)(8676002)(81156014)(81166006)(476003)(8936002)(486006)(86362001)(7736002)(11346002)(3846002)(54906003)(316002)(6116002)(2906002)(25786009)(99286004)(446003)(91956017)(76116006)(76176011)(4744005)(102836004)(5660300002)(66574012)(6506007)(66556008)(64756008)(66476007)(186003)(66946007)(66446008)(66066001)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3791;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WQuT9ru85Fw+Ub7ypbsVbkV5is1kD44Y82p6zyJISqF8pj5t5NxA6+stQ0LXQxvMmJLCO8kuPwj546yJtHU4YuW+JFVbHAYGEeLjORAE8B7KPZPFnDqiMmmJlwi79luy1psh4BjYhRS/iDQXcx8Ejb9QMWXqG3ivL+0CXd1zykQQMTQcb73AK0Cx2HS65gNv0xlkACQPmZneOnqVjg4dnHVIT1yCLJcP1GxVYaCZnN55l3iWhd5kJ0aVPKMIgtpY9cgRoepSLTUR9B0KLXB7JvxvV0NJUnL9jJD4VazP3AkFGuxa1DIMBf+i6aHD6314zlqaaBOyKsz/MBFsPyjMJJ0VaXfoapbItasPSLkz6+jKZpvDBelTTZlRtJOKjDsZuTXMb67FqvWQeUgsbnl7AilRB8kFdstWC7zps2kRems=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <D76D8AC44FFF174E98879F79DC311406@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb31fd8-11e1-46e2-4d21-08d74755a6fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2019 16:29:09.3634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zveEeK6gmYX/NPcpOPJa+E8D6619Rq/y6xubiDnrFIdQig1uNEA00n6aR36P4SUWdxv0ojy/vsD0ZnZr+tTr7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 19 September 2019 18:34:48 CEST Andrew Lunn wrote:
> On Thu, Sep 19, 2019 at 10:52:35AM +0000, Jerome Pouiller wrote:
> > +static int wfx_sdio_copy_from_io(void *priv, unsigned int reg_id,
> > +                              void *dst, size_t count)
> > +{
> > +     struct wfx_sdio_priv *bus =3D priv;
> > +     unsigned int sdio_addr =3D reg_id << 2;
> > +     int ret;
> > +
> > +     BUG_ON(reg_id > 7);
>=20
> Hi Jerome
>=20
> BUG_ON should only be used when the system is corrupted, and there is
> no alternative than to stop the machine, so it does not further
> corrupt itself. Accessing a register which does not exist is not a
> reason the kill the machine. A WARN() and a return of -EINVAL would be
> better.

Hi Andrew,

I did not forget your suggestion. However, if everyone is agree with that, =
I'd=20
prefer to address it in a next pull request. Indeed, I'd prefer to keep thi=
s=20
version in sync with version 2.3.1 published on github.

--=20
J=E9r=F4me Pouiller

