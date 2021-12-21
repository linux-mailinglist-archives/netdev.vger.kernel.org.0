Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2211847C9A0
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhLUXS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:18:28 -0500
Received: from mga01.intel.com ([192.55.52.88]:28302 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234664AbhLUXS1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 18:18:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640128707; x=1671664707;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ckfWfCAzoMYLQTLkSuUy9kHDKTgg8+NmMdbWbTT7flY=;
  b=YTqqk13lK4QK6LQekoJEn1i4vNKO9tpwqG6LoRZWYA6c39HhI6+80LZH
   6kIvqjq0sg7E5Rsjttj1uOCtAQWqRPTMwC2S92myNt7uq4G3brxSJISaf
   sHlEowT1ldQAcIrpnMjYJEidnaPZR+uCdkEZAgVyawvR07ujLmXGFmd7E
   R/4sLsuRQWVoIhr71/DxnVmRarceIw/jqP1a265yktMkkzeEQCycdUS7K
   BNvC8uGhEvo7iTKztiAYvvQbVd8pzExzITTjFK6EXIj7IzMHXgfpdAoLG
   14P8u+XCRNGUSFI/fL0paLt4OWwvg2QZhdHepPk5gPsKFo3nP7nRmtgCO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="264702093"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="264702093"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 15:18:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="607218984"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2021 15:18:26 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 15:18:26 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 15:18:25 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 15:18:25 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 15:18:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f5Hhpa2tv1se8m34UGcha+Glk1C2hJA1Eh0bU5bgZIzdm7BxokXDt50yx5PZcBAe/lZoPK3R4jmPhMB8k3KxyfxomrXzXX5lbQdBdXQt8vZMsRgZ2PvXnHBpP7iG+NIL/ZnJamraCPto6QDUFjPc+xPNwRrZZQcVAVzOIY8HihYPYf+1yyHM19/X0COe5nSPSQ3/WOunAjgtq/KGrHGwF2GClZL88u8tOelIIugchDUWbT8Wv3xBNrtbBJNXUCd8gz3WSRJMeqW+5CSGNBquHeo2mS11cBPNjN4OMhGUkuVHaV/2NW2NeWFJHWHg+ToBjdxmmlKC4S9Tr2pk30yrIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QD10WSD9RZsQ4gPXmaae2gdF7gnt9eiUEdic4s0IQoE=;
 b=JS3e13HPG/nlk3DDOyj7ecn+a9k16/AxgK17P/mkHab9L6NZhqCt+jN27hx0mTKgSYWq1XrQIcJJKa9JKTbY/97TuOjBc/B5x/SEY11CfnOBkbl503ywWxXJBUf2i7JorCs3J6YClVOyCwrl56evXSNLCVwp67l79bmidP5jDOMrmWJMaTNeAQyLxsgYr1KyGg4HimpjRKWwdY1WDBIEglCLx7Vs/S1mXvD0rzSWkXQLF9WOJi73vnTHZgvWn57MBqM2v2Ya9zg+btcmtvrY0lgO/WOlo4oW3RmsceR0BKFUPbmcQHuBOtKk7ocalmP0S/8EBcEu4iECcv3mDxQCsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5181.namprd11.prod.outlook.com (2603:10b6:a03:2de::10)
 by SJ0PR11MB4941.namprd11.prod.outlook.com (2603:10b6:a03:2d2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Tue, 21 Dec
 2021 23:18:22 +0000
Received: from SJ0PR11MB5181.namprd11.prod.outlook.com
 ([fe80::71d4:f7b9:12fe:d9cd]) by SJ0PR11MB5181.namprd11.prod.outlook.com
 ([fe80::71d4:f7b9:12fe:d9cd%4]) with mapi id 15.20.4801.022; Tue, 21 Dec 2021
 23:18:22 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [RFC PATCH v12 17/17] dlb: add basic sysfs interfaces
Thread-Topic: [RFC PATCH v12 17/17] dlb: add basic sysfs interfaces
Thread-Index: AQHX9jdp8zCLYq9nh0Woi5QXeJNDCaw8if6AgAEJ7wA=
Date:   Tue, 21 Dec 2021 23:18:22 +0000
Message-ID: <SJ0PR11MB51810AC3BFBB39F7D0833F82D97C9@SJ0PR11MB5181.namprd11.prod.outlook.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
         <20211221065047.290182-18-mike.ximing.chen@intel.com>
 <4c0ec417457a16fd437f39e9b6d5bd7057aef028.camel@perches.com>
In-Reply-To: <4c0ec417457a16fd437f39e9b6d5bd7057aef028.camel@perches.com>
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
x-ms-office365-filtering-correlation-id: c679b9f1-2847-42bb-6701-08d9c4d82e97
x-ms-traffictypediagnostic: SJ0PR11MB4941:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <SJ0PR11MB4941E9C8FC7B2E63E3CB1552D97C9@SJ0PR11MB4941.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EaxrtXtzNYkHLL1YBnZFiDr/oQeZpXEHfoHKac8U3tpH9wCRLKyVtZPMhf8rbAyQd5xI6c+ikG+vZTUH+SMdTdZjtVEDsHksbkSuz5k3rUy8dHZl5kr55NNC/m2rVv606/tbhv93XOncVup3C14/NsQSWN2hI2DDAG8Lx1rCFhpZORGaUE3SXxD2cA5DWz1KeM3dqiCb+Nk3icg5N3fLPoLZBZrnzU3XnIjmYyz8V99BMFMa8yXzKldgKXT9o52TuXMhfpLuWPNdtpQxP5rFjvQLewC+43ys34Jcqr8f/iS12XnfFmiTbgiOz7I3jMXla07QKSn9rapKrCVC4CZAJfhiDrpeIU3rQTG2bOsoET3SVKGxwDAppSM+2ta+FRPWCdznDLNUfH3Q50u4PvC3xJ2D4QUDZUI99ivc1KP4T5vAoQLb5T7Yndb3cgpgSYUKZKf2pDTcuQl2FNxtV0o2Tw5GygcCXoarKxWePokBoQoIWZpaFF/sDs/ZXAF19kVAzS8YyinIjULDKWFof9hu7tX0ZZZ6Ks7Ih/T9mcBXgwGi4aNaIznTIlHecypjVWTmvzYyqaUUfF4xGuTJzhwZvaXyeylsVNElJ55WBC4IwRquelI7NfXU3XhvM06yuYn0zczX4PhXd3SVLXlmjDsWoN5HuXm1aXoj3IjGKW2qMvJWWuvVD2f3x3Gj2sr56tqFTyBNi1VgP8vDK2W1soHgZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5181.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(8676002)(8936002)(86362001)(7696005)(4001150100001)(53546011)(316002)(6506007)(38070700005)(33656002)(82960400001)(54906003)(2906002)(110136005)(38100700002)(83380400001)(122000001)(66946007)(64756008)(66476007)(66556008)(4326008)(76116006)(66446008)(508600001)(55016003)(26005)(186003)(5660300002)(52536014)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/+c4j9/k3Dp7B6B1gyk//GJAYxVMcfI7KJfhZpgFCTxbyIJ9NMYer9l+e9Zc?=
 =?us-ascii?Q?OKSnWphOpribRY1VuicA1V5BM6GtAiPyxlLinKCWa+E2mSvjsI/YBOqZ+BY/?=
 =?us-ascii?Q?h5H1+VeDkc6cXGLnF4609x7KJA0qmhKSaLDPJXxE6u1FJrswlEx5KbKZMn5y?=
 =?us-ascii?Q?nytBbQnD5Fwh7lIzLrnHSnwOB8wgaDorWuH2IKcAzTBEU3YcsQjKnxF31jUU?=
 =?us-ascii?Q?QjW43NJSU21RHP8D2w1ygdZwE64DW6XfuNPWG4btwBWrdL7Ko4r2C/tEt8Cn?=
 =?us-ascii?Q?4fMEyihvXzjY1TVzfjpqnj56f39dg2SMg8ssglDsCB2WtjQr80jRhSAPutnZ?=
 =?us-ascii?Q?IeXrsuMmvw1svh/2Ii4ma5wlt408mEYN/jaaRLd6Rebt815UrJZ50ydMrTso?=
 =?us-ascii?Q?hWMa/eKV+kPKd8Sf6ti9/WvmhxF6KZbvQozrsHwsp1hjPJWRE7HIAEJea4Ns?=
 =?us-ascii?Q?sTs46OdrUjKt7ersa7dO3x46M7ptZIq+fe/yv9yy7+GSEk2unS4SJhCWwG9X?=
 =?us-ascii?Q?FZlNbzFsXSs6655EeUgThpHOjNo8L7LmXUCxJbbZez0muPVcZxCWQjOOYoGE?=
 =?us-ascii?Q?oRQ5ievemrVOcm3e/asJOjhofcWbKF0+pn2QKUW0QUEiGgMjl7yJF5GT554x?=
 =?us-ascii?Q?WVp5w283kVwWuwvmx5JguA3xt9D5RZW4PWXNECkRT1aXNexIOXi9jURzpyD3?=
 =?us-ascii?Q?nhZ/O6RVaS+dtmz7TzeROf8sps1fv8tgLmGICqkJN9VJSIvsdo/8DYfI8nzV?=
 =?us-ascii?Q?N72Bl23UE73p8JGqq+BnQj5LO42ZpqwLQKhG8G4pjGhCQ1DdI16btB5QkUx1?=
 =?us-ascii?Q?EloaYQqsZ3fIqGWTj53UoymkhOENMpKvHgCfK4CZ4knLTwyjKTXFCPjay/1f?=
 =?us-ascii?Q?u75GN0ZLPLhMs24HRTkYnavgn4qKggC2klnSoYt/bZoXRtFr88rmKgJUmpbA?=
 =?us-ascii?Q?gCKLGJ6Di+VlFrsRy5FYxJBysRFOOeYwX4zHAW8kyguDB9+Scztizl9Hw3Vx?=
 =?us-ascii?Q?1iPTkPtBGXCzARQHcPxHRqpFt0D+OxOQq2B94mO82JRE+5wWdNAQKrT9TkoP?=
 =?us-ascii?Q?tzpj45uECmXEggMi1Qcd2N/1Pgi4GnYxItuKRrmSZTBQIuR/phoq917krjIN?=
 =?us-ascii?Q?4kehx8+GFiJjSAlBC1FGgJ52Gc3s1y7YCKH8Re5EV3ypGSj63ePyyV8FZTQg?=
 =?us-ascii?Q?Wxb8GoHHAq3J3t4QwZwyem7WpNyCivyxrIz1gbh0+7jq/0NwnKcfcAK8SK2F?=
 =?us-ascii?Q?6y5zF1p03dwfj7zJkVTXfQrJeVr9Fz2cqr3mfXU0hj6Gj/swXuT8DtwyLAB9?=
 =?us-ascii?Q?bPD0Tz+WbpJ4j7xcsZeKk0h6uFmPi8XpoiOxTjQuS+JWwU6snmmdKfCYFqoE?=
 =?us-ascii?Q?pzd4sui/FqrZ477onwyVBiX6VThBNPOz2lU+4pp2wm9GcwQd2Ipig/L8pdTK?=
 =?us-ascii?Q?KnRv3YJPPfff91aNSskfo6uVahKpkvSOiFWCQBVqWtpWnAtreBbwvcAgqBtR?=
 =?us-ascii?Q?L6+0qIhNsgZd4r7Zc0v8+20d9nb/Dt6FEpzRwJ5mPjcodh8tsMPnXndQhLlx?=
 =?us-ascii?Q?bITSf7FAHXmuEonHgt4KODQ8Np+Z3PXVbrHfokdWWTn9/DDsbjCgMZmCWK3c?=
 =?us-ascii?Q?Lk1sdxYrJTNlc0xQHLMO5oIHrLJL4Wr3ZaOB1EtsCF3jVnNOOnEL/rJc5AhJ?=
 =?us-ascii?Q?sw4pzA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5181.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c679b9f1-2847-42bb-6701-08d9c4d82e97
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 23:18:22.2040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cT4e2s2ipmQNBNksSPVVBoiUUY+cPAZBPd3A+8matl2Rju3pOoB7E+DR/nrRajArwqPFjkNn8pebrpIIpvfF2TDQM2AhAB9t5oKi7mE9mYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4941
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Joe Perches <joe@perches.com>
> Sent: Tuesday, December 21, 2021 2:20 AM
> To: Chen, Mike Ximing <mike.ximing.chen@intel.com>; linux-kernel@vger.ker=
nel.org
> Cc: arnd@arndb.de; gregkh@linuxfoundation.org; Williams, Dan J <dan.j.wil=
liams@intel.com>; pierre-
> louis.bossart@linux.intel.com; netdev@vger.kernel.org; davem@davemloft.ne=
t; kuba@kernel.org
> Subject: Re: [RFC PATCH v12 17/17] dlb: add basic sysfs interfaces
>=20
> On Tue, 2021-12-21 at 00:50 -0600, Mike Ximing Chen wrote:
> > The dlb sysfs interfaces include files for reading the total and
> > available device resources, and reading the device ID and version. The
> > interfaces are used for device level configurations and resource
> > inquiries.
> []
> > diff --git a/drivers/misc/dlb/dlb_args.h b/drivers/misc/dlb/dlb_args.h
> []
> > @@ -58,6 +58,40 @@ struct dlb_create_sched_domain_args {
> >  	__u32 num_dir_credits;
> >  };
> >
> > +/*
> > + * dlb_get_num_resources_args: Used to get the number of available res=
ources
> > + *      (queues, ports, etc.) that this device owns.
> > + *
> > + * Output parameters:
> > + * @response.status: Detailed error code. In certain cases, such as if=
 the
> > + *	request arg is invalid, the driver won't set status.
> > + * @num_domains: Number of available scheduling domains.
> > + * @num_ldb_queues: Number of available load-balanced queues.
> > + * @num_ldb_ports: Total number of available load-balanced ports.
> > + * @num_dir_ports: Number of available directed ports. There is one di=
rected
> > + *	queue for every directed port.
> > + * @num_atomic_inflights: Amount of available temporary atomic QE stor=
age.
> > + * @num_hist_list_entries: Amount of history list storage.
> > + * @max_contiguous_hist_list_entries: History list storage is allocate=
d in
> > + *	a contiguous chunk, and this return value is the longest available
> > + *	contiguous range of history list entries.
> > + * @num_ldb_credits: Amount of available load-balanced QE storage.
> > + * @num_dir_credits: Amount of available directed QE storage.
> > + */
>=20
> Is this supposed to be kernel-doc format with /** as the comment initiato=
r ?
>=20
Yes. Thanks

> > +struct dlb_get_num_resources_args {
> > +	/* Output parameters */
> > +	struct dlb_cmd_response response;
> > +	__u32 num_sched_domains;
> > +	__u32 num_ldb_queues;
> > +	__u32 num_ldb_ports;
> > +	__u32 num_dir_ports;
> > +	__u32 num_atomic_inflights;
> > +	__u32 num_hist_list_entries;
> > +	__u32 max_contiguous_hist_list_entries;
> > +	__u32 num_ldb_credits;
> > +	__u32 num_dir_credits;
>=20
> __u32 is used when visible to user-space.
> Do these really need to use __u32 and not u32 ?
>=20
Will change to u32.

> > diff --git a/drivers/misc/dlb/dlb_pf_ops.c
> > b/drivers/misc/dlb/dlb_pf_ops.c
> []
> > @@ -102,3 +102,198 @@ void dlb_pf_init_hardware(struct dlb *dlb)
> []
> > +#define DLB_TOTAL_SYSFS_SHOW(name, macro)		\
> > +static ssize_t total_##name##_show(			\
> > +	struct device *dev,				\
> > +	struct device_attribute *attr,			\
> > +	char *buf)					\
> > +{							\
> > +	int val =3D DLB_MAX_NUM_##macro;			\
> > +							\
> > +	return scnprintf(buf, PAGE_SIZE, "%d\n", val);	\
>=20
> Use sysfs_emit rather than scnprintf
>=20
> maybe:
> 	return sysfs_emit(buf, "%u\n", DLB_MAX_NUM_##macro);
>=20
Yes. Thanks for the suggestion.

> > +#define DLB_AVAIL_SYSFS_SHOW(name)			     \
> > +static ssize_t avail_##name##_show(			     \
> > +	struct device *dev,				     \
> > +	struct device_attribute *attr,			     \
> > +	char *buf)					     \
> > +{							     \
> > +	struct dlb *dlb =3D dev_get_drvdata(dev);		     \
> > +	struct dlb_get_num_resources_args arg;		     \
> > +	struct dlb_hw *hw =3D &dlb->hw;			     \
> > +	int val;					     \
>=20
> u32 val?
>=20
It should be int. dlb_hw_get_num_resources(() returns int.

> > +							     \
> > +	mutex_lock(&dlb->resource_mutex);		     \
> > +							     \
> > +	val =3D dlb_hw_get_num_resources(hw, &arg);	     \
> > +							     \
> > +	mutex_unlock(&dlb->resource_mutex);		     \
> > +							     \
> > +	if (val)					     \
> > +		return -1;				     \
> > +							     \
> > +	val =3D arg.name;					     \
> > +							     \
> > +	return scnprintf(buf, PAGE_SIZE, "%d\n", val);	     \
>=20
> sysfs_emit, etc...
>=20

