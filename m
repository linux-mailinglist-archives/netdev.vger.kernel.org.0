Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B26C325B45
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 02:26:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhBZBZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 20:25:23 -0500
Received: from mail-eopbgr40054.outbound.protection.outlook.com ([40.107.4.54]:22877
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229535AbhBZBZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 20:25:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+YetwlSGnNsjVps1Ltu8W/gme/WEBmKyZGrqkxEebhnaYbb4REs9+WnCkKzFOsw/ZBfnkfW+9AJ7WcpN+HeXeuvVTT6MnZcgOzUDhrkDCiw5zy++PkAALIwIzvWAC02zQD4RmKJj1sR8VFPN9aOc2HtTn8g1n1p9NBseSzbW8AGeMQpRx4QTK5p2BY2aeqSDm3INN/ozP+77TraQ6ymdH5DV/TaITnIo5ERIVILQvGxh4+TrG4VReDN+iPhOFeqtPDXG1gg0enNL7EaBSQeuONvzkBaJGmK53CXGozcgA4yu7XPNAA2Xjd1kEJfQwmbn4Y4o2T10aNK7C4wdjMQOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcsguZ1gcnBDyjUMBP+aqUUjv17PVCXspnZnYpmSs0k=;
 b=ZQBJENKp3qqcinMwo7tK05KjFFeHXZbA1JAYynSTsJ9la/2kvZv01QI2nvgYQnlOTC+CB0ZWZ17FXwMAvTP3N8x66VRTdCxL+8RVie4amoYsoCNryqujawuqtA7WwbdDx4P0Ze4pMab9j29D1KuwEbwJh5tmyuiy7NSvZs6QpP/qarowH2s7Bk3uP0YNv3xeWaISMOUfzsdIEtcHplaHl85xyZamlPQ6XE/xlAWNXzul7QOp8iAJRMGOaCW9y5OgJROT7a/4hLtEMjUB1dtYXjtMTbG3h/KtGRHv03vtlitTlKBjWm4ExDJQDX3HRPY7WD8SGhhPh0C5QJDlfi6GLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcsguZ1gcnBDyjUMBP+aqUUjv17PVCXspnZnYpmSs0k=;
 b=jYwqZ/GOjDHWU2s+H8mWsIpOSQ8HraAjIV9Qn7YPTqst9BRO6iPq5rlc+cGaozaoHlcqlgtBqe+G9Ob/R6lzeKPCC/3wc+mPNPlNT/HkoYOIHVeqCxLXJL3lymy2Ecasc5aQ5zXd65azFX1IR7q/jlBEKYhqaohL3LdnHt6GkSk=
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com (2603:10a6:803:133::16)
 by VI1PR04MB3184.eurprd04.prod.outlook.com (2603:10a6:802:9::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Fri, 26 Feb
 2021 01:24:23 +0000
Received: from VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14]) by VI1PR04MB6800.eurprd04.prod.outlook.com
 ([fe80::6958:79d5:16bf:5f14%9]) with mapi id 15.20.3868.033; Fri, 26 Feb 2021
 01:24:23 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC V2 net-next 0/3] net: stmmac: implement clocks management
Thread-Topic: [RFC V2 net-next 0/3] net: stmmac: implement clocks management
Thread-Index: AQHXC2xoYHDmmozE3UejIHveolpuL6pppE+A
Date:   Fri, 26 Feb 2021 01:24:23 +0000
Message-ID: <VI1PR04MB6800870F2CDE77CA2E85E1B5E69D9@VI1PR04MB6800.eurprd04.prod.outlook.com>
References: <20210225115050.23971-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210225115050.23971-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 664ee54d-c700-40d9-37d1-08d8d9f54015
x-ms-traffictypediagnostic: VI1PR04MB3184:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB318411B411C8D0C5A05F49B2E69D9@VI1PR04MB3184.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 51NNujLkioDB2o77b1AZbu7BF8CDqApAdkdkjN/LkHQjQapyAYUhqcy0Pv1q7/aDUUMZrLng96wSRORTg2aKnPrgq+AM+MVM33kCZfQ3QMUOhiawNoFwMs8kAwnPEWLYOnFvhzZu9cmpnIgIMpomsp+FmVDwfQoGV65m6fbqhqE16lZxoo3m5crA9AJhkJIbEaBFl1EaL8tx7ytN3dhloxkAL9hSrJ0nFZ9qxhIZ5YTlVHCmZMow+29vPXSsyxyMm8y3HUMnIgvrbaTvdEOmZuLURo7ig+4Cq5VmBUya+m2n6nmq2VMTtBXtYUv4T4e+ZsW20hHUQigWxMvOg6MBr3PF49qMSBuQnkvXa6mOe6ncCGBXl4Cnf6toZpRJBUdQIM1G5xtTOEKWtX9OtXMc4M2D6tl+OnzHDtnL3m7HjMghVFdfMZ52L6IWL9Fhvkxd+5Jik2R19zLbmTbC4oVldfdGheKzEv5HjZD15mox8ehzvydfyAUTAglnMhMo7p1tW1yDcjwZgmzLWnCdum2pvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB6800.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(66446008)(76116006)(66946007)(66556008)(66476007)(478600001)(52536014)(64756008)(186003)(8936002)(33656002)(53546011)(2906002)(9686003)(26005)(55016002)(54906003)(6506007)(71200400001)(316002)(4326008)(5660300002)(8676002)(110136005)(83380400001)(86362001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?OTdydmJZa3V0SkJ2RHQvb241TzN0Z01uSEdFcTFTRWJJS1FnY2ZhQUk2d1NF?=
 =?gb2312?B?eTNpVzkvTlBzNnlkbWs2WU5nWUYzTlA4SDJKT1RMWVZMMWVqOHQvVlhsTnhM?=
 =?gb2312?B?Nnlvc0I5YnpMWDZjUk5sTG1jRkpWN0cyaXkxenJSTlBDMXZCeHh0K0hQQTNt?=
 =?gb2312?B?ZlUwdHdsK2VVNjBrMVRocVhqdkhsYm51Z0QrVlpwUm1zY0hBczZZTUpLbTVW?=
 =?gb2312?B?TlBoQ1NqU094QzBLSFBUb1NLNThta2ZPK2g5dTNXYjhBRWJQVmtMZTZFNnY4?=
 =?gb2312?B?V2VVZlI3bVdrVUhieHpOVkt4R3BDRkE1YTVZUUVhaTBjY1IvdUM1UWRMSmFI?=
 =?gb2312?B?UU95QXplWUVrMER6YVlnaGVFSlYwWDdRa1pIVDZkbVpQbmZrMytBSXEzd3ZM?=
 =?gb2312?B?Vy9KcU0vbG9OeEtXQUt6M0pMSWJYTVNVM1doU0xGVTJRMFBHcHNxWWU0RnYz?=
 =?gb2312?B?dHpsVmUrOXdMMFFhNGx2YVZIeXNmNTQ2NmVaY28rUDVzb1I4S1NiZktXeTVZ?=
 =?gb2312?B?SS92Nm00UDc3KzdlL1VmaDA0RWVpRnU4dUpTUEhTOE5IcFdoY2ZtUHNHSFE1?=
 =?gb2312?B?Sk5YZmRXS1VoamRTTUljOWxZOVlhUW42TkpsN1g3VXdqSzdFNGdacG9UUmZz?=
 =?gb2312?B?ejduZmVPZldibkU5YUFkQUh4WmY5eVd6Sks3RTM1angzblc0dzZ1VzJudm91?=
 =?gb2312?B?NVp6SDNadVFCbHM1RWY2cDBBK2JLQ3YwTkNGYTEvL2FLSGJ4SDV3UVBhSUNh?=
 =?gb2312?B?c3VScmphM1RzMk51eDhZWFlxaHBXb29RSEVSSFZScmxEZk5oVm9KMXROaE0v?=
 =?gb2312?B?NytVemJuNEJCTVB0UTVkL3pmK0NvYmxwM2wvZWFYUjRnYlNQSEpDVDNlUE5Y?=
 =?gb2312?B?K25hNWg5NnZBcTkwSURHSGlBK3IyYUpJbVRKRWZFbnByQ1N6R1l4RnJZanpP?=
 =?gb2312?B?M0tYSmxPbmhFaGVZV0tHZ3owVXBSZHg0YWFsNVVpQ01nVEx0SDFNSmhyMDY3?=
 =?gb2312?B?WSszaUdvRVlUVmhuS0xpQnZJVnQ4MmRYZUZXN1ZtejhLT0JSUlhmTmdDc3Vx?=
 =?gb2312?B?NjcwSWtIMXZCVDFHVWdsd3M4bHdJbWtNRmV3U0IrRFVXTzFrbHRySVU4WndP?=
 =?gb2312?B?YUlQT2krLy9FVEViK0NrVlFQbWJWdlhSUmJMR2tDa0EyZGtINUI1R1VvYkFo?=
 =?gb2312?B?Mzh0QXVSSWxqdkZEU052VW41SEdLOENKTkZOZEczb2EwN3EvY1FHR2lETGpH?=
 =?gb2312?B?ZWFLQ1hKUXVoWThBblJKVlovT0x6WTdJL1QxNWRza0E2QVFFREdzWXVqcVo1?=
 =?gb2312?B?U1plaEVZcEw0UGxGa1Y4OXJxeHR5WHlzTWdpVlhqQUptbURDZmtJYkxsdHNH?=
 =?gb2312?B?elA0emlGRENKZ2I2RXZCb2FQVkswajZQNDFMdzhLWDJFL05EazN6TFByV3dY?=
 =?gb2312?B?QWhvMC9GRWhqVkw5b01PVGZzMjkybm1salFPU0VPNDAxdkU5VUlPUmtxamNV?=
 =?gb2312?B?YjZLclI2ck14U0xVWUJoampiR0ZoeUNMblR4bmNhTDRoNTNweTh3SWVoUHZl?=
 =?gb2312?B?U2tIMnZhTERwR0J2anFQZE9vRzMxY3MxdHk0U3JwUHJUM3BCalkveU9DcWNy?=
 =?gb2312?B?bEROSXlXMHdHT0lnNFJZek1Oc1gzQ0RId2pkTTBMeDlNeXBqN3lNbmhOZXlH?=
 =?gb2312?B?ejFOaDQvY1pCMDkrNThkMjBtQ3Z0M2toeGk2Mi9YYjFNUE92WFNacVZCcDkr?=
 =?gb2312?Q?YsQM8eRf5l01Tbie7VGIWMug6316sJ0ul9Y1fKl?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB6800.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 664ee54d-c700-40d9-37d1-08d8d9f54015
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2021 01:24:23.7207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m+fGS0OHRmnhyaCbr3xEE3W8TBwO9Sxa45g5OcMHLiwpcIQY2QGvPLJREGz60sPn4CO0iQupMh548dXUW0rDQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3184
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbGwsDQoNClRoZXJlIGlzIGFuIGlzc3VlIGluIHRoaXMgcGF0Y2ggc2V0IHZlcnNpb24o
VjIpLCBwbGVhc2Ugc3RvcCByZXZpZXdpbmcuIFNvcnJ5Lg0KSSB3aWxsIGZpeCBpdCwgYW5kIHRo
ZW4gcmVwb3N0IGl0IGFmdGVyIHRlc3RpbmcuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFu
Zw0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpvYWtpbSBaaGFuZyA8
cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IFNlbnQ6IDIwMjHE6jLUwjI1yNUgMTk6NTENCj4g
VG86IHBlcHBlLmNhdmFsbGFyb0BzdC5jb207IGFsZXhhbmRyZS50b3JndWVAc3QuY29tOw0KPiBq
b2FicmV1QHN5bm9wc3lzLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3Jn
Ow0KPiBmLmZhaW5lbGxpQGdtYWlsLmNvbTsgYW5kcmV3QGx1bm4uY2gNCj4gQ2M6IGRsLWxpbnV4
LWlteCA8bGludXgtaW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1Ympl
Y3Q6IFtSRkMgVjIgbmV0LW5leHQgMC8zXSBuZXQ6IHN0bW1hYzogaW1wbGVtZW50IGNsb2NrcyBt
YW5hZ2VtZW50DQo+IA0KPiBUaGlzIHBhdGNoIHNldCB0cmllcyB0byBpbXBsZW1lbnQgY2xvY2tz
IG1hbmFnZW1lbnQsIGFuZCB0YWtlcyBpLk1YIHBsYXRmb3JtDQo+IGFzIGFuIGV4YW1wbGUuDQo+
IA0KPiAtLS0NCj4gQ2hhbmdlTG9nczoNCj4gVjEtPlYyOg0KPiAJKiBjaGFuZ2UgdG8gcG0gcnVu
dGltZSBtZWNoYW5pc20uDQo+IAkqIHJlbmFtZSBmdW5jdGlvbjogX2VuYWJsZSgpIC0+IF9jb25m
aWcoKQ0KPiAJKiB0YWtlIE1ESU8gYnVzIGludG8gYWNjb3VudCwgaXQgbmVlZHMgY2xvY2tzIHdo
ZW4gaW50ZXJmYWNlDQo+IAlpcyBjbG9zZWQuDQo+IA0KPiBKb2FraW0gWmhhbmcgKDMpOg0KPiAg
IG5ldDogc3RtbWFjOiBhZGQgY2xvY2tzIG1hbmFnZW1lbnQgZm9yIGdtYWMgZHJpdmVyDQo+ICAg
bmV0OiBzdG1tYWM6IGFkZCBwbGF0Zm9ybSBsZXZlbCBjbG9ja3MgbWFuYWdlbWVudA0KPiAgIG5l
dDogc3RtbWFjOiBhZGQgcGxhdGZvcm0gbGV2ZWwgY2xvY2tzIG1hbmFnZW1lbnQgZm9yIGkuTVgN
Cj4gDQo+ICAuLi4vbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL2R3bWFjLWlteC5jICAgfCAg
NjAgKysrKysrLS0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3Rt
bWFjLmggIHwgICAxICsNCj4gIC4uLi9uZXQvZXRoZXJuZXQvc3RtaWNyby9zdG1tYWMvc3RtbWFj
X21haW4uYyB8ICA4NA0KPiArKysrKysrKysrKystLSAgLi4uL25ldC9ldGhlcm5ldC9zdG1pY3Jv
L3N0bW1hYy9zdG1tYWNfbWRpby5jIHwgMTA1DQo+ICsrKysrKysrKysrKysrLS0tLSAgLi4uL2V0
aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19wbGF0Zm9ybS5jIHwgIDI0DQo+ICsrKy0NCj4g
IGluY2x1ZGUvbGludXgvc3RtbWFjLmggICAgICAgICAgICAgICAgICAgICAgICB8ICAgMSArDQo+
ICA2IGZpbGVzIGNoYW5nZWQsIDIxOCBpbnNlcnRpb25zKCspLCA1NyBkZWxldGlvbnMoLSkNCj4g
DQo+IC0tDQo+IDIuMTcuMQ0KDQo=
