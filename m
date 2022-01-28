Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9096D49F978
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 13:34:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348493AbiA1MeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 07:34:15 -0500
Received: from mga14.intel.com ([192.55.52.115]:17826 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236511AbiA1MeP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 07:34:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643373254; x=1674909254;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vamGcxIAHAiiNuu/jUqVJxiRnYTEOwOa+p7gQw8PJKQ=;
  b=oC62UltBGh3IXn2sKmp4GQyok+OyUp2uJLwUQRy1Cw5SjbG5XFXo0vyq
   dlZXmkIGXGHHr7K5CCpXHPlRCkY8duQZKUww0BNQST4Ybj0uvOQFLViS4
   ac2LWMS16/WYnX6GEZbbv+Uds/09IGsdKNXYfvYMel4XO4hqV9TQ+//l8
   Md5UzoHKOtqY1pLB4dg7kk2VtJDyxvEBgkmTi/doxxakJ4uGh3X7MjSXv
   Ip/a2ejlKnOkVHs42MfEX7GodMYtS5+tf/RAspRQ9qsZSO4+kU0dEzc9P
   eDbmQC1dSLyMO4TNDa87s+hMuwWvmP2s5T8kxn3odH8+peuHej3/3VIjo
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10240"; a="247333813"
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="247333813"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 04:34:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,323,1635231600"; 
   d="scan'208";a="478272930"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 28 Jan 2022 04:34:13 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 28 Jan 2022 04:34:12 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 28 Jan 2022 04:34:12 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 28 Jan 2022 04:34:12 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 28 Jan 2022 04:34:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMgDc1g/gH0AjoSFFDq0aULhwm/oPU8MQLnP7V+/itCRm3w28DTltPQf52wKxXwOxnD6JVmHOo1iC2M8567K2Xr13EN+ON+hqlFXHAQLifuRrj5FKxNK5T+AlLhDRUiuTJH8LiO8BYaQJHA00+p51r3GGBl+LJ2H8aj47mbhyKv95na8IrgKFSHFRhZQ6HHPn1LAJOJLKASZYzTtHQ1BSuAonIhlwpYnO6KfW4hEmCL4JpG9ddhvkZwvoLdBkCV4Id9gENZ5dai782mAiUgFjCwnp0GXVCx6h6F60lCOgBIk5KUXx/eIzC3MAkw5d20iTk6eEiUnZLHw7JnA4oTnGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vamGcxIAHAiiNuu/jUqVJxiRnYTEOwOa+p7gQw8PJKQ=;
 b=TuQYs65L4A6clDgswHgc4Jrdgrf9r3bUZFAPILTioK+wJEiNBSycHZev81dX+Ku5kC9ACbHNeKfETnU8AvJwDuqBC5k6AgS1N91CdprM/mPq/1O0IS3H5r93u0iKESmSxOHUz4ltQtSTVZ3+KKmENoNcOL7Hyk58PswZMz6FLQyprTCmJH5jWO6MjzZyg+79DQewljenNJIWPESy1jLBgMJkFE9wBgnx+BWBvStL7c+E8hes5fb+qtHS69qSXBGj/OSwpFguUgAXWcLfh+Gkqg8W4uKMUA9OxA1diwUmfG+Z+sK+sDhqs72CpnaTteWHr64YZRhiPmAfyBe5nrdZnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by MW3PR11MB4762.namprd11.prod.outlook.com (2603:10b6:303:5d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.19; Fri, 28 Jan
 2022 12:34:10 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::9977:f8a0:e268:24f5]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::9977:f8a0:e268:24f5%5]) with mapi id 15.20.4909.019; Fri, 28 Jan 2022
 12:34:10 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "cgel.zte@gmail.com" <cgel.zte@gmail.com>
CC:     "zealci@zte.com.cn" <zealci@zte.com.cn>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "chi.minghao@zte.com.cn" <chi.minghao@zte.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "trix@redhat.com" <trix@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] iwlwifi: dvm: use struct_size over open coded
 arithmetic
Thread-Topic: [PATCH v2] iwlwifi: dvm: use struct_size over open coded
 arithmetic
Thread-Index: AQHYFCoLntoNV1yLl0CTU5Lsztq8FKx4Xl2A
Date:   Fri, 28 Jan 2022 12:34:10 +0000
Message-ID: <9fde441c79a6f08ef3c99ded93a00d7bb15c9ac6.camel@intel.com>
References: <87o83wi67x.fsf@kernel.org>
         <20220128093147.1213351-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220128093147.1213351-1-chi.minghao@zte.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e255841-b632-4474-200d-08d9e25a7be7
x-ms-traffictypediagnostic: MW3PR11MB4762:EE_
x-microsoft-antispam-prvs: <MW3PR11MB4762F11B37C10B0B993DD8E090229@MW3PR11MB4762.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1ljJv/zgx3qvhueo12HxrlKUCoM1UwPJPjwvTLmn/LkkuwRya+xMPcO5kT6nfoM+ceZD0jRMZC+M4QFYHBdRvpskZQRLZcj+CB99eUKbWZjO+iVVoQm4QFOeewf1OYrhTXjjWfTGa3U6laT8460GWlBROGgOXzJKEnamLQsVl6cQV70sqehq7xgd1aFfnYmE0QCt0vChIjWH7AowGKRZCdo8amjdWfNuWDJ2XDhKaVF3lVG8BiQ/xFoQuFdKXrtLAQCOIAvddsnwHQg+tbTxnC05995nHgdcn/UhOVRTsO2GR6yoPrg/J4ov7DgyFPVbN8Kj9UzuCw8SM0MUiQboKnNpJTfU5gOwcUZOElMPSlISWfKtvXR92ixS4QGJRxd2rQpWiJMi3mbvYrZkGQLyDCAZKdqdQ8tFtc68/c4Jw/uLu/qJ2JTwinGBy6KdLIiF+ozDYl0JyWoYRbXj+aTIObeoqcfDL9R8duaydtku+61Y++dnfA7y7l4++GmHhqhodIw4GRR1RXCR/yec3TLsCiHCAPuJmVzkrzKuMH6Baj4B6p3SyhWKAsk+cHdF+7dbZSa747SHQ2FPePISTQxLl3++cMtd+OgMPNYtNJpjEDck6nRTuQ9BZCqurzQyw0uPEaVfWsBxlwyZaWOM9NSX/BxKHKrbzFIUaDXQCIwusonNi2PUr7w0pBCrYkYE932O/uqTIng6DGZd89JFZS20ZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38070700005)(86362001)(122000001)(66476007)(66556008)(82960400001)(91956017)(2906002)(76116006)(66946007)(4326008)(316002)(54906003)(64756008)(8936002)(8676002)(110136005)(66446008)(4744005)(7416002)(5660300002)(186003)(71200400001)(6486002)(2616005)(26005)(508600001)(6512007)(6506007)(36756003)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmdsZFFsdS83QnNoSENSTmV1bVU3UUFuR0VZOU02dk5GajByS1NRRTIwZWRh?=
 =?utf-8?B?ZmdIb0lkNjRXR0ZCbnROeUUxK3pkeGdnY1g0S2hZZFlPckVxaWo2UmEyUTNq?=
 =?utf-8?B?VldBZUx0RVNZT3pHblBLaDlwVVVGd1EvVWkzVGxoQjRXTWpTYmR3SGh3NE1l?=
 =?utf-8?B?OXRKTzQxQVdEVWtwQ2lrYnR1c0pEV2xEQ3dySWxSU1k1TUVsZG9ORC9MdmZz?=
 =?utf-8?B?YmRrWVBxcnBMai9JWnlGbXhwZnZYZDVtdFNWY09IUnpPb3FycCtOMFZwWlY0?=
 =?utf-8?B?ZExKV2xQeENWTDROaTNhS2ViSklPeHBUT1hDeE11MG8zOGE4WmJOYnZ4ZWNF?=
 =?utf-8?B?WVcxdktXeVhiS0YzZThXcjYyNnBXR0tPcmNNMk91N1VDTnA3NmxlUEo4Z0t5?=
 =?utf-8?B?UG95TlgwR1M4U0gyekgyT1phSW1BZkw3azd4ZFhOb0F1UWRodDkySk1SKzE4?=
 =?utf-8?B?MUM0VkJTWkN3YXFNS2N0dEpoWU0zUjUrQnJwVlU0b3l6NU1hdlAzdGV2cDhq?=
 =?utf-8?B?WDhyS1VhN1B5QngyNENvSmliVSt0RUNjZzJxRENxMnZ2em0wU1hhaXFpcXpP?=
 =?utf-8?B?a0hZYW5mdnBEMlBvVGhPQ1luTytFODZETWVybEFHWk5maVQ4alZuNk9oVTJL?=
 =?utf-8?B?OC91a3hEamIzQVlMcG1uSklZQlQ4bTFISFZHVlJKV3RubStOMzNzZVdkMjBU?=
 =?utf-8?B?eDVWemw3SHRocEYwVm1Hd3ZTV1o1TTNKMnFmZ3BISUw0a3VGVUJyVUEwNWVi?=
 =?utf-8?B?SHRLWWtOVldjRVY1di9tbkJaMDlSYlZsQUNrQWlqclZKc1hlalFXRmlRTmtk?=
 =?utf-8?B?NXB5dVpXb2pKS2h2SGRQUHBzVitKOE8zdHpTQ0lLYWY0V0x5bEhORHFVSmZW?=
 =?utf-8?B?aVprTGxuWUQwdTNKZ081VkNHdjVzVVd2SmR0UlhZT1Q0UUQwMk9NV3k5L1NV?=
 =?utf-8?B?NHVtakl2dmZpY296WHJJRkl6aU5SM2FsYVhRTGYzNEtuaWZkMEFHd0VaZHk4?=
 =?utf-8?B?TkY1UWVYYUJJWGRITzZVc292M2F6M0d5c0hyazVQOWxlZW5mUFg1ZlBjWlBF?=
 =?utf-8?B?Zi9xeUtSNWRkaGlIRE9LUU9kdzQyaFNLZE1yZTM1RzI1cHU3Z0N5WTcvSTBk?=
 =?utf-8?B?akVIWjY0bWs2TmMvcllrUEFTY0YwRFJCZEE4YmNBYXNUSFNkOFc4WVFJZXNz?=
 =?utf-8?B?TE1lbTA3bUxybGIybU45T0xLYzBjc1JnT0IyYTlGWE1ncHRTa2ZiTFNPd3FU?=
 =?utf-8?B?NTFrRHZHcVJBWEhId2d1UmxZT2hGUjdhUTI5WU1vMnppWGp2Y21FcmNwYUVQ?=
 =?utf-8?B?WkozV3BqaGx0TVZwbnloa1YvRE9QYmxoYjFrcTJrSmp4Vk1RK2lMYm1zUUov?=
 =?utf-8?B?ZTRlNkJvWjFDRURvVVlZc3F4QUVOdzRzWGl5NEJENjU1a1ViSW05S3QwVzI4?=
 =?utf-8?B?c0tzYWkyQk9lc3RLbXZPdkdVcEFqVU5lYisxSTdvT2IwaGZBMmEzbHd5QWhi?=
 =?utf-8?B?NGJYZlFiTWFXQnJXL3lRMENDd3BmcXU4VWl3Z0Q1Y3VtWVM1MVU2VGl6WUVV?=
 =?utf-8?B?aXJsTG9FbStvM01xeWJsWjI0ZUVDUjdOdWhEdTIzcHVteEp3clJXbDVSeEx0?=
 =?utf-8?B?bGc3eXkwMGl3bVpzOTVnSGhTL2s5U2UzRm1BMWJXRkpLMmtEamFaYUJVSmVB?=
 =?utf-8?B?Y2hpTGovclNQWWdGMFRjYVI5V2dvUzlQUnBlMGRzN3gyV2w0ZFZUYStDcWR5?=
 =?utf-8?B?d3JDTEkyMUFmQ0ZMSFZ6Tnl6M2xWME43TTBORTA2cHZHR0xUZGxGSDNqb3lt?=
 =?utf-8?B?VnBXdVlMeTFpSVllOEswYktDYVBKODFNamxGWitVWVN5SWEwTWtTdGxLcU9W?=
 =?utf-8?B?cDc0eGJxMG5UMHRyLzRJMGtaK3hDUXg2Yi9EQkgxR2tCMEhhNlVyYWptSnVD?=
 =?utf-8?B?a0c3WTFpQlZYWmpzRyttaUFnZ0FPY3VxeUUyM2tBT0kzdXExWXdDdEFZZHBa?=
 =?utf-8?B?dkswSFE1ZDRmbTNVcG11YjBVajY3NzRod1hSNVZGSnA4ZkxadU9HQ21kakJ0?=
 =?utf-8?B?UTlmN0N4Lzg3eGFIb0dhSHowZTVxTXlsVmZ6cHBxNWpobC85RUpkbFoxZlEy?=
 =?utf-8?B?N2ZWTytOaEVYUXpBY04zTUpMT3hhdGhacm5zdlRyVjUxQkc3eEYzS1g1dG11?=
 =?utf-8?B?d1NlWnU0QXdkVnhFN1grRG04SkJ4OTN0dUFGZnRBWmJOeUZjU0F0bTA1eUhJ?=
 =?utf-8?Q?/ZdEo/3I4aKAKb4s+ybMkq1ivakMQ2F9SK5fpYO9Ow=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D606D098C5AA0C4BB632074EC97A5F76@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e255841-b632-4474-200d-08d9e25a7be7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2022 12:34:10.2064
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nkftzMKrsG0MkGFYkvSqoVsE8Pix6bE/MrjLUAbQgTQakrXiOZOCMDWjStcY4dJ1DIpjpo1LrFTm9kzDh+rT2TDpXMgN632tq1Tpph595/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4762
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTAxLTI4IGF0IDA5OjMxICswMDAwLCBjZ2VsLnp0ZUBnbWFpbC5jb20gd3Jv
dGU6DQo+IEZyb206IE1pbmdoYW8gQ2hpIChDR0VMIFpURSkgPGNoaS5taW5naGFvQHp0ZS5jb20u
Y24+DQo+IA0KPiBSZXBsYWNlIHplcm8tbGVuZ3RoIGFycmF5IHdpdGggZmxleGlibGUtYXJyYXkg
bWVtYmVyIGFuZCBtYWtlIHVzZQ0KPiBvZiB0aGUgc3RydWN0X3NpemUoKSBoZWxwZXIgaW4ga21h
bGxvYygpLiBGb3IgZXhhbXBsZToNCg0KWW91J3JlIG5vdCByZXBsYWNpbmcgemVyby1sZW5ndGgg
YXJyYXlzIGluIHRoaXMgcGF0Y2gsIHNvIHRoaXMgaXMgbm90DQpjb3JyZWN0LiAgUHJvYmFibHkg
YSBjb3B5L3Bhc3RlIGZyb20gYSBkaWZmZXJlbnQgcGF0Y2g/DQoNCi0tDQpDaGVlcnMsDQpMdWNh
Lg0K
