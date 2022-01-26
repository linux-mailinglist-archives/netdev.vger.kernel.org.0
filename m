Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A50D49D4A1
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 22:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbiAZVjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 16:39:43 -0500
Received: from mga14.intel.com ([192.55.52.115]:30397 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231478AbiAZVjn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 16:39:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643233182; x=1674769182;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iEK5+0srBFU680aOW6ei/TfkyNx/5rWU7XXZywJK6yo=;
  b=Dmoz0JfBKvfp1BLhG6j83omAIOrxedOM6LTV459yRPi4NQNJ2+W0dON+
   WE5tSr7Ou7S+/aCiqmFbTbJOBRzUAtok+af9WJQEPGXj1ZNRCTMjkGDAT
   IEnAxUIY4/IsWqdfUaVWNlhMDQ+S+Lh8o33ydC6JR9JX2v0UAnp+BWJ/T
   F5b1CT8VhGLdXrY/j8squnU67Yd/kFWZHJkdh6nzz25XTahKjSkUVpftv
   +s6bBy1n84YBLm4gfHfwi69L4Goh3rFCcL740OINMwtoH4xesPATtI6vy
   R/K5CfJ9psTsEygThz0qbh7ImRo7GC3/oVD3pceEzrrpd3e0GgT9lBk+8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="246877008"
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="246877008"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 13:39:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,319,1635231600"; 
   d="scan'208";a="769499339"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga005.fm.intel.com with ESMTP; 26 Jan 2022 13:39:42 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 26 Jan 2022 13:39:42 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 26 Jan 2022 13:39:41 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 26 Jan 2022 13:39:41 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 26 Jan 2022 13:39:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6Vw+pGHTZk6jtsMtmx881ZgHCmBqNASXE/jYGXkk9B3LqKNBipPsCE61IIhj+Dg561XMlXDVJudr83zCZf3ocnrK7H33iNXXVeVyt/27hkfIegA+gK+eyfIk/d+04wqvIzsLWgfobbVGbLcS6+pRT3JlEbqu608rTG2uX9lInkVn7wEKtpJlNijT5GGD+bYvKIEbLbAm/EibyWKo4veNRmRHnJwCb8bIhs+e4jpFljxHD25bDHgLeJ3s/fmtZpjUiDfEFlW4Srysv5Gt/c0aUDee+fkMebym9lAV8NWNNLPf2a9eC34Yc43KxgxJ26T5hWq15CHEaPvdF6APGFhIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iEK5+0srBFU680aOW6ei/TfkyNx/5rWU7XXZywJK6yo=;
 b=hYH9EhA9+6+fKqfzYwO8hD4isTeKuNOkQ8RjaLW8Xbu8zRjpBQB5U7+2KEZ9q0Iu3qjZNlwi+uvT7zt8y7RwT7Azp88Fa2Dy3qe5annopPitUoBGup7fJJUEFukema2Llpl8l5z0O/2dq3fuo1tQJ8ZTl8OU0WIZqITHJj9adutR4lLdjJ11zFRGlBQrfUKXN2K39k8+ygP0ICtaonNRTutbPCQ/Wj0GFt6CrADB36BOmlZQZXbwc8vKQ3GnzrTfpri1ug4kh6U+HrJLRy29MbKcuhOmVW/hjl/bCVrCWcZBXpKRzYmQXk8ZhHcyWbfOjwnE2vK4Mpea5brrie069w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BYAPR11MB3224.namprd11.prod.outlook.com (2603:10b6:a03:77::24)
 by DM4PR11MB5536.namprd11.prod.outlook.com (2603:10b6:5:39b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Wed, 26 Jan
 2022 21:39:39 +0000
Received: from BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::39fc:1b8e:f6b8:89e4]) by BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::39fc:1b8e:f6b8:89e4%7]) with mapi id 15.20.4909.017; Wed, 26 Jan 2022
 21:39:38 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        "Szapar-Mudlaw, Martyna" <martyna.szapar-mudlaw@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] ice: switch: use a struct to pass packet
 template params
Thread-Topic: [PATCH net-next 3/4] ice: switch: use a struct to pass packet
 template params
Thread-Index: AQHYEUh93Nf+6AhoZEGW2tQUnrEoGKx118yA
Date:   Wed, 26 Jan 2022 21:39:38 +0000
Message-ID: <6375d82b976f18eb085859082c548b35b168cf14.camel@intel.com>
References: <20220124173116.739083-1-alexandr.lobakin@intel.com>
         <20220124173116.739083-4-alexandr.lobakin@intel.com>
In-Reply-To: <20220124173116.739083-4-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ce7f9b0-13f5-45d8-7eb9-08d9e1145a93
x-ms-traffictypediagnostic: DM4PR11MB5536:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM4PR11MB5536E42D58BA08D1998266B9C6209@DM4PR11MB5536.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K0cxwKTdu8bEMgPJfOAMeeDMPNlKiO+u+OTyP5aaYIVbcWBeRz3F75NshxdiOSxFN3twikkdLJYlZbnjp7Vemv2B0xnANONpZ1uP7wra6XFo+HAVGfS5lZyOl2VowJvgllNinMicy4YjE8WWSHF29zcV00I0EEPcpJ5pg2A3Bb2qRDQrcSxWr2mbsd2rkZujtD6J/CRL64IqjIICvojEmxGJmaAeDDRMLMBcntBi/lJ1jUZIkVCr00ye3F/+AKJtfyP7fGifWBgiCg9IjAvJD7pD9zbgl6+KNmabexp0OGwHm69AllSEX+8MbRft4iDvrZlfka5TQ05U7qH4lC7QVuvfWJdJ6t35obFC6PRQV4nVLYMxIO9KFP4Ckav3ZAypxv1aiSKMGpghAvxK0YLpYSiYajJQzZYVLxy6BgAUU2ZoQ1tdz+rCOP/72iBOuavCso/L73KWeFaeLouO/aQd2lOpg0q4vFFGo562pNvSNNEpyMtc5o54G6VVnoWZUUGXNcebkJ8YS2MjjNL/AzcY9fXAT1A+E+3gW+rLPM4i8jB3xC6CFV56dOOTV/C2EFxWmApNDFcflXgdD6UpfmyVApRtYegcpWC9ysf/QNpWW43HADa9QAb2gB5j+6WT4/9N0+2Faf5ppy1M21fOLC5kMj6hS0uPJEDnqIzjsiEIstXYm6CPHuTdn60KRUpSiJnz7NKYhqmE+/Ue1Unvd3/3BA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3224.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(508600001)(6512007)(26005)(2616005)(110136005)(54906003)(316002)(186003)(5660300002)(6486002)(36756003)(8676002)(122000001)(86362001)(38100700002)(6506007)(2906002)(8936002)(66946007)(64756008)(66446008)(66476007)(66556008)(83380400001)(91956017)(4326008)(82960400001)(71200400001)(76116006)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NnljOW96MXF1aWxVQW9WVHU1NUVMSFR0aUZwdmhKMzlUWllzWUtQRm1VM2VG?=
 =?utf-8?B?SE9tUlI2RDZ1N0ZXRXNjRWw0bzNEbjA2aTQ4NUp2akVReG82ZXlCWjB4ZEpR?=
 =?utf-8?B?dDVvN3BTeEE4NUh6V2FTdmI0WFdodHI1ZUROeVNiL1pCUWY4V24vUHVwQkN4?=
 =?utf-8?B?cldKQ1g5dk4vRThkTDI3bEFUbXBRNm5jQm96WGtuSWU3STlzd0E3cmZ5U2Rh?=
 =?utf-8?B?eVN3YktUWTBRWW9iWG1DNHl0UDhUSUFpeGxGTzZnNDFaUVgrV3d4REZWT3Vy?=
 =?utf-8?B?THFKZWhVUXdEWEhQc0RzUk85WHc3bGtDdmJqN3lCWmVZWUEzT2tpUUY1dHdi?=
 =?utf-8?B?Wld6clduNlpOT1hzb21PVUJsVU5oaHZuSGZZNkxpaFBCR0d3SXE4dGEyYVUv?=
 =?utf-8?B?SGp6MytPV29FeGk3ZTJobnlTUFVnZlkwaWNIUVdXakh1QTVTM1lPaHZiMnIv?=
 =?utf-8?B?bGhzV2p6TktrNnRCNUIzVnJMd2Z2ak5PSmFkbEtVK3B5ZVFEVEQxa29lQ1ZJ?=
 =?utf-8?B?bGloSEkxU3hYeUM3eU1FVVJsWk9jNEJrZTF4Y1cxV2hjek9JMHhaVDc1UHRS?=
 =?utf-8?B?Y2daSTJXRlowVWdnc21vVUw0UDBKQnBWbHlha0RvSzY5NHN4NHJQRklLNlZV?=
 =?utf-8?B?a0hmMzh3T09YMVpLTU4vMTBPcGNwMnYwQktnYm94TllPc2tUTHhVRDNsNlQz?=
 =?utf-8?B?MTVMQkwyUEhNU0thNkp6T3E4V3gwUTlDVTZCL0ZPWHBDQzNnRDdSZlcvLzgx?=
 =?utf-8?B?ejFtUjlTOGUxam8yQnNNNUtsa3dSMTB0N3Q1a054cHRocGxMSG5tcThjbnBi?=
 =?utf-8?B?OWszK09ucXZGczN5VFVOYlVNV0hzeW1NMzRIeHlmOWdSamp4aGZ5WUxhZXVa?=
 =?utf-8?B?andwTlBJRW1rT3pJNkk5ckVIUjFlalRNakNaZnVNenRwNWlpc1U2L1lOSGsx?=
 =?utf-8?B?b0kvS0FKdXY1RHorMGVmd0FFcDJHTXFCNzNjVUdpaUIwdGZwWGFzYTBBQzdy?=
 =?utf-8?B?Qk5sVi8yRmRGdDMralU5cXBpS0tUaElPVEw0ODBhK1JNdG83Q2RrY1Z6b0Zm?=
 =?utf-8?B?MlErSzEvSDBKUWhWOXRDbFFtMEVPUWhZaWJaU0tZdldRa2gzVHhLc1VndGJj?=
 =?utf-8?B?cEFNWkpGVjNLTTFZWm4zc0QzTVJCM2RycmJHTWdQV2Njd2tRQ3dycHFYRjE5?=
 =?utf-8?B?ZE9PSFBrcWUzdVd6VmU2NlNSTkVCN2htc1BBUDVQTjhGWlJwa0ZnRU54RjlN?=
 =?utf-8?B?RytBa0w0Q1lxQ0toMzg1ZEhOUkZSODZkT1dmRU5NQVE4Nk1ReHVRdEpWbHhr?=
 =?utf-8?B?WTJ6T28rM3N6Qm9VeGlSTnpmN2lDQTc2RDFFR3R1SllVbUVEMkR0WFVXUDVi?=
 =?utf-8?B?VllZQmFXWlN2YjgxcXhtSVdCNTdHekthY2tjc0FhM3hRa21xandzL2RFK3JK?=
 =?utf-8?B?NitFTHZnbjU2OGpvTXpFWmFCT1JkeGZ3eTBYanZwZGNnMnJhQzJlYW9NNFEx?=
 =?utf-8?B?WXFYRC9QYUkvUjhqa0s3OWplK0N1bitrbFNtSS9YWEVuYlM4Y3hCOTMwaTFp?=
 =?utf-8?B?Nllib0tDVVZaOFZBYktBVVArZ0RaRHdFRzRwVEF0RWJHU2RqOWJPMjFNbTIv?=
 =?utf-8?B?Z0RvMHFFajd1a2ltKzdXK0QyNFZxd0RkZGVVa2dra1RVc3pkbHUxOS9RUGhq?=
 =?utf-8?B?QmQzL1NQRkFPaEREampScGx5aThlWXd6eGcrU0U1ZGRtNjlLVWgvWjRmSEtn?=
 =?utf-8?B?UGVLcENLY3VueGcrK1AyNENZYkQrVVNvdjZlam1WMUtGc0Z4dHorWFBMZE5O?=
 =?utf-8?B?WlRYY1UxeG1Id0twb0EzYXVkZzlpVTNaZlZ3NHNBL3cwR3FsR3VqU1hSbWYr?=
 =?utf-8?B?dm92Y3hsMXJHQzUvY0YzUkloTkJDT2RLemRyRmlQZTdIdEp1MEFLTzhtTHFZ?=
 =?utf-8?B?RzMxWGJmMldiK0ViVFdSemJkMHRzVGNtMGY4aFpTNVBzRWtGUDFEQm80RGQ3?=
 =?utf-8?B?a0JHTkN4a3FuMWExZnRER2NtcXMybHBaSGcxVE82bEZHbEFtUXJzWmt5U0RQ?=
 =?utf-8?B?L3dISlE1SVBUWTJEcmhrdmNmVUJua0x6blRLSThLNURrbXhqdzEvdThPYU9m?=
 =?utf-8?B?RFhwYUFiNzZTd3hVcXJrN093UGtPeGdoUGVsWHQ2ZHpQOWc0S1RjejVVbG9R?=
 =?utf-8?B?amIwVnloRDY5dWRMVUdhVUxFaW5WS3hHcVNBOUJBNnNBanpIWGRFWUd2YW5W?=
 =?utf-8?Q?FMs3Xolj7x2L1fTcFkbniSynkMCHcuufgTduOjin7Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4EB25B1F275C6343AAA6F6C8AA2B9B04@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3224.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ce7f9b0-13f5-45d8-7eb9-08d9e1145a93
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2022 21:39:38.3128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: prDzV9OPan5eO+jtbiJweNAmwJdu7V3RZS1/9NCiJf2ufZcpnK3xKFGFT3TI0cazMOL3VBISh6oGZgfwj/q2rTX5EMoTaFJyXZl93ATolzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5536
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTAxLTI0IGF0IDE4OjMxICswMTAwLCBBbGV4YW5kZXIgTG9iYWtpbiB3cm90
ZToKPiBpY2VfZmluZF9kdW1teV9wYWNrZXQoKSBjb250YWlucyBhIGxvdCBvZiBib2lsZXJwbGF0
ZSBjb2RlIGFuZCBhCj4gbmljZSByb29tIGZvciBjb3B5LXBhc3RlIG1pc3Rha2VzLgo+IEluc3Rl
YWQgb2YgcGFzc2luZyAzIHNlcGFyYXRlIHBvaW50ZXJzIGJhY2sgYW5kIGZvcnRoIHRvIGdldCBw
YWNrZXQKPiB0ZW1wbGF0ZSAoZHVtbXkpIHBhcmFtcywgZGlyZWN0bHkgcmV0dXJuIGEgc3RydWN0
dXJlIGNvbnRhaW5pbmcKPiB0aGVtLiBUaGVuLCB1c2UgYSBtYWNybyB0byBjb21wb3NlIGNvbXBv
dW5kIGxpdGVyYWxzIGFuZCBhdm9pZCBjb2RlCj4gZHVwbGljYXRpb24gb24gcmV0dXJuIHBhdGgu
Cj4gTm93LCBkdW1teSBwYWNrZXQgdHlwZS9uYW1lIGlzIG5lZWRlZCBvbmx5IG9uY2UgdG8gcmV0
dXJuIGEgZnVsbAo+IGNvcnJlY3QgdHJpcGxlIHBrdC1wa3RfbGVuLW9mZnNldHMsIGFuZCB0aG9z
ZSBhcmUgYWxsIG9uZS1saW5lcnMuCj4gCj4gU2lnbmVkLW9mZi1ieTogQWxleGFuZGVyIExvYmFr
aW4gPGFsZXhhbmRyLmxvYmFraW5AaW50ZWwuY29tPgoKVGhpcyBpc24ndCBhcHBseWluZyB0byBu
ZXh0LXF1ZXVlLgoKPHNuaXA+Cj4gQEAgLTQ5NjAsMTEgKzQ5NzQsOSBAQCBpY2VfYWRkX2Fkdl9y
ZWNpcGUoc3RydWN0IGljZV9odyAqaHcsIHN0cnVjdAo+IGljZV9hZHZfbGt1cF9lbGVtICpsa3Vw
cywKPiDCoCAqIEBwa3RfbGVuOiBwYWNrZXQgbGVuZ3RoIG9mIGR1bW15IHBhY2tldAo+IMKgICog
QG9mZnNldHM6IHBvaW50ZXIgdG8gcmVjZWl2ZSB0aGUgcG9pbnRlciB0byB0aGUgb2Zmc2V0cyBm
b3IgdGhlCj4gcGFja2V0Cj4gwqAgKi8KPiAtc3RhdGljIHZvaWQKPiArc3RhdGljIHN0cnVjdCBp
Y2VfZHVtbXlfcGt0X3Byb2ZpbGUKPiDCoGljZV9maW5kX2R1bW15X3BhY2tldChzdHJ1Y3QgaWNl
X2Fkdl9sa3VwX2VsZW0gKmxrdXBzLCB1MTYKPiBsa3Vwc19jbnQsCj4gLcKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZW51bSBpY2Vfc3dfdHVubmVsX3R5cGUgdHVuX3R5
cGUsCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgY29uc3QgdTgg
Kipwa3QsIHUxNiAqcGt0X2xlbiwKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCBjb25zdCBzdHJ1Y3QgaWNlX2R1bW15X3BrdF9vZmZzZXRzICoqb2Zmc2V0cykKPiAr
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlbnVtIGljZV9zd190dW5u
ZWxfdHlwZSB0dW5fdHlwZSkKCmtkb2MgbmVlZHMgdG8gYmUgdXBkYXRlZCBoZXJlLgoKPHNuaXA+
Cgo+IMKgLyoqCj4gQEAgLTUxMDQsOCArNTA2NSw3IEBAIGljZV9maW5kX2R1bW15X3BhY2tldChz
dHJ1Y3QgaWNlX2Fkdl9sa3VwX2VsZW0KPiAqbGt1cHMsIHUxNiBsa3Vwc19jbnQsCj4gwqBzdGF0
aWMgaW50Cj4gwqBpY2VfZmlsbF9hZHZfZHVtbXlfcGFja2V0KHN0cnVjdCBpY2VfYWR2X2xrdXBf
ZWxlbSAqbGt1cHMsIHUxNgo+IGxrdXBzX2NudCwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBzdHJ1Y3QgaWNlX2FxY19zd19ydWxlc19lbGVtICpz
X3J1bGUsCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBjb25zdCB1OCAqZHVtbXlfcGt0LCB1MTYgcGt0X2xlbiwKPiAtwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnN0IHN0cnVjdCBpY2VfZHVtbXlfcGt0
X29mZnNldHMKPiAqb2Zmc2V0cykKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGNvbnN0IHN0cnVjdCBpY2VfZHVtbXlfcGt0X3Byb2ZpbGUKPiAqcHJv
ZmlsZSkKCkhlcmUgYXMgd2VsbC4KClRoYW5rcywKVG9ueQo=
