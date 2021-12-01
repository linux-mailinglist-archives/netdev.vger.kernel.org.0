Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F7774658F0
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 23:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353467AbhLAWNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 17:13:08 -0500
Received: from mail-eopbgr60102.outbound.protection.outlook.com ([40.107.6.102]:53825
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343722AbhLAWNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 17:13:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RS5euDKEVrBx5WYENkxzHE24uVWYBQ2DeVYuVmPzQdU/diZyIW5GqFTBcmCaVTxil1pfvq+GhqLeOlGbVV/JL/j5jYAHOvbTj5yIjKunq8XJkN4W+bYRbVqx8C8edmKZua08KW+ptByE6d+VraHrcpfn6PBB9iSZJSWB29LNjQ4UdrHL1WTocxkiJhlyjJluyfLGPc9cgNVzJdBreKmcBo2Cm54nBX0kbpxs2aoaQazxckgee661V0R16hd4uMZG0+UGHikrgxF8OQNxWxloPX64JWkc6aKaMRNZFbt3cpjFEg+MdRb/iDQYzt51+puPG1xZlIbwe0GCiq5mPnxWsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lqaOxIGII/WuHsnmSxuGlFEFhdxxSjWe42BFyMORhks=;
 b=UGFUELSmPHbgqNQjRZ3/ExApDrrlmUGSVj5dRU+bLife23tqX7n+fgQrJ2LXQT/UsM5rF5BlKzWcWwFaJQ7JYtA/srCEupecdVZ8x1dmGC4kDucVMs1z2Q10dcTcIgzIDRuQLjecazL26Uq3kekmYr+Z6SNrUbc842qJnp7tYK82MpClkJuxRYJBmsUffJBEZ1DmVltnhSBKPidae3ihpM+44YoqqZcCwmZrpVjTSPcCmyPqLEP4t2RJfZoOTM3iWhGv9StG6P5m824oyfDlZPHR/85J6x54zgxnti6YQgjc6NX06n15iKfUoBMXXwIXjGQ1/CY/k5v0iIYYnmUvhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lqaOxIGII/WuHsnmSxuGlFEFhdxxSjWe42BFyMORhks=;
 b=eif3SfmjJRdAurBlbRmVS6zkBr4SD5TC0nFotC3zzwqbXgPcHqMEmHT41N445NMex9tsvP7WlK6Dagb3LGy9OXufQY6t0L67tyH02m3gatL94ZJXISkx+ksZu5HK+iP8YDG30SmuKC87R5xxD9cEFMzihQafHaLNBbo3rSa/0zQ=
Received: from AM6PR03MB4296.eurprd03.prod.outlook.com (2603:10a6:20b:3::16)
 by AM6PR0302MB3191.eurprd03.prod.outlook.com (2603:10a6:209:19::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.24; Wed, 1 Dec
 2021 22:09:44 +0000
Received: from AM6PR03MB4296.eurprd03.prod.outlook.com
 ([fe80::129:21b5:1484:669d]) by AM6PR03MB4296.eurprd03.prod.outlook.com
 ([fe80::129:21b5:1484:669d%5]) with mapi id 15.20.4734.024; Wed, 1 Dec 2021
 22:09:43 +0000
From:   =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <Stefan.Maetje@esd.eu>
To:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 0/4] can: esd: add support for esd GmbH PCIe/402 CAN
 interface
Thread-Topic: [PATCH v6 0/4] can: esd: add support for esd GmbH PCIe/402 CAN
 interface
Thread-Index: AQHX5wAkICfeFtPuKk6B9pq4Q17ihA==
Date:   Wed, 1 Dec 2021 22:09:43 +0000
Message-ID: <c650cf14619a583185c5250a0e7db2bc3c54b0ab.camel@esd.eu>
References: <20211201220328.3079270-1-stefan.maetje@esd.eu>
In-Reply-To: <20211201220328.3079270-1-stefan.maetje@esd.eu>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5-1.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9d34f7c-f748-4f52-572e-08d9b517478a
x-ms-traffictypediagnostic: AM6PR0302MB3191:
x-microsoft-antispam-prvs: <AM6PR0302MB31915B8C902F47204B25CFD281689@AM6PR0302MB3191.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FArpUWl+0DhWh/k4FdLOK8Kr6aVXUoDjbOP3nu9a69S//dHTiea5DQ2j5nqdHwJGGVNE4ws+6TZ20JX+6xqBNtaliKKpKoAxKs7hz57HEikxuZiUyKU0+hlZEy5NDPUkRoU2NwJPDruMjnVCqogDD//FjaAe1U86V9UGNMjK2gt0DSkS0lv8HWULOZ4cI9Xwn3/0HWhHsAVZ6Yq1CQBFBTWmiO4oqAa6pnlRxgftkmuBatnpCTnU2ANa1GGoLoA4tr6YRcy76U/02FMDHWcMeRPd19q66dErQ2df7c8uA6SgBc+WSuvDibFXSHSoqeGNLkEzA+2F1WTdY8yryveq2tiqG7DvMsQbndWFrZadJX1AFGecGSpWrCS5Gt60lc+PlUbx4baTkzG9uGs6aHfe1lzy8BiYhxyHuMj8ypDifvq22p7LoBN6/OuiIOXloxJsaVjCDPhKjhYtKDlVQmuHt/CF8laA4cK0t9ZhBsqeMWBtZjXvKNdpXmd5/H01/nUkuXU9ZVQMBl2sylWpU251mqqKE/Q51V09LqPPmHGILck/EvGP1BWHzDA2/bNFrFYzY8uNbSEvhiiVoObXnFudmXySmN+uR4ESYbM+CTCq8WQH/nXYFG2J7jZetZnEiCYiJcVyyiNfOVmFyGKY3CUpHLQNBj/52GwLmykpvag+/ZR+HQKo4b3GiJsOg7jJqfFGEcbQGCfInQ55iN1rbgL8O6TnvDaMlfty2GmRzhnVULSqux6dLVv8amTtnVxvD/hi3f6B/PuGOGTx3MvP+IeNkjZM3/zYh1h2IU0U1qusYdi7SwwP6qcw0UcIneODiZjwV76E58OX0LHP2Rx7xqjP5g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB4296.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39840400004)(136003)(376002)(396003)(366004)(85202003)(38070700005)(86362001)(122000001)(38100700002)(110136005)(36756003)(8936002)(2906002)(71200400001)(83380400001)(8676002)(4326008)(85182001)(508600001)(66574015)(966005)(316002)(2616005)(6512007)(54906003)(76116006)(186003)(6486002)(64756008)(66446008)(66556008)(66946007)(66476007)(6506007)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGtCUEJYK3NnK0RwMXE2VVY2L1hTeGwvcDVhTm94NlBLZ280UDQzT0JrWXNQ?=
 =?utf-8?B?ZzBwcFFza2pOeERtazJ6OWU3cFZOb09jazdxTzMyQ2dHbkd0eE91Q3NtVGRs?=
 =?utf-8?B?UW5CRHpCNDV6a29IYVZ4UHM0U2ZIcnYrYUQ2bGVXOWJqc2xKbStnTFBQN3RS?=
 =?utf-8?B?c1hKVVp5Sm8wYXZyTEo1eDROcDFwT0VuMkpWb2tHVERqcGl1QjdBbGl6eWF6?=
 =?utf-8?B?KzdRNzZtVjl1RHVZOGt1eEMzTHljSW8yRU92bUJhQWRBODAwdlF2R1B5Nm9a?=
 =?utf-8?B?N0NLRFdKOHVINnBsOUJ3MGJJSzhGeUw0VzMvb1N6ekRUSUsyUUhNVllZcHlP?=
 =?utf-8?B?YzFOb2U3QnRCQWJVUVprNmM1RGoreUpPVEdOY1o5ZU8zQjk5a0J0ZElocUFa?=
 =?utf-8?B?ZDM0WlFiT2pLWDRZUFBYUzk1cWhVYldKQ285OVdVejVJT2txZHA2ZUNzQXNW?=
 =?utf-8?B?TVF4TjRPZlUwVEhJb3EwZUNTd3h3U3Q3a3hDbUxtbi9vRFRWSW9wYkhGMkdy?=
 =?utf-8?B?aFRiMDU3RmNBTVRydUdxV0JhUGh3WjdBb3JlSitWOWFHNGdNeXdkN3Q1VFdo?=
 =?utf-8?B?ZnRLQTMxcUxnSnV4eFlNZThvemFYck5qSy9MVEJ5bmVmZ0gvQUswTEVpaUJk?=
 =?utf-8?B?dDZ5dUpLWWxWRzM4dEROOWlnVDVpQ1hTVUVjL1ZEOGVvNlFLV2V1VEdRMEVD?=
 =?utf-8?B?SG5sZDRZKzBlcW0vVTh2bmY0R0xjaWhtR1MyVGRRRXNKTnlEQkN6WUFjakM3?=
 =?utf-8?B?UDRkNEt6bjU4cVM5c1RUS3I4WjFhMHNRbFVwVjFSUTQ3aGVZR2hHaTg5RklC?=
 =?utf-8?B?ZmEyUU9JR2t2M0g0Vi81d0ZiWDNRUnV0RjJzUERuRW9neS9rYk5STmQ4UzhD?=
 =?utf-8?B?Z3NYeHJKRGNHWnhBellUb1pWNCt6MFBHb3BhOFVBY203SDlZSjBDVGwraG1y?=
 =?utf-8?B?U0dCYTM0T2phdFdUYUFnVkR4TVczWWVkVzF6MGFvd1dDMnQxU1U2VVlDOHA0?=
 =?utf-8?B?WUZBc1NrNDV0TUJ5WXl1eUwzcDUwWGIwcjBIZWVZcXlqeVdvemVSdmxQalVN?=
 =?utf-8?B?c1hCaFRCT1ZqQzNINmZkeXd4YlRDb1BibFRQVER0MnhIVHpsUGg3bWdTNm11?=
 =?utf-8?B?QjdPMnE4dS8xbG5MSFVTUC95RGlTcHF1blhjSGJNbEVWaUEzRmxwYWFsRmZ2?=
 =?utf-8?B?T3k4UEloTDIrSXV3Ym94TWM1OTVhbGpySCtmWkJWdUNtdFhHQThYS1pmNmdu?=
 =?utf-8?B?SUhhOVFGcXRDQVpWKzhDb3N5NHNwL240K2dJNm8yZjRtNEh2ZzhLUFZvYmRZ?=
 =?utf-8?B?ZWRFdWVKWkpPSXNzT0JRS0lSaWtYUFI2NjMzSEh3SlRRNUEwN2JZQXZ4aDRV?=
 =?utf-8?B?clhiWkFKRi9lc3Y5TDU5dFFLWU4xSGdjNnY0ZkVlaEtDUDlvUDdhdERYQ1ZF?=
 =?utf-8?B?UlFuZVdUZVJZb1lvN29uMGNOYVRqS1BCUGFYT2QvZ2JHSGtLdEl5Vm5udWdS?=
 =?utf-8?B?UFphbCtDeFNMaEc1NWl5c2liNFZNZkxVQjY1UnhmSjdzQXpWOWZSODYvd3l0?=
 =?utf-8?B?Z2wwNGl4Vnc3SFVRckI0TURNME03clBGa2o4d2lkcHRnU0xtMWZWQldwamlo?=
 =?utf-8?B?bUxXanJPL0tLcGY3S1I4QTVNSW5MNnRJV0gyejFINzJKYmlCd2NaSnFBTlRE?=
 =?utf-8?B?d1AxZlVyM1ZxWXd3TStWR0V1SlluMWFySjNnUDJ6TmlCQ1lyRnhwUURWUlJI?=
 =?utf-8?B?MDg2b0s0Y3pwemlqdll0U1FBNEp3eENxU0dEa0FpRTRNR2tQWVVWaVhmR3lt?=
 =?utf-8?B?T1FjSi9jem9hcDJNaHQvVDV4TjUvWjRiYkFNZGtSbkhoeEJqNTFYMkNTNDlt?=
 =?utf-8?B?ZmF1dTJVc1Rab3BQeFJmRXpHRU5sOUxMYThZc1VwVkJuc1JoWUtxbGJnbXZZ?=
 =?utf-8?B?eGJvM3FYK0NtUWJ1UjlVR2RtN2tPZWEza3Z3UWRoQ2o4K0VUZEZKVk8wVlA1?=
 =?utf-8?B?VUhndEgwUk52R3p0UG9acGVwUUpsRzloUWlVWVhUNzB6ZFZYLzRtTXdYdXI5?=
 =?utf-8?B?cXBUNkNvY0c4d1NLVXBSKzY3b016Nk1YV0VOeWFzMkRQTlNidFJKZW1TM3Z0?=
 =?utf-8?B?U3VIK0tWcERsQ2NGemQzcTVERWpzOHdIeUQ5WnlUMUhwY3lLSmtNMGsrNG5I?=
 =?utf-8?B?SGhLRG9lZXlld1psZ2dJM1ZMNHhXVmd1eFBIekhLdFJ2YnVXVXlTaWdyUjlD?=
 =?utf-8?Q?4KInTsW4V8JiGrBLutWLGI6y42MHrwbpjEJTKl+vgo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <55DFB500B72EA048BE0188935466C816@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB4296.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9d34f7c-f748-4f52-572e-08d9b517478a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Dec 2021 22:09:43.7630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /586ETChVgjCRp2u3cutlewPvXQETcU0scNsd0nVL61bgnj9ZgFRGTU5yYw+cjJsi7LpFURkBBVii9oosFCW3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0302MB3191
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNCnRoaXMgaXMgcmVhbGx5IHBhdGNoIHY2LiBNaXNzZWQgdG8gY2hhbmdlIHRoZSBlbWFp
bCBzdWJqZWN0LiBNeSBiYWQuDQoNCkJlc3QgcmVnYXJkcywNCiAgICBTdGVmYW4gTcOkdGplDQoN
CkFtIE1pdHR3b2NoLCBkZW4gMDEuMTIuMjAyMSwgMjM6MDMgKzAxMDAgc2NocmllYiBTdGVmYW4g
TcOkdGplOg0KPiBUaGUgcHVycG9zZSBvZiB0aGlzIHBhdGNoIGlzIHRvIGludHJvZHVjZSBhIG5l
dyBDQU4gZHJpdmVyIHRvIHN1cHBvcnQNCj4gdGhlIGVzZCBHbWJIIDQwMiBmYW1pbHkgb2YgQ0FO
IGludGVyZmFjZSBib2FyZHMuIFRoZSBoYXJkd2FyZSBkZXNpZ24NCj4gaXMgYmFzZWQgb24gYSBD
QU4gY29udHJvbGxlciBpbXBsZW1lbnRlZCBpbiBhIEZQR0EgYXR0YWNoZWQgdG8gYQ0KPiBQQ0ll
IGxpbmsuDQo+IA0KPiBNb3JlIGluZm9ybWF0aW9uIG9uIHRoZXNlIGJvYXJkcyBjYW4gYmUgZm91
bmQgZm9sbG93aW5nIHRoZSBsaW5rcw0KPiBpbmNsdWRlZCBpbiB0aGUgY29tbWl0IG1lc3NhZ2Uu
DQo+IA0KPiBUaGlzIHBhdGNoIHN1cHBvcnRzIGFsbCBib2FyZHMgYnV0IHdpbGwgb3BlcmF0ZSB0
aGUgQ0FOLUZEIGNhcGFibGUNCj4gYm9hcmRzIG9ubHkgaW4gQ2xhc3NpYy1DQU4gbW9kZS4gVGhl
IENBTi1GRCBzdXBwb3J0IHdpbGwgYmUgYWRkZWQNCj4gd2hlbiB0aGUgaW5pdGlhbCBwYXRjaCBo
YXMgc3RhYmlsaXplZC4NCj4gDQo+IFRoZSBwYXRjaCBpcyByZXVzZXMgdGhlIHByZXZpb3VzIHdv
cmsgb2YgbXkgZm9ybWVyIGNvbGxlYWd1ZToNCj4gTGluazogDQo+IGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL2xpbnV4LWNhbi8xNDI2NTkyMzA4LTIzODE3LTEtZ2l0LXNlbmQtZW1haWwtdGhvbWFz
LmtvZXJwZXJAZXNkLmV1Lw0KPiANCj4gKk5vdGUqOiBzY3JpcHRzL2NoZWNrcGF0Y2gucGwgc3Rp
bGwgZW1pdHMgdGhlIGZvbGxvd2luZyB3YXJuaW5nczoNCj4gICAtIGVzZF80MDJfcGNpLWNvcmUu
YzoyNzA6IFBvc3NpYmxlIHVubmVjZXNzYXJ5ICdvdXQgb2YgbWVtb3J5JyBtZXNzYWdlDQo+ICAg
ICBUaGlzIGVycm9yIG1lc3NhZ2UgaXMgdGhlcmUgdG8gdGVsbCB0aGUgdXNlciB0aGF0IHRoZSBE
TUEgYWxsb2NhdGlvbg0KPiAgICAgZmFpbGVkIGFuZCBub3QgYW4gYWxsb2NhdGlvbiBmb3Igbm9y
bWFsIGtlcm5lbCBtZW1vcnkuDQo+ICAgLSBlc2RhY2MuaDoyNTU6IFRoZSBpcnFfY250IHBvaW50
ZXIgaXMgc3RpbGwgZGVjbGFyZWQgdm9sYXRpbGUgYW5kDQo+ICAgICB0aGlzIGhhcyBhIHJlYXNv
biBhbmQgaXMgZXhwbGFpbmVkIGluIGRldGFpbCBpbiB0aGUgaGVhZGVyDQo+ICAgICByZWZlcmVu
Y2luZyB0aGUgZXhjZXB0aW9uIG5vdGVkIGluIHZvbGF0aWxlLWNvbnNpZGVyZWQtaGFybWZ1bC5y
c3QuDQo+IA0KPiBUaGUgcGF0Y2ggaXMgYmFzZWQgb24gdGhlIGxpbnV4LWNhbi1uZXh0IHRlc3Rp
bmcgYnJhbmNoLg0KPiANCj4gQ2hhbmdlcyBpbiB2NjoNCj4gICAtIEZpeGVkIHRoZSBzdGF0aXN0
aWMgaGFuZGxpbmcgb2YgUlggb3ZlcnJ1biBlcnJvcnMgYW5kIGluY3JlYXNlIA0KPiAgICAgbmV0
X2RldmljZV9zdGF0czo6cnhfZXJyb3JzIGluc3RlYWQgb2YgbmV0X2RldmljZV9zdGF0czo6cnhf
ZHJvcHBlZC4NCj4gICAtIEFkZGVkIGEgcGF0Y2ggdG8gbm90IGluY3JlYXNlIHJ4IHN0YXRpc3Rp
Y3Mgd2hlbiBnZW5lcmF0aW5nIGEgQ0FODQo+ICAgICByeCBlcnJvciBtZXNzYWdlIGZyYW1lIGFz
IHN1Z2dlc3RlZCBvbiB0aGUgbGludXgtY2FuIGxpc3QuDQo+ICAgLSBBZGRlZCBhIHBhdGNoIHRv
IG5vdCBub3QgaW5jcmVhc2UgcnhfYnl0ZXMgc3RhdGlzdGljcyBmb3IgUlRSIGZyYW1lcw0KPiAg
ICAgYXMgc3VnZ2VzdGVkIG9uIHRoZSBsaW51eC1jYW4gbGlzdC4NCj4gDQo+ICAgICBUaGUgbGFz
dCB0d28gcGF0Y2hlcyBjaGFuZ2UgdGhlIHN0YXRpc3RpY3MgaGFuZGxpbmcgZnJvbSB0aGUgcHJl
dmlvdXMNCj4gICAgIHN0eWxlIHVzZWQgaW4gb3RoZXIgZHJpdmVycyB0byB0aGUgbmV3bHkgc3Vn
Z2VzdGVkIG9uZS4NCj4gDQo=
