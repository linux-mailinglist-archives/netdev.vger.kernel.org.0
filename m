Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC4E217B325
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 01:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgCFAwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 19:52:30 -0500
Received: from mail-db8eur05on2078.outbound.protection.outlook.com ([40.107.20.78]:6119
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726173AbgCFAw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 19:52:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TPQn+GKOB+yXTw1MMr90esFGcx6u0826RaFG5fhCtnekKCHLK0THd7wuKwBdK5kku/aIOXa8V6mLVVAewIzAW2UvPgxWd5kXIwCgXeI1tGQxHm04aVSj5hSTwa2L/hiySjHJ0vArh8KoZLVbou1H4Hanv2P6MyqS2fa5OmdDK3Ft9/PZAbqau3YRlqTOFX/z8IHlPSxY2SAOSk0hS5OGrm8qtSqQ1+2gJa+wl3nk+Dw2mMz54ZkMDv0q2d0Fl6X7hA7SqteDDtNyR0VHcBSwEgckKGCcNNBYBSZ8AqAymfDU4VsvWMmATweI3y1IUGx6bNHhfrLqxZRCsScbjBWUow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBctt4nYpGXwtxyd/kbO3HPl2lrAEGqFdm41CMIzcC8=;
 b=EfH6+h1gEIeOsH/BK1ZL2kvw0koB5KfCfRu33yJnakdwgvKj2SzDs9ielKy4YSX57s1gjYylyFF+lLScpB0S2TBQ8CT9SK6MRpKpzWqio7msA75QgJPAlXZm0eyqOL2Tc49oFbRNS2PpfeYtW6xvzV4Ta+x+V4QzGMtMVpc6TclKASf6wctEaB2RjWro9QhaBMYLXRXiqr70Z8hpoegD8eLLejUlxGF0R/SHFp+k1e7aRM6vgGbfh321UiYB03xIQl1r8rEntt/WkV/5Y8bBjKZPMyvxa0daO/9FOLjwSSJBslzGtTwlOSi5V+OmdQ4MC4T5SdTD1fB5IF3lAiD3Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RBctt4nYpGXwtxyd/kbO3HPl2lrAEGqFdm41CMIzcC8=;
 b=QwKDHPPbEg3Grpzze/hUmvPeKPJ3GDhyvQEkwMuYDDBfNt5fp6nhObBjRFPgnfvaQj+7lSrl0vuLP7wuEpCpqFHujVs0C5ZgWSzJlFGzgTO+tOfreeqaokqoRwDeJT/VAv7I4ZzkogieG7uK/C7E5ElzpYfZUo/AVCx9qf+zoC4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3246.eurprd05.prod.outlook.com (10.170.236.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.18; Fri, 6 Mar 2020 00:52:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 00:52:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net 0/5] Mellanox, mlx5 fixes 2020-03-05
Thread-Topic: [pull request][net 0/5] Mellanox, mlx5 fixes 2020-03-05
Thread-Index: AQHV80RNKBZ+Y24z/0CDhMjONfpfj6g6rOWAgAAPjwA=
Date:   Fri, 6 Mar 2020 00:52:24 +0000
Message-ID: <7f2e3fb5789270a6106510138211e5c17f3c7ad7.camel@mellanox.com>
References: <20200305231739.227618-1-saeedm@mellanox.com>
         <20200305155641.0392c073@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200305155641.0392c073@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 54268cd5-a0b9-483b-20a6-08d7c168a271
x-ms-traffictypediagnostic: VI1PR05MB3246:
x-microsoft-antispam-prvs: <VI1PR05MB32467CD6988CB46DA11A2D45BEE30@VI1PR05MB3246.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0334223192
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(199004)(189003)(6506007)(186003)(71200400001)(36756003)(316002)(26005)(54906003)(478600001)(2616005)(2906002)(81166006)(5660300002)(81156014)(8676002)(8936002)(6512007)(66946007)(6486002)(86362001)(4326008)(66556008)(6916009)(66476007)(66446008)(64756008)(76116006)(91956017)(4744005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3246;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RB6u9CTmaXDgNqq3GSP0RXXX0e/IBBNA5Pawiuq5QAajEjKemvpODi2W0NGfpFHWq8e16Gm73Dje3pXybs1wbq8vL/lgrPNUbA1XMWeabJsqYeLYWf3a2bSQ5z9D7vqQLJ4AuMGnYQVc/LqqI4E2z1KTHwpqNmhD3lbj1duCzEY8LhyNJ57N+BwUMVejN3XstOgEegJzSGHcyoDbUhbEFecyloRxnplt4sUhcO5y4y/SKmzFRDzAQ41mtn5qpFDYAvdrSHY9AorlgSLZeuny1BsHLr1frmlns+spFCU0RTFAJQah/3fIHpsGd+b0iV3kECoRrVyAPCDFx5War2jKqi3JYlaeHjxytt9/sLLJWPPoUsqVOXwMMlIiQMFJHbia++uwgExCTgDbDNh0AzK4IrLQ70DT2U41W82GWB/yF0g7Zxr7ZbmFk11q60WPOx4+
x-ms-exchange-antispam-messagedata: aUEpX/DViNdBrp8CNqTD5GWE53673b1BRJZDHeu/LLt5290iZAMRYmLGpZvTIpWHHEc/ZIdssopHGCtZCPC+D2VXqkRY/d9Y1npsNW/dd4xB2Vd0oOal8IiSuNDQb4lcS1F8shJqA4CFb6Gfd5lt2w==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <24DEF44B3B52064290E6F7CD57EEE01F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54268cd5-a0b9-483b-20a6-08d7c168a271
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2020 00:52:24.1687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JAxXQFdSfOQTQ+yoUfMTaGTvGeqIxdszwuk6U6K2Vrnt1HnYNu6c0D6QQEmrByMNiUApc5hLubFmSFsyjlJDjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3246
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTAzLTA1IGF0IDE1OjU2IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAgNSBNYXIgMjAyMCAxNToxNzozNCAtMDgwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBIaSBEYXZlLA0KPiA+IA0KPiA+IFRoaXMgc2VyaWVzIGludHJvZHVjZXMgc29tZSBm
aXhlcyB0byBtbHg1IGRyaXZlci4NCj4gPiANCj4gPiBQbGVhc2UgcHVsbCBhbmQgbGV0IG1lIGtu
b3cgaWYgdGhlcmUgaXMgYW55IHByb2JsZW0uDQo+ID4gDQo+ID4gRm9yIC1zdGFibGUgdjUuMw0K
PiA+ICAoJ25ldC9tbHg1ZToga1RMUywgRml4IHdyb25nIHZhbHVlIGluIHJlY29yZCB0cmFja2Vy
IGVudW0nKQ0KPiANCj4gQmFjayBwb3J0aW5nIGRlYWQgY29kZSBmZWVscyBraW5kYSB3ZWlyZCA6
Uw0KPiANCg0KWWVzIHRoaXMgb25lIGNhbiBiZSBza2lwcGVkLg0KDQpJIGhhdmUgYW4gYXV0b21h
dGljIHN5c3RlbSB0aGF0IGFscmVhZHkgdHJpZXMgdG8gYmFja3BvcnQgYW5kIHRlc3QgdGhlDQpw
YXRjaCB0byBmaW5kIHRoZSBjb3JyZWN0IC1zdGFibGUgdG8gbWFyaywgYW5kIHRoaXMgdGltZSBJ
IGRpZG4ndA0KZG91YmxlIGNoZWNrIG1hbnVhbGx5IGlmIHRoZSBwYXRjaCBpcyBhY3R1YWxseSBu
ZWVkZWQgdG8gYmUgYmFja3BvcnRlZA0KLi4gbXkgYmFkLg0KDQo+ID4gRm9yIC1zdGFibGUgdjUu
NA0KPiA+ICAoJ25ldC9tbHg1OiBEUiwgRml4IHBvc3RzZW5kIGFjdGlvbnMgd3JpdGUgbGVuZ3Ro
JykNCj4gPiANCj4gPiBGb3IgLXN0YWJsZSB2NS41DQo+ID4gICgnbmV0L21seDVlOiBrVExTLCBG
aXggVENQIHNlcSBvZmYtYnktMSBpc3N1ZSBpbiBUWCByZXN5bmMgZmxvdycpDQo+ID4gICgnbmV0
L21seDVlOiBGaXggZW5kaWFubmVzcyBoYW5kbGluZyBpbiBwZWRpdCBtYXNrJykNCj4gDQo+IEkg
Y2FuIG9ubHkgdHJ1c3QgeW91ciB0ZXN0aW5nIG9uIHRoZSBwZWRpdCBjaGFuZ2UgOikNCj4gDQo+
IFJldmlld2VkLWJ5OiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPg0KDQpUaGFua3Mh
DQoNCg==
