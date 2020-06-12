Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0CD1F7E5B
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 23:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgFLVUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 17:20:30 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:36209
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726290AbgFLVU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Jun 2020 17:20:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ImgG3ZfsKDWCJWUHZ0/ch2SGQrMuR07SW/XgIQS0AVfuFJspzxs3e3x36BPn4ZlWpfLjN/VF8xDv4ivL1yNtYfR2GjdsGwaASXx1XlDW0Qj45r1BPDlHDgvnvcOE05jqiTdEh9iTQZSyUlAG8xTyOLh2eN5f0w+BGZPScqu+tPfWPsAbAukARRHCfoR3qr/SdETaoZAZrRnqSxHQysBekdHsWRxNViz2YbyqLyxf1X3JWa73leh+x1PAV8ADf+4ylY2xO3gF/0kx3iGVYYi0KfWZ+Ybnw7AuDuP+GQyYuIQ04SV+COa7ukM+ZB7OYv7BXavv5rLr+G/4OFDRZWEjMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+0soPW05JvdQNxQitAW4MMMV19OUVGv403Pphqiqh0=;
 b=GK+eH+CmLfya8rE5Oh+sHcru3kG0NqnmujPqYaNjy9BsaeoPGbhZ9EtvDtIYSO9Pd8MBbEybHJkOJHfkjt7sgo7TevzlUh12lCIOivOJdOyhEs9HGWIZuvxLWZl00ReUfsZ33zNj7bVJkc2j063N1hzcxKtiioZA3XR3Ed++fCOpzWius9HADEvQm8NLYl/1lee/wZacK0Oe3LHa39gnh00aEezFWebag/RsmgDVokk33HWDNZlBHOlL6IuLpRLWyCf8C5n1I0m5/FMhTPRY3voLFVz3lLiSnOdzOjDfAfHdzIaaxvGikb+tEOl9TXeCjpKZIPMrZtdzWaIIQwyW7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+0soPW05JvdQNxQitAW4MMMV19OUVGv403Pphqiqh0=;
 b=XOLd6rKWdkH7pguCsR6FelghXckVk52wmQTTti/ZUY5YIbZZ9IrvceYPZFiSYqT1LR6KSTONEo5m7wpi8QEq5P5ge1RvwtYGT7EQ205p/bcyBWT0Y2H64G3cyxzokXk70N/POv6R1s3Jbr69HttozUSW2oNrRew4Mu7P9EIxjGo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7054.eurprd05.prod.outlook.com (2603:10a6:800:181::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19; Fri, 12 Jun
 2020 21:20:25 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3088.021; Fri, 12 Jun 2020
 21:20:25 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net 00/10] mlx5 fixes 2020-06-11
Thread-Topic: [pull request][net 00/10] mlx5 fixes 2020-06-11
Thread-Index: AQHWQEJNKuFfaiTr1EW8ILyP9IMA8qjUL58AgAFObYA=
Date:   Fri, 12 Jun 2020 21:20:25 +0000
Message-ID: <5b75e88f124d1afc1f6aec9f4270eef5b3c02515.camel@mellanox.com>
References: <20200611224708.235014-1-saeedm@mellanox.com>
         <20200611.182326.1387553567386071693.davem@davemloft.net>
In-Reply-To: <20200611.182326.1387553567386071693.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1aa51f86-a933-4f3e-405b-08d80f166c92
x-ms-traffictypediagnostic: VI1PR05MB7054:
x-microsoft-antispam-prvs: <VI1PR05MB705409D079409F1B5C552417BE810@VI1PR05MB7054.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0432A04947
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KimeWikPyIFwIpFQtaPeB/U2dg//lCZh8b+ykATaIGbR4WbcDBqZPPpVkI8qxeE1YZ3Xz1z3fHkYnJsK+SfAX7O8uTfHvhv2ZhSpPu3FUe3SXa3pTo/vspv30ry9+nVaWiP9yW2EdVf5q7kd3Lfd+mZ7u3VPsL40Z06oZ4SQnp2IRM68qf5LRYfo3ENtYYxGb/NGEso8qNCYdJj3azgM2hC41ewjDTJJVA4NnZhKf2O1ymMghQbACHtnJD+JKK5hkiWIbdBRr+CggsTrg35Mw8VWAnWq0CqQcDeaayGdDm0Udz1TeUsjKyx6y9wwOL0zK523wfIKMxRAVc2nyhTwFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(186003)(478600001)(66476007)(4744005)(8936002)(4326008)(6486002)(91956017)(86362001)(76116006)(5660300002)(64756008)(2906002)(66946007)(8676002)(66556008)(66446008)(6916009)(2616005)(316002)(71200400001)(6512007)(26005)(6506007)(54906003)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: vs+qIU/LqASiyC6ck+HY934xtsHeWSxxr3b/FCmjAq/GJwD4wcnVtMZM2fdxbqi37fUlSzn5BcRvHtBnM29SGyHmb88eAPLk7HYYtHT9AhpoJw9KibbyMKu320fxmnjQhIJyQbxTuwM9FphRQURaS7IySE86RO52aQt/0omo/4EEidV1hN7zDP/KTNBfaD1qHSVekjj9mlDUn4TpnG/ZvJ0EcMAy5enLfUC8pgyVb7kOMvc1y8At4xZG7XtCHQcl5o+MlMJfvCN1aKknoBHc8dkxEWnhJZYv80Ijf/gJJkvbca5Y4JreTA0XWmaBJeYjO6w+852LqJ3JY88SpyAC8up0VjuWJ8pii5jV9qjR/yMO+xXRxhXof4phtXk7tI9e7SCLAdAjNq5S6kl8VIB29/C0LEurEnZ9O3Z6wEKVG8QBZ/2M3vfgN5Vuwmfb9CR+BejYOrSeLZsunHHHIOhkVfHVXHcQpGDkNyoyLfkP5c0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <91302D15169365408631B4DA9C3F80B6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa51f86-a933-4f3e-405b-08d80f166c92
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2020 21:20:25.6157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NMrsjpaMfQtp0Z0jna07kikA14INuDCdd7nBUvRDSSaTuGtXKlTAiFTlVAQy1eytFbLiHTGhA6QM3OpMD8T5CA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7054
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIwLTA2LTExIGF0IDE4OjIzIC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiBEYXRlOiBUaHUs
IDExIEp1biAyMDIwIDE1OjQ2OjU4IC0wNzAwDQo+IA0KPiA+IFRoaXMgc2VyaWVzIGludHJvZHVj
ZXMgc29tZSBmaXhlcyB0byBtbHg1IGRyaXZlci4NCj4gPiBGb3IgbW9yZSBpbmZvcm1hdGlvbiBw
bGVhc2Ugc2VlIHRhZyBsb2cgYmVsb3cuDQo+IA0KPiBUYWcgbG9nIGlzIGJhc2ljYWxseSBlbXB0
eSA6LSkNCg0KU29ycnksIEkgd2lsbCBtYWtlIHN1cmUgdG8gZHJvcCB0aGlzIGxpbmUgb3IgYWRk
IHNvbWUgbG9nIG5leHQgdGltZSA6KS4NCg0KPiANCj4gPiBQbGVhc2UgcHVsbCBhbmQgbGV0IG1l
IGtub3cgaWYgdGhlcmUgaXMgYW55IHByb2JsZW0uDQo+IA0KPiBQdWxsZWQuDQo+IA0KPiA+IEZv
ciAtc3RhYmxlIHY1LjINCj4gPiAgICgnbmV0L21seDU6IGRyYWluIGhlYWx0aCB3b3JrcXVldWUg
aW4gY2FzZSBvZiBkcml2ZXIgbG9hZCBlcnJvcicpDQo+ID4gDQo+ID4gRm9yIC1zdGFibGUgdjUu
Mw0KPiA+ICAgKCduZXQvbWx4NWU6IEZpeCByZXBlYXRlZCBYU0sgdXNhZ2Ugb24gb25lIGNoYW5u
ZWwnKQ0KPiA+ICAgKCduZXQvbWx4NTogRml4IGZhdGFsIGVycm9yIGhhbmRsaW5nIGR1cmluZyBk
ZXZpY2UgbG9hZCcpDQo+ID4gDQo+ID4gRm9yIC1zdGFibGUgdjUuNQ0KPiA+ICAoJ25ldC9tbHg1
OiBEaXNhYmxlIHJlbG9hZCB3aGlsZSByZW1vdmluZyB0aGUgZGV2aWNlJykNCj4gPiANCj4gPiBG
b3IgLXN0YWJsZSB2NS43DQo+ID4gICAoJ25ldC9tbHg1ZTogQ1Q6IEZpeCBpcHY2IG5hdCBoZWFk
ZXIgcmV3cml0ZSBhY3Rpb25zJykNCj4gDQo+IFF1ZXVlZCB1cCwgdGhhbmtzLg0K
