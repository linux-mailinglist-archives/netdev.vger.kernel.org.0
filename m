Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F85D4978FD
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 07:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235749AbiAXGe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 01:34:58 -0500
Received: from mail-eopbgr60047.outbound.protection.outlook.com ([40.107.6.47]:54365
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235740AbiAXGez (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 01:34:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U81R/lZ4r/mt/qjbggzShm2/duTZsqfPSL4oPM+A9d/H9pgpO+JHbSBc5Re3mguISNZ0G9Q+9v9c3Rsf2WaWTuqT+SxNT5S4GttiruzoJFUC2lTbQ7ShOfyDkbBuRigzIO702SXVJshXS/HGMep2bNutDWBy2aJoyO7D+P2vvArUeTADcT9Ulmky+NJXHOfiGsrGqc/TnqZ2q+B/R0KYksl9RBANa/aV9cRTn8RMk81B+kCOb5CIrzRuUtJWVlMYyI6N+XpzF2io0cKotyPROI4kzBf0fyytkZtOyjjRlF6rBqYNuGu9ZvtKwOl1avCLHtnzG5kZ5ohwUZYYI6Wsrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sn/0EZG4S53KTCo6lXJWVvZo09XP0a8kaVksLGdIlzA=;
 b=C5s6hnUIKMqf2MOiXm8l41Ykf0HDiPKW+vzJWUUi/LSan4fA76thBywrlndoH4EsUl/6+/Z9npWpOIGOBIhf6OZIx4DZHIYOoKZD1yXQYW1KrHQRS5bfCBqsWqNpNrwYKSs+kZb1nD3a2OIVwDiiNrOW0BFL8UhZyE3cqQ7jzn2Ald7hZ4VVQfy58kfOPGSqOTrpKfkztMApOZrXygXa4pJwX9/1j1UhqqIaLCj4ZoEGQSBB2xg4Y24YK/dxpd69L2dhXD429Wo9E7wmUSqaxyUe8i4GKl9EPHx6TfdamWcK1v92kWYcq5opjG6lxKYIyOtMRko9kTj3SH//x65pGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sn/0EZG4S53KTCo6lXJWVvZo09XP0a8kaVksLGdIlzA=;
 b=ioiifZExFHKq+mNoi1TaoHcMdR/BCzdN2+gF686u/PotKSRy3iZzFKEK0z0RLOJEazzBr8/SikKMg7lhXkdSwB3coHnccQdxav+Bp+xc/XGvFUoKo70sx9lPsNUkJA/aKD3OYurHXF4NHSH8feeTSi+mDLCG5EPFDDuTn76iy4g=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by PA4PR04MB7712.eurprd04.prod.outlook.com (2603:10a6:102:ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17; Mon, 24 Jan
 2022 06:34:53 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3071:c2e8:c8f5:570e]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3071:c2e8:c8f5:570e%5]) with mapi id 15.20.4909.017; Mon, 24 Jan 2022
 06:34:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Colin Ian King <colin.i.king@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: fec_ptp: remove redundant initialization of variable
 val
Thread-Topic: [PATCH] net: fec_ptp: remove redundant initialization of
 variable val
Thread-Index: AQHYEIn5EmI4pcM+IkiI1fDpgJlgE6xxt4Jg
Date:   Mon, 24 Jan 2022 06:34:53 +0000
Message-ID: <DB8PR04MB67955FA78F866E7B95B33207E65E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20220123184936.113486-1-colin.i.king@gmail.com>
In-Reply-To: <20220123184936.113486-1-colin.i.king@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35292b79-be16-4b3d-f755-08d9df03a13f
x-ms-traffictypediagnostic: PA4PR04MB7712:EE_
x-microsoft-antispam-prvs: <PA4PR04MB771251484BACC4E64AEE472FE65E9@PA4PR04MB7712.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nm5G+s/W8oml6ZVH3cX8a3jyDrWWdUv9MieEAX1tLnQrsPwi9r4EsKUWvv5ng5fOin/uJZ9cK1YFwRlhwN1Iakb8vonCDWZaow0sOgMZy8LhojwLtB/kQuUVn96If2H7fskFOIG42pbKo3eR7U8qi66Grl9KH2X/tCIWRLCMFLivFyC3yBm78cYB0GEqHCxRupnCzE3J/EPe5brXnQ8aN/gK5TNj7wzwWrMCMZC+oV3Yq2iemiY+HGwcSJJ6D4dMzpyKwwoFSHLwG3FVrcQNuEyygv7ap74o0ZYVgN7LhQWcx/kDHDJz1lhUCIrR3mF/jNuH1MY6gKaWvGVY2fPRhjWyXNhquOTQu1bwvp0Rbes91fzJsBukosT6zOzAmyt9D1Vc0M6m9n/n7foEb4L34OXQsQQ8T+eMYbKnXbfSAbkfF2whZ7ISUPZzLM+VT/D+kqUhjubocL4DSqaW+u/s/A1K85zm7kopo+GIUzeFUjAG1+FKn8j5QCBAA7c/fYwHHL7+UebpD939FZxthxt+xuC+nxu42B7uSNp2emTDQKQGYH8eve9SYpOZzEzPSoJtWeBkGW/qp3ws1JzorEcQnbemer1s0wI7osgDGrSusqqVLHaeJo1S6xfl9uV7DvMOTys4MsDynbf4Hi/HADPEJWKBMzrnA+qoG0SHALXTLNcbBTaeJn2r+i0FecqqsU5U5fsSlDMXgDwoa5js8YhZWA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(86362001)(7696005)(316002)(8936002)(9686003)(66946007)(76116006)(54906003)(83380400001)(66556008)(66476007)(53546011)(6506007)(33656002)(71200400001)(64756008)(8676002)(66446008)(26005)(4326008)(55016003)(52536014)(38100700002)(508600001)(110136005)(5660300002)(38070700005)(122000001)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFplQW9Cci9ZZVNybGZvbmZpS0NoNjNRLzRlS2FJcjlyYmtLcVhrUVFUNDVU?=
 =?utf-8?B?V2N2UHRsM2xOQWJyZEJjYWZDcUN6MGVMOFRibkNRbm0ycm13S2syMDAzemVl?=
 =?utf-8?B?VHVkM1AxTlVQdHY5TXV1VmhWRUNLQlc0Q3FhdjUwV0FyaE5BaTZPTVpMUjRS?=
 =?utf-8?B?azd6cnpNREVuMjFITWhWMDdkT3FtV0ljeXBmSExFUW5WdThXY1R1Z3M0Y1B3?=
 =?utf-8?B?ZG9PeWJDNG9oZEMxVDFpeHNBVW1VaklpTldNZmd5clFwdVJOSGFIVUdmZ3Jz?=
 =?utf-8?B?TUZrQ1czVkdwUkZwNkU0WEtOV1J1T1laYm5FRE9NK3R2RUh1QkRubGtySGVv?=
 =?utf-8?B?RG1DUmpQeFZVSlNoV1dRM1hjcEYzSlRWd25uQTArUDljbVJwaGpEbjJTVzR6?=
 =?utf-8?B?dW5zQXlnVEdsQWVDeHZMV0FzM2JCRDlETm5kVnZ1TmdmcjgwNk9HMGdVK1o5?=
 =?utf-8?B?WEJyNkZWVW54cEZPamd5Q0RLcExNNXZ6VFFoaWF5Wnc4MXliUy93ZXFNVVZ6?=
 =?utf-8?B?RnVvTEpNcVhzTTF0b1pRdlo0YmhmN0dnbHpHcVUzdVIxZFNpQlY5d3RXZUlE?=
 =?utf-8?B?enloRWFJenY4ODlUbm1mOFZKN3o1TG5kSUxSR3NaMWxiMXRUZUhqdTZGV2JP?=
 =?utf-8?B?UHl6Q1g5YUlJUmdVbitmUVVlb0plcm1oTTZ6a0JGOGVoTlR4bnZ2NmpZbmJL?=
 =?utf-8?B?SjkvYkVMNzRqOUkvNXBIaHhxeWZBUkR5dU81ZkJFbmJXdkthamdRV0RZWVd1?=
 =?utf-8?B?a2p4WWtNM2hoV2N2TEVMSWNTOXZDRXpRY0sybXo2UXdVbXEvV2V5YmdxLzFn?=
 =?utf-8?B?REdXdW1KRDlmZ3d0ODdYVnNwWVVSN0ZuL1dHQ0RhMHZCWXBqWERvQWJ1d3FC?=
 =?utf-8?B?TWFGQnFXKy9JZUMyRWNYUFdubXlURGdUalpoZmM3TkR4OGdpdUd1RlNVYnZ2?=
 =?utf-8?B?azZmMHA0WTNrVC9IdGJpNEJsQy85Y01xNjg2RVhWdUZWUVFXWFJKM3dFWE5r?=
 =?utf-8?B?R0FCUC9abnVqWWp6bGlyRGdLMGRkQUlRZ1gzS2h5UExXekUzRDBzOUxMVVVp?=
 =?utf-8?B?YlBUTlkxUFlnd3BGckxNRnY3a25kbG8zWDhBNW1JY0sra1BPZHErMzlSaE9U?=
 =?utf-8?B?TFhxOURFOVhMRVI5TEZFc0R0SXVobnovQ2huaVRzR3VpODB1eEFFeklQWWZj?=
 =?utf-8?B?RENYNCsyOHAyOXYvZ1poWXJFWFJMTXhYMWlHMHkzYU5aenpmODJxOFUvMTNF?=
 =?utf-8?B?eVZ2Rjd0MTcwOUw0QTBGSFk0RGJDSTQyVjJTZ296SDUvbUlRYzR0VmN0ZXZi?=
 =?utf-8?B?RXRrZ3RLNUlDaldEWGQzRERvWWRuTEM1WXZyOUNDZERwZyt5QnhLVjhvdUt5?=
 =?utf-8?B?V2k5d2FJdUJ2a3NmRFNRM0x2UjBNekxmVFZ0YnhTZmJZVVQyUWFIcDczMW9Z?=
 =?utf-8?B?eWdIU1BjMTRHVlYwWjA5RlJKSUkwbFYxTXJTbVJ5QXNydzBwdWNGeVZHeUov?=
 =?utf-8?B?VENmUlJFdWFpeGd5dkJWWjBudUE2RldldmoxM2thVUs5Njdvbk1rRzh1amt0?=
 =?utf-8?B?UzhLeWJrb1k0bzBrQTRuSlhtR2pjcHZBcVhON2pqaGhDQWsxV1cxWXdJYWtO?=
 =?utf-8?B?Qmdaa0FYMzZ0cVIwRzM0SHhPd2p6MURhSk1RMkNkYVY1b2JlUkIvSmNyM2RW?=
 =?utf-8?B?WkpRYUI4bE05N1ZiSmQ2QjdhOFlRY0VvS3o1a1lQTFh0NENISzRBU0tCVGNJ?=
 =?utf-8?B?RTd1Qi9XNEwyTDFOK3pDc0phektyc0hNTFY5WVQxbWxkMldZZTJyRGpiT2Fk?=
 =?utf-8?B?ck94ODVoVWZvejBGRU1Ed3dxY1VhZEZQZEpzQ2FQZlk2Y1N2SVB6bmZITWoz?=
 =?utf-8?B?UE8xU1FDdDVSbEdTRWRucWJDZStmS3FwTFordFNWNE1YK0ZuTHQxb25UNWJl?=
 =?utf-8?B?Y215R2RidTBnTkdwN2syallRMDI1SVJNbzk0ZkRvTVBmdmJ5RzFjaEdva21J?=
 =?utf-8?B?L1BWQ21rcFJwUW9hZGRqOENGY2dLQmVEOGI1c1kvVENyNDFQRVZDdzlhSU8w?=
 =?utf-8?B?Q3ArVXdUblorcjNqcStYc1BHRzFxQ3pJY3Y2V0lUZnl2aVdvQVFsMmhIV1Zy?=
 =?utf-8?B?NjVVSWt4d29JU3JnTjMrcW9UdU5xWkYvcFFoRHV6dW5POU90eDNhNVkzYlFK?=
 =?utf-8?B?VVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35292b79-be16-4b3d-f755-08d9df03a13f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2022 06:34:53.1604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y8Na0im3q2xPCpRihH0Qa8u4uCWU0eFxNNcsgsufcKJD0348tNpebQ87P7w9qEAJgvRAq2VQUIfDrUa8BzcWDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7712
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IENvbGluIElhbiBLaW5nIDxj
b2xpbi5pLmtpbmdAZ21haWwuY29tPg0KPiBTZW50OiAyMDIy5bm0MeaciDI05pelIDI6NTANCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBEYXZpZCBTIC4gTWls
bGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVs
Lm9yZz47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGtlcm5lbC1qYW5pdG9yc0B2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDog
W1BBVENIXSBuZXQ6IGZlY19wdHA6IHJlbW92ZSByZWR1bmRhbnQgaW5pdGlhbGl6YXRpb24gb2Yg
dmFyaWFibGUgdmFsDQo+IA0KPiBWYXJpYWJsZSB2YWwgaXMgYmVpbmcgaW5pdGlhbGl6ZWQgd2l0
aCBhIHZhbHVlIHRoYXQgaXMgbmV2ZXIgcmVhZCwgaXQgaXMgYmVpbmcNCj4gcmUtYXNzaWduZWQg
bGF0ZXIuIFRoZSBhc3NpZ25tZW50IGlzIHJlZHVuZGFudCBhbmQgY2FuIGJlIHJlbW92ZWQuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29saW4uaS5raW5nQGdtYWlsLmNv
bT4NCg0KTG9va3MgZ29vZCBmb3IgbWUsIHNvDQoNClJldmlld2VkLWJ5OiBKb2FraW0gWmhhbmcg
PHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcN
Cj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX3B0cC5jIHwgMSAt
DQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfcHRwLmMNCj4gYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9mcmVlc2NhbGUvZmVjX3B0cC5jDQo+IGluZGV4IGFmOTkwMTdhNTQ1My4uN2Q0OWMy
ODIxNWYzIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVj
X3B0cC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfcHRwLmMN
Cj4gQEAgLTEwMSw3ICsxMDEsNiBAQCBzdGF0aWMgaW50IGZlY19wdHBfZW5hYmxlX3BwcyhzdHJ1
Y3QNCj4gZmVjX2VuZXRfcHJpdmF0ZSAqZmVwLCB1aW50IGVuYWJsZSkNCj4gIAl1MzIgdmFsLCB0
ZW1wdmFsOw0KPiAgCXN0cnVjdCB0aW1lc3BlYzY0IHRzOw0KPiAgCXU2NCBuczsNCj4gLQl2YWwg
PSAwOw0KPiANCj4gIAlpZiAoZmVwLT5wcHNfZW5hYmxlID09IGVuYWJsZSkNCj4gIAkJcmV0dXJu
IDA7DQo+IC0tDQo+IDIuMzMuMQ0KDQo=
