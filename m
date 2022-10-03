Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A973D5F3576
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 20:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiJCSTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 14:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJCSTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 14:19:14 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309FF2B619
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 11:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664821153; x=1696357153;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K6whnrJJd1LGABNJVnxv67n0rVjWeWqEqvhtDD1Ms2w=;
  b=SCvAAQf7IrbfiZZYEZ89lrKud7jQUCkaQWOecQK9Y+L6hR5aRcQg79UA
   QdqKZzuyeGAXNRBmkLJ6nbn9CktgW7B1ZckLo2zECmHlnZrXoY+wydKvx
   MpmfFpnJFlrQsZRrkFDpXTQ/DzU/uzzHcDbH8HiLaHobNcSgd1qlLAAki
   11P8m2Z+1ZeMmWB8ccPm8ljoUUZZeDRwe9cb+zALtOpcqKZIDSS4ZWBR5
   d7sQEI2aqNMKar4GCEnhf3019Tf38Dq2tT5290wDrvSnupcfSFiLaytVQ
   YN1Kp+/UCbb1bq5pGteeHBPzLDj+9XBaY5yosn2pLGH/gR1cMsrlG9N/5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="364606689"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="364606689"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 10:53:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="686220540"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="686220540"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 03 Oct 2022 10:53:24 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 3 Oct 2022 10:53:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 3 Oct 2022 10:53:24 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 3 Oct 2022 10:53:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ip6bg2nfPwuPoPkmsAAo7ECOQiZmlxrKoac4khp/VJwjKutjen4l7GBeCh3V77k12tQx4JUlUsH3xO07/yTWQn4S/Hph/9OcFYfxGha2HOIMDRFf9vf35/IJDLA0/owq4CTV+2UdREnZXsi90kgObJAwt6bsySVmEUZmP4jblps/lhQOsPom+Tioj3q61EqWdNbJeyp66xwae2ze8jJORWiF5/RcPlf6lfGu95Hb6XW/ex+4qyHcG3Yth5kr637s+RaiFjo3zCGWBty/6nHbh0gaBdgJ5/0lPVLUnzWduHS9E+pfELANSxVbFXaIWaKV9yGLEP03EKAgALooKFMC4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K6whnrJJd1LGABNJVnxv67n0rVjWeWqEqvhtDD1Ms2w=;
 b=QCWKWDy0VDIKqbd9HmJIp2WWNXYpAkk7h7y/Hypq0Fle6yHKPUcr6lTdJsBzROtecVLM9MwdLvsqTB9A406aPbyXN4GIN1Izk4XZejwjLe+hvKiMFyD56vcKM/UyGOqXxxwjPkJYvL3AL+vFFeAY9QOKsbf24tpOTjMMP8lKBna/8+7uY+wAM4ziV0GxpqHKHF4j2/o8OYLm0I8jCQkuwp2LZpis09o+S4hPy9YKPN7OfuvBv/h3bP+WKbSJTh1hG5spH9QG7Ar54RMUpUGqiBjvf9/19vUa9g1bmYH0leNPZUS5qpIoY9QyE1DOS0KuCG0VKx1EsSBH5ipD11jP8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY8PR11MB7396.namprd11.prod.outlook.com (2603:10b6:930:87::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Mon, 3 Oct
 2022 17:53:21 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::47f1:9875:725a:9150]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::47f1:9875:725a:9150%8]) with mapi id 15.20.5676.030; Mon, 3 Oct 2022
 17:53:21 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Michael Walle <michael@walle.cc>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: PHY firmware update method
Thread-Topic: PHY firmware update method
Thread-Index: AQHY0y1TlZftc25x0kaRSZx+auW9oa30xUOAgAE3t4CAAFqNgIAAHQqAgAALd4CAASXhgIAARliAgAAkCgCABI3ygIAAKAWAgAA1ROA=
Date:   Mon, 3 Oct 2022 17:53:21 +0000
Message-ID: <CO1PR11MB5089B0BADFA1B8D1EE20863BD65B9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <bf53b9b3660f992d53fe8d68ea29124a@walle.cc>
        <YzQ96z73MneBIfvZ@lunn.ch>        <YzVDZ4qrBnANEUpm@nanopsycho>
        <YzWPXcf8kXrd73PC@lunn.ch>        <20220929071209.77b9d6ce@kernel.org>
        <YzWxV/eqD2UF8GHt@lunn.ch>        <Yzan3ZgAw3ImHfeK@nanopsycho>
        <Yzbi335GQGbGLL4k@lunn.ch>        <20220930074546.0873af1d@kernel.org>
        <YzrTKwR/bEPJOs1P@shell.armlinux.org.uk>
 <20221003074205.29ecfd8b@kernel.org>
In-Reply-To: <20221003074205.29ecfd8b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|CY8PR11MB7396:EE_
x-ms-office365-filtering-correlation-id: b708ba9f-8146-44a0-e62f-08daa5682988
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y6TA1BI37HcbKacYVrnWa/B8KLgQKHh4TUD9uDmKLVkxJss1vghPmxwVv/nDPG4zdUBwby5m0VohbKNg1KxlgxWCgbN2wwSDtR4e8jPjIz4snjYHSnBvF9b4xP3hZVW0+2RYQlacpNcacBqHboXxspDId1mszLmR8uTEpF5il0DcnEr1NaieLbn+168jdjWkqFNRiGnnblPzcvHm/HpmypHfMUbGznvGQdMI4OIIfq8JzRYxnY9GPBKMfsS9WGiD7BEMeZiW1jlQFLyzAAACWUQQBmtCBy1IUQxaHJpyLS0gbpi6HuT4AN+TfZp5eL/0C4oLttww/6rVFj6x74bGUwcp5y0IcdK3bJmGwyXPVvjOxX5tVKDrQorhxHoPSILTI0jwMN5QYrv0qGIUKcRIOP2sUZ0qkmZrr7YdO3XNEbe3P8p1HL6LQQ3JCEBcKzh309zNOQQ1M04wdptnd4+KcIgnRpmp10QWtCZhl8lNQ9bAjXlXQL/9AEdIfPfEKmr4bh6JdFjnjfL7TVPEWazI7oMo//lOQfGK3HhCPeXqmvb8eC8RGGXcKZ/PNUJvOv2VSxYXwwE28V7ZhcUge9QGTpmyHMH9xMa1u6GqswKJGkY+0GYTAXlDRQp2n1e2hOzpvIpl/wLU+vauBT7yJ99m/xE7f3qM/iczdgkAoW44lcSbHbGvzJn52GDFcPvw5Aj41YimG6m7oxRwo+gyDRFqFShj/YfFT1uACQZqMcPUWbrlUDEZAhhfzDUS3QrKRtUz3dfsj5z3RnvXv0xGAZmfN4z4MxJnf+kvQ7WvBXP+ges=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(376002)(346002)(396003)(451199015)(4744005)(64756008)(122000001)(2906002)(15650500001)(7696005)(83380400001)(52536014)(76116006)(53546011)(6506007)(66946007)(9686003)(41300700001)(3480700007)(82960400001)(33656002)(8936002)(66476007)(26005)(38100700002)(966005)(71200400001)(4326008)(54906003)(38070700005)(86362001)(55016003)(478600001)(8676002)(66556008)(186003)(110136005)(66446008)(5660300002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FeROaRnUKKced4VI6a8SiPTzYY9KqELcpCQWhDHyY+5ZMi+lszTqOsiwJ9fV?=
 =?us-ascii?Q?uJP0ZpsfK+j3Gpb6BqNdSt9Mvt3YhKthqaXOfH32C1SEmP/gbWcyORko8CkM?=
 =?us-ascii?Q?dYgZ3F+3WX1iSGM4c9vGiPFH9L6uCrkmqVxLTsJFcE9jY9XLZfAGDykhzZUZ?=
 =?us-ascii?Q?CylK4P4JlUVysUwxx+yxPHTrwPsZhR+MDH5tVEyRB+LgjYO0yvSuC6a5GVaT?=
 =?us-ascii?Q?ZelF/v0iyFCj2kCXuv3x++2JsNTEy952t3yI93VrzbNw9v4wy1/VnKgu90v0?=
 =?us-ascii?Q?UFowx2ETsMDwChTV9E1PTAIhvuYzkfhQKHAly3yab1/FXrH+ghOJZmawZBGl?=
 =?us-ascii?Q?20hEgDP2cHFeopsfosh7u2QOukAF6AdRsCKofBv6gYsX5dgEfdfsFttF1gT+?=
 =?us-ascii?Q?nQx8R+FNfEMI4PoOgDK6KLe/hWKFHarKmE+n17f4mf+QBUGEibRsGE/MbHf6?=
 =?us-ascii?Q?JPI7A613y8I3wO+KFRlOA4R0bbXEl6+GCaIbGHtGRDxQRbqYntZtawWQlUB0?=
 =?us-ascii?Q?uNWejWGLPyPsjQ8CW03+uO+pw/Xl90HRr5qPii0t3nO25bhvrHm4PQXn3dUo?=
 =?us-ascii?Q?Uo4RPhP+8qvB0D0xd6/vddWOvsaPxJN29MxaT1mYng7DWwSrhZ9W3Kt+XsWY?=
 =?us-ascii?Q?+vEo6gMxGfiZg+F0RaKLFeWjeredaUfMi95stE47MIqhGGBoPEGgU9eZHqtM?=
 =?us-ascii?Q?910O7EPtenP+kC2ZMMpMj3Gd+5WZzrMCnaKSQus+QHOTnsAnfSnX0Xl+8E0F?=
 =?us-ascii?Q?G3xCuC83V/R2JHtXvUNNP71FJOylez2jxsMo+JJ8iUDejszN3EG5UYLChCh7?=
 =?us-ascii?Q?S7Yu6OaI76JLy9rlHPltERsObA6yZaUZFRTowedJs+eeE7m/UUcyX3rB8Ay/?=
 =?us-ascii?Q?sBzlk/M7Co3wu3o82GAeFCN36AoD+4lkPW0uXAmXRkvfXjooNMxtsITLuDSb?=
 =?us-ascii?Q?DJUpW4/jf39n6y5SjN9o/9jZxFbF/StMYVKMA3bfPK8lvEQF2ZHznK8ymUTc?=
 =?us-ascii?Q?aYfGNgOppOPIiJ2vOoWiF8y5LkQmYginKNAn24mhgJPagXc/VByD+wwH9e3T?=
 =?us-ascii?Q?+X9Krw7Uv4gAa7MQOe+dIXHMTpJxkJXwUOaPO/JN3/K7CylsE6JVFEgiVxT6?=
 =?us-ascii?Q?cS0KzGXpLCg5jv8Bsa/2+6umgH7zObFDZoS0uBiMzEN6IIXxLfsbxynJfqzF?=
 =?us-ascii?Q?Zh8n6J7LUzSWZTnjjvN0XzALfpAiOStxPThJDMiSiOuQG6XHeI3HI/3MCvbC?=
 =?us-ascii?Q?lMMjetzGQoQtBqxMhpK9buROMRdnfUsyW8q5IHwbrwlqZ6RM3Pn45/+9JCFm?=
 =?us-ascii?Q?3G+XfoxfEokNvXmU3E/XpuTW7Vs6wgYa21SHjmAw8Ga5O3andFLiZsHVy9lm?=
 =?us-ascii?Q?6a6zuDxaOamCcRmqoaDcx0qBgf3x/anZ2CB9ShlsoIihRiNQ/HY0NmeptjgA?=
 =?us-ascii?Q?GwbA7UIlpmvYv/FRIXt/LrOiSZJkeu7nDLYMRzLdhDpLfyRNbonmPB0c5LKo?=
 =?us-ascii?Q?FAJY5IJ0ZA1lm6/LE7/YizAGc91aFcSpdASNSuYtxmmx/IVdHSIPtzjF30Rn?=
 =?us-ascii?Q?4+lmwT7LCOunzT+k/4xRv47laqvvMgNJaK7ljIN7?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b708ba9f-8146-44a0-e62f-08daa5682988
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2022 17:53:21.8053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ebUzcwdz5aINaWeDn2aKP0gDgitkl7lTyDQ8SpLRRgiNpdXtb9kNjPSh17IO8JJIughCEYOdngDX45CGl2YZhoANgBPa4xcokjtwqaacYDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7396
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, October 03, 2022 7:42 AM
> To: Russell King (Oracle) <linux@armlinux.org.uk>
> Cc: Andrew Lunn <andrew@lunn.ch>; Keller, Jacob E <jacob.e.keller@intel.c=
om>;
> Jiri Pirko <jiri@resnulli.us>; Michael Walle <michael@walle.cc>; Heiner K=
allweit
> <hkallweit1@gmail.com>; netdev@vger.kernel.org
> Subject: Re: PHY firmware update method
>=20
> On Mon, 3 Oct 2022 13:18:51 +0100 Russell King (Oracle) wrote:
> > On Fri, Sep 30, 2022 at 07:45:46AM -0700, Jakub Kicinski wrote:
> > > Actually maybe there's something in DMTF, does PLDM have standard ima=
ge
> > > format? Adding Jake. Not sure if PHYs would use it tho :S
> >
> > DMTF? PLDM?
>=20
> Based on google search + pattern matching the name I think this is
> the spec:
>=20
> https://www.dmtf.org/sites/default/files/standards/documents/DSP0267_1.0.=
0.
> pdf

Yep, this is the standard I implemented in lib/pldmfw and which is used by =
the binaries for the main firmware in the ice hardware.

Thanks,
Jake
