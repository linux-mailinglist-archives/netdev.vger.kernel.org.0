Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C5E32392A
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 10:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234229AbhBXJFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 04:05:21 -0500
Received: from mail-db8eur05on2083.outbound.protection.outlook.com ([40.107.20.83]:31291
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234381AbhBXJEC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 04:04:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fD+PxdEh1ElRiTScpOXkZm7jjsD6ST1dK0U421EL90lMFFqZZi4xx/yDaYJAFtGPe0Yg46jcxrrWmMHSBkxr/j84PH8hQ96cGn4e2lBLaVzbI60FsKtfeRE6kSDvoPcpwJxLL6QzDlaDNsINKKie34EocXeTAQ0NBtYbN/VpOpSD5FKjEkV4hc/1rKDwtMALkjbEmFTjvZ70XTEJFmGrMOnJkigL1AuBZc++DSSOGmoZTDof24wq5pFg4NlHJUnRc4GJ1SglVE9rrNRfP+dWXR17aKNqToMV6Twp0njdHBY+gW6LJOSPFamp1pf6+JSmjQkYhd72H5X8aaOh2kV7Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yeAPp6/PtLUXOBSK516XhKM3Q19UFZbotvxlF2odNs=;
 b=Y3akldrD20heVMg70VLjnQEgOvEScWkL3oNWuiIitS4jLjakT5jVQ/sGO2aXe4w17lYkJTzvJBk5PHCjC2TCe+bPaILs9D0nUuItkOV5bpaxKHpHoOCmt4r0OQs31HosZOdeKDvdXxyX4+8B+i8lOYXZiRv1af88ggZuAsSll2XOyW+nsSZKVaI+BHsaDnSom7/72U3Qnq6y3cN80V+BPHMJ/2d9pNFSgixOwih8qZOuEViIrE9h1kFPQQ0hibNvgP9dzvge6b1mQr4w6RC8iXcwt0wcgGk3ThbCKIn5TZP8RB6qpIJERJSSRqh60r/oQWnGbb65/l0ecX/yMLKQyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yeAPp6/PtLUXOBSK516XhKM3Q19UFZbotvxlF2odNs=;
 b=j9wjf8ne0E0fkb6LMnfVV8PN24rzsSpdpbOKMzpqfEj7Ln/CcsPG5EDKGdNBhGAO8vLB3ZCSbIFES6hMGvmcYczy6Ifgq9aMjuIuh95tWwAkVd/gldRYq3E8MXzElMmaZIah14XVgAFXqO1HNLJOv4LiGLTPsDIZQxHEpcI/xlU=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7628.eurprd04.prod.outlook.com (2603:10a6:10:204::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Wed, 24 Feb
 2021 09:03:00 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Wed, 24 Feb 2021
 09:03:00 +0000
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
Thread-Index: AQHXCdFekWFqiRqYw0qX+7Ua7CCmtKpl8tSAgACRjMCAAAgFgIAAA1yAgAAHzQCAAGlk8A==
Date:   Wed, 24 Feb 2021 09:03:00 +0000
Message-ID: <DB8PR04MB6795FC7C030275F4E6043427E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
        <20210223084503.34ae93f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB6795925488C63791C2BD588EE69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
        <20210223175441.2a1b86f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB6795663DB5336C8BDB16A159E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210223183438.0984bc20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210223183438.0984bc20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 46a626b1-2e47-422e-8984-08d8d8a2fc62
x-ms-traffictypediagnostic: DBBPR04MB7628:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBBPR04MB76289EFD0F3D54B5C08E558CE69F9@DBBPR04MB7628.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hRnhy6EIsd18sls4o4dVmk8PHL22FBGMigyJR/smEQGjvTW9hg9rLgL8Q0uwOfPxNVbJ9w8hDR8G1puSdg+ISHx2C2nZeK6enVJtepwRUNJP+sUwJgDgI/q4oY/ukY2lDcWfeDEUEJp3FG5yNzragFJx0spdEqIfKTC1pZbAiuO7+0mGjMDuf7a4/nIQLLy+m/0qheUX6jXsVVM77nVOwHFxeLV7kl0Z/SIqrPjYX8ejygRGgqiI9/eFg4AHd3rXVPPtRLW5sQFtru+gpdXYShlxVJSimJjISs9qDfn+GnYlxk9IDgiZjes7EOPxqzh1wKxhBR9bM0WJE5y6ftZPon+w6LH/yby5GoG/wuNbHe48BgaIOgwQP/7J6tgSVWaTMBSjbS9Qa2sfY9OWSzlG+R+oal0ouLmtNkKtgHQUh7prOvRx0BEx4T3SWEOlzoN6+S9O9/nRT8YrX6nA/ubV5ArUP9MoxHrllTm7yKUi0cVx5iYoebyUnm1sCOYeYiMmLXd8v4mHQz8PxfnPc/8hxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(366004)(396003)(6506007)(86362001)(7696005)(4326008)(53546011)(5660300002)(8676002)(71200400001)(316002)(66946007)(66446008)(66476007)(76116006)(64756008)(66556008)(478600001)(55016002)(9686003)(52536014)(54906003)(26005)(8936002)(33656002)(2906002)(186003)(6916009)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?gb2312?B?VTJPQnE0RW9SWUkrNWkva3hReDNibTU3YlBRaU9LbUhKTlBmN0s4NHNSeE5m?=
 =?gb2312?B?Z3hJYmpNM3UvWkt2SFZGY1FUV2ljWFlCS0lIZUFjUzZYSk5ya2JISmpPNCtt?=
 =?gb2312?B?RzJOUVZ3eXUvT21LNGUxbFhTYWZOYWZydEI2bFpQdFo3MDhYeWZPeVVyc3FZ?=
 =?gb2312?B?QXI3aVBGdGFkMDhGQ0NHc0dVNEFGcWZtc1R0RkVFdTZwTmV6MVFrYjhacmFF?=
 =?gb2312?B?WUVSQ0prUXRjT2EvN0tPSnI2aCs5d0lVMmlZUjhFOWlBVU5KKzRLSjNnYTU5?=
 =?gb2312?B?S2hPYVhwbmFXU1AyRURacTZoT1d0SXFSS3F0Y1Y3TE9ROXAvZEtMRE80Q3VW?=
 =?gb2312?B?b0dKY1k0YjhTUWg1N3BTTngzNFh5YjVCNGlGMlZiQWI3bVdZY2ZZVGNxblJE?=
 =?gb2312?B?dEczMWMzWm1EMFJBUlN5WkFVWXlpNUswMXBucUYwbG04OEtrSVdjY1dQZ3ZZ?=
 =?gb2312?B?Szk1U1NZZ3hIamJDRTFVckFlbTUxQTZXMEp5N0ZOVElqcVloMnB3c1VUdkJE?=
 =?gb2312?B?clNyb0dFT1RQTy8rRWVSK2hQd0d6Tm1lQTZoYnY4Y2o4TkVjVTdScS9tbHVt?=
 =?gb2312?B?TWVKR3hvN3RrdnBMVXhFRnZ1dlVVdFRWWVVZaERreDVURTRHWHNWc3VWcFdw?=
 =?gb2312?B?b1Flck5UQTJwR0UxOFlMSmZHSW9VVjRhNnZkOHlDU1FkNTJCTGR5bXlPUTlB?=
 =?gb2312?B?dkNkUER4WDc1ZUVVV1pURDRyaXk5cVFQN1BhU2N2YytRdW9iajhuQWRyTSs0?=
 =?gb2312?B?UVB1MzFESy9DV2FwL0V2cW9CRlpoeFNyUUVKL2IzaGZOUHdpdnpsTkFYVHZL?=
 =?gb2312?B?WUtaTytIVFgvQTl3dExoaVZGTWZ2VDhlTHRvSTgwQUpWWW10QTBJczMwKzJn?=
 =?gb2312?B?SmNNZDdicU9pYWZiZGRTVUVscVAzU2UxTG5SQXVGRnJMYk80TzIvdkkrbHJO?=
 =?gb2312?B?dUtDbjVjcGFGRXh0cnpMVGM3eU92a2o0QUpqUUt6ZVlFU25BRXQ3SWwxUVhi?=
 =?gb2312?B?ZHIydmRyZFJDQVdaUUU5N2tDRWNBWlN3WFhIam11a2xFcmVBZjJRdlYxcFN1?=
 =?gb2312?B?R1lGVUVoeHlrSk9sdGsyVElMbjltV1FKZTQxSTNoS0FDWW5OYkxXN3hvU0VJ?=
 =?gb2312?B?bXdrR1U2a3E4d0ZWREg0emo2MnJudUNaSjI3b0VmbnZpcHRRbWl2aVJoMTFX?=
 =?gb2312?B?dE1vZjZWQkZ0VDc3c1lodDJiaE1DSjFGWHMwMVI2NWZmeWh1NVByZiswWjlw?=
 =?gb2312?B?UXlLMGFJWkY0dmgxaWJGYmhGR1dDVVd1S0tqQWlUSVZya0twWW5YdUtBWUZa?=
 =?gb2312?B?eGRrQ3dZUjlYRGVSb25odTRvdm1jSmhrZFhuNEl6bmRybk5LZGl1SkZxZlJI?=
 =?gb2312?B?NW80K2hydENGZ3l5MTJJT2t1RTFWSkZyS3BSWVNaOGhGVkcyTkV2T29sWmpQ?=
 =?gb2312?B?cTI0VW9ZRjNUWmFQQ2x0ejRRLzVLOThsU2lvNFVJdDBUZ25qNTdpaCtoTExJ?=
 =?gb2312?B?WnhHZUdaMXdYU0IvNjdaL04rRXVGaEF0ekorai9pZm9QcktNMFJwZGlrdkli?=
 =?gb2312?B?VFhwdEtXWnBYYTY2L3VjTXRQUjVUeTBmeCtUOHAvWHFYaDFyL1VHSXhieitF?=
 =?gb2312?B?MGRiVnE3UCttZzJoeWpRTXh3RGZseiswRm5GSk9HUTRyQ2NpUXNZMmhNa0ND?=
 =?gb2312?B?Z01zQURMVGpxUVRON1U4dEdiWldWZ3pVTEp5TmRlWGdUVHdyQVV1N291b0hz?=
 =?gb2312?Q?57/C8LhWOSrDA+6jXVI/pciANzxdjbArOtuT07F?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46a626b1-2e47-422e-8984-08d8d8a2fc62
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 09:03:00.2099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nby1s8rcUwJ+Eo2Orn3hQNVyxQtDj+OdrVlNE7Eb9U/SpNgqxSi9GEOW5UuKv4nZtPSAz+zqT9B+TFcEZ7gDvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7628
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEpha3ViIEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjHE6jLUwjI0yNUgMTA6MzUNCj4gVG86IEpvYWtp
bSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+DQo+IENjOiBwZXBwZS5jYXZhbGxhcm9A
c3QuY29tOyBhbGV4YW5kcmUudG9yZ3VlQHN0LmNvbTsNCj4gam9hYnJldUBzeW5vcHN5cy5jb207
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGRsLWxpbnV4
LWlteCA8bGludXgtaW14QG54cC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjEgbmV0LW5l
eHQgMC8zXSBuZXQ6IHN0bW1hYzogaW1wbGVtZW50IGNsb2Nrcw0KPiANCj4gT24gV2VkLCAyNCBG
ZWIgMjAyMSAwMjoxMzowNSArMDAwMCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4gPiA+IFRoZSBh
aW0gaXMgdG8gZW5hYmxlIGNsb2NrcyB3aGVuIGl0IG5lZWRzLCBvdGhlcnMga2VlcCBjbG9ja3Mg
ZGlzYWJsZWQuDQo+ID4gPg0KPiA+ID4gVW5kZXJzdG9vZC4gUGxlYXNlIGRvdWJsZSBjaGVjayBl
dGh0b29sIGNhbGxiYWNrcyB3b3JrIGZpbmUuIFBlb3BsZQ0KPiA+ID4gb2Z0ZW4gZm9yZ2V0IGFi
b3V0IHRob3NlIHdoZW4gZGlzYWJsaW5nIGNsb2NrcyBpbiAuY2xvc2UuDQo+ID4NCj4gPiBIaSBK
YWt1YiwNCj4gPg0KPiA+IElmIE5JQyBpcyBvcGVuIHRoZW4gY2xvY2tzIGFyZSBhbHdheXMgZW5h
YmxlZCwgc28gYWxsIGV0aHRvb2wNCj4gPiBjYWxsYmFja3Mgc2hvdWxkIGJlIG9rYXkuDQo+ID4N
Cj4gPiBDb3VsZCB5b3UgcG9pbnQgbWUgd2hpY2ggZXRodG9vbCBjYWxsYmFja3MgY291bGQgYmUg
aW52b2tlZCB3aGVuIE5JQw0KPiA+IGlzIGNsb3NlZD8gSSdtIG5vdCB2ZXJ5IGZhbWlsaWFyIHdp
dGggZXRodG9vbCB1c2UgY2FzZS4gVGhhbmtzLg0KPiANCj4gV2VsbCwgYWxsIG9mIHRoZW0gLSBl
dGh0b29sIGRvZXMgbm90IGNoZWNrIGlmIHRoZSBkZXZpY2UgaXMgb3Blbi4NCj4gVXNlciBjYW4g
YWNjZXNzIGFuZCBjb25maWd1cmUgdGhlIGRldmljZSB3aGVuIGl0J3MgY2xvc2VkLg0KPiBPZnRl
biB0aGUgY2FsbGJhY2tzIGFjY2VzcyBvbmx5IGRyaXZlciBkYXRhLCBidXQgaXQncyBpbXBsZW1l
bnRhdGlvbiBzcGVjaWZpYyBzbw0KPiB5b3UnbGwgbmVlZCB0byB2YWxpZGF0ZSB0aGUgY2FsbGJh
Y2tzIHN0bW1hYyBpbXBsZW1lbnRzLg0KDQpIaSBKYWt1YiwNCg0KSSBjaGVjayB0aGUgY29kZSwg
ZXRodG9vbCBmcm9tIHN0bW1hYyBkcml2ZXIgb25seSBjYW4gYmUgdXNlZCB3aGVuIG5ldCBpcyBy
dW5uaW5nIG5vdywgc28gdGhlIGNsb2NrcyBhcmUgZW5hYmxlZC4NCm5ldC9ldGh0b29sL2lvY3Rs
LmMgLT4gZGV2X2V0aHRvb2woKQ0KCVsuLi5dDQoJaWYgKGRldi0+ZXRodG9vbF9vcHMtPmJlZ2lu
KSB7DQoJCXJjID0gZGV2LT5ldGh0b29sX29wcy0+YmVnaW4oZGV2KTsNCgkJaWYgKHJjIDwgMCkN
CgkJCXJldHVybiByYzsNCgl9DQoJWy4uLl0NCg0KU3RtbWFjIGRyaXZlciBpbXBsZW1lbnQgYmVn
aW4gY2FsbGJhY2sgbGlrZSBiZWxvdzoNCglzdGF0aWMgaW50IHN0bW1hY19jaGVja19pZl9ydW5u
aW5nKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQoJew0KCQlpZiAoIW5ldGlmX3J1bm5pbmcoZGV2
KSkNCgkJCXJldHVybiAtRUJVU1k7DQoJCXJldHVybiAwOw0KCX0NCg0KQmVzdCBSZWdhcmRzLA0K
Sm9ha2ltIFpoYW5nDQo=
