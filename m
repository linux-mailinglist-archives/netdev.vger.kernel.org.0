Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741D16487AB
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiLIRWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiLIRWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:22:01 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A60250;
        Fri,  9 Dec 2022 09:22:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670606520; x=1702142520;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=o3xPvjCrUytfKcGve85XRQUKuCQ6OY0AzyG1SBxWNTQ=;
  b=Z0bb/NRTsyIaB1AvyXyR8LCB0QmOfsI1HCvCOX74d7N8Z/PSBpMpLaq+
   hbpw7k1BuF/bJ3ArOMm9+ZuUoGsl9vw0cbsnLCGx5ZaGBQLWPIBsFHfAH
   oxuOZLkW7h5Hz5HkKu2XTkUWbxV4ddCN4fnthmyJjGdVCJZvtMKjQqfkh
   pp1WxLkdQAFmDfUPRv6k82K2Wu5R2qL9fllmm0g02qtif6A2pkrPihHDP
   VOwoW9jPNt7MDEdoKR6Nf4xKeD5KRUhJziPia0tb2PEi5ZRe4VQMWJlE1
   zMHWOjrm5h8MjOZ1bxg3s4j6BJMKoHAHbvc9DpXKgd/aG9M7P50CTLpch
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="379719566"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="379719566"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:21:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="821790091"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="821790091"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 09 Dec 2022 09:21:59 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 9 Dec 2022 09:21:58 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 9 Dec 2022 09:21:58 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 9 Dec 2022 09:21:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brxhldy4m27iCRyUbDIjJvetk9CmicdiKcOMoXTCyVs8FY/52sK84Ru0Vceso1437aHsC1jzCb1WCJDCZBd82+UnLKuxgbVKFxsWavomnLlx6FOAv8Mo6KXnj4FC5jml0HMFBr66ZL3IJL5MgjG2kgyplnjQrTol2dwxOl4EHru0z8IA3wwSL0wOn6ulxVMxETpLWho2btmod7lGrHQS+qnNK1emsm2ghHKtUcWTpgydzCJERkN2eEy4UkHDmyIsYpIDTHxa0f+58D56UmXs2PZc/vG3dTXGIqOS7HOyhoZPPO5Q4WLCXObdda+vVDmKiHhTB1OuvTd1x+5hClQxtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=afXKz2ORSZ/x3s30Hx6+q8HfBBUUTRQV6BatJVl1XrI=;
 b=G329c98GgrfBLJ+7pS8AOisW7Afrj/8XMXyDnSIo0BqScJzGeuy4h2Pkl76kI/JVTsurWtDRNyMpIbRLXx2sDY6QywJ3rujPrCBgMdiL7AvicY07SOZLCsb63dwM1Edp0eRMx4BfX1DTm4yJMvK183fWKiawWwlVkHyFypdceM3kYYQiBV4M7jEw4i90JTzKS1cPORvLM+7V3S7EmdUg9IbCdRIUFJAuN6dvj1i3CFNsZO3E6iiH/Fr8G7STXyAlL1hC5SZiKfVz9ik8aRi7JAUGoydvTNerZQh1HuT+PRHiTjSQPb7kL+lObx1NRzznOC/FGUjomzBrH0veu50iaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by SN7PR11MB7537.namprd11.prod.outlook.com (2603:10b6:806:348::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 17:21:55 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::1bdb:fbd9:b48c:6e6f]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::1bdb:fbd9:b48c:6e6f%5]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 17:21:55 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Saeed Mahameed <saeed@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: RE: [PATCH net 2/4] ice: Correctly handle aux device when num
 channels change
Thread-Topic: [PATCH net 2/4] ice: Correctly handle aux device when num
 channels change
Thread-Index: AQHZCoBpTdDa1UJnHk2WsWg1c+9BN65jAKQAgALHjtA=
Date:   Fri, 9 Dec 2022 17:21:55 +0000
Message-ID: <MW5PR11MB5811E652D63BC5CC934F256DDD1C9@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20221207211040.1099708-1-anthony.l.nguyen@intel.com>
 <20221207211040.1099708-3-anthony.l.nguyen@intel.com> <Y5ES3kmYSINlAQhz@x130>
In-Reply-To: <Y5ES3kmYSINlAQhz@x130>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5811:EE_|SN7PR11MB7537:EE_
x-ms-office365-filtering-correlation-id: dcd95918-169b-4a15-574f-08dada09dea2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lY4aEhN5ugYWnYZ+H/Uc6fHyeATLggjzoMnZZLDgnpaEG1HA/0EVzqN7MGychTQJE8SSyMr/UZOqunzLZ4vs0psiieoJ4m93NIGvVU8oqVR6/BUSPluqX1Mvj5t6mfJ+VPBBQqvY2d7EaRtTV5JCP26w+PKAtHXPas8MqZbb5HSkQIL5eA2aXFGya5r3xv2WwP6KJoEU8ynD6TvHud+XlAY+IOql1hosXaGb8yrNktSRAk0FWbl1m3W3juXqJe2ehWkt14WgLKscOYcfFi27bT8CBGXE1EE0YD2YDojRD2CuMD4kZbU6KPR8nAgddRE+e87Mgt+iXtKP7cv3dGMb9mnioPNNM+GUaIsb85mhKaeZebXv25YGpNYw0pLkL95nPAWvl2I4OgpA/OtzJRMLA7kPLOiq+jjkLAkDJttvlGsWuIlqT+yvSeKSXwarSj222xqjeFmP7kJB4/JfRF2yrfkHZQJfXJuSECTLxucZZ+nYGYwHe0SX1inFm1hXHB2rDM3JIwKNK4oqZupk1WkQ3mMBeBammA5U/5euRtg4eerixaIkPOmWjuyHdRxxBL+0XebOW61kQS5qgYd0npcFVnvPdSuPWGU2ROO7CT+Zsame1AHYgv/+vNMCPTVqCPvl7YxmC9Mz0X8TPHZOo37m4i4D9tfxiu8K20g5lP/OlMz9YfpA7HcIySh5rZxNztipcAnn40rMoPP1eWP7JzvFSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(396003)(39860400002)(376002)(451199015)(66946007)(478600001)(66446008)(55016003)(64756008)(33656002)(66556008)(122000001)(66476007)(8676002)(4326008)(107886003)(38100700002)(82960400001)(2906002)(110136005)(186003)(71200400001)(53546011)(26005)(54906003)(86362001)(83380400001)(76116006)(7696005)(6506007)(38070700005)(9686003)(41300700001)(8936002)(52536014)(5660300002)(6636002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VySn2+dtrydjiup4fxevvRanMUyay3EyPj4LEURMMfNEGXqIw/DlCarJLWOF?=
 =?us-ascii?Q?nJlF8RVH/q87mc251Ky6hoVLqU9Af0AWlPhJXzq4ni5FzlT4SdLyqZkio8I3?=
 =?us-ascii?Q?CJ6ejhpIRR5N/6IngC0IiRKVhc/LF4wIJMM4mCfl0WXjA1gDJqTtS8vl7owU?=
 =?us-ascii?Q?7ecDPkRRxNw1ped5ALbiRpiG/VCKzOXuFmesGSyuWpyM3kRrm98fLjuNSdj5?=
 =?us-ascii?Q?JJGHso1G5M8p46S0pJRRhnjvPRcr6LP7NvtSopOiEGGYsoKqIVxBA8G96Gaa?=
 =?us-ascii?Q?uwFAEx4wZwpHEHUyhhxxnEdvNThwG5C3Rig1pyv6b99zkLmOA5XKbiXklt6p?=
 =?us-ascii?Q?IaRJKux+QrK0fexTe6CJniI7UV39mI+6onmzcrGzMTd9Nr1/KhgzUoEOGMP9?=
 =?us-ascii?Q?fKxJzkF2BHhW/JTF09MjFVhtABexmXjiUnHIGthArLvOiiRdvl5uWlJPmfko?=
 =?us-ascii?Q?YnJCA/ThSdTYTqd7YXDZ5AM4sqfb5X6iPW2lRMsPle4NCsiodIvI40cGES7n?=
 =?us-ascii?Q?7X9U//cUDFAPZ9brzuBOIk8UROkEL2813ljcDqSGqdoz6rWN2qvQ/FZThGlE?=
 =?us-ascii?Q?mLNO8+u1cAbIVWlwZKYPUra6hmCBiwi5PWY+9nROKXrPUzA0WK4Kn3uzvsuw?=
 =?us-ascii?Q?XB+bWbbmVysemA9SXaGq7Znh3cutUbHYMwQzOICg7NFNBauW6TwozlnzuSnM?=
 =?us-ascii?Q?FS7c1k011S2eYEePpuou/ZfYXSR5ajZ3NixTs106GFklwfVr8E3hyv26+aPA?=
 =?us-ascii?Q?fG/U3e3GEnRoBcn3YckuIfpAODPCiRJfbbyDECFrpTtRu1MuJcQLmRM7OSne?=
 =?us-ascii?Q?9TyLT6x3zl037PY//eUrxNr3OFkqB5ptPfv7jk6Zyr5aL9XfuqhJAwXjz5gc?=
 =?us-ascii?Q?a4VaxZOcRsLqMoJjKg2HwRLT3dDtP6WJdFEdc13NNGyD2edINAH/5UwSNM7X?=
 =?us-ascii?Q?JU6hvsA3WosX7wC+IC6yE3AVvbFZrwmsmRz4A8ij9MNbUHKjBX7Hf4iMyYAJ?=
 =?us-ascii?Q?Kod0rWe1qKb54gCUOiXjmY6hycTFCzDASA9SxRbvrjmCo6WZfGZfhv/cuo0E?=
 =?us-ascii?Q?8WIsnHib71jaYZWr1wS7I/89fCKeAeQtsmRvAUncM45AG6OCmZXsGbR0owfZ?=
 =?us-ascii?Q?hJmgPRwQs9IV12+YWW72HiuiGDmWL5Fz4Jlf9UZWHEuCsr3vFEeuqwm+0tLV?=
 =?us-ascii?Q?kRh8uMjK0Op+15tUjh270z8ztkTMi9mWLCnWYKvUjGu88V3x93mxzdf+9dLK?=
 =?us-ascii?Q?JdkaEbY6nSbTtNvHJ9xsIonJlqRZCzLS1mCyU9iREBgtbpu5k2y5JlFfGNMP?=
 =?us-ascii?Q?sgL0NGy+dYyUxi57VlhnAM/A8vzJqxbdfFQZSABJZjEMwnruNY7lXASh/2Jt?=
 =?us-ascii?Q?tmYTFhHSPD9yC7zL+iP1yFHl6YcphBWcPpEmkh5LJkitlUv6/z5z/ed57UNu?=
 =?us-ascii?Q?OZ7xr0NEevCVVJ8o/2eukH5OLrUBK1ORvqK0/7bMnsVl/Dw6r+agIGbXPL0T?=
 =?us-ascii?Q?RlVdvQ9nJIfRUSs5Dgl6XHn9Z6tS+A1HkhQ5rYJnJnuwfO2veNRmekQY6nRZ?=
 =?us-ascii?Q?pq8BNuRSeFkn/9TPwbOKTLH9eM3g67QmBveIEsfoCS8t9G/t+GG9aVrKb75p?=
 =?us-ascii?Q?Jg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd95918-169b-4a15-574f-08dada09dea2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 17:21:55.0932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FgwHSwOWDIER99tSX54bhJR4QjTnIdZQUPYsChS5Tjc6a9SV+CMhTZiZjJzcnS6lnsm773Pi2Ie1Nfg66oKIkCs6vonjxIbbvIz0RZBK4hQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7537
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
> From: Saeed Mahameed <saeed@kernel.org>
> Sent: Wednesday, December 7, 2022 2:26 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> edumazet@google.com; Ertman, David M <david.m.ertman@intel.com>;
> netdev@vger.kernel.org; Saleem, Shiraz <shiraz.saleem@intel.com>; Ismail,
> Mustafa <mustafa.ismail@intel.com>; jgg@nvidia.com; leonro@nvidia.com;
> linux-rdma@vger.kernel.org; G, GurucharanX <gurucharanx.g@intel.com>
> Subject: Re: [PATCH net 2/4] ice: Correctly handle aux device when num
> channels change
>=20
> On 07 Dec 13:10, Tony Nguyen wrote:
> >From: Dave Ertman <david.m.ertman@intel.com>
> >
> >When the number of channels/queues changes on an interface, it is
> necessary
> >to change how those resources are distributed to the auxiliary device fo=
r
> >maintaining RDMA functionality.  To do this, the best way is to unplug, =
and
>=20
> Can you please explain how an ethtool can affect RDMA functionality ?
> don't you have full bifurcation between the two eth and rdma interfaces .=
.
>=20
This patch is to address a bug where the number of queues for the interface=
 was
changed and the RDMA lost functionality due to queues being re-assigned.

The PF is managing and setting aside resources for the RDMA aux dev. Then t=
he=20
RDMA aux driver will request resources from the PF driver.  Changes in
the total number of resources make it so that resources previously
allocated to RDMA aux driver may not be available any more.  A re-allocatio=
n
is necessary to ensure that RDMA has all of the queues that it thinks it do=
es.

> >then re-plug the auxiliary device.  This will cause all current resource
> >allocation to be released, and then re-requested under the new state.
> >
>=20
> I find this really disruptive, changing number of netdev queues to cause
> full aux devs restart !
>=20

Changing the number of queues available to the interface *is* a disruptive =
action.
The netdev  and VSI have to be re-configured for queues per TC and the RDMA=
 aux
driver has to re-allocate qsets to attach queue-pairs to.

> >Since the set_channel command from ethtool comes in while holding the
> RTNL
> >lock, it is necessary to offset the plugging and unplugging of auxiliary
> >device to another context.  For this purpose, set the flags for UNPLUG a=
nd
> >PLUG in the PF state, then respond to them in the service task.
> >
> >Also, since the auxiliary device will be unplugged/plugged at the end of
> >the flow, it is better to not send the event for TCs changing in the
> >middle of the flow.  This will prevent a timing issue between the events
> >and the probe/release calls conflicting.
> >
> >Fixes: 348048e724a0 ("ice: Implement iidc operations")
> >Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> >Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent
> worker at Intel)
> >Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> >---
> > drivers/net/ethernet/intel/ice/ice.h         | 2 ++
> > drivers/net/ethernet/intel/ice/ice_ethtool.c | 6 ++++++
> > drivers/net/ethernet/intel/ice/ice_idc.c     | 3 +++
> > drivers/net/ethernet/intel/ice/ice_main.c    | 3 +++
> > 4 files changed, 14 insertions(+)
> >
> >diff --git a/drivers/net/ethernet/intel/ice/ice.h
> b/drivers/net/ethernet/intel/ice/ice.h
> >index 001500afc4a6..092e572768fe 100644
> >--- a/drivers/net/ethernet/intel/ice/ice.h
> >+++ b/drivers/net/ethernet/intel/ice/ice.h
> >@@ -281,6 +281,7 @@ enum ice_pf_state {
> > 	ICE_FLTR_OVERFLOW_PROMISC,
> > 	ICE_VF_DIS,
> > 	ICE_CFG_BUSY,
> >+	ICE_SET_CHANNELS,
> > 	ICE_SERVICE_SCHED,
> > 	ICE_SERVICE_DIS,
> > 	ICE_FD_FLUSH_REQ,
> >@@ -485,6 +486,7 @@ enum ice_pf_flags {
> > 	ICE_FLAG_VF_VLAN_PRUNING,
> > 	ICE_FLAG_LINK_LENIENT_MODE_ENA,
> > 	ICE_FLAG_PLUG_AUX_DEV,
> >+	ICE_FLAG_UNPLUG_AUX_DEV,
> > 	ICE_FLAG_MTU_CHANGED,
> > 	ICE_FLAG_GNSS,			/* GNSS successfully
> initialized */
> > 	ICE_PF_FLAGS_NBITS		/* must be last */
> >diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> >index b7be84bbe72d..37e174a19860 100644
> >--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> >+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> >@@ -3536,6 +3536,8 @@ static int ice_set_channels(struct net_device
> *dev, struct ethtool_channels *ch)
> > 		return -EINVAL;
> > 	}
> >
> >+	set_bit(ICE_SET_CHANNELS, pf->state);
> >+
> > 	ice_vsi_recfg_qs(vsi, new_rx, new_tx);
> >
> > 	if (!netif_is_rxfh_configured(dev))
> >@@ -3543,6 +3545,10 @@ static int ice_set_channels(struct net_device
> *dev, struct ethtool_channels *ch)
> >
> > 	/* Update rss_size due to change in Rx queues */
> > 	vsi->rss_size =3D ice_get_valid_rss_size(&pf->hw, new_rx);
> >+	clear_bit(ICE_SET_CHANNELS, pf->state);
> >+
>=20
> you just set this new state a few lines ago, clearing the bit in the same
> function few lines later seems to be an abuse of the pf state machine,
> couldn't you just pass a parameter to the functions which needed this
> information ?
>=20

How is this abusing the PF state machine?  There is a 3 deep function call =
that needs
the information that this is a set_channel context, and each of those funct=
ions is called
from several locations - how is changing all of those functions to include =
a parameter
(that will be false for all of them but this instance) be less abusive than=
 setting and
clearing a bit?

> >+	set_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags);
> >+	set_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags);
> >
> > 	return 0;
> > }

