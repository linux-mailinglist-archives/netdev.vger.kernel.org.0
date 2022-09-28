Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B455ED4E5
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 08:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbiI1G3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 02:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiI1G3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 02:29:49 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8719D57BD8;
        Tue, 27 Sep 2022 23:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664346587; x=1695882587;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5a6pInsNCO2tsVscB2SlMVDSPB933dfehDeWFHzUhEc=;
  b=U+WaxpUvl38fEV5ap9U4iPzBz5kxjbDmr6Eh9ZF4WJP38MzAFS1QNY83
   df+VBEJ+xZlnurMz7wyeFOL3I+71PVDYalQLREzRjZmFY6qC7/yS9LY7R
   isZahk2uxOOolEK6mTCFWLBifQwA2NsnUUanVo6znr6PobnRejRqaPNQY
   Krg0ntQG6e9XkZ1CWW+NIF7bGx8zatziyXrZ2X6wiD97D8tEr1KSPV9b0
   jT6QwjiEtcm/r19ZSPxWi53+facD8MbXjpe156BBXFv8CsCbXYl5V10jR
   vo0AEMZwpYnsoKPaxpOfKdDMKud4mIF8XPT2p2kHT0LB6gJJii7SxHjS9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="281890043"
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="281890043"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 23:29:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="797042460"
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="797042460"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 27 Sep 2022 23:29:43 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 23:29:43 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 27 Sep 2022 23:29:43 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 27 Sep 2022 23:29:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gzx6qccMcswzyTObHAGQw8bIlz6Enwd9sZ4ArDyP7BUGDfMCiNlKJauJxxPAzyUs2w8WayXv7CmQV0mtnJeCc0kEIWtjJpYRUWH3dQlpB/IRsEX16XQM+JHnzcebNRi5aKHz+Hb5hvbDgct3kgFbLxodlT8ov5g7wOwgZg3FCj8Be7v9v7INgzGlijBbH6kMoDSy9l3wfIFFQtlOaJiHEid8Gnsc2hXtdUSRr7pNm0tc7KmmMMa8XFHy9m8eDk2u0gASlMnM6pwe1bRNzLo3atjpLfSlXV/2Hvum2p2A4v1lMbHauhV2tGUNbIphNm+zidV7ZSpg4oVW6OiwrIzXRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5a6pInsNCO2tsVscB2SlMVDSPB933dfehDeWFHzUhEc=;
 b=lVZYmu7oMzFshaj8SlBsaGJqoO/2uGcvnCFIEh+XZLoCWxr3DV6IlP1bNXoJHaO8FugXRgx8MldjEqusFj0ULMAfR20SyUDPgjyRKxZH3Ssd+XLHzs4UAmfHpwW3mFaVWSgVcylNVNtOWYFrLdUQEOAjJ71sfHSgCV4rCRkxfJgEGqx96SVqnYKTzd16fxtOkNeCFRezXEFRH9cWMQcNkmnWRlAsnhzMErcnlSM/GlAXCNINbbDKKJYqcrpda3UwyAOUbkivRwo5cLzu1nnoxcdcXavaj7JlLvlQzy9GeNfcK8HCleIN8o1hhePyzmrLXroWzPn1GsbUq2u3sgfg0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5987.namprd11.prod.outlook.com (2603:10b6:208:372::8)
 by BN9PR11MB5436.namprd11.prod.outlook.com (2603:10b6:408:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Wed, 28 Sep
 2022 06:29:41 +0000
Received: from MN0PR11MB5987.namprd11.prod.outlook.com
 ([fe80::9afa:894a:4804:12a2]) by MN0PR11MB5987.namprd11.prod.outlook.com
 ([fe80::9afa:894a:4804:12a2%3]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 06:29:41 +0000
From:   "Greenman, Gregory" <gregory.greenman@intel.com>
To:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>
CC:     "Golant, Michael" <michael.golant@intel.com>,
        "Goodstein, Mordechay" <mordechay.goodstein@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Errera, Nathan" <nathan.errera@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "Stern, Avraham" <avraham.stern@intel.com>,
        "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Peer, Ilan" <ilan.peer@intel.com>,
        "Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: [PATCH v2] iwlwifi: Track scan_cmd allocation size explicitly
Thread-Topic: [PATCH v2] iwlwifi: Track scan_cmd allocation size explicitly
Thread-Index: AQHYz5kc7SR2h3jUNEWHRVME3o0Lra3xXOn2gAMLQ4A=
Date:   Wed, 28 Sep 2022 06:29:41 +0000
Message-ID: <9019c8d467ed1d844d29d00b52604e74b330583f.camel@intel.com>
References: <20220923220853.3302056-1-keescook@chromium.org>
         <874jwu4lc7.fsf@kernel.org>
In-Reply-To: <874jwu4lc7.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.4 (3.42.4-2.fc35) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5987:EE_|BN9PR11MB5436:EE_
x-ms-office365-filtering-correlation-id: bd7fbf08-a679-42cd-4d82-08daa11ad339
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: chssmizG0KB070OAfc74u3rvPstPgdmafdkkv030FY31rKmDYzYOeqeGEzoiagVWJHwGhpdE7TYC9ff2bz4d323QM2VlmRyBZIQ/00XPv9kpPJzMTkx1+QkpSAQsnTJIfEgHb8Cs6ZyjrjqjKvXz26BpODOmnCfMALf5EZNU9LwwEdrmrX6N+pwl3deAgreahnXS25CjZiYflQZxrEioevmdwD/Azzo3Y9qIzwg0AK+yxnmhSMc6ikSiygoJWPWarpCbjvZzGNnZAOTvS0xEWprAn1bWvkPt8MOTZsNIq+ITO5mCZzI4SP9AfxAQxmLzHEs6YAY5WB8i2CTDB3DVZbxHFIeA5PxNiBjaj2TPrpJyffDt9Bu8e/3rqwYp6wo/6a8N3Y8GZvgI3zIDFlfgsq2CZ7i25KJz2IYKZlyTH+xBZ6Y4VARvedutrDTLQ4xR2CerdJm0lL+eSijGn3R2CPAHfWDj31hcMkCGZcLX3XesQ9j5gRzMsq+ryDY2VhmpL0irHkH1JA6YIlcLHOABXSNKWh0lygkDGAJn7cxtPJClQBbYMeVOscU6hi5hPQb2NgTudDpeF2PbY1HCt8l2Gs+HeuzXvJbuJ6KaBhws7+/QtcRrhzJPYGPzDsrdv8ap1rvgbuwspXGqJNQ6DYKMeBAHYJgTCpEXHgxjtjhpn2tc8TDDqDlPR17cTppBjMMnFBKwaBRP9RgRP9z56x6NrY4qk6o7SB4aC+yDPyWqHuUtXCQ1gnYrCBqiKBdxdXEpwt+J/MZIj66y0371uzR9Mw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5987.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(346002)(136003)(39860400002)(451199015)(83380400001)(91956017)(36756003)(26005)(6512007)(38100700002)(2616005)(110136005)(186003)(316002)(38070700005)(122000001)(2906002)(54906003)(7416002)(8936002)(82960400001)(66446008)(66476007)(86362001)(5660300002)(76116006)(64756008)(8676002)(4326008)(41300700001)(66556008)(66946007)(71200400001)(6486002)(478600001)(107886003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnhPS2hiTjJmSG84eVFDOVoyVFN0dVE1RHZmc0pSRXNreVRnN2lCKzJRQ2Rj?=
 =?utf-8?B?dnFTR2ZxOVpvTncvb201RHNzdDVYR3ZyS05DMDdwR2ZBN1J3MHo1VDlHNERj?=
 =?utf-8?B?U09hU2dlMHNoaGY1OWtEeWo2aGQwemhBTWwybXY2TmhrQjhZZ25UUG5hb0dm?=
 =?utf-8?B?b1VRQTVsZTNKV25wOURQTlZrWTkraVhtNG5MVit0cnI1V01kQktpWFBhN0lB?=
 =?utf-8?B?WnpnbGliYlo0VVhJNlVWVFo3SDRKNlYwRXRWSzIvTVJHSzJIdmh5YzJ3U3c3?=
 =?utf-8?B?WnJWUE9BMGR6ZlBZUjhEdEh1Njh6TEFQazBscmM2a2ZSdUhKaFV5enhFa3Fm?=
 =?utf-8?B?ZmkvZ3R3MnYvVitTeWt0T1VEbDNHbkF2WmtMKzdwSHJjMjNTQXBBZkt4OTZl?=
 =?utf-8?B?RGllWVF5c3hKeTdRc0JycEpaQzhHVGd2bWhaVERKdWt0TTQwV0tpR2IzUzdw?=
 =?utf-8?B?TDJISGZET0RoZ0ZkdlFmakhUSWNxVjhFQkdpMWFlQlpvV3R5WW9JUjRGMXVN?=
 =?utf-8?B?ZWxnWk03R1FLM0N2ZlFLckdVeTlPT3VjcU82LzFZSzBycW5Sd2dGREo4QURD?=
 =?utf-8?B?cmpIVkJ3NzVkYWtrUkdVWFZ2Wms3Q1FjTWUwc2oxckp2aCszS1R3elhpbmpp?=
 =?utf-8?B?cHNJWE0vZnBKdWxtSmtpRjZHamxzQW9Ia2I0TG83OStaTkhPTDhEMVk3U1FZ?=
 =?utf-8?B?Zlk4cm9LaHBNZzE0TW4rK0UyTmxMeW5JZVRtL3c2Sk1vNDUrUVlFdkVIblhD?=
 =?utf-8?B?YzRTRUYrbEo1Y2U4UnZuQjdwazJZTXkwSGw5Qnp4S3NzbXZSN3lBR0VwblhI?=
 =?utf-8?B?L0gwR2R1UTZFVkNHWU5NTmQxSE1JNlFsVjVKOEE3ZWVqcW5HaTQyVmtmcUVK?=
 =?utf-8?B?WFRMZFZrWkxQWFlWN2VJeDQ4TGdoUE9YUnI2T2RLS1M4MzN0MXp2UVgvRlJx?=
 =?utf-8?B?THVkUXU2UGdFbW42NE91YkxwMHFONXNKekdLNkFKUHkrR3R2UDUrMXE1YURP?=
 =?utf-8?B?QXpROUZwRndPdm9HSWIrY2Y3V1M1eFQ5VC9oZkdYemVpZVowSFJUeXp5bC9Y?=
 =?utf-8?B?MzM0SlNqUyt5UkZaUm9YM3NGT2tyU08xM2VkM3E1ZFl2RW1BSGZOaGpCTzYy?=
 =?utf-8?B?dGxTNk1kUGZpMDZ0MlFndnZSUE5qTERDQ3dab2pXY2k3VjFhUU9VVGR6Y2lN?=
 =?utf-8?B?MHNwY0ZFZ3I1RGZDOVZ5VXJCQXhVbGVjY01mNE1ldENNemVENmpLRWxTSGkw?=
 =?utf-8?B?eVFiNUE3MlFHSmdaRGpjYkQ2d2pHUzZsdmQ1U1RUTjIrNTJsU1RHNkJoSmkv?=
 =?utf-8?B?d2laZWV3QXJUaEM5VHZzOWJMZVpuVjVxMTdzRzFLMlBCSXNqSThKeTVuQm9H?=
 =?utf-8?B?dlN1S2tjQnhHcGxHY1dicW1GSVB6ZnRJeUlLcTlBamZ6eHFmQVVGSi9pUEt2?=
 =?utf-8?B?eW1tN3ZZVjlhTjNaQWNrTHJTYlBUWW01UDMwU2JnWWUrV0ZpUXUwdjZJcWtX?=
 =?utf-8?B?cVZPNGZ6azV5bG9iblBLdEVBUDVvYm13REQ3d24zeFdlRWFOTkpyOE5MQlJs?=
 =?utf-8?B?ZTBwRzJCaXpRc1R1TFI3ZlBCY3ZYU3dvaEVyNDFzS1FsZHJkTm5HR2VnNitq?=
 =?utf-8?B?Wmg4ZU5kZXpWMHFTODF1QjkvZ0RtbjJaWEhQbGQxVVlCVjk4cGVzdXpxZHl5?=
 =?utf-8?B?cUJTemZxeXB5T3l1MzZRM29GQ0g1ZWVlTGREc3lsR3h3T3BjV1h5cWhvUFpQ?=
 =?utf-8?B?Qysrdmt6bnhKakJZdFNHL1dzLy8rK3gwVVFqZWNSK3l5S0xXSDQ0U3M0SURl?=
 =?utf-8?B?K0ZOWC9GOWdhNzAvWS9ndTVtZ2hVbXUveVcwTG9RTVFKU0sxUmMyeWUwT0ta?=
 =?utf-8?B?UEQrL3BaMzJKZ1dpTGN2UkJzd2RjTllIVnowb0dydGtuSy9PUHdqU0lCNnk3?=
 =?utf-8?B?TmdyckllVTRTdkZsTXFUVGFKdFkzNWZOVkpoT3V5ZG53ZGd6czFzbFVZQ1hr?=
 =?utf-8?B?OXZHQkZ5UXcyV0ducHd3cFBpVFk0QlRrMitBaTRDWXF5cXdBZ1dxREZhc2Ri?=
 =?utf-8?B?VS9NVWlFeTJSZXI4dGwvK1J3Z0pZVkc0cWYwUnZvUm9IL0JyL2pJdVlSME1P?=
 =?utf-8?B?ZTdaemZLWGtHc2dCMXR2UGlERmk4ekxsUGl1K09IOXlUVDc4UkIzd012cUx4?=
 =?utf-8?B?cGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BCB27CD2867F864FAF14358A226D20EC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5987.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd7fbf08-a679-42cd-4d82-08daa11ad339
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2022 06:29:41.0691
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OUVIz4kBLCX0aMrO0HkHLg/B/H1Bhp223GfuIPC71+LmnMBlu89KzQspZ6ysj+Lsa/l4IRACmqXcqUmIirkZ3tzocpHW0oaQ0C505TyayNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5436
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTA5LTI2IGF0IDEwOjU5ICswMzAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiBL
ZWVzIENvb2sgPGtlZXNjb29rQGNocm9taXVtLm9yZz4gd3JpdGVzOg0KPiANCj4gPiBJbiBwcmVw
YXJhdGlvbiBmb3IgcmVkdWNpbmcgdGhlIHVzZSBvZiBrc2l6ZSgpLCBleHBsaWNpdGx5IHRyYWNr
IHRoZQ0KPiA+IHNpemUgb2Ygc2Nhbl9jbWQgYWxsb2NhdGlvbnMuIFRoaXMgYWxzbyBhbGxvd3Mg
Zm9yIG5vdGljaW5nIGlmIHRoZSBzY2FuDQo+ID4gc2l6ZSBjaGFuZ2VzIHVuZXhwZWN0ZWRseS4g
Tm90ZSB0aGF0IHVzaW5nIGtzaXplKCkgd2FzIGFscmVhZHkgaW5jb3JyZWN0DQo+ID4gaGVyZSwg
aW4gdGhlIHNlbnNlIHRoYXQga3NpemUoKSB3b3VsZCBub3QgbWF0Y2ggdGhlIGFjdHVhbCBhbGxv
Y2F0aW9uDQo+ID4gc2l6ZSwgd2hpY2ggd291bGQgdHJpZ2dlciBmdXR1cmUgcnVuLXRpbWUgYWxs
b2NhdGlvbiBib3VuZHMgY2hlY2tpbmcuDQo+ID4gKEluIG90aGVyIHdvcmRzLCBtZW1zZXQoKSBt
YXkga25vdyBob3cgbGFyZ2Ugc2Nhbl9jbWQgd2FzIGFsbG9jYXRlZCBmb3IsDQo+ID4gYnV0IGtz
aXplKCkgd2lsbCByZXR1cm4gdGhlIHVwcGVyIGJvdW5kcyBvZiB0aGUgYWN0dWFsbHkgYWxsb2Nh
dGVkIG1lbW9yeSwNCj4gPiBjYXVzaW5nIGEgcnVuLXRpbWUgd2FybmluZyBhYm91dCBhbiBvdmVy
Zmxvdy4pDQo+ID4gDQo+ID4gQ2M6IEdyZWdvcnkgR3JlZW5tYW4gPGdyZWdvcnkuZ3JlZW5tYW5A
aW50ZWwuY29tPg0KPiA+IENjOiBLYWxsZSBWYWxvIDxrdmFsb0BrZXJuZWwub3JnPg0KPiA+IENj
OiAiRGF2aWQgUy4gTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4gPiBDYzogRXJpYyBE
dW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPg0KPiA+IENjOiBKYWt1YiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPg0KPiA+IENjOiBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+DQo+
ID4gQ2M6IEx1Y2EgQ29lbGhvIDxsdWNpYW5vLmNvZWxob0BpbnRlbC5jb20+DQo+ID4gQ2M6IEpv
aGFubmVzIEJlcmcgPGpvaGFubmVzLmJlcmdAaW50ZWwuY29tPg0KPiA+IENjOiBFbW1hbnVlbCBH
cnVtYmFjaCA8ZW1tYW51ZWwuZ3J1bWJhY2hAaW50ZWwuY29tPg0KPiA+IENjOiBNaXJpIEtvcmVu
YmxpdCA8bWlyaWFtLnJhY2hlbC5rb3JlbmJsaXRAaW50ZWwuY29tPg0KPiA+IENjOiBJbGFuIFBl
ZXIgPGlsYW4ucGVlckBpbnRlbC5jb20+DQo+ID4gQ2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2Vy
bmVsLm9yZw0KPiA+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+ID4gU2lnbmVkLW9mZi1i
eTogS2VlcyBDb29rIDxrZWVzY29va0BjaHJvbWl1bS5vcmc+DQo+IA0KPiBHcmVnb3J5LCBjYW4g
SSB0YWtlIHRoaXMgZGlyZWN0bHkgdG8gd2lyZWxlc3MtbmV4dD8NCj4gDQoNCkFja2VkLWJ5OiBH
cmVnb3J5IEdyZWVubWFuIDxncmVnb3J5LmdyZWVubWFuQGludGVsLmNvbT4NCg0KWWVzLCB0aGFu
a3MhDQo=
