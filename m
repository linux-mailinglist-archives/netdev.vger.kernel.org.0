Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3BD20D22B
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 20:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbgF2SrH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:47:07 -0400
Received: from mga18.intel.com ([134.134.136.126]:30419 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728116AbgF2SrF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:47:05 -0400
IronPort-SDR: /RwfO/htfbfkO8qz0PmmZHpirlw8zIgSMLzzYClTN4lRIMY/M5sOA4ohPkZ1HGVEPUADLLAcOQ
 J0a2ds/lt0EA==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="133469538"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="133469538"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 11:47:02 -0700
IronPort-SDR: uYtSz4VsZ+RRKIisFcQYHv5JHjsooT6rm+nEvSMKujKJbeCmDiQiy9BtMJYYEmrIATwTMCgASD
 0prwILg6izIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="266268985"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga008.fm.intel.com with ESMTP; 29 Jun 2020 11:47:01 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 11:47:01 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Jun 2020 11:47:01 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Jun 2020 11:47:01 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 29 Jun 2020 11:47:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dl8QFgrywK+bIvRzxqhYE3WRM0lRji0TjqPfkWDrQUsw0QJJJlIsHOYeQDLIFPwRrRp87OkrdcwoY7eGNGtQBLPUTI5bfMu+ulyP0cG0Kqo7ifFYvk1uOZfddWRQUb9K/Q3qEz/cJibfw0MT42z7h6Lq3kN1goEUHQLD3+S0PmfIHxw47X+PuBDd4E0HLbKteGj5m+zf0JrNXAZ/cw/GsqqkK6F2cRApre7GehdVEifC9P4Fs8I1ryOlYL1EtfgLv9vHeWfoc0kw9473fbB30kS9tz9J2n+RrsqAbM6cABHcvbiJCGCmH4LG7sZZz+0rIYSskmgxP50NJvOFxUqulw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9BB431jzyxUNwcF1iCMqmBQ1bchLtK4WzZFkBHANWA=;
 b=JW+7qzozZ3LfKGo4myCWakbO0oJN1ZQFk3HwbPBwzX6cjwXMUMffA72HbdAjpM3dnwfPDlyY4Kmdk4IzTiHTA/mgRW5wCj/W60ob5Ti/8pJ80EXXYZhgzU5KcY356RiLOA1LjblPTDB3/u22Ekp0zylDlLATMr6CsNtv9BvU0Hr9RZXqJy+ZyLoaRdnKoKJGsO0CRrPe/pxShhmfwarDnFLNba5Lio78N3Cncog6j18+aHZuC0tzTrF7Hh/SbXvB5A0IJA55TGBLAeKbNxvw5yhfhm4lWS5snUedI+zZX59ypmd1a5UGqSseAuIJJ67nimP2qaRRxENardGCHW32Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9BB431jzyxUNwcF1iCMqmBQ1bchLtK4WzZFkBHANWA=;
 b=WlbJJWC/L/lHKjHpfgs6H74G3wkFi649fWyMnGkyx2wlY8kdBPVUhXy0IftFk35X5utGEiXxqOz2dZ7eEEDLvUHUjYvg8oJ3rIZQu204KvFWJeLUsblD6m9kEMiQ0aGAPifyVVut1IFCbWJGEEzHqvyTSJ71nXCeJ9Uruans35o=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB1808.namprd11.prod.outlook.com (2603:10b6:300:10f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Mon, 29 Jun
 2020 18:46:57 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%6]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 18:46:57 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Joe Perches <joe@perches.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v3 14/15] iecm: Add iecm to the kernel build system
Thread-Topic: [net-next v3 14/15] iecm: Add iecm to the kernel build system
Thread-Index: AQHWS16Y7BGCucOKkkmmk56D1uG+CKjqPfyAgAW2d6A=
Date:   Mon, 29 Jun 2020 18:46:57 +0000
Message-ID: <MW3PR11MB4522D2065D16293848FA9C0C8F6E0@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-15-jeffrey.t.kirsher@intel.com>
 <f8b49d7e88a0e5016a16a03dd50b28e73c2a49cc.camel@perches.com>
In-Reply-To: <f8b49d7e88a0e5016a16a03dd50b28e73c2a49cc.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c49813f4-5e1f-43a1-764b-08d81c5ccd0c
x-ms-traffictypediagnostic: MWHPR11MB1808:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB18083762774AD60347AFF02E8F6E0@MWHPR11MB1808.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mWZdnT7/GeHweBjwMgkpuY0avpSZMHM/Cti96Ke+8e+qAm1BZN/74VR6CQ3ZjGwQu3tVPeO/a9EtyNB5PjcS9fa1CSS4oOrSuG83jSVvETsnSVCmQblUFHhzbzh9GrwyByxsAAOrfswTNZSciOQ2zYr8DQExRBVufNZ6+l7/S8iB2Q+8NSawu8CqCjR+OqGAZ2D6iv2MWEkzCapo0+9Jb+v2OeLcn5tasKEWWlbgBwoZ3dGmnaEwkk7zhptok+jtbWTtaZeFI/tvAzehEoKyTI0s4U69Fk8gxc9raUkkpL8IVF0Ryp0C0kWFNOjHvxKK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(6506007)(53546011)(33656002)(186003)(26005)(7696005)(9686003)(52536014)(86362001)(66946007)(66556008)(66476007)(66446008)(64756008)(76116006)(55016002)(71200400001)(110136005)(54906003)(2906002)(8676002)(4326008)(83380400001)(107886003)(5660300002)(478600001)(8936002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MaRmWW+xiEKuyrK/wGqxwXjTvs269hbZfRbx/yovVZyf+d4m0vRoXboxkLHfC2+t/7pqsewovO+FQZIz08YhP7gr3tfqUNZrFqTgK7VTCi7+wJ2Zr7HA7F64sG2urL3qnbV+Esrb0VG1vV6JKrO6Q/u/QxEcXCK3BhTtFBNc8MKft4vN+kK1BBqjXcU3HXG7h9LaGvAHE7UvGXvbglFWAn2wDy51BESEPyOPOFHbauM2zVx/IoA4ty2vOaiaZf3I3Ky89l9MS8dqUR2SeXAbTV96jzBeQQ+LTiYsG6HWH9XwCuotZhtsP+xWxzdxueW0DAO99kTPsQdajaITR8BY0d9DqjyNxeMHIirxt9l8vhFJrpaFpy/iUqbksVvA9ZenBDh7mW+YvTGePULfHyj1c0uUreoAjteOiUjy82vevqjkMMyrE57zyGrOAcPR1yQsFwUhcDUVUvUBHMgBumnmd/eYjz6MHD38qJdWOCmXgKI5MpFrHxH8dPD0lDwkBG2g
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c49813f4-5e1f-43a1-764b-08d81c5ccd0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 18:46:57.3728
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kUy7AIAFObkVeJH0LkcKcAHo0j4mJfm5UzGX/A6hOQ2qRrYs/V1O3qKXWpqkIsR/RGwYd+0CNXlPceacx3iY0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1808
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Joe Perches <joe@perches.com>
> Sent: Thursday, June 25, 2020 8:32 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> Cc: Michael, Alice <alice.michael@intel.com>; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Brady, Alan
> <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.com>; Hay,
> Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v3 14/15] iecm: Add iecm to the kernel build syste=
m
>=20
> On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> > From: Alice Michael <alice.michael@intel.com>
> []
> > diff --git a/Documentation/networking/device_drivers/intel/iecm.rst
> > b/Documentation/networking/device_drivers/intel/iecm.rst
> []
> > @@ -0,0 +1,93 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > +Intel Ethernet Common Module
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > +
> > +The Intel Ethernet Common Module is meant to serve as an abstraction
> > +layer between device specific implementation details and common net
> > +device driver flows. This library provides several function hooks
> > +which allow a device driver to specify register addresses, control
> > +queue communications, and other device specific functionality.  Some
> > +functions are required to be implemented while others have a default
> > +implementation that is used when none is supplied by the device
> > +driver.  Doing this, a device driver can be written to take advantage
> > +of existing code while also giving the flexibility to implement device=
 specific
> features.
> > +
> > +The common use case for this library is for a network device driver
> > +that wants
>=20
> to
>=20
> > +specify its own device specific details but also leverage the more
> > +common code flows found in network device drivers.
>=20

Will fix, thanks.

Alan

