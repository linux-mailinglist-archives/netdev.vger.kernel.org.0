Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D97763C9875
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 07:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239904AbhGOFcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 01:32:39 -0400
Received: from mail-vi1eur05on2068.outbound.protection.outlook.com ([40.107.21.68]:63713
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238709AbhGOFci (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 01:32:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWqPNQpOLpmFZsGZn3UkDA0egrasPwKzcQKjj68YDQUwt6N0miexnDmKg2NrG0XsJyFf2xF5n1HYDHKixdNUZTbOsC68+ijmpLlemkyQd3WFWGWo0gYvCTlSCvGqaA661hQoRK/jzp5tXr9FWFh2u52qTk/Qns0XZ6vZ91LLd7jGExr426sDT2Juw3gH8A4lJSH2wGu0Bqr2RBr5CLizFTtiU20J0VbXQa+R+dYiDJqPsuKOcpuMvX6aGnwKjjDVH5a+uJSFm4u35kbFr6bwctoXHkKio1xLjeb9Zwm+GiwrCDhL0u4baOkyhgxGS0pZm5vyLw6OxKimenvdbQN0FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DK+jo4Fi4PLKIMGRW6ZFG3g88II8dF9ysvKtNp+UfH0=;
 b=dJxPQe4nHv53/m2h8OssCIO0rRlB5bSEoHvtVuEcb26De2mcTlVdU+BvxCgSGxpax1WNTFbkkSoRDXKE/uoaFU313JEfQCxDrfzeo8W/gGfHuDiGa5Ub8Lzv6Tj634lYfCP+S5yWOTM6s+3OyeSRPoez3ODtbH5t4z9/4n39gbW9K10KvGpMT4CO5r97nhV21pdG/rJqbcJb4g5kQjaeDNL68/FY5CjIa+K/y++3j8SDm6COgBIpO64NFp0LCRPurEHIaNjlh3SZz08cdfKBdSkDlOh7JaqRIKFmVqimcXNF66AFtdSdtXAYBmEQBSBlLBWLqFqPs15RgWMlcdHjtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DK+jo4Fi4PLKIMGRW6ZFG3g88II8dF9ysvKtNp+UfH0=;
 b=IBJ/MvatBWwJA9AEn2HsAzQso0UqxMGYtNnjfhBXO4h3MK12QHGQG6rMjjGd89PTAyXVk4lTVKYixkeXLSI/skwxmMAqSqK2xSW8dblH7JKSTQQ2Kvfh8ztNo/2kcVVz3VlfvEfFQlb1mB3ONFz9XQQCyW+6h2wM/TVkJJExu+0=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3850.eurprd04.prod.outlook.com (2603:10a6:8:3::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 05:29:43 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.021; Thu, 15 Jul 2021
 05:29:42 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Rob Herring <robh@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V1 net-next 1/5] dt-bindings: fec: add the missing clocks
 properties
Thread-Topic: [PATCH V1 net-next 1/5] dt-bindings: fec: add the missing clocks
 properties
Thread-Index: AQHXdJrlALbhC475AU6Oxx+677UChKtDJBsAgABnH4A=
Date:   Thu, 15 Jul 2021 05:29:42 +0000
Message-ID: <DB8PR04MB6795E1FEE11395000374B048E6129@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210709081823.18696-1-qiangqing.zhang@nxp.com>
 <20210709081823.18696-2-qiangqing.zhang@nxp.com>
 <20210714231914.GB3723991@robh.at.kernel.org>
In-Reply-To: <20210714231914.GB3723991@robh.at.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ffee318-ee0b-4a9d-89bc-08d947518cbb
x-ms-traffictypediagnostic: DB3PR0402MB3850:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB3850A0C53BB435A7E1105FFEE6129@DB3PR0402MB3850.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZfI2/6fyhF3SYRUVO1EysHWN3piQcl+bgf2m9e0j7SSqALoS+8W4ZHPk2QNcR4BaLwZxIKaWt4SlihZ5ZHAzuYCodR8AwXX6EOJjhPYjqtdJ/HraxRYYJN9xyRDx7VQlMSdxYVfnp1sUY6/BL6kNsvx0JaDLLLqJedFwEpQd6b0zdU/G5QrSjrC1k2BeRVbi2SBYc833Zw2fFqoTzIHTz9NCO9EIf5KB0nLuFjudukRn1j8GgVddubVG7zINtRgZYu1sJFrNj4EWLltpgyYd05Fob91pfU/M6LnFCBrC+LwWKlVF66VVQlKGqDEyvP1ajMbi57m1gfoltS82dBCSJNFs4cCXrqgbWNp2MTsnHFauH+YcL+ttImNLPX9OVPkWoMsNokcN3J//iUsJr5eyNAIOhMPbuYeVRbWbjvXHLf6CjqenYigYDrGrhw7epo9nXyjo/Td8UPlPgsi1W3JpddkOtJ2qSdZLVd/8L5ok9DfO0trQarJwIvbgd4yBWUgRAzL2QMBzb2/2T1qJC3SrCfjMdDfsrTpHUbdYzUPKHdADtAANbjYVq1fNpAbu9py1khfI8JnI+LYEnfXLO+fOEI44GFzmttVZrRV7914CD0PPxXCFkQYWMG551GhhncecVoQf+oR1NJ7hHK8H+V9pgd6Eq3/efyQ74J/JvuFxBnM+Bim0FldtCubRA20XLrwzps9b3jTrMdV2Bh2OnYKbZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(6916009)(52536014)(186003)(55016002)(122000001)(2906002)(8676002)(38100700002)(316002)(33656002)(5660300002)(8936002)(64756008)(76116006)(66446008)(66946007)(26005)(66476007)(54906003)(66556008)(7696005)(86362001)(6506007)(478600001)(83380400001)(4326008)(71200400001)(53546011)(9686003)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?ZHJ2NzFyOFhGbUNuc3h0N0lrV2dqQVNTd1doZzNLMUdUQ2dnZnBIMVYzbFpQ?=
 =?gb2312?B?Z01HUFZ2Tm5wUmtlc1c0R2hmOVpDQWNZYkpaVVNsQzFjUkI4cnNxZDkwd2Vu?=
 =?gb2312?B?VjJ3QnBwMU5ZczBXUDFoUWRibFRrOHpQYktGOUtWdmFmNlBWYzJGcE5EQ1ht?=
 =?gb2312?B?T0c0ampaTGRmUXZWazRQZk83OTVEOVR0aHBxSWtwZC9rMFlJeFBlVlo4OHlN?=
 =?gb2312?B?YWdKMkFuUHVjNzF6cHBwYWJ1RkpvRk85TDQxNDlVUFQwNk0ySkkxckJwSlJZ?=
 =?gb2312?B?RHNFSEplb0ErSFZsZUFKM3pFV3B2aTc0SzQ0bXp6Q2htU3pEUEtFUGgzUitV?=
 =?gb2312?B?ZHk3VVFKb3BJRDN4aFNPMTVCVm5XSEFQVGp6ZSt6ZWFIcXlWbTVPK2pBSnAv?=
 =?gb2312?B?cFVERERPQlZhZmM1ZEdJQkFDWU15N1Rrd29lYS8zb0FsTm5DQWIwMlpEQ0Jx?=
 =?gb2312?B?SSsvRHNETzdPckk2ZmNtMVRtRy9JM2JubUxlMzRvSUltVHdKYWIrVTIzSEcr?=
 =?gb2312?B?K1JuUDQ0UkVYSHZxbTVkNnB1SWZVU1RSUlV4MnV6V3VMWURpNS9zdWJ5U0Ju?=
 =?gb2312?B?MThOb20vMDJTU2ZVVGRvRTI2cSs3ejY3Rm1TYzZrYVlLNlA4QWs4YlAyU3Nn?=
 =?gb2312?B?R1JCejdFNXdNT3hMZi8zbGlZclk2VkhGcGViZ29PRk1GdnhscGFTeWc2MWxU?=
 =?gb2312?B?Sm9HZHlvNHNFS1orcllqSTdBYlE2VFdqbXFFWDUyQjJKK21FTml4TW9Rak5j?=
 =?gb2312?B?WkdiTDcxSUZzU0dKNlZLUURFZ2lpQ0w2Uko4UWlqaW9TQ2hJaUJZaFFaNFI0?=
 =?gb2312?B?ZTkrdHZhSXI5dnJQMDFmVmZOdlBmdFNKRDRia3hEU3dEVFlTTnVERE5GbHdM?=
 =?gb2312?B?MnBkVXlSN1ViaUptdFlUdEtzWGFvWGVJTENqeE1wdkhCQ3BhbituUXNPOHNY?=
 =?gb2312?B?bHdwUVpkYkRpeXBIMC9EcGVGYmQ4WStyWTZ4ZjFac2E4dFdhcmp2WkFPU0sv?=
 =?gb2312?B?dlJmc0FOcjJiNnZKYjF5MlhPZ2FEaTlpVEVMSXZycExkSndaVWtyd3ZLQ2RP?=
 =?gb2312?B?N0VtdUNhaVJTQzRUQUQ4UWtVaEczWS84cTFIUk9iRlhrbU1iNXQ4UlFLZzRl?=
 =?gb2312?B?a1pwOUdwalJuWm5qRTNkWEVjbHR5Rzh4VkNwR2pzcWZ3N2tYL2Y1RjZTVlpG?=
 =?gb2312?B?Y2NUOXhRSC8xUlVHNmVRUlpQSHFWdEhmMlZnR3lIZlAwYmVNaVE0MW5Saytu?=
 =?gb2312?B?NzVSQiszSXJiclQySVdyVHJNdmNCTVFja0N3WkdMdW1tdzEwaE1DQVlOaW1k?=
 =?gb2312?B?cjJnU2ozdFBSRGhJYnNDQy9XVTNzRWpXUkhlRFhtazc3bWhqQU9TdEpRRlBh?=
 =?gb2312?B?L3F2VHBaTXNKdUdwUlRSVWtCeUkwZnNJd281TkVlM2JvMDhDUVRXblJ1Szls?=
 =?gb2312?B?blZXRkU1dXpMWUtLdTJETnM5Z0M3Ny8yajlHamxrbEhMMS9XOXl1S3lLd1Ay?=
 =?gb2312?B?S0YvcTZKSXlsejJpUFE3MExPciszVWtYZ09ldXhqMElKRmhVWkRYYWtFbUpx?=
 =?gb2312?B?MWFmcEttenVWbjNXS0RvcThmM3k1cTRiYTIvWVdybVEwUG14ZGdNbTFKMG14?=
 =?gb2312?B?Z3JsSVA5V1FsNXFORjdEVWZYTGFOQ1Z2bjc3cjFQZkhmRTlYZEx3VDZnRWtl?=
 =?gb2312?B?djZ5ZjJ3cUkyTzh4bHJ6ckF1czhVcUg4azNzaThRQU55YXN5ZEFrY0NxV1lu?=
 =?gb2312?Q?M9IgVoSegNotHu3pg0=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ffee318-ee0b-4a9d-89bc-08d947518cbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2021 05:29:42.7883
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FKE5RmsmaqRw8gYihcHkJnS67E5mWePuDPrxVG2/PJ8nD4RZGxL30GnjSzMo2r0y5r/njbxRo5lUYC2mBQ8jkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3850
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJvYiBIZXJyaW5nIDxyb2Jo
QGtlcm5lbC5vcmc+DQo+IFNlbnQ6IDIwMjHE6jfUwjE1yNUgNzoxOQ0KPiBUbzogSm9ha2ltIFpo
YW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
IGt1YmFAa2VybmVsLm9yZzsgYW5kcmV3QGx1bm4uY2g7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJu
ZWwub3JnOyBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTog
W1BBVENIIFYxIG5ldC1uZXh0IDEvNV0gZHQtYmluZGluZ3M6IGZlYzogYWRkIHRoZSBtaXNzaW5n
IGNsb2Nrcw0KPiBwcm9wZXJ0aWVzDQo+IA0KPiBPbiBGcmksIEp1bCAwOSwgMjAyMSBhdCAwNDox
ODoxOVBNICswODAwLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4gRnJvbTogRnVnYW5nIER1YW4g
PGZ1Z2FuZy5kdWFuQG54cC5jb20+DQo+ID4NCj4gPiBCb3RoIGRyaXZlciBhbmQgZHRzIGhhdmUg
YWxyZWFkeSB1c2VkIHRoZXNlIGNsb2NrcyBwcm9wZXJ0aWVzLCBzbyBhZGQNCj4gPiB0aGUgbWlz
c2luZyBjbG9ja3MgaW5mby4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEZ1Z2FuZyBEdWFuIDxm
dWdhbmcuZHVhbkBueHAuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+DQo+ID4gLS0tDQo+ID4gIERvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9uZXQvZnNsLWZlYy50eHQgfCAxMSArKysrKysrKysrKw0KPiA+ICAxIGZp
bGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKQ0KPiANCj4gVGhlcmUncyBlbm91Z2ggY2hhbmdl
cyBpbiB0aGlzIHNlcmllcywgcGxlYXNlIGNvbnZlcnQgdGhpcyB0byBzY2hlbWEuDQoNCkhpIFJv
YiwNCg0KT2ssIEkgd2lsbCBmaXJzdCBjb252ZXJ0IHRoaXMgYmluZGluZyBpbnRvIHNjaGVtYSwg
dGhlbiByZXNlbmQgdGhpcyBwYXRjaCBzZXQuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFu
Zw0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9uZXQvZnNsLWZlYy50eHQNCj4gPiBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9uZXQvZnNsLWZlYy50eHQNCj4gPiBpbmRleCA5YjU0Mzc4OWNkNTIuLjY3NTRiZTFiOTFjNCAx
MDA2NDQNCj4gPiAtLS0gYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2Zz
bC1mZWMudHh0DQo+ID4gKysrIGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25l
dC9mc2wtZmVjLnR4dA0KPiA+IEBAIC0zOSw2ICszOSwxNyBAQCBPcHRpb25hbCBwcm9wZXJ0aWVz
Og0KPiA+ICAgIHR4L3J4IHF1ZXVlcyAxIGFuZCAyLiAiaW50MCIgd2lsbCBiZSB1c2VkIGZvciBx
dWV1ZSAwIGFuZCBFTkVUX01JSQ0KPiBpbnRlcnJ1cHRzLg0KPiA+ICAgIEZvciBpbXg2c3gsICJp
bnQwIiBoYW5kbGVzIGFsbCAzIHF1ZXVlcyBhbmQgRU5FVF9NSUkuICJwcHMiIGlzIGZvciB0aGUN
Cj4gcHVsc2UNCj4gPiAgICBwZXIgc2Vjb25kIGludGVycnVwdCBhc3NvY2lhdGVkIHdpdGggMTU4
OCBwcmVjaXNpb24gdGltZSBwcm90b2NvbChQVFApLg0KPiA+ICstIGNsb2NrczogUGhhbmRsZXMg
dG8gaW5wdXQgY2xvY2tzLg0KPiA+ICstIGNsb2NrLW5hbWU6IFNob3VsZCBiZSB0aGUgbmFtZXMg
b2YgdGhlIGNsb2Nrcw0KPiA+ICsgIC0gImlwZyIsIGZvciBNQUMgaXBnX2Nsa19zLCBpcGdfY2xr
X21hY19zIHRoYXQgYXJlIGZvciByZWdpc3RlciBhY2Nlc3NpbmcuDQo+ID4gKyAgLSAiYWhiIiwg
Zm9yIE1BQyBpcGdfY2xrLCBpcGdfY2xrX21hYyB0aGF0IGFyZSBidXMgY2xvY2suDQo+ID4gKyAg
LSAicHRwIihvcHRpb24pLCBmb3IgSUVFRTE1ODggdGltZXIgY2xvY2sgdGhhdCByZXF1aXJlcyB0
aGUgY2xvY2suDQo+ID4gKyAgLSAiZW5ldF9jbGtfcmVmIihvcHRpb24pLCBmb3IgTUFDIHRyYW5z
bWl0L3JlY2VpdmVyIHJlZmVyZW5jZSBjbG9jayBsaWtlDQo+ID4gKyAgICBSR01JSSBUWEMgY2xv
Y2sgb3IgUk1JSSByZWZlcmVuY2UgY2xvY2suIEl0IGRlcGVuZHMgb24gYm9hcmQgZGVzaWduLA0K
PiA+ICsgICAgdGhlIGNsb2NrIGlzIHJlcXVpcmVkIGlmIFJHTUlJIFRYQyBhbmQgUk1JSSByZWZl
cmVuY2UgY2xvY2sgc291cmNlIGZyb20NCj4gPiArICAgIFNPQyBpbnRlcm5hbCBQTEwuDQo+ID4g
KyAgLSAiZW5ldF9vdXQiKG9wdGlvbiksIG91dHB1dCBjbG9jayBmb3IgZXh0ZXJuYWwgZGV2aWNl
LCBsaWtlIHN1cHBseSBjbG9jaw0KPiA+ICsgICAgZm9yIFBIWS4gVGhlIGNsb2NrIGlzIHJlcXVp
cmVkIGlmIFBIWSBjbG9jayBzb3VyY2UgZnJvbSBTT0MuDQo+ID4NCj4gPiAgT3B0aW9uYWwgc3Vi
bm9kZXM6DQo+ID4gIC0gbWRpbyA6IHNwZWNpZmllcyB0aGUgbWRpbyBidXMgaW4gdGhlIEZFQywg
dXNlZCBhcyBhIGNvbnRhaW5lciBmb3INCj4gPiBwaHkgbm9kZXMNCj4gPiAtLQ0KPiA+IDIuMTcu
MQ0KPiA+DQo+ID4NCg==
