Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB05432B42F
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352959AbhCCEjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:39:00 -0500
Received: from mail-eopbgr10058.outbound.protection.outlook.com ([40.107.1.58]:4069
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1352785AbhCCEOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 23:14:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aF6ijhdmSZ5ByFIaR6moCn5bTbCdeq/pGdlV7rFcX8SdNi22k064fo3n5KvcyCHkRpEhpH9HfXdDWHXZmNqBkBS3+44vIzcEhmNE/5GRY5AfLXG2/4GtHToPT1GrTlj7TUd9WHyZeAyodBr1PYgi6+Z2E7vO/tv73f7yoZ/GCGRi1jslTFXD7CnlDFgOi/q6n0vE59bsO79iHJsZV1wvT8Wg2TLqheOH5gs0yAdpZmaVpX58G433oyeej4K0kU6MOt91BXXq/Gd1w/UYqW4dlfcZzS0Px+4xNUK+6zOJI+fqmw8SZ6//3QdZB+nWozfqekh/2bfrHRXJip4iBnljhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZQ60tKvVm4VlNVoKtLJwd+xKpC37lVeNH1aoUOUAwc=;
 b=bl+AOr/qYb/yK5MlCaWtGX/Rv4ez3kuA9J6U+yB1K8hqbPsC22LlvTLsu/CKdgQSlyYz1A6nqGhtaS0a61cO862IkQPhJOzR/Pu55pbjgdDFj1eHDg0AVysQeCMKfk5Gsm6C9UIut65CbDbTUQ4RCCsPmXLW2BT/sX3NWSHwkadiLYydpJubd0/1zo+vAvXhNH68kmocnfTBDO63T2Ym+jdi4DWI4FkBpdlUwzi+YIPjrXyVrdGEu+0M2//0jFjRMCx/u3cFP03FX+bauKlHk50qaWlLJTn+bDLJSIs9rh2xL/fJCx8/z0vSOwq1+6vP84Proi2XiAgOwSot3VYJwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZQ60tKvVm4VlNVoKtLJwd+xKpC37lVeNH1aoUOUAwc=;
 b=KETfdoVS75CpSvvuCf5bK/gcZBEDJ5s0hkxE5r70+6smFrpaIR0C40wumsrDyOdJbrm8xhrGS+Nn8SsePElRr4EnTc0Vuj/1Px4eDqCUbrBQKFEY4dr8/ZAf8Ow2iRIzyH9UCqVB9lpXid8TALjjkAmV1a2d3NUEB/DY1DFJxiY=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5500.eurprd04.prod.outlook.com (2603:10a6:10:87::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 3 Mar
 2021 04:13:54 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3890.029; Wed, 3 Mar 2021
 04:13:54 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC V2 resend net-next 1/3] net: stmmac: add clocks management
 for gmac driver
Thread-Topic: [RFC V2 resend net-next 1/3] net: stmmac: add clocks management
 for gmac driver
Thread-Index: AQHXDoUsQJGaJ1wVhkqhKfqQQhWzXapxeqiAgAAfXNA=
Date:   Wed, 3 Mar 2021 04:13:53 +0000
Message-ID: <DB8PR04MB67956ED7546382C42B7B0DA8E6989@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210301102529.18573-1-qiangqing.zhang@nxp.com>
 <20210301102529.18573-2-qiangqing.zhang@nxp.com> <YD7lHzFxPPYA3M04@lunn.ch>
In-Reply-To: <YD7lHzFxPPYA3M04@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 432364bd-f106-4830-0b06-08d8ddfac20d
x-ms-traffictypediagnostic: DB7PR04MB5500:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB550029FD8EA4267F40C5CFA7E6989@DB7PR04MB5500.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NU4sgFQAeQ5z8I1B2NAEHaO3K8Cczj6sztxFCtRW0bcroSAXxVpz73YDFwWapza07IwQjE9X3zph+ijL1LxNcfpSolcq1d83/kEVcOihv5YxjlCo/JqZEPdCYNkdGN2jIiu/kWjeaVXUnj27LcW5sBk7v8/YriFJoWWzLuB5zNZAns0QiOwEKO3s0yoh/jKKCtjOPXsVZGp2encN8w2fqOmHqluBpbAluIctPud5/qUDxkdf8Nm6Imv0wZeVTe4+S5i6rh9dUR+krKicFoKBI1xY20MNCHpE/k2F6YgXfh7l9QvcS9WjD2w83F52/l5mn4Ql+VxWSzhpwWSpa8AZYaeLdIPQkV53LUt7SgroljHffB7gGbe+rs0XUDdXSyqtqL/YRSUeoJeR5P4JL0FP1wuCBYgBPQsFseJlCxqon7Nffgb4KxO+f0TKWKei2ZYgZ/aWlZC+LWjmchMuZM4DsJ1pmeTievLm043+eW2O8vO+Ue1ql0BlvgLYuWSSGfzwjbmH922UXkXArjiPYie+ug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(136003)(396003)(376002)(83380400001)(86362001)(2906002)(66946007)(76116006)(6506007)(53546011)(66476007)(66556008)(66446008)(4326008)(64756008)(55016002)(9686003)(33656002)(8676002)(478600001)(7696005)(8936002)(6916009)(26005)(54906003)(5660300002)(71200400001)(316002)(186003)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?L0VnK0ZGOTMvOW9RcDlIZjNhRzZ3SGRvcWNaMUc0TE9rWXltd0diMlhJWDVp?=
 =?gb2312?B?NGVTbFZmTVdiTHhwbXZxY2hhZk95ZEV1UEFodnlFdm1mVHo0c1VwRUVESnIy?=
 =?gb2312?B?Q21ZdVVsOG9memMwVjFieVJQUCtOc1dvMFBrc1hXSXF5a3FEMFU2ZE4yVS96?=
 =?gb2312?B?ZGJRa01vSzhFK3N2elZEVUluZ1RnRHpiQnF6MnFsazUxc3I3cEFqV0R0Q01I?=
 =?gb2312?B?TkNnK1hmSXdWLzBCWGtXQWU5c3g3RytDeXpaN3NlUmxSUlo5RGZYaFdPaUhq?=
 =?gb2312?B?NEQwWDhrOFgxWTR5VXlqVjhJck9mTU5nd0RsME40ZEdTTGc1ZTNCeU4yVEIz?=
 =?gb2312?B?UGVYa29LODlsNGc3aGJMNnh5S1FLWUJMN2R1VXpxMEw0b3BVRUxrQVI1U1ZI?=
 =?gb2312?B?VEtnWU9hMFBSRG50SHd4UkMzb1Z1RFRtT3pOZ001bERTdnM3a3lCMnVYSWdR?=
 =?gb2312?B?UXI5Z3ZueVVIMDFlaGNseWRJdTJ2T25TOUlJOTZOM3FYUXozNTlHdGJyaTJH?=
 =?gb2312?B?R0pGelhyN2huaXphcFdKK3d5c0xPaFVzcEpEdWRzSXR3ZXdtWG5UVkNBYXpv?=
 =?gb2312?B?Sy9nTEJ0d1NZdUQvTmpRVTlnMnY5a1pObDl6UFZBOGY1N2w4Z1JyMnlNc0xm?=
 =?gb2312?B?ODlCUm9xUnBCSHNnN244a2VUbGFKemJFQ2pXWGhsVzZvWTFvdm1PNjFUTVVS?=
 =?gb2312?B?djR1b0tjUHpzZHlYVEcwRXhVUUJLZlprOUhoYkd6WFlLZDViODB0WXFjMVdp?=
 =?gb2312?B?eU5wd2R1Y0REMnFOY1JkMW12QjdmMTVWc3Y4eEFENTM2S1dOV2VYRlUzRUZU?=
 =?gb2312?B?ZXg4NWNPV3VDYzJqMWFMSHRTV1dzZDhhZE1BLzlldDZPS3RUYmdydEMrd1Fw?=
 =?gb2312?B?S2ZZNHFsM3ZXdDFNZEhxMjQyaCswaE8vQXl5WnRaZzNJSTVUcUdndlZ6MnhI?=
 =?gb2312?B?b1pFL2VtYkhRbzl1SlVtOHk2SkYrazZyZXhhbE9uU2NReHpJK0VsU25VTUFV?=
 =?gb2312?B?YUprcUg5SmtIRlhxelhNazFrSGd1SjVXRjc0ZmhOUHVCSEdCbmNNMnpnZzNW?=
 =?gb2312?B?SXJHTTQweU9JR2JkZllCR1hmZWV0TFd6S3YwbVlFdkd5THdTYTN4OFRHamVP?=
 =?gb2312?B?TUVUc2JpNFBlUm1QRFdOSEdGbzdiUkRJcExvQVk2UFM4L3hWTEtMRDNKdW5u?=
 =?gb2312?B?SXNNQjFJdjlXZEM5RCtia0xyWFE0UThWemlWb1JLMGhqTjg5OWZWZWVEMUZt?=
 =?gb2312?B?L2FrR3VaYWZMNUpIZkp1M0hiSTNzTXhtREh2NTVpTnRqVCt0TXFxVS9kRDhW?=
 =?gb2312?B?U25MSE53ekdZWkNWcmcvSC9sYmlqZlVod050OHdtNFJvRDFhcWpaTkw4ME1F?=
 =?gb2312?B?OUVGUklUcDZ6VWwveVdsZi9sQTJBem9yRG5aay8wemhGdnNQWWJnSVVYTUU0?=
 =?gb2312?B?SDZxUUNrMjlWcEpHRHd0SnV5dzZlVHNZWEtqN2REamFTZUxyZXZlZU1wamty?=
 =?gb2312?B?Vm4rbVhNRjd6UXFnMTIwM1VldVRXR2dpZkloZjY4a3J4U1BXZFNEMnJSRis3?=
 =?gb2312?B?UGdMVmhOb3dTVDNZR3MyYVdmdDR3alZxc2RTVVJQV01tblI0V1BIUkdDcWlS?=
 =?gb2312?B?SjR0aXR3d2xXQ1ZWY2hwOC96S0JTbWpwVTMwZFlCdExnWHZxcCtyaDhUbjZr?=
 =?gb2312?B?NkV4Ky9vbjBTL3MvY0VXa0ZYbGE2WHplNWVRRHVNTkJLbkY0ZWdsMFNaL1VN?=
 =?gb2312?Q?h+pLCGrHM78mwSl6ks=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 432364bd-f106-4830-0b06-08d8ddfac20d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 04:13:53.8838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qFjQija44/86p5UrTCqhNljXAAZwH3N+BgWv9KtcTNzMF2hfIrJT04OyRtXCTdDkhOyVeHYAyLz5slIZbP44Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5500
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEFuZHJldyBMdW5uIDxhbmRy
ZXdAbHVubi5jaD4NCj4gU2VudDogMjAyMcTqM9TCM8jVIDk6MjQNCj4gVG86IEpvYWtpbSBaaGFu
ZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IENjOiBwZXBwZS5jYXZhbGxhcm9Ac3QuY29t
OyBhbGV4YW5kcmUudG9yZ3VlQHN0LmNvbTsNCj4gam9hYnJldUBzeW5vcHN5cy5jb207IGRhdmVt
QGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsNCj4gZi5mYWluZWxsaUBnbWFpbC5jb207
IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnDQo+IFN1YmplY3Q6IFJlOiBbUkZDIFYyIHJlc2VuZCBuZXQtbmV4dCAxLzNdIG5ldDogc3Rt
bWFjOiBhZGQgY2xvY2tzDQo+IG1hbmFnZW1lbnQgZm9yIGdtYWMgZHJpdmVyDQo+IA0KPiBPbiBN
b24sIE1hciAwMSwgMjAyMSBhdCAwNjoyNToyN1BNICswODAwLCBKb2FraW0gWmhhbmcgd3JvdGU6
DQo+ID4gQEAgLTEyMSwxMSArMTMyLDIyIEBAIHN0YXRpYyBpbnQgc3RtbWFjX3hnbWFjMl9tZGlv
X3JlYWQoc3RydWN0DQo+IG1paV9idXMgKmJ1cywgaW50IHBoeWFkZHIsIGludCBwaHlyZWcpDQo+
ID4NCj4gPiAgCS8qIFdhaXQgdW50aWwgYW55IGV4aXN0aW5nIE1JSSBvcGVyYXRpb24gaXMgY29t
cGxldGUgKi8NCj4gPiAgCWlmIChyZWFkbF9wb2xsX3RpbWVvdXQocHJpdi0+aW9hZGRyICsgbWlp
X2RhdGEsIHRtcCwNCj4gPiAtCQkJICAgICAgICEodG1wICYgTUlJX1hHTUFDX0JVU1kpLCAxMDAs
IDEwMDAwKSkNCj4gPiAtCQlyZXR1cm4gLUVCVVNZOw0KPiA+ICsJCQkgICAgICAgISh0bXAgJiBN
SUlfWEdNQUNfQlVTWSksIDEwMCwgMTAwMDApKSB7DQo+ID4gKwkJcmV0ID0gLUVCVVNZOw0KPiA+
ICsJCWdvdG8gZXJyX2Rpc2FibGVfY2xrczsNCj4gPiArCX0NCj4gPg0KPiA+ICAJLyogUmVhZCB0
aGUgZGF0YSBmcm9tIHRoZSBNSUkgZGF0YSByZWdpc3RlciAqLw0KPiA+IC0JcmV0dXJuIHJlYWRs
KHByaXYtPmlvYWRkciArIG1paV9kYXRhKSAmIEdFTk1BU0soMTUsIDApOw0KPiA+ICsJZGF0YSA9
IChpbnQpcmVhZGwocHJpdi0+aW9hZGRyICsgbWlpX2RhdGEpICYgR0VOTUFTSygxNSwgMCk7DQo+
ID4gKw0KPiA+ICsJcG1fcnVudGltZV9wdXQocHJpdi0+ZGV2aWNlKTsNCj4gPiArDQo+ID4gKwly
ZXR1cm4gZGF0YTsNCj4gPiArDQo+ID4gK2Vycl9kaXNhYmxlX2Nsa3M6DQo+ID4gKwlwbV9ydW50
aW1lX3B1dChwcml2LT5kZXZpY2UpOw0KPiA+ICsNCj4gPiArCXJldHVybiByZXQ7DQo+IA0KPiBI
aSBKb2FraW0NCj4gDQo+IFlvdSBjb3VsZCBkbw0KPiANCj4gCXJldCA9IChpbnQpcmVhZGwocHJp
di0+aW9hZGRyICsgbWlpX2RhdGEpICYgR0VOTUFTSygxNSwgMCk7DQo+IA0KPiBlcnJfZGlzYWJs
ZV9jbGtzOg0KPiAJcG1fcnVudGltZV9wdXQocHJpdi0+ZGV2aWNlKTsNCj4gDQo+IAlyZXR1cm4g
cmV0Ow0KPiANCj4gU2xpZ2h0bHkgc2ltcGxlci4NCg0KSGkgQW5kcmV3LA0KDQpUaGFua3MgZm9y
IHlvdSBraW5kbHkgcmV2aWV3IQ0KDQpZZXMsIEkgdGhpbmsgdGhpcyBiZWZvcmUsIGJ1dCAicmV0
IiBpcyBhbHdheXMgdXNlZCB0byBjaGVjayBmdW5jdGlvbnMnIHJldHVybiB2YWx1ZSwgdG8gYXZv
aWQgY29uZnVzaW9uLCBJIGFkZCB0aGUgdmFyaWFibGUgImRhdGEiLg0KTWF5YmUgSSdtIHRoaW5r
aW5nIHRvbyBtdWNoLCBJIHdpbGwgaW1wcm92ZSBpdC4NCg0KQmVzdCBSZWdhcmRzLA0KSm9ha2lt
IFpoYW5nDQo+ID4NCj4gPiAgCS8qIFJlYWQgdGhlIGRhdGEgZnJvbSB0aGUgTUlJIGRhdGEgcmVn
aXN0ZXIgKi8NCj4gPiAgCWRhdGEgPSAoaW50KXJlYWRsKHByaXYtPmlvYWRkciArIG1paV9kYXRh
KSAmIE1JSV9EQVRBX01BU0s7DQo+ID4NCj4gPiArCXBtX3J1bnRpbWVfcHV0KHByaXYtPmRldmlj
ZSk7DQo+ID4gKw0KPiA+ICAJcmV0dXJuIGRhdGE7DQo+ID4gKw0KPiA+ICtlcnJfZGlzYWJsZV9j
bGtzOg0KPiA+ICsJcG1fcnVudGltZV9wdXQocHJpdi0+ZGV2aWNlKTsNCj4gPiArDQo+ID4gKwly
ZXR1cm4gcmV0Ow0KPiA+ICB9DQo+IA0KPiBTYW1lIGhlcmUuDQo+IA0KPiBPdGhlcndpc2U6DQo+
IA0KPiBSZXZpZXdlZC1ieTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiANCj4gICAg
IEFuZHJldw0K
