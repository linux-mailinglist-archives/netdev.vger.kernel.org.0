Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3D2475B51
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 16:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242156AbhLOPD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 10:03:56 -0500
Received: from mga07.intel.com ([134.134.136.100]:29065 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229623AbhLOPDz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Dec 2021 10:03:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639580635; x=1671116635;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RT7wwlzfQgCt7UrqjWS02XgK8kU4dDVX1Qy7mX2o0dU=;
  b=YW6eveOOYnmkeQJbK+dLzWKBS9PqONgUV0qY0FhfSF2XzuXrrb0YOvWp
   OpacihpZIPVmQDtZ52PX6J5UJ+ASaWiqZh/RAFtpHAuehyi15gMyWbp+S
   v2m/t1A6cyK3xXICJTCp88w3WADjybbvWcjix4QTkn1jIx45GUnUxXp10
   2KC9r18TgqkQpaJXKE2lj9rdpwhCSeFKbSwvVTVzXHP/wRJLu5PkpguLg
   DdHiSdmgRJ8dT3/0xlt0WGPuHFDik5+FEadPuEFALouVNhlkGE9GcwCQT
   5XGO7IIT++XrkaLeduSoFruFtLwn/kKOaDEjIAP1WNDC2PpBp/PA9Z9Q2
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10198"; a="302618151"
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="302618151"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2021 07:03:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,207,1635231600"; 
   d="scan'208";a="682527033"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga005.jf.intel.com with ESMTP; 15 Dec 2021 07:03:54 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 07:03:54 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 07:03:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 15 Dec 2021 07:03:53 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 15 Dec 2021 07:03:53 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjVXPTtDAa3IUCJlYe04cl4oxmGENBoffWqQscAcm2kcgvkT61MoV5QXXiMt5WwosZ26BvAuv0HFrTYUNH0K3zKAW1pBhCAK9mEqg4VFiYFGk95LnFSno2MlCqCnokRfa5xwD9Tz8Ze/lNcXs9pOAsCQI/7SeXReHMrtodgqOOtG4idkotz3KeDToBOedwmMZxZ4DPNzAjAIEeDmES3hG3B0HSb+dXG2dhNRLCn5TQUara4JCCesFcmzHwowCwxI8/VJVXpoa1yUQJjpaTAJRi4mbfNd35MMtLOrRm+9U+NPa2ylzOiKwMu3dlqugQzYYQTh4mdpPAPOjGp0L6NSfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kXf6lKOI6pjSGm0BbDzXKlrfLtf8+CY8ubtzAvN3blo=;
 b=hg/SFxpbLMhY0AYutdh68ww3X6NleSm8MMusaMGY/Pg+vRWgwSZWDVOahbkgnMaOshbOfQe0E1ZgrNcb9JUy+QTS0QdBG7RxzeKNLhSJUzjwW6MzCsv+NfzpTMNpo7hMcd5Cb0kcDV3Rxp7mDSOFMwL5kUftAgqahM2q1orgFxhNOoCQv7Z2/m75kHki3b11i280YI6t/uNmZ2xO7vszFjwzj3TUdBIqJW5Fttm1QuMzDLE/siBM8tURs2EHNrMMG7M03fIggHkS/RSIPpK7K+OQYvZLC7gomiXO4ZnQVya+m2Q7NvYF/WIP/AWva+8HLF4gWNqBTmP08AeGZoIM1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MWHPR11MB1792.namprd11.prod.outlook.com (2603:10b6:300:10b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.18; Wed, 15 Dec
 2021 15:03:52 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::116:4172:f06e:e2b]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::116:4172:f06e:e2b%8]) with mapi id 15.20.4778.018; Wed, 15 Dec 2021
 15:03:52 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>
Subject: RE: [BUG] net: phy: genphy_loopback: add link speed configuration
Thread-Topic: [BUG] net: phy: genphy_loopback: add link speed configuration
Thread-Index: AdfwtmkvCyrAW5M4S3mERBKDxICdHAAGBHqAADANSQAAAa06AAAAYHXgAAC+sIAACnbKwA==
Date:   Wed, 15 Dec 2021 15:03:52 +0000
Message-ID: <CO1PR11MB47710EE8587C6F4A4D40851ED5769@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <CO1PR11MB4771251E6D2E59B1B413211FD5759@CO1PR11MB4771.namprd11.prod.outlook.com>
 <YbhmTcFITSD1dOts@lunn.ch>
 <CO1PR11MB477111F4B2AF4EFA61D9B7F4D5769@CO1PR11MB4771.namprd11.prod.outlook.com>
 <Ybm0Bgclc0FP/Q3f@lunn.ch>
 <CO1PR11MB47715A9B7ADB8AF36066DCE6D5769@CO1PR11MB4771.namprd11.prod.outlook.com>
 <Ybm7jVwNfj01b7S4@lunn.ch>
In-Reply-To: <Ybm7jVwNfj01b7S4@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c9bc89a-9e4c-4970-f1b2-08d9bfdc1ba0
x-ms-traffictypediagnostic: MWHPR11MB1792:EE_
x-microsoft-antispam-prvs: <MWHPR11MB1792F6F9A4B07BCC1D54BDFED5769@MWHPR11MB1792.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X/gjfs+Je2NA8b52ZoWa3p9/ZcTV7O1TE25CX7WHKFLkrHOkm4ncZlqjTj68mj2TfxNfxpV0I6vXq8jMDfvfJj+LSLDafOMN0D3iXCKRe72KobArczCFVYFBVPuUDtmtOJWlW/fU0EyVwl650UZotoBybriUsduwuWsS6C98aONTNcx5EczL4A54h6CgT/AE6zY3JIMqBt/eKZ/+4F/9ZRSKv0hDlhMTYbVvBPU/KMkRra9NmqcAOv91KuuFds5y5yDWye/WqSDxinwYLM97T3GdrVKM6e4qGE+Ny67/O2uLNkc0kfc0+TYSbfP67+5lw5xadj3B+R7e1c58YQLDH5+U79drXz6ZNzfTkXNZAr+J6goM/RIPakzzL5RFeV/XD1mYwgOgmQKh2SfjHbyabwwgc0xSrM3WckYuiMxgEvlYhnxkgaFwPXgQQOwTlACkfNr1qXH5k61UFnQvB8nC7l85jKW6LNBEarQdh4QUNjOIuWneMCN6JYUv3aWL8aVnodoFeVAOZofoLZ+WY1FYCV8OKg2b9lT8sqvVfvvr6LoguJ6BvLLSvWoDdX2D9EgKsbwOsJsKdK4LtJLSqnssdBBAn2telEW94baYpU93IKypv1b2l1i9dohg4GTtvt3O27U8DmhDZu0NegwG1iRGIewty1vdbjRlAkIOC0jPPcJhCPxMBNIYpo3Mxe2QbH5gFBuNsuEX8R31l5iMRsBTrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(26005)(52536014)(107886003)(2906002)(8676002)(186003)(5660300002)(8936002)(53546011)(6916009)(64756008)(316002)(82960400001)(54906003)(7696005)(6506007)(38070700005)(66476007)(66446008)(66946007)(66556008)(71200400001)(55016003)(508600001)(9686003)(76116006)(122000001)(38100700002)(86362001)(33656002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oip6Ew1cF9A15rUjadBb3Cd60Vn0KCRAlKFI3nEjyFnf50ga+LX6SsgqctSW?=
 =?us-ascii?Q?F/kc7O/obCONIXNdEUkGdpS76GpdasiL4dEGEfPc3Tgn657iNeyclz7MNZo4?=
 =?us-ascii?Q?OYo8xJEPAbsokss3yeGSjtwHvcXe4zWBWPeKjJios6IH5gaG2+0VXK+VU6xs?=
 =?us-ascii?Q?i1HNA2+59rou7VyyR208scxKCWMqVa9DtPj3rilMZD57lujsntR6GEGSSdTf?=
 =?us-ascii?Q?v645BbqdXgD+wl9AoqBVI1LJt2mPWjrj3e1bitikcrCQodcHhMiGT39esFFQ?=
 =?us-ascii?Q?DhReXYGg055kFfBXqHfV0/1UQItBOwzkeE1gAALejjYUMH29RQvkMsYVANTC?=
 =?us-ascii?Q?wlYA7zDGPuZXMm7Qwzsm//pyoTDtI2yN/sEoQiK3DL81csLIzpmAKeiZDaiB?=
 =?us-ascii?Q?loTRMqwRZFgGRrXigNZUyv/JAf0rJUfDkj0xYhsn/WkJd6+uIOCAAX9weeMp?=
 =?us-ascii?Q?nZ8stmzYXt1g+Bp/NBF5hSYaxHV6Mtn1kprZu7I0hFOy4mtjtin82uHFK4x2?=
 =?us-ascii?Q?h3ThyFKHFa3WkmMrw5dvnGs+rBuaOuXbe0ibEY1WIddpK6729cE/gPqMiR/P?=
 =?us-ascii?Q?PErxJq65EfL49jm9Qh1ZkK6S4xnTfkdSizUh4dvw+bTZHA+NmVWLT5AoRsQT?=
 =?us-ascii?Q?OCcXtV3xo7TSwq1xEEVFB1lHdt72vCtbZ9OBcFKhbvZVqlRFce9DUWR2N7W3?=
 =?us-ascii?Q?W9uZXCTLgl80B8e9dGVggSjFnsxWwbPEA7Uelev85X6RAh0FwB10O90TcxRl?=
 =?us-ascii?Q?CV+3BqStK25IIMkMPIKRTOWTcEQA0nMsS8WAtQ8Q+AZhGYXSKYi14pkw3pDq?=
 =?us-ascii?Q?D21dCl1hrRH0coiVnvOX3ybNQUcKxTHao//1WApzdvMhKVHAZSai+yCNnX+u?=
 =?us-ascii?Q?OrTSM9o7Uvwx6SjAa96c8NamK4UujDr1RSLok4jwMD81+RZ9zH9+tDqp1fsh?=
 =?us-ascii?Q?c2KLkZErJx2Nbt8liyQoQ07AyUa9rK2YETwktpoeS7r0LXqYii9ZhpRzDUcR?=
 =?us-ascii?Q?WJPa7jIw1tKEU43jZv6I4aFAn3Vq6GXtMHe5YkYfUuzSyUIDyq4WAEdNviT4?=
 =?us-ascii?Q?fLWPvkwIh7cICRwkLZktj10nzXGVZRLEoLiUu+S3wbrdj1nglM2ZrJEoDpP1?=
 =?us-ascii?Q?dAdeLcL2Xyn4aU5CdywJg5+oXD6CWkS11NLWaazOcwYmzvJaTKq/nTjkhvBa?=
 =?us-ascii?Q?iA0NJ6aN8D5N/OWmz/chO6MywNXNQibsut3vPdI0yzsv6Q3mb6ZsToaeNnKA?=
 =?us-ascii?Q?M0TgIwhMXAYf54m933TLDDasl9HnZL5gobJvVvEbpe9dG1z/7KH3KpqVmry0?=
 =?us-ascii?Q?ankhY4x+LdGeLmanTO4iL+8EtW1TAznUNBXeVgL+wnMmU1G3t4POwW1SOp7A?=
 =?us-ascii?Q?mjkZ1EFrpqeo8bodd7+//j2LWheW7RBTFiLlInfIt1VETuF32RD9LnR/2ZEF?=
 =?us-ascii?Q?Wt2k877VJA5Pnjj+kpUM0AYXDO5hQIwmi0EqxAsSpluiI+QhNn3QRrVW+hqN?=
 =?us-ascii?Q?+kYOIlaXUd6KaBA1M+Zrzt5fRMCesKmT4svxHYNry986J77rSIL4HP7yPibx?=
 =?us-ascii?Q?HqNmNQOYaJwWtVK/FJ6prYcIZZY5Yc/iYrbNZRVRY2cUOUjrj/DyDzFeOejC?=
 =?us-ascii?Q?Y9f0iyk+8MiKV0DUYjzLc3NFA5b7+U64CM+LTfo2Igx5upvKmtH0Eyk5YjbM?=
 =?us-ascii?Q?w3WiFOqkZSPMHnCnocdHIZK6zwKMxYJySaAP6fSx/i4Reh/G?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c9bc89a-9e4c-4970-f1b2-08d9bfdc1ba0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2021 15:03:52.5036
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1wh90lolYo5wwAWRFdBbglsxWA2C0FlPkHFC4rLy5yrBBWrwa3ohq4QjTjNm0lMlMR8d5y4kPO0af41bbNaPqX9XRB2w/qi3munJI46ZOhWyiUP5i6mRcdbsCXq2u/D9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1792
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Wednesday, December 15, 2021 5:55 PM
> To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> Cc: Oleksij Rempel <o.rempel@pengutronix.de>; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Voon, Weifeng <weifeng.voon@intel.com>;
> Wong, Vee Khee <vee.khee.wong@intel.com>
> Subject: Re: [BUG] net: phy: genphy_loopback: add link speed configuratio=
n
>=20
> > > -----Original Message-----
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > Sent: Wednesday, December 15, 2021 5:23 PM
> > > To: Ismail, Mohammad Athari <mohammad.athari.ismail@intel.com>
> > > Cc: Oleksij Rempel <o.rempel@pengutronix.de>;
> > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Voon, Weifeng
> > > <weifeng.voon@intel.com>; Wong, Vee Khee
> <vee.khee.wong@intel.com>
> > > Subject: Re: [BUG] net: phy: genphy_loopback: add link speed
> > > configuration
> > >
> > > > Thanks for the suggestion. The proposed solution also doesn't
> > > > work. Still
> > > get -110 error.
> > >
> > > Please can you trace where this -110 comes from. Am i looking at the
> > > wrong poll call?
> >
> > I did read the ret value from genphy_soft_reset() and
> phy_read_poll_timeout().
> > The -110 came from phy_read_poll_timeout().
>=20
> O.K.
>=20
> Does the PHY actually do loopback, despite the -110?

As Intel Elkhart Lake is using stmmac driver, in stmmac_selftest, return va=
lue of phy_loopback() is checked as well. If it return -110, the selftest t=
hat using PHY loopback will be recorded as -110 (fail).

>=20
> I'm wondering if we should ignore the return value from
> phy_read_poll_timeout().

Removing/ignoring the return value from phy_read_poll_timeout() can work. B=
ut, the -110 error message will be displayed in dmesg. It is because there =
is phydev_err() as part of phy_read_poll_timeout() definition.

-Athari-

>=20
> 	Andrew
