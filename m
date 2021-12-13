Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2691472D6A
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 14:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237638AbhLMNei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 08:34:38 -0500
Received: from mga05.intel.com ([192.55.52.43]:25004 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237656AbhLMNeh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 08:34:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639402477; x=1670938477;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lk/k2oFLEiNbgcT5WlxyTklRlvVBRwK8t4IM5qqeD1w=;
  b=M4OAbHX+bYuiGIgKjBQt7I/r3EBqTCdop5mEywl755ngdRB1XgbqV0Mp
   nEThB0vXM3vKX0CEkESwdBgF6gJpYyn/9f3tc3hA3lmJflE3L7KwTh7Ml
   V7eAiNJB3hLU+l3AJlCTUs2X/pZqMsSKbzeUWrf9dGq0qGSs1xXIecQ7k
   7DAW+03skLAaly1VM7zjz7xb04Mta4xPrxuI+ohQiL61hZFnEzVbq9hFX
   2hQvogWseyKIrgzgYgUEtHf6zJFfn8nYqba2zCsxHnDMluBOyC0evkwls
   vq6aeblfHlyUxgZH/4Fe+MnGWZDdTjYJFtkK9q3c6CQjC3ioNQjw0DCvZ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="325001826"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="325001826"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 05:34:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="464632239"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga006.jf.intel.com with ESMTP; 13 Dec 2021 05:34:36 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 05:34:36 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 05:34:35 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 13 Dec 2021 05:34:35 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 13 Dec 2021 05:34:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jUkQ8yMKMXrUL0DUzq66ukIM4jKqqjbi0GlFJTZlBi8aNXieN2dI5j0GuOmzMHHUwXSNd/FOrZKmYSGWv1U0dW7tPW9vu4u3qZjg1xWYLHZIyFcgK4N8d5uMwNvjfwts5zJM30ZUCz+s/rtonZsGdfMVMp2KHGCVx1KqueX9DVffKz1m33hlNsq1ETbI5hHpvGPOrNhc03fdclbbrgQmgwwtdb2qtPMk+BEcfEhTs3gILlaqIwbvoZ/iuOZlz5iCI4AJYQy8VMxqu5xoYA91tmDptJFPnaYcan0lLFgEFbGa7P+5H6A2yHz1naUGKetWwaThsjEm8YBCeMbPnu3bwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zOsbNKS9VF6/ZND6elpNug1dF6r5VMlR3GAs+Rpcuew=;
 b=JsoN/Sv7z6Fwh9UDAtfqhjLH7gWiQx3FoRllJjhRxaPByAiLPRW4/MXZEkuZKRqU0S9zjZKzgVzhQD2+y4NQOktsTcYSUdno8CfL/srUQrPnEJCEJKGs4uLWCiEQnUzCQOvck4bCjxuaOhsGfAc3ZRYzk2Gfp0Gbtfd5lLeP9YYx5yvlVazP1mAUvfVkJYK3ADynYeNxYIkvqb4LGcmmnJOfvrwDrS3b8Ao8u4mGVyoU6Dmf+OPUYAP6xxq34OdPnLKHfIfYaWihNuvARTlfH4U2QTIQZI4+SFGa1aOderwQaB4ckL7B3tDSN9tt710WOafx9iLfzDPSL4Jc4zZXvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zOsbNKS9VF6/ZND6elpNug1dF6r5VMlR3GAs+Rpcuew=;
 b=wjQkwmUitvSEZdeuH6ESbGRHtlO13UTgHUybPD041BRReMOPcFOMQGZQdhwr89nNGm22Rpfh+HbRsEmRevOMrgAxPI96d8XVhMVHjoS7PPiTLdA1S1bRrVbXp/DyqYpbjyqiaiWr6LpDSI+CIfzbB7NokhLKlHD9iqLqJYFUN/s=
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 DM8PR11MB5606.namprd11.prod.outlook.com (2603:10b6:8:3c::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.12; Mon, 13 Dec 2021 13:34:32 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::3114:bfaa:f64d:684a]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::3114:bfaa:f64d:684a%4]) with mapi id 15.20.4778.012; Mon, 13 Dec 2021
 13:34:32 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Palczewski, Mateusz" <mateusz.palczewski@intel.com>
CC:     "Pawlak, Jakub" <jakub.pawlak@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net] iavf: missing unlocks in
 iavf_watchdog_task()
Thread-Topic: [Intel-wired-lan] [PATCH net] iavf: missing unlocks in
 iavf_watchdog_task()
Thread-Index: AQHX1gsBBv+yKWcxMEeWNVvnAZqpXawwoB+g
Date:   Mon, 13 Dec 2021 13:34:32 +0000
Message-ID: <DM8PR11MB562120FE054D26F5E43475ECAB749@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20211110081350.GI5176@kili>
In-Reply-To: <20211110081350.GI5176@kili>
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
x-ms-office365-filtering-correlation-id: 5987fc82-260a-4b60-4980-08d9be3d4bf4
x-ms-traffictypediagnostic: DM8PR11MB5606:EE_
x-microsoft-antispam-prvs: <DM8PR11MB5606397FAF99451E7E13C842AB749@DM8PR11MB5606.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M7YuBEiDXTzsK2csGUjAYb/yazwL5e8O04/F6GCor2z4SHFaTOCkmW/MyFfdTToFY32QYAz0mvDBKWd38UvAzz+UX1BamEUyEzHfuraCWpqG4ZSBEx3PxNCTmTjzgdH2g/F57exGaurDp9IKjgAN3XeThpG/sIi5b+60RDfYdU8sElkRza0ELpqNdw+0d9vjXHtr4lffDOBaDRD3nd7UHMHPjIrFvXeEQZ5TZS3ufRtGRmQqRTmJIl/ziwC9F3HJ87OEQa9brECfZPr4jx3OMPW7Ua/6LfawO8g76d8lcMVUSQXJvCFo7pxxIYc3wQIFWQpwEieWwU6/Fk9shg3tLGqlQeGI69AlXZ5efjlQ17wbqm76Lln7y7B5AP3LCitBmvL8/zqWhEyc/UO8Gg/57/cgyQZQLjUufJIiZ8qEOw7Kmqc5Mn3zfXLfczb41E2oVrII4n0mZSRH7PBGpXUncCeaPbNPwgJSPCc7LpPs4/Yhr4ytcTQ1YdpVbvjINCiI4fELviyDA/kkUrDJiI4FAn+IliAxYJh42tf24+alao8ZGPklHXBbYKlzbDcVx262BqwNg+Cqf2XRKIsqAjEDyJ0hbr8pxXZtlFa77SnQkOEWCHVnp1Rgbw+ubgOnMOMyoQcbd1rVLq6TiemrO2TSlhA+xGH0amSI3364Vu9k1sDu9HqOBEtENl+I7qpQnKWQIysR8mT+8AeAlbPOXvY9tQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(83380400001)(66556008)(8676002)(66476007)(71200400001)(76116006)(9686003)(66946007)(64756008)(186003)(66446008)(8936002)(52536014)(38100700002)(110136005)(6506007)(316002)(4326008)(55016003)(54906003)(26005)(86362001)(6636002)(38070700005)(53546011)(5660300002)(2906002)(33656002)(82960400001)(7696005)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?Ipw4firE4ZrYaqH2Pmnc3HNFMIGBwyTP44C+TWUlhx74s9L5FR4oS0WlLY?=
 =?iso-8859-2?Q?fslfh0CCyxOqbyZZ8goGf/vuwYxoEYkson+5KeFL7a3OpseA2r8hpY085m?=
 =?iso-8859-2?Q?oKdKDRvw3gWzbt+owcLi5DNuTxuZ7nXR8rfbI3HlJuI33CILKXqkqlK2lu?=
 =?iso-8859-2?Q?qLtModqLdjEElwmpo9Nsg1XBNRAmtZ0BdvuxwuPE6KcgHwDZ8/w43jujET?=
 =?iso-8859-2?Q?PthRL/1nwVdv3LM517xHwXY0DZ1WFJXubFPNKbFW5o5px6sTb+K6Nwrwd/?=
 =?iso-8859-2?Q?6rkKe9D6IacVzHS+3h1tBHDLfFWsHCOHXoagaTJMMpZ0DsSKgnPCZpTbi8?=
 =?iso-8859-2?Q?wG6WjNzVbjWaF5sMeC3jsJDE1gHdZ6ET5usQcaAzfWCvD9/yI6V8vEm9sf?=
 =?iso-8859-2?Q?FE7ZHHQW8OF0cvPuw+QUo7fY0OklVFU4E/coFxb7Ox8kvdJkwgxJTRRRL2?=
 =?iso-8859-2?Q?Auqj7/eENFz/Pv/4cROI+Cq1eS+bKdPmKxRxVAi/CQeKgqhGhSv1diWL9l?=
 =?iso-8859-2?Q?eEg0S7S3qn8UjeveHRrNX+NOPzIF+OEOv7tyGDPbToTeYJvKhBHDDrlkk+?=
 =?iso-8859-2?Q?RuzN0OoidPkQHGECkqxr0hpgr0ijltmzJ1Pynb1eXP/Y/PXfzclgubZizn?=
 =?iso-8859-2?Q?hnf96d+ZlIOn+ffhxqW5A7JeUAbk/wD4fCC1mqBhi+ym4HTFVXu0kul6XT?=
 =?iso-8859-2?Q?paL1dQMzmIkKwpGJ8z/0Cbh6/ecj13xHwi0fHsbEcPNcco+e18vU9oSYBu?=
 =?iso-8859-2?Q?NWcZUdVfCnI96uKwP0eMZiHzlNcmBB4IuNGkGiLDniX6dEbE5ncQdbXV7Y?=
 =?iso-8859-2?Q?ucaJsSv1OqIm6+ML3FuDs7KYYkJfpmoR4JEpDI1E2XoHYcwUfSloHpEJZV?=
 =?iso-8859-2?Q?l4p79+jNokg7Q+e4BDCQ9DDxFIramXleHmuwzKnGKuq/kH+g4lJGhkDPQ7?=
 =?iso-8859-2?Q?dtkHdYlyXQ4w1nQdkZM0ACe32bskcakFtSFGdc6GyMRELW4qa+4e9vWQaX?=
 =?iso-8859-2?Q?NTGivw+DzOxDsEWu1qAjNj/yoQTpcK2YnCL0ZFxwoTcBoCGzccI0deXcZI?=
 =?iso-8859-2?Q?WdDHQFPl3GC/vXaebDy4q8xbt/1MU3/9O9YBCBc5mojYdhq4zwNHzow/5o?=
 =?iso-8859-2?Q?y9WFXl/Cpe75ozZq7O8dSOFeVkFSY9MX9eWs2RiZiTPOTv5Tf+J4MgKmIY?=
 =?iso-8859-2?Q?FaBBgS/yl2eU1vgHB5BVFDiTBg6bTx9liaTSAuYsIzEYFtBg4hDyYX4gT7?=
 =?iso-8859-2?Q?ymze2/oHP4TL85SmtDQ0CjaY+iRnV2mHmbqQyl8UJf8+6uNWzNXbzJnw1Y?=
 =?iso-8859-2?Q?Ll5LPrvf+3o4j0hzdS6nhshAsyOSuoImgZ6AUPgSnOIQmNlSJZ82U5Lvm2?=
 =?iso-8859-2?Q?mM3udQ0lc+JpZrcc34oX3idpIECaLTF1rVnm40ib1cc0y1KfBmjB2ahwvY?=
 =?iso-8859-2?Q?2cAOEz0hwKP6Y2fh/86naqMNqgfV5U9wTXdf6C5mUO42/e70NgrS1bF1WB?=
 =?iso-8859-2?Q?2y+4Cqmk3+01loCJDtrU/or1AtbLN118hECNzb1yYClHQIWBb/8m+dmmMl?=
 =?iso-8859-2?Q?Dv2WY3kqu9oTn96YffLYzqA+7bcHZ6vy/kaClP7M3yw7auOzuDyWq4fwjF?=
 =?iso-8859-2?Q?Fx3LEhA1fbSeVr7jhMmmjGYiIPCoV3ihqfa20KuCWNES0ieeygqvBatZLA?=
 =?iso-8859-2?Q?jO3Swt1a+6P1lPyMa8YLdxSbbmGnnX/igVvxoHIj5QXbMHgbZRk5SB8KJ1?=
 =?iso-8859-2?Q?Z2mQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5987fc82-260a-4b60-4980-08d9be3d4bf4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 13:34:32.4506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BT1F6+kmrJeHQeJinbuft+WpbIVPknWkdz14sTO/SOJie4nHy8TIK1mdVyNRuPzWmw8NfCE4U3VFAjgLg53iYuIMm216aeKHYMxD4jnFyxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5606
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Dan Carpenter
> Sent: =B6roda, 10 listopada 2021 09:14
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Palczewski, Mateusz
> <mateusz.palczewski@intel.com>
> Cc: Pawlak, Jakub <jakub.pawlak@intel.com>; netdev@vger.kernel.org;
> kernel-janitors@vger.kernel.org; Jakub Kicinski <kuba@kernel.org>; intel-
> wired-lan@lists.osuosl.org; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net] iavf: missing unlocks in
> iavf_watchdog_task()
>=20
> This code was re-organized and there some unlocks missing now.
>=20
> Fixes: 898ef1cb1cb2 ("iavf: Combine init and watchdog state machines")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 847d67e32a54..b97f685a5cf8 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -2012,6 +2012,7 @@ static void iavf_watchdog_task(struct work_struct
> *work)

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
