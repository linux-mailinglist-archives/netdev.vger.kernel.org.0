Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6646248DD7D
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 19:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237502AbiAMSMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 13:12:18 -0500
Received: from mga07.intel.com ([134.134.136.100]:63657 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230329AbiAMSMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 13:12:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642097537; x=1673633537;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6Ac62o13gYFV1Nz0xlWQ+kEpx1uhV8knNbw82O05Tyg=;
  b=dGsYETqE3EzBizywR3PWbKMF7rMXAT/1aUx58rFQxdhPdHXmbGL0WCOg
   s+Z0F2DdRatwODy2DrG9XGbdd5HRXMiUVqnHuKwq00PmBVO8MCQWN8eHt
   yNJeDeto/gHxTkyzrVA0Z3pwRSEuS5B4xtGMSbLSnSPe2OqAbYwOr3EwM
   WkTnOTXVTe0gLDitiEf1k3rTbh0Mh44rwHbmqr8HrVBLJmHf5D4VMAydF
   3+QNWd5uZI3myWXqVTtFrqjLzduYQeBROP74eI/YwuYfyvsjI2Yb++nKl
   L+12gi6r1geZSmC+bP8hnEZmLigy/ukH/6KTA9TMdNIjQ/+ddh00drL5n
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10226"; a="307423017"
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="307423017"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2022 10:12:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,286,1635231600"; 
   d="scan'208";a="614050643"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jan 2022 10:12:15 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 10:12:14 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 13 Jan 2022 10:12:14 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 13 Jan 2022 10:12:14 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 13 Jan 2022 10:12:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQ9FsaxoJ4Md+pTjWl6Di0h/IShD3fwCV4lG/6EXK0UIEOMN5zAOL5DF+Sz43Cm3zd68iqfKBIEFgCgM1KpKs5fIncSvvNtZTejQSW3X+8pS32yXbrBgOXSO4JWvagY2kC8yK4KLwktPW/yMeLCkLG2zHeurhbrDx/LLBI35jwNklwjooBoE0QjDZPkn87lSd0XDktwkSUF7+BWFn6Yj0P0cDggStjmjKJM2vhu76elEo54bGWIXyMYEUo6odf/B0shqf3MklxoFY3B8cHIozW4Vb1yEjW8KyE3YFyMOjpOW7uxZV+ZYhTyrRkLNQLNfkjCPVQlvQLfgoFG0AknwXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joCw6wM54f7bt030EwZabLENilzzqug0bjthJm4BpEY=;
 b=Gps7Vkwe5oPPPeepKyUqgC2MRmRSy4yd9YhItbaaGwKT7fPIRN+6MXxfJIHHEf5Z7LFqbVPGAZf7vvvsnefJJEvSA+k3fhQyfpNREgRJcLjfL1UXTAxkjIKaf0uqPr4jJXvSWC4HZb2Tr+2LohtTugb0ZbEXf+Gn49snNG+SEoPhH7TkTVAdBAj7D77lx7SUJe+EPfWbU0MCxPm/faFLZh2IX6/HskpHN+RcG8A7muzoOqMz9upEG6fxQMohiQVuUiwVonyccJnjGLBTzryiRgsT+u6/hNaff2oWTc3gbM/kGliXpj/x78tYme6QVuIVAmZo6dARGX7VXI2LQJekFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BYAPR11MB3749.namprd11.prod.outlook.com (2603:10b6:a03:b0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.9; Thu, 13 Jan
 2022 18:12:12 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::3162:31b:8e9c:173b%4]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 18:12:12 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "Swanson, Evan" <evan.swanson@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net] ice: fix an error code in
 ice_cfg_phy_fec()
Thread-Topic: [Intel-wired-lan] [PATCH net] ice: fix an error code in
 ice_cfg_phy_fec()
Thread-Index: AQHYA5z+menSk3aWiUaEwXq7UgPTVKxhStFQ
Date:   Thu, 13 Jan 2022 18:12:11 +0000
Message-ID: <BYAPR11MB336762F8D52112D0A24DA039FC539@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20220107080206.GI22086@kili>
In-Reply-To: <20220107080206.GI22086@kili>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fbe1ff5-4db7-4f51-237f-08d9d6c0388f
x-ms-traffictypediagnostic: BYAPR11MB3749:EE_
x-microsoft-antispam-prvs: <BYAPR11MB37490A023E42613FAE19D346FC539@BYAPR11MB3749.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nlVwxTfKA561WGjqNjl4mSmeqM86HLCcVKsnDTtG1pCvlblwP66zIH4CvJMX9sFRMVVacaEp9pTKbbJFtReybgycCm8dCCAd6ECgD1Ii2+b/VCYfAhREvE+NBZLARxkrMAMdm9EPlN22RkK+5g58nmvx5pi7yFZ9xrf1xb7Sg+a75nvYxRvNu4gmIQzObvaFJ7DZlF90ZvXiHLyBP50XT+5zpGv1Uc+wRUU9fNteZqmSmn1j4Pya/YfHVUZRhxxAxsEoT0PA2z0W3io3H+CtPFK4oU/gms0RwC7mXkO+5X1tL9bK9e216uPn0Pi799f1yoYhA3fF7JY0kAW1P9bqZhu6aVaDQ0+mF3Ni387A5Ao2yexS5BhwOlgpc322OZUedbHhWbnIK7U0Lb6OrqSlJv9nJ5QM5EQ4+/s9u871Xhk4aIAmTYvaTgj977FLjBpgB69AYSzpCsTSgSswRGYqAH5Hh2qXbcOhRjBFR++STQSbTKDWypLHZxzdq1Q/2L/EDXDg7TcTkeFb0ctLAX2H+m12EbWKruriqVlidqg3RxuHy7GwPizUzRFjaGL+z5DMjcEXfm1y3ZuNR9PTSj/O+aF5kZrLiCbdUvjqCtn5t1rS4lGamDCj530lWJ1w+05A044YPsgGgXEjJa9GmvDpU4HJlQeWU5McHzgC/vaL/Rp6JK+FqqUiPqdBw/MRCiLoAJnA7sgipXm6V3dkVW29Iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(76116006)(54906003)(86362001)(66476007)(110136005)(8936002)(26005)(6636002)(66946007)(8676002)(66556008)(6506007)(53546011)(64756008)(4744005)(316002)(66446008)(5660300002)(71200400001)(52536014)(4326008)(2906002)(38070700005)(55016003)(38100700002)(33656002)(83380400001)(508600001)(122000001)(9686003)(186003)(7696005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HKXrbw1ovoU5KNdS229q/fwaTIO3MfFpsBZlURYtElWMD647blV76QOX2U4Y?=
 =?us-ascii?Q?9w0/C0G95dAz7jhS2tvOpYgsGsl5b7M6c/XUbzpHqDTDq0goOiXRT442gDcj?=
 =?us-ascii?Q?+7J0UxOoT7fnO7CG1RC59TlY8HxDlwSTb3Z+pnwYHZo4yvy5zYTEGiYJrAT5?=
 =?us-ascii?Q?hn9sPprJ+dNBnfx3LPgHPExJT8S8Ubs+j28pWzstLKuRsefxUt27BEFL8eC5?=
 =?us-ascii?Q?KSOkRnh4I6UTsNZL1CZfggAm2ndSjVWCsgrg8pEr2e74pkmlg7RiBXSjPbiO?=
 =?us-ascii?Q?2dRqpB7UmVYd5l0jBiiHXFz20sAweCPWppn8/XgSodz9ppivP2uyOUdct0HN?=
 =?us-ascii?Q?7dTx4GMiUu6GlE6c6MUuwvGtRI86BO7QCifrKeLkUbe1xlo+rBlShYdhAVMH?=
 =?us-ascii?Q?s1YPAUv+8sS4ZjEC891nlm74NF57e/p1dLZKgVBXheqyKUtl6ljr3wd/QGje?=
 =?us-ascii?Q?GEWgiT8MzdRmSLKQu93KK2bvZ534km3E66Y7AZC0dUku+FT2IwpMX7YQ5hzk?=
 =?us-ascii?Q?8zheo5lmAYaL/pMUZ3mpt4fIO2zuwh5EeCiV6l4+6ibj+uFCv23gkTvKY11l?=
 =?us-ascii?Q?9B9Hqxn7fi5NPica6KNQKNuTMyFcKeo2frN9S2gnOp6T2sqan6/WpIDjhevb?=
 =?us-ascii?Q?Gr6VcE6q62vDvUXU2zTVrsTrTUxtASiY8tCJlSqpcTsSo0sTcxt94Nw0UVor?=
 =?us-ascii?Q?aejIzX6grxJ3jwane7XVFWtl+cmr3duhNrt9C1uUcmdI/hfKZO5HLJYRqrR2?=
 =?us-ascii?Q?CBDiCY9jTjAcbaYl8t2SLGu1MqoDAv1W6mcSu+ae+EFH5J5D+iGf35hI91Jb?=
 =?us-ascii?Q?T0Mc7xDyIerDWWn/aaRiSI+iVVdNupOj6y5o10YDBAjVJLcWUvgtK2xDlQKK?=
 =?us-ascii?Q?v+nDyTkUPrIQ/6teTjmPYhEQ0RmTUWqbyaDSiAwHEiayKp8ArhuDRp8XpNRs?=
 =?us-ascii?Q?OvkWpbLEFRzROH1vPZhuPNSMNLneQALSV6ipyU81TUGWujChXGwFxo5ZKiEM?=
 =?us-ascii?Q?DxAXe0PzYGEbokKQj/aO7L/Gk6+nfjObxHeytMPZdDtB1PM7C4wxptdjV5c8?=
 =?us-ascii?Q?pQ2qVNK2AeqFruHfcxnQi3ocOkoEPwQdGNiNi7SycEZ1l4mc6eZttBclHOgG?=
 =?us-ascii?Q?dFobz4uMYUQlqbinoTQfyy2PRYHSEyxfmbpGiSFW9p2VzwmfZDuEsDRqmQWa?=
 =?us-ascii?Q?EZsoKimoHy4r6N0TkiZOVTH0XUjCCr/gcPc661ZhPr2ApD4gOGN015joJPsr?=
 =?us-ascii?Q?xLml44GuMN+1nvD7OwzVxFR+LUOp6HnB76MGODJcf4fBHiNVDGSgVcKIOKAB?=
 =?us-ascii?Q?hO6vXe0IHfAfB4/+5caNDu/s3WwCkOSZP34pO26vVmBAz1FkiB2Cd57fhg+r?=
 =?us-ascii?Q?Z/TkGU7gf0fHHCeVHwT/VVgFhwmU++YagMYH5llX+hnoWJS3yG8ngJ5mzss3?=
 =?us-ascii?Q?8jLsKOerq26lgAOm7RtX5IAvcQTK4YwlEA+4JF+Dc6hxsJyUZ/RTVscjF/jQ?=
 =?us-ascii?Q?WoOMG/vipnyZgjNSDWXwUWxhHTvSr/7Nel5tE1sTy5+3Jc/qLLblsufPTlOq?=
 =?us-ascii?Q?ZVFXcwYajPsARryZF5g1AZg1f3mHWT5dX4BsFRXvqK8fx1t0fa8GBS0jSKtP?=
 =?us-ascii?Q?xA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fbe1ff5-4db7-4f51-237f-08d9d6c0388f
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2022 18:12:11.9355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lzY9fSMD5vKfmDQl2M5ZFVM8UyS6W0onhsDcRWJeV164n35srePMW/ESZf2Xubcaa84uiYzIi7sAx6B7++rnog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3749
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Dan Carpenter
> Sent: Friday, January 7, 2022 1:32 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>
> Cc: Swanson, Evan <evan.swanson@intel.com>; netdev@vger.kernel.org;
> kernel-janitors@vger.kernel.org; intel-wired-lan@lists.osuosl.org; Jakub
> Kicinski <kuba@kernel.org>; David S. Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net] ice: fix an error code in
> ice_cfg_phy_fec()
>=20
> Propagate the error code from ice_get_link_default_override() instead of
> returning success.
>=20
> Fixes: ea78ce4dab05 ("ice: add link lenient and default override support"=
)
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> From static analysis.  Not tested!
>=20
>  drivers/net/ethernet/intel/ice/ice_common.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
