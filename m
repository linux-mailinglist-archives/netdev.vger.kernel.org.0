Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2760302172
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 05:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbhAYExw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 23:53:52 -0500
Received: from mail-eopbgr140048.outbound.protection.outlook.com ([40.107.14.48]:63583
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726677AbhAYExv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Jan 2021 23:53:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEd6AslXrMaII/LbLHUSiQpw94zsJ/e3fY+5IukO0CgXxvSs1uqg8KHbTB2QvPXekYa6TOlkgACuAewf5MFufWUkUfcFv5+STGN5gkAAnxgSMSg/D0QWxasmwvKCnFYkIRMpAff5O9vuNz4OTQD5Y2BF4/3N+dWER/yjW9NmgldoW6hCaXXhhxjBKB79GrGLIb0NBmGm3TYY9DRzMx06kxxBsfZ3SSjeFJGpQh2+thRHx4PmAqxN9zqqNs19AHnEN5I+79X+IpdEwCysQ1Oa9bRJkaCpObqJy+MpNrF7T0/jmsxxOym+6O7WbLP5xDFl2fGfvfjRARd9U2QxGOgWXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sC8OO6N3al9GVtxB9oBkuPfXcUyvyIYDAe+trBT4REU=;
 b=NpghpYGrefLHrVscB/+7lkYxtLsA1Y72azlaxsQ9MKwfCqLbv4swRrSWgAMldaDkosOGPIdOTKKdtiBuZMT47Gkn9Zy7Rs81BjkhVWT0Hz5DIMM7nNfN0ovHZZ2cFswKmV5m3amnYAqWKZOC1kq14TgoX4yfGzlOd+riF1Sq+yK7aUFQ5xPJw9XMXXVRo/ZYOLXFnRrWggoCQ6IcVrbFZgOq5kSueFKvmGFFbDH+By/rHqT7pJ4TjAdIrFqA7Sk5xgduwyhUcIhnq8ukAfk1OCLEOypv2zFGq1U30jC54fOyUxJNEGiLpq4etoQAGEcb7RIkzcJN3fI/hgMdnEcqiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sC8OO6N3al9GVtxB9oBkuPfXcUyvyIYDAe+trBT4REU=;
 b=m/PlMrl9LzzAgsqy96d7ZRSpKcPhmU6ec/u06oVKEOsjhcf7w3f+n94vg3uujHDiRJRiiC6aaC+Kb1h3Oz/6goMtGiG0YT4PAfHGIHTSZgkKtJtFMU1RgMfAI8wXt1nDVB36jcDIVUMwDzG/uPEJK/BMskoiK5F1gvGip9Lg6lc=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4523.eurprd04.prod.outlook.com (2603:10a6:5:36::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Mon, 25 Jan
 2021 04:53:01 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9d2b:182e:ba3b:5920%4]) with mapi id 15.20.3784.016; Mon, 25 Jan 2021
 04:53:01 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: RE: [PATCH V2 net 0/6] ethernet: fixes for stmmac driver
Thread-Topic: [PATCH V2 net 0/6] ethernet: fixes for stmmac driver
Thread-Index: AQHW6NbY1/nTacn06ka/dqTpPSLiCqo32h3Q
Date:   Mon, 25 Jan 2021 04:53:00 +0000
Message-ID: <DB8PR04MB67954786B4359A020C76D2ACE6BD0@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210112113345.12937-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5d49571e-920e-4b31-50f5-08d8c0ed17b2
x-ms-traffictypediagnostic: DB7PR04MB4523:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB452389CA8819DA02EEEA4D04E6BD0@DB7PR04MB4523.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Tl5Z5imdGETMh3ruVbBPkRZmDLxpjno+MgUQtJtsTPRqWEKVaV3k9ctHWdgJkuhnOKXirOQjrvTh652ZI/S6lBp5r9H5IpQb/Da1AMaa5LL2XbgPfifEX6eiJVC81FYayMe4U/sYyqL8PpCs2VdkfJP+54IkfDYOJ8VkE2jOK0dG49U2UQ8lXjY1qFoZ9hvHV4wfx+p7fSLC49qkmRxMKimT52Cfyf4Jf9x76DNERDvJX9daCcYkhMowFU5VDanP6N9AsA3LFByev0Q4C49jQXHia/ae4u5WbmtWdindi84pDXZJyACnh7BtBiCwBfFvDxZhdHKFWvQQFNrD27PjQodVB5bzu76NGIYkqDyk/8DbB63+7INdKAkexoYuTAG4NxBs3Upvm8yjuWUMgvsrTYVRW9TU2n4FJdi1icTBx4IkP2NEiaoKLJTRFsrzJ9sRmYYKyaYZSHwDQvH5Cbez/6TDkaMyz27Hb3PEk4HFZIOf5XAQBt9YEqi9Q/rKz9tsP3d6jxqJJXLWh7bVuP7hg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(39860400002)(396003)(366004)(4326008)(186003)(52536014)(478600001)(54906003)(6506007)(8676002)(66476007)(66446008)(64756008)(5660300002)(2906002)(76116006)(53546011)(26005)(316002)(66556008)(83380400001)(71200400001)(55016002)(86362001)(9686003)(66946007)(7696005)(33656002)(110136005)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?bW5paE5MUjBNWFBSWlZQRUREOHdYVUwwNkVlVzhqWVExSktNcm1kQi9qRVlv?=
 =?gb2312?B?akJTRUpHTkFSTkRMYkJyUGw3dElNdjhTZ2ZrNUxtMjREN1pWTGo3d29jUG9O?=
 =?gb2312?B?YXFWb3dqOHI3YzNsU1hZOW5adnJYS2RrVHcrdVB3VUFVRHljZWpoWDhid0Q3?=
 =?gb2312?B?UWowdkpsZ1N0NGRKMWUzQUxQQ2N2YzdnR3Q0UWY2alN1TUNMRGZZYi9ncmx2?=
 =?gb2312?B?bmoyd3ZjRzROaDdpZmRRajR3enFTQ2JwQjk5dnVvOHhrYU01My9ZR0JaVCtW?=
 =?gb2312?B?ZjFSNWZXV2taSThOQVA4b2dUbEZ5ZENyT1AzTEcvOTJPYmJyTnNXODg4OUNx?=
 =?gb2312?B?R3NGQnF4ZXU5ZGRsTGlDTzdEMmZlK2Exa0NVRFVJZW8xUGNLQnpBcDhqMUxx?=
 =?gb2312?B?RnlrdXBWeTY2Ymh4U2NGMzh4SGJMSTdxcEQvV2Q0aXp6akMyN0lGTHhPcGh1?=
 =?gb2312?B?N3FrR1ZET0ZDazBWYlBURkd6Rlh0dXh2UEJObEhXQVFSMjBxeWpVTXFkYVJo?=
 =?gb2312?B?VDc1V0h3d0FITEl3SkZLQW1RNURGbXN6U1RLdFhHMFlSTjYyc29QdmFmOHd1?=
 =?gb2312?B?QWZDamhKcWVXRnk2ZWQxcjlQT2k5QkR0cGdicmVWMklqZ0diOXdSUG9nZ0hP?=
 =?gb2312?B?T09JL0N1bkpkR0R2WmErMTBEZmZCd0xpNzAvZnpESTVuNGd3SFhHR0VxK3Ri?=
 =?gb2312?B?MWZ1aVZJbEdmb1J2aVFWRTlFWEZSV0pqZDNzZFBuVFdabmtpUEpSNzBUYWZq?=
 =?gb2312?B?Q1EwNndyOFNjdlZYTnlxTjRFdVhIalBiRHduRWw1SEVoalF4KzN6MnRzWVVP?=
 =?gb2312?B?Sm8wVTdOZHpNTWh2clUrUld2Rmo1UTQvMUFBWngzNmJXZ2FBQ3ZCRGMxSkRL?=
 =?gb2312?B?dWUzL2Z5TFJkWjRqK2g1dGVWeXhwMUY2NExwaVB5cStHTHRCV05ORkNzdmhX?=
 =?gb2312?B?a2thQzRmcVZoMGxUcUVNdm83dXNzQlpqWVZHRkNuUndTRXhwOHJ2bmZWRVdp?=
 =?gb2312?B?S2dlME9WMnh1Z3BOTzdIT2lvZXhsKzVtbk80QUVpaWtkY0RtdUR2MHBrL24x?=
 =?gb2312?B?UE45OGoxQnU0cUJOWUl1S3BBRWVFTkZmbXlROXpSL0lGUEI3aGxMODEvQlZN?=
 =?gb2312?B?dTU5UXdSNGJDZVVEcnF1VlhCOXYxOG1KR1hCWGNDVUxYRlk4RHprOEJNbHdX?=
 =?gb2312?B?QmxnSVpsL28rV3g1OXVtem5EcTY0WGtJQmZmSGZrTnhjNDZkWXdFNXorbkRH?=
 =?gb2312?B?Z1hpOWJWOXRBTyswOG1BZFJhdmJSOXdSZk9oRWd1dlhNOTR3aWZjNVVJaVVE?=
 =?gb2312?B?VmhTUUxRdjVrL05LRlU1MldGMUNGalJhYzMxeGJqaUw3OHpIZ3N1enJkWGhI?=
 =?gb2312?B?aWRDTWYwakM3NGRPWlhzVUtOOFNNdzh0RHFPSzgyQ0lzaSsrY01rSGVGbjRT?=
 =?gb2312?Q?rWfcJbXP?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d49571e-920e-4b31-50f5-08d8c0ed17b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2021 04:53:00.9552
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o2rK5JwSMTPzb/pN+vAraXIP87nYSIGnCEybRkiBklYDc8561vxxIMd9N3hVfpAGIb2zC7fZGSlJk4cEi3pNYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4523
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpHZW50bGUgUGluZy4uLg0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCg0KPiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56
aGFuZ0BueHAuY29tPg0KPiBTZW50OiAyMDIxxOox1MIxMsjVIDE5OjM0DQo+IFRvOiBwZXBwZS5j
YXZhbGxhcm9Ac3QuY29tOyBhbGV4YW5kcmUudG9yZ3VlQHN0LmNvbTsNCj4gam9hYnJldUBzeW5v
cHN5cy5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZw0KPiBDYzogbmV0
ZGV2QHZnZXIua2VybmVsLm9yZzsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47DQo+
IGFuZHJld0BsdW5uLmNoOyBmLmZhaW5lbGxpQGdtYWlsLmNvbQ0KPiBTdWJqZWN0OiBbUEFUQ0gg
VjIgbmV0IDAvNl0gZXRoZXJuZXQ6IGZpeGVzIGZvciBzdG1tYWMgZHJpdmVyDQo+IA0KPiBGaXhl
cyBmb3Igc3RtbWFjIGRyaXZlci4NCj4gDQo+IC0tLQ0KPiBDaGFuZ2VMb2dzOg0KPiBWMS0+VjI6
DQo+IAkqIHN1YmplY3QgcHJlZml4OiBldGhlcm5ldDogc3RtbWFjOiAtPiBuZXQ6IHN0bW1hYzoN
Cj4gCSogdXNlIGRtYV9hZGRyX3QgaW5zdGVhZCBvZiB1bnNpZ25lZCBpbnQgZm9yIHBoeXNpY2Fs
IGFkZHJlc3MNCj4gCSogdXNlIGNwdV90b19sZTMyKCkNCj4gDQo+IEpvYWtpbSBaaGFuZyAoNik6
DQo+ICAgbmV0OiBzdG1tYWM6IHJlbW92ZSByZWR1bmRhbnQgbnVsbCBjaGVjayBmb3IgcHRwIGNs
b2NrDQo+ICAgbmV0OiBzdG1tYWM6IHN0b3AgZWFjaCB0eCBjaGFubmVsIGluZGVwZW5kZW50bHkN
Cj4gICBuZXQ6IHN0bW1hYzogZml4IHdhdGNoZG9nIHRpbWVvdXQgZHVyaW5nIHN1c3BlbmQvcmVz
dW1lIHN0cmVzcyB0ZXN0DQo+ICAgbmV0OiBzdG1tYWM6IGZpeCBkbWEgcGh5c2ljYWwgYWRkcmVz
cyBvZiBkZXNjcmlwdG9yIHdoZW4gZGlzcGxheSByaW5nDQo+ICAgbmV0OiBzdG1tYWM6IGZpeCB3
cm9uZ2x5IHNldCBidWZmZXIyIHZhbGlkIHdoZW4gc3BoIHVuc3VwcG9ydA0KPiAgIG5ldDogc3Rt
bWFjOiByZS1pbml0IHJ4IGJ1ZmZlcnMgd2hlbiBtYWMgcmVzdW1lIGJhY2sNCj4gDQo+ICAuLi4v
ZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWM0X2Rlc2NzLmMgICAgfCAgMTYgKy0NCj4gIC4u
Li9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHdtYWM0X2xpYi5jICB8ICAgNCAtDQo+ICAu
Li4vZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZHd4Z21hYzJfZGVzY3MuYyAgfCAgIDIgKy0NCj4g
IC4uLi9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvZW5oX2Rlc2MuYyAgICB8ICAgNyArLQ0K
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvaHdpZi5oICAgIHwgICA1ICst
DQo+ICAuLi4vbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL25vcm1fZGVzYy5jICAgfCAgIDcg
Ky0NCj4gIC4uLi9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFjX21haW4uYyB8IDE0
MCArKysrKysrKysrKysrKystLS0NCj4gIDcgZmlsZXMgY2hhbmdlZCwgMTM5IGluc2VydGlvbnMo
KyksIDQyIGRlbGV0aW9ucygtKQ0KPiANCj4gLS0NCj4gMi4xNy4xDQoNCg==
