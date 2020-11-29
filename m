Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A10832C7A1A
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 17:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgK2Qvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 11:51:45 -0500
Received: from mail-bn7nam10on2095.outbound.protection.outlook.com ([40.107.92.95]:44769
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727482AbgK2Qvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 11:51:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRfwFAwpsU0f86FiwifJkafOMcWLpO8ld0wQMpHnC0+lJ01rZxOFtnT2Qph6ndBDtspLGMVWI4zo+YFTvWkD798dx2tmgDmb0vQbqGcfNsL//64wQIOsW4+M+ESEdmBIaO02uyhDsQWfCUXSlWA0Li7XMKeJZLAvEprG031VKsrVC/HZeasycL42S0PAzMXlmaWRzfP4xhGfzlxt6vPsGXUMnEYefR5JtYBlzAsXCZGINL3Olv/Roq7D6/sZfTTAujmEyr6bU6Uo6NyIxMU7JPiX4NSsq6li0AT/1oqVayHMZwixCyQkjjd8SrWjdix6kSR2js2nr1urInbrt9abjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWtis63TCfkqaHiFBWny71gEsCliicOqRloWKuAfYao=;
 b=dnp11EW5onrJ64NWC0Rftn6IURchSnSBm2HCkHrpbR6E8QSjB3hSbRu/4IE1JRTqSh5bWF7r04OJ2RJ4c9WusAb2NR7teOg/6X7ADXnwDspUSnBE6ArCtiUAxLnR/ywdJHeOxxeFaNyIYgJBVVBPDgT4LWgP3Dc+zTkhO4z5Su5JnE+ZuhzbEhnLpYUtmxF5jZJmjFVv+rMyNY7KdCFbRQPvggg1MBlOEfIDrwJhIUvB9RH3Iyhds7Xzy1r3TKs1djN4O0qYh5LvmxmAzC5lM57qaNjmvlOb6s6O+6H2Z/jgThUgceRbKVok9FIFJgJ5bSVwMGm6n4FE5+VMkzP4IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hammerspace.com; dmarc=pass action=none
 header.from=hammerspace.com; dkim=pass header.d=hammerspace.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hammerspace.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWtis63TCfkqaHiFBWny71gEsCliicOqRloWKuAfYao=;
 b=ZFfk9SjfeduuLloYHPonyC0AK1yRlUMiPZim3MNO0IzE1OLXOdkMjVwNCGeh0w+kObGUSiLmRmgvyHInDyjUnsBZFIZjWEN39st1TQkH5npmQYul0hY4shylncLzxFiHkHAp+gQh4XNdbbva0jXEUV1AOr6rRgsRwU8fUhbmaBE=
Received: from MN2PR13MB3957.namprd13.prod.outlook.com (2603:10b6:208:263::11)
 by MN2PR13MB2927.namprd13.prod.outlook.com (2603:10b6:208:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.6; Sun, 29 Nov
 2020 16:50:51 +0000
Received: from MN2PR13MB3957.namprd13.prod.outlook.com
 ([fe80::e989:f666:131a:e210]) by MN2PR13MB3957.namprd13.prod.outlook.com
 ([fe80::e989:f666:131a:e210%9]) with mapi id 15.20.3632.016; Sun, 29 Nov 2020
 16:50:51 +0000
From:   Trond Myklebust <trondmy@hammerspace.com>
To:     "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "trix@redhat.com" <trix@redhat.com>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>
CC:     "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NFS: remove trailing semicolon in macro definition
Thread-Topic: [PATCH] NFS: remove trailing semicolon in macro definition
Thread-Index: AQHWxPWbldOlJ73hwU20MDIpyx86PanfU2iAgAACPQA=
Date:   Sun, 29 Nov 2020 16:50:50 +0000
Message-ID: <110444322a9c301c520c1e57e9a6f02b29ad25c1.camel@hammerspace.com>
References: <20201127194325.2881566-1-trix@redhat.com>
         <96657eff83195fba1762cb046b3f15d337e5daad.camel@hammerspace.com>
In-Reply-To: <96657eff83195fba1762cb046b3f15d337e5daad.camel@hammerspace.com>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: fieldses.org; dkim=none (message not signed)
 header.d=none;fieldses.org; dmarc=none action=none
 header.from=hammerspace.com;
x-originating-ip: [68.36.133.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78e3e365-4c21-43a3-4c71-08d89486edef
x-ms-traffictypediagnostic: MN2PR13MB2927:
x-microsoft-antispam-prvs: <MN2PR13MB2927A66953CD6C19105595F7B8F60@MN2PR13MB2927.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SZ1tkNY9qUl4sCzDl3fHzCzVjASWQBOBPqQLAFh15cVwo4EqNxNPCyOZHCvuV3BS82+FVsNfHifRNxEY8xWi3qpFaoqGNJT73fuTxjeEAFUyXIqMRsOkvXn7fjvY99CT65q/EN+Y1grin5YH/i5Pm02bOADWDmgB4M6AI7S7yKaejSSkXjz1bh82biUivbrEdzLDiKuISaF/w2a7sKQSYTIYvzfW62Jdb5Afyc9/KhcyP43lb5XFsL2mH7hBQ6dA0Cx+KUYEnQ0GULDJa4mENQCEOZJvwLW/zxK29gg/C5t5M0EWi/6B4XTZzCRE3Jpo2jEut+JceNUipK5PuKCWCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR13MB3957.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39830400003)(136003)(346002)(376002)(396003)(4001150100001)(64756008)(6506007)(66946007)(478600001)(66446008)(66476007)(6486002)(2616005)(66556008)(91956017)(6512007)(76116006)(8936002)(5660300002)(26005)(186003)(4326008)(36756003)(71200400001)(2906002)(54906003)(8676002)(110136005)(316002)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?R2JYdE9hbEJxN2FYWmQrQ0pUT2FTUHVXUFRRQjBUL3doSVFpV2dSQW85RVp4?=
 =?utf-8?B?UWRFZWhGRlVReWVLOGlXYllCcVhUN2JhblZCVS9SMnRxVE9lNWhuWXBXRGJ5?=
 =?utf-8?B?NSsyVmd2SDAzMFR0a3l5QkVRQmhGSTJyVWlOeGhxNmFUbFN3TE5VNG9rbGZZ?=
 =?utf-8?B?dW9RMFEzTlFvQkp5UXJEVHJxeDE1bFNZQnovQ3VNYXVJaDgzNnBsMmoyVlRB?=
 =?utf-8?B?Y1N0WnR3YzQ2L0pCZ1MvanJOaUJMUnd0QzJjcXFPSlpZM1JlY3ZuOVZLdkZN?=
 =?utf-8?B?Ym5SbkxDeUdlYnd0MGlPS1VWQ1FncDlXM0QrQ3RQK0lndEExaXpLUEVGUFlV?=
 =?utf-8?B?bnN5Z3VuSGVHRCt1aWlxcnN1VnVjamdkM2NJVjV4UW1tVVFHdGVDQ0dma0ZS?=
 =?utf-8?B?ajhwSkc0TVBKM01xejlIeWdQNnRaRWdyQUpuSzRKcitCaUw3Qmh5Rjg3VXZT?=
 =?utf-8?B?bzBZbXRpRzlVSEp4S2FjMzRhazU3cWZOc0JaZUF2Ui8zMm9xUCt5V2ExSVEv?=
 =?utf-8?B?cW1pRGRLengrZ1VBZWpld3R2NHUxdjFuT2RFeEdpdW5vU0JoVEtBR29YQXJh?=
 =?utf-8?B?WE16V0pUd1htMUNuMmVYc2RNNHJOY3hoUllQazc2SUZSSmxTRURpVTVuV2FU?=
 =?utf-8?B?M0VKVGxqK2U4eUJCOEh2K2lTcVlGTGpJbkhJaVFwdUI2VkRtY0pmL0xCNVRJ?=
 =?utf-8?B?aHVkRDlCTk1jUllBSERlNXYyN2dNNDBpWmlUV21kOGszTHBiVGNDZnphaWJY?=
 =?utf-8?B?TGFoeGNoL0N0ZEFseHNXek5ndnpaMjhldy9tbmpQb29mUXFOOSsyOGcvTy94?=
 =?utf-8?B?N1B5YXhDS1ZtVGxDd2dKd2xFcENRZnRJVDMybmlocldtb1R3T1RuTHhveVRT?=
 =?utf-8?B?TEQrVWJIVnVERXBPODRKNkRpZ25LcEZzL0ZVU1hoYVJyV01HczRNaGNZbWFw?=
 =?utf-8?B?cVdBUXR5YVhzT1VBemQ1OS9ucjg0TzBIZGd1K2ZRNllpY2ZQL0VYVTUwWUFF?=
 =?utf-8?B?RmRNZ2lYdU5NczdndThRRGFMQWwydmxOYmJvT3NXeUJSYi8yeXVzYUZIYU44?=
 =?utf-8?B?UVpQWUxheXE1ZGFYRWJYMTZBa2xJWUxTNy9oUlN3eWdSV25EcEViWng0bFRF?=
 =?utf-8?B?bDlKeFFlYmxDbDVObWlXTE9wUlRTSTI3YUZYT2x6RWE3dlgwYnU5a2hyMXVn?=
 =?utf-8?B?enE1cnRFekxwVmFubjVyTDZ4ZG1NQ29HdWpSTTFYQXhGZ0kwZnlmcTRVaEFz?=
 =?utf-8?B?MnVRSmdsZy93SzNFUGRMdnBibjV1WUdaTTFhTURGUkgyV1p2eGdDNzhGSy9M?=
 =?utf-8?Q?j1t6xSVTww/iDimEBzM/9Tj09rtTVnzxsM?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E97E99AD568E354DA2FE02AD2372C80D@namprd13.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: hammerspace.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR13MB3957.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78e3e365-4c21-43a3-4c71-08d89486edef
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2020 16:50:50.9833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d4fed5c-3a70-46fe-9430-ece41741f59e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8FPB7q1ZLQXE99l7QwWFePzpScrDM4nsYrfqhEStPy0JZGCDl4d+/YtYqSvKU4NW1shQOx3BWMiyIjgaYbpkww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB2927
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU3VuLCAyMDIwLTExLTI5IGF0IDE2OjQyICswMDAwLCBUcm9uZCBNeWtsZWJ1c3Qgd3JvdGU6
DQo+IEhpIFRvbSwNCj4gDQo+IE9uIEZyaSwgMjAyMC0xMS0yNyBhdCAxMTo0MyAtMDgwMCwgdHJp
eEByZWRoYXQuY29twqB3cm90ZToNCj4gPiBGcm9tOiBUb20gUml4IDx0cml4QHJlZGhhdC5jb20+
DQo+ID4gDQo+ID4gVGhlIG1hY3JvIHVzZSB3aWxsIGFscmVhZHkgaGF2ZSBhIHNlbWljb2xvbi4N
Cj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBUb20gUml4IDx0cml4QHJlZGhhdC5jb20+DQo+ID4g
LS0tDQo+ID4gwqBuZXQvc3VucnBjL2F1dGhfZ3NzL2dzc19nZW5lcmljX3Rva2VuLmMgfCAyICst
DQo+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4g
PiANCj4gPiBkaWZmIC0tZ2l0IGEvbmV0L3N1bnJwYy9hdXRoX2dzcy9nc3NfZ2VuZXJpY190b2tl
bi5jDQo+ID4gYi9uZXQvc3VucnBjL2F1dGhfZ3NzL2dzc19nZW5lcmljX3Rva2VuLmMNCj4gPiBp
bmRleCBmZTk3ZjMxMDY1MzYuLjlhZTIyZDc5NzM5MCAxMDA2NDQNCj4gPiAtLS0gYS9uZXQvc3Vu
cnBjL2F1dGhfZ3NzL2dzc19nZW5lcmljX3Rva2VuLmMNCj4gPiArKysgYi9uZXQvc3VucnBjL2F1
dGhfZ3NzL2dzc19nZW5lcmljX3Rva2VuLmMNCj4gPiBAQCAtNDYsNyArNDYsNyBAQA0KPiA+IMKg
LyogVFdSSVRFX1NUUiBmcm9tIGdzc2FwaVBfZ2VuZXJpYy5oICovDQo+ID4gwqAjZGVmaW5lIFRX
UklURV9TVFIocHRyLCBzdHIsIGxlbikgXA0KPiA+IMKgwqDCoMKgwqDCoMKgwqBtZW1jcHkoKHB0
ciksIChjaGFyICopIChzdHIpLCAobGVuKSk7IFwNCj4gPiAtwqDCoMKgwqDCoMKgwqAocHRyKSAr
PSAobGVuKTsNCj4gPiArwqDCoMKgwqDCoMKgwqAocHRyKSArPSAobGVuKQ0KPiA+IMKgDQo+ID4g
wqAvKiBYWFhYIHRoaXMgY29kZSBjdXJyZW50bHkgbWFrZXMgdGhlIGFzc3VtcHRpb24gdGhhdCBh
IG1lY2ggb2lkDQo+ID4gd2lsbA0KPiA+IMKgwqDCoCBuZXZlciBiZSBsb25nZXIgdGhhbiAxMjcg
Ynl0ZXMuwqAgVGhpcyBhc3N1bXB0aW9uIGlzIG5vdA0KPiA+IGluaGVyZW50DQo+ID4gaW4NCj4g
DQo+IFRoZXJlIGlzIGV4YWN0bHkgMSB1c2Ugb2YgdGhpcyBtYWNybyBpbiB0aGUgY29kZSBBRkFJ
Q1MuIENhbiB3ZQ0KPiBwbGVhc2UNCj4ganVzdCBnZXQgcmlkIG9mIGl0LCBhbmQgbWFrZSB0aGUg
Y29kZSB0cml2aWFsbHkgZWFzaWVyIHRvIHJlYWQ/DQo+IA0KDQoNCkJUVzogVG8gaWxsdXN0cmF0
ZSBqdXN0IGhvdyBvYmZ1c2NhdGluZyB0aGlzIGtpbmQgb2YgbWFjcm8gY2FuIGJlLCBub3RlDQp0
aGF0IHRoZSBsaW5lIHlvdSBhcmUgY2hhbmdpbmcgYWJvdmUgd2lsbCBiZSBjb21wbGV0ZWx5IG9w
dGltaXNlZCBhd2F5DQppbiB0aGUgMSB1c2UgY2FzZSB3ZSdyZSB0YWxraW5nIGFib3V0LiBJdCBp
cyBidW1waW5nIGEgcG9pbnRlciB2YWx1ZQ0KdGhhdCBpbW1lZGlhdGVseSBnZXRzIGRpc2NhcmRl
ZC4NCg0KLS0gDQpUcm9uZCBNeWtsZWJ1c3QNCkxpbnV4IE5GUyBjbGllbnQgbWFpbnRhaW5lciwg
SGFtbWVyc3BhY2UNCnRyb25kLm15a2xlYnVzdEBoYW1tZXJzcGFjZS5jb20NCg0KDQo=
