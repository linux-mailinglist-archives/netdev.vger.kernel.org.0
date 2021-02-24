Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8EB323570
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 02:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhBXBqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 20:46:36 -0500
Received: from mail-eopbgr00079.outbound.protection.outlook.com ([40.107.0.79]:35712
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230367AbhBXBqb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 20:46:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWOIEVtUo3ICxxB+f/R24pGepFpkXKbIfRCREA2l1zzS+C2PFiKVRt/kwi6stw9kp7Re3ty6XkzCdDi0a6N9R6jvwTYekkp2Rf7jW48Icc1hn7dYXC/xXwA+4MnHzti9SdyBf0uYYX5OXWgUho3wyXqaMwJaoWpG7s5/80UImHGbhhZ1ZedZpRJGzUuQeV8zWQr61YT0yHBBxEtQ0kdixI9PK98vteB2VjzHbB7gzRm1/nQ2Ay59EHMUQAfdXGXX8imUR/c5WtkzgLDN99BCcH4SHj3n8U8yBzGuB+FdgzYNvbTaYBTY/W/ULk31EoJzB1Lnw5PIn+IBh8/N+HE3Yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g09Vv96SXaaV7zRVGLZ0xeu30fIda0YmblcsFF1p+Yo=;
 b=TUjsKEx1avFH1JvWgvL8v0gRh+mSJQC3NtJG2vPRjZudkXSSOI8tp74TPxgdUO9RNpUUbBIpzVBnhvJZwHiIFhMByrtvK0EtdyYdWVr73q0HFtpq9NN7Z71h/HHIOnMHGW0DgSzaTMFFJhedGjoGCdYD5pgfkEIsJZNJsmF3rydCHbKAhgz6NUPZuw9bmLI+0cf09tteP/fohNbfQPmuO/GTB8AVKt6XJnjiT9+wrNTdY+IUbNTd58qRsCzUSG07/OS+SnQViGbSyoTW7eE37UMJjaWuQOABNURvpo0i4wJwJ+AosZ+uLB+EWdGUpzJeAT4hcM++rv3H0Hb+hcSCYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g09Vv96SXaaV7zRVGLZ0xeu30fIda0YmblcsFF1p+Yo=;
 b=kq5/YmxLxMoIAGxm6NP8L/WcccxEj+hbzMsik8itFar7AzCjncSbL2nMhCfJqp3wT68eD73Xyg4rUqrGAKr4uzgmGId2OlDjcn+S9eKToguHvHw5jHImqiCjZDjJar9lj0VivVrYzYCRZGQHGbUWrfCaRT6ETllF7f6AtGJk4CQ=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3094.eurprd04.prod.outlook.com (2603:10a6:6:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Wed, 24 Feb
 2021 01:45:41 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Wed, 24 Feb 2021
 01:45:41 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Thread-Topic: [PATCH V1 net-next 0/3] net: stmmac: implement clocks
Thread-Index: AQHXCdFekWFqiRqYw0qX+7Ua7CCmtKpl8tSAgACRjMA=
Date:   Wed, 24 Feb 2021 01:45:40 +0000
Message-ID: <DB8PR04MB6795925488C63791C2BD588EE69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
 <20210223084503.34ae93f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210223084503.34ae93f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c6b7ac74-0e01-4773-6bd0-08d8d865e48b
x-ms-traffictypediagnostic: DB6PR04MB3094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR04MB3094A9F12CBB6140A247961FE69F9@DB6PR04MB3094.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h865AIu7toCgYXag1LIrk5qHGYNXy5YTJfjxiXQNoL6FD1kBF0o/f18JvY6Z+hCHn1Xh6R8+V59YhHnznxecmQ2Vfqm2FFe0N8CRAnVnOQqOBJ4kCF67eRxzf3tPZ80Ff3iqbkbt5GHFQz/+tFB+7FWCcJMEtp9hBzkJJ9p32WhsfOZQ+pRAwkSlQ6gaI8sdfjVf4FtSbQnRRTcXSS2buI7JQClrH4g4ccFzZG3U+2SAGNGyr//dwQrx7aUL322OyGcwRRde3pc5QeLRHq3Y61P0IfO3mld4RTRAJRf8EeHf9bAikvDRJZJXCrp4v9OO3/NZ27KNAE8NhafpwgJuWbprxW4L4TkUGmt3U7CpQ2ts2gHD9piGKgiT9QO/q1M6RcX+C1TWoXiMr0J/Z/mVGN8eewOF7AOUPvYgOQOPDmbo/wPyGiupV9QPKS6tj5ElgXdZ1B+fQ7hNBsr8Vh/JxprwDjcYcuVnUVyGwetSTD9STceb+ySysPWglbpPy9cALrKpV517jbN8mcsW0A6Gr2dCa4xZGTVVVBE/zz6l0/iPMc9yaxE9qmi8ing/KAgn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(45080400002)(4326008)(6506007)(76116006)(71200400001)(55016002)(5660300002)(478600001)(9686003)(186003)(64756008)(8936002)(53546011)(8676002)(54906003)(66556008)(26005)(83380400001)(316002)(33656002)(2906002)(66446008)(7696005)(52536014)(66476007)(86362001)(6916009)(966005)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?NHpXbTZVVFgza20waFpNQjV4eWxENE9GbG1pa3Nwajk5MjRwRVdWbjl3N3Ar?=
 =?gb2312?B?RmlaT2I4clFDZGlOTlhzakNRVWwxTEdraW5hVXNjSTg3aWN4VTQwSkUvQklp?=
 =?gb2312?B?K2ZPWXJ2TGpqYituVXB4SXZwOXlwd0pZNUdYQnBzcEFhb09nTCtObWFXWmly?=
 =?gb2312?B?ZVh5dG5YUUJrbmdDK0tNWUZjWE04NmUzYmkyb0huUDd5a29QK281TVdCOTlB?=
 =?gb2312?B?RHZwL2x6ejJmbmdCMlZMalJZNW9IMnhKMXB2RHQ2WW0yL3hWc3RWWWZvT2hr?=
 =?gb2312?B?TmxKYlFuamI4emUwekl2U0UzQTg2R29RWkJOY1IwcmZaZmRpcFhmVVVCZXc2?=
 =?gb2312?B?Tjl0R0NIb0ZyUDBoYjlGQnBPZGJkMjNwTDZqbFU4aGVGcDVQa1JRWERzTEpB?=
 =?gb2312?B?Qlhra0xiVHViNlZTYmYwbUtmVmVHNU10a3JWa1ZaWkExYXdGUkVnbUh6SXhH?=
 =?gb2312?B?czJ1UUdmUmplc3VxajZ5SUhWV2JoMk5iWmIzTmxLc2RSdkEvandLWmszT1Fo?=
 =?gb2312?B?S3A0YVYzMGFDb1ZnSzEza2hLenRSV3ZZZHBmVWRUZzJrKzVjZmtSSzZmQ0xQ?=
 =?gb2312?B?VHV2Wk45eUdMZDdtYTFKT3lrQktSOWNPRlZIN0w1YUdvejZxbjV3aVIvNmFX?=
 =?gb2312?B?UHNySEpIZXBpN2JtOE94b3V0cjVBaU1RK3pwTVRNQ1FZSDFQeHhLM0dsN3I3?=
 =?gb2312?B?VGZmV1NPb2tRdDgza2VYNmQ4eWQxRmxVSlFQSnVwQnUwTnJGYWtzbGtjV2dB?=
 =?gb2312?B?YW5DUUFjR2o5VW9aaDhIVS9ES1ZmbWY1WHI1dGpzRVFGcmxvak1PYjFJSVVq?=
 =?gb2312?B?ZUE1TzFEQk9NRHh3S3N5UXdXWksyK1dqV3BmT1NtRVE5b1lVUGNGN0RONU9s?=
 =?gb2312?B?dlJDSmtVaENDMWpGanQ3Q21Tc05tK0FaTGx6eDRKcWZJRC9rYWNxR1VKOHdP?=
 =?gb2312?B?TWE4Nk5pWmZoaDFGdW9FNDc4U0ViSWU3bW1JWU1LY1V3ODlISmZuUEZqQTRV?=
 =?gb2312?B?ZGhZeC9SQjdoRkg1c1B3UnFlbHZMcjBUYmpZZGJVbTkzdVVCQk1NRGxBSUtG?=
 =?gb2312?B?eG4raTFTa0ZTSFlUZ1pzeFo4ZzZPVmpjZHdDRVlUNmlLeWJ5eDlSdFdCYVdO?=
 =?gb2312?B?TG9wc0dFSUhxcUdpaWI2Q1dBY0EzcmRsNk44bVE5enlDUm1VM1htMGJiazNh?=
 =?gb2312?B?ZU1tcFNWMHZJM1RxNGx0a1pXWU5PUDJpT29sNEptbnhPdjNLaHlQc2xyT2VN?=
 =?gb2312?B?RVRSK1VtVXE0cTJyUGVNZ2xoQWhyTkFndUE4di9TMm43UVdzMjBTZS93UkNP?=
 =?gb2312?B?c0RRLzMxby9rbERvVXdGcmtBLzhLcXkzN0NtSkpxbE1RZWRDVHZvcUVOL2Vr?=
 =?gb2312?B?Q2Nhby9tWmpncGRYK1pmcVhMb1RldlBmNnY4cWx1NVNseHByUHRMMVRyOG4r?=
 =?gb2312?B?R2tkNU5TckdPaGkzcTd0WWNqUzdOMXZKMXcyOWpkZ0JydXRxbS83d05CbVJD?=
 =?gb2312?B?K3VndDFVM3Z2R3B6dkhrRGZLVWJZT1UrcTBPY2JCZ0J0ZG5qMnlRZVdWWjFE?=
 =?gb2312?B?Q2FwNUpmai9nZ21XQlZQYTFkcXVrS3huWXRGTEJmZ3FnOW10eDh4bGllWDY0?=
 =?gb2312?B?MnU0Y3VZUWVDQ2VORGN2dmpPeGp4eGllZ1JFeUhOTHVVdVlDUlhIdDhsTVRj?=
 =?gb2312?B?TTEzQmZaQjBTYWlFVTIzTm1rekk5eGR3RGwxQVd5cFJ2bHlBNERWVGpEa2dm?=
 =?gb2312?Q?HCXUcNQkd8PekAIr9NkKUZq+TuUkmr2vNPlA5jO?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b7ac74-0e01-4773-6bd0-08d8d865e48b
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 01:45:40.9648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1Q4Af+yh5fg+Z4/Uy6mJvA4rapOq+YMDHtkdovsquO+MuSciP/5uILN+eZUbMn6qN4o+x5wmxcXvMiHIWuoBvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjHE6jLUwjI0yNUgMDo0NQ0KPiBUbzogSm9ha2lt
IFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IHBlcHBlLmNhdmFsbGFyb0Bz
dC5jb207IGFsZXhhbmRyZS50b3JndWVAc3QuY29tOw0KPiBqb2FicmV1QHN5bm9wc3lzLmNvbTsg
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gZGwtbGludXgt
aW14IDxsaW51eC1pbXhAbnhwLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBWMSBuZXQtbmV4
dCAwLzNdIG5ldDogc3RtbWFjOiBpbXBsZW1lbnQgY2xvY2tzDQo+IA0KPiBPbiBUdWUsIDIzIEZl
YiAyMDIxIDE4OjQ4OjE1ICswODAwIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiBJbiBzdG1tYWMg
ZHJpdmVyLCBjbG9ja3MgYXJlIGFsbCBlbmFibGVkIGFmdGVyIGRldmljZSBwcm9iZWQsIHRoaXMN
Cj4gPiBsZWFkcyB0byBtb3JlIHBvd2VyIGNvbnN1bXB0aW9uLiBUaGlzIHBhdGNoIHNldCB0cmll
cyB0byBpbXBsZW1lbnQNCj4gPiBjbG9ja3MgbWFuYWdlbWVudCwgYW5kIHRha2VzIGkuTVggcGxh
dGZvcm0gYXMgYSBleGFtcGxlLg0KDQpIaSBKYWt1YiwNCg0KVGhhbmtzIGZvciB5b3VyIGtpbmRs
eSByZXZpZXchDQoNCj4gbmV0LW5leHQgaXMgY2xvc2VkIG5vdyBhbmQgdGhpcyBpcyBhbiBvcHRp
bWl6YXRpb24gc28gcGxlYXNlIHBvc3QgYXMgUkZDIHVudGlsDQo+IG5ldC1uZXh0IGlzIG9wZW4g
YWdhaW4gKHNlZSB0aGUgbm90ZSBhdCB0aGUgZW5kIG9mIHRoZSBlbWFpbCkuDQoNCk9rLCBJIHdp
bGwgcG9zdCBhcyBSRkMgZHVyaW5nIG5ldC1uZXh0IG9uIGNsb3NlZCBzdGF0ZS4NCg0KPiBJJ20g
bm90IGFuIGV4cGVydCBvbiB0aGlzIHN0dWZmLCBidXQgaXMgdGhlcmUgYSByZWFzb24geW91J3Jl
IG5vdCBpbnRlZ3JhdGluZyB0aGlzDQo+IGZ1bmN0aW9uYWxpdHkgd2l0aCB0aGUgcG93ZXIgbWFu
YWdlbWVudCBzdWJzeXN0ZW0/DQoNCkRvIHlvdSBtZWFuIHRoYXQgaW1wbGVtZW50IHJ1bnRpbWUg
cG93ZXIgbWFuYWdlbWVudCBmb3IgZHJpdmVyPyBJZiB5ZXMsIEkgdGhpbmsgdGhhdCBpcyBhbm90
aGVyIGZlYXR1cmUsIHdlIGNhbiBzdXBwb3J0IGxhdGVyLg0KDQo+IEkgZG9uJ3QgdGhpbmsgaXQn
ZCBjaGFuZ2UgdGhlIGZ1bmN0aW9uYWxpdHksIGJ1dCBpdCdkIGZlZWwgbW9yZSBpZGlvbWF0aWMg
dG8gZml0IGluDQo+IHRoZSBzdGFuZGFyZCBMaW51eCBmcmFtZXdvcmsuDQoNClllcywgdGhlcmUg
aXMgbm8gZnVuY3Rpb25hbGl0eSBjaGFuZ2UsIHRoaXMgcGF0Y2ggc2V0IGp1c3QgYWRkcyBjbG9j
a3MgbWFuYWdlbWVudC4NCkluIHRoZSBkcml2ZXIgbm93LCB3ZSBtYW5hZ2UgY2xvY2tzIGF0IHR3
byBwb2ludCBzaWRlOg0KMS4gZW5hYmxlIGNsb2NrcyB3aGVuIHByb2JlIGRyaXZlciwgZGlzYWJs
ZSBjbG9ja3Mgd2hlbiByZW1vdmUgZHJpdmVyLg0KMi4gZGlzYWJsZSBjbG9ja3Mgd2hlbiBzeXN0
ZW0gc3VzcGVuZCwgZW5hYmxlIGNsb2NrcyB3aGVuIHN5c3RlbSByZXN1bWUgYmFjay4NCg0KVGhp
cyBzaG91bGQgbm90IGJlIGVub3VnaCwgc3VjaCBhcywgZXZlbiB3ZSBjbG9zZSB0aGUgTklDLCB0
aGUgY2xvY2tzIHN0aWxsIGVuYWJsZWQuIFNvIHRoaXMgcGF0Y2ggaW1wcm92ZSBiZWxvdzoNCktl
ZXAgY2xvY2tzIGRpc2FibGVkIGFmdGVyIGRyaXZlciBwcm9iZSwgZW5hYmxlIGNsb2NrcyB3aGVu
IE5JQyB1cCwgYW5kIHRoZW4gZGlzYWJsZSBjbG9ja3Mgd2hlbiBOSUMgZG93bi4NClRoZSBhaW0g
aXMgdG8gZW5hYmxlIGNsb2NrcyB3aGVuIGl0IG5lZWRzLCBvdGhlcnMga2VlcCBjbG9ja3MgZGlz
YWJsZWQuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiANCj4gDQo+ICMgRm9ybSBs
ZXR0ZXIgLSBuZXQtbmV4dCBpcyBjbG9zZWQNCj4gDQo+IFdlIGhhdmUgYWxyZWFkeSBzZW50IHRo
ZSBuZXR3b3JraW5nIHB1bGwgcmVxdWVzdCBmb3IgNS4xMiBhbmQgdGhlcmVmb3JlDQo+IG5ldC1u
ZXh0IGlzIGNsb3NlZCBmb3IgbmV3IGRyaXZlcnMsIGZlYXR1cmVzLCBjb2RlIHJlZmFjdG9yaW5n
IGFuZCBvcHRpbWl6YXRpb25zLg0KPiBXZSBhcmUgY3VycmVudGx5IGFjY2VwdGluZyBidWcgZml4
ZXMgb25seS4NCj4gDQo+IFBsZWFzZSByZXBvc3Qgd2hlbiBuZXQtbmV4dCByZW9wZW5zIGFmdGVy
IDUuMTItcmMxIGlzIGN1dC4NCj4gDQo+IExvb2sgb3V0IGZvciB0aGUgYW5ub3VuY2VtZW50IG9u
IHRoZSBtYWlsaW5nIGxpc3Qgb3IgY2hlY2s6DQo+IGh0dHBzOi8vZXVyMDEuc2FmZWxpbmtzLnBy
b3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwOiUyRiUyRnZnZXIua2VybmVsLg0KPiBvcmcl
MkZ+ZGF2ZW0lMkZuZXQtbmV4dC5odG1sJmFtcDtkYXRhPTA0JTdDMDElN0NxaWFuZ3Fpbmcuemhh
bmclNA0KPiAwbnhwLmNvbSU3Q2NmZWJmZDBhYWMyYjQzYmE5YzkzMDhkOGQ4MWE2MTk0JTdDNjg2
ZWExZDNiYzJiNGM2ZmE5Mg0KPiBjZDk5YzVjMzAxNjM1JTdDMCU3QzAlN0M2Mzc0OTY5NTUxMzY4
MTY1OTUlN0NVbmtub3duJTdDVFdGcGINCj4gR1pzYjNkOGV5SldJam9pTUM0d0xqQXdNREFpTENK
UUlqb2lWMmx1TXpJaUxDSkJUaUk2SWsxaGFXd2lMQ0pYVkNJNg0KPiBNbjAlM0QlN0MxMDAwJmFt
cDtzZGF0YT1MTHFYOXV0YVRmblY1QlY0Slc2em9ZNzZZelFpT2U5WGxhaDU4Qg0KPiA5anYxWSUz
RCZhbXA7cmVzZXJ2ZWQ9MA0KPiANCj4gUkZDIHBhdGNoZXMgc2VudCBmb3IgcmV2aWV3IG9ubHkg
YXJlIG9idmlvdXNseSB3ZWxjb21lIGF0IGFueSB0aW1lLg0K
