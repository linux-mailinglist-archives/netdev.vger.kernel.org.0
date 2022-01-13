Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E7248DD48
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 18:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237354AbiAMR5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 12:57:16 -0500
Received: from mga05.intel.com ([192.55.52.43]:14254 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233807AbiAMR5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 12:57:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642096635; x=1673632635;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LzcirMWlBGP7xt+YNYnUMSj+vGve4C/F/OdcvYz1jAY=;
  b=mm506Vb2iUEScL84U2NuR8VCfOGowdCtb2aYNctxIKbOHEHW0Fmy9DiF
   Rmel/IgYPz6ma80kltdXZ4G+Sd2X6OLJFfhPTrQTYOILNmIQko+j8WyO5
   gnSP+rhhekp2NbfmgdwrgbgFoeLXKULEDV+Edgx7Z76CPMVF/iOaY9dyW
   twXjeRNVmjU0XVyI5qEIMoOK87umWsH3uLJTrfV2cgMy0bJWRWbTl+voE
   YOXqab0nGkFMXzNCRMS7RgJUgvJZLLTB8l9in1ULxJW29eysw5Jn8UhzT
   DL8DBMrOB/Myg3+81vQGDS/HpSv/0yHHL5Fx9ZyBdH/vlmuiFseEJGwHO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="330424458"
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="330424458"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 09:57:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="475426014"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga006.jf.intel.com with ESMTP; 13 Jan 2022 09:57:14 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 09:57:14 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 09:57:13 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 13 Jan 2022 09:57:13 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 13 Jan 2022 09:57:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMI9sMRc5ZUgC7Boksy4en9zhWJk9FjlNkzW8AAwkG6dhqrp/FwumpjcU6ytNfyb1gIli79yAMBtZ5c7zWYcqjqHgyTrUqZfKCFkDtSm1V6berfsMPMzpd+0yPHi5BxPQzTDA2IwpJtdruyT840BpXHRtY62eycJlwVNf3mK7bUqjof2TK6Thu3RwwJSNHns6zx4MKKvhGbTLVHlmNSEqMoMtvmqYixLxOS2AxRjCP+grW4FZH7oGjC0/P0DYV8i0Nrd0DFNfyLdguJX1LehFXb4f/nW6TMGGvY4xj+sSN549ZR63g/hvkEwg7MdD6nelLwQ0eSZa40Ikly/sSmEvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0RBenMlznp4eWk4jwQzAiYEKG3aDALJNMunbzhfw7tw=;
 b=bwtj98HA1V4b0+DLXdmUA5UgXksdBiJoRVhiWPoQ0aPsPmbc990jaIJ8QqCmb6lLY21P1RelwZVzE9mosFGTbCIUawBYUPj+wyV9/D5Dy29l05lFQpuAWgnWTAYfqMtci4UXhsIkH3zlZxNi+mvtyHRbIDCirfcRK9z1/J8rqOtsOSOSpoj/RKk147W5gEUZoZgT5xxroydN7CUTTrev2OIowJY+lu4Kn5FalGHcobfMOYiyBZHNSivOY3U5lXnO+pfXQ0gDasJSXhua5zFm9S4aqhNSzK4nuixC4wT7DYPO2sLvwxCDTma2UwhukHwKBFRBOzVNo5lL5zVWYlxL9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BYAPR11MB3063.namprd11.prod.outlook.com (2603:10b6:a03:89::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Thu, 13 Jan
 2022 17:57:12 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b%4]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 17:57:12 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [Intel-wired-lan] [PATCH] ixgbe: Remove useless DMA-32 fallback
 configuration
Thread-Topic: [Intel-wired-lan] [PATCH] ixgbe: Remove useless DMA-32 fallback
 configuration
Thread-Index: AQHYBX1Sbv5kASDb702YfX2gbt7VAaxhQtZA
Date:   Thu, 13 Jan 2022 17:57:12 +0000
Message-ID: <BYAPR11MB3367BB6A6D67E41A6EE574A5FC539@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <aafc0597758dd8ba58c15e4bf2e669872246c839.1641748850.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <aafc0597758dd8ba58c15e4bf2e669872246c839.1641748850.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a376df7-85d0-463c-c9e7-08d9d6be2067
x-ms-traffictypediagnostic: BYAPR11MB3063:EE_
x-microsoft-antispam-prvs: <BYAPR11MB306371E2113B4246B497408AFC539@BYAPR11MB3063.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bnyAlJy6u6447wKmZ2eWZQ+uYXFMyhtuwp2f3QmbUwBpZLfMV5f5NCJHI84A0/Xw9YJMs5l3kEbDGzF8xatUgWK1oOpGaVPpN6y31v8tWRSB3z5gAkuvuIOBVoloELBmj/fd9l7oAh12pHoTZcYC6MpfUZvwM+uQ2Q3r8ukDOiu9JJ1a4Ykt8qkduCa82QmtwVpYDHn0uY0Vrw3C6Gj7AF5Ec5+FDYikhtjzPHJVeNkJPctRoyVhkrsmYERU+1Alih3QO29v0q1s/wxzXrJMqw8wa47U9yIMqXC6xT6L/Ex/W0w3JqylYZfDxJyujZjJ2nTdynnYbq32cRJIV0w3yucOAzQfuoI1SYCZ6RXfUJmkp8gPMGZudAHDfeJ8SvJCPf+VXMSF3GXZ4XKw+AubtEzQXHfxRPc3O1za0c8BrXNZ8tM2Ac20vAdRKsINm62ZZ9ygodFT6ETUkBNv2pbisA2O+AUueSh5nmUke+GDaUCRivSYM5HXeKKD/xPNkM8At8cc+Zttg+aBRTw3uHTjRtV8XSE8SKt6NXQeuovhSOruwRPYnMNt+0TOWax2K3A15ugTXOitnYSI3q3LOB9t7QYAbVcF68CmKGkNRsTvCKj0qaoJ9RqmYt7aOWeOl3wYdpoVHOA+yyVWoeL6gO7XS3R7AvHLRSgBGkYi9c+AaV7Vmo+CVBru8Jzvjkdtw865bi+eNdr9/nmslsuM/cQxu8yr62Y9eEwVGPZiN2vTrqFi96op+SRMY/Vbceg+ezbipqtVF6bKgINo4155ExKKwvF8OczrPKHLrC2yGWH41l0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(66446008)(64756008)(54906003)(38070700005)(5660300002)(110136005)(66476007)(52536014)(66556008)(9686003)(55016003)(4326008)(966005)(76116006)(66946007)(316002)(6506007)(86362001)(38100700002)(83380400001)(26005)(8676002)(8936002)(53546011)(82960400001)(2906002)(186003)(122000001)(71200400001)(33656002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?51VfqIZlMnRlCABJlKwOfKGZMJHBGu3a8JKYL5xbEKVAHjdalQlVCPdAMjnC?=
 =?us-ascii?Q?//d48LyFZ0eAl4TnFTrKVWLAy1qTUij9grAPPRrXx/hgOkxfYgV2aEGDK4L8?=
 =?us-ascii?Q?CzlCVrBpnF2t6QfRRK1Ar9CbjBnhOtmNqjH5Ke+BBwLfPqLdwSndclnhdrWj?=
 =?us-ascii?Q?T5VhBwSonCNx1i5c3V4ThphXwIgV6rAP9dJmlhCLqZwDIp+/vV4R5cj3xAaw?=
 =?us-ascii?Q?776RV+/Mq+hd9zcIaRq3Z/lJ2PivuEU5vvCuAbLb+/Y2DMYQnEVa22UR8kIz?=
 =?us-ascii?Q?EMPYvw6bwVxs3lnZ1ETlwrmJlobC/4aN+fabG5wRnz1DwSlFoxDkdgwwgPVC?=
 =?us-ascii?Q?y3ftsBBbT70LuzmUB4KNtQvj24GVGay2OM21Si3+fhV9w1fkYcBucvl1zyP0?=
 =?us-ascii?Q?rLEzaXKOtR4FQp6A5zpdJrg/81OzIu/W5xaJnltF2hVqIwRxeSI7xjRuIn6H?=
 =?us-ascii?Q?VYgBAOKRD9w9E0jpmzUw8tvEdxuFBTCDUVnOSdXJVPaWgmpeYo0U1IhhD2H4?=
 =?us-ascii?Q?C/usxgl3dJl1yQFvKaGbcB1G3vpfyBCZdBvKpV9+muEFjTqdLV9uWdquQuAY?=
 =?us-ascii?Q?M+88GwkYijPQG33g0+Du/X9G3kezO4gsuEHyZ5D7S8P8oa2TRCgE3dCByZQP?=
 =?us-ascii?Q?leIVlfqUWHSjpIFa4dYdDrUCz0GcKwXfhtvSQFP0ZMeFaaRdOsKUCNXLUhvc?=
 =?us-ascii?Q?DPvoB7nYYw67oAwrClBro/ZwihkftrufPh0garyNbbRR+Tdo3dcujGOkHbUO?=
 =?us-ascii?Q?hGF4c/r90gZ3S73WrvK1mvqGEHZNyKHZw/HApOSm8pFkymGrR/8JcC2QJCM7?=
 =?us-ascii?Q?/7fit1sSeBg7aHh74F9pImAk0olw7OL7v4BVGTvkpseJ5f6LyuRTAWwTQybY?=
 =?us-ascii?Q?JjBuSaLw0WLlqbalvAP2Dxks36DMGGBpX2+tQwdYHAGXFwLPzuraA+3ZM32l?=
 =?us-ascii?Q?XkZyU78OCLamUtVyy0h4BYV/4OUcNdhCQq0aWK/qxxdGH9Yxmwn/XQfs0YJM?=
 =?us-ascii?Q?FyqZYVT2f6hMYzww1+XthH6UxOonnXaQLNUP/88CQLH9jqtYQOzNcCBvrtTC?=
 =?us-ascii?Q?XXtUNKS8oVTmQJMZGzwHI5vTIzaH0Qh0bWWmemtQuO2Tw/KNYkryXiZAC85x?=
 =?us-ascii?Q?qLBtvENXkshaU4pQNOkKe3n35b0PNd5TulxkXMaVJyJmT3yiHMGjgudwrTcL?=
 =?us-ascii?Q?4d32rDQEDQVwC8d1oA8r2ZRLpek3z13IOtzgQAVC2eo2QPbtop4RPKEdEka1?=
 =?us-ascii?Q?swDWYNiQxv6lwgTY52iWef4V37chDUuzj0m89727O356Nj9LO7EVDH7uJH8l?=
 =?us-ascii?Q?EkPYw+i4PvPEYbMoViOoYP1RtLtMtL3GL2n/4jk75spFUXw1jZA4rANgiI0d?=
 =?us-ascii?Q?kOGzDV9Ry695MFvivM9GP1/VlQD0MtQ1XuHUoQcEq/1tQg9ueg8WI1TqlOtF?=
 =?us-ascii?Q?nxs1xcTF8lG0eGy8PMXy9KaxhJH8P6lPzPoNR0x+dfO/KDtg9VXeoyIxwmDG?=
 =?us-ascii?Q?jH2C1RAi5a3hSiR7qJUJbbtufmd+blJO4Kow09ZuDBCjo3cGdXr2weFpDjo3?=
 =?us-ascii?Q?nAFfURVLLyc7xL7KycgmLltsTQBoFFW4/y8TpYKonFQsF8KGR2WQijIITEsC?=
 =?us-ascii?Q?uQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a376df7-85d0-463c-c9e7-08d9d6be2067
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 17:57:12.4032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bg/gsfYR2UjORq+1PycAYRzt+bLiBLh1cN5LxA+548ygLzV/AQ2+tPzbZCM9lghBV7I5Ugt0DYNLt1nvxRyxEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3063
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Christophe JAILLET
> Sent: Sunday, January 9, 2022 10:51 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org; kernel-janitors@vger.kernel.org; linux-
> kernel@vger.kernel.org; Christophe JAILLET
> <christophe.jaillet@wanadoo.fr>; intel-wired-lan@lists.osuosl.org; Christ=
oph
> Hellwig <hch@lst.de>
> Subject: [Intel-wired-lan] [PATCH] ixgbe: Remove useless DMA-32 fallback
> configuration
>=20
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
>=20
> So, if dma_set_mask_and_coherent() succeeds, 'pci_using_dac' is known to
> be 1.
>=20
> Simplify code and remove some dead code accordingly.
>=20
> [1]: https://lkml.org/lkml/2021/6/7/398
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 20 +++++++------------
>  1 file changed, 7 insertions(+), 13 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
