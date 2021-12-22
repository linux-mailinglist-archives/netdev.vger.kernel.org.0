Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5573647D069
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 12:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244349AbhLVLAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 06:00:13 -0500
Received: from mga03.intel.com ([134.134.136.65]:61238 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244340AbhLVLAM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Dec 2021 06:00:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640170812; x=1671706812;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zi1uEhMnlliGJTqxmrLw7OEJxiLpW7cbq2AkLTS3YM0=;
  b=FoyNZd3ex1yFDd4gDFB0t/CcVu3DVVdGL5qpL1mPB1k0j6FLeaDIG+7T
   sA1HyjTDrQ9g5TxFexOOR2gpksW/MoBqgOjrlcQmZM0cFEETI8EQ4JVv7
   vbtF+kK6KSpOy9HNRs4ceWM09j2gn/QKsZBVulsETAccPAluMvtFzG09V
   4gfGtmufH1vv6e98Vv4TwtH+DZa5igdNPPKxuJVhpvNPN9OclyPRdSZr3
   I4p6cBi/RT05BHcymqz+WEyB8B9/45xbuO1vXtAS7xJdsJy3OMts9TTlO
   QylRtYhEuZQlN+5nnozAUgz2ncwOsfSaZCCcZ8UgxhbzaBeOl6aw/QvGn
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240549073"
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="240549073"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2021 03:00:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,226,1635231600"; 
   d="scan'208";a="758389600"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga005.fm.intel.com with ESMTP; 22 Dec 2021 03:00:10 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 03:00:10 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 22 Dec 2021 03:00:10 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 22 Dec 2021 03:00:10 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 22 Dec 2021 03:00:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUx03W35Myd1Fb20Y5yLtU3LNrdoZGtTOlBEC7lVqn3xJHmGFDl0p/A24f34CD0a4SmjdfU6aD8yYnH9CAnKQB9PbsK2c7xp6TUVtcjGo7p4l+52ZYG7mhpb5eIgUbM11yvt7pCx/KzhpDFCvHyPkmcGei3b5y5QJtmbhUJUWQokdE6SrfO8x4SLzYkz+L2oWMXQzK74gnbwslK5N0sS7X4QxgFFnCfMjdbUF2gEWiDnCcmYh+RBlVng8D2BtZ5eq6UeobRnoueV/+f9GpzQ9rdeCVbKAe7XuVSsmtnd0MsyW5DqCQ/U8CJDv6WzpugGm0o6o+QlxmQ0t19Hh0X5Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Notx98Lb9QrnTRbsKmd70xO0756EnpbCpSLbagv805k=;
 b=HutNJx2odWnmbvoRhOBWDFohwXXs57It8l29iLMdeKsSe4Ymfk9Nhd/q1F/sIWKyAxSUAKouZVSAJnKjKsErEhrikqYsETrIXZQf26q00bjV3QrnUOLgsIPanpzSLud5UEcQbE1wROVcmqaI8HlYTh+o+UzXEl1rODOjWsA4KitqNpoH5XD233Qu6curyxRV6Hdloth8uROhSAsjteePLW24R97Tpw+ziUPbG6SxkcAayEk+Kjsy1J3oklQTKaXkubluYzVZ3Zj1iDQOTS93zxJwYbVohi9jNm9vVu04qntKgteMmVMjUtcHC0V0patABrwVNUCI0QQUN6YjX9FQ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by SJ0PR11MB5087.namprd11.prod.outlook.com (2603:10b6:a03:2ad::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Wed, 22 Dec
 2021 11:00:08 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::bc02:db0b:b6b9:4b81]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::bc02:db0b:b6b9:4b81%5]) with mapi id 15.20.4801.020; Wed, 22 Dec 2021
 11:00:08 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Yang Li <yang.lee@linux.alibaba.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "llvm@lists.linux.dev" <llvm@lists.linux.dev>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nathan@kernel.org" <nathan@kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH -next] i40e: remove variables set but
 not used
Thread-Topic: [Intel-wired-lan] [PATCH -next] i40e: remove variables set but
 not used
Thread-Index: AQHX8D510leJSDY7zEydjsNb2ccmC6w+ZYyw
Date:   Wed, 22 Dec 2021 11:00:08 +0000
Message-ID: <BYAPR11MB336744DCED9E187D5051F81CFC7D9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20211213031107.52438-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20211213031107.52438-1-yang.lee@linux.alibaba.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a6f6be0-3a70-401d-e6be-08d9c53a37d8
x-ms-traffictypediagnostic: SJ0PR11MB5087:EE_
x-microsoft-antispam-prvs: <SJ0PR11MB5087A98FF3A19D1F9719EDF1FC7D9@SJ0PR11MB5087.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZRYj3tsRta/662Ngk5/1D4Gu5bvQQYf19pdsz0W5G1yWKuIEZXOpJr94SYS5IOkedeGQTddA113iAUjQMpjgP3INswoZAiGIl+NP6EhrB3v+2Dhy8UVfExQORRyDMvP8Fn1ezsTzzfkdAde17gCM45yFr/H5CvpJiM1YWG1l8UOSq8fH31QC+GSXLswTmyXDlBxAZ8P78BhlnEISe88ORXD+CzS3vHEGV4Paif1vmutagdBkqeuzESlR30D7Y70CDnLvoE+cJkZ/vUiRDIPH8Xo52OVwtz4DX2SjuWNrDSpIWekXXf0Tj7MsW+4cyAZF+PvknyKBFeiFrKwmNFCcdWBdrLl3NxEf0Vx/P+IFOzZ7Y2LWNpZG6VNAeME9AUBEiO4IiTyIPFyGCielfV4+aVQLRDvdATLaJMtkuWIug1hX5FmaV08k2RjSVGgRLX6yANSWjki+jClFbdXnA5uexSP0fA1eiVl8R/UelkkXil9cPgPRFBBQS9JFAtAlTVNEQ5A84clvzyhA9/oCAJeMNmvTCcRa5U5Q4vdljhCPbs+Gy5/2F8ykXp+78w1jNwIiOZ3TgOL++E/qy/svBzV1ktv6YC0pdogkrkMCYXR8nPcY+oMlwXakjNgPj9cnW+H2mSz4NsXDQI1MpAvfk9e4gBajYuCaE3TxrFz3bHW4iOpy4gZRQCTVCzzoRfYA/76sjY4QSiNViBk/fJYBtAJRYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38100700002)(86362001)(4326008)(122000001)(53546011)(5660300002)(82960400001)(33656002)(7416002)(8676002)(38070700005)(8936002)(26005)(55016003)(52536014)(2906002)(66446008)(66946007)(66556008)(76116006)(83380400001)(6506007)(71200400001)(64756008)(186003)(54906003)(7696005)(9686003)(508600001)(316002)(110136005)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fN4uSmtLWSlattJmWZ40Ss1mNsDxq6RJx7Rhs4pY5VTl+BOfLYAwVw8LyOx5?=
 =?us-ascii?Q?mJRAt6QA0twjzjetyBXuiS/5fXWHzWBt0EiQO77wwDfPMjN38DAdzWVNPt1C?=
 =?us-ascii?Q?7i7C8wQqz9FTfQ/skWzc5G83JKDJuh2X3rgKnUVqcIdxdZcwQx/MEO/DPYus?=
 =?us-ascii?Q?UNixvGBMr+1quwK0yH4FkeOBiSpFKbd8M6OA03+5I8fjPJhLl4n/fo2EAvo6?=
 =?us-ascii?Q?24SdHwwlz6b94ckt/OUgs7TSWSAsCoZzyZJhlPxhOBKm3kgrBa3XNliW7hvm?=
 =?us-ascii?Q?IrN8hlKjcp7jegj+6jkmGwPQed7B8JlPdrp8AwVeU9qHAFvrgXGG9ii/wdin?=
 =?us-ascii?Q?LNxQbA8aSNmUx+vuT5XkLF3whZIF8sd0sy6IzwmL6lKAHlTlHdRvSeyi53qV?=
 =?us-ascii?Q?incEKniy2eNiqqp60MeCT7aTVlmL9R7aNRlmSrbh1qeorjn8Pkb3/ZtjD1Nl?=
 =?us-ascii?Q?cv2pLoKBnXFED72sUJfzS4zbBoaS1Dw8SBXmKV4DAwMNwZ7f2WCtEWsaQrCN?=
 =?us-ascii?Q?hnrcnLPjh/321u3ePKZW03odY+JGKiUO8vjIQfAMP+/1WGzK3fZ+u9nzwbdy?=
 =?us-ascii?Q?o8O4HNvkVZ/E0iBy1otVesxLLBAtArNHhRIn7go136oJEZYQwgNzwwrHtIE4?=
 =?us-ascii?Q?HFQHHcpqy+wIDOuDtJ3TFfSnusUjS2IvqLdrSWKo6xt+Q9UbSEdHymNa7cPP?=
 =?us-ascii?Q?zTQ/kcshsfDnp9A9FRYL9IaxUnSD6jJmDezUEHoh307u+cS7Lj8wG8VhyiR4?=
 =?us-ascii?Q?+9rj9/1t/geL1cV5B+SiyoVP23MLK6+eTOOrYIFWYe2+jHvx/WIyYpATUSHr?=
 =?us-ascii?Q?pHcRD7F+o/ln2RgzjHZawbPGrFIrNtLVLK15HEFsbbwqAPi48jCtSPKbi0HX?=
 =?us-ascii?Q?OMBKv3dmtPb2tCDm451XpGXZaJFb0RbCnm7vFlVfTbVAr/Ou7oO2u4aVFLCv?=
 =?us-ascii?Q?e2GtVUvrTkMW/AivLfVmG7Oh6XDnjqm18khHTKgpuf5B5ueVyi9RAZe9eGYK?=
 =?us-ascii?Q?o0szSgvKKAr6b/DY2NHs41/iVemKpXuKisAw+EaohOe36CVs5lGXYpDHsCeh?=
 =?us-ascii?Q?tX3oGmLWbndJFTLddJyIvT2eCHApZayvGCjxP9pv9ldpaHsdFZEU0LuVP5jY?=
 =?us-ascii?Q?KTY+04nI21kjaHxakDutKuNOlZALpzbvAbGEoEwtNQizvFhTcHGdng5cqg8j?=
 =?us-ascii?Q?58w+VnE2WpWe01pRDv0xJg2hKa6y3DpyaMdZZzKiosRfD0gkGbmIcE+0pQvi?=
 =?us-ascii?Q?HMyjwKuuIMfjVYhAW86+xSOTbGTqZ8cKRnVo0Os/h/iN8Zk826uOz8RFStoo?=
 =?us-ascii?Q?NeGep/I3XnY7kl94CCRoZigoxT9Sc2Zzo2XEpEZ2+np+x6y3n/eRUBg1uFIQ?=
 =?us-ascii?Q?xL5H6mPwRCheP27IOcEY3fPrJhjCFF9zgePrg5QpyC2T5dihOx00Idz3Agb0?=
 =?us-ascii?Q?vMGSQ1n/WFr7Pod9NoeHam7OS/gviYKbzgZw/pFAXT5mhjC4ELxpsVogOp3x?=
 =?us-ascii?Q?1NefQ2dr+OrwAF1jUJ3QpQD0q42IKgimdkUi/cTB65xYadzIy6p0Yzsberey?=
 =?us-ascii?Q?EDvvpGBMaigQSg5lDY44hnTAcJeTtHFWIG4RJmFuZp83yAyeKLfJE4xJz83H?=
 =?us-ascii?Q?qoG/+CTGdpbFrEnkNPOq1H8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a6f6be0-3a70-401d-e6be-08d9c53a37d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2021 11:00:08.4435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: to2uwMJ3KKOjoPoh6ipY84XIEsOB9h6DHET/ZIQfl0uub/XBXJ38UHJc9csd09QbYNNW0iG3AvfS6rziiMiSEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5087
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Y=
ang
> Li
> Sent: Monday, December 13, 2021 8:41 AM
> To: davem@davemloft.net
> Cc: Yang Li <yang.lee@linux.alibaba.com>; netdev@vger.kernel.org;
> llvm@lists.linux.dev; ndesaulniers@google.com; linux-kernel@vger.kernel.o=
rg;
> nathan@kernel.org; Abaci Robot <abaci@linux.alibaba.com>;
> kuba@kernel.org; intel-wired-lan@lists.osuosl.org
> Subject: [Intel-wired-lan] [PATCH -next] i40e: remove variables set but n=
ot used
>=20
> The code that uses variables pe_cntx_size and pe_filt_size has been remov=
ed,
> so they should be removed as well.
>=20
> Eliminate the following clang warnings:
> drivers/net/ethernet/intel/i40e/i40e_common.c:4139:20:
> warning: variable 'pe_filt_size' set but not used.
> drivers/net/ethernet/intel/i40e/i40e_common.c:4139:6:
> warning: variable 'pe_cntx_size' set but not used.
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Fixes: 467d729abb72 ("i40e/i40evf: Fix code to accommodate i40e_register.=
h
> changes")
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_common.c | 5 -----
>  1 file changed, 5 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
