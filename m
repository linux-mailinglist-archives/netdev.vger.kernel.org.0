Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22205493AAA
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 13:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243866AbiASMyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 07:54:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:60748 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232897AbiASMyq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 07:54:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642596886; x=1674132886;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HsBNXF1Neo+VKPSJeaMnfu5UzOOXS4H7YgH9m820TrM=;
  b=OHcewzDlR+MndspF8lotRtOAu+Eqrbym8VRbT6FuECsTWUo77hvGdaGh
   30N0IQYv55nURNPdkCA+YpXNvHTN1sXQcCTvysg3J4Yk8S9fXosM+Xqk4
   QEwFHYuZvO0tHABy0R8JBSWb6Sj6PG5NVhZydyiLFXW8hWPKjcPlfmI0v
   pm8+QYAkzOo6F8PX0XPpKz522/XeHgQcSg4CnR5+NiJ/41YJFZuD0nkIB
   957fes5kMaW1keOFOhS6oZCl8DZtqKh9jS1nv+iSCrX2edE9uNlHyfV6S
   Lx61JqrPXnWy+/qaYvLozLqv3FUTsVHGly/Mgdle349j8g8z5QAOlboix
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10231"; a="232422184"
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="232422184"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 04:54:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,299,1635231600"; 
   d="scan'208";a="493018486"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 19 Jan 2022 04:54:46 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 19 Jan 2022 04:54:45 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 19 Jan 2022 04:54:45 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 19 Jan 2022 04:54:45 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 19 Jan 2022 04:54:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSBkzhl2EdQqdNgCbltX87tb+VPC3IIj7WJkrJYxtchUy6AJlA7hOaIBDO1784PoglqF6y1xnY51/fXUJobRCufPCZrc5c6Wa2M4UBBA1ETQcMBQzAUsm8qBtvKHB2XMbMlLvRoIh8B6LStsdUjIL8ZQjY4F+ntWbV95XRDmr6xfPBcs/D72QLbtxUYh1oHwZoySK9Z7jkMxob3J1MX8BL5MZtzslloKBvnqAFjy408FZYSyLRHe+gEooM83EA4MRtG0ndOjMneDgH/5ZqFBAlBIp/v8Pf5+yzQZ5JPU6GPD/zM33WLB1iMfHZMp9x+l0aXGuyn2PPbFFDaWLb3Ajg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k/AhxZsSKwaKXAaWEXg5Qvl8gLTshV8XYRKzIm0nG7c=;
 b=OdoBpcH5fWnydylbc4P21RoPUyc38WkWsz37/IqfzGBD+xC2H0IbtnZvsXKi9dPjXH4JXZAczMWwuO9drSsTvhvJNIPW/fnR4kulf86ubkiR6394P6Ea6QIkii4N9q6n0wMFy65ne628YEwcaztKgmHnsZZ16YTjCckSCqgxdi8bJiDSZs+2bXz7S4k34H0ueNUeFD/waWkGNxpsPhkLtu3G2SYNwhR1HYxCF9zQmJHngHAS6N9/WF8h7YNpv9vTRkHsBNFLaO+RMAkjXrQJsRve11h2hcoDJvcIDoLjjkw/Zb+tqWARTkwD0PYxG83NtuzAhE8wcDo+20Ko1W4H4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 MN2PR11MB3870.namprd11.prod.outlook.com (2603:10b6:208:152::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Wed, 19 Jan
 2022 12:54:41 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::fcc9:90bb:b249:e2e9]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::fcc9:90bb:b249:e2e9%8]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 12:54:41 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] igbvf: Remove useless DMA-32 fallback
 configuration
Thread-Topic: [Intel-wired-lan] [PATCH] igbvf: Remove useless DMA-32 fallback
 configuration
Thread-Index: AQHYBYjhQEW3+lq1qk6BWFQCzhhKr6xqXDyg
Date:   Wed, 19 Jan 2022 12:54:40 +0000
Message-ID: <DM8PR11MB56214F1217ED05D3EDAF7968AB599@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <dc75b24883381a060eaad21cb0deffb5a027b05f.1641753812.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <dc75b24883381a060eaad21cb0deffb5a027b05f.1641753812.git.christophe.jaillet@wanadoo.fr>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e70aac96-3fde-4119-df57-08d9db4adbbe
x-ms-traffictypediagnostic: MN2PR11MB3870:EE_
x-microsoft-antispam-prvs: <MN2PR11MB38705FE4C9DC6ED71B1B69E1AB599@MN2PR11MB3870.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T6im9y/eGwC47FBdPTX775jqkCHwZalgBqs42vwOlhweUseUdvq6/gAS/Co+UhBW9XkvztXBHGVL75OFOZL8O4FIcCa9X+f/P+kcAyhqKuGXZETKDLlPm7BxDmnIXmnX/4VFPTpetThLmy1RM594QmPRLD0bWd+vBI0R8YZlGUP9a5HQLgETxgQ688T8WFGXV2ICmX24BDTQYwggguCtSLKwcC1T1jd1cAWy/FVhbFTjDzvSCmoO1ir+pN8eowNl3Y21I3Ox/2PUdihOztP//clV8qmhLG8p8X+n1BEJYfc8nO9/zlI1x45OLyCpG8/aadblrV42rKA9WAXFwkR6OTp5vbPsMGaCj7clOFqCuoFZiUcIcZQ7CFySOET9qB2cr9xnzhPI57EJXazNsQQGPahpbyPlbkKn5orVCpyO7XB36xiWCRk93O4u3sbRor6Kl544//gSGWZtI+8EwtfN4ZCMWD814SAva+fEr/rsRcdD+itYkVkzeKNFkbjAxYjqO8c3qCtLwpU99HRIoNCoMFAXvFHqzKSZkerZM55DWHkReZM0aveuUwlWwHY2OSeuKObn3UGt9lDXux4syofXZKTcwhc74JBbLqHp9t/71V3LEAz3uOhePEEKwhziHKkD3cC3+/inQdCFH6lWbPmR8aBU4frhsac0Wvw9e/Ld9P9hoIaVEHswPr6MpxGPTqcN4trU0meRtoR3OIdvwVItRSCTrhPK/5oj01VRXAfVW6JiOsAG1mTEO9bWLV1B6WB0i4vDCoXPovNbH22OvKc1RdyE8ZtWWwRSQYNGb8hIJJY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(4326008)(110136005)(54906003)(7696005)(86362001)(38070700005)(33656002)(122000001)(66446008)(2906002)(64756008)(66946007)(76116006)(82960400001)(508600001)(8936002)(966005)(38100700002)(52536014)(6506007)(5660300002)(55016003)(9686003)(26005)(53546011)(8676002)(66476007)(66556008)(186003)(83380400001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hiXRl2tMUf/BFOddFqn70xSBIjgd33nfyaSlkgwpGUY9YONoPdwt84v7gehb?=
 =?us-ascii?Q?p8W/7i7TpRref7flMsbLXB+RIlAhrTBtUVobvbAZEc6IcOCY9yInFZDMdqKR?=
 =?us-ascii?Q?ZMW8uMB3iFRrUwB7EVsL2qcK615uXbPakkFj8D8bPRKVbTHbBWY1G/w57S3Y?=
 =?us-ascii?Q?nxK0S20RC2FBlOuuSS2S2a1M44gh0XhiVDvUm4eDoKRdg+OzFQvmcv0YFMQe?=
 =?us-ascii?Q?IV191/yYq855HUmJzcnFpGm/LfLBMWO+HhCUOB7ZopUM9utDh2PmDcy4+c4Y?=
 =?us-ascii?Q?CM8ePi1fnLjbl7abZzyOVWpIvgxBuWMwoWWAH+QKVm1ZiWisqg5a4y0Jv300?=
 =?us-ascii?Q?TOfhmYEYv+QhEU2Bg6fecO/Esez3c6AgL5qfu8elf63A0iI3+0A5Kc7OQIsx?=
 =?us-ascii?Q?DswGZIcGaBQ4Molcm7/M/gdGWM001gMAKP8yqF1RvF/Mac8y/G3HaeaUKcAZ?=
 =?us-ascii?Q?kSIXp5gPDlA7EU+pRgq0J9Nacl8TjGsQBNNcGXrqvpjgar8sE3e0yh9V/z4K?=
 =?us-ascii?Q?sYg6cce3Ao/2NhHYJADRtUXvVd5vge+vaZYdk0MvCiMBf1O0pZjs4h+B4NhN?=
 =?us-ascii?Q?rEXpeWYKSCDU8CM5ZHphX6xnOAeequj1TNmK/x0H3cW9VSMjk2N6J7+mXh44?=
 =?us-ascii?Q?UTdXGo19coZMmBsEUDHOZCOta3kmS6ZFg7TOtONoO6FMp9Aph+RkCbaTRstw?=
 =?us-ascii?Q?SYEd1gBWvV9S7bgkzU0qqJ7gzVRSE0aYaoMrti+7veTlycHKj6NTVukHqsGr?=
 =?us-ascii?Q?XxQZxw8UUPl8i/il5FciNwtAa18Hbx/5NcM6ziKygNIEkoywEB45kWOR6uhR?=
 =?us-ascii?Q?Ggi4e0g9ISNOWSuXm2GKpQsVm9eKsEWGqdpGdHzjX01zp/UGw7I2o1lIgj0C?=
 =?us-ascii?Q?SxkKFLpF1vxAOYF4TIRNG+QJ3Ydpv3qmQWu8p5nbda9jyh2/H1WZ4qZ0UXVx?=
 =?us-ascii?Q?3RshryM3kGK2BrYAHush8bVBhJFNcgY6NUbyLm+uzZKeFjIiENR2P7tDGOf6?=
 =?us-ascii?Q?MMRUIBqFTmllksDPa4BdlVTwKgGSlwzRV/zibJcz3WrHbWs6/eJes34u0XMG?=
 =?us-ascii?Q?AiXrhP4IA1uvEStHVDXwA1uK2btfhuLL/bd3n/87qLk67eiMS6i3t1iq0Dev?=
 =?us-ascii?Q?NL0rrePg4bQk5YXLPGdzI+tshuUT0p5PD3F2mFzK0e0kfuoR64kqv3uyKJA5?=
 =?us-ascii?Q?dCf7IsUgfXAnnIlFazRr5aC4ifOtnzVsS3wq1a76t6OLwFXK6XIyRHFLww9U?=
 =?us-ascii?Q?Z4CjJq/Vja/4tMNemkUMI5+RoG2i8CqFYvRJYvIwBl6DbR7e+p7gakg0t0wL?=
 =?us-ascii?Q?z84d1XiU13SDDYEyNJ44PS68gjD3WyVyRC1gstY8EH4Q5PGjmZIs5DwvIOLh?=
 =?us-ascii?Q?Sy69+DjJdFcyQz8LUPAMPmbNF2CN+VsDBYMWgIOHxct2J20Ok8qcAJwKLcWN?=
 =?us-ascii?Q?QJOndwiKcVpCqeZLtW92zFcPzc39wyZhoooDerq65LuKYv8N2KzYgjIaL4jz?=
 =?us-ascii?Q?SNWP6LQp8HhtSGlct70c4vVLCu7v+2NxGT5B8NvSQVrIK8FS2BGXza2NT3Iq?=
 =?us-ascii?Q?iEdjoXkWBVHu3fWh2NG34It6mv+sr8X/Jzoi970ZGQ23dwfyY1EfiqvaE5hJ?=
 =?us-ascii?Q?nykfuuNKNTRhacjJUcByOV126t9DPq5gV2F0FMIkKwalzcQIBluhHx9BN5iL?=
 =?us-ascii?Q?0HV0jA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e70aac96-3fde-4119-df57-08d9db4adbbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2022 12:54:40.9324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WbII+tHjLifU87mu7TknBxbK5J5YIXbQc8htnbAx9xzbLdQLCMd3s9zlPzXHQGTmE7YvwkPjEMrtEDZRwduzO5F8Zih3MuVgpKmVwaMmN0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3870
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Christophe JAILLET
> Sent: niedziela, 9 stycznia 2022 19:44
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>
> Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>; intel-wired-
> lan@lists.osuosl.org; kernel-janitors@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH] igbvf: Remove useless DMA-32 fallback
> configuration
>=20
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
>=20
> So, if dma_set_mask_and_coherent() succeeds, 'pci_using_dac' is known to
> be 1.
>=20
> Simplify code and remove some dead code accordingly.
>=20
> [1]: https://lkml.org/lkml/2021/6/7/398
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> This patch was not part of the 1st serie I've sent. So there is no Review=
ed-by
> tag.
> ---
>  drivers/net/ethernet/intel/igbvf/netdev.c | 22 ++++++----------------
>  1 file changed, 6 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c
> b/drivers/net/ethernet/intel/igbvf/netdev.c
> index b78407289741..43ced78c3a2e 100644
> --- a/drivers/net/ethernet/intel/igbvf/netdev.c
> +++ b/drivers/net/ethernet/intel/igbvf/netdev.c

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
