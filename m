Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AB35EDDB8
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 15:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbiI1Ncs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 09:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbiI1Ncq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 09:32:46 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52137A2610
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 06:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664371964; x=1695907964;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rri/JYT47/p3Vc/it4DULH252x5C1KmjQZ2L7D7BMfU=;
  b=QTPOj4Ps+5Yh22WSZ61gCtPPDRKjIHl4CQLttgPTf7eRGYLEYtOvpauM
   ytzpQP7otOo2I9aIQP3eriBaelYP3oUA3bJV3jS4YJIlBz/pJFZqVizrZ
   D3sTbXoGtQoFISkJKqwBAxNvGfV05va6SIuoaKhEe7QqhaGvKa8A2d1Nu
   VlAUtlpmH0CMQny9aGCIwaeTyk/of1IriqAoVg5GsvBk4MwPsY+pxf7V3
   LJkL+O+mFE+YOEaREFQevGkwTFuNXxwQV/nDZpF06yxDt2NVSWY9rqtvf
   PcmiDmnVUBADmZkydfELNuPep2COpDqX6V+hZ0LGXvF25XFAMKZnaSDu8
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="288759688"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="288759688"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 06:32:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="573037343"
X-IronPort-AV: E=Sophos;i="5.93,352,1654585200"; 
   d="scan'208";a="573037343"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 28 Sep 2022 06:32:43 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 06:32:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 28 Sep 2022 06:32:43 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 28 Sep 2022 06:32:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nejyevLm9MpM3AsZtgs2idSE83w+OJ6MgqZnzDnJx4WLeFSySbTq+Zscz8lPG0s+buXWiL1rbA4itGv0LMtqr3JCTlSVmJEeWKPtxQTMChRz2LTEs+gd7v/Kbj4fD9vjTakcSW5JGcPEjgRbAq5HGE3PNH0KTrjaQrgYZXb2k613gIV8RC9b8Gju3qg8tWvVQKDCUmXgW4BtcF3IJdSSKj6gqtATCDJr3q219MlQ57oXBlh2TJe0vAYB+gdtQpB6/MHWffeOvma/qxv0VMp38L6G2q9cg1+5QhgkKs/03G7z8sS265GUYJneFjEDbOqucoKVgAXdzPRZ8OxwGjFNTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rri/JYT47/p3Vc/it4DULH252x5C1KmjQZ2L7D7BMfU=;
 b=Os3z8IIPf2h4NIGg9aGM5IgrNLZx6/P/SIAoIvOlhMQGXoYQ2+8SMAYVaoc97uAUiHBa9Roa3JCWWzjepIGBBSkRJ+V4kIhpQ8IlPce5Xwcz3yaoNz5TyOU7WZMz2tOnR8dWopPKVsd1bVmNr597XA9DC7/MqHtnhORDMHOWb1L7/uhiWvaFFrtITO+28ROCYCLijkKDC+cJvkfVH0gQliFQtVA7Jsw54G2MtYvNgy0yeL/s0s3U1gbFr62S6CIvjKwkTQOAPBL2FXPjaDTfWu9d2n8cMwNTWyQLjq1hIScXE30Awyc7/1TkNmCoPyYTa1Kpypzv0kKUwHHBhXejFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5SPRMB0012.namprd11.prod.outlook.com (2603:10b6:930:3f::7) by
 SA1PR11MB6757.namprd11.prod.outlook.com (2603:10b6:806:25c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Wed, 28 Sep
 2022 13:32:41 +0000
Received: from CY5SPRMB0012.namprd11.prod.outlook.com
 ([fe80::44ae:7bcb:96b2:f2]) by CY5SPRMB0012.namprd11.prod.outlook.com
 ([fe80::44ae:7bcb:96b2:f2%5]) with mapi id 15.20.5654.026; Wed, 28 Sep 2022
 13:32:41 +0000
From:   "Jaron, MichalX" <michalx.jaron@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Maziarz, Kamil" <kamil.maziarz@intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: RE: [PATCH net 2/3] i40e: Fix not setting xps_cpus after reset
Thread-Topic: [PATCH net 2/3] i40e: Fix not setting xps_cpus after reset
Thread-Index: AQHY0ecWG2TpjKMUNEeOmACNWrW4Fa30D7eAgADI8pA=
Date:   Wed, 28 Sep 2022 13:32:41 +0000
Message-ID: <CY5SPRMB001206C679A78691032E6E73E3549@CY5SPRMB0012.namprd11.prod.outlook.com>
References: <20220926203214.3678419-1-anthony.l.nguyen@intel.com>
        <20220926203214.3678419-3-anthony.l.nguyen@intel.com>
 <20220927182933.30d691d2@kernel.org>
In-Reply-To: <20220927182933.30d691d2@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5SPRMB0012:EE_|SA1PR11MB6757:EE_
x-ms-office365-filtering-correlation-id: 82c31387-dd2d-4703-e63e-08daa155eafd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s7Yxwb/PYzGB9XUhwc1pjBjrFJs5aZsGm5hIzcVhSeeEKS6QQdbbLPXq31NAdOt6xwRe6MbaIVxL3qp8HVk0No4atkaiiYfd5OBVAbPnM3jFUAFzJWa1g4ucYDjxS/Pc+8EohuNfLWn4WHZWqYnvJAKyN+LpTmKXdcruurfvY5THQTtCrxI53IPw33iKF0lQl2gGOcsJj1OnOs/SPG8Ys9TYGoTNNpjtHmH9IZFHwijj2+AzVQK2giqYlT4kAQZelfZ3CImeD6Y5zhm5SYV9Oev+XIbH2tos3H5Sl+lI+IXNoykHwNe+zEGRS1Y1ol5aaBTd9U636XDa58jMAM4DaZJqzZdOYg8kR2cr4OApmjod8VX4q8mI10bTKa/auFn1dWyB4t6bHVn++Hmm/fidroYg0xGf9OCIjo+xDJCzCGeX95lkcY3lmzQ6opiTgtHJ6gOm2tAPNnG/1Rz5Twdd7ASr+PJD8B1YSi11hDR8f54zHEgtDqHueCmP5iquprzWMdBasIQS+/RZdefH3sK/X6jm+yFTq9sbFI6dWUOjsBfDo1pmmzThUTV2Gi8FIDaK3vvgOT6cUQMaZ34K8uRbYGZH3vJg3AF29OSgnCMo68VDGxh56SDZ9AdEmNqexVSjZ0jgibbqX076hcaTsE/XcUAbaHj+2uyo7sd5vwCvjZ1HgQyd8LAM3CzM6tDgEHTL+swjvGbjUO+WEPMIg/M88mJgxZ+7WqfFXFHopxdltdjCJQ3hDgmBYarR//rA6eJYElbUWX+0BJ4CCgbqrL3aXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5SPRMB0012.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(376002)(39860400002)(136003)(396003)(451199015)(53546011)(71200400001)(6506007)(478600001)(7696005)(41300700001)(83380400001)(107886003)(186003)(9686003)(26005)(55016003)(5660300002)(66446008)(110136005)(2906002)(54906003)(6636002)(64756008)(52536014)(8936002)(66556008)(66946007)(66476007)(4326008)(316002)(76116006)(8676002)(86362001)(38100700002)(82960400001)(122000001)(38070700005)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kNLjvXFE3yd7Ef8amPRK1Stt4nYzh3ZnLIDRXsCwa57LhxLWcb8d73o/QRzQ?=
 =?us-ascii?Q?ak5zV9cYzHxU/1DHW3uap/yJ+BLw7dqq6mdchX3sMcqYxgAsHNYvuN2tuKiU?=
 =?us-ascii?Q?fg0mwUAHu0Hdkqnsy+j/tdEiGqTf/bl3ruo9MdrZPglJkp2nHTDGLB7uGjWW?=
 =?us-ascii?Q?TsCjlp2g5XmKDgKRsCAqorTHKBcFJ9pf77mnzP7mV30FkhYw+wTTm4v7N292?=
 =?us-ascii?Q?/PvLVxgnfmjq3trZI8bCbmq0d6VcLdPiPq2EyJJtxRIwL5MnBptUWE4VcRLJ?=
 =?us-ascii?Q?EJw4bWQaIAb/k4MBLztuZ50HY6VnwWy4P00a1SWmwHe9qtyhSKKYgLziQhZl?=
 =?us-ascii?Q?g4WSSqPQCeepBRkvF67gEFp6UpF9zEroQi7AoZzrVZitTCGtwMtf+eZ2kyZa?=
 =?us-ascii?Q?D4Jg6L2wzJueN88xMqM5qr6IWJl+DaBCaqPIRBhgcLrY4PiSqNqubxj0Knem?=
 =?us-ascii?Q?y1r+qLj1FgspnfXkrmV3V514ZJ4dqlS4vdip4BESufDcYH5dVouOe4wN9Wjk?=
 =?us-ascii?Q?7h+RC2hkeSyiniGnvjJ8P6j6J/9f9eubppF+/1PIiAltioF0Bh+JuVFLEcqQ?=
 =?us-ascii?Q?c9r5Pq0afb3EtibtkRlb6FOpOd+YmSGaDnqh4q85/vDxVcxprbxr+Ts9CkYY?=
 =?us-ascii?Q?XYsKZ6Ik/FJf/ryPiaDT7Ih22TO/9F/RvXOKPOZsU7Ss4f6zYQg0dwoEuo+2?=
 =?us-ascii?Q?m28Pfx8+OAoIUCytGRun+4VDMXbojmq8Eqx752+qZ8QRXD2SMe3cV2425Hp0?=
 =?us-ascii?Q?LE+CvTiKPb+VUmPtoybUiebjHUXqoqz5Z+wRZk/lqc2yx+EfD712hIyOS/+D?=
 =?us-ascii?Q?u3pdS8piYNpJgxBC00jddd+Ax0fqpPpV6N88pEHom3KpUrUtMbqF/TzhhE9n?=
 =?us-ascii?Q?6lujsY9m0p/x5FAedsgCw/vwEDVmimrnTFEahANik2/bpBm2lMxXp+wZ34G0?=
 =?us-ascii?Q?gLu9fScCcoQtjM0jF2GGY5OjCY+o3hO34/u1iOfA7402u3mrgiWu4cu+VymB?=
 =?us-ascii?Q?Y+dW2taKAVsCDhH5U4P6UF96KPHbvvklQpUTGtUKdSnIq49XenKqZvRd2WYK?=
 =?us-ascii?Q?Dp1G8mnqq8qUkL5NfYqx4ij5jDs6ZkXbzD4ql5dNBdv7QBUm09JiMoaOjs9o?=
 =?us-ascii?Q?9X787ZrvcVIUwBEBW0nZK4WJn41RmQXb0UMmgaleXs0jNBwuzZt4T0gbK2Vb?=
 =?us-ascii?Q?bC31vmtMipBq4zLwaKjSDrXRQZ76CvsOwrrSJ86Nezs8p6Tmx/yiGJLcSKUr?=
 =?us-ascii?Q?4+TG8EiSVe2I/UCLPJs79vHJBDPLIxZhYYXLUSyI+8O7Wk2OWdm7y7sZvZmY?=
 =?us-ascii?Q?btj4K51MTPe14orauRiZJebEHR40cTBSbGOPEFMVPCHoDiEcr/WiLgLX74A6?=
 =?us-ascii?Q?PW9o+KGMTjjZuLbUgG8JZIPLFn8fjwsBfvk4nRiHjMDKBJ5Mh3WUirVbousO?=
 =?us-ascii?Q?zl835k/DDIFLlNzxv/m6Sed3oZR3Nrp6mOSMpqPyvcizjbXTMFBhBCqYoVSj?=
 =?us-ascii?Q?hwcrcAuCxNhhmNL9BYgjEOmWTdtnI+qriiE9NlOfWu635XENfVSE7cXQTX3Z?=
 =?us-ascii?Q?Zy3Ee+pwB5BwqgTGJfEqxxHU5z+EnfduFuwQG1f4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5SPRMB0012.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c31387-dd2d-4703-e63e-08daa155eafd
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2022 13:32:41.2678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7i6e/4JwNmLV0KM+IVik3+XsfZQt4M5AZfLrIeWUupfJcUGfP9a2sD+6Wl7Nvt8vGTFGN63qCCEPc4EfG65sPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6757
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, September 28, 2022 3:30 AM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; pabeni@redhat.com; edumazet@google.com;
> Jaron, MichalX <michalx.jaron@intel.com>; netdev@vger.kernel.org;
> Maziarz, Kamil <kamil.maziarz@intel.com>; G, GurucharanX
> <gurucharanx.g@intel.com>
> Subject: Re: [PATCH net 2/3] i40e: Fix not setting xps_cpus after reset
>=20
> On Mon, 26 Sep 2022 13:32:13 -0700 Tony Nguyen wrote:
> > During tx rings configuration default XPS queue config is set and
> > __I40E_TX_XPS_INIT_DONE is locked. XPS CPUs maps are cleared in every
> > reset by netdev_set_num_tc() call regardless it was set by user or
> > driver. If reset with reinit occurs __I40E_TX_XPS_INIT_DONE flag is
> > removed and XPS mapping is set to default again but after reset
> > without reinit this flag is still set and XPS CPUs to queues mapping
> > stays cleared.
> >
> > Add code to preserve xps_cpus mapping as cpumask for every queue and
> > restore those mapping at the end of reset.
>=20
> Not sure this is a fix, are there other drivers in the tree which do this=
? In the
> drivers I work with IRQ mapping and XPS are just seemingly randomly reset
> on reconfiguration changes. User space needs to rerun its affinitization =
script
> after all changes it makes.
>=20
> Apart from the fact that I don't think this is a fix, if we were to solve=
 it we
> should shoot for a more generic solution and not sprinkle all drivers wit=
h
> #ifdef CONFIG_XPS blocks :S

XPS to CPUs maps are configured by i40e driver, based on active cpus, after=
 initialization or after drivers reset with reinit (i.e. when queues count =
changes). User may want to leave this mapping or set his own mapping by wri=
ting to xps_cpus file. In case when we do reset on our network interface wi=
thout changing number of queues(when reinit is not true), i.e. by calling e=
thtool -t <interface>, in i40e_rebuild() those maps were cleared (set to 0)=
 for every tx by netdev_set_num_tc(). After reset those maps were still set=
 to 0 despite that it was set by driver or by user and user was not informe=
d about it. With this fix maps are preserved and restored after reset to no=
t surprise user that maps have changed when user doesn't want it. Mapping r=
estoration is based on CPUs mapping and is done by netif_set_xps_queue() wh=
ich is XPS function, then I think this affinization should be performed wel=
l.

If user doesn't want to change queues then those maps should be restored to=
 the way it was.
