Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E49440E969
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 20:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344930AbhIPRyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 13:54:02 -0400
Received: from mail-eopbgr80118.outbound.protection.outlook.com ([40.107.8.118]:35822
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350583AbhIPRsp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 13:48:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iNSgpnyjBJ7JWpgPJHySVpwTILRphJUb5bT66GtvgZF7vRDbwd1Sex6l8JPddag50DdPCVyJ8ksweNZWbllqXCEk80HeG1LNLEERoFRw0CC8KMW8q1iwAoF3Vqqpmc2mvMPTjSsQ8BSU3WXVMU8qwOQnU9sRlmPhg14nU0UEvMBPCt5jd/7TFWEn1HYDcdSjhYKjJCiP+oWrjYIc/bfuC5F41tIPQH72pjInaivtjlIgvrDDvFDj8SboKHeTNBD0VxGK7EvGZb2hscmEAXErNhGtI9Nur7VqpBbsNxnxRsSi9qRzRNfgERNS5psRZMH2G2hQDIi58WJld7iQ3GTVdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zsPPf5zSgYbat1TB3NNOjnUI/rSYyGorzjD7YK2pt04=;
 b=Jn8a1WVaOTp/bv37GeEEddAZQmFqapDMwbLVonp09t4lWMRMmgqpSELWsuFehRb4q8FfTvFx4ktVe3o+mufbSASHcnhBy1ZzpP+jdCUcLfln+dUeFNksu5rUAGcLal9ar8ftbLh6PXTYXx8MV0v/RSf2NHax4pH3Jmz0afwABcbZo6YbwGkaZPRd5hUxGB0MlUs04Z1dAc9wv4p2wBpSuF0bU39mPaTWt4knwYK7YHfRG11zdCiwDJ+qZ0Eb6MOrFA9CNS6oKIRjxMWtoj19dmoWfmP9XmDaNOEjeR14aNzF5LyJ17dGObsbIOGAfNyd5EtWeA2dif54ckRR6twJtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=esd.eu; dmarc=pass action=none header.from=esd.eu; dkim=pass
 header.d=esd.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=esdhannover.onmicrosoft.com; s=selector1-esdhannover-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsPPf5zSgYbat1TB3NNOjnUI/rSYyGorzjD7YK2pt04=;
 b=c+/b0JgYbwOHQPfxjZ6DHC/Nptto7fyVa6yCVnTFfflIhGguyfl0vn/nNdCXJyHhARIqjEBl8aQMZ+/IJSR+Yh5gn3c5y6PSnYEe0InER3dyLJwbcCFGemOzgjtxl6yoCTYAkfj0Fz7nBcPrCoC0kDN5QwsF3JljKPrX77co4jw=
Received: from AM9PR03MB6929.eurprd03.prod.outlook.com (2603:10a6:20b:287::7)
 by AM0PR03MB4516.eurprd03.prod.outlook.com (2603:10a6:208:cc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Thu, 16 Sep
 2021 17:47:22 +0000
Received: from AM9PR03MB6929.eurprd03.prod.outlook.com
 ([fe80::10ad:7cc1:aa13:f41b]) by AM9PR03MB6929.eurprd03.prod.outlook.com
 ([fe80::10ad:7cc1:aa13:f41b%9]) with mapi id 15.20.4523.016; Thu, 16 Sep 2021
 17:47:22 +0000
From:   =?utf-8?B?U3RlZmFuIE3DpHRqZQ==?= <Stefan.Maetje@esd.eu>
To:     "lkp@intel.com" <lkp@intel.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC:     "kbuild-all@lists.01.org" <kbuild-all@lists.01.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] can: esd: add support for esd GmbH PCIe/402 CAN
 interface family
Thread-Topic: [PATCH v3 2/2] can: esd: add support for esd GmbH PCIe/402 CAN
 interface family
Thread-Index: AQHXpNEnvymJpgPWkkym9W7N8X0W56ufd+0AgAeEPYA=
Date:   Thu, 16 Sep 2021 17:47:22 +0000
Message-ID: <d05c727fb91f598a28e7fc8e5fcc5643ea5ab93c.camel@esd.eu>
References: <20210908164640.23243-3-stefan.maetje@esd.eu>
         <202109120608.7ZbQXkRh-lkp@intel.com>
In-Reply-To: <202109120608.7ZbQXkRh-lkp@intel.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=esd.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3dc7448-2b7b-4242-61bb-08d9793a097b
x-ms-traffictypediagnostic: AM0PR03MB4516:
x-microsoft-antispam-prvs: <AM0PR03MB45162109B4E65BF43181630581DC9@AM0PR03MB4516.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1002;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H2xl2WUA7iMPvQpoqgPBh9F7rqPQJcO1G6pIZqZ9G1iI+soFrB+H+WXvNhENaeaGlWYensxuPLKu7oplK+rQttrFBQSFvfV5hlSQlV2zh73dqSkLcCjA0adUWF0OUBoX7wa92tu0VuPBMytWgdvwyhYUA7G/icpLYNRhcn9+E6+/m+FWSwqRRwEdV3hGUIU2P4ZVXI4FfmnV4+/3FckcjDbZ/py1EmNmPlMZ3Mvto0yP8zyrGqwws8tp7vjgWRyqDMG31vX1EpuLAcStDhB6k0YwGpK54p+1yuFJL+sUgafxE0DtlM0nNqhPfF7M6uiESOthPr4ZyMKYGRz/91Y/PN8IuD+08fqxkqkH0Dtc2T/NW845C+D5P3OnB906GYTl+6Mo3wPj5vQN1dgu2ycGoDelIvEJhs2YzstvXaOTGgbrN3CRi1UrtGJyQ2GCL5j2Kig5ydpAweQF1yc/TP0SCVDXLNH9tyjk5Q+pwMUEmqsiLm+WTtK2VNJ8WwAtXZ6Gwr7ODGxLjpL2MTCsiILdNNQjnVGGf57flFgRUTxsYSgV9EfBqVBfUGINQCEF6C8lBpxc2Zi+Bh3kQWBG7DIWzM30OrR6WpkT4f9Tk+StFUc4509KKeFmxPFVMwBdJE4Y3UoFcD5lzd2y2DY1BEHWBgmT6O332yAOMw0a5TyIoloOm+4FXW4EcvlaCQyPjG/hoDy3SxyLJjs9sU0HBmrIrk/fcY43iVG66HubvYVR8NGnJfbYnw3kToq00zHvR07RoTgCn+zFuuLNyMSdO9HTqLMN9REemjBDzIupcnpSEdI+2tu+OlsS+Rt6hMYwTuvG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR03MB6929.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39840400004)(346002)(376002)(396003)(136003)(122000001)(2616005)(316002)(54906003)(110136005)(508600001)(85182001)(66574015)(4326008)(15974865002)(86362001)(5660300002)(38070700005)(36756003)(6486002)(76116006)(966005)(66476007)(66946007)(66556008)(64756008)(66446008)(8676002)(26005)(85202003)(186003)(38100700002)(6506007)(8936002)(71200400001)(2906002)(6512007)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1hlck0ySjAyVUlxRy9aQ0lxdmdOTGwvRmIvWkV6SnVCLys1VjBnSnBSZ2Uz?=
 =?utf-8?B?cEVhTUNEZzdWZ2xFekwzZk9TNHpuU3ZRUUFkTDA4aVNUSHlIZnlvclBINTF0?=
 =?utf-8?B?SEZrNmZmL2V2dUFRUmFDVlhJNGc3b1lsUUlLQUplSG9JRG5Jam41NTdVSGg1?=
 =?utf-8?B?RHo4aGRvNHc0MlpDYlNZNE5IUFROQmtQT09TQjRReE1BYkoyREU3WCtQWW1G?=
 =?utf-8?B?SzlsekVaYko0T05UeXVUM09TZjhwa0tlNTdvcGJBVmg1WjJiQnM4MEJsSjdn?=
 =?utf-8?B?TFRmelZ6UFdPR0VoUmNSaHpBVXhSOGRydm9oc0lhNG9KL3Uva1NtNjR1Wm5p?=
 =?utf-8?B?OU11d3o1bFQvWHdzOWhLR3R5Y1RPYkkzRTdOQ2FFcHBzZzh0L1VlZnoxRVo4?=
 =?utf-8?B?bzQvY3ZIeUJ2UWx1N0RRajhid1crTlU3bGY4WTNEUjYzcFl6UllnRVZnSkRY?=
 =?utf-8?B?aGU3L2pETnEwdUNZbkdBc0tOcHAwTEZBOTJHeW1VdnVITVpDYWppM1ZLMlkw?=
 =?utf-8?B?b2hDVnJJOXIzT0VvZHd6NnF6SDZNRUFsZkZpTzQzSDF4d1hKc3VoRWl4OWZ6?=
 =?utf-8?B?NjNQRHkvNU8rd0VYdFZPOGlHSzJaYS8wOWQyUHg4OGxrTXdFcnA2K0ZCeWds?=
 =?utf-8?B?Qi9oQW1zVWhQNitic0RNUVZMdWVVZmVNSzBuRDJQUGNhckthOVpLUlF2YmVv?=
 =?utf-8?B?WitNZXNCMXVHSmF0ZkFJaHNoZkhqNGRaTENTb0ROVTZNSGlxMlZ5RFc1ZlBx?=
 =?utf-8?B?c0xzZ3EzaWI0TDhEenp5ZHkxaHcyaHo0KzBLY2l0TEk0dmE4QUxJZEhFakdI?=
 =?utf-8?B?QTJUdlJQbjVFRFpoUHNXN2ZRSSswanBtSXpab3FOUjV6aEJreFgwUW5MbGly?=
 =?utf-8?B?VVZ5ZmFDdlVMaHJtZjZ2a0oxQlJtSUg5aktNZUpnQXZ5QWhrbXdyak10bkVZ?=
 =?utf-8?B?TkRHUVk3ODh0WFpzYjBOc2tvZGtVdWE5TENmeEk0cTNpcE93UTFUdXJDb1Jp?=
 =?utf-8?B?RHF0Vi81cFA5aW0xc2l6dXJyK2p3ZzBWVmVhY3lGVTBmUk5jNkdrTTFBalhq?=
 =?utf-8?B?M3FSSHozUDRGSVRwMmhPUEJLdmFoK1BhTitSMDh1T0VEa0hvTnVqTnZVR0Jq?=
 =?utf-8?B?dHNOYUJ0dk1LOUpRTTlnUXBZM2IwZW9ZZmxUUVpKNUZMM0VVM1FiUjRENlhk?=
 =?utf-8?B?RWhBeFdIMWZEaGdFYkloRGNxdGRwalJsV0taOS9DMWtNYnNBdWVNUkVoSDdR?=
 =?utf-8?B?cFJTOVVJbGVYTmRiQXpZaHpsOW1TbmhFUFZzckFEb3YwZmp4VHBURmFHS3Jk?=
 =?utf-8?B?dnlJZ2E4ayszM3pYalV0WXM4RytuTkZDN25MdytkSnhmVXhCQURjdFhISUl1?=
 =?utf-8?B?cnBtNEZCU0JjaHF1T3pGekNnV3FoS1hod2tObVV4dFhodGs2NEtZdlBOM2s0?=
 =?utf-8?B?UmlHOHpTYmhDdDJMZlV2a3RjeWF2T3BuK3RrS0Y4YUwvY0lrVGdvZ1RuNmFH?=
 =?utf-8?B?ME9na3MyUU81aHgyVUNaQzRJWXBPdXB6eStVeWRTVm1GTVNrU0hweUJrbFpU?=
 =?utf-8?B?WkpTZW5DaDFjTkdRdUY3UXZ5U3k3MlJDRzdrakFPbmRTWmRVUTZsaERkd2pu?=
 =?utf-8?B?SlpBRllQc1NzbzhWQ0F4SXR6UlhXU1d1S0tMcmhHeDlkalNwRTVMYXdUS0Zq?=
 =?utf-8?B?UTdTakF3M3N3cnZMNGM1T2VsaFBnb2F2ZkU1enpIWEJsZllvUi9penlkc0dl?=
 =?utf-8?B?TGRqMjU4Uzc5QnU1L3pjU0NibmJyeXMzYU9ZU1FBdHM4QTVsRjY1RW1YZjU5?=
 =?utf-8?B?emV2dGVpa1ArUjhuY04vZz09?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E1067065CD414F4DAAE186647376DA94@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: esd.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR03MB6929.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3dc7448-2b7b-4242-61bb-08d9793a097b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2021 17:47:22.2834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5a9c3a1d-52db-4235-b74c-9fd851db2e6b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b3DrWdxsQq1zB8S1c42GkCSbc02AoMnRldw/CflziNaS3hpiEUJOmTDSRLK65i8/ETtz7uf28dG4ZNI1KiWmwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB4516
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QW0gU29ubnRhZywgZGVuIDEyLjA5LjIwMjEsIDA3OjAwICswODAwIHNjaHJpZWIga2VybmVsIHRl
c3Qgcm9ib3Q6DQo+IEhpICJTdGVmYW4sDQo+IA0KPiBJIGxvdmUgeW91ciBwYXRjaCEgWWV0IHNv
bWV0aGluZyB0byBpbXByb3ZlOg0KPiANCj4gW2F1dG8gYnVpbGQgdGVzdCBFUlJPUiBvbiBjYmU4
Y2Q3ZDgzZTI1MWJmZjEzNGE1N2VhNGI2Mzc4ZGI5OTJhZDgyXQ0KPiANCj4gdXJsOiAgICANCj4g
aHR0cHM6Ly9naXRodWIuY29tLzBkYXktY2kvbGludXgvY29tbWl0cy9TdGVmYW4tTS10amUvY2Fu
LWVzZC1hZGQtc3VwcG9ydC1mb3ItZXNkLUdtYkgtUENJZS00MDItQ0FOLWludGVyZmFjZS8yMDIx
MDkwOS0wMDQ5NDgNCj4gYmFzZTogICBjYmU4Y2Q3ZDgzZTI1MWJmZjEzNGE1N2VhNGI2Mzc4ZGI5
OTJhZDgyDQo+IGNvbmZpZzogYXJtNjQtcmFuZGNvbmZpZy1yMDMzLTIwMjEwOTExIChhdHRhY2hl
ZCBhcyAuY29uZmlnKQ0KPiBjb21waWxlcjogYWFyY2g2NC1saW51eC1nY2MgKEdDQykgMTEuMi4w
DQo+IHJlcHJvZHVjZSAodGhpcyBpcyBhIFc9MSBidWlsZCk6DQo+ICAgICAgICAgd2dldCBodHRw
czovL3Jhdy5naXRodWJ1c2VyY29udGVudC5jb20vaW50ZWwvbGtwLXRlc3RzL21hc3Rlci9zYmlu
L21ha2UuY3Jvc3MgLU8gfi9iaW4vbWFrZS5jcm9zcw0KPiAgICAgICAgIGNobW9kICt4IH4vYmlu
L21ha2UuY3Jvc3MNCj4gICAgICAgICAjIGh0dHBzOi8vZ2l0aHViLmNvbS8wZGF5LWNpL2xpbnV4
L2NvbW1pdC9mMmI4MzcyZDNlNGExY2IyZWNlOTdmNTI1NjBkMGE1OThiMzZjYjZiDQo+ICAgICAg
ICAgZ2l0IHJlbW90ZSBhZGQgbGludXgtcmV2aWV3IGh0dHBzOi8vZ2l0aHViLmNvbS8wZGF5LWNp
L2xpbnV4DQo+ICAgICAgICAgZ2l0IGZldGNoIC0tbm8tdGFncyBsaW51eC1yZXZpZXcgU3RlZmFu
LU0tdGplL2Nhbi1lc2QtYWRkLXN1cHBvcnQtZm9yLWVzZC1HbWJILVBDSWUtNDAyLUNBTi1pbnRl
cmZhY2UvMjAyMTA5MDktMDA0OTQ4DQo+ICAgICAgICAgZ2l0IGNoZWNrb3V0IGYyYjgzNzJkM2U0
YTFjYjJlY2U5N2Y1MjU2MGQwYTU5OGIzNmNiNmINCj4gICAgICAgICAjIHNhdmUgdGhlIGF0dGFj
aGVkIC5jb25maWcgdG8gbGludXggYnVpbGQgdHJlZQ0KPiAgICAgICAgIENPTVBJTEVSX0lOU1RB
TExfUEFUSD0kSE9NRS8wZGF5IENPTVBJTEVSPWdjYy0xMS4yLjAgbWFrZS5jcm9zcyBBUkNIPWFy
bTY0IA0KPiANCj4gSWYgeW91IGZpeCB0aGUgaXNzdWUsIGtpbmRseSBhZGQgZm9sbG93aW5nIHRh
ZyBhcyBhcHByb3ByaWF0ZQ0KPiBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBp
bnRlbC5jb20+DQo+IA0KPiBBbGwgZXJyb3JzIChuZXcgb25lcyBwcmVmaXhlZCBieSA+Piwgb2xk
IG9uZXMgcHJlZml4ZWQgYnkgPDwpOg0KPiANCj4gPiA+IEVSUk9SOiBtb2Rwb3N0OiAiX19hYXJj
aDY0X2xkYWRkNF9hY3FfcmVsIiBbZHJpdmVycy9uZXQvY2FuL2VzZC9lc2RfNDAyX3BjaS5rb10g
dW5kZWZpbmVkIQ0KDQpUaGlzIGlzc3VlIGhhcyBiZWVuIGZpeGVkIGluIHY0IG9mIHRoZSBwYXRj
aC4gU2VlDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1jYW4vMjAyMTA5MTYxNzIxNTIu
NTEyNy0xLXN0ZWZhbi5tYWV0amVAZXNkLmV1Lw0KDQotLSANCkJlc3QgcmVnYXJkcywNCg0KU3Rl
ZmFuIE3DpHRqZQ0KU3lzdGVtIERlc2lnbg0KDQpQaG9uZTogKzQ5LTUxMS0zNzI5OC0xNDYNCkUt
TWFpbDogc3RlZmFuLm1hZXRqZUBlc2QuZXUNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fXw0KZXNkIGVsZWN0cm9uaWNzIGdtYmgNClZhaHJlbndhbGRlciBTdHIuIDIwNw0K
MzAxNjUgSGFubm92ZXINCnd3dy5lc2QuZXUNCg0KUXVhbGl0eSBQcm9kdWN0cyDigJMgTWFkZSBp
biBHZXJtYW55DQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18NCg0KUmVn
aXN0ZXIgSGFubm92ZXIgSFJCIDUxMzczIC0gVkFULUlEIERFIDExNTY3MjgzMg0KR2VuZXJhbCBN
YW5hZ2VyOiBLbGF1cyBEZXRlcmluZw0KDQo=
