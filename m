Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE7A19C4A8
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388737AbgDBOrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:47:49 -0400
Received: from mail-eopbgr760075.outbound.protection.outlook.com ([40.107.76.75]:65156
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388612AbgDBOrt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 10:47:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eW+bRmGT98Z0wAzczCutzwsf2pWrspD/1BJ07e2hYcci96mdinIX9JsnzWkwpvw1BWglgXBSRjIygamqWItdJCFJV0gQY7ykbtMV0s4O+QsNyiXd4/z0DdNRXs7W0Qh+OIKziqA6XRV5cFHos0HR42B9T93EcCTowwGImlucGI0oVLwDVoDb736rmQ5dTQvutgoyPSSfYaNaatxz3cgaWEx4VvUSsU+y6nlQQuCwG8Z5+n+OWDEcUd+LnEKfokl5eJLfVA4rbB8MyKID+kseJDpD9kgnjDE1AjSR2m5qC6FyLprS2G/YqUqZpnaH0wHb0dpzNeDwmWT5hmmQenLZxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tx5HaOlF5WMgiHCbnL8ck9EVglskddJgBgzgphBcfhg=;
 b=l0u8llp14V+KmDxwJPNUWozkuRo4EgaNJr8YbW2Jntb05yUPwR+gOlcIcZBGWbGxP47wHKK8K9DwHWV/Xt1I56y0/xSqMHnKzLVDW7US77py4rDROBgh7LBnxDdju6yFvzL1TD+rAxBo48q0e9yQevyOjV0+n6ivQAqaeV/bBBPp7tIYQrw8KWtqr4WeCIZ5RNgcuzheQnRWDFuOnv1G9Yq0RwOJ6GAci8wMvYpKwXM+p5yjcQearnqzdIMAlcJu7un+yVGsTZuhMcpGLH2L+YIYzKRNgFhRRPaoJKo21m0ehosmuXsR/zTCOdxiWi9UVerJ7r5S/l+7QR8yPnTXrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tx5HaOlF5WMgiHCbnL8ck9EVglskddJgBgzgphBcfhg=;
 b=JmVEKs9vYVWjT3uIv1ioxHeO0cnhixvEBhJ9+bpI2oQ81WGcKzjxje9zWGu7shKQzZnIf0Re7Cs0pWv7WB1EQyDG0mrOz1Rw9ZXUgK7petsZfPj8rVy7nkU6shP8R253Hl/95sKCzIznuGpmZUqHfUQLKcsEpGLsvv1TuPRh8fU=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB3758.namprd11.prod.outlook.com (2603:10b6:208:f6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Thu, 2 Apr
 2020 14:47:46 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 14:47:46 +0000
From:   =?iso-8859-1?Q?J=E9r=F4me_Pouiller?= <Jerome.Pouiller@silabs.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 04/32] staging: wfx: remove "burst" mechanism
Thread-Topic: [PATCH 04/32] staging: wfx: remove "burst" mechanism
Thread-Index: AQHWCBVPTkK1g59Lj06+40sZrLfNVKhlzpUAgAAclgA=
Date:   Thu, 2 Apr 2020 14:47:45 +0000
Message-ID: <2993281.fr9RtUPQsq@pc-42>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
 <20200401110405.80282-5-Jerome.Pouiller@silabs.com>
 <20200402130526.GR2001@kadam>
In-Reply-To: <20200402130526.GR2001@kadam>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [82.67.86.106]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 444f3428-2d65-4b2b-bf1d-08d7d714ce7f
x-ms-traffictypediagnostic: MN2PR11MB3758:
x-microsoft-antispam-prvs: <MN2PR11MB37580815BDFD6BF7FBDB90F493C60@MN2PR11MB3758.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0361212EA8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(7916004)(376002)(39850400004)(366004)(346002)(136003)(396003)(26005)(71200400001)(81156014)(54906003)(33716001)(316002)(6916009)(186003)(6506007)(86362001)(6486002)(478600001)(8936002)(76116006)(66446008)(66476007)(91956017)(4326008)(81166006)(6512007)(66946007)(64756008)(2906002)(9686003)(66556008)(8676002)(5660300002)(39026012);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bC7fT14yzI98ccEY6ZtlAx9o74t1ZzlwBZoJzOLqQn9W9/17zjRZeVQhQi2z6yRb/E9k/3a+t2UKnZ3n9KmJLguaZsmIIOYO7rMbSqyLBxNGjNZUw55VNCeAii7QQqqhGeEdcJS3sPxSLSWDrnvjSQ7oN0PCyBJYcKDa769oeQYO+u/tGBCGuiX71wnSarkSjsvBn24C2u0LB0q19elhVzMFjBbJVe9vJz8FFpXGJP15K7yzFOOb4F7X28lad+WM4e4oJGg1L+7VD0dFZ1P5cXirm1KMDbOVG0giZUgPqeq+/muuiEUeq9QnbpNJCCEJ8bFVQvu4MWLRpsymK86TeR0xhw3ks6Dr1hFCzDx7PeAisisyHv7c6QMzfGnDnM5kyrMWijsDTr8vqjYfRBNZiaD50fpa7ObYWOMwwCSD2+0HBO5fMS6/98JvAWBIu2I6+usrdiGQEIUe5L9pDRid7nsoU66VzlvdJvzfoMCO9eSahwxyTs8Q+rw0ChumBja/
x-ms-exchange-antispam-messagedata: 9odATOtO0QhPTq2nAShPA3uNdLSMJJs/YnkXEXY0lj0iImpDumvCYlSWkZcuIZy06hhlg3PmhnaEFKytIn6oiKDCLyUbmpQY8v+kO860sZoCWjurZut1gPsxHJaxSdd8Rtjgf7qrxpTdRPSeQxVfmQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <CC952B9C1189284E897517DD71B780CD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 444f3428-2d65-4b2b-bf1d-08d7d714ce7f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2020 14:47:45.9121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zx/YJxdY5VZnixGjai+QJ8SE7qSSsGWw1Nd/ejuGINiZEcstX9IMwL6vLwcIIEwHkz11QkCmmLxts7ZtM39zAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3758
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday 2 April 2020 15:05:26 CEST Dan Carpenter wrote:
[...]
>                             ^^^^^^^^^
> Not related to this this patch but this confused me initially.  UINT_MAX
> would be more readable.
>=20
> The other unrelated question I had about this function was:
>=20
>    402          /* search for a winner using edca params */
>    403          for (i =3D 0; i < IEEE80211_NUM_ACS; ++i) {
>                                 ^^^^^^^^^^^^^^^^^
> IEEE80211_NUM_ACS is 4.
>=20
>    404                  int queued;
>    405
>    406                  edca =3D &wvif->edca_params[i];
>    407                  queued =3D wfx_tx_queue_get_num_queued(&wvif->wde=
v->tx_queue[i],
>    408                                  tx_allowed_mask);
>    409                  if (!queued)
>    410                          continue;
>    411                  *total +=3D queued;
>    412                  score =3D ((edca->aifs + edca->cw_min) << 16) +
>    413                          ((edca->cw_max - edca->cw_min) *
>    414                           (get_random_int() & 0xFFFF));
>    415                  if (score < best && (winner < 0 || i !=3D 3)) {
>                                                            ^^^^^^
>=20
> Why do we not want winner to be 3?  It's unrelated to the patch but
> there should be a comment next to that code probably.
>=20
>    416                          best =3D score;
>    417                          winner =3D i;
>    418                  }
>    419          }

Indeed. In add, this code is useless. That's why I drop this code in
patch 22/32.

--=20
J=E9r=F4me Pouiller

