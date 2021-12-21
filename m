Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC2F47C877
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 21:57:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235445AbhLUU5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 15:57:31 -0500
Received: from mga02.intel.com ([134.134.136.20]:43394 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235348AbhLUU5a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 15:57:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640120250; x=1671656250;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CJnJTk75IJ8BOL7B/oVb7OT3paqlkNvgVXQv+/GGeZs=;
  b=noLOeFNFOD9es46N19GKSkxhq1j0sXyiI8RYxnbr/0ZFFj0kwZPMJiuZ
   hFPMkehKme+475S1GMaZkt1QVrk6y72mOK3AMuOMVa2vsCPA4eHzi10op
   zEoWMprYVsa7rj/Ure0/yhz1zCRMj2TqTyPaY5bU05BPrnDeBxlByV6jI
   K7g9PTGh2U9SGHTsR3AM7ZyvtubGE0+PlTg9wrC2Nqg3idXybRGF+mxjW
   VVO9YBzlWMkTVYLCdkqtmlX2QnDXP85K2Y4thVaMNTS5gBeLme2pcV5DV
   z83n5han5eg8IDmJswSLvNaGytYYnvStnU/4cDFI6HkuaOLBFysAjd+HK
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="227785517"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="227785517"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 12:57:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="521859024"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga007.fm.intel.com with ESMTP; 21 Dec 2021 12:57:30 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 12:57:29 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 12:57:29 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 12:57:29 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 12:56:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbEU1FrXjZ8bI5Wfa/5c2NT9jP6XLi4ffCmKCw3tsZHkJqrIlgNmlV3BLTuLjhVQeTCFmDgqpW6JFWc9zhIy7UWUnCDRmQrSIhx10XTh90KCCCvnEsZ2gKq29T1BKI6uvP8KhWVgWAAeVdoSDGf4oHwteVCE+1UcfrJyLzfTpG/MljKGcpgJPOc5fQXhrHasGEqn+ubrfEpIc2NR9luI171cgsSheCr08Ptw+xZF8MtQvoRzpLQpOtQwZfJgDpp4pRHzk662ahE2gbKcEZFLj0++qXMQ6uUSwLJAfhILI27XoZVG1E+qWFVtpDvKB7VEjVorhb2QD8hSwJPChON1XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tGuocrl5Ln0eElWV5c5jmDRZaBlFYmmA5B9/XkNsyos=;
 b=kKHEbP9hzH0bjcltaGIi09C0j5yO410j7MWXmN5JsxICFwK/hfI4OVEVwdq5XjwqJdeXwAnJGWesWsWp+PbTO7FouCT7fZHp5NYyKXP0MgJi7ANqQ1eiHSUQ9qoMz1XZ/O8fy+t0hgcYrB1AiDjPT0ZRozW0dqte8CduzHwdam01Jk421eYzQLGkKmsqEsQLuJ6z4vEUjBYZxt2TGui66cXxnTxMXQN4moWmSlqtPus9jKZ34XGIUgv0FkWTDWWUn7MCywo2CaJqRP7EphbGZjDgpsxzWjWX2ycbHahkZYLUhF0xdq4OgMhmZp/Rg60M2rZ3YHE5zfnigUnSWb4J5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:95::10)
 by CO1PR11MB4804.namprd11.prod.outlook.com (2603:10b6:303:6f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 20:56:42 +0000
Received: from CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b]) by CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b%6]) with mapi id 15.20.4801.022; Tue, 21 Dec 2021
 20:56:42 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Thread-Topic: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Thread-Index: AQHX9jcKOP1y1O92CEC3pIeygh1pI6w8tNAAgACRSSA=
Date:   Tue, 21 Dec 2021 20:56:42 +0000
Message-ID: <CO1PR11MB51705AE8B072576F31FEC18CD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-2-mike.ximing.chen@intel.com>
 <YcGkILZxGLEUVVgU@lunn.ch>
In-Reply-To: <YcGkILZxGLEUVVgU@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03120129-9d77-4e2b-967a-08d9c4c46457
x-ms-traffictypediagnostic: CO1PR11MB4804:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <CO1PR11MB48049503E84B9821180217C2D97C9@CO1PR11MB4804.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lri/4GpUEIPFFbxyh0a0fH/nhqBkUukkysY9KuYDoSFa/e8L3ihCNjz3L2TLI+9Aq+n507X7BVS8KbntPO4NbknjjBhToXIzwsP7XOGUa9oA+DhRhBzZNbuyV/spdHRAhxg5FM5o3Ib4cLERO8P2I/6JIXs0RGUXBmunvM316SMU4Xb4h9ldmg3C48beJuME9hGoP16uvZwwx44QlRGZzDsCqKxt1l+PeF+dMURfYSS14tk12u7DX671HS8QY34FDBNso4HOhdw6z4Wu26U1T/SKq3gk5rhFT9knmHYpwdfaGYl3oOz+71jG/d11icEaAKbwhG4cgTRS2hFPB+WTpkQrPhm70BP5KSaqe12X/qtoTxppcjPzfGas/uT4Za7hfd+sSi/7yiW+fikT6/RJ+T7rHqsBbhdrCYlMNcrEluzEGMNG8MgAoRivvZpZapKv1uFLeE/huelUwuluHurVHqNhq0868FaOypUV3IcWLyXlxn1WWaq+kU42qy/DNntJnI9D7pyAO46Znzj9b8422m5Jg29ih/dgrOtBqr803b0Acbf9adbONplkX1yR3j3Gm3dN16abZBnlJj9StUHy7462oiMuJwKh/YmYbzGPauJWOsF6aO9DkUufbVfciwgbT7xEkPE3c90TdxhWTlBQgbzKZ5YuWS1Qnj7OylmHP0YvySZ41gOUeHV4nG/CHuYQk+2KlI7LCygvLrtARvGaIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(33656002)(6506007)(83380400001)(8676002)(71200400001)(9686003)(54906003)(38100700002)(122000001)(508600001)(38070700005)(86362001)(186003)(76116006)(4326008)(2906002)(6916009)(53546011)(66946007)(66556008)(64756008)(55016003)(66476007)(52536014)(66446008)(5660300002)(82960400001)(8936002)(26005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tOdBbiGzPPNC6SDcHaAYVp1oUKZDahwuz5RMjF+P8nrNjpIazKx7HtBggfyh?=
 =?us-ascii?Q?BOFRzBznlSGeQ1blUADV1OTmG7/lHgyKCy+A8gJeoBUDxTJOZyvr3DDHkjW4?=
 =?us-ascii?Q?4LA0Qvu3IwKHE70AJDPSeJZpp6YVtzsAX+1LTDa0InxvrFc8YfkqhHhL3a0i?=
 =?us-ascii?Q?oKX9QcckrVQaV3BjeJurMUbfDY2fziAMvZQsVYW535U8rfUk0u0nHDZvjWJe?=
 =?us-ascii?Q?nDvskxBHZ78lIONBpCc19zK1dYrBj8N/icpaJXuGyVI0dFvBTtlxWiMqSXal?=
 =?us-ascii?Q?XM75QUuY9tKxGzvvNiDc7KBof9f6TKbrk2zctYDvk7PsEnkzuNArxNz/Ekci?=
 =?us-ascii?Q?1XDvOhvqF/kd4t9qZnKjcjJxMtNt4yH5rkqHHd8+hjXGcXO+rESALr4cGu/k?=
 =?us-ascii?Q?hj1pLz7HA/+YuGLPLtMQ9mB9qxdItMNCtyWauMym0XoinjQsJB4yAynjsqH7?=
 =?us-ascii?Q?DKIEpnZp0yMui1Z7iC9Q93CtA/Qo7eOllf9tL4IrWyKf0dFwv0LjyPdomi91?=
 =?us-ascii?Q?4pDcs6m93EiOw4KQQ2/1QbR0EcNvUaPHfmV1rRq8CEO8WXrtv27T91iJg+bO?=
 =?us-ascii?Q?8Q7sumJovGX+Of2l7HP6dAniS0i909GuMEk52N+gP0dtZycm/a+JSRnRjRW8?=
 =?us-ascii?Q?jMlUkrlS2+8f+izhIYkrXnDjHeBQp6qBr6rF7cEFVOiutjQpAgzZ1wXfpM1K?=
 =?us-ascii?Q?gCksjdk9VynyO4YiC6fnUEzLBwqeygwZJ3ofT0cHNJKDCaLKxmPo05hVJ+mK?=
 =?us-ascii?Q?3+JOwOS7Ov7VbiXBwBnUIvL0DyDiZ3eZAinof3l7hHud9HSFaJVcRPJHpUBz?=
 =?us-ascii?Q?ILB8sJM+vlov3I3/UOJTVF6bVvui+HL0Vgnz3LaK2YyIuePEwqg7MO47B7YS?=
 =?us-ascii?Q?7iHDpXwBe8jPsGHAi6eNMjuBbpz3piduk53ZXvfkRzt9DAMgmN+CU0DV68wu?=
 =?us-ascii?Q?yePsg+99ZlBpMFDaXShQJ6GO5wmhJMOEl8Xd5PDdX/oN9/FpYwhGMQIV8bm2?=
 =?us-ascii?Q?tIOmaZ//7bh3joco2M3D0gpF60vvrBlWi5ij9ToggO3wPP8+4Rd0RG6tn3ek?=
 =?us-ascii?Q?0QGL9kPQIqdbV14LbxQK54qxjSNjvDio44KVcy4GfJbDROq0KNPfshZesqcJ?=
 =?us-ascii?Q?Tx5QzXUJgMU9H+wS/iV8Wn+EaGvOSqy+K9/25KUrkN3s+ciylL7U1JBbuSvL?=
 =?us-ascii?Q?Wl4cduJPIEmmINrhHu41r0P2qeFhK4Uh9h2u+0y9JHI5W7IVQXr0ctiByNM7?=
 =?us-ascii?Q?DIt2hIM1W+UaQX0P5YMVCoxE2UxpETq2TbEKR/kj40Y4KuNfvujhfwCV+NXq?=
 =?us-ascii?Q?wQ6nlb0ibxLtYyIG66FHkGvM56at30t2yoQIt8Anj+N2E2I2uORtkQ6a5sYy?=
 =?us-ascii?Q?gB2ytkj25TBqeKtDQoBeyd3yeYcS113+0DtTb7mE9feuxsF6elkkygPXWbN7?=
 =?us-ascii?Q?2CiivaZl5YjUJF8/CW3bNjhtahFccBR+6tDOx0u06S8lztdJPQBhgiGjmZ1N?=
 =?us-ascii?Q?z319DLr4a/vvHZaZO2wNhBXPchhMsPiKyiOQ27oA0uEKTF+7y6wO1jx03zgn?=
 =?us-ascii?Q?phbMBCJ8lHLtXKar9bdxdNnWlhlHA64Rmrkup8GrIYrAvrAqchn+cRhNHFR6?=
 =?us-ascii?Q?NiEGvBH+qjPlJRnCkVh1A4/E8CPbVovCY7AT3D/dbBzUDPLrYBm+Qq5qB48l?=
 =?us-ascii?Q?/hS9mg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03120129-9d77-4e2b-967a-08d9c4c46457
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 20:56:42.4487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FhS9XJrnXfFjDO4ZApj/yqWdBemg+jpa1PrgjWEy31YADhc1qkM1Q/Fi9PniDSM7McfQv7xS2AUON0FIgnpnAPMYtC6rh8chipfriblt9zY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4804
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, December 21, 2021 4:54 AM
> To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; gregkh@linuxfoundation.o=
rg; Williams, Dan J
> <dan.j.williams@intel.com>; pierre-louis.bossart@linux.intel.com; netdev@=
vger.kernel.org;
> davem@davemloft.net; kuba@kernel.org
> Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
>=20
> > +The following diagram shows a typical packet processing pipeline with =
the Intel DLB.
> > +
> > +                              WC1              WC4
> > + +-----+   +----+   +---+  /      \  +---+  /      \  +---+   +----+  =
 +-----+
> > + |NIC  |   |Rx  |   |DLB| /        \ |DLB| /        \ |DLB|   |Tx  |  =
 |NIC  |
> > + |Ports|---|Core|---|   |-----WC2----|   |-----WC5----|   |---|Core|--=
-|Ports|
> > + +-----+   -----+   +---+ \        / +---+ \        / +---+   +----+  =
 ------+
> > +                           \      /         \      /
> > +                              WC3              WC6
>=20
> This is the only mention of NIC here. Does the application interface to t=
he network stack in the usual way
> to receive packets from the TCP/IP stack up into user space and then copy=
 it back down into the MMIO
> block for it to enter the DLB for the first time? And at the end of the p=
ath, does the application copy it
> from the MMIO into a standard socket for TCP/IP processing to be send out=
 the NIC?
>=20
For load balancing and distribution purposes, we do not handle packets dire=
ctly in DLB. Instead, we only
send QEs (queue events) to MMIO for DLB to process. In an network applicati=
on, QEs (64 bytes each) can
contain pointers to the actual packets. The worker cores can use these poin=
ters to process packets and
forward them to the next stage. At the end of the path, the last work core =
can send the packets out to NIC.
=20
> Do you even needs NICs here? Could the data be coming of a video camera a=
nd you are distributing image
> processing over a number of cores?
No, the diagram is just an example for packet processing applications. The =
data can come from other sources
such video cameras. The DLB can schedule up to 100 million packets/events p=
er seconds. The frame rate from
a single camera is normally much, much lower than that.

>=20
> 	 Andrew
