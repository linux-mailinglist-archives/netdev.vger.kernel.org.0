Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D318B17EE43
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgCJBzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:55:04 -0400
Received: from mail-eopbgr00088.outbound.protection.outlook.com ([40.107.0.88]:12772
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726252AbgCJBzD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 21:55:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E4Zu/bjFoWtiNm9WHa/7n2wLzsFqNgsDqEyp7Q/TNWgmvaz7vJbI+vOBoorOQRq4vlkPYAH00qttOW/mqfl/aP7kfIgHNzLWGBqFAHkq8EI6bQIuO97YcDWS98JCO4/CWn1sL5hwbXMQqKK6jsBgnt8iqGSPbeNE8me9dwY0JVQnsN9oXTIN+IFeP2ZkXMuRahawMQ80gX3nAT5C+HiRFe4Uc2mtqrqdzx7V47154ne0NpIPOiPtoPxN8o6MW7/HE+IynB6kdgmKv/I0x/hCq5SMfhaCyIwSA3g+ruKG3LUf6BbTchOygBsILcNA4oKlSd6jSLwmYB2aTQ/nf1l9Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u47ZN4EbAxijii16RbuIkqapNlpmAKWlzA5pvEjz590=;
 b=JqS6SpjIBIlLtoZgdsIYGg9cYFtbVhM0g2VBMXwlIkgSYOa4mzXAwvF7NLf4R2BfnaO116+0J8/SmsDa8ZKaZ/SGj7w1A1vnDsq3628Q79SUW4lFnXzb9AmFuAP5jBJBVq/+71eQ56H/TYkt6OwLmr9nVOf09zct2uEB1fT+MHRiLjxw//UCp0/ooR6xH8bR+dp7aL7EWVwJUd2cDDTXqGenR0TrQmGask8yun+5nS65u78GiZsZON9OVuM3yrFUTigpTbAs7MOT/YUcA+2ItxGuKRLvtAhTiRYhwBpLMNQ2MPzQpjg03A6/PPiqW3HfFjQVIb3McYAMZjonKrwo7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u47ZN4EbAxijii16RbuIkqapNlpmAKWlzA5pvEjz590=;
 b=bxEEuO6GoP5f6Q+k43JRi5S9efxI7Pr3uySN8u6mhW1hKKXucOED+yOE18RYupbiYBQuRPsGkNqNE7zpUux+UWxYl6x0eHUdjDbLQwz5ImZ5QF7paDJxcKH67gZGEGbXlgtN8f4zI4GPQAbDFaYGhWbuKE8bTWwuNeiWk6N1rIE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3136.eurprd05.prod.outlook.com (10.175.244.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 01:54:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 01:54:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        "marcelo.leitner@gmail.com" <marcelo.leitner@gmail.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH net-next ct-offload v2 06/13] net/mlx5: E-Switch,
 Introduce global tables
Thread-Topic: [PATCH net-next ct-offload v2 06/13] net/mlx5: E-Switch,
 Introduce global tables
Thread-Index: AQHV9VNyCdn2FMAmJkyM7c9X1SrvkqhA3L2AgAA2WoA=
Date:   Tue, 10 Mar 2020 01:54:47 +0000
Message-ID: <428981006305a063a196e8b51ab2161b1b1d897c.camel@mellanox.com>
References: <1583676662-15180-1-git-send-email-paulb@mellanox.com>
         <1583676662-15180-7-git-send-email-paulb@mellanox.com>
         <20200309224013.GK2546@localhost.localdomain>
In-Reply-To: <20200309224013.GK2546@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 654a8da1-d6d5-44e5-cfda-08d7c496037b
x-ms-traffictypediagnostic: VI1PR05MB3136:|VI1PR05MB3136:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB31366838471BE6A7EA1261CEBEFF0@VI1PR05MB3136.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(396003)(376002)(136003)(366004)(189003)(199004)(6506007)(86362001)(2906002)(5660300002)(66446008)(478600001)(110136005)(54906003)(316002)(6486002)(66556008)(71200400001)(186003)(8676002)(6512007)(26005)(66946007)(64756008)(81166006)(81156014)(4326008)(2616005)(8936002)(36756003)(76116006)(66476007)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3136;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r9P7CpRBsGMiMGbD++PC3ZG5uXnlLsD6+coqk4viQKvEjRgljBkVczHeLlLcB6LP4Su6RNmTiPNuYEK5X9id1anwObo7+lnXUYg4eHc04HOy/pneMt34OzD4D+Q/10ylWlmVz/KHTMePjLp+ZWtlxDr1B4zxp8+TpnuPJo8YRvmyS1eVst09rFxWm3yrDLPAOU1ARUKK0cDy0cruUf0O3VE97kbv3VjcvSH/oMPqCKmbRfiQxVJJ/+M+kUTNXOLYGpTdc1pIlFCYH5oWfPBSU11EoptY9aK96RAruCyd+w87jkDSzftarkZT7LHLXkj214eGW/dtE2j/uIrSnD1iW833prYLq6NlV86qbmawk9js8cVqhbtFaU/iGzA9KtV0aBphSC70Cizfx70/bAfvHMwuaykL9S0g0hdqVT3PmIx/Rc+p6mQmdK67ONBaOm0+
x-ms-exchange-antispam-messagedata: K/6qqUC5JynYRZQetZ5pxbJ4/9umAUpAj3mATP79mO0U7N2vMQSY8Wiujj2peQoHyzf1fIIyKWqucGobk3ot9cht5kKgGpO4AsMgV+JxRD2ZBTRl85dNRYUPr12wv2PFSWZcQTcQnRxoqwYkYF+TCw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <172E4EB542972A4895FB184A34EFF726@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 654a8da1-d6d5-44e5-cfda-08d7c496037b
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2020 01:54:47.7819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S9d0W+WtPUonErfycx8wFczc08UWv0T9FcUZcPedpjxF3kE/IXuW2YPwFYZTMTHzrhmhg9eTEDsmCM/cDB0FaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTAzLTA5IGF0IDE5OjQwIC0wMzAwLCBNYXJjZWxvIFJpY2FyZG8gTGVpdG5l
ciB3cm90ZToNCj4gT24gU3VuLCBNYXIgMDgsIDIwMjAgYXQgMDQ6MTA6NTVQTSArMDIwMCwgUGF1
bCBCbGFrZXkgd3JvdGU6DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9hZHMuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMNCj4gPiBAQCAtMTQ5LDcg
KzE0OSwxMiBAQCBzdHJ1Y3QgbWx4NV9mbG93X2hhbmRsZSAqDQo+ID4gIAlpZiAoZmxvd19hY3Qu
YWN0aW9uICYgTUxYNV9GTE9XX0NPTlRFWFRfQUNUSU9OX0ZXRF9ERVNUKSB7DQo+ID4gIAkJc3Ry
dWN0IG1seDVfZmxvd190YWJsZSAqZnQ7DQo+ID4gIA0KPiA+IC0JCWlmIChhdHRyLT5mbGFncyAm
IE1MWDVfRVNXX0FUVFJfRkxBR19TTE9XX1BBVEgpIHsNCj4gPiArCQlpZiAoYXR0ci0+ZGVzdF9m
dCkgew0KPiA+ICsJCQlmbG93X2FjdC5mbGFncyB8PSBGTE9XX0FDVF9JR05PUkVfRkxPV19MRVZF
TDsNCj4gPiArCQkJZGVzdFtpXS50eXBlID0NCj4gPiBNTFg1X0ZMT1dfREVTVElOQVRJT05fVFlQ
RV9GTE9XX1RBQkxFOw0KPiA+ICsJCQlkZXN0W2ldLmZ0ID0gYXR0ci0+ZGVzdF9mdDsNCj4gPiAr
CQkJaSsrOw0KPiA+ICsJCX0gZWxzZSBpZiAoYXR0ci0+ZmxhZ3MgJiBNTFg1X0VTV19BVFRSX0ZM
QUdfU0xPV19QQVRIKQ0KPiA+IHsNCj4gPiAgCQkJZmxvd19hY3QuZmxhZ3MgfD0gRkxPV19BQ1Rf
SUdOT1JFX0ZMT1dfTEVWRUw7DQo+ID4gIAkJCWRlc3RbaV0udHlwZSA9DQo+ID4gTUxYNV9GTE9X
X0RFU1RJTkFUSU9OX1RZUEVfRkxPV19UQUJMRTsNCj4gPiAgCQkJZGVzdFtpXS5mdCA9DQo+ID4g
bWx4NV9lc3dfY2hhaW5zX2dldF90Y19lbmRfZnQoZXN3KTsNCj4gPiBAQCAtMjAyLDggKzIwNywx
MSBAQCBzdHJ1Y3QgbWx4NV9mbG93X2hhbmRsZSAqDQo+ID4gIAlpZiAoZmxvd19hY3QuYWN0aW9u
ICYgTUxYNV9GTE9XX0NPTlRFWFRfQUNUSU9OX01PRF9IRFIpDQo+ID4gIAkJZmxvd19hY3QubW9k
aWZ5X2hkciA9IGF0dHItPm1vZGlmeV9oZHI7DQo+ID4gIA0KPiA+IC0JZmRiID0gbWx4NV9lc3df
Y2hhaW5zX2dldF90YWJsZShlc3csIGF0dHItPmNoYWluLCBhdHRyLT5wcmlvLA0KPiA+IC0JCQkJ
CSEhc3BsaXQpOw0KPiA+ICsJaWYgKGF0dHItPmNoYWluIHx8IGF0dHItPnByaW8pDQo+ID4gKwkJ
ZmRiID0gbWx4NV9lc3dfY2hhaW5zX2dldF90YWJsZShlc3csIGF0dHItPmNoYWluLCBhdHRyLQ0K
PiA+ID5wcmlvLA0KPiA+ICsJCQkJCQkhIXNwbGl0KTsNCj4gPiArCWVsc2UNCj4gPiArCQlmZGIg
PSBhdHRyLT5mZGI7DQo+IA0KPiBJJ20gbm90IHN1cmUgaG93IHRoZXNlL21seDUgcGF0Y2hlcyBh
cmUgc3VwcG9zZWQgdG8gcHJvcGFnYXRlIHRvDQo+IG5ldC1uZXh0LCBidXQgQUZBSUNUIGhlcmUg
aXQgY29uZmxpY3RzIHdpdGggDQo+IDk2ZTMyNjg3OGZhNSAoIm5ldC9tbHg1ZTogRXN3aXRjaCwg
VXNlIHBlciB2cG9ydCB0YWJsZXMgZm9yDQo+IG1pcnJvcmluZyIpDQo+IA0KDQpQYXVsLCBhcyB3
ZSBhZ3JlZWQsIHRoaXMgc2hvdWxkIGhhdmUgYmVlbiByZWJhc2VkIG9uIHRvcA0KbGF0ZXN0IG5l
dC1uZXh0ICsgY3Qtb2ZmbG9hZHMgZnJvbQ0KZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L3NhZWVkL2xpbnV4LmdpdA0KDQpQbGVhcyByZWJhc2UgVjMgYW5kIG9u
Y2UgdGhlIHJldmlldyBpcyBkb25lIG9uIHRoaXMgc2VyaWVzLCBpIHdpbGwgYXNrDQpEYXZlIHRv
IHB1bGwgDQpjdC1vZmZsb2FkcyBmcm9tDQpnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvc2FlZWQvbGludXguZ2l0DQoNCndoaWNoIHdhcyBhbHJlYWR5IHJldmll
d2VkIGFuZCBhY2tlZCBvbiBuZXRkZXYgbWFpbGluZyBsaXN0Lg0KDQpUaGFua3MsDQpTYWVlZC4N
Cg0K
