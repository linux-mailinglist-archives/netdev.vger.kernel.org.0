Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8719C632429
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiKUNrf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiKUNra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:47:30 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA51FD8;
        Mon, 21 Nov 2022 05:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669038447; x=1700574447;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HoSNNoRJ3pWd9sNv0yBX8V8qsAQowGXUSA9d0hKJRgQ=;
  b=glXUdy3SqkzUWvV+/g+5EBZptMgKGGwJjxZE2DpitSf35np9CZerxiM/
   I2WPVZH6Gs+z5IztGWLrXdgtdFQSvc34RvNb264gkuEI7KbhPMEY0tSJH
   sieCBnhWNGdNeRxsoMv0RHWmuAiAupEwbDgUKtyK+Rrg0LGpIo+JhuukP
   i1E8o/blPD4AaZ1x+jtd/jBytanYZg4ouo/vJ5fd+QaxQyEo6UoxlN+98
   OWjP/rGeqSOhCabYkAeVzD2cjM9Kvq7oEniJ1gnEqSrjGs2b3QyMdMBWC
   Zajql1aqYKqCY8SHW0ooDmfMwur8X8FrIqAeWICi/V+/WcQKKjMuyXDRC
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="340418042"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="340418042"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 05:47:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10537"; a="709813082"
X-IronPort-AV: E=Sophos;i="5.96,181,1665471600"; 
   d="scan'208";a="709813082"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 21 Nov 2022 05:47:26 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 05:47:25 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 05:47:25 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 05:47:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R/txeyKaQV234g5TxygSyNq9kRb3ymzbBcWwzCt7AvUzfuwHUsVUlhDuM/QXwERQ7jF8AiddLk4EeYGWY4LkNhIrPoosoBQ4T2UaGwhys8WdVoiWJzVznQozYDe/m5tqGYlZtNzkEEUBgpIl28D1cMCV2hfZe/EjlNUZbw1zNbZ0rnRhxx6xkVo30Pz1IaWGI+v0LeeISwuz6XuategQq3MCp/bQAnB5J9lc23ibBsXkvABBc2Iex6Sct0SIXdO4ivgi4uLB1A3j701YeoI0CxDwtJ5p3DiI3hKe71/jYG0mlZch7ctYV+b+ALbk9iw0dmvgowEqDA4JN5u9eguqxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hTSAGdCm5Htj9+F6o5yUpsP25GuT0BkdU2HB4/RZmWM=;
 b=a2KBbS9w51+nCyaWivxnGkLJodQwZDS6jqRWhKb1mbSWgSqk6ObJcc/DkSPaQ1FlaWO7egDXsaB8N07SEQJZXfUOvoQcHGp2pKyxzlQMR01Cwp8aGhppy/oKzxg7r1HM2t7nATpKXEKN5LONUp1CYIsBWmOCDBzWXYcaKjOnnsUUx2skbBKgO+2aSyAzZ20GV2KeqftU28pYeVNJ+mnPBIlEKePSa9/vaKKKDdk0Req2L7VvRdm1L7p6HTMtvwORSiPJ0nqZuI36Ou2RF/etF3BWLXI+kosnFESaf9nRP8cy8Tfq6N2YjH8J2of65uyDY356+Y7zCVR2OQraVoVjmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by BL1PR11MB5318.namprd11.prod.outlook.com (2603:10b6:208:312::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 13:47:21 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::c9b5:9859:5a54:36ee]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::c9b5:9859:5a54:36ee%6]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:47:20 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Diederik de Haas <didi.debian@cknow.org>,
        "Bonaccorso, Salvatore" <carnil@debian.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxwwan <linuxwwan@intel.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>
Subject: RE: drivers/net/wwan/iosm/iosm_ipc_protocol.c:244:36: error: passing
 argument 3 of 'dma_alloc_coherent' from incompatible pointer type
 [-Werror=incompatible-pointer-types]
Thread-Topic: drivers/net/wwan/iosm/iosm_ipc_protocol.c:244:36: error: passing
 argument 3 of 'dma_alloc_coherent' from incompatible pointer type
 [-Werror=incompatible-pointer-types]
Thread-Index: AQHY+rpr+isg4xtGiUuyoCVpo/4Cu65JZxgAgAAAtpA=
Date:   Mon, 21 Nov 2022 13:47:20 +0000
Message-ID: <SJ0PR11MB500875E67568132D3D4EBCB1D70A9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <Y3aKqZ5E8VVIZ6jh@eldamar.lan> <2951107.mvXUDI8C0e@bagend>
In-Reply-To: <2951107.mvXUDI8C0e@bagend>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR11MB5008:EE_|BL1PR11MB5318:EE_
x-ms-office365-filtering-correlation-id: 5c5d5858-716f-4096-2993-08dacbc6e956
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0yTqn6HVE9eAyKwhoZtkWOpOgHnYyzOWNVjqVbXd1CC/Ve2VrTHrdvjo6VC+jV7lrsZW9SJoE8RMKYdz2vPjF6JLMV9+KA1sCaLwDbUIYqK5E41ixZ03ztpTwEgvDgeZaLD82ru6yYBiNoc//Zm/INsIZ4h+nmJypF5WmZHk1CL8jooAeX+vqUDg/E7xOgIWJ3UBxBiixyEgv8xVYiKPCRs3SSBHpxKpVmO6/VtQP3icMvOZdEojo2ih2DT7cDrRXzsQYwJZUs5516c5Z7UeQDfAyU/K0Vq5VwGGsNnLu12Wh4x3+FAdmTjyDeQF5/VvOUDIhkDa3VT7qrEBqGOISgghF3oGhaBmHoGWLBEi3wIxpNP0GHmKLk5twbc7SBM6EpdGNLhzdp+zvX2t3d16hF80p48x8AyfL16Co3yHQWXSQgdVvkZfXC0FS1aLYlyhvttgLejBVFm3OrwNVuU7MFcUERsvimAK8qHj5X1evSQYlNJ4fGnwMVdhJpvv+avkqjKIGdV/I2/0E6EtwA98cs2dnuC9c33RXo76lg3ThmQBLwJ6ybtAgnxXpEA7DxaZcydterTtC4OEmFwjOZ+wGOxc4TaqFNOgafj2jnedZgoysWsflMSe3xObXgHKlVlFn/AyH0Xqdb3MgI68F0nkR0pEcPChJHHf1nPzMSo9klRiCWxdjfjcBhnpJmLHMXthrm6bDAym8Y48pvyhv+EIivNaSsQgJnHbwFxhWkEhyfI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199015)(52536014)(41300700001)(7416002)(8936002)(54906003)(64756008)(76116006)(5660300002)(4326008)(66476007)(8676002)(66556008)(316002)(66946007)(66446008)(966005)(83380400001)(82960400001)(55016003)(478600001)(38070700005)(110136005)(6506007)(26005)(71200400001)(2906002)(86362001)(33656002)(7696005)(9686003)(4744005)(186003)(122000001)(38100700002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KKWJj1vvtLCnHeFRr7a49WUvmj27ipmN0PnjvnP3hQZ+n8lHaSiq7MZqUjUa?=
 =?us-ascii?Q?s/qlPVJHgGnLfVRbo2I5e+Ahewh1T2sfROH5fYDk1VjI8UhsLPC5V0NqnvLl?=
 =?us-ascii?Q?zhy9ASTDZ5S/7CQJgBQlC84IO82UoKJLP/HfVSTgAPyi5c+NTgtNQrJFq9x6?=
 =?us-ascii?Q?iEwQhcz1A2kdVkk3q6PTFSPDAd3DG7VxWUuF3UWsSxJctYKHe1vGUkm0Wjx+?=
 =?us-ascii?Q?0dQRcquIoPy5AIWJijMBG2tmq/VXVUkJPogBC1LWNkYjo4Ipy5DOdm9SoRUT?=
 =?us-ascii?Q?SdpOSPRRQ7X8vR7WTh3X3MWv1YZBM2RcMV+xZTinT05uF4Ju8Cz8ZJuRhuGp?=
 =?us-ascii?Q?wuHCY4Ux6TRKrPa20pA6f2JhkCxZPSpvMnEif8s+3hr8EghD5NVO84hJ25Cf?=
 =?us-ascii?Q?eKpAli1TMLrAAl7jMT6UJD3LASkzvxltfVbEyp8AfD4lo9qVxUxDaPPYSmeG?=
 =?us-ascii?Q?z/Wqksoa8A0l/nSeGKksfp//bmKRAJkxCIdsF5Q66HKcsNFT4Efuss7yJser?=
 =?us-ascii?Q?rQxnpy4qlMcxYDwsomy9KbuB3sj0Jn7QYAC+0K+7zoN5Cn93p+jfjb73gCvj?=
 =?us-ascii?Q?fjrjjEoTPNRck09PXUBgshsp1wKpZQBYNYc+4pGFN3hdo5Ri01sNKeZWN0ee?=
 =?us-ascii?Q?dmQ7gRBzgY+FpStJiBdEvOFqB6ERWSdY3/TsVvdUMgDhOtTkdWVgqHwiiHR5?=
 =?us-ascii?Q?/yL1iQ8dSzZcNMylNT+cAgDoUJJmafcfMbtk+q2ySbLag122N6tq/zWWG65M?=
 =?us-ascii?Q?CVVMlku3wbrhk6Ol6I0OkyaUn/Uv6y9AuTzQPbJHQvjVSgwwhCWTTQV96WTm?=
 =?us-ascii?Q?hqJI9m55xcQ8vB5wxvHIejKenGXsZ71/n6OLSjpCEjvzrumjND6bGoebFGzZ?=
 =?us-ascii?Q?r9wXHtcRJ0cB3sXdYg07vSbOvmpqXuXzYdqu6KiIrOFvrQRwtYR+iHP3MsiD?=
 =?us-ascii?Q?4s+2Vl4PzbZN3/kbY4Z6eSaf//aUTok8GrLgMhf5VHYjRiY3jXO3dcgUOlcU?=
 =?us-ascii?Q?Tp0uxBFA5o7HlucGYFv++YRDbpxeHyW2EN+Jfu/TWrIcZVyidLZftWXvTiIJ?=
 =?us-ascii?Q?Jb2MYpfcaH5c5Srsc64Swm/T645f6PXv8MTvLte4TsL+YIzHcnM8xMZi/qvg?=
 =?us-ascii?Q?ekBvvpgobrWyYgA7msI+5F7MZtJdV6F+KKx2CoozB9Cgh5nnmZ7CAQk5/43+?=
 =?us-ascii?Q?yCPSW4ypeXjFlk6JdOBeaFftf11TxzW0fap4nRHay7Wfl17dikxpKwiVcE6K?=
 =?us-ascii?Q?wZa3c4U7/Kn01IiSXrgBfwHot+uCDTJLd/JjLFrk0310Q0ckBxWNFEAL5+7v?=
 =?us-ascii?Q?M3oyByjXdN4QeE8/a9j2/z4iwI4tCWllDiCaSqWzprG+KNZyiEuQ0TQIHung?=
 =?us-ascii?Q?JHc0h7YDvkwu5UoU2/aOjnw+XFJxCBubvZRmocSQnsfy6anBq0VI0dG3Wu4c?=
 =?us-ascii?Q?0XXlaJiOXQJpGbrRb6grWteXuEMjSNitkKK6GPuQb+XY3BONHmod+hP22UR/?=
 =?us-ascii?Q?C2zTPTapmtnfzm3TzvlQ1e/oHFzOdSO9AWhX1uI+8Hpbl3vsdw2UwbifSgP6?=
 =?us-ascii?Q?7nrIoMdEM/93l6cn1xqOdM9tNuq4e2yPSeP/tSR6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c5d5858-716f-4096-2993-08dacbc6e956
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 13:47:20.4422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yBZO9264muQnxmQJ/mroM+SnJJpPeELdUqIOTWFbBO2VgozcRDfHSiFxgHPc/SRRb7Pmqh+4hfZTQjSYo+uPsmOcbOH1xxuI2VH/kwlx3UQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5318
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Diederik/Salvatore,

I tried reproducing it at my side by compiling kernel for armhf configurati=
on [1] but could not reproduce it.
Could you please share the steps and config details for reproducing it loca=
lly so that I can take a look at it.

[1]=20
https://www.raspberrypi.com/documentation/computers/linux_kernel.html

Regards,
Chetan

> -----Original Message-----
> From: Diederik de Haas <didi.debian@cknow.org>
> Sent: Monday, November 21, 2022 7:07 PM
> To: Bonaccorso, Salvatore <carnil@debian.org>
> Cc: davem@davemloft.net; edumazet@google.com;
> johannes@sipsolutions.net; kuba@kernel.org; linux-kernel@vger.kernel.org;
> linuxwwan <linuxwwan@intel.com>; loic.poulain@linaro.org; Kumar, M
> Chetan <m.chetan.kumar@intel.com>; netdev@vger.kernel.org;
> pabeni@redhat.com; ryazanov.s.a@gmail.com
> Subject: Re: drivers/net/wwan/iosm/iosm_ipc_protocol.c:244:36: error:
> passing argument 3 of 'dma_alloc_coherent' from incompatible pointer type
> [-Werror=3Dincompatible-pointer-types]
>=20
> The same error occurred with 6.1-rc6, again on armhf.
>=20
> Cheers,
>   Diederik
