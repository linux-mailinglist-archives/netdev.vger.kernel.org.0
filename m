Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FF021E511
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 03:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgGNB3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 21:29:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:33778 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgGNB3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 21:29:46 -0400
IronPort-SDR: ULqgTXjrT+aBrMelpGKH7+YTnOXZ+QD89pBS0Kn6fwlL4e7ycaS0yvRRpFpvOf4GMyv8RLEh6P
 FvKOUse3sGKw==
X-IronPort-AV: E=McAfee;i="6000,8403,9681"; a="146792128"
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="146792128"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2020 18:29:44 -0700
IronPort-SDR: 6Ap64ENJ3L5VXHO76Q17313HjdLA8KsLBOpcahNCvABdv52IdLbXLJSwy5gysv3KTFm9p29TTS
 VvN1r/Rnjy2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,349,1589266800"; 
   d="scan'208";a="325687577"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga007.jf.intel.com with ESMTP; 13 Jul 2020 18:29:44 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 13 Jul 2020 18:29:44 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 13 Jul 2020 18:29:44 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 13 Jul 2020 18:29:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLJmkgyQzkUgSYpe/kdRLwZ4wN7W6Fj6Z74ZlOt2rgVD8wvL85McCwDVEUv1u+2gihL+Oxu2lcQZAhAGb8wMm+D2OkeoqXB8zoQfJIQe5HvPZgKQ6JQbDW0LTMkVjz771++vXmNR16CaoRVd7EFNx7otWfybJ6mTre4xMMOD2dKsAcwelWxA8SktkXq1srPjXFJbcFEqa6SSuVsa6nXFM9Cbb1LsXU8/enPjNp/0KM1KNqVmiKFVEOvUMbETAyhvGYGcFBD/9v9pNYuw3eRF6N8z3JPvMQEUwD7qiyOJCgaA3IUuDz9rMNpEbuSutvoIUqnAv9jjI36emrk//vpoMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHFuV+sIgajMHxqGGQieEmHVrE5yPSLcL+9Mx+UFWXI=;
 b=DKMVCftzMZUYlc3rNX2mmFIFR5zVBEjjxqPU+f5aj3NsNAjdTqnA76lbPXf0GPAz9CN919VkX75dzWzrpYalD2vn6y5jn+Hbozg2pl39oe/8VE3QC5FMbX7Gt4q8XAwyUDAIehb/JlnscrLfkXgzmigHyyepw773+k9ppY/PdiaSU9+zhbhDwAxQUnRRqoCy6qAFLiW9hZ8E6crBk8fKzrfPu8yYZJoYZYZJZpoO0IOoSQ4Vdpi+Trzp4VHbDFDf0igIfkaSYezWWt1QJ1ugw3wLlhYwhI32urp8FyfqTjDyFBcTjGtBrxg64doiyC/e5QYFJ9hnpXs8gW80qCQj4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHFuV+sIgajMHxqGGQieEmHVrE5yPSLcL+9Mx+UFWXI=;
 b=vMfyNghgwI1FmtK861uoSwNgzlBIKgxFdN6wg6fDBDhB+njJ6YZDWyguj6tq6l9rhV0coiC8xt5f2T14X98Yt4UxoveXvJ4OGtcwfqwDY4YBtKeu311XgQbqL9+SJuPYk8Jr+xYezv36st9QS2JtbCFTPn5TJKmrogrJqoXXHxo=
Received: from BN8PR11MB3795.namprd11.prod.outlook.com (2603:10b6:408:82::31)
 by BN8PR11MB3729.namprd11.prod.outlook.com (2603:10b6:408:81::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Tue, 14 Jul
 2020 01:29:41 +0000
Received: from BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::dd0f:7f49:bc5f:2fde]) by BN8PR11MB3795.namprd11.prod.outlook.com
 ([fe80::dd0f:7f49:bc5f:2fde%5]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 01:29:40 +0000
From:   "Wang, Haiyue" <haiyue.wang@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Lu, Nannan" <nannan.lu@intel.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Topic: [net-next 1/5] ice: add the virtchnl handler for AdminQ command
Thread-Index: AQHWWT0ppkWffu3OB0+1aq0Sup42gakGHQqAgAAk/NA=
Date:   Tue, 14 Jul 2020 01:29:40 +0000
Message-ID: <BN8PR11MB37954214B9210253FC020BF6F7610@BN8PR11MB3795.namprd11.prod.outlook.com>
References: <20200713174320.3982049-1-anthony.l.nguyen@intel.com>
        <20200713174320.3982049-2-anthony.l.nguyen@intel.com>
 <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200713154843.1009890a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.38]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dae53d9f-7d4d-482f-b2f9-08d827956156
x-ms-traffictypediagnostic: BN8PR11MB3729:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3729F3AFA6241B8ED3E4B066F7610@BN8PR11MB3729.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JcSD3NtH7cpETffHHzXstvKzAep9L0lFlUXFgh1/iIqyljLwzmAnIy3CZNwfXOu0mk91aX5r3tY62k0+9B72PG+BNca1VylGHWul+WzTHQB4JBlH2xuQn6zbmahbE+poZbZNVhSiXOAm2oWBz0rUCNQRtd+mv/n6Q6KBj+012ob34lEP1ZIaJIOrW0lkMyXwSUfV5mcyAc9tNkhfX1p5LEXtDKoADjYOcZV47UEFVe1aPkrHmC9v9mgiKicwM9Ff9NIBRx3Ydh8CyQA9vwF2t2C1FesZoAE3UBL+IqyebkcYHVbDtoJBJ+jz1JTX/nl8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR11MB3795.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(33656002)(26005)(110136005)(54906003)(107886003)(316002)(83380400001)(2906002)(4326008)(71200400001)(76116006)(66446008)(64756008)(66556008)(8676002)(66946007)(86362001)(9686003)(66476007)(53546011)(52536014)(8936002)(7696005)(478600001)(55016002)(6636002)(5660300002)(186003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: lzS4jmdKbJ/jweLple7Rw988v6FXntCKYWnsI49VwuqSypez7nPUVL51OrTSJz7tMjpwRF0P4oYmqT4jooRtYS/xzM65ZPqtGdJSXZrsYuQaObrigoDmoX1K4j5+W7mKLu3eeZ7HJntfKWk5mW/SdfGsXhiDMscT4Sxnys1Sfg2zprtKgjfXlCIDiSpdcaZUiMTVQZThAMP5T3ejo0GO6/GCtm3XDb5pYpix5KRc2bFPzAxAUt+wWEN/V2+WL2spCMz5MJ2LaDDlfFhyGYUR6kGmd3WYAsa2xTBqMsQO3PoB4pmjA+EvYn6FCEB4e2B+noYJ68KHugMZPRuIqYIPWn6xAyNuOL0csPWiaBt/u1tkzZc+CX6r0jTtXfAs0l+4NjiReUudju1oWBFPs0d469x3O17KqtaDR79QvsBNyBOwxWjjV/nrIDN4MSOccNFp7PVXsoG2ccTrukFiFzCY63mwwrHGWEXG4isbObXcyO1gYbvBVLc9dOboK/HQDUv3
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR11MB3795.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dae53d9f-7d4d-482f-b2f9-08d827956156
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2020 01:29:40.8038
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u+k1iypiGOr+RSYNZ5OMSU61Vt742e6MjFNGaCkJ8eLNDfwsKbd26ysHBSygRiAkPoOXH8SUE9VykP+luKW9iQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3729
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, July 14, 2020 06:49
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; Wang, Haiyue <haiyue.wang@intel.com>; netdev@vge=
r.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Kirsher, Jeffrey T <jeffrey.t.ki=
rsher@intel.com>; Lu, Nannan
> <nannan.lu@intel.com>; Bowers, AndrewX <andrewx.bowers@intel.com>
> Subject: Re: [net-next 1/5] ice: add the virtchnl handler for AdminQ comm=
and
>=20
> On Mon, 13 Jul 2020 10:43:16 -0700 Tony Nguyen wrote:
> > From: Haiyue Wang <haiyue.wang@intel.com>
> >
> > The DCF (Device Config Function) is a named trust VF (always with ID 0,
> > single entity per PF port) that can act as a sole controlling entity to
> > exercise advance functionality such as adding switch rules for the rest
> > of VFs.
>=20
> But why? This looks like a bifurcated driver to me.
>=20

Yes, like bifurcated about flow control. This expands Intel AVF virtual cha=
nnel
commands, so that VF can talk to hardware indirectly, which is under contro=
l of
PF. Then VF can set up the flow control for other VFs. This enrich current =
PF's
Flow Director filter for PF itself only by ethtool.=20

> > To achieve this approach, this VF is permitted to send some basic Admin=
Q
> > commands to the PF through virtual channel (mailbox), then the PF drive=
r
> > sends these commands to the firmware, and returns the response to the V=
F
> > again through virtual channel.
> >
> > The AdminQ command from DCF is split into two parts: one is the AdminQ
> > descriptor, the other is the buffer (the descriptor has BUF flag set).
> > These two parts should be sent in order, so that the PF can handle them
> > correctly.
> >
> > Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
> > Tested-by: Nannan Lu <nannan.lu@intel.com>
> > Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

