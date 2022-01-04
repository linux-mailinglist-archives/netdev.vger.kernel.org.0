Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1051F484A46
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 22:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbiADV4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 16:56:45 -0500
Received: from mga17.intel.com ([192.55.52.151]:23563 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232847AbiADV4o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 16:56:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641333404; x=1672869404;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=58nJal4+o7q93s2uytek6MZuUN1E5nh6G6ToKPKxYRk=;
  b=fEFVW6lcU4C/Dm2QxiLXr0u44VUIC0tpQM8V/CgxYqUHivYLAHBOE1Ky
   zW5AQZKHgpUVxK0gS0fRv02M2zLCfiABayXSfRZsm8hMd5kTkOIlzrHl1
   U+94jtLGcObhBLw2LwXej3d+w/kYzu0V5BtCo58tMzPsL0OCx18kTEV70
   MlsTUAqPoSQwuAgacp1qab6gvbOg7PU/qqyWcHgaRPug8DQFd0K7SqIrR
   FeUC2C5PLvNm2eBR5zNnYBp1WXSl+vfYRWAiY1KRhnxQVi9Hfr/lBssRr
   qPaCtZacDFfSXeKcjWXeXaJNRpo1GPf7GPZFcmcn8DZAEGcmVx9WYk0ZD
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="222982147"
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="222982147"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 13:56:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="526391347"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga007.fm.intel.com with ESMTP; 04 Jan 2022 13:56:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 4 Jan 2022 13:56:43 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 4 Jan 2022 13:56:42 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 4 Jan 2022 13:56:42 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 4 Jan 2022 13:56:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjoJKBHh9oCGUFqNMidpHBAwPBtAxbGJQo0jp6gvUrCPSc3zGzn6aK/9tG3vrHwWG66BavKtR1hRbh9qbnDcJp40PTxKdtDhn4UZQ2XMMTIaS1yy5JwHTPWyXJWiuXqkLi8dJfiyUnsL2qLxTIzG9C0azNbLBXj05hLK25uO8zZSDU2VLt/p6QnF1SzG1OOBs3HhocDTNFceSaM5GEIxCIQpXASUdY26A7i/0S0f+TlYHGusgdZjSgwOaJ4diGLybBgVVI4bihQPdMvC2g/HGG9vRDMYA42G/X5jtFvCpyndQekfCWkGAZU21VTvqFiBGCWBCdDpBSDGUEYlG0LMkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=58nJal4+o7q93s2uytek6MZuUN1E5nh6G6ToKPKxYRk=;
 b=RqtVo318vEJJRERJyp4SmocDKUJTzAIo/1vi53ABzxBoapfsY/mKQyiBoz4OOUwuUePMI9Gu2s1Gg29ohX9c9v76u7sDT7RNTHdXTjnYS0BIOZYSQdC8ffUty0rq4CrznR/xzzMeh6oi0ixXsnr8LGt7CykEfO/bnq9Q+SXq27FNAvLB0BoobF06Q/51qDhPupSubgGmKw6xtv12RqwGqYwEhXz5StOJBcRU0XdRuJvzmVFx5PKf+64tfVujTQusThnA+wcvevu2E60l4r6kuJY76PmMd90/bJsKrkvcvDuKiS1rpv8gjOrPZytDKeox7a1d4RYgOWBL5IINxhcPQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3279.namprd11.prod.outlook.com (2603:10b6:805:c6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14; Tue, 4 Jan
 2022 21:56:04 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bded:8c4b:271e:7c1]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bded:8c4b:271e:7c1%5]) with mapi id 15.20.4844.016; Tue, 4 Jan 2022
 21:56:03 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [Intel-wired-lan] [PATCH] intel: Simplify DMA setting
Thread-Topic: [Intel-wired-lan] [PATCH] intel: Simplify DMA setting
Thread-Index: AQHYAQA0wj4pdTwWK0S4iroUO9oyF6xS3DsAgACNVgA=
Date:   Tue, 4 Jan 2022 21:56:03 +0000
Message-ID: <c258c3bb440b88e984b0385af8ffb38a017ba644.camel@intel.com>
References: <c7a34d0096eb4ba98dd9ce5b64ba079126cab708.1641255235.git.christophe.jaillet@wanadoo.fr>
         <20220104132936.252202-1-alexandr.lobakin@intel.com>
In-Reply-To: <20220104132936.252202-1-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73750248-2afb-44eb-ef85-08d9cfcd00e1
x-ms-traffictypediagnostic: SN6PR11MB3279:EE_
x-microsoft-antispam-prvs: <SN6PR11MB32790E78D6677FC98E84AA03C64A9@SN6PR11MB3279.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2rHDbhRIjQ368mwaqsS7Tl0NsBsr7cCs+XBHFjE52xrgXajSREwNqo5Eew1/xlnbVCDtxF7EQt6GQ4JWSyWICjuR9mHrpuL83tqk6lvCnTPKhm0ARNVs9HnNeAmMU337rKr91gv9z4okei/DeuGctKy7ILBH2PuNWuDy5VtvapizrlJqhkInQK+o9Fu5LAl42zf43pAou778VSvVBhokKARN97y4IIValXjzjYtDDp1B8KkuHwa+yb03bro/Oo7DYKwB9432fDiaAhRkB10nV4x4YYtZVgPeqPCmEjTTxi+kHeNkTfUqWSTBguM/bhSryQ7Z3z1xLuVlHCCraoyaPQqsIX6zpYDED8Sw5JQZ58vvb5rk7hKNafo5NFYnhhjnM8BX7Y2kA9CfXQObqJYJyhXZHQdSR7UYlXzO82Pg0QJY0Ftufv2hHBl9Hu0fZ9adzl25dD1LXy33tLvdIZMY0mQXuhl5MiypS9IfDmmFfw0YAuhu+U1zy/471S54AcUU/ix0lnH/ryzozqFCXN8AuMGI57UfYhat+oEKPvS6geRnuAFsT89okzZetLT4i24r/i0ccCYTqmH2ir7pRn10S2GDwtV8V9MqJ4OyAr8MyIur0y3aD2i6kcMVVli8z6nsblU4bLEyPDVPg+F+2Xi6GZul4Z+Nyt+lCURgpndmYYzhjuuDn9qZS5UVU4RovMW2TXUW5gV95vbtttmasQw4u3qAbHzbwopyLqMjoKJ6NHO6VdaTIkgo1PUwjRAz6ecN4epAAi+APHvwW+l5YO7L28EcyjNj6rcg1yPcnhCni2c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(508600001)(83380400001)(54906003)(5660300002)(38070700005)(82960400001)(2906002)(86362001)(38100700002)(122000001)(110136005)(36756003)(2616005)(76116006)(26005)(91956017)(4326008)(186003)(6512007)(71200400001)(64756008)(66556008)(66476007)(66446008)(66946007)(6506007)(6486002)(8676002)(316002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkNFNFhTTHpxbjU5MzV2MGtaZGF5UnNjZjQ5MFl3K09lN3dDcHlRejZ2M1Mx?=
 =?utf-8?B?VlJlNFU3YnZtNmc4ZmtINjBLV1MwUzY1RkFMaGRTM1BDdjZWanhmd1hqMU5a?=
 =?utf-8?B?NlRTUnVjZDQvWWlwSnJmZlpVeGVCdEVqaVF2U0xyUUg4VHVicm8zQWk4Q0k5?=
 =?utf-8?B?OWlSYUwwYk1DdjJ2ZEVZY25jTjhyVWx5RmozUklrTTBvOXcrYUY0a29QZ0ts?=
 =?utf-8?B?UkF2NGM4VzNEaEdkbnI3U0laSmZuOEYwdU5TenRMaTZYUElqVzAxdTZScFhG?=
 =?utf-8?B?UGc3bUdaUE1MQnRMY0xwRE1Bc2VLSlBCK1NPcEc3alNPSHYzTEJ5bWliUjd4?=
 =?utf-8?B?ZXRFSmszK25rTmN1SlFtNXRrOFA5Z3pOOWdNTWcwQ2R6ZFZVallqcGVhdGc3?=
 =?utf-8?B?eW8va2pvbW1mZ2E0ZTFmNDhVSzFqa2wxRE5OQnlMWGsycUhjRjIvYVlzdldz?=
 =?utf-8?B?b2tmWHUybm0vTnV0WUgxTmlSYTYxL3NUTVh2YlBJbzZtVDNxdDhpKzNwSjlG?=
 =?utf-8?B?eENzRGREZDZscnBWYmJ4aWxqK0xqd0poZlc0cnR0YmdSUitSNkNXQkN2dU5D?=
 =?utf-8?B?dmtsYWZ4VHdFMVFnYjN3OVpPYnBhMncvNlFDN1EzRDdTUHhDV1V1V2xpT2lD?=
 =?utf-8?B?VG92YnF1WTVwS3R2K1VmeEgxekU2dTRWUVZHMmphYkhkdUJza1dxSjNCV0R6?=
 =?utf-8?B?WVpSS0JvMm9DeE1QMkFMYTVOdE5xUFN6TnBmaDFvc00zeVpsdnIvREtLbnNT?=
 =?utf-8?B?WjFHOUJiV29FTFBKd3kxT2lmeWFOWkZvVWtCbGY1cTVIcW9hZThjRE92WHRj?=
 =?utf-8?B?UnJ4anRBY2l4YTFwcTQ2NVpqUmZtZDhxbTVHdlVtVTZoc1FvbElhZ0VyZjNi?=
 =?utf-8?B?WjM5b3F1TVFpbTNhOU9tSmdLYTY2OTRmZTRjRUFaTnNoeWt6bGxLNnEwei81?=
 =?utf-8?B?cmRJdEVEaTRRS1NyalpiNG8xeTE4SlhMNzVNMTBvSklXV3hGUFpOZWU0RFpx?=
 =?utf-8?B?ZkwrSnVQeHhRdmdvQ2dSeFdQOWRqUGhWNFRESXkzaFY0a3pBOE9PRURwSVZB?=
 =?utf-8?B?eGw3Rm00UnNSZm5aWC9rbVdwcy9xbVFaRWwzTG96UG5ua29VbUNSQ0NLTzMz?=
 =?utf-8?B?cjZtNlpFbHROTVlwUzhEVmszSU1nZG5vRWdLc0lmcU8vNlAzd0o5dkM5aGhu?=
 =?utf-8?B?a1YxU24vSlhMTGRjSXd0OFl3ZmdZTDY4Z09xWjdYZjlXTktKWkRFNnE5ZE5o?=
 =?utf-8?B?UlJZZENUSTB3SEJSZ0JmdGtFeFM5eEJZa0U2OW41WUhxdGd1YWdUMElFN0xW?=
 =?utf-8?B?Y29pNyt6UVpGUzRSTk1aeE51VTFsTVJ6T2x3empWemFUMW01WVBtdE4xTVo4?=
 =?utf-8?B?ZmptOWd1b1lPRHlCVmpRM0hqNlErN3BLU00yaDMxeDRDVXBSTUZoRk1QT3RK?=
 =?utf-8?B?TXF4WXMrL2pveE4xNjZxRTY5MG00SVVMWm9HcVBsWVEwQytRYm1BTE9GWk1o?=
 =?utf-8?B?a2VadEF0RDFPZmJETGcvblZhN25VZUxmTTFOQjJ1SUpPcFpBcGZEbE02YzYz?=
 =?utf-8?B?SnF1UTVLTEg5eDBPYmlQTnpLbGpja2ZzdlJaTk5sT0xqZno2QmhKRjhZS2VU?=
 =?utf-8?B?RVo1cDRENGFTbFFnUHdseHBJTlJkbW96cEh0NnIvNFM2SzJJU2FmVzhMekVB?=
 =?utf-8?B?VXI1UDhUK2JxTk8xZnhlVWt5TTJtQXJBbnZqZnRHUDFIY3VPa2RObEZQbjhn?=
 =?utf-8?B?NWl2ZUI5c3dnaHducDNQaXFTMmpRNFJnUmNnRGw5TFRNU28rMS9sd2VCSkM4?=
 =?utf-8?B?RGI0QnVmdVk5TDhVbWFaT1k4OWV2UCtYNTdORE40M3NySG0vSnllUVV3NGMv?=
 =?utf-8?B?ZFlZYjZuYUF6YW1aQlI5SG8zWitZOWdCck9LY2VSYithZTVqbDhQM3lITnFs?=
 =?utf-8?B?YjVFa1NseXlsMVh1VmthRmIzNkdRVVZPS3ltcHFMTXFoV2kxMHBxajA3MGhN?=
 =?utf-8?B?NDZwaFJvekJaNWpaT2YzWVc2N0J2MjBXQ2llQjZ0a1QyUmV4dGovci9xWGNK?=
 =?utf-8?B?SHRQM1ByQkJaT2IxVDh6RDY0Z1ZoSlljVHlmbzA3Y0U5b2NUM0M3ejBJTVFC?=
 =?utf-8?B?U2IxQnZhaFRuekU2SzJCQVpUcFhzaHBiVzI2N05FbmhVVlVReGppczJ5M0Zh?=
 =?utf-8?B?M3RaaVIxT1JkUmRjM2NIenFhWjFyNVhSUmE2U1NxS2liRW9VbkVnU1huYWt1?=
 =?utf-8?Q?U5aI66m1PviQyefFB+Sdx8TI5Zoqg5BukO+6FUENcw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EEE1F9637C187E4EB3C2B9BC96CD7158@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73750248-2afb-44eb-ef85-08d9cfcd00e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2022 21:56:03.8906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mqok5M6Go6DoKQwk5lSCgZxe+SEOBIfjeKQPkhL/IQ+RsIbRu519154gdvnvBVeaEuqone0IV/DKSMgGtr0X230sJl5Z5rpZNkvSe2FymN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3279
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTAxLTA0IGF0IDE0OjI5ICswMTAwLCBBbGV4YW5kZXIgTG9iYWtpbiB3cm90
ZToNCj4gRnJvbTogQ2hyaXN0b3BoZSBKQUlMTEVUIDxjaHJpc3RvcGhlLmphaWxsZXRAd2FuYWRv
by5mcj4NCj4gRGF0ZTogVHVlLCA0IEphbiAyMDIyIDAxOjE1OjIwICswMTAwDQo+IA0KPiA+IEFz
IHN0YXRlZCBpbiBbMV0sIGRtYV9zZXRfbWFzaygpIHdpdGggYSA2NC1iaXQgbWFzayB3aWxsIG5l
dmVyIGZhaWwNCj4gPiBpZg0KPiA+IGRldi0+ZG1hX21hc2sgaXMgbm9uLU5VTEwuDQo+ID4gU28s
IGlmIGl0IGZhaWxzLCB0aGUgMzIgYml0cyBjYXNlIHdpbGwgYWxzbyBmYWlsIGZvciB0aGUgc2Ft
ZQ0KPiA+IHJlYXNvbi4NCj4gPiANCj4gPiBTaW1wbGlmeSBjb2RlIGFuZCByZW1vdmUgc29tZSBk
ZWFkIGNvZGUgYWNjb3JkaW5nbHkuDQo+ID4gDQo+ID4gWzFdOiBodHRwczovL2xrbWwub3JnL2xr
bWwvMjAyMS82LzcvMzk4DQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoZSBKQUlM
TEVUIDxjaHJpc3RvcGhlLmphaWxsZXRAd2FuYWRvby5mcj4NCj4gPiAtLS0NCj4gPiDCoGRyaXZl
cnMvbmV0L2V0aGVybmV0L2ludGVsL2UxMDAwZS9uZXRkZXYuY8KgwqDCoCB8IDIyICsrKysrKy0t
LS0tLS0tLQ0KPiA+IC0tLS0NCj4gPiDCoGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUv
aTQwZV9tYWluLmPCoMKgIHzCoCA5ICsrKy0tLS0tDQo+ID4gwqBkcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9pYXZmL2lhdmZfbWFpbi5jwqDCoCB8wqAgOSArKystLS0tLQ0KPiA+IMKgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9tYWluLmPCoMKgwqDCoCB8wqAgMiAtLQ0KPiA+
IMKgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYi9peGdiX21haW4uY8KgwqAgfCAxOSAr
KysrKy0tLS0tLS0tLS0NCj4gPiAtDQo+ID4gwqBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9p
eGdiZS9peGdiZV9tYWluLmMgfCAyMCArKysrKystLS0tLS0tLS0NCj4gPiAtLQ0KPiA+IMKgLi4u
L25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZXZmL2l4Z2JldmZfbWFpbi5jIHwgMjAgKysrKystLS0t
LS0tLS0tDQo+ID4gLS0NCj4gPiDCoDcgZmlsZXMgY2hhbmdlZCwgMzEgaW5zZXJ0aW9ucygrKSwg
NzAgZGVsZXRpb25zKC0pDQo+IA0KPiBJIGxpa2UgaXQsIHRoYW5rcyENCj4gDQo+IFJldmlld2Vk
LWJ5OiBBbGV4YW5kZXIgTG9iYWtpbiA8YWxleGFuZHIubG9iYWtpbkBpbnRlbC5jb20+DQo+IA0K
PiBUb255IG1pZ2h0IGFzayB0byBzcGxpdCBpdCBpbnRvIHBlci1kcml2ZXIgcGF0Y2hlcyB0aG8s
IHdpbGwgc2VlLg0KDQpIaSBDaHJpc3RvcGhlLA0KDQpBcyBtZW50aW9uZWQgYnkgb3RoZXJzLCB3
b3VsZCBtaW5kIGJyZWFraW5nIHRoZXNlIHBlci1kcml2ZXI/DQoNClRoYW5rcywNClRvbnkNCg0K
PiANCj4gLS0tIDg8IC0tLQ0KPiANCj4gQWwNCg0K
