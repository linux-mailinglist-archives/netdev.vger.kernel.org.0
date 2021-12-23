Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B7547DE88
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 06:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbhLWFPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 00:15:45 -0500
Received: from mga05.intel.com ([192.55.52.43]:65003 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230035AbhLWFPo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Dec 2021 00:15:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640236544; x=1671772544;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9kVRc6bfb0+KBwojcUII5cWmQ3BwvMWUBbH8fIQGYBw=;
  b=is2wK7jHo+f5U4o+9qROkw3m1mFJh0neSm5x7Z7I5Yx6bkOzRT5TYuvy
   Kjju85BATlN7n+rsYGIFBA9uFcxgj+cPpMeRrUmy2pT8G9+X3B9UNRuMV
   iVC4vc/aOZbcOYk39B4UjscsA79bGHUEgBT5ld5c6pOyM6qJ/4IZF5d2t
   SZE4GQTgnY5WMJWc0WWyBtC80PedEZkbNX+kbHhDMgWorKL5VDFK2YWY3
   5j2Ct9JcfyCb6OjWp2GwAH+qXsRRdqnklFEmwIrXCkLO59k0bM0QCxZ3+
   OZWjNcfYOmBJPDPl/xi1c/VAcz9989FBJ+8p8xjsDyHzznE/uGMmSjh8a
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10206"; a="327066517"
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="327066517"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 21:15:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,228,1635231600"; 
   d="scan'208";a="521954664"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 22 Dec 2021 21:15:37 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 21:15:37 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 21:15:37 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 22 Dec 2021 21:15:37 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 22 Dec 2021 21:15:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=niTXlFTG+wSJxb8smfVEucmypovfGMXdbumcycvJYFGN3ToFOqWwqoU7BjU3tVXwuCWG9Q0P60/4sjpeigSOXSzAyQaY0GBR3f0aLbWgNZe2/8+2I4JB7x1BOqlRld+pc23X3aIw8sYTOk4GD80vDZcZ5ULcWVW51q53D9ue822KAsJ1wWGfz9em+7D6pcVvrqz06/n1lxAN5U1a7ncQpgxtPNgacs6HsPS9eRbaPDR9LHGABjOOYyVUfexjm/Hn8SUyCFmOaY74V7S1oKOZlLco1NeF8lYnWh+PEqvwkxtyg5CCxeoYkL9ghPLhstwJaVZwTRPixQl8xCkzsuu2ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kVRc6bfb0+KBwojcUII5cWmQ3BwvMWUBbH8fIQGYBw=;
 b=LJ00fLGEurHAEVoorlRMmsBtvUhs5C6Mwqg/RttYiWWGZISyfEcVFPS9mTSSKBdo6c87+tkbAK9S3Mz0jSvC0nCT0CZVlx5YENkdxSj9vY9gkMmubYOxrCVVeea+wexQHyqF2x0Gaysezvm8Dvr/Rna2WXKUyGtgUoKY/swXwbyvJ1/8qmqoPuowl6LAKa6d50qRcHYY1abT2M2FtvzjKD406XZ8Du2f6TwvpUNAorLiy2nO3uPWtnUVCtKpeNkBerpcon3yuymumUAlyzWLF2RNE+p/XD+BS+bjqqAqBnv7x/Wn0UybFFywPu/RurJJ/4GHAD+OXaEO9DR3+hkn7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:95::10)
 by MWHPR1101MB2240.namprd11.prod.outlook.com (2603:10b6:301:52::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 05:15:35 +0000
Received: from CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b]) by CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b%7]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 05:15:35 +0000
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
Thread-Index: AQHX9jcKOP1y1O92CEC3pIeygh1pI6w8tNAAgACRSSCAADPkgIAABxaggAGHswCAAHiSsA==
Date:   Thu, 23 Dec 2021 05:15:34 +0000
Message-ID: <CO1PR11MB5170B7667FD1C091E1946CEDD97E9@CO1PR11MB5170.namprd11.prod.outlook.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-2-mike.ximing.chen@intel.com>
 <YcGkILZxGLEUVVgU@lunn.ch>
 <CO1PR11MB51705AE8B072576F31FEC18CD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
 <YcJJh9e2QCJOoEB/@lunn.ch>
 <CO1PR11MB5170C1925DFB4BFE4B7819F5D97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
 <YcOYDi1s5x5gU/5w@lunn.ch>
In-Reply-To: <YcOYDi1s5x5gU/5w@lunn.ch>
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
x-ms-office365-filtering-correlation-id: d3cd59d5-5fb9-40af-65ff-08d9c5d33fef
x-ms-traffictypediagnostic: MWHPR1101MB2240:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MWHPR1101MB224026476C8B162F9333D307D97E9@MWHPR1101MB2240.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iADDWGYfI+A30HAjulS/XeJYs9XbS8u4QNU574hohBhCgcK1MyVfIZ01yxDKEQ4onY1yIjn3+XmQn6QIHiZEDL7Bev6t+6Dm4zXO68fdDiLSZIvbVgROuIh1oWQaGjxdQwNJKfzx/S8ToZwUHD+zB3v3c9237AOnjkWa7ORqBUJnCFc5xXU5crxxB/r5r/ZK4NpcL4VDPzQBNpfevX7/2ZyXutdMK9rjkp966fa8QKuHjDJgRorWCc02ySXY9fAUWDMI1CTcNY7IcgZhaSVAiqk/I0Vmnqy+Ff+pONsPBuUFpc+ebA9syRAdWk1IBpYl3LFe/KCt5Y5SJgG3Nrbd6yNhOpveiX2qtUpIRpsLI3rYXblwfHK19QmEL3VO47WqvQ8PGchjnbggF05+GsealCysac5xJdCOdol5r1wjLPkMq/YqrCiRZsW/VNWJpCWgfO1iS06+KuCkO+zhxHj+slMevr83qNdNGnP/cAIOd2Khjk+NcqH4Fmfm0FzG1K6cSntGLSDbAzIp+i/Jjdk0x+5zIL+TKYVxE2FGI0KQh8N/qjJnuDklS24IyDX+p6Dkd3sTulEU5MYJyYtZt5iUfHb7TGwfkTtgaX/EN7UVWM9bT1HlnyAuRlmq3+4/3z0O+f9v2yD1lOSy+dmzHOKViiCmNSMEJkjWE0c/xrTJRbTJm1XRN9fckFGX+NdVyC/TyER2mxIxY8twFVSnlpaoMA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(52536014)(122000001)(4326008)(82960400001)(9686003)(6916009)(8676002)(33656002)(26005)(66446008)(64756008)(66476007)(66556008)(66946007)(55016003)(71200400001)(76116006)(8936002)(186003)(7696005)(38100700002)(316002)(38070700005)(508600001)(53546011)(2906002)(5660300002)(6506007)(54906003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?rnzr/9uoE1u3F9PnwOt+KS50fcIpgIUAKj0ytWPOfWrzW1F+wJ+u1IS2axQe?=
 =?us-ascii?Q?jGWQo4fSyhsFOUb0iuzmJIHlp5nS/kBc3hdoy9SqxpNC/pZsSucSdkO/fvar?=
 =?us-ascii?Q?ECnSXta93R/bzg+Ndp4VwwZ42lZ4/z/4JlB1rPdYrjKJ5EKv+SETYGmN8z3w?=
 =?us-ascii?Q?C0c41mXjHp3k5g2cnRc43Sgk833S0wqEljdELhLsKZEjm6q4cEQF1x8w2Z6o?=
 =?us-ascii?Q?0Av8kmLOwjICOh9b846v3uM9N8E+XgOAnXmwqXZVlL9ExVxzHgsxwclq3Lq+?=
 =?us-ascii?Q?sKQCE0kl7lXrcYbv3zzemF/YlZNPEs1Mv+WPeIWIOFlEOp0g+XBrfyrtiTC4?=
 =?us-ascii?Q?/PWJpmoEAeTBl9BlPMATOJsgEAGP5F7QESymOcmK51OUrfxRDsUe/KyyB3nF?=
 =?us-ascii?Q?bZw0vSiSQcxcVD1YpMqhh6JGz3sgJ6IZ3M+0RtRlMtHkmEeKu3dTNfv/ywDV?=
 =?us-ascii?Q?FNbD51pXXWQJUqHC0nMkc2x3Xdlu9EfmtdWqXoMfXo5bIxZZUHURg1DxjEl2?=
 =?us-ascii?Q?KHc06+z3428YHUGM5B+tdI4uXJQP8Vrc4eMBXvireSkdsaV7e1+2337rsoii?=
 =?us-ascii?Q?sUodC3mnIyKWBbHnkYQponHomEMET0JWbDHWp4FAqT+NksGidpTh93YkGmF/?=
 =?us-ascii?Q?hmeBb7YQveva2s9Y9LCWNuPb0O0JKtLvfLZplX1ArQYWQUUnqHdFq7eu3kUs?=
 =?us-ascii?Q?Q67+xmGnGVBTnqPiC5VdB2f1orxMJJ3vDYgADVxsZFG3oQK2+lIx7Zc24og/?=
 =?us-ascii?Q?VTOxJBj30nCDH8IRiyufDevU9DyrbAiOUaivlzuGla9ST44BNRK224QLxJU8?=
 =?us-ascii?Q?hm33qIZ+1hlxNFrZsMn/B8rV/K1qcqQ1nDeTx5eC+zxPnpD4YfO6TZgbUlxk?=
 =?us-ascii?Q?h0nB7lhRQqABbSMwCcefiH9YMq4BpL+XsHtDbhhVECTrrGi/0QzWxQ3TFc1K?=
 =?us-ascii?Q?7cPheK9+ZiNQqRKraWVxQdtim+FV1Seuh5mdbZnG/BZXSlPIh237o3qiDN5F?=
 =?us-ascii?Q?Dblk/l2l0Tt3A9HZxsUWZZFfbc46l56NCw90OfbBsFlXpre0OcZtUJCeCmuJ?=
 =?us-ascii?Q?1Eix3TeT5sS1TjG9Pe/Fx1BKYzs2VuCZv7OXWnMk9K2UxkeQBAri1SQxmhLW?=
 =?us-ascii?Q?Y6xG0C/2YVD4v27crEWm7fCvJiivJ6e3ydNzCv86fTgPMxsu85yX1XrP63FZ?=
 =?us-ascii?Q?ULUO14BV4lNHxmRPwPb5A5njY7pDTyyXLw45ww/DulJ/jMciWDWWWA1FNayI?=
 =?us-ascii?Q?9roMbXV5CTPKz7ShuOLHa1vHO27qrnpfO+r8amkiwVtsi+CYYCWtPK/lFzcx?=
 =?us-ascii?Q?6gbzx7jydIcJnlslBoRwuwsQNNvPJptiWlq6xeB6m7PcK2CVcVW/on++Le9m?=
 =?us-ascii?Q?t84EteOKuhSrexqtgyGbi6BdUatFIBLUYSfmmAhop86dhk4YQt8n9CFuEsqZ?=
 =?us-ascii?Q?z7NFtuIL5psBgNL3QP0qZl1RKfCaE1hG0bvvhwLzP4RCFp8dkzdUpuX38GpD?=
 =?us-ascii?Q?VOcBKOVw3VMHsGt+ZKGxvh1+RHKPJHib7aMb8dwHjQIyDEUkvpv3UVQk8hHY?=
 =?us-ascii?Q?kfUsDaCvK0h5YeDex5z3BLCjFNIuMMLIP4yRJBoBEzDgrWwSiRNkYB4kfoqq?=
 =?us-ascii?Q?ulV93sNu7h/+QotDGZuFermXfnxxAd7SQZcWg1MWQJg1MmHcjeWPZeOBru7A?=
 =?us-ascii?Q?F6BXBg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3cd59d5-5fb9-40af-65ff-08d9c5d33fef
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2021 05:15:34.9886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ks122s1cIdO4GWrd0LWtdVd1qbssECyKT8fbZo9BsP6wADZJ50Y3XNom4elLbbz3TUiNkLs6pNAMYqSSf0/tQZCEHs/YWwCuPY20CzzZRxU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2240
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, December 22, 2021 4:27 PM
> To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; gregkh@linuxfoundation.o=
rg; Williams, Dan J
> <dan.j.williams@intel.com>; pierre-louis.bossart@linux.intel.com; netdev@=
vger.kernel.org;
> davem@davemloft.net; kuba@kernel.org
> Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
>=20
> > > pointing to skbufs? How are the lifetimes of skbufs managed? How do
> > > you get skbufs out of the NIC? Are you using XDP?
> >
> > This is not a network accelerator in the sense that it does not have
> > direct access to the network sockets/ports. We do not use XDP.
>=20
> So not using XDP is a problem. I looked at previous versions of this patc=
h, and it is all DPDK. But DPDK is
> not in mainline, XDP is. In order for this to be merged into mainline you=
 need a mainline user of it.
>=20
> Maybe you should abandon mainline, and just get this driver merged into t=
he DPDK fork of Linux?
>=20
Hi Andrew,

I am not sure why not using XDP is a problem. As mentioned earlier, the
DLB driver is not a part of network stack. =20

DPDK is one of applications that can make a good use of DLB, but is not the
only one. We have applications that access DLB directly via the kernel driv=
er API
without using DPDK. Even in a DPDK application, the only part that involves
DLB is the eventdev poll mod driver module, in which we can replace a
traditional software base queue manager with DLB. The network access and
receiving/transmitting data from/to NIC is, on the other hand, handled by
the ethdev in DPDK. The eventdev (and DLB) distributes packet processing
over multiple worker cores.

Thanks
Mike
