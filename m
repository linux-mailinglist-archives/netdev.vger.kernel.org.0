Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C25647AEF
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiLIAqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:46:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiLIAqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:46:38 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36515A0FA5;
        Thu,  8 Dec 2022 16:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670546797; x=1702082797;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MqgA9o0WHdB8jwQFNoB4J+snYZ2RQBYtJpHsc9OA4Hg=;
  b=PPkji9unXgw5+Z+LA2Soh9qKSi0d3vZTQLC+qfl+hqzR+CrkD0j+f92E
   nE451g2LVwMwKCipMI2raMSOuj9ZyL8LjHNnzCRXlZ86u477ZAHtIjTn6
   qDps8IPHhkaURwncBw6F/b8U7xK22h2P1aBEGNOjdUi2EowM7ZK+nfgV/
   NGz+ObNttzdWc46wyX5Pl2xcBLC6kD5OBTFILBj22Z7UZznuF5iT5nfCx
   1fPOJdcKFQuxu3ONicWA3A22wnD/V4i+hKq3HW7NOqfhaYV8UcBUUiOTA
   2HhF4GarzpyxaVb697fe/DqZmL106fEyLSNFPO8cLupKWQApqlVPW5j2a
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="403599883"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="403599883"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 16:46:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="597557696"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="597557696"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 08 Dec 2022 16:46:35 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 16:46:35 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 16:46:35 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 16:46:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lb3yKJcaYH20+FtAD8LAldosFfXZg2GiNqasFMkgBkQ/K023VxWkPdvsMRYZGfIFPgfla0CKmJRlGWYJGtrJYwa5PKVyc0Xsiwm1hssdmnHfAOk1PDU0Q5JPCJ3xjV9m1s1hpx0pwHC8yPV7I4Pbyn6xhkVp27OCAj07fr3dyRoXprm2/wJTQtDE8SpuWJvJoveTbUzmfOg1RObVFSeEf1r+LdVOlEOqDna2o7kGabTYoZjWybDNs4yivSpdmgPQKRE8KMJYkNGICj7gkJ4YTTtGFpI3a2fhO3frEBFtzK3g2TlcKbgadQfBkgDvAxoIr01J50txuS4aKNUMLVN7ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BR3KfaJdZJJ2Ej4dNPswS9/3nafFQwgmXALIreM7eSE=;
 b=UhtzrjaWTOe2LydNNxsTQcPNAIzQKZ4xVgZDvUtWHaWDprPNvVNnqeJ8q7ggHo9k2rManWm6GaJDQxopXWCnEd6GhlU3DFfodSYb64Jg+BKsrOQlv/Mbz2K2XDYGcm9Os55LeMLv172zpcd5Lakdy8nnodWwubHVq6d9Eo8HFbMyv/qd9thlLc9sws043v3CwzIUjFDJWXoreIR6ccTzHEAQ1wrcq/FVwa93/FkSl+0f/tqgPNElrH2guFDYDMhcS4WvhF6l5p5yBhGPr/YmWuJ41cTaYIC0iPulZPBlZ+YHtHHkyHMENe6m461GYEabiR/sJ6C4VaNnQRNYHFag+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB6833.namprd11.prod.outlook.com (2603:10b6:510:1ec::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 00:46:32 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 00:46:32 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "netdev.dump@gmail.com" <netdev.dump@gmail.com>
CC:     'Jiri Pirko' <jiri@resnulli.us>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        'Jonathan Lemon' <jonathan.lemon@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Topic: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Index: AQHZBDr1K1GsCJct2UayQH1vPDEq/65XZyGAgAMK4oCAAFcrAIAG+ucAgAC+YICAAJp7gIABqUhQ
Date:   Fri, 9 Dec 2022 00:46:32 +0000
Message-ID: <DM6PR11MB46575FB34426955331DDACF29B1C9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
        <Y4dNV14g7dzIQ3x7@nanopsycho>
        <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
        <Y4oj1q3VtcQdzeb3@nanopsycho>
        <20221206184740.28cb7627@kernel.org>
        <10bb01d90a45$77189060$6549b120$@gmail.com>
 <20221207152157.6185b52b@kernel.org>
In-Reply-To: <20221207152157.6185b52b@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB6833:EE_
x-ms-office365-filtering-correlation-id: 135138e8-ee7a-4654-288e-08dad97ed15e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P9jZ8/3CyfdE+lUW0uoHpM5gRsJLsZ/kXBQS0ExtGQ2+zDySlcIYkM9bw+EHNBTSzSW6AFDAxY6mj3bqeluSp2plkO2XPxQUargdmIW6VZi6Us+G3vlR+XFdogwQ2zHNI5Z4vKmMvvi0qDw/ClpjTV5yOVjlPb2wIMmGGp7cCQi+iKrcQ0yknTipDr4K4fwTomtqmwJT0HkMAbMLBWmrfBtNDJXKwJqSie4E34aMdv70UheWP3CoRktTQmHPZvdgGmo2nGToAsMqCKeQNUizbP5GyxhvW5P/q5o3SYL6/zAUzqYtm8uq/z7YJcRjE185j6sRYasITn1D55KyaBXuOhuXH7qNmW6RZXOEgLiOktUsJKU8jdzwHIpsSSzs9GDa/gzN+c1CvhEetgh76XZZQnG19ohxgai34GddSXad4WllzI0xtfkF4LxIC6iRWQbBHqowTK9FAo3e6BP57WZ9bL3yrazH6yHCkjIztNS7rC4dcLrhACB3klO/KzW01MfN991bQV2mexLMHht45n6WBRXL2tF8dNeRCQzoinxueyHR5lZqnp++6iWCVmZHTJA+NOM6iK+EWtyGYC7R4B7rS0UOwXqq7wstx2tT/Vaq824Yt0CXg6QVxzgOdq0nN3mH1Cx4F3BD33ddMbr0s587n9aRYoN7ZYSFZCdEAgldwy0D7wrRdLXWeAeKXfHRddOgnPvU02aIvFF/eqwgTYvA7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199015)(66899015)(86362001)(71200400001)(9686003)(6506007)(478600001)(55016003)(53546011)(38070700005)(82960400001)(7696005)(26005)(33656002)(38100700002)(83380400001)(41300700001)(122000001)(316002)(186003)(5660300002)(8936002)(4326008)(52536014)(66446008)(66476007)(54906003)(2906002)(76116006)(66946007)(8676002)(110136005)(64756008)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dXs2wcnTUbnltlTJ2TdH4CWiEkefhOWj28x12DXri90h7tZYeU5CLjLDWdre?=
 =?us-ascii?Q?TVdCowCZcyS7nLHDnmdRAiDfO5PmczXMWcSGe7ANqdQyr7NKSHrBoviJBlcI?=
 =?us-ascii?Q?KGfcneiJOcfLzQKCVgCMqd5/QbhJPu5EA/2OvMBcABArOMqkbMmNJ5R4y2Hy?=
 =?us-ascii?Q?ClBZEODKvTn8fJvPcgn6mbEbi5sRw0wb+qXlqbYCqzVPbb2uUwnAdW0Kes3/?=
 =?us-ascii?Q?jMku+hX1V8aAMya00ekF7GWcNbvGP961/7C1LfXa03m90MW4K+V+e8gtbdF9?=
 =?us-ascii?Q?i0QNaz5gCGfzxB/0GLBy2Nywg59/2ZN5OuWN+qSmrC9t/iz5iT6Pe/4zHF66?=
 =?us-ascii?Q?j7kJqCyecyCi2h/gCsDrkaUpgcc2wKgqeeNXwRV5/mrUXPWT39AetVatB1t7?=
 =?us-ascii?Q?v3ril27xYb1iGkIG5uFXvOJHsfVyiIY7d2YdQSzgNqkn0D1QnxVTgUpcKpcn?=
 =?us-ascii?Q?YU3Ey/tJ2BI+UwztLyQ5KTkQQOBbuZwaofveQp7qAemaqSIws/FABDaHsrY/?=
 =?us-ascii?Q?K8DW+5aBkNCsS9E2eJOpE96tMelEc2Ceybd3uY6bAbFZAWuSxlp+RnmnUA71?=
 =?us-ascii?Q?4iGhqBFlcDR6CF3P8Ye4E3nJ2cgm7wwXrPRGcGUiS1tjQEkuKe8Yfm03lF5n?=
 =?us-ascii?Q?hdAUxHb90c9LLeHfoy4wEUT+UCw23antyYLgiydnDjt7swm64weH2KFaxAY9?=
 =?us-ascii?Q?3m/Ij9R4i1ivUBnVxghbmaCa7RaJQY/lGcVabN4VQRh1wc/F1pNsvtyEU/qk?=
 =?us-ascii?Q?pOD+hqVGWgUHn5KabYM6tzoiTqNFrMBdyI7KFJSw1ZIUC9e0e0DwAPYcFBLO?=
 =?us-ascii?Q?B2xYZOLg//LtuZVVEeOs3c0TyyJzmRXdtXyfV1PjJjdtwmffvuREWv0LTgsq?=
 =?us-ascii?Q?7m7Xfh23L12+z+c7gZvue11Tqx883xjC41nh4gA/O8BxpWRWJ9eL2U/2z0ov?=
 =?us-ascii?Q?fx4J2+StyaKlyrsqWuJ4udDY5NGshR2/oPZes91jPFoBD756qBJUUFneA1xF?=
 =?us-ascii?Q?fVnLYE2Q18YWjhjhLJriomUZNZ0SnKgsokTbtJgA3H8Qf9UfI5aarEUzZ2Jg?=
 =?us-ascii?Q?I8TSavaLUgPsHVpuL8epMDG7t9HVmPjZcH6CY+wjkZxQoH9yc+dxi1Ww9HjO?=
 =?us-ascii?Q?QSbclW8EhANwfYkC4XXXEmBOpmkKtr7iSm73BCDGiCrxn+6jmjFTUkEL+wsj?=
 =?us-ascii?Q?dyy6Xwq2rZx33mRx6DB6Pv4oSrTDTD2FwUsfSHPsJP3cK5HH1FMbbgit6zLN?=
 =?us-ascii?Q?yFbB1t7hkiayYOD4fjsOzLy7tFgM5gpbiIK3tjlNyPXzcgxCMksTZrYrn3pE?=
 =?us-ascii?Q?3wGSrP18JkrpAVpbAdj8vRKE93OXzWEcSWQxVSJwlF4C6er9aV4Bn0u0ZTdG?=
 =?us-ascii?Q?zbZZBoe+JumrNe+wzvLaI3ch0oms+FUhZee4kcW6e3I8fTEl9f85C3zZS/Vp?=
 =?us-ascii?Q?MPR5g57cjBOAG/I8HHmaCXgGfIvmU5yoVwtGEqTuwhL2PdfB+XGTRtxv4Us4?=
 =?us-ascii?Q?A5KGcSjnzXVS5WXzT9tLkS64rBCxT/B0Smwg+ZAopcZQ82e78I20mC/aZD4m?=
 =?us-ascii?Q?EsHK7UPNKqZWudPpSgSjupD8ANpT/smjkG5ZVsR9oLXsJArs8BHAjIvQYpyh?=
 =?us-ascii?Q?6w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 135138e8-ee7a-4654-288e-08dad97ed15e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 00:46:32.7593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1aROZgc9+vP5v29n7qUJGiv0MytRL251bncoIZsVU7DjONRItkRJZ+s/ZQiRu/GwrdjVRgPH6dSntzIsCyzv9hVXMRQ/o8k9PFrV3srt8JI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6833
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Thursday, December 8, 2022 12:22 AM
>
>On Wed, 7 Dec 2022 15:09:03 +0100 netdev.dump@gmail.com wrote:
>> > -----Original Message-----
>> > From: Jakub Kicinski <kuba@kernel.org>
>> > Sent: Wednesday, December 7, 2022 3:48 AM
>> > Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration
>API
>> >
>> > On Fri, 2 Dec 2022 17:12:06 +0100 Jiri Pirko wrote:
>>  [...]
>> capable
>>  [...]
>> require
>>  [...]
>
>Please fix line wrapping in your email client.
>And add a name to your account configuration :/
>
>> > > Yep, you have the knowledge of sharing inside the driver, so you
>should
>> > > do it there. For multiple instances, use in-driver notifier for
>example.
>> >
>> > No, complexity in the drivers is not a good idea. The core should cove=
r
>> > the complexity and let the drivers be simple.
>>
>> But how does Driver A know where to connect its pin to? It makes sense t=
o
>> share
>
>I think we discussed using serial numbers.

Right now, driver can find dpll with:
struct dpll_device *dpll_device_get_by_cookie(u8 cookie[DPLL_COOKIE_LEN],
                                              enum dpll_type type, u8 idx);
Where arguments would be the same as given when first instance have allocat=
ed
dpll with:
struct dpll_device
*dpll_device_alloc(struct dpll_device_ops *ops, enum dpll_type type,
                   const u8 cookie[DPLL_COOKIE_LEN], u8 dev_driver_idx,
                   void *priv, struct device *parent);

Which means all driver instances must know those values if they need to sha=
re
dpll or pins.

>
>> pins between the DPLLs exposed by a single driver, but not really outsid=
e
>of
>> it.
>> And that can be done simply by putting the pin ptr from the DPLLA into
>the
>> pin
>> list of DPLLB.
>
>Are you saying within the driver it's somehow easier? The driver state
>is mostly per bus device, so I don't see how.
>
>> If we want the kitchen-and-sink solution, we need to think about corner
>> cases.
>> Which pin should the API give to the userspace app - original, or
>> muxed/parent?
>
>IDK if I parse but I think both. If selected pin is not directly
>attached the core should configure muxes.

If there is real need for muxed pin (hardware with support for priority bas=
ed
Auto-selection or some other hardware constraints), then both.
As priority is set on mux-type/parent pin, but selection of muxed pin would=
 be
done manually with DPLL_CMD_DEVICE_SET and given DPLLA_SOURCE_PIN_IDX.
If the hardware doesn't support priority based auto-selection, then it migh=
t
be better to just add new pin into existing dpll without any mux-type pins,
this way your driver would be simpler. But also possible to follow the same
approach, add mux-type parent on one instance and register new pins from
different instances with that parent, both are propagated to userspace app.

>
>> How would a teardown look like - if Driver A registered DPLLA with Pin1
>and
>> Driver B added the muxed pin then how should Driver A properly
>> release its pins? Should it just send a message to driver B and trust
>that
>> it
>> will receive it in time before we tear everything apart?
>
>Trivial.

With current version...
Driver A creates dpll (as it was initialized first).
Driver B:
- allocates new pin
- finds existing parent pin (find dpll (dpll_device_get_by_cookie), find pi=
n
(dpll_pin_get_by_description).
- registers new pin with parent pin found.

For dealloc Driver B shall deregister and free it's pin:
dpll_pin_deregister(struct dpll_device *dpll, struct dpll_pin *pin);
dpll_pin_free(struct dpll_pin *pin);
This shall be done before Driver A deregisters dpll.
As long as there is a reference to the Driver B registered pin in dpll crea=
ted
by Driver A, the dpll won't be deregistered.

>
>> There are many problems with that approach, and the submitted patch is
>not
>> explaining any of them. E.g. it contains the dpll_muxed_pin_register but
>no
>> free
>> counterpart + no flows.
>
>SMOC.
>

_register counterpart is _deregister
_alloc counterpart is _free
Whichever pin-register function the one would use, it shall use
dpll_pin_deregister(..) when releasing resource.

>> If we want to get shared pins, we need a good example of how this
>mechanism
>> can be used.
>
>Agreed.

Shall be provided in next version of patch series.

>
>> > > There are currently 3 drivers for dpll I know of. This in ptp_ocp an=
d
>> > > mlx5 there is no concept of sharing pins. You you are talking about =
a
>> > > single driver.
>> > >
>> > > What I'm trying to say is, looking at the code, the pin sharing,
>> > > references and locking makes things uncomfortably complex. You are s=
o
>> > > far the only driver to need this, do it internally. If in the future
>> > > other driver appears, this code would be eventually pushed into dpll
>> > > core. No impact on UAPI from what I see. Please keep things as simpl=
e
>as
>> > > possible.
>> >
>> > But the pin is shared for one driver. Who cares if it's not shared in
>> > another. The user space must be able to reason about the constraints.
>> >
>> > You are suggesting drivers to magically flip state in core objects
>> > because of some hidden dependencies?!
>>
>> If we want to go outside the device, we'd need some universal language
>> to describe external connections - such as the devicetree. I don't see
>how
>> we can reliably implement inter-driver dependency otherwise.
>
>There's plenty examples in the tree. If we can't use serial number
>directly we can compare the driver pointer + whatever you'd compare
>in the driver internal solution.
>
>> I think this would be better served in the userspace with a board-
>specific
>> config file. Especially since the pins can be externally connected
>anyway.
>
>Opinions vary, progress is not being made.
