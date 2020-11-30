Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9872C8E78
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387770AbgK3TwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:52:25 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:19204 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbgK3TwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 14:52:25 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc54d4d0001>; Mon, 30 Nov 2020 11:51:41 -0800
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 30 Nov
 2020 19:51:40 +0000
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 30 Nov 2020 19:51:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AeXulFXrQAutMoW1kTzxVZ+aczxwl66H5v82HwyOvguNzIb4xtFCBZDnvOFH+T7Z/IUFMfK0+x6ROvtoJYgXoGX0ltZMKMMzcB3hf3lIbUET+c+8TYjkgEo3BevNCS5iEX9R+IojDwB1pSHVZ8pe6GwmIWet/fo1wWdzcJYeBjM3vbjI6sSHBjVu2ekQhMMAsx6h3aSkxLvcybRtdHiYSiJCHV2RVFta6WiDy1ngv0Rp6YyBf3nowiWrFcPnaY2XwOWdwSgSI3XK6akJag4hSFG5yxVJ3EmKlaWcYVhNM3Gc9julrHEFb0IiumNflotHKkm5JO4joqogJGPug1RsBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tBq+OE4X14zFDJ/hp2YqpvvzB3FeIZKjFUDEM3U3I54=;
 b=Rd46TYaZwVfbO9WGyhQU2XnWmaHJgBIDTi/9AX33ytC8zxi6gal8wfJnQxYGasYZ55nNYj2epKHZMA/vaZ6Zwgdz67W+9Qh/J+4yHEShRHFMYFtqpqJPN7z313el8tcwxf7Wu7d6XrzFO8HJyDC0YCW43K4Udtm8p884BPo+UlDe5HP8KubIM6uk8Sva4ofc7jgvO4TpMseIWtdB3MMlq1+D3LCGkfsLQGwfl+Zc0V+MITc89fQNwrK3CqCjl6q1Iu6oqYIZyGoZ+lQVreZFu6NF+C5XE02qgNWoUhVQYH6GV9I6isjq2+O0gc4NwO7iAB1xKdNCNFBgyPmn3NCYhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4148.namprd12.prod.outlook.com (2603:10b6:a03:208::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Mon, 30 Nov
 2020 19:51:39 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%7]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 19:51:39 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jacob Keller <jacob.e.keller@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next] devlink: Add devlink port documentation
Thread-Topic: [PATCH net-next] devlink: Add devlink port documentation
Thread-Index: AQHWxze8h1/QOGiYM0ulu6k8QxmPgKnhD7uAgAAF8AA=
Date:   Mon, 30 Nov 2020 19:51:39 +0000
Message-ID: <BY5PR12MB432283BFD52FFC97C2C0AAA3DCF50@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201130164119.571362-1-parav@nvidia.com>
 <835d53da-25e2-04fd-fec5-7bd2b0e4427f@intel.com>
In-Reply-To: <835d53da-25e2-04fd-fec5-7bd2b0e4427f@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.223.255]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da7707d7-da65-4977-31f8-08d895695ac1
x-ms-traffictypediagnostic: BY5PR12MB4148:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB41480F55F352731DECA0690FDCF50@BY5PR12MB4148.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:747;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j/g0eUTdK0Li2jR8nB3ASIQbJ1VIlpZi0YC0lb4iMDBGKrmTGTX/XzYtq/qFt1kV4EPQRz9H/abcfsol/Z1trUeF1U30VONAJ9nwOMOXvEToaCneMd7xp4W3HxmjCbbJVSoxlXmlnysCYrbyXJDD84ZfiWh9ATzhgDzZoGJtzJJqN3MEYanZbNLzfY54XSqmuQnDlBeCZYRv+rk1lFk+W+Q6V+ZAsv5cxDnWSVdDFAUEMo981fvL/gkqVePemG2ZD+EqoMYyDVAGksF0B4NNNleTps1sWg1Bdr3yWIaxUi1SYkAixykyNUdW4S5mD6sy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(376002)(346002)(136003)(33656002)(26005)(55016002)(55236004)(66946007)(53546011)(110136005)(71200400001)(52536014)(76116006)(6506007)(8676002)(66476007)(66556008)(2906002)(478600001)(64756008)(66446008)(8936002)(186003)(86362001)(316002)(107886003)(83380400001)(7696005)(5660300002)(4326008)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?U0ZjL0YvbjRibTZ2OVdmRnpEbFBURjJYVXNaS0VjZEU3Qyt6V3pUWmpBMTRM?=
 =?utf-8?B?dTczVnNZZ2k0NFdXOXNLQmk5VTBBRHpXRUNhMjUvdUM5ZXFoNDgxV1ZLQ25W?=
 =?utf-8?B?ZHJGNWVQbHFyUGtvaWx0dDR6eE42eHM2MlQ5NDR0SnNhY1kvaUN2ZTFZd0F3?=
 =?utf-8?B?ckZ1blM1bWY0VmRTY05ycVpIUGdJdmQ4VVpQSXBDcWZDeHYzNmhKaVZzaEhw?=
 =?utf-8?B?U0FUMU9VV3FFTHBoaitHakVCeXRKSlNZQkpEb3JsVElMbW1jeHNKRW1mVk5J?=
 =?utf-8?B?a0c3V0lqaHFtSExOOStPOFdGT1Vrb01KWS9IeWRUOE8rcUljdGVvZzh5RlNk?=
 =?utf-8?B?VlRJby91RTIzY2lhR0VmdmN3cy8xcktsWitPbUxNM2s1VHZpc2o5VjZ6aWtP?=
 =?utf-8?B?cExtenpjOE91T3JCUkthZTdoSnJJenFrbEFqRmFRL3gveFg4MG96OGUwd0ZJ?=
 =?utf-8?B?RHgrekE2cUxMUmtVeUREVk0vbGc3MGpRTloyY3VFOVhrNjVnSXh5Rmt4MEY1?=
 =?utf-8?B?Zjl4UnRiTmhDNHlaOVFHRlpJcldBRjQ1bm13anNlaUlCZVVhUEU0a09Ea2c1?=
 =?utf-8?B?RzRpWnNURGZkb2FLVnBXRVl4OXpiWkloQVg1RWRrMFFMc3UvSFU0YXdiWXJI?=
 =?utf-8?B?MkQwSTgrQjVPVFJzb1hQQXVUVDdNUlU2QjdHQ2t3TGpENEQ4RjZNVmpPY0tq?=
 =?utf-8?B?QUkwUk41NmxYVzBWVTg1Z0ZaQ2VscVdqVDFSTS8zdEtvQlQ5VVhrWnRkam1U?=
 =?utf-8?B?Wm1SYlI0WWI5R0IwcGhOcHgyWDNzTjVrcVZHelV4NUhjcFZycjBqb3lnQ25S?=
 =?utf-8?B?eEoxYTVyNW55cE4xcUNQdzl1VFA3VGV3TnVnYmozNDEyS1cwNnRGTC9hYjJq?=
 =?utf-8?B?WmdYQ1hwVjV6L3A0OHdlQnRySEZNVStPK0UxQ1lLcE54aDVrejJCRkJWVVBr?=
 =?utf-8?B?RlFLT1BEZUZ6b0w5NTZ4dEp3TG5pWElBQTZHaXN0TmJyVE1sZ1lZNW9RSm5m?=
 =?utf-8?B?MkI3YVZ0Ym1XVHVTOFNIN1dLeXRYRUpQR1kzbmZDbEc5cTMrdlB3RXpHQkwx?=
 =?utf-8?B?UFhFdUpNM2dZeFB4dUFhTy9DUTVBaVlZSzJzaTVvWG5saWk0Zy9kWC9HMk92?=
 =?utf-8?B?QmIxakVMVjhhTHNqZ0RaZWl0clZZWTVBZG03R2FkL1lwUzhXWFNjdWFudnNn?=
 =?utf-8?B?cFQrcTNrNGFsTlp4QTdvUDRlOWl6V3V3bkhTYmVYRnVtWklqbmJqcFdwRmZv?=
 =?utf-8?B?SGJ5L0w5Wmsra3VXSnVZODRydGFoNGttTE5teHdmMnNBYUQ4T2x6SHdQYnVE?=
 =?utf-8?Q?1iKL9ARYeAmas=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da7707d7-da65-4977-31f8-08d895695ac1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 19:51:39.8316
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S4RabYr/DbqW14JoFAd9KIX6E2AFr8V38FlF9t3DU/VEhAkcNg+LipF0dNlmkH81ubIb7NHStXZyV/R9TPEcQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4148
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606765901; bh=tBq+OE4X14zFDJ/hp2YqpvvzB3FeIZKjFUDEM3U3I54=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=nuwy7aUMzqneqqd56DtrPhJQAsRLlPUHOjAMdhcGtkhObnhKUD9aM1vJ0RGDBoWge
         cc9Vi/xTzDFdGH1ze6P7JGQO50Iu24sbREkzBMpo+s5WLPBpWygS+7wYGAL61XxFC7
         Jwu2mUXUdnzQ/B4qXPic4QUD23P45dlHv9jwhRHWsH/3lvR/e94oNKgp24ryCIGWDt
         4NxQG3VQ69/utdxR8gNLzoUFS57WSU7ptd0ZLqvtbCTQjAyitnc5cuducjtryeEnHd
         NFBHhzpNwomuYHkvi3Va4IwYFQuGu8WF2tOdPzinVPXCosRhq7HTG+Y6mWt5HZCWmp
         oZ4x552kw1jJg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gRnJvbTogSmFjb2IgS2VsbGVyIDxqYWNvYi5lLmtlbGxlckBpbnRlbC5jb20+DQo+IFNl
bnQ6IFR1ZXNkYXksIERlY2VtYmVyIDEsIDIwMjAgMTI6NTkgQU0NCj4gDQo+IA0KPiANCj4gT24g
MTEvMzAvMjAyMCA4OjQxIEFNLCBQYXJhdiBQYW5kaXQgd3JvdGU6DQo+ID4gQWRkZWQgZG9jdW1l
bnRhdGlvbiBmb3IgZGV2bGluayBwb3J0IGFuZCBwb3J0IGZ1bmN0aW9uIHJlbGF0ZWQgY29tbWFu
ZHMuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG52aWRpYS5j
b20+DQo+ID4gUmV2aWV3ZWQtYnk6IEppcmkgUGlya28gPGppcmlAbnZpZGlhLmNvbT4NCj4gDQo+
IEdvb2QgdG8gc2VlIHRoaXMhIEkgc2F3IGEgY291cGxlIG9mIG1pbm9yIG5pdHMuDQo+DQpUaGFu
a3MsIGZpeGluZyB0aGVtLg0KIA0KPiAtIEpha2UNCj4gDQo+ID4gLS0tDQo+ID4gIC4uLi9uZXR3
b3JraW5nL2RldmxpbmsvZGV2bGluay1wb3J0LnJzdCAgICAgICB8IDEwMiArKysrKysrKysrKysr
KysrKysNCj4gPiAgRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL2RldmxpbmsvaW5kZXgucnN0ICAg
IHwgICAxICsNCj4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAxMDMgaW5zZXJ0aW9ucygrKQ0KPiA+ICBj
cmVhdGUgbW9kZSAxMDA2NDQgRG9jdW1lbnRhdGlvbi9uZXR3b3JraW5nL2RldmxpbmsvZGV2bGlu
ay1wb3J0LnJzdA0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vbmV0d29ya2lu
Zy9kZXZsaW5rL2RldmxpbmstcG9ydC5yc3QNCj4gPiBiL0RvY3VtZW50YXRpb24vbmV0d29ya2lu
Zy9kZXZsaW5rL2RldmxpbmstcG9ydC5yc3QNCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+
IGluZGV4IDAwMDAwMDAwMDAwMC4uOTY2ZDJlZTMyOGE2DQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+
ICsrKyBiL0RvY3VtZW50YXRpb24vbmV0d29ya2luZy9kZXZsaW5rL2RldmxpbmstcG9ydC5yc3QN
Cj4gPiBAQCAtMCwwICsxLDEwMiBAQA0KPiA+ICsuLiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjog
R1BMLTIuMA0KPiA+ICsNCj4gPiArPT09PT09PT09PT09DQo+ID4gK0RldmxpbmsgUG9ydA0KPiA+
ICs9PT09PT09PT09PT0NCj4gPiArDQo+ID4gK2BgZGV2bGluay1wb3J0YGAgcHJvdmlkZXMgY2Fw
YWJpbGl0eSBmb3IgYSBkcml2ZXIgdG8gZXhwb3NlIHZhcmlvdXMNCj4gPiArZmxhdm91cnMgb2Yg
cG9ydHMgd2hpY2ggZXhpc3Qgb24gZGV2aWNlLiBBIGRldmxpbmsgcG9ydCBjYW4gb2YgYW4NCj4g
PiArZW1iZWRkZWQgc3dpdGNoIChlc3dpdGNoKSBwcmVzZW50IG9uIHRoZSBkZXZpY2UuDQo+ID4g
Kw0KPiANCj4gU2VlbXMgbGlrZSBhIHdvcmQgaXMgbWlzc2luZyBoZXJlIGluIHRoZSAiQSBkZXZs
aW5rIHBvcnQgY2FuIG9mIGFuIGVtYmVkZGVkDQo+IHN3aXRjaCIuIFBlcmhhcHMgIkNhbiBiZSBv
ZiI/DQo+IA0KWWVzLiANCj4gPiArQSBkZXZsaW5rIHBvcnQgY2FuIGJlIG9mIDMgZGlmZmZlcmVu
dCB0eXBlcy4NCj4gPiArDQo+ID4gKy4uIGxpc3QtdGFibGU6OiBMaXN0IG9mIGRldmxpbmsgcG9y
dCB0eXBlcw0KPiA+ICsgICA6d2lkdGhzOiAyMyA5MA0KPiA+ICsNCj4gPiArICAgKiAtIFR5cGUN
Cj4gPiArICAgICAtIERlc2NyaXB0aW9uDQo+ID4gKyAgICogLSBgYERFVkxJTktfUE9SVF9UWVBF
X0VUSGBgDQo+ID4gKyAgICAgLSBUaGlzIHR5cGUgaXMgc2V0IGZvciBhIGRldmxpbmsgcG9ydCB3
aGVuIGEgcGh5c2ljYWwgbGluayBsYXllciBvZiB0aGUgcG9ydA0KPiA+ICsgICAgICAgaXMgRXRo
ZXJuZXQuDQo+ID4gKyAgICogLSBgYERFVkxJTktfUE9SVF9UWVBFX0lCYGANCj4gPiArICAgICAt
IFRoaXMgdHlwZSBpcyBzZXQgZm9yIGEgZGV2bGluayBwb3J0IHdoZW4gYSBwaHlzaWNhbCBsaW5r
IGxheWVyIG9mIHRoZSBwb3J0DQo+ID4gKyAgICAgICBpcyBJbmZpbmlCYW5kLg0KPiA+ICsgICAq
IC0gYGBERVZMSU5LX1BPUlRfVFlQRV9BVVRPYGANCj4gPiArICAgICAtIFRoaXMgdHlwZSBpcyBp
bmRpY2F0ZWQgYnkgdGhlIHVzZXIgd2hlbiB1c2VyIHByZWZlcnMgdG8gc2V0IHRoZSBwb3J0IHR5
cGUNCj4gPiArICAgICAgIHRvIGJlIGF1dG9tYXRpY2FsbHkgZGV0ZWN0ZWQgYnkgdGhlIGRldmlj
ZSBkcml2ZXIuDQo+ID4gKw0KPiA+ICtEZXZsaW5rIHBvcnQgY2FuIGJlIG9mIGZldyBkaWZmZXJl
bnQgZmxhdm91cnMgZGVzY3JpYmVkIGJlbG93Lg0KPiA+ICsNCj4gPiArLi4gbGlzdC10YWJsZTo6
IExpc3Qgb2YgZGV2bGluayBwb3J0IGZsYXZvdXJzDQo+ID4gKyAgIDp3aWR0aHM6IDMzIDkwDQo+
ID4gKw0KPiA+ICsgICAqIC0gRmxhdm91cg0KPiA+ICsgICAgIC0gRGVzY3JpcHRpb24NCj4gPiAr
ICAgKiAtIGBgREVWTElOS19QT1JUX0ZMQVZPVVJfUEhZU0lDQUxgYA0KPiA+ICsgICAgIC0gQW55
IGtpbmQgb2YgcG9ydCB3aGljaCBpcyBwaHlzaWNhbGx5IGZhY2luZyB0aGUgdXNlci4gVGhpcyBj
YW4gYmUNCj4gPiArICAgICAgIGEgZXN3aXRjaCBwaHlzaWNhbCBwb3J0IG9yIGFueSBvdGhlciBw
aHlzaWNhbCBwb3J0IG9uIHRoZSBkZXZpY2UuDQo+ID4gKyAgICogLSBgYERFVkxJTktfUE9SVF9G
TEFWT1VSX0NQVWBgDQo+ID4gKyAgICAgLSBUaGlzIGluZGljYXRlcyBhIENQVSBwb3J0Lg0KPiA+
ICsgICAqIC0gYGBERVZMSU5LX1BPUlRfRkxBVk9VUl9EU0FgYA0KPiA+ICsgICAgIC0gVGhpcyBp
bmRpY2F0ZXMgYSBpbnRlcmNvbm5lY3QgcG9ydCBpbiBhIGRpc3RyaWJ1dGVkIHN3aXRjaCBhcmNo
aXRlY3R1cmUuDQo+ID4gKyAgICogLSBgYERFVkxJTktfUE9SVF9GTEFWT1VSX1BDSV9QRmBgDQo+
ID4gKyAgICAgLSBUaGlzIGluZGljYXRlcyBhbiBlc3dpdGNoIHBvcnQgcmVwcmVzZW50aW5nIFBD
SSBwaHlzaWNhbCBmdW5jdGlvbihQRikuDQo+ID4gKyAgICogLSBgYERFVkxJTktfUE9SVF9GTEFW
T1VSX1BDSV9WRmBgDQo+ID4gKyAgICAgLSBUaGlzIGluZGljYXRlcyBhbiBlc3dpdGNoIHBvcnQg
cmVwcmVzZW50aW5nIFBDSSB2aXJ0dWFsIGZ1bmN0aW9uKFZGKS4NCj4gPiArICAgKiAtIGBgREVW
TElOS19QT1JUX0ZMQVZPVVJfVklSVFVBTGBgDQo+ID4gKyAgICAgLSBUaGlzIGluZGljYXRlcyBh
IHZpcnR1YWwgcG9ydCBmYWNpbmcgdGhlIHVzZXIuDQo+ID4gKyAgICogLSBgYERFVkxJTktfUE9S
VF9GTEFWT1VSX1ZJUlRVQUxgYA0KPiA+ICsgICAgIC0gVGhpcyBpbmRpY2F0ZXMgYW4gdmlydHVh
bCBwb3J0IGZhY2luZyB0aGUgdXNlci4NCj4gDQo+IERFVkxJTktfUE9SVF9GTEFWT1VSX1ZJUlRV
QUwgaXMgcmVwZWF0ZWQuDQo+IA0KUmVtb3ZpbmcgaXQuDQoNCj4gPiArDQo+ID4gK0EgZGV2bGlu
ayBwb3J0IG1heSBiZSBmb3IgYSBjb250cm9sbGVyIGNvbnNpc3Qgb2Ygb25lIG9yIG1vcmUgUENJ
IGRldmljZShzKS4NCj4gPiArQSBkZXZsaW5rIGluc3RhbmNlIGhvbGRzIHBvcnRzIG9mIHR3byB0
eXBlcyBvZiBjb250cm9sbGVycy4NCj4gPiArDQo+IA0KPiBzL2NvbnNpc3QvY29uc2lzdGluZy8g
Pw0KPg0KWWVzLg0K
