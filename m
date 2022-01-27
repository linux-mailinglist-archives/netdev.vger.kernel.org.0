Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB6FA49EAEC
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 20:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245457AbiA0TOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 14:14:46 -0500
Received: from mga04.intel.com ([192.55.52.120]:45611 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231180AbiA0TOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 14:14:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643310885; x=1674846885;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hXHbPl/MJFk2huxmrNsiIecBu4utNigIWu1OVC3WIzY=;
  b=KuJ1OLPA1Ub5QCvpw/B94m1yrp3HX704QDgSzZwcPw5SHUdUlaGQGDSh
   L4JP3N5KHGjhv/jINkcvUVJXzkRBhKZiHZSDuczhov77XDuHYZ7OzPHlj
   dkOiHIX52tKB1YW5FiiMk9z0k/rCJMWy9zhe39/UnH+YQsaS0Wiev3P17
   Gv4HdQmxMOIZVIajlKvxlym5Hp5MQq8/oo3s2sXfrf0SGzWgRhIm48KY5
   5lqT3mCrxXdB7mIX7j4Yo6dOJdHMXkwsTWIV+HHlJPLSygQh5qseLMxZr
   PyKm2t06M5CXoBLvLBZ3+Atxo6KI9lcM5uM6YUss7SYB9H4GGz4u2ZAVq
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="245785023"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="245785023"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 11:14:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="696771708"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga005.jf.intel.com with ESMTP; 27 Jan 2022 11:14:44 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 27 Jan 2022 11:14:43 -0800
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 27 Jan 2022 11:14:43 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 27 Jan 2022 11:14:43 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 27 Jan 2022 11:14:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVXwOXghpmkAolRoDJ2aO9spcekE2HTZL0s51o9bDWw0q7chVJY09pb5qA3umhFv8SW4iNL/6uptSiJZnk8SUu0SItxIFL5CrJUNLByzPDzzjNJmJsI7Q+vHn7TGgcuPQVmSCYJ2EFVK8BlkHVWGuxwpeHB3qU3JHgBsxBGbFZo5jw0qYWD1NoPxXpfkC6JRo3jtC90DCHcpEwnidOxz/mOrm0RFNGPfLRtgsiJsEa4ovr89GEn6FlfLswh2bxty1AnQlSYFJy4ZfW6BUlPz3fH/4X8MspotgdIGD66lF3yFeOGK/JhgyMBwSF0I2eeNcVFA8BuQcxFBYUaxP9s4aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mWyjQkx73/xUoVX92KbisdLcTsV10Wl6fSZwZueqcvc=;
 b=lBWEWyu0ROGZiLzLLa/BRmyEmNIlheM1i50O6/t+HdApCxPj/Ky0sZKiEpGlB5o3Mviz6ebXmjNb0Jj/E6UDnHIiDmlUA8uILOcbAScmBYMAZORDm9ei7Qqaye2he5I4aX9lWrLXazK/50Mhv1pgskrknQrtORNAMP7UrBJPRy8iOAC0U/MZOrU9wDNPqpLsLxKyHrODV0RoGYdJZr2fQT3bJajdNEEkgv5nP310ZQt6m9vQE7Cg0hQ9Kas/vMWq6EmvrdoHvAP3PSpSRgj43gGgG9cOWek2WIm3GnC7yaZxS5lq6c2yeVz8aTB0YLVCSK36GHpRVyMy2NAns7U1oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MW4PR11MB5776.namprd11.prod.outlook.com (2603:10b6:303:183::9)
 by DM5PR11MB1819.namprd11.prod.outlook.com (2603:10b6:3:10a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Thu, 27 Jan
 2022 19:14:42 +0000
Received: from MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::6cb5:fdfd:71be:ce6e]) by MW4PR11MB5776.namprd11.prod.outlook.com
 ([fe80::6cb5:fdfd:71be:ce6e%3]) with mapi id 15.20.4930.018; Thu, 27 Jan 2022
 19:14:42 +0000
From:   "Drewek, Wojciech" <wojciech.drewek@intel.com>
To:     Harald Welte <laforge@gnumonks.org>,
        Marcin Szycik <marcin.szycik@linux.intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "osmocom-net-gprs@lists.osmocom.org" 
        <osmocom-net-gprs@lists.osmocom.org>
Subject: RE: [RFC PATCH net-next v2 1/5] gtp: Allow to create GTP device
 without FDs
Thread-Topic: [RFC PATCH net-next v2 1/5] gtp: Allow to create GTP device
 without FDs
Thread-Index: AQHYE33qBCwJWjkzYUi+eLqs6q2WKKx28MgAgABK5EA=
Date:   Thu, 27 Jan 2022 19:14:41 +0000
Message-ID: <MW4PR11MB57769BF0F43B4A4AFD9BE12AFD219@MW4PR11MB5776.namprd11.prod.outlook.com>
References: <20220127125725.125915-1-marcin.szycik@linux.intel.com>
 <YfKu9NwF7/RKsMbb@nataraja>
In-Reply-To: <YfKu9NwF7/RKsMbb@nataraja>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d4f8fd7-fb90-4077-466c-08d9e1c9457f
x-ms-traffictypediagnostic: DM5PR11MB1819:EE_
x-microsoft-antispam-prvs: <DM5PR11MB18195800CFE291CFF9325A1CFD219@DM5PR11MB1819.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zcrdDDHR7WCKed+CwVRPCXVB3HOnFXiPcTN8QcqEeQtlUp8CdQ9hm1NAQeRFVtlmU27QLoHB42ZH/IgiuX4j5IIbrPD5K+XYx2WCgzhk2s/9mp/4YhEIoACWw2ammISJxGFWjCZ2wdMS2NzEzH010fd3nOde+26EB4tdAd6i9ahR5xi1Yfrrcv2S9bRb2cKzgGIhT3CXRfJU7gJq+1lxb34AQQTTIbLSACwQjwY1jGKPkR2BRSDa5Xc7lAI5naudIfrmBKqqC7Cf9Pe8AUbhTLxbgGSsSJgweIopq+PExDUS57waPvCMjYCF/q/3lds3pBcSlcwjmThrIRX9eRaPkvbvRNqi8gfKDJ38ziGFhvb6ijwRwUwomXJjL6BlFURIN99LnPD4JIazAiyIyRERrc2JMcZt8ytGG7WV33qWixbSjrSOiX09zqya1/sq1UNT+3PGak00P8GjNG9+ZyGQmiK61q+DzKUXW3QIGInPPqV2glp5L8vz4wKV6qfPbX31USqb58msb6z4OGGsmp3rBGlhXk5PNY48sU+DQMSpttUlnDVTqXpiPM4GMLQZhdaIgfomdcqEL5U3gosmneD1j1SzdfzZXnKZ6sEo4kPbc+q3TEIKOud0BpNm097MMekuZjBCrYduhUyjBbUkD4A1Cm8PSKa5BUicd5+Y6T0v285N3Mn/+lL1VttpqfrKyuWUFdjA12w+G+xJc1PJoIfW8yCe8B9ZFn63Y9wMYxEQNAQJCgcPbZdcp4r4m/8GXd9LVjfOFfzCuxyAbebDotjGSQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(316002)(6506007)(110136005)(2906002)(52536014)(186003)(53546011)(66556008)(76116006)(66446008)(38070700005)(55016003)(66476007)(4326008)(5660300002)(54906003)(508600001)(33656002)(66946007)(8936002)(86362001)(82960400001)(71200400001)(8676002)(966005)(38100700002)(26005)(122000001)(64756008)(7696005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PEwVwT3wN3054ZQT0m/WnANgoUkuGRT65xqFSsfTOa431qRxx06NIie7xD/N?=
 =?us-ascii?Q?0ZhTloZ5Bs9V827d/eUp8kdAACh7Cou1jl+aJsxqH2vLnx8gJrd5Z2vpLMXV?=
 =?us-ascii?Q?awJj+1rb/K9Nh0TtjGrS8da5CSvjFLv95qsp7rletkACfHa0NytMOZrdy8P6?=
 =?us-ascii?Q?PB2O+CQOmtirK/yghg8FjzL6UyU2wrxicL4U7N526kzd0VsvZuK2hHWCaIP1?=
 =?us-ascii?Q?ZYO0/jQ8osXBLBsGimyajCX0PYvGdODCYTBb/TaMDuaGWWEYFaklbzC+n8F1?=
 =?us-ascii?Q?+pPYUvRLQjdwaMu1np732Nr0NkFIhvV/IebOQaLJhAkmH8SPZLnirC6uy1ce?=
 =?us-ascii?Q?ea0oTVQatLL2QOu5KUHOsc07wdmtnWf14KVMaXdOUbjOSVwuBq1gAOj/NUVI?=
 =?us-ascii?Q?wcB4cJYtp5RoGSn/sBi3vhnmT/Wa9axmVVbqeSvzutFUUEL3ynEYLFQSpFRY?=
 =?us-ascii?Q?lhvrgQSxNonkXZhLDruJNK+T2fSNoI163j9yJPOcEfGXI4L7Bqi3nRRmXE1N?=
 =?us-ascii?Q?kiqvj3t00CqcJKUUswk1qFnuzkqHasqI0IHuUb7IiyfJ6iSxOf6XRmKOapgA?=
 =?us-ascii?Q?fM9/0FS3PrXAE6AfPhw/iGBxJbEL7hm6Lv+LyoIPZU77bof7Wssy4RqByWFX?=
 =?us-ascii?Q?RLbLvEvSRaPOhBG/JfQzZn2AQWWUoFf69EQbJaKpQF0GNrIIf+5C5Lw64v4O?=
 =?us-ascii?Q?ACDVGP9MzWFkiCtp+97YWnq/lob/42tebrfGq0tbzX/7im4/qmJ7iUWA5Dkx?=
 =?us-ascii?Q?iHiwrrnuqlBqa1UN6NjPj4nP+QXw33hiBuS0ivZo3TjInq/zXL8DlyU3MoQm?=
 =?us-ascii?Q?F7nfRpSzxeRm8zQLWHpafJ1f4Uyc+nRrsdi8RzNKFyd/bCiRf/FkoHiVuV0w?=
 =?us-ascii?Q?ALOirMszvANrj2hXhyqbcPlv0Jp9tsmf3tBKuyqWaCZsEFHfxrZZsglA4D5y?=
 =?us-ascii?Q?v9I+OTdxX2NzU8Q3gwdtXa9voAkIhPCpWXNzok4tbb+y2/+2dsdpQP0DjHn/?=
 =?us-ascii?Q?CtVlXaAHRrVYidKfeqDuzm+sf8ss4d2P1+4FPlA5/OPm5kUGFtaDW31x6em6?=
 =?us-ascii?Q?sKsT0IhiXUTJFO7wAVRbzRl4JkkumUP5p4Ka8uoN1hoWOaCjkexDbYTF4Sc4?=
 =?us-ascii?Q?92L1mPmgF3zWI7gJEiQqtn8teTdvFNUoCXmb9AQHsClt/s+h5T2uujFLKUUq?=
 =?us-ascii?Q?8LynRz/a+LPNVte/yHEyUQ6rCBApo/hwv39gFpJKMcZrv+PErL5PEmOm3ha9?=
 =?us-ascii?Q?5WVxXtUMyeIfW9kFIn0QORTPmC+ro7ebOedBzKbJHw5inRmKW5+rK2aUCZCV?=
 =?us-ascii?Q?zKwtcw/frHNxm/NJsdkLnQztyLm2XtdAUmKNIJ891Jvc3yf3CRy0VHYcdu/C?=
 =?us-ascii?Q?i+pr4pcWbWT54TyJxQOwU7jeXOQ5ZZ29mhk/iqLw7ij2B5IA51Ss9P/wa1DH?=
 =?us-ascii?Q?HKvj+6iO1qPXDXvSzxAoDWgkYoLPhXunFgbHIFtcg9En09hM5HeGNAsEFXvm?=
 =?us-ascii?Q?n4ClDiPUoHl9Xc3YvP1vKPhdeKocqf5sE3Khi8XvLPr94fV1zWtg3Hv9hc1c?=
 =?us-ascii?Q?/FB2PattqKkZmHXVHwrkpcHE418j2Xkx34r1R3AJjXHtXkSLmTviGYKfiXTW?=
 =?us-ascii?Q?BYLtlhFYaTR8Lw34l33+9Y7YxmyWUf5mCTO4uiNWzd5mNyKZpQL4pwaNr5c7?=
 =?us-ascii?Q?WbE4Mg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d4f8fd7-fb90-4077-466c-08d9e1c9457f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 19:14:41.9187
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gDWTxWzaZBViy4A4ZSMYRAM8lGFnZovZ540TsnhINCkeFSUklMqdvDzREYejFtCetOZDD1RpdxeMK84uTqk0nUm9vJFLM6L3E5hTtvducN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1819
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harald,

Thanks for the response,
I'll take a look on how GTP-U ECHO works and I'll try to implement it.

Regards,
Wojtek

> -----Original Message-----
> From: Harald Welte <laforge@gnumonks.org>
> Sent: czwartek, 27 stycznia 2022 15:41
> To: Marcin Szycik <marcin.szycik@linux.intel.com>
> Cc: netdev@vger.kernel.org; michal.swiatkowski@linux.intel.com; Drewek, W=
ojciech <wojciech.drewek@intel.com>;
> davem@davemloft.net; kuba@kernel.org; pablo@netfilter.org; osmocom-net-gp=
rs@lists.osmocom.org
> Subject: Re: [RFC PATCH net-next v2 1/5] gtp: Allow to create GTP device =
without FDs
>=20
> Hi Wojciech,
>=20
> thanks for your contribution, I think in general it is a good idea.
>=20
> However, I do not think this can be merged, as the resulting system would
> not be possible to use in a spec-compliant way.
>=20
> > Currently, when the user wants to create GTP device, he has to
> > provide file handles to the sockets created in userspace (IFLA_GTP_FD0,
> > IFLA_GTP_FD1). This behaviour is not ideal, considering the option of
> > adding support for GTP device creation through ip link. Ip link
> > application is not a good place to create such sockets.
>=20
> The GTP kernel module in its past and current form only handles G-PDU pac=
kets
> and not any other packets.  So it relies on always having a user space pr=
ocess
> [the one with the socket you want to make optional to handle other frames=
,
> such as GTP ECHO.
>=20
> So if you apply your patch, you will end up creating a GTP-U instance whi=
ch
> does not respond to echo requests, which is in violation of 3GPP specs an=
d
> which will create problems in production.
>=20
> So if you want to make this optional, you'd also have to implement GTP-U =
ECHO handling
> in the kernel, and require that in-kernel handling to be enabled when cre=
ating a GTP
> device without the socket file descriptors.
>=20
> Regards,
> 	Harald
>=20
> --
> - Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.o=
rg/
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> "Privacy in residential applications is a desirable marketing option."
>                                                   (ETSI EN 300 175-7 Ch. =
A6)
