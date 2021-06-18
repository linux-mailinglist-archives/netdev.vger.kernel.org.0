Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7067E3ACF3D
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 17:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235545AbhFRPiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 11:38:50 -0400
Received: from us-smtp-delivery-115.mimecast.com ([216.205.24.115]:34567 "EHLO
        us-smtp-delivery-115.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229768AbhFRPit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 11:38:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maxlinear.com;
        s=selector; t=1624030599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3NlxFHAmo9QvZmqoLs8Mefa69sfsNgI4EE7M8g3I8tM=;
        b=DX3TNcII6q7kdwqPFHU3RszpL6tBPCn6XSXhmwtX1RW2VuVlYC361wtx2hIogSWl/9CEve
        kT0Pbx5Crh4ulsDzSKFOhsM+39GeoSvreysf3zTcZ/cVJM5jAIVlV5oXka1mNjs5GCffLa
        PU9yW694Ht4Hvum0fAjoTa8UOU3LX+s=
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
 (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-4El921n-M6quigwcW05iUQ-1; Fri, 18 Jun 2021 11:36:37 -0400
X-MC-Unique: 4El921n-M6quigwcW05iUQ-1
Received: from MWHPR19MB0077.namprd19.prod.outlook.com (2603:10b6:301:67::32)
 by MW3PR19MB4219.namprd19.prod.outlook.com (2603:10b6:303:51::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Fri, 18 Jun
 2021 15:36:35 +0000
Received: from MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87]) by MWHPR19MB0077.namprd19.prod.outlook.com
 ([fe80::b931:30a4:ce59:dc87%4]) with mapi id 15.20.4219.024; Fri, 18 Jun 2021
 15:36:35 +0000
From:   Liang Xu <lxu@maxlinear.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Topic: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Thread-Index: AQHXWVyDhUpan91jNkyIQ1KYwvXYZKsECXGAgAAhoACAAB2SAIAAfDEAgAC87YCAAnCRAIARoG6AgABPWYCAABqdAA==
Date:   Fri, 18 Jun 2021 15:36:35 +0000
Message-ID: <2f6c23fd-724e-c9e0-83f2-791cb747d846@maxlinear.com>
References: <20210604161250.49749-1-lxu@maxlinear.com>
 <f56aa414-3002-ef85-51a9-bb36017270e6@gmail.com>
 <7834258b-5826-1c00-2754-b0b7e76b5910@maxlinear.com>
 <YLqIvGIzBIULI2Gm@lunn.ch>
 <2b9945f9-16a4-bda5-40df-d79089be3c12@maxlinear.com>
 <YLuPZTXFrJ9KjNpl@lunn.ch>
 <9a838afe-83e7-b575-db49-f210022966d5@maxlinear.com>
 <334b52a6-30e8-0869-6ffb-52e9955235ff@maxlinear.com>
 <YMynL9c9MpfdC7Se@lunn.ch>
In-Reply-To: <YMynL9c9MpfdC7Se@lunn.ch>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
x-originating-ip: [138.75.37.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99a64ba6-7701-46ef-5823-08d9326edb53
x-ms-traffictypediagnostic: MW3PR19MB4219:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR19MB421943ECF1DE24470F1EF73FBD0D9@MW3PR19MB4219.namprd19.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: z4mUE7RuEG9MC7uVU3W6Lm6sVCGCm6kzoJbed/6RWDcRHDjJwrDTDFhYrkHwUHSzMB9IdYcia/vrZ8UNiqP9tjZQAJIoVQasWiVIS2YcLL8FQemjWSg2UvYQmEMaW8RNIy00ykUE8juKpz1RjyYv++Ip5u1piBKDOlQXzowyz/jpoaytnFG2eqX22tNvSVBZNPu846qdTeowtUx+ubkollf0FaH8W3Y/y5VoZ9rrtLXD/cC7BtWcED+Hndh+lGBwJEptNA6AeC+wdv1wTUMslXY5nvNd0YQifAsZHt1raHqXrPouLkbYWSdu651rdRIaanga5gZub2DopIeMyY6xf4/Z2hLnb2gj/i17B1ZoaJK8con4EcQdciauNYYvnZhlgJVyEmBwb88yvF3h+6WILTgN3HSsrK8EjHJlLdR9uVeAmlpu3tbOBH21dRaTQcK5vHa3s4Krime9Ec3lWsceU3fcoCBds91C+uFDWfcIwVZPtMGKo5ikRXSRC3J7DpV1PxYhKgc0kWmbDUSaOlUurXzUN/fCjQcElOUQIWtu4fSN+h0DbgWzOTDGNaroLozvdmNMKricOuXS0htkNNSm+9uvOPSldMUHt461woXJlHNnIlB+LYar3NtT0f1lU2qJQt7rG6jIjHmxFkQ4tvv88CnklCAjVWtvGn9dn6pasROZsa1PEGR3xiWCtt2GM/a/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR19MB0077.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(39840400004)(136003)(4326008)(6486002)(2906002)(478600001)(186003)(2616005)(5660300002)(8936002)(71200400001)(6916009)(83380400001)(31686004)(6512007)(64756008)(66946007)(36756003)(6506007)(66446008)(76116006)(8676002)(91956017)(316002)(26005)(31696002)(54906003)(122000001)(38100700002)(86362001)(66476007)(66556008)(107886003)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dzdGR2cxdys5RkJVNXFVa1ZVSTMyYUk0UXAzVUF2UFVCR1VoM0FaSTBkQWxJ?=
 =?utf-8?B?SStFOXNVTXFiQkN6eVFmek1WWlNzNUNPK3VFMWM3cmNvSnErNUQvbUxCZFpN?=
 =?utf-8?B?ZjUxUTJPMmtNYkYrd2RYZmt1MlcrMERwUUZUT1VSdlArOFI2VGJJZHZ5UkIr?=
 =?utf-8?B?QnBRWnlmWTlFYzA2TExxaW81bk94Nk90L3crTXFWVVVCVTRZbnlWOFhvSmhI?=
 =?utf-8?B?Yi9vK0JtaWtYVG8xa2EwMEx5ejc5eldleTVicTZtcTIyTTZpcHc5TVEvNUJ4?=
 =?utf-8?B?K1dNL3ZzSGxZbEZWaXV4WkVtMTEzQ2RuSTJaZ0lvUnJzS3E2b1pEOWEyNXVl?=
 =?utf-8?B?Y0tMOFhGOEEzWXd6VjdmY0EwWTlPcW1ZV3dLVUVGM2ZmYW9qcDViajJTYWtt?=
 =?utf-8?B?aURhTlVMaFZVczFDalp1T3RrVVpIRHdUWWFJZTRGa2tRVTFsc3dJelhkRzhQ?=
 =?utf-8?B?TndPL1M2RkZJYnNCRUhZRk42UDJTOEhKM1J5R1JYN09wLzQwSm1aUWEwaUFv?=
 =?utf-8?B?N2NSTFczdHBGK29qNEl5TklIcklWaGNiUEZOZXdCYmM5MDZBZXNQWGNhdjNO?=
 =?utf-8?B?aktwT1U2OVQvOUlveUNpS1pmRVdQdmFBdGRtVE1OdGFGZ2xGQ2dKSWVtVXps?=
 =?utf-8?B?MXZBSjMrU0JaL3EvdjJSWVFzM3l3N01QeUY5RjkrcWVRa3Y3OVZmRWNrVjVB?=
 =?utf-8?B?TC9JZmE2UGxnYmVCUmFiY3Q1aDFpQXByRnRxZi9WK2VqL01hekVxYkROdEhQ?=
 =?utf-8?B?WE5Rc1N0dzNtVGxPTi9aaU9uZ3JWdHlOK0hyTnl5N25jSFNPcFBTemY0a1h1?=
 =?utf-8?B?bWpld3J4MW04bE0wVmg4bHR1bmpuTFdiVXM4N213ajBRZkp3d1JDYitTRVgw?=
 =?utf-8?B?YWNEWmU1TUxHT3Z1M2tPMEVHVTBXUThZWkN4UXBvVTMvN1NMak9qYmpVV21h?=
 =?utf-8?B?KzdlVXVYTldYdnRjN2hnNklnMXI3YndXU3RwczcxWWRWNFJKOEVkMTd6dm0x?=
 =?utf-8?B?UWJ5S2ZCWmhVbFYxRDlkZHNwTWxQU1I4Z3RkUHV2UDBhSUtxSmNKbG1Mc0VV?=
 =?utf-8?B?OUpTWC9kNC9IeHFEVXpMaGZhVlZsNXA0N0NKeFpUMFY0cHBlTllnbklQV3Np?=
 =?utf-8?B?bjdyZkZhZVBrRWxWckY5aW10SXNmcUYwWHFVOUpFSXA3eStja1lNZExsR0xR?=
 =?utf-8?B?Z3hQOCtjekFKN3dqOEpYSmJ2RWN3Y05ycVk5RDA0cGozTGQ3bldEaXJyM2wr?=
 =?utf-8?B?bi9nM0d1Y0JqclpHTzI2Y3duRURmZHFHdzZ3b1dKZ1pHREp6aUMrQldKRGtQ?=
 =?utf-8?B?NEpOSmZlcUNGYmRaSVJFcVc2MEpYZ3cyRTA0Zy9YcFVGZkh4Q09iVWZtWS93?=
 =?utf-8?B?cStPM0Ird2dTQTBEZWYrYlJadnpOUmN0dEZ6eTI4MkVYd0syOGcwVEVTVHFG?=
 =?utf-8?B?S29uTlprNFZOYlhUczJjdWlxVHloUW1JWlJUZ3AzMlllSUE3akNCcnlLRlh1?=
 =?utf-8?B?WllYOUNhUDFjLzJFYUE5YjY2algrTHF5SzVoZDhYWW5Ob3NENUFTVm55N1dh?=
 =?utf-8?B?M1RaOW1WQmtpelA4SHFMNXlFb25PdkFDWmhWTTlsY2VCdVM1VE8yT1gwMklD?=
 =?utf-8?B?ZThYclBjd3M4dWZTb1hjUFhSd245YXFCRlZ2akx4SkdoSHJnVTRkQWM2bHZ5?=
 =?utf-8?B?Y1Bnb0lPK1JyZU13UlRLbVRrc1NNSkFncURramUzSDZ2UW1rdi9wK2pVZ2hL?=
 =?utf-8?Q?QQXrgdvFXFCZPP7jfY=3D?=
MIME-Version: 1.0
X-OriginatorOrg: maxlinear.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR19MB0077.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a64ba6-7701-46ef-5823-08d9326edb53
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2021 15:36:35.6140
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: dac28005-13e0-41b8-8280-7663835f2b1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j8kJf1nrNOEIu5CtAQoxxla0ndvqy4GIPYzn25iatgUEZ7Saf4ETzvq7WmAa/cVKtX8YUcn/YRVgMLZd9IPapg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR19MB4219
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA115A51 smtp.mailfrom=lxu@maxlinear.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: maxlinear.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <271EEF6B150039469674CE3777D1A85B@namprd19.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTgvNi8yMDIxIDEwOjAxIHBtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4gVGhpcyBlbWFpbCB3
YXMgc2VudCBmcm9tIG91dHNpZGUgb2YgTWF4TGluZWFyLg0KPg0KPg0KPj4gTmV0LW5leHQ6DQo+
Pg0KPj4gaW50IGdlbnBoeV9sb29wYmFjayhzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2LCBib29s
IGVuYWJsZSkNCj4+IHsNCj4+ICAgICAgIGlmIChlbmFibGUpIHsNCj4+ICAgICAgICAgICB1MTYg
dmFsLCBjdGwgPSBCTUNSX0xPT1BCQUNLOw0KPj4gICAgICAgICAgIGludCByZXQ7DQo+Pg0KPj4g
ICAgICAgICAgIGlmIChwaHlkZXYtPnNwZWVkID09IFNQRUVEXzEwMDApDQo+PiAgICAgICAgICAg
ICAgIGN0bCB8PSBCTUNSX1NQRUVEMTAwMDsNCj4+ICAgICAgICAgICBlbHNlIGlmIChwaHlkZXYt
PnNwZWVkID09IFNQRUVEXzEwMCkNCj4+ICAgICAgICAgICAgICAgY3RsIHw9IEJNQ1JfU1BFRUQx
MDA7DQo+Pg0KPj4gICAgICAgICAgIGlmIChwaHlkZXYtPmR1cGxleCA9PSBEVVBMRVhfRlVMTCkN
Cj4+ICAgICAgICAgICAgICAgY3RsIHw9IEJNQ1JfRlVMTERQTFg7DQo+Pg0KPj4gICAgICAgICAg
IHBoeV9tb2RpZnkocGh5ZGV2LCBNSUlfQk1DUiwgfjAsIGN0bCk7DQo+Pg0KPj4gICAgICAgICAg
IHJldCA9IHBoeV9yZWFkX3BvbGxfdGltZW91dChwaHlkZXYsIE1JSV9CTVNSLCB2YWwsDQo+PiAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHZhbCAmIEJNU1JfTFNUQVRVUywNCj4+ICAgICAgICAg
ICAgICAgICAgICAgICA1MDAwLCA1MDAwMDAsIHRydWUpOw0KPj4gICAgICAgICAgIGlmIChyZXQp
DQo+PiAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+PiAgICAgICB9IGVsc2Ugew0KPj4gICAg
ICAgICAgIHBoeV9tb2RpZnkocGh5ZGV2LCBNSUlfQk1DUiwgQk1DUl9MT09QQkFDSywgMCk7DQo+
Pg0KPj4gICAgICAgICAgIHBoeV9jb25maWdfYW5lZyhwaHlkZXYpOw0KPj4gICAgICAgfQ0KPj4N
Cj4+ICAgICAgIHJldHVybiAwOw0KPj4gfQ0KPj4NCj4+IHY1LjEyLjExOg0KPj4NCj4+IGludCBn
ZW5waHlfbG9vcGJhY2soc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldiwgYm9vbCBlbmFibGUpDQo+
PiB7DQo+PiAgICAgICByZXR1cm4gcGh5X21vZGlmeShwaHlkZXYsIE1JSV9CTUNSLCBCTUNSX0xP
T1BCQUNLLA0KPj4gICAgICAgICAgICAgICAgIGVuYWJsZSA/IEJNQ1JfTE9PUEJBQ0sgOiAwKTsN
Cj4+IH0NCj4+DQo+Pg0KPj4gTm90IHN1cmUgd2hldGhlciBhbnlvbmUgZWxzZSByZXBvcnRlZCBz
aW1pbGFyIGlzc3VlLg0KPiBUaGUgY29tbWl0IG1lc3NhZ2Ugc2F5czoNCj4NCj4gICAgICBuZXQ6
IHBoeTogZ2VucGh5X2xvb3BiYWNrOiBhZGQgbGluayBzcGVlZCBjb25maWd1cmF0aW9uDQo+DQo+
ICAgICAgSW4gY2FzZSBvZiBsb29wYmFjaywgaW4gbW9zdCBjYXNlcyB3ZSBuZWVkIHRvIGRpc2Fi
bGUgYXV0b25lZyBzdXBwb3J0DQo+ICAgICAgYW5kIGZvcmNlIHNvbWUgc3BlZWQgY29uZmlndXJh
dGlvbi4gT3RoZXJ3aXNlLCBkZXBlbmRpbmcgb24gY3VycmVudGx5DQo+ICAgICAgYWN0aXZlIGF1
dG8gbmVnb3RpYXRlZCBsaW5rIHNwZWVkLCB0aGUgbG9vcGJhY2sgbWF5IG9yIG1heSBub3Qgd29y
ay4NCj4NCj4+IFNob3VsZCBJIHVzZSBwaHlfbW9kaWZ5IHRvIHNldCB0aGUgTE9PUEJBQ0sgYml0
IG9ubHkgaW4gbXkgZHJpdmVyDQo+PiBpbXBsZW1lbnRhdGlvbiBhcyBmb3JjZSBzcGVlZCB3aXRo
IGxvb3BiYWNrIGVuYWJsZSBkb2VzIG5vdCB3b3JrIGluIG91cg0KPj4gZGV2aWNlPw0KPiBTbyB5
b3UgYXBwZWFyIHRvIGhhdmUgdGhlIGV4YWN0IG9wcG9zaXRlIHByb2JsZW0sIHlvdSBuZWVkIHRv
IHVzZQ0KPiBhdXRvLW5lZywgd2l0aCB5b3Vyc2VsZiwgaW4gb3JkZXIgdG8gaGF2ZSBsaW5rLiBT
byB0aGVyZSBhcmUgdHdvDQo+IHNvbHV0aW9uczoNCj4NCj4gMSkgQXMgeW91IHNheSwgaW1wbGVt
ZW50IGl0IGluIHlvdXIgZHJpdmVyDQo+DQo+IDIpIEFkZCBhIHNlY29uZCBnZW5lcmljIGltcGxl
bWVudGF0aW9uLCB3aGljaCBlbmFibGVzIGF1dG9uZWcsIGlmIGl0DQo+IGlzIG5vdCBlbmFibGVk
LCBzZXRzIHRoZSBsb29wYmFjayBiaXQsIGFuZCB3YWl0cyBmb3IgdGhlIGxpbmsgdG8gY29tZQ0K
PiB1cC4NCj4NCj4gRG9lcyB5b3VyIFBIWSBkcml2ZXIgZXJyb3Igb3V0IHdoZW4gYXNrZWQgdG8g
ZG8gYSBmb3JjZWQgbW9kZT8gSXQNCj4gcHJvYmFibHkgc2hvdWxkLCBpZiB5b3VyIHNpbGljb24g
ZG9lcyBub3Qgc3VwcG9ydCB0aGF0IHBhcnQgb2YgQzIyLg0KPg0KPiAgICAgICAgICAgQW5kcmV3
DQo+DQpUaGFuayB5b3UgZm9yIHByb21wdCByZXBseS4NCg0KVGhlIGZvcmNlZCBtb2RlIGlzIHN1
Y2Nlc3NmdWwgYmVjYXVzZSB3ZSBzdXBwb3J0IGZvcmNlZCBtb2RlIGluIEMyMi4NCg0KVGhlIHBy
b2JsZW0gaGFwcGVucyBpbiB0aGUgc3BlZWQgY2hhbmdlIG5vIG1hdHRlciBpdCdzIGZvcmNlZCBv
ciANCmF1dG8tbmVnIGluIG91ciBkZXZpY2UuDQoNCklmIEkga2VlcCBjdXJyZW50IHN0YXR1cyBh
bmQganVzdCBzZXQgdGhlIGxvb3BiYWNrIGJpdCwgaXQgd29ya3MuDQoNClRoaXMgbWF5IGJlIHNw
ZWNpZmljIHRvIG91ciBkZXZpY2UsIGlmIG5vYm9keSBlbHNlIHJlcG9ydCBpc3N1ZSBpbiB0aGUg
DQpnZW5waHlfbG9vcGJhY2sgaW1wbGVtZW50YXRpb24gaW4gbmV0LW5leHQuDQoNClRoZW4gSSB3
aWxsIGltcGxlbWVudCBpdCBpbiBteSBkcml2ZXIuDQoNCg0KVGhhbmtzICYgUmVnYXJkcywNCg0K
WHUgTGlhbmcNCg0K

