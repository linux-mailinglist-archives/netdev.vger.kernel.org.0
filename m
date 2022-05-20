Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B813F52E7AA
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 10:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347260AbiETIeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 04:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347380AbiETIdq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 04:33:46 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E89F7E1E7
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 01:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653035595; x=1684571595;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zwMrCPHWaOW2pMKEH7/aFvkSz1oSYoYxGey/Qg1a8v0=;
  b=K2Zk/96Jg9p5qikw7SE2y7cVDTOJneXrWDTbUHaaOD96jIcocI7wSuk0
   D9ioKWI7OV50BJI8jUuWpim0SkvrXKOF688GR/Oscq3YbFoNUINMacrM6
   /g2iMqkMggg14WRX9tFaZlmtSPxmmxmoPispkdMtzG/+FDRes1xZU0gmI
   McdNKWUnlMPfrI3stl4aFy9eoeQ3Qon+oLstacCSQJ6y2isvN1JyE7bCs
   j5mU1UCpGneBI/N0wt7vJ/Gru53na0sMlzRMMpT3RvdaY8Hzo7sayyAlR
   YuqdHYXo6FPrSz1lptZNgJ9QsbQlb1r0aQGd8hcPpwPSIKVgoHFJRSEek
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="335593841"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="335593841"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 01:33:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="599096847"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga008.jf.intel.com with ESMTP; 20 May 2022 01:33:14 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 20 May 2022 01:33:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 20 May 2022 01:33:14 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 20 May 2022 01:33:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bylEiv0tEi/346QSvWthI+nPj9/ENtBmED5k7+TT+U7JYSUFpRtIqKCRzFbN+Ilxqb0h3gjp3mqEy39ROQuY/950rEZNCCkYqMuixryy59Lc/WbzgT5h3N6HvtNWa04G2tM6efB4Fd5/UAxPzkid2Sc4K+W+ZLsB6UcZpCWnN5HMdgq3IMxxrfH+f0VLoR/fzmpguOzZeqv7cNuBteZ/esDf/y4aP/XZdP6FfEJaK5d0/Nktx9KZCdeViZ1tqnUFc7/Qiqh82TdK88NeIYSs7F0sE0ArfZEZtDfDvcL0HPHX1qiPFnj8Pd1GT1dkODJiK3VQ+0apav8h7XiTzdjzhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eEQ1nfTGIq9HhgU/BxbRlmKHp39/QqK9Pqup9Nh9ToI=;
 b=fYrepcbS1QwJI02WXYzb8hmA6i52N3+lSTn/SvcKIkCU7VD9McIy8j1drjsCy/oCV/JMQgXV9jgvxs6jQqz/y3mYj7Sk9nts7/2eGAZkaut/zLW7Ete6EhNTnpY9lQkG2OqR0B/6gT5lTorXzy7GyefNl8VP+TTMFbYBR+4kOOckfxHi+mZoNX8fNOjM1HEUoFVCTvxRuBdgy2EQJI8azEwVu0yZ5DuGmMwBw5en2BjVmGdFKN1fVx6lIwjlZcO3nF0dsqJBC2lek8OQBl6/lnxd8mSkXRx3xRFJ48MB4kDqsvf+8EQOHMwB0puAnL+30hzYJCpzVvbkNhitjKaBwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by MWHPR11MB1743.namprd11.prod.outlook.com (2603:10b6:300:114::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 08:33:06 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3968:a4a:e305:b6f2]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3968:a4a:e305:b6f2%4]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 08:33:06 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Moises Veleta <moises.veleta@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "Devegowda, Chandrashekar" <chandrashekar.devegowda@intel.com>,
        linuxwwan <linuxwwan@intel.com>,
        "Liu, Haijun" <haijun.liu@mediatek.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "ilpo.jarvinen@linux.intel.com" <ilpo.jarvinen@linux.intel.com>,
        "ricardo.martinez@linux.intel.com" <ricardo.martinez@linux.intel.com>,
        "Kancharla, Sreehari" <sreehari.kancharla@intel.com>,
        "Sharma, Dinesh" <dinesh.sharma@intel.com>
Subject: RE: [PATCH net-next 1/1] net: wwan: t7xx: Add port for modem logging
Thread-Topic: [PATCH net-next 1/1] net: wwan: t7xx: Add port for modem logging
Thread-Index: AQHYa6+P3P8qDfc/FUCjrupriGDY1q0nRR4w
Date:   Fri, 20 May 2022 08:33:06 +0000
Message-ID: <SJ0PR11MB50085483433229CC9E4BCED0D7D39@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20220519182703.27056-1-moises.veleta@linux.intel.com>
In-Reply-To: <20220519182703.27056-1-moises.veleta@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25e3ca4f-acf2-475d-7abd-08da3a3b5cfe
x-ms-traffictypediagnostic: MWHPR11MB1743:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR11MB17436974790BD0CCA3F62EF4D7D39@MWHPR11MB1743.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XgoFm4CRH9mksMxCGC0vrmg6GHj83BwtWHieV9cQ8qE8rypvbsOeLsGNSQa/iqlXjCVuZB/8ccE5Z5xw3dxl/goRiJ2Z19Henkohm2zjS/pejsweGRh+WnxAUW6C3LabmrvV3Orz3I3RAx2RfLnSdAI32a37rHpYC9zDx8asqRk9Xccn6ZJUpSFJHpsQCtZTgncYp5Br4jm+YHi44JOerqc14fxh4VMdq6Ys4pTc0ri/7xA9NTJXszX2YYYQHG2M5k9RrSOWHvWYaIbT+ARAH8BYFjdoLs+m59cRo21GyoihNwK9XsQIka9j2UBJb28UfvycobtbJAGcYmZGchPZYkewFlMfsGHZb0z0/yjdz3B54Vsix5iygYZlKxGSaNiPYVfC8zur1mO3RwGgvjOFcd35NxBhnkV6FfoXpmSiMR8TuDFgvBLQfbo644OtKNpPH1HXS9ZDDtfylY68k+HkXF3czXMEGT3bhKrWuqUPxptifcLNjty5T30wot64P5LKDCg9XmBssX+8stw6iHrifjcBQkJaiPEi83/TXqjk7XBdt1XhCfbu8PYBOSmbAVm9oSAebCPc96WGRT/4S3HAMdV/LL8ATaUC+oEkahvdE/NMXQEFt5EtN8wqQo69fKHKHrG/ASY5Ot6PS+//TqHIkvGphamGo2zdm1PK5k0ZkGunBCR8dN2kNl0n9fgmb5ka8OTy6ETBFXe78DQRzq0cdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(55016003)(38100700002)(66556008)(54906003)(38070700005)(122000001)(110136005)(8676002)(76116006)(4326008)(83380400001)(66946007)(66476007)(66446008)(64756008)(7696005)(316002)(82960400001)(71200400001)(86362001)(53546011)(9686003)(7416002)(30864003)(33656002)(26005)(186003)(508600001)(8936002)(5660300002)(52536014)(2906002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?faVXKWsKDbjr5GHr2OrwPBdiJj74IJduV9I8H9qIGDoMAwWuUdPBZnxGWGJa?=
 =?us-ascii?Q?qSfEdYnbFKtn0ihq/3y8nc6zT+1/2A2eJztNax7XUjEkoxjdRnbfpvljEAEt?=
 =?us-ascii?Q?BkV4+eW+WWwpYy4yHWbM/PXmwGqV2F9jGx82+ixNXVqyawANeASPIJPWJahQ?=
 =?us-ascii?Q?oI7mw7XbANtvRKKnYwmmbqhCiNWvIb5xzoJIcdXqjGlhew8ySSz3NES8P40q?=
 =?us-ascii?Q?Es4jrqRDymPOkPKRKPFFfU3m1kAvy0JOzvl9y8ucU52eP9dlpyWmuCTwvauP?=
 =?us-ascii?Q?QOxeHB4oRYAnmIcgCwInQDd8xSDsjlm5YtrWyPtMi5KYsruapDpGV/4UOAhk?=
 =?us-ascii?Q?XBdfkrKFLggFN6ciyQ8t1myG4HuPgo/6Tispm8FEgNO5+Gg5nlJipopDkLBO?=
 =?us-ascii?Q?XYPwj3ljeHv448JToKDcyp4ccoNp9zIBOoGG3MHpguflepf98d1h5ABX6Jge?=
 =?us-ascii?Q?TO3Jq3YH/ZkPlytORlMiSzwLhF9VFfK2Vd/rLJFVfJaFgPVZTpBuzOZc0qIX?=
 =?us-ascii?Q?sd47qmvfVqR+kcKUPyVfuenk4QSospSLZ++fqbYS4ir4gQNpUz33ch+YWy/1?=
 =?us-ascii?Q?k9UsCH2xiUJwPXZq1TCF9EF4PYut8Blp+mmB1FLNb+AjzwAMZT8R+Tw+svHo?=
 =?us-ascii?Q?YVmXLwt30dSqy7wfKHDN1Wmd/QTE+bdEDexu8GoMCTdsV1KLpBgTdHJzcJqY?=
 =?us-ascii?Q?opN8bJbnL7yRWfWnZekD6n0tPJmSvZCXoTd/CGCgVi5RorGySSJIZ3vsESDJ?=
 =?us-ascii?Q?OTIw7GwvH0oJkECMbxzWWWHH37nk9nSeI4IRx1hwq1ExaZ/FgHqnVqp3CXS9?=
 =?us-ascii?Q?IKgXS+DyCkjHcXG/X8DNst7bAlrKyF5aJCX/MFzWVmHo7jgd5UadrRrCBcUY?=
 =?us-ascii?Q?AAHxOSa/hwWKP0cHgOn8qTCcDJsFWtBFMZfwVMlEhbOeF/J5lbtcSDEsqKnK?=
 =?us-ascii?Q?4af2cWaXP1paJR58Or8hARxcSUhyJzSa00NgiyH6JYmuZcbiyl7OGchCNUtB?=
 =?us-ascii?Q?aFMEBOCkIBOHP9Hva4MLmc9b8f8DV+HNyXVaMn0g0Dc6qKyDeaA2Xc5Zrgyd?=
 =?us-ascii?Q?Bb5/P3mij9S73MJiJN097B7YQTolRZJJ7sOpE9iJMC4x0QiWtfmvi8HFq1HA?=
 =?us-ascii?Q?q+duFb6cBZ+++JazTKF2V1OsiGQdpigj+cD82IJoAUv87EjzShD0DIGyXQ4z?=
 =?us-ascii?Q?muFKbyyelmNzGWjkU43fFs6CWfxX0oNk+/G0JpAqAx3v9yCQvvKSoZ6MNzOm?=
 =?us-ascii?Q?TInylDUWQ0pb/hXYDOT5TYTNXtXz0MTMwVoCn50r3yFCWjMCPJ60gEnnTz9N?=
 =?us-ascii?Q?AnmpBj4Bhe/KSNbACzsfX6NYIwDhdhVnR/rcfbrKuNHUOl0CqrltPGiOrtIo?=
 =?us-ascii?Q?6BE/znUgZ7Ud4uyZ698zB5RDVFc7O3mB7Q7oJmh4TtzDs9I2f2FJU97FH9SP?=
 =?us-ascii?Q?YOFugK+f+36XI/PppnbE92WpD7JfADcYcI34voJLdwjpnFN4RYuqy1Q+Dr4q?=
 =?us-ascii?Q?988ZkwAzdyKXJJiBKVY+QIoi8vS1YrTIK7zWYqTeWRpoRPISJKaBYQIGKpgd?=
 =?us-ascii?Q?RlbiVHNHNmvbqDr5UuA8EilI47CZtX2NqPm6JLi5vrwSCYsSq8A1qnrNO2FM?=
 =?us-ascii?Q?fz24QptyphSF3PipnQkVlFnwHTgiiQLV2A+bZ11OJniaNv2qk9OuOiFHtgWv?=
 =?us-ascii?Q?Ve6ZUab/ow0uomlHSgH76EG5tXL/Vq1ZAc1C7jh6uJnkSoUlSqnNXYDX9m6p?=
 =?us-ascii?Q?HTSaOaN3VQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25e3ca4f-acf2-475d-7abd-08da3a3b5cfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 08:33:06.3696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QVSDg1xE24xP/I5UsCz4N6jvjheo5WXh86Qxz/yfZM1JV/R653UjQezqzPbjh+R0My5lfXLM6PjVaHdk0rdMRWzJBDK3FesotW1LCPRMlHE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1743
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Moises Veleta <moises.veleta@linux.intel.com>
> Sent: Thursday, May 19, 2022 11:57 PM
> To: netdev@vger.kernel.org
> Cc: kuba@kernel.org; davem@davemloft.net; johannes@sipsolutions.net;
> ryazanov.s.a@gmail.com; loic.poulain@linaro.org; Kumar, M Chetan
> <m.chetan.kumar@intel.com>; Devegowda, Chandrashekar
> <chandrashekar.devegowda@intel.com>; linuxwwan
> <linuxwwan@intel.com>; Liu, Haijun <haijun.liu@mediatek.com>;
> andriy.shevchenko@linux.intel.com; ilpo.jarvinen@linux.intel.com;
> ricardo.martinez@linux.intel.com; Kancharla, Sreehari
> <sreehari.kancharla@intel.com>; Sharma, Dinesh
> <dinesh.sharma@intel.com>; Moises Veleta
> <moises.veleta@linux.intel.com>
> Subject: [PATCH net-next 1/1] net: wwan: t7xx: Add port for modem logging
>=20
> The Modem Logging (MDL) port provides an interface to collect modem logs
> for debugging purposes. MDL is supported by debugfs, the relay interface,
> and the mtk_t7xx port infrastructure. MDL allows user-space applications =
to
> control logging via debugfs and to collect logs via the relay interface, =
while
> port infrastructure facilitates communication between the driver and the
> modem.
>=20
> Signed-off-by: Moises Veleta <moises.veleta@linux.intel.com>
> Acked-by: Ricardo Martinez <ricardo.martinez@linux.intel.com>
> ---
>  drivers/net/wwan/Kconfig                |   1 +
>  drivers/net/wwan/t7xx/Makefile          |   3 +
>  drivers/net/wwan/t7xx/t7xx_hif_cldma.c  |   2 +
>  drivers/net/wwan/t7xx/t7xx_port.h       |   5 +
>  drivers/net/wwan/t7xx/t7xx_port_proxy.c |  22 +++
>  drivers/net/wwan/t7xx/t7xx_port_proxy.h |   4 +
>  drivers/net/wwan/t7xx/t7xx_port_trace.c | 174
> ++++++++++++++++++++++++
>  7 files changed, 211 insertions(+)
>  create mode 100644 drivers/net/wwan/t7xx/t7xx_port_trace.c
>=20
> diff --git a/drivers/net/wwan/Kconfig b/drivers/net/wwan/Kconfig index
> 3486ffe94ac4..32149029c891 100644
> --- a/drivers/net/wwan/Kconfig
> +++ b/drivers/net/wwan/Kconfig
> @@ -108,6 +108,7 @@ config IOSM
>  config MTK_T7XX
>  	tristate "MediaTek PCIe 5G WWAN modem T7xx device"
>  	depends on PCI
> +	select RELAY if WWAN_DEBUGFS
>  	help
>  	  Enables MediaTek PCIe based 5G WWAN modem (T7xx series)
> device.
>  	  Adapts WWAN framework and provides network interface like
> wwan0 diff --git a/drivers/net/wwan/t7xx/Makefile
> b/drivers/net/wwan/t7xx/Makefile index dc6a7d682c15..268ff9e87e5b
> 100644
> --- a/drivers/net/wwan/t7xx/Makefile
> +++ b/drivers/net/wwan/t7xx/Makefile
> @@ -18,3 +18,6 @@ mtk_t7xx-y:=3D	t7xx_pci.o \
>  		t7xx_hif_dpmaif_rx.o  \
>  		t7xx_dpmaif.o \
>  		t7xx_netdev.o
> +
> +mtk_t7xx-$(CONFIG_WWAN_DEBUGFS) +=3D \
> +		t7xx_port_trace.o \

Drop \

> diff --git a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
> b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
> index 0c52801ed0de..dcd480720edf 100644
> --- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
> +++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
> @@ -1018,6 +1018,8 @@ static int t7xx_cldma_late_init(struct cldma_ctrl
> *md_ctrl)
>  			dev_err(md_ctrl->dev, "control TX ring init fail\n");
>  			goto err_free_tx_ring;
>  		}
> +
> +		md_ctrl->tx_ring[i].pkt_size =3D CLDMA_MTU;
>  	}
>=20
>  	for (j =3D 0; j < CLDMA_RXQ_NUM; j++) {
> diff --git a/drivers/net/wwan/t7xx/t7xx_port.h
> b/drivers/net/wwan/t7xx/t7xx_port.h
> index dc4133eb433a..e35efb18ea09 100644
> --- a/drivers/net/wwan/t7xx/t7xx_port.h
> +++ b/drivers/net/wwan/t7xx/t7xx_port.h
> @@ -122,10 +122,15 @@ struct t7xx_port {
>  	int				rx_length_th;
>  	bool				chan_enable;
>  	struct task_struct		*thread;
> +#ifdef CONFIG_WWAN_DEBUGFS
> +	struct t7xx_trace		*trace;
> +	struct dentry			*debugfs_dir;
> +#endif
>  };
>=20
>  struct sk_buff *t7xx_port_alloc_skb(int payload);  struct sk_buff
> *t7xx_ctrl_alloc_skb(int payload);
> +int t7xx_port_mtu(struct t7xx_port *port);
>  int t7xx_port_enqueue_skb(struct t7xx_port *port, struct sk_buff *skb); =
 int
> t7xx_port_send_skb(struct t7xx_port *port, struct sk_buff *skb, unsigned =
int
> pkt_header,
>  		       unsigned int ex_msg);
> diff --git a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
> b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
> index 7d2c0e81e33d..fb9d057d6a84 100644
> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.c
> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.c
> @@ -70,6 +70,18 @@ static const struct t7xx_port_conf
> t7xx_md_port_conf[] =3D {
>  		.name =3D "MBIM",
>  		.port_type =3D WWAN_PORT_MBIM,
>  	}, {
> +#ifdef CONFIG_WWAN_DEBUGFS
> +		.tx_ch =3D PORT_CH_MD_LOG_TX,
> +		.rx_ch =3D PORT_CH_MD_LOG_RX,
> +		.txq_index =3D 7,
> +		.rxq_index =3D 7,
> +		.txq_exp_index =3D 7,
> +		.rxq_exp_index =3D 7,
> +		.path_id =3D CLDMA_ID_MD,
> +		.ops =3D &t7xx_trace_port_ops,
> +		.name =3D "mdlog",
> +	}, {
> +#endif

Why do you want keep mdlog port under flag ?

>  		.tx_ch =3D PORT_CH_CONTROL_TX,
>  		.rx_ch =3D PORT_CH_CONTROL_RX,
>  		.txq_index =3D Q_IDX_CTRL,
> @@ -194,6 +206,16 @@ int t7xx_port_enqueue_skb(struct t7xx_port *port,
> struct sk_buff *skb)
>  	return 0;
>  }
>=20
> +int t7xx_port_mtu(struct t7xx_port *port) {
> +	enum cldma_id path_id =3D port->port_conf->path_id;
> +	int tx_qno =3D t7xx_port_get_queue_no(port);
> +	struct cldma_ctrl *md_ctrl;
> +
> +	md_ctrl =3D port->t7xx_dev->md->md_ctrl[path_id];
> +	return md_ctrl->tx_ring[tx_qno].pkt_size;
> +}
> +
>  static int t7xx_port_send_raw_skb(struct t7xx_port *port, struct sk_buff
> *skb)  {
>  	enum cldma_id path_id =3D port->port_conf->path_id; diff --git
> a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
> b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
> index bc1ff5c6c700..81d059fbc0fb 100644
> --- a/drivers/net/wwan/t7xx/t7xx_port_proxy.h
> +++ b/drivers/net/wwan/t7xx/t7xx_port_proxy.h
> @@ -87,6 +87,10 @@ struct ctrl_msg_header {  extern struct port_ops
> wwan_sub_port_ops;  extern struct port_ops ctl_port_ops;
>=20
> +#ifdef CONFIG_WWAN_DEBUGFS
> +extern struct port_ops t7xx_trace_port_ops; #endif
> +
>  void t7xx_port_proxy_reset(struct port_proxy *port_prox);  void
> t7xx_port_proxy_uninit(struct port_proxy *port_prox);  int
> t7xx_port_proxy_init(struct t7xx_modem *md); diff --git
> a/drivers/net/wwan/t7xx/t7xx_port_trace.c
> b/drivers/net/wwan/t7xx/t7xx_port_trace.c
> new file mode 100644
> index 000000000000..87529316b183
> --- /dev/null
> +++ b/drivers/net/wwan/t7xx/t7xx_port_trace.c
> @@ -0,0 +1,174 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2022 Intel Corporation.
> + */
> +
> +#include <linux/bitfield.h>
> +#include <linux/debugfs.h>
> +#include <linux/relay.h>
> +#include <linux/skbuff.h>
> +#include <linux/wwan.h>
> +
> +#include "t7xx_port.h"
> +#include "t7xx_port_proxy.h"
> +#include "t7xx_state_monitor.h"
> +
> +#define T7XX_TRC_SUB_BUFF_SIZE		131072
> +#define T7XX_TRC_N_SUB_BUFF		32
> +#define T7XX_TRC_FILE_PERM		0600
> +
> +struct t7xx_trace {
> +	struct rchan			*t7xx_rchan;
> +	struct dentry			*ctrl_file;
> +};
> +
> +static struct dentry *t7xx_trace_create_buf_file_handler(const char
> *filename,
> +							 struct dentry
> *parent,
> +							 umode_t mode,
> +							 struct rchan_buf
> *buf,
> +							 int *is_global)
> +{
> +	*is_global =3D 1;
> +	return debugfs_create_file(filename, mode, parent, buf,
> +				   &relay_file_operations);
> +}
> +
> +static int t7xx_trace_remove_buf_file_handler(struct dentry *dentry) {
> +	debugfs_remove(dentry);
> +	return 0;
> +}
> +
> +static int t7xx_trace_subbuf_start_handler(struct rchan_buf *buf, void
> *subbuf,
> +					   void *prev_subbuf,
> +					   size_t prev_padding)
> +{
> +	if (relay_buf_full(buf)) {
> +		pr_err_ratelimited("Relay_buf full dropping traces");
> +		return 0;
> +	}
> +
> +	return 1;
> +}
> +
> +static struct rchan_callbacks relay_callbacks =3D {
> +	.subbuf_start =3D t7xx_trace_subbuf_start_handler,
> +	.create_buf_file =3D t7xx_trace_create_buf_file_handler,
> +	.remove_buf_file =3D t7xx_trace_remove_buf_file_handler,
> +};
> +
> +static ssize_t t7xx_port_trace_write(struct file *file, const char __use=
r *buf,
> +				     size_t len, loff_t *ppos)
> +{
> +	struct t7xx_port *port =3D file->private_data;
> +	size_t actual_len, alloc_size, txq_mtu;
> +	const struct t7xx_port_conf *port_conf;
> +	enum md_state md_state;
> +	struct sk_buff *skb;
> +	int ret;
> +
> +	port_conf =3D port->port_conf;
> +	md_state =3D t7xx_fsm_get_md_state(port->t7xx_dev->md->fsm_ctl);
> +	if (md_state =3D=3D MD_STATE_WAITING_FOR_HS1 || md_state =3D=3D
> MD_STATE_WAITING_FOR_HS2) {
> +		dev_warn(port->dev, "port: %s ch: %d, write fail when
> md_state: %d\n",
> +			 port_conf->name, port_conf->tx_ch, md_state);
> +		return -ENODEV;
> +	}

This means debugfs knob is available to application even before driver & de=
vice handshake
 is complete. Is not possible to defer debugfs knob creation until handshak=
e is complete ?

> +
> +	txq_mtu =3D t7xx_port_mtu(port);
> +	alloc_size =3D min_t(size_t, txq_mtu, len + sizeof(struct ccci_header))=
;

To keep it even we can drop +sizeof(struct ccci_header).

> +	actual_len =3D alloc_size - sizeof(struct ccci_header);
> +	skb =3D t7xx_port_alloc_skb(alloc_size);

alloc_size contains the actual len and t7xx_port_alloc_skb() is considering=
 alloc_size +=20
sizeof(struct ccci_header); So actual_len calculation is redundant.

> +	if (!skb) {
> +		ret =3D -ENOMEM;
> +		goto err_out;

In skb failure case an attempt is made to free skb() by calling dev_kfree_s=
kb().
Better to add new label and simply return ?

> +	}
> +
> +	ret =3D copy_from_user(skb_put(skb, actual_len), buf, actual_len);
> +	if (ret) {
> +		ret =3D -EFAULT;
> +		goto err_out;
> +	}
> +
> +	ret =3D t7xx_port_send_skb(port, skb, 0, 0);
> +	if (ret)
> +		goto err_out;
> +
> +	return actual_len;

If len report is txq_mtu then actual_len is returning - sizeof(struct ccci_=
header);
Instead return len.

> +
> +err_out:
> +	dev_err(port->dev, "write error done on %s, size: %zu, ret: %d\n",
> +		port_conf->name, actual_len, ret);
> +	dev_kfree_skb(skb);
> +	return ret;
> +}
> +

> +static const struct file_operations t7xx_trace_fops =3D {
> +	.owner =3D THIS_MODULE,
> +	.open =3D simple_open,
> +	.write =3D t7xx_port_trace_write,
> +};
> +
> +static int t7xx_trace_port_init(struct t7xx_port *port) {
> +	struct dentry *debugfs_pdev =3D wwan_get_debugfs_dir(port->dev);
> +
> +	if (IS_ERR(debugfs_pdev))
> +		debugfs_pdev =3D NULL;
> +
> +	port->debugfs_dir =3D debugfs_create_dir(KBUILD_MODNAME,
> debugfs_pdev);
> +	if (IS_ERR_OR_NULL(port->debugfs_dir))
> +		return -ENOMEM;
> +
> +	port->trace =3D devm_kzalloc(port->dev, sizeof(*port->trace),
> GFP_KERNEL);
> +	if (!port->trace)
> +		goto err_debugfs_dir;
> +
> +	port->trace->ctrl_file =3D debugfs_create_file("mdlog_ctrl",
> +						     T7XX_TRC_FILE_PERM,
> +						     port->debugfs_dir,
> +						     port,
> +						     &t7xx_trace_fops);
> +	if (!port->trace->ctrl_file)
> +		goto err_debugfs_dir;
> +
> +	port->trace->t7xx_rchan =3D relay_open("relay_ch",
> +					     port->debugfs_dir,
> +					     T7XX_TRC_SUB_BUFF_SIZE,
> +					     T7XX_TRC_N_SUB_BUFF,
> +					     &relay_callbacks, NULL);
> +	if (!port->trace->t7xx_rchan)
> +		goto err_debugfs_dir;

Even though trace resource is allocated using managed API good to call devm=
_kfree() in error paths ?

> +
> +	return 0;
> +
> +err_debugfs_dir:
> +	debugfs_remove_recursive(port->debugfs_dir);
> +	return -ENOMEM;
> +}
> +
> +static void t7xx_trace_port_uninit(struct t7xx_port *port) {
> +	struct t7xx_trace *trace =3D port->trace;
> +
> +	relay_close(trace->t7xx_rchan);
> +	debugfs_remove_recursive(port->debugfs_dir);
> +}
> +
> +static int t7xx_trace_port_recv_skb(struct t7xx_port *port, struct
> +sk_buff *skb) {
> +	struct t7xx_trace *t7xx_trace =3D port->trace;
> +
> +	if (!t7xx_trace->t7xx_rchan)
> +		return -EINVAL;

skb free not required is it considered by caller ?

> +
> +	relay_write(t7xx_trace->t7xx_rchan, skb->data, skb->len);
> +	dev_kfree_skb(skb);
> +	return 0;
> +}
