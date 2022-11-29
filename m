Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0971463B679
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 01:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbiK2ATF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 19:19:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbiK2AS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 19:18:57 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66C331EEF
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 16:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669681136; x=1701217136;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZkFjBInh/fhG0j6exqojI/PJmS1lxQ1MVAYvu5Ekg3U=;
  b=h6JWn9PCLKO437rcV4Yos4gVWpSBLOF3EQMVfh7fs8Dybp1jUeWc7U8P
   1WBjXukhdSzZlz5KqUGQ5PadCn4FcOPSSw+qwKFgDEB2H3tyA5bleYEq4
   9mr4Vpq4QyKs+72zSToNn6PRWQ7kd71/csjfNEmrDmcthLF/fBBr5XPrw
   aOcYqJ/IvItyoDkGU+3UB7wbLrUiUBsn9XvCoJoLp2rtrPc7sX5/nxLC4
   ehBvjY4yR2orgyodjach4jAjsDjOrg0AYvD1B1Efbj9UVqMtidxrdmYUU
   oe4xJX58jAFIYhH7GMVEju87ZtqopiqnNtUNhlGD0+zm4H+f5a6eYOMOr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="294674381"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="294674381"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 16:18:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10545"; a="594064385"
X-IronPort-AV: E=Sophos;i="5.96,201,1665471600"; 
   d="scan'208";a="594064385"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 28 Nov 2022 16:18:56 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 16:18:56 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 16:18:56 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 16:18:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrnhHJeIg6k3GAxqTXyp98ofNniyd7eLwlHfl82aVWmSU7ifPKc20AvNqmLRIiSV3wWdA/iZ6bjWsD8g9ikCQaXzQV3ltF05sDtnOgrSG+kWOEKIHc7eAQ67pvnv9Qyn9jWXvfbb1l2WKVZlnC85kQe9UOZMWgl/K84+LYBKf8FlDXbLYjrLZpDNlnZXcC+OfZYcL8JrpCL9q9652GrlOxm7KwkVRwhY23cKX+656xFISvRd+MWq2kG8JW6jJDRq3O9FzcXHbaYH0soq9QtQOhjMIgdsUZRGhrTgCDPK/4II2/p3Ls2NHBvbcmWQhwNKEUU7HYySdsP/es8MsWKk+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZkFjBInh/fhG0j6exqojI/PJmS1lxQ1MVAYvu5Ekg3U=;
 b=e7ipMZcbS2KJksk9rmQUFpbRV23TKX5hadT5pszy+Ex80VqfrJDjRX+Z6ijSC0tZZq0yRwobXRpffpmAD5BTPDpd8Khl/Ko3LW3on58PN+P84DezvFNbb8pvjYOXel8lnQMdGUzz0LxkfNG8xnPZN4prFzSbgO6p9LmycBHd+x7/bxqp911ZBrMWZeDH/Q5nTkLHm/Rlttrq+F16fBslua6NQQnqJuDhNK1FDNM5vcTF63Yu/SG41rQO/z0MSQrLqxGaK47O1Gs9Un8H8Pnh8V1wo+6L0IsH/uddgrZYGOfbDsuk+I5TJb0TS/ZLYjHKkPRG14aFUAH/NuzJmrJO5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN9PR11MB5546.namprd11.prod.outlook.com (2603:10b6:408:103::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 00:18:53 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%6]) with mapi id 15.20.5857.023; Tue, 29 Nov 2022
 00:18:52 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Shannon Nelson <shnelson@amd.com>, Jakub Kicinski <kuba@kernel.org>
CC:     Shannon Nelson <snelson@pensando.io>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "drivers@pensando.io" <drivers@pensando.io>
Subject: RE: [RFC PATCH net-next 06/19] pds_core: add FW update feature to
 devlink
Thread-Topic: [RFC PATCH net-next 06/19] pds_core: add FW update feature to
 devlink
Thread-Index: AQHY+6OB9jIRuo/XUEmDcCW4ZuKVkq5UtsWAgABCrACAABLagIAAA3+AgAAH6UA=
Date:   Tue, 29 Nov 2022 00:18:52 +0000
Message-ID: <CO1PR11MB508985697264AF426CF01AA7D6129@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221118225656.48309-1-snelson@pensando.io>
 <20221118225656.48309-7-snelson@pensando.io>
 <20221128102709.444e3724@kernel.org>
 <11905a1a-4559-1e44-59ea-3a02f924419b@amd.com>
 <20221128153315.11535ddd@kernel.org>
 <2acf60f9-1ce0-4853-7b99-58c890627259@amd.com>
In-Reply-To: <2acf60f9-1ce0-4853-7b99-58c890627259@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|BN9PR11MB5546:EE_
x-ms-office365-filtering-correlation-id: 706b44ba-85d9-4638-eb08-08dad19f4bb6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iTw/BjlBqHtK8CZeVBZ/ygZeuq0ktqpoqwntfI8xkOUVRnU8CYhWi4KfPz+QyWnU6JojzbfbGf1Y8RJiPO7CmqNQFxtDrUgN551SGIpAMtttqLAxwdt4cVp9KUulwsmCOTDSq53AS0rheut5mhy6USqfuqJ21R7QNvF0u5toNndr1nC9KKe2gS2icw6o0qXAnYeDUuRuvx2pZDaBPVC0nq+SNWZMs7u0EvgcnWsjlOtzPy2udalLn5FzkXFmJurBd6uFj9G1WV1Ug2aJKcHVbyrK+TlPmsNVNfo1kQXirk45GBJ0Sq5sqghOto59ONhCQNNzznaWiPVVkOjFFHMUDtjRKS5e80UIAOPVIJ3G2M2OffRHqfWmNGJ/D5Z6jIKgVpF2+mFRLCcBoOcy8eatzy+2GBNgIghnn8bR/U40TjNaP+bTVcFWas39s8Q1ECveXJet9zBpDwg0Ulgk7iryBqnJr+hVH0rcdWbZmFLsgebHF6VEoqHZo07xxOrqytLHKCBIE2UT9/hHY6jYp/Hqn/PNdRYdcFAB75KMQ03Hb8koQ5e0aw0mM7AboqNWxAaCcsQES6eT8nvjLua/I0s9DxaAMFd6Y+ZebSzhOy6hXnq1kXrCZwcuRSK/S54bYyeX1k08uj/gN2ZSlLuiZsEtzRd0ighoMd35PdGDaWuLFGHOizmWIQypGG0fgLBK4mxBVshvglG9TuyAgGYKN8hPOg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199015)(55016003)(38070700005)(86362001)(9686003)(83380400001)(33656002)(71200400001)(54906003)(7696005)(6506007)(110136005)(53546011)(8676002)(478600001)(8936002)(52536014)(5660300002)(66556008)(2906002)(316002)(4326008)(15650500001)(66446008)(41300700001)(76116006)(64756008)(66946007)(66476007)(82960400001)(122000001)(26005)(38100700002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWVORlovOUpYdHpjMkk0Nlk4M0h0R01BeFN1WDBNek9GZ2J3alYwNVZtZVFD?=
 =?utf-8?B?MkxlaEFqeS80T0xtQVltRUN4NTVHSVlHQ21rcnJZTTdnTGlaa2ZiQTZnaVdV?=
 =?utf-8?B?RDlUd2VmZDVnQ2g0TitLalhGYzVRMVVjdHZTYys0VTA2Y0NTaS9Ba2xzTGcz?=
 =?utf-8?B?N0tzeHI4QUxMZk5wWUsyeU1uU0lHcGtYbDR4bHV3T00yNEVUOHo4SEtaanBx?=
 =?utf-8?B?c3RXeWFUR1J6NHdCZDJ6cGZjS2NTSWdQUis5T0lsdWJHa0ZWeXo2b1Z0Ni9j?=
 =?utf-8?B?eEt5MFpzN2hTcmV3VzN5eVNwTW5MVFpmMzJSR1ovaXhTM0dldXZoWHkvbnNu?=
 =?utf-8?B?MDh0OXVvSDl3cmgzd2RhSjloOVJ3TjhEVHE1RzNhWit1ZGJVd0luWGxQZHdO?=
 =?utf-8?B?ckliVHRGUnNTd2YyTzdYZnA4UitKbFBJUmNhbERFL2kvSkhVQkJlbHRzb2JW?=
 =?utf-8?B?RFA5NERpVHBqU3g1ME5KczRjdHBOMDBKM01FVCtNdGZzRjY4WDZoVlBWL2pB?=
 =?utf-8?B?Z0VXSmhvcXdIY1VRMitITUVobXpNNThYYlIxbEV1K0dXbi9YbWtFd3Q0RWpH?=
 =?utf-8?B?QXhRVDRDTUhPRzRMYzhsODVKZmhtTUhBeTl0aFNHVjN4TlAxVWcxMUJ4dkZQ?=
 =?utf-8?B?NjVZWEJKdzZOQlZpQ0tKU1RKWEJWOHUyNkI2c291RG5NSy9TZ3owYy9rT2d0?=
 =?utf-8?B?MllEdlNHOEROU1N5bkRBaGRDaXFRSW0zaU5SSGx1TkwvVGwrWnpqRi9uNk1M?=
 =?utf-8?B?aUYzOGhKQ0R4OFA4ZFZ2VC8zQXpJV2x0cSs3ZytSUXpEeDNYTzkzNlZ0YnNW?=
 =?utf-8?B?L01obytTYXpYa0NMaHAvM2ZtdTArYW1XeWVNSERpeXNlZkFJRTFyajhNd3pG?=
 =?utf-8?B?ditIVVl6dVRHNWlEc0kzSk90NC9ER3V6NGdKYkdmcVFEQUE3NVczL2hjdllR?=
 =?utf-8?B?b0hTcXBwT2RiNU5oK1RLUWxOVUxVbnJMN21kNHphK3pzaEIxeHkvN3pucEtq?=
 =?utf-8?B?MWNvUW55VytFKzA0RVAxVWZ6b3A5T1hMcDEzSVpSanRzRG9zeW5Yc3dyelpw?=
 =?utf-8?B?ZzFzNjNaUHhZZjJRRGd0YTFaSnlnbnhtbElzYjA0ai96ZFF1TncwNlNHbTNF?=
 =?utf-8?B?L1lvd2VzUmJINzNzNldlMWhQbHhPMkt6U1FnQkFmRXBWUWtlWGl1SzBMMWtI?=
 =?utf-8?B?Rm5XcXEzbWIxYlhuM2R3WDRIMmY1ZkxNOGlsRFpDWG5Wd3pEZW5LRzBnbm80?=
 =?utf-8?B?UEJuc3VqUVNFMVNNSWxYdUFzcmhGS0Nwc1MwYzVxMnBnR0hjQ2wyVk1sRE9V?=
 =?utf-8?B?clU5eTdxWHlPbmsvcmF1dW9NdXhGTHpKRGhITytBZ3BDcnNVR1BlVnRpc2xJ?=
 =?utf-8?B?M3hzS05PUTdsYU5aSXZvR3Z5SkNvaVY1QjU1YWxFbFlNcTk2VHdLbytiK2tR?=
 =?utf-8?B?T3BCUmlkbWc1SXBQSG0zT1N4Zm9FTEJkZExUTEZVZExJY1NiRVdNZ1RQdVRE?=
 =?utf-8?B?K0NnYmpxZy9KL1N5Zys4UDJWSTc5TGdtSXU2eW9ySVpENFpKeDlsbUl6S1Uw?=
 =?utf-8?B?bUFXaHZqd2pHL2xiSmxaSEdrMUNXcE1jYXQyQlJoVytxWndTR3VYSFFYa1Zi?=
 =?utf-8?B?SmE3b2VQdU9aUlNPWGpHVGtIYWVEbm96SmpEckJ3NFNuNVEvdWIycTF1Q0NT?=
 =?utf-8?B?TnovbTFhWEVKOWJOcGtjUmNkZHEzSk56Rys2dzRBTFBSeFRGYmpwQ091Ny9x?=
 =?utf-8?B?S0dmRVExL08wR20rVCt0emxCSUNQdWhrWkRacUkrREphTmZVanhtcnRMdEFW?=
 =?utf-8?B?MzUvWjVKaFhCeGQ0N0dRQ2NJdW5Pa2RMUVIyQUJDM2p1WDNtY0RIR0VRWjVw?=
 =?utf-8?B?Q3N4dG1ocDNEQnpvTkQrRHNmY1czYmZwRG5QVnlWdTEzZmoxYlZ3WGp6R0tH?=
 =?utf-8?B?REJESkdQNFh4SEhoMDFpVVhuQi9ZTFJnUHQzR0h1clQrWDZ0UGFoajBWUGp6?=
 =?utf-8?B?NWZPMTVkbGpYSmxRaVlJUnM2Skw0eXQvdHM2R2h3ODhOTjZhT2c4YmxNbTNZ?=
 =?utf-8?B?QzljSFg0cWVCeGViZW1QNUJTVEJVWEo3Kzg1ZGRIUWRncURYTWpocGJPSTY2?=
 =?utf-8?Q?pFg2DnrjHuzEjxI1+jaakAg+K?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 706b44ba-85d9-4638-eb08-08dad19f4bb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2022 00:18:52.6005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qOz/B0fYmjm0JkAyIUIXTxQweQN0xpeOo2QEn6d3uRn4WAZEVHXsDKWSIckowqi9rpD9ULLBjGW/tW+mJ7aEXufGeaYuJSXnNswsbJE18fU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5546
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2hhbm5vbiBOZWxzb24g
PHNobmVsc29uQGFtZC5jb20+DQo+IFNlbnQ6IE1vbmRheSwgTm92ZW1iZXIgMjgsIDIwMjIgMzo0
NiBQTQ0KPiBUbzogSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gQ2M6IFNoYW5u
b24gTmVsc29uIDxzbmVsc29uQHBlbnNhbmRvLmlvPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsN
Cj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbXN0QHJlZGhhdC5jb207IGphc293YW5nQHJlZGhhdC5j
b207DQo+IHZpcnR1YWxpemF0aW9uQGxpc3RzLmxpbnV4LWZvdW5kYXRpb24ub3JnOyBkcml2ZXJz
QHBlbnNhbmRvLmlvOyBLZWxsZXIsIEphY29iIEUNCj4gPGphY29iLmUua2VsbGVyQGludGVsLmNv
bT4NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggbmV0LW5leHQgMDYvMTldIHBkc19jb3JlOiBh
ZGQgRlcgdXBkYXRlIGZlYXR1cmUgdG8NCj4gZGV2bGluaw0KPiANCj4gT24gMTEvMjgvMjIgMzoz
MyBQTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+ID4gT24gTW9uLCAyOCBOb3YgMjAyMiAxNDoy
NTo0NiAtMDgwMCBTaGFubm9uIE5lbHNvbiB3cm90ZToNCj4gPj4gSSBkb24ndCB0aGluayBJbnRl
bCBzZWxlY3RzIHdoaWNoIEZXIGltYWdlIHRvIGJvb3QsIGJ1dCBpdCBsb29rcyBsaWtlDQo+ID4+
IG1seHN3IGFuZCBuZnAgdXNlIHRoZSBQQVJBTV9HRU5FUklDX0ZXX0xPQURfUE9MSUNZIHRvIHNl
bGVjdCBiZXR3ZWVuDQo+ID4+IERSSVZFUiwgRkxBU0gsIG9yIERJU0suICBTaGFsbCBJIGFkZCBh
IGNvdXBsZSBvZiBnZW5lcmljIFNMT1RfeCBpdGVtcyB0bw0KPiA+PiB0aGUgZW51bSBkZXZsaW5r
X3BhcmFtX2Z3X2xvYWRfcG9saWN5X3ZhbHVlIGFuZCB1c2UgdGhpcyBBUEk/ICBGb3INCj4gZXhh
bXBsZToNCj4gPj4NCj4gPj4gICAgICAgIERFVkxJTktfUEFSQU1fRldfTE9BRF9QT0xJQ1lfVkFM
VUVfU0xPVF8wLA0KPiA+PiAgICAgICAgREVWTElOS19QQVJBTV9GV19MT0FEX1BPTElDWV9WQUxV
RV9TTE9UXzEsDQo+ID4+ICAgICAgICBERVZMSU5LX1BBUkFNX0ZXX0xPQURfUE9MSUNZX1ZBTFVF
X1NMT1RfMiwNCj4gPj4gICAgICAgIERFVkxJTktfUEFSQU1fRldfTE9BRF9QT0xJQ1lfVkFMVUVf
U0xPVF8zLA0KPiA+DQo+ID4gTm90IHRoZSB3b3JzdCBpZGVhLCBhbHRob3VnaCBJIHByZXN1bWUg
bm9ybWFsIEZXIGZsYXNoaW5nIHNob3VsZCBzd2l0Y2gNCj4gPiBiZXR3ZWVuIHNsb3RzIHRvIGFj
dGl2YXRlIHRoZSBuZXcgaW1hZ2UgYnkgZGVmYXVsdD8gV2hpY2ggbWVhbnMgdGhlDQo+ID4gYWN0
aW9uIG9mIGZ3IGZsYXNoaW5nIHdvdWxkIGFsdGVyIHRoZSBwb2xpY3kgc2V0IGJ5IHRoZSB1c2Vy
LiBBIGxpdHRsZQ0KPiA+IGF3a3dhcmQgZnJvbSBhbiBBUEkgcHVyaXN0IHN0YW5kcG9pbnQuDQoN
ClRoaXMgY291bGQgcG90ZW50aWFsbHkgYmUgaGFuZGxlZCBieSBoYXZpbmcgREVMVklOS19QQVJB
TV9GV19MT0FEX1BPTElDWV9GTEFTSCBiZSB0aGUgYXV0b21hdGljICJzZWxlY3QgYmVzdCB2ZXJz
aW9uIiwgYW5kIGlmIGEgdXNlciBoYXMgc2V0IGEgbWFudWFsIHZhbHVlIHRoZW4gZG9uJ3QgYWxs
b3cgZmxhc2hpbmcgdW50aWwgYSByZWJvb3Qgb3IgdGhlIHZhbHVlIGlzIHNldCBiYWNrIHRvIFBP
TElDWV9GTEFTSD8NCg0KPiANCj4gWWVzLCB0aGUgYWN0aW9uIG9mIGZsYXNoaW5nIHdpbGwgc2V0
IHRoZSBuZXcgYmFuay9zbG90IHRvIHVzZSBvbiB0aGUNCj4gbmV4dCBib290LiAgSG93ZXZlciwg
d2UgaGF2ZSB0aGUgYWJpbGl0eSB0byBzZWxlY3QgZnJvbSBtdWx0aXBsZSB2YWxpZA0KPiBpbWFn
ZXMgYW5kIHdlIHdhbnQgdG8gcGFzcyB0aGlzIGZsZXhpYmlsaXR5IHRvIHRoZSB1c2VyIHJhdGhl
ciB0aGFuDQo+IGZvcmNlIHRoZW0gdG8gZ28gdGhyb3VnaCBhIHdob2xlIGZsYXNoIHNlcXVlbmNl
IGp1c3QgdG8gZ2V0IHRvIHRoZSBvdGhlcg0KPiBiYW5rLg0KPiANCj4gPg0KPiA+IEknZCBqdXN0
IGV4cG9zZSB0aGUgYWN0aXZlICJiYW5rIiB2aWEgbmV0bGluayBkaXJlY3RseS4NCj4gPg0KPiA+
PiBJIGNvdWxkIHRoZW4gbW9kaWZ5IHRoZSBkZXZsaW5rIGRldiBpbmZvIHByaW50ZWQgdG8gcmVm
ZXIgdG8gZndfc2xvdF8wLA0KPiA+PiBmdy5zbG90XzEsIGFuZCBmdy5zbG90XzIgaW5zdGVhZCBv
ZiBvdXIgdmVuZG9yIHNwZWNpZmljIG5hbWVzLg0KPiA+DQo+ID4gSmFrZSwgZGlkbid0IHlvdSBo
YXZlIGEgc2ltaWxhciBjYXBhYmlsaXR5IGluIGljZT8NCj4gPg0KPiA+IEtub3dpbmcgbXkgbWVt
b3J5IEkgbWF5IGhhdmUgYWNxdWllc2NlZCB0byBzb21ldGhpbmcgaW4gYW5vdGhlciBkcml2ZXIN
Cj4gPiBhbHJlYWR5LiBUaGF0IHNhaWQgLSBJIHRoaW5rIGl0J3MgY2xlYW5lciBpZiB3ZSBqdXN0
IGxpc3QgdGhlIHN0b3JlZA0KPiA+IHZlcnNpb25zIHBlciBiYW5rLCBubz8NCj4gDQo+IFdlIGFy
ZSBsaXN0aW5nIHRoZSBzdG9yZWQgaW1hZ2VzIGluIHRoZSBkZXZsaW5rIGRldiBpbmZvIG91dHB1
dCwganVzdA0KPiB3YW50IHRvIGxldCB0aGUgdXNlciBjaG9vc2Ugd2hpY2ggb2YgdGhvc2UgdmFs
aWQgaW1hZ2VzIHRvIHVzZSBuZXh0Lg0KPiANCj4gQ2hlZXJzLA0KPiBzbG4NCg0KVGVjaG5pY2Fs
bHkgSSB0aGluayB3ZSBjb3VsZCBkbyBzb21ldGhpbmcgc2ltaWxhciBpbiBpY2UgdG8gc3dpdGNo
IGJldHdlZW4gdGhlIGJhbmtzLCBhdCBsZWFzdCBhcyBsb25nIGFzIHRoZXJlIGlzIGEgdmFsaWQg
aW1hZ2UgaW4gdGhlIGJhbmsuIFRoZSBiaWcgdHJpY2sgaXMgdGhhdCBJIGFtIG5vdCBzdXJlIHdl
IGNhbiB2ZXJpZnkgYWhlYWQgb2YgdGltZSB3aGV0aGVyIHdlIGhhdmUgYSB2YWxpZCBpbWFnZSBh
bmQgaWYgeW91IGhhcHBlbiB0byBib290IGludG8gYW4gaW52YWxpZCBvciBibGFuayBpbWFnZS4g
VGhlcmUgaXMgc29tZSByZWNvdmVyeSBmaXJtd2FyZSB0aGF0IHNob3VsZCBhY3RpdmF0ZSBpbiB0
aGF0IGNhc2UsIGJ1dCBJIHRoaW5rIG91ciBjdXJyZW50IGRyaXZlciBkb2Vzbid0IGltcGxlbWVu
dCBlbm91Z2ggb2YgYSByZWNvdmVyeSBtb2RlIHRvIGFjdHVhbGx5IGhhbmRsZSB0aGlzIGNhc2Ug
dG8gYWxsb3cgdXNlciB0byBzd2l0Y2ggYmFjay4NCg0KU3RpbGwsIEkgdGhpbmsgdGhlIGFiaWxp
dHkgdG8gc2VsZWN0IHRoZSBiYW5rIGlzIHZhbHVhYmxlLCBhbmQgZmluZGluZyB0aGUgcmlnaHQg
d2F5IHRvIGV4cG9zZSBpdCBpcyBnb29kLg0KDQpUaGFua3MsDQpKYWtlDQo=
