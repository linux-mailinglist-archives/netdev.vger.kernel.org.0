Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537DD397EF3
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 04:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhFBCYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 22:24:40 -0400
Received: from mail-eopbgr40075.outbound.protection.outlook.com ([40.107.4.75]:47982
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231222AbhFBCYY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 22:24:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8/vl6tvK8ZOg8q3GlfsiN2hCGkr1fARCQH7t8m01OB19s0bIvx+zUS/623yeauu3d6wS5IllhZUXtK0arAqOf2nuESa6dX0/bqE/pjwdYBQ6gyY3+61PIcBWZ+KWZgnsg6dvFjhJLYm8es385Iyh4qlvFXqWgEmhUeOmJ9VrnCXpPAEmkfOrMZ4lulGp7mBj/zhg8Ykq5cKk159pL4oXakkuWfOjr/jj196tzDNUz1HPLhISg6i/3QQqfDS1rU0O6XRJ9kDtI5UX8yxMddvAUDmJJmUj8513gWa1vPtee6FR9DBd+OJnzlKrXO5MHz/Z9GaVRGuiOc/w8rs3kbs1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSg/r5lNj3rFC0Fstt6qsz2tJ1Lv2HdhdHkeF6tbsqM=;
 b=Pv/XxtVddg/PKarPc22tt3OYUq0BAFotLS991NKGNcorMjnuuN7SSvaFnalqye1WX0hnS6SJwtfLsJKeDebQiw3W8jXnG7Yiu1RfqD1aowAp0jqQ+IfzP0GO4cuG9Kg+c49CNppHxgerhhpxfsd6Ok4joup5ZHFULI304XBSzAuz6tBoy9uYlSD7L7McAnQyg0Cv/xdzX5kPoO8NUc5JCxlmD//CdGhPZBb9Ge48SHK91N+/WwNd1qxRSMp2/r8bpCrIazRO0F5fQzyvOMLMxB0uFmL8P/dB2IFxsvx6w6T683VabS2XreuCsTu8HCBsmcU/9VVTMfQfkVD3TZKYaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uSg/r5lNj3rFC0Fstt6qsz2tJ1Lv2HdhdHkeF6tbsqM=;
 b=puoBRT7J4sev0cee3aH8IQy02PbK6u8TUiK/AvTpZZ68F1BzdXJ8aP1xDJLMfO2fEUrzwZ4ARGfc8sbvmB6eAg+0I1oeA83gcueMHjoURMf42HtA8bG0alnRmA9/2PKgvfHURgQnUgWO1TsGD1XhKFZNagaQhqrAOVZXL+zTxUA=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2904.eurprd04.prod.outlook.com (2603:10a6:4:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 02:22:38 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 02:22:38 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 3/4] net: phy: realteck: add dt property to
 disable ALDPS mode
Thread-Topic: [PATCH net-next 3/4] net: phy: realteck: add dt property to
 disable ALDPS mode
Thread-Index: AQHXVsUtJuhMvmxy5k2Gw3UiyLhowqr/C5uAgADul6A=
Date:   Wed, 2 Jun 2021 02:22:38 +0000
Message-ID: <DB8PR04MB6795A51DF2F9525CA9AEA177E63D9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210601090408.22025-1-qiangqing.zhang@nxp.com>
 <20210601090408.22025-4-qiangqing.zhang@nxp.com>
 <20210601115219.GU30436@shell.armlinux.org.uk>
In-Reply-To: <20210601115219.GU30436@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: adcaa9c9-269e-4fd9-35a3-08d9256d4af3
x-ms-traffictypediagnostic: DB6PR0402MB2904:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB29045A5F31C3BB533ECC33CEE63D9@DB6PR0402MB2904.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8Atr+DZe3mBslCeSM51B2WOLgP2gWbwiexQISLYWi8LG/yRn/kUu2b8KZD2GBvYEW9QR7SfHNpfElHZSdJQToQUlq5dcR4MPpyEl5WUdomhNYmYKJ0P0dmNixecRvLHbSQOGwK06t7yLnMT7CSrj+FmVaefLXuYdNUMfeqmh1gzkLLgAeeqIDgkYMtSpskwOZ3LHacTUx+x9XKPSHoniHdBriqGqijogknb12XIf4+pG5Qm8YfeX9DNCpoJhocwuyumeCrt0bNK8h4z2oX9fLQpGaQK8jULzBaGlENvSVfFuiIDmCjbHp/FzBHnYMmyUyRiAv36W7k73xscVeX7RQqklPzDwhCtw9BXvL13vCxbFlUDpq2fsWUNWlc3qGZkGdufe4fHFaMb+5VsZIpBfMhQMMWozB3tbVp1Kv+sYCvatAkca+NmLmWkGE8b+PhC3fibjtYVMwicr/bzFp+l2WssI4IsW9Y32oaeiVqIJRmEC4SXqkhcIr2zx/pKqfW3BQphYQAbrvFz+JJcux9oDPO0JmyUK2TFXEt3u3uMjdjNRtRhyeMUu7XWsWpK7gHOgTj92iJzvBzplD61EZcDuQvCc7EcMwfAm1MWZvey/ldyFf1TTBJFb6U4M23qT6YZxP+wH+yKNw41ccb5DUv/ow3qWR8hf7TImBdGzhFeNnqkSYelXV/Aw0P5JV0lmDqJH9yiv6d/pAuly3Van2ZEYEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(366004)(45080400002)(478600001)(122000001)(966005)(66946007)(316002)(33656002)(8676002)(86362001)(76116006)(2906002)(8936002)(4326008)(26005)(186003)(66446008)(7416002)(53546011)(64756008)(6506007)(6916009)(66476007)(52536014)(7696005)(5660300002)(71200400001)(83380400001)(55016002)(66556008)(38100700002)(54906003)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?Zld6YXRiV3ZXVS9hWFF1ZnZldm5mRE9HS3hOMDgyWTRZNk1wNEIvUjFJVDQ2?=
 =?gb2312?B?ZDBIWG00bEJ6Y1ZCUDU1U2V1L0d3QTJMYmlUZERZUVV4NUY0KzQvbVVtZG1o?=
 =?gb2312?B?UkRBZWtxTUpPbk9DSVdnSVhuT2xQUUtMK0pyTFN3b3A4dHRobEE5QzhIOTJj?=
 =?gb2312?B?RlQ2aktUOEw4dERZeTRGdnlaeFpDVWwvZGRhZ1l1MkVuNmFrWitoQzlrWWI1?=
 =?gb2312?B?b21Sd2lyRnFSQ0s1NXBQdGZsOTB3RnBNL1daWGJvWWkyZ2ptZWUyY24zT1ZK?=
 =?gb2312?B?UDB1ZldBbzdoc1RrSmNHQVpPVDRnTUtyMlRpRUdjdUxETERsU0RuTldKeUlS?=
 =?gb2312?B?dVJHZmNVOGI5RGxXSTlMVnNCNUxjV0FqUEZoRVhCS0xCakc5bWRPQTRaSkNG?=
 =?gb2312?B?YnYrckFWZHZEV1RFQlljcnp4bjZQVGV5VUVUQjRUMTBDNVJSM3VSY040VXo3?=
 =?gb2312?B?anVFMlI0MWRRNjQ5OWExR052RWdtNEVKZUU3NVc4MG5ZSWo0di9zcDZhQnVt?=
 =?gb2312?B?SC94a0hEVWpXOWhlZUlYZU8rRjJyZGN5czRUOENrTGpYbkhVM3c2bVZHSllI?=
 =?gb2312?B?VWlXU0dhV1ZScWVwZ2hlN1pLOXlsclpBTjRoQ3RRd25pTnREQVNJc2tvc2lq?=
 =?gb2312?B?RGhPSzdYODZhb1BqMFdxWG1pc0RjaXB0Ly9QUnR5WWFEc1padE9qNi9xdm1o?=
 =?gb2312?B?M0cxaDhrYkYzby9NcHdtbXBoOFNnMHNxSWFlWXUrUHkzYVptQmEySzJSVEZo?=
 =?gb2312?B?UTZIc29DNVIrUWsrT3JEaElVMUtiZ0pseWZRRXpKYXAyZGJKc2c3TkxGRWZO?=
 =?gb2312?B?U1JCRmV1Nk12czJSNjluWUxHNTRaSkcrMytHaWpacmhMT29SSWFDclo1aG5t?=
 =?gb2312?B?VVY2MG9SUVZYM2pGc2oyU0RJaHZQZDJlTDhLVm5rWnBlVW16MjVVc0xQTGZB?=
 =?gb2312?B?TlVDTEIxOWJyeHRZZURJQkJWMXZnVEZLMUdveFN1Nk1rTm5FVUs0aFZ5ZWs0?=
 =?gb2312?B?Ni9TdVQ5b0hRL24zNVVHK0NQajljNFM3bHdRVHRURFNyYXNPQUtpWGdUdzMv?=
 =?gb2312?B?S3hWUy9VaG9yTUtvaDQxSEtraFF6MGVNcGpoclJnY2hZZjFNUmdjK3djeHJz?=
 =?gb2312?B?NEl4SmM2dVFzS1BiYk9MeEV5T3BLaVpyc2JaYVlDQXArVWhBNUwwU2U4MDl3?=
 =?gb2312?B?TnMxcVJCUWlZU3B1VGNPZ2U0eGlDNUkxWFdwTjRkcThZaW1kRDg1SlNwaVBo?=
 =?gb2312?B?ZThzc3g4QjJZQzFXbThyZEhsclBqaU5SKzJMTk0xRDVlM2ZmNWd5UEw5cFo3?=
 =?gb2312?B?Ly9Wd1ZGQjZjdGtJdXBHZDV1NW9LZTFZMERXV2lNb2t0Y0dkbm1aMjRuVlpP?=
 =?gb2312?B?NmY5MnFaNUJrWkFoNVhLcjVDOEtTLzVvdVRGNWF4L3ZJTzVUdGROSjRlSnRJ?=
 =?gb2312?B?Y0svL01RZzZPNy9iUDZTOWFFUWRSNnc5UndrT1BXRTdSemV0QkNIdnhvS0hO?=
 =?gb2312?B?OEdTNEhWb2hkK09oWEVXQnRBY3JaUEE5RVJUKzJuMGpudmlZNG1DZVU1cjlQ?=
 =?gb2312?B?V0MxTkZxanZRZGp4NjcyUnExNVlFNXNZL0NIV3JKcmh2YXkwbEF3d2dvYnRD?=
 =?gb2312?B?ZE4ya2JWRXh6a3cxbFR2WWhzUlY5QnZhOWFWV1lTcnA3U1I4WEw5MXNkMlNu?=
 =?gb2312?B?YnhMVk5zRVBHYy9lYTVDc0dCRzgvc3BibUpnNUJueHF4TXZ4ZGE0MWcyekFn?=
 =?gb2312?Q?wzNNqDk6PJjEiIzwIz10hFvw81qnOHGNeAngGMB?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adcaa9c9-269e-4fd9-35a3-08d9256d4af3
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 02:22:38.6770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rFKPhU1iuiTHO2CKzKLAwerN7WMJUTR4Qu3yR9bWoFj61qGE6Mj1FD/OtiksVsVuMa+mTeWOYmAx4YGeMdO/tA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2904
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBSdXNzZWxsLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJ1
c3NlbGwgS2luZyA8bGludXhAYXJtbGludXgub3JnLnVrPg0KPiBTZW50OiAyMDIxxOo21MIxyNUg
MTk6NTINCj4gVG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IENj
OiBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IHJvYmgrZHRAa2VybmVsLm9y
ZzsNCj4gYW5kcmV3QGx1bm4uY2g7IGhrYWxsd2VpdDFAZ21haWwuY29tOyBmLmZhaW5lbGxpQGdt
YWlsLmNvbTsgZGwtbGludXgtaW14DQo+IDxsaW51eC1pbXhAbnhwLmNvbT47IG5ldGRldkB2Z2Vy
Lmtlcm5lbC5vcmc7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgMy80XSBuZXQ6
IHBoeTogcmVhbHRlY2s6IGFkZCBkdCBwcm9wZXJ0eSB0byBkaXNhYmxlDQo+IEFMRFBTIG1vZGUN
Cj4gDQo+IE9uIFR1ZSwgSnVuIDAxLCAyMDIxIGF0IDA1OjA0OjA3UE0gKzA4MDAsIEpvYWtpbSBa
aGFuZyB3cm90ZToNCj4gPiBAQCAtMzI1LDggKzMyOSwxMCBAQCBzdGF0aWMgaW50IHJ0bDgyMTFm
X2NvbmZpZ19pbml0KHN0cnVjdCBwaHlfZGV2aWNlDQo+ICpwaHlkZXYpDQo+ID4gIAl1MTYgdmFs
Ow0KPiA+ICAJaW50IHJldDsNCj4gPg0KPiA+IC0JdmFsID0gUlRMODIxMUZfQUxEUFNfRU5BQkxF
IHwgUlRMODIxMUZfQUxEUFNfUExMX09GRiB8DQo+IFJUTDgyMTFGX0FMRFBTX1hUQUxfT0ZGOw0K
PiA+IC0JcGh5X21vZGlmeV9wYWdlZF9jaGFuZ2VkKHBoeWRldiwgMHhhNDMsIFJUTDgyMTFGX1BI
WUNSMSwgdmFsLCB2YWwpOw0KPiA+ICsJaWYgKCEocHJpdi0+cXVpcmtzICYgUlRMODIxWF9BTERQ
U19ESVNBQkxFX0ZFQVRVUkUpKSB7DQo+ID4gKwkJdmFsID0gUlRMODIxMUZfQUxEUFNfRU5BQkxF
IHwgUlRMODIxMUZfQUxEUFNfUExMX09GRiB8DQo+IFJUTDgyMTFGX0FMRFBTX1hUQUxfT0ZGOw0K
PiA+ICsJCXBoeV9tb2RpZnlfcGFnZWRfY2hhbmdlZChwaHlkZXYsIDB4YTQzLCBSVEw4MjExRl9Q
SFlDUjEsIHZhbCwNCj4gdmFsKTsNCj4gPiArCX0NCj4gDQo+IFNpbWlsYXIgcXVlc3Rpb25zIGFz
IHdpdGggdGhlIHByZXZpb3VzIHBhdGNoLCBidXQgYWxzby4uLiB0aGlzIGRvZXNuJ3QgYWN0dWFs
bHkNCj4gZGlzYWJsZSB0aGUgZmVhdHVyZSBpZiBpdCB3YXMgcHJldmlvdXNseSB0dXJuZWQgb24u
IEUuZy4gYQ0KPiBrZXhlYygpIGZyb20gYSBjdXJyZW50IGtlcm5lbCB0aGF0IGhhcyBzZXQgdGhl
c2UgZmVhdHVyZXMgaW50byBhIHN1YnNlcXVlbnQNCj4ga2VybmVsIHRoYXQgdGhlIERUIHJlcXVl
c3RzIHRoZSBmZWF0dXJlIHRvIGJlIGRpc2FibGVkLiBPciBhIGJvb3QgbG9hZGVyIHRoYXQNCj4g
aGFzIGVuYWJsZWQgdGhpcyBmZWF0dXJlLg0KU29ycnksIEkgZG9uJ3Qga25vdyB3aGF0IHlvdXIg
bWVhbmluZ3MuIEFzIEkgZXhwbGFpbmVkIGJlZm9yZSwgYm9vdCBsb2FkZXIgYWxzbyBjYW4gY29u
ZmlndXJlIFBIWSByZWdpc3RlcnMsDQpidXQga2VybmVsIHNob3VsZCBub3QgZGVwZW5kIG9uIHdo
YXQgYm9vdCBsb2FkZXIgZGlkLg0KDQpJZiB5b3UgdXNlIGtleGVjKCkgdG8gYm9vdCBrZXJuZWwg
d2l0aCBEVCByZXF1ZXN0IHRvIGRpc2FibGUgdGhpcyBjbG9jaywgUEhZIHByb2JlIGFsc28gY2Fu
IHBhcnNlIHRoaXMgcHJvcGVydHkgdG8gZGlzYWJsZSBpdC4NCkkga25vdyBsaXR0bGUgYWJvdXQg
a2V4ZWMoKSwgY291bGQgeW91IHBsZWFzZSBleHBsYWluIG1vcmUgaWYgSSBtaXN1bmRlcnN0YW5k
Pw0KDQo+IElmIERUIHNwZWNpZmllcyB0aGF0IHRoaXMgZmVhdHVyZSBpcyBkaXNhYmxlZCwgc2hv
dWxkbid0IHRoaXMgY29kZSBiZSBkaXNhYmxpbmcgaXQNCj4gZXhwbGljaXRseT8NClllcywgZXhh
Y3RseSBzaG91bGQuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiAtLQ0KPiBSTUsn
cyBQYXRjaCBzeXN0ZW06DQo+IGh0dHBzOi8vZXVyMDEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0
bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRnd3dy5hcg0KPiBtbGludXgub3JnLnVrJTJGZGV2
ZWxvcGVyJTJGcGF0Y2hlcyUyRiZhbXA7ZGF0YT0wNCU3QzAxJTdDcWlhbmdxaW4NCj4gZy56aGFu
ZyU0MG54cC5jb20lN0NlYWNhYmQyNTk0MTQ0ODMwMWFjYjA4ZDkyNGYzYjZkZSU3QzY4NmVhMWQz
Yg0KPiBjMmI0YzZmYTkyY2Q5OWM1YzMwMTYzNSU3QzAlN0MwJTdDNjM3NTgxNDUxNDM2MzQ1NzMx
JTdDVW5rbm93bg0KPiAlN0NUV0ZwYkdac2IzZDhleUpXSWpvaU1DNHdMakF3TURBaUxDSlFJam9p
VjJsdU16SWlMQ0pCVGlJNklrMWhhVw0KPiB3aUxDSlhWQ0k2TW4wJTNEJTdDMTAwMCZhbXA7c2Rh
dGE9M2p5WWVHVkJYWGI1akNEdHlUcnQzREk5TXdWRQ0KPiBPVDVFdDl0cENaRzI2Z1klM0QmYW1w
O3Jlc2VydmVkPTANCj4gRlRUUCBpcyBoZXJlISA0ME1icHMgZG93biAxME1icHMgdXAuIERlY2Vu
dCBjb25uZWN0aXZpdHkgYXQgbGFzdCENCg==
