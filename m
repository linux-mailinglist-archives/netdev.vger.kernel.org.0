Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67F691E52AF
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 03:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgE1BKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 21:10:47 -0400
Received: from mail-eopbgr40042.outbound.protection.outlook.com ([40.107.4.42]:46819
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgE1BKr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 21:10:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJYDRu5e+rSULL8c53N1QDCWrNwf8CXeuz2bix9MCpg3gJpTebQ0f7UdVOB2WwIP00h8+33jWyHRf7rUZ7T2sOaWaZeCeJ0wFnZYN0RqCPPUg+m5SsRmqGFv1RV7RCuRsEYijgeUfJ7oGgl+3MlloTEVegIS6G9Pm8EX15jYyAhUXfPy1jSza6/dK/Bq8fHvx+aBy9MA5Hke5dnaKRT/nK4PPDd7AHtutLMh/D87KwrWjGl1hPYg2Lw6hm4i0jMptzl7PM/SkcMPIMJr9rlIdqc2xBQeOQ5vusWtYj1f5XnPkQUObGniC8w4T1dMqNUKXqgTN8VNLhlQcOt5ASZBWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ocNoQMtYgp/IbtpM8spsQhQZfbsUPApq34BAM76ng38=;
 b=WXobXSja1L11fh1oqv4M3qoIyQasX+RVd647/sCDGdaJPY3AbUHIvuyWufkCiu9/B4X/ubHI2eHBj9wbUQlWk2EDA8XY7drUQu1zPKydA62+1W17s4yNCLSGXc4e9EWj8Y+2Vz+sMkm1lQtPFg/YsVoGsWLZFni4TuILEaFUHuNCXNFWR/W3hhCtud6CFs2CXglZrHPFL+eErjLbRD8QVjqlu8GxjIxsuXof7MpIbdvimUb2Wuywy8KKNqVlpgGMggAq5DC6uCYgTvOVF94f0FVpwlbEtzoINxgXBzB1ErvG8JWsG+0oBXitqxqN87ohq1VxfgFA1TA8BNUJ80q8ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ocNoQMtYgp/IbtpM8spsQhQZfbsUPApq34BAM76ng38=;
 b=JX57AwGNdH3ZlVkw5wxSxd/wxa6qdg93Xqxjd/46V4EvOronpNW9/TdgNUGMEYB0q5XbE5vZhrV4f+4KzSy+IDIo+63lhmcRT1X48+jxLv09myaQRU1mCdKnYltttVVdI2flz9UEGd0QESTH23fSRn1aD7WEKUY3j7r67DW2mCA=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5727.eurprd05.prod.outlook.com (2603:10a6:803:cb::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Thu, 28 May
 2020 01:10:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 01:10:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net-next V2 00/15] mlx5 updates 2020-05-26
Thread-Topic: [pull request][net-next V2 00/15] mlx5 updates 2020-05-26
Thread-Index: AQHWNELwtPdpLdxtDEqjoR+8+B2Bsqi8MOQAgACAMwA=
Date:   Thu, 28 May 2020 01:10:44 +0000
Message-ID: <21635a972965daa463ff9a25719f21d7a88059bf.camel@mellanox.com>
References: <20200527162139.333643-1-saeedm@mellanox.com>
         <20200527103152.1a0d225a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200527103152.1a0d225a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e5adc6d7-2e91-4b02-f109-08d802a3f282
x-ms-traffictypediagnostic: VI1PR05MB5727:
x-microsoft-antispam-prvs: <VI1PR05MB5727A50408F08D336B295D34BE8E0@VI1PR05MB5727.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xsbkjwDtR7QvjMMVlPISX60YgVzdw83e8ANuS0xhy8d5u/x41DuZ0AoDmN32N8zRu7938XTS7hTX8w6vm5FaZjywxwsY0GluKAeKn7PcF3m1C3q6diK2uFd8fpAs4pwxsAshhLYF2KHXYjO875f+MNG1SG3qB1LBXFBDeDjSetaf1RO3ZpA496LmIMjK6KWVtoKoK27BfU6rEB1arFmg163VZga2lJnAO88td1/l8yjMXvnPf15NByH6cbXL/GdpyEDVK0mk/+xReGZGG5omAW34VgA2l88lTP+sPoUnTsZE9fAXYNLBXIOkX9aivirdu6kF8RoS87Bur2M7oWcyZQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(2616005)(8676002)(8936002)(36756003)(5660300002)(26005)(15650500001)(4744005)(6512007)(186003)(4326008)(2906002)(83380400001)(6506007)(54906003)(6486002)(316002)(71200400001)(66556008)(478600001)(66476007)(66946007)(64756008)(86362001)(76116006)(66446008)(91956017)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ApdN9xdFgkty4OIHSONCmQpHOt4FQ2jYCsgDFcnJEeFH/VaBueh5QUpmk1AyNarK/1wsePKNMFTFl60M4Mxicl7tZxLEN+Fzt3u391qV2lLfeSgK2bSHzF0+SuB1MtgjQbpP+gc1RibVITqlHFPMRlrzoVvsSrRZ7cHy1jAdKGVNslZRcDmk1N2jf9QHW+lOwXmlSNKQ/TZLoj2rFVUhClgqvD2YfSVSdTOIAqcmEhTFYVyFA7qLbU1Zjy94cS5DYpCX6qrSM4k+UsV8IKEUskgimaeDciPNV0juCa/Lh+/leQlRRDYwuIceDut7A8cnHZDkBjJnNQS4PCnIsohyr9e8WuA/ce9lid4JVBYnfbEBney5j8m5P1cAg1e5+ju/QttUtpnBFeItMiZGZWI8PGxCUvMQ5FSkzI5O5bSCZRy78VqkOdx+EG9wrPWrATcQc/e2IjWEM8YxTo8cZKC+6uuU7wSi4vHv4S2sN5pnJc0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <49C1E66591CDC14B92C56BE2B7DE172D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5adc6d7-2e91-4b02-f109-08d802a3f282
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 01:10:44.3818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pLdGvxM0wfZFFVlvHFJhtHz53Is9h8fM6AqnYZb7PR8eBOMxUGOnDnKW8ogWaXEjyf2ISfQsRiekvBWTq3iYoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5727
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTA1LTI3IGF0IDEwOjMxIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAyNyBNYXkgMjAyMCAwOToyMToyNCAtMDcwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBIaSBEYXZlL0pha3ViLg0KPiA+IA0KPiA+IFRoaXMgc2VyaWVzIGFkZHMgc3VwcG9y
dCBmb3IgbWx4NSBzd2l0Y2hkZXYgVk0gZmFpbG92ZXIgdXNpbmcgRlcNCj4gPiBib25kZWQNCj4g
PiByZXByZXNlbnRvciB2cG9ydCBhbmQgcHJvYmVkIFZGIGludGVyZmFjZSB2aWEgZXN3aXRjaCB2
cG9ydCBBQ0xzLg0KPiA+IFBsdXMgc29tZSBleHRyYSBtaXNjIHVwZGF0ZXMuDQo+ID4gDQo+ID4g
djEtPnYyOg0KPiA+ICAgLSBEcm9wcGVkIHRoZSBzdXNwZW5kL3Jlc3VtZSBzdXBwb3J0IHBhdGNo
LCB3aWxsIHJlLXN1Ym1pdCBpdCB0bw0KPiA+IG5ldCBhbmQNCj4gPiAgICAgLXN0YWJsZSBhcyBy
ZXF1ZXN0ZWQgYnkgRGV4dWFuLg0KPiA+IA0KPiA+IEZvciBtb3JlIGluZm9ybWF0aW9uIHBsZWFz
ZSBzZWUgdGFnIGxvZyBiZWxvdy4NCj4gPiANCj4gPiBQbGVhc2UgcHVsbCBhbmQgbGV0IG1lIGtu
b3cgaWYgdGhlcmUgaXMgYW55IHByb2JsZW0uDQo+IA0KPiBCdWlsZCBwcm9ibGVtcyBmcm9tIHYx
IGFwcGx5DQoNClllcCwgZml4aW5nIG5vdy4NCg==
