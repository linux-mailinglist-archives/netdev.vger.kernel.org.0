Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9A947C977
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234959AbhLUXFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:05:54 -0500
Received: from mga18.intel.com ([134.134.136.126]:23598 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234752AbhLUXFx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 18:05:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640127953; x=1671663953;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t2JBIIcxnFSJoQGa/ggKeSXRFBZ4JkKTw37IWmtxmTs=;
  b=U8zT0PWoBX23zDoVNFmC15uJyrLLa623gbm4ZhRr6XI8LGsEH2z2Pj5P
   RadSCzIIbssz/QPMFpPcNSJsoSD7vIXOElHDiZWCc4pczDv6JeKZpVUBo
   O/+Zqun0XRnspuX7iGVgxgxZT5I5HNvwxb+4i/7uBIJ46TkF8PYjRRDp/
   nblijJK3ArX5AsyFojQ/swv0ymKLFir/bcRcPklGy80JlGB3Ix6xeu1eW
   EUzwp1T4ISrn8IyVnD+f+cRd0DgzyUaQe/zKvYDm384UJAMzL/hobNt8S
   K1xIqoOOtxhwUBq6XTNNVW/UQY4O91cxPeM9gdR6gnqtZ8rSAbQSQJdJx
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="227357642"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="227357642"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 15:05:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="521445797"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 21 Dec 2021 15:05:43 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 15:05:43 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 15:05:42 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 15:05:42 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 15:05:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNXypQDmB70Wa6dJkRq76G46fULT5fZW2O1BNKUDAYLJYkaTA1iTLkmoduIjYzFqYUWayYZXvuyPLTdOZlkmhV9saT20cePBJDTLdNUxXFvoXB0aRyHPzkWHQjN2SX4Roxk+MSHTJyEjuM/Dm2MryGtoqXA+yiZvmib5Eh784DovX0UH3XEATGOyJULzpIvWpRo5PT3ECmmHsXTqEpoDno5wM363UL3nVToY4CnOEbMoQpSrqthW9c++V7UvrxQk3bXTofo0eiAGaefx/LA2jYXHWgk4lpBtqulVIF4rE7LBjKbi6oDs3nUe4Ov4zBAGhfm2azBNrSD5v49pcj+TrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s37vW40wURzRjY3SOFAH4EqhqHNlwHrHJ61L2m8N9Ss=;
 b=hSudxnCZ3SXaSJ1qQXhMS07dAWyP4/L2mJ2gMjlDL4XywAcipbVCdmUt1bJXCjUgRH1N4vudtIPhXPCizmVeUtS12hF5s+Kx5LeaNpas4t7/35cM6d0gKn1Cr8lThNW2olCVWMHIPVsw8nTIm15Wvo4Zf7jGcxxPyEa6rketqloaLsXXO8nwh6vIQvekkuhq44eArHuK17FYY1JKr0ijD6PIYxQNJ569fmpewH6MOP3Yh7axuharB1gFMNK5bdvX3dQ1Z9ZqCSM1fFrqQDokhwzfYl03emWnoEkl/n+DDKSPVszYIF6X5OxB7j9nvBwKRe8M/o66nqyBkUX1lrAm/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:95::10)
 by MWHPR11MB1376.namprd11.prod.outlook.com (2603:10b6:300:1d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 23:05:41 +0000
Received: from CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b]) by CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b%6]) with mapi id 15.20.4801.022; Tue, 21 Dec 2021
 23:05:41 +0000
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
Thread-Index: AQHX9jcKOP1y1O92CEC3pIeygh1pI6w8tNAAgACRSSCAADPkgIAABxag
Date:   Tue, 21 Dec 2021 23:05:41 +0000
Message-ID: <CO1PR11MB5170C1925DFB4BFE4B7819F5D97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-2-mike.ximing.chen@intel.com>
 <YcGkILZxGLEUVVgU@lunn.ch>
 <CO1PR11MB51705AE8B072576F31FEC18CD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
 <YcJJh9e2QCJOoEB/@lunn.ch>
In-Reply-To: <YcJJh9e2QCJOoEB/@lunn.ch>
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
x-ms-office365-filtering-correlation-id: 0165319e-c816-441a-c5d8-08d9c4d668f4
x-ms-traffictypediagnostic: MWHPR11MB1376:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MWHPR11MB137640C7519973DE06B5F9BAD97C9@MWHPR11MB1376.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YGzZxoLCgszE0uG4Lx5golksh7DTbVOinn6qIDSQzkq88w0+dmP3sBaxlUiZOc4ywdU5KiFd1OVOEuSWzUseNvx7CbIavA3eSOx/T5N5OcUDO81IMAPCj3cMoY+t2fxhavUrSgMENfsEPAOhI+rMlKe+eihOG5NYvtmUg8SBPBk0/z/2gM1QVIG9U+20fOHJOBhzp6TCRl5x03AuOYd8FzN6c17f0U0tK11TF/iUQJe2kSude/2+zOEgvq1W2ysLxr6iEdNb9G6fqd3vKFrxLz6An7EvRQ+wJK4JYDgifglVOoHoWQjBt7LgIdmjWNwxXMEttlG/hpwU8VzBSBnmxWpB5tUcKmldkRHvl6BVS+IG4khSk+AE1b42lNMi7Jtg56TUKdY7t6S4pwsX4EHH8CTHpy9f85FckaZPaOQf15TufyKcpbPIXWjlJUlue92Wh5Gl8MURsQciTTpBYrw23MRGFVnDg7C95N7z7xlhMalT1wsvgPpr7gesVkfBFlGidA0zeRP9p8wLcEMVB8j4c4DBb7mHvgYhhxS8Reik8lD1D0a/bj3BB04hnFmqWGRfSRddC5xhm0hz+8V+WUgYgLU21+XNTg6LF7h/ahoJJfcPP3OjMDXcg6wKyai7UUzfu93j/EWZ9hW3d6CQVft4d9t4Jitwk/Ok9ywAdqASpCU737U2s5qkpG9SK8pSBrq13TVmZYXdbftsc5evOBMEhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(7696005)(53546011)(52536014)(6916009)(508600001)(66556008)(122000001)(5660300002)(38100700002)(26005)(82960400001)(55016003)(66476007)(6506007)(9686003)(38070700005)(2906002)(66946007)(54906003)(71200400001)(83380400001)(186003)(4326008)(76116006)(64756008)(316002)(33656002)(8936002)(86362001)(8676002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OJ3oVfJIj2dHCxb+h3Gj+cuqctz71580dYWLquPHpEHGHlaCMe6z+Nx7hPTQ?=
 =?us-ascii?Q?leriTpVWQKZjUkLug2M0nppBSYu+UpAWt7pekloMtk99LFAG5Jsax01riyb/?=
 =?us-ascii?Q?blbfSxr5+B0iP7hHU03f4UoLp9UIJpCLg/RYpP7OPBLht5lbWeXz3Ul01lvs?=
 =?us-ascii?Q?+ySunZTCGK3S0mU/8o8BmMcBOKTO/M2QfiMsl1YqcMdfmW0lDU6g8g3SqNXb?=
 =?us-ascii?Q?SyZx5D/jEMojI011hTDWODvTkprgsf0bTHnH3Gfd9wu/82BNjKoSSHOFPsZW?=
 =?us-ascii?Q?lGu9uHynCPoqi7jU431nEu0KqmqM9riJhLou7c+rXGZHOc93ToWNkg/bhysU?=
 =?us-ascii?Q?8DG7wNB1OWZiXKshzec+3ybjPWnGhvKNuY+1qRSmk4Bg46qsMzNTNNVYkFrp?=
 =?us-ascii?Q?h/yNXoJLPvsV01t/5DkEaf2jMz1c/0lc3jWRkMFUE6nTEtC5/x3UeKlIhCgj?=
 =?us-ascii?Q?OvUH2mIl4BEZbQahgarg46HyCFTqrIGsz8a/XQWOjIuyFdZws7wjospAUqGv?=
 =?us-ascii?Q?LUufhix9B4ASLqU7XThAwO/x/QJD4qNuaOaNOx+/HDbGUj9i2glVJr/7OHvu?=
 =?us-ascii?Q?HJogudxadJ5jGbEzNxOV5nP5aGlms4kRwBkVd4v9UpJpSTHMAVf7DRneCq1+?=
 =?us-ascii?Q?NKziTw3NZ9a9eSh60A3i6ZWLR6q4Y8UZl5aX9RvjKQbuAdBPZBatw2qmM1Ol?=
 =?us-ascii?Q?srx4Qxr3UymOxz8CLETGsWq0CoDr8hRsYh+Mkl0CTbnTOsta9YHrBQTFxadL?=
 =?us-ascii?Q?7ZU7o4KcAwarS0qcRm1CzBvj03CvEvALgBAscEQnR+vCmlURWcgR48CPqQwV?=
 =?us-ascii?Q?ZjQbs7RaZeVM8hyM9ZVScbGG5gdmXfIKuo29+9QFuWug+OU6nL7tw+dg1vJc?=
 =?us-ascii?Q?lC73Ph0OpEmDUzTUbdVzAb4VDkv4d5lB8tZBi/YzDAM8YJZjbJp5OsqTJ04Q?=
 =?us-ascii?Q?zHmH020eilTZ35UmP+4vpUEO2GeldIt8JpMaOpwqEqcT9kbzbGACRbRKBZ+s?=
 =?us-ascii?Q?I09w9V8Xr5lM46lc/Pou8sbE+hgfvZh4E7NQ4kxeTHi+kGJGnkGx5+6kJuZ0?=
 =?us-ascii?Q?pYODpzgvmB/ZNP1K1cXWI/K2+fy/egrmf+MfdZ9rQg4qbrKHjgQQv1woJNuC?=
 =?us-ascii?Q?JYkSvJ7bsomNzudsw4enO7SYwqVXRVB8m0kZlMRx0t+knflYQ3U3/oMNxuXP?=
 =?us-ascii?Q?KcYWQuPkBTqcyfu43vam7s1K6k5od/+D54JFGmorui8Epn7pRHOqu+pvqXWA?=
 =?us-ascii?Q?hwLNb6Ymeb8GxjFXdxlIxTbAzywLsdk6zBifYEH4Mloek2D1t2spUvdc7gus?=
 =?us-ascii?Q?iJb96ZTn+JSFs3Su8aZYjBH8psYDUiP365ih7iOghKJAY6pGl1kNHbLPOXHo?=
 =?us-ascii?Q?JQL0cPTyJ50E/ph6/EzjgoRp2DDJt5dBNCzRspa0X8UrCytjEeNiIU8LCllo?=
 =?us-ascii?Q?srwWP5WV1561kVtVH5EVmAqfOjLRsIN+no01b/9J4n6kF82gjohIDjuIZ9Vg?=
 =?us-ascii?Q?HYMoGc407mbz7G9Zulzqzyp/lBLydR8L0Fjd4bm6Wi2wCiRH3paRaEs73CB3?=
 =?us-ascii?Q?KkiqtGtbHPFnKqMmSozL+slpNt7UbRTNp8SujdtBnyf8lXUte6TlAj+Oo5UJ?=
 =?us-ascii?Q?YY2LZSZe7XZIa+OLB6cqswObFOTWB3PX2sQmxAldhOMPwO6FsxxauD3GBxRg?=
 =?us-ascii?Q?YNZVbg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0165319e-c816-441a-c5d8-08d9c4d668f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 23:05:41.1139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4PPfZqsjtbDrV90nQXP4ZJAZhB5Zll+zno6wctkJsMChNexkgMM0Fdwk4c2fXtYSahpzmzl6H4Lx4l2gDiUGGmNVsvrjpqWf/3lpgIvKObM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1376
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, December 21, 2021 4:39 PM
> To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; gregkh@linuxfoundation.o=
rg; Williams, Dan J
> <dan.j.williams@intel.com>; pierre-louis.bossart@linux.intel.com; netdev@=
vger.kernel.org;
> davem@davemloft.net; kuba@kernel.org
> Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
>=20
> On Tue, Dec 21, 2021 at 08:56:42PM +0000, Chen, Mike Ximing wrote:
> >
> >
> > > -----Original Message-----
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > Sent: Tuesday, December 21, 2021 4:54 AM
> > > To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> > > Cc: linux-kernel@vger.kernel.org; arnd@arndb.de;
> > > gregkh@linuxfoundation.org; Williams, Dan J
> > > <dan.j.williams@intel.com>; pierre-louis.bossart@linux.intel.com;
> > > netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org
> > > Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
> > >
> > > > +The following diagram shows a typical packet processing pipeline w=
ith the Intel DLB.
> > > > +
> > > > +                              WC1              WC4
> > > > + +-----+   +----+   +---+  /      \  +---+  /      \  +---+   +---=
-+   +-----+
> > > > + |NIC  |   |Rx  |   |DLB| /        \ |DLB| /        \ |DLB|   |Tx =
 |   |NIC  |
> > > > + |Ports|---|Core|---|   |-----WC2----|   |-----WC5----|   |---|Cor=
e|---|Ports|
> > > > + +-----+   -----+   +---+ \        / +---+ \        / +---+   +---=
-+   ------+
> > > > +                           \      /         \      /
> > > > +                              WC3              WC6
> > >
> > > This is the only mention of NIC here. Does the application interface
> > > to the network stack in the usual way to receive packets from the
> > > TCP/IP stack up into user space and then copy it back down into the
> > > MMIO block for it to enter the DLB for the first time? And at the end=
 of the path, does the application
> copy it from the MMIO into a standard socket for TCP/IP processing to be =
send out the NIC?
> > >
> > For load balancing and distribution purposes, we do not handle packets
> > directly in DLB. Instead, we only send QEs (queue events) to MMIO for
> > DLB to process. In an network application, QEs (64 bytes each) can
> > contain pointers to the actual packets. The worker cores can use these =
pointers to process packets and
> forward them to the next stage. At the end of the path, the last work cor=
e can send the packets out to NIC.
>=20
> Sorry for asking so many questions, but i'm trying to understand the arch=
itecture. As a network maintainer,
> and somebody who reviews network drivers, i was trying to be sure there i=
s not an actual network MAC
> and PHY driver hiding in this code.
>=20
> So you talk about packets. Do you actually mean frames? As in Ethernet fr=
ames? TCP/IP processing has not
> occurred? Or does this plug into the network stack at some level? After T=
CP reassembly has occurred? Are
> these pointers to skbufs?
>=20
There is no network MAC or PHY driver in the code. Actually DLB and the dri=
ver does not have any direct access to
the network ports/sockets. In the above diagram, the Rx/Tx CPU core receive=
s/transmits packet (or frames)
from/to the NIC. These can be either L2 or L3 packets/frames. The Rx CPU co=
re sends corresponding QEs with
proper meta data (such as pointers to packets/frames) to DLB, which distrib=
utes QEs to a set of worker cores.
the worker cores receive QEs, process the corresponding packets/frames, and=
 send QEs back to DLB for
the next stage processing. After several stages of processing, the worker c=
ores in the last stage send the QEs
to Tx core, which then transmits the packets/frames to NIC ports. So betwee=
n the Rx core and Tx core is where
DLB and the driver operates. The DLB operation itself does not involve any =
network access.

I am not very familiar with skbufs, but they sound like queue buffers in th=
e kernel. Most of the DLB applications
are in user space. So these pointers can be for any buffers that an applica=
tion uses. DLB does not process any
packets/frames, it distributes QEs to worker cores which process the corres=
ponding packets/frames.

> > > Do you even needs NICs here? Could the data be coming of a video
> > > camera and you are distributing image processing over a number of cor=
es?
> > No, the diagram is just an example for packet processing applications.
> > The data can come from other sources such video cameras. The DLB can
> > schedule up to 100 million packets/events per seconds. The frame rate f=
rom a single camera is normally
> much, much lower than that.
>=20
> So i'm trying to understand the scope of this accelerator. Is it just a n=
etwork accelerator? If so, are you
> pointing to skbufs? How are the lifetimes of skbufs managed? How do you g=
et skbufs out of the NIC? Are
> you using XDP?

This is not a network accelerator in the sense that it does not have direct=
 access to the network sockets/ports. We do not use XDP.
What it does is to effectively distribute workloads (such as packet process=
ing) among CPU cores and therefore
increases the total packet/frame processing throughput of the CPU processor=
s (such as Intel's Xeon processors).
Imagine, for example, that the Rx core receives 1000 packets/frames in a bu=
rst with random payloads, how to
distribute the packet processing to (say) 16 CPU cores is the job of the DL=
B hardware. The driver is responsible
for the resource management, system configuration and reset, multiple user/=
application support, and virtualization
enablement.

Thanks
Mike

