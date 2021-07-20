Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1ED53CF31A
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 06:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346248AbhGTDlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 23:41:18 -0400
Received: from mail-eopbgr40078.outbound.protection.outlook.com ([40.107.4.78]:21931
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346279AbhGTDjo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 23:39:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RkIS2M47/HOvG3Jy1Y3qTmangdNcp0kDE8u45OaL/xUfdRubpCJ6S3htUTQ31Lsx+D6dEIWbX8655bjjYDo3M0PEkQfDcv9owO3BPYg/6UvIHuiYyQZwx0XeW1/v4Q1bkPIj3HtXSAsU2OQFKUHdlO9bi4oUwxjufNHzDLNjetKmYnpGxTkpB/Qjcd3H6ocoVYZxCQdZNMFF6Qe4pXIUZxixNNlxnDbNVzrDiBnuOdpeOWBaCuKUzdvaa6NNwLP8qJ90j93gnbegC/wvJwSdnxsua6k0dwPjrh+jYyy+xLKxkKGzsK8pUdDSbG8liA3DbZVyT3WFA8XHqoMcEkbEdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUBY1U+U32H3Keociy0As3KZn2aiQNqGYbMxqnSh6A0=;
 b=O+itqqyb9LBgBraVI3qtIJS69a9fgcYz5kZ1Cg3ikvROcP0NlgE90khBwQp+jx2ufe1sjPzc44gegm2CMnxTBYM+J6C1pRAe6CVKSl2N7K9dEce/AFuWh+9uf+sIjGXYbAB13rXxYi6ErZdJbyPmPJ/t8tlmuHAFao1Hi6GtnCyodPc30lddfS21IS5ubxxeanOMvf2C9Z/XSZF/g/I9wuGqZqhVshhurEsO2e6OzzV4faHABWSHdYrw9kZAhacBpIUC0eJ6mcjqLSxUC+3oN3wiOiiqRIHHXwjipzQSkHEgg+WU5/ZzrWl3kJ+RMW7OcDFt/NNVn5Q05m2bJzeIrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uUBY1U+U32H3Keociy0As3KZn2aiQNqGYbMxqnSh6A0=;
 b=c9J+EAWMKhg65cBXD4A+fHQZi4riaAYrXbCoOHqHvj2xc9rIeIaRM6RNeoMqsPkvn+XqkOjgrUbBmPNZjVjdSzdtXlCWxuPI7Wfxmmcql3wOTZA7fhSEQOoEtpfNs9W/peRjyO3UCx8Oxea8EkHQSNP1TLbXSC3fPhGQ000RjYk=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB5884.eurprd04.prod.outlook.com (2603:10a6:10:b0::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Tue, 20 Jul
 2021 04:20:20 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.034; Tue, 20 Jul 2021
 04:20:20 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH net-next] dt-bindings: net: fec: Fix indentation
Thread-Topic: [PATCH net-next] dt-bindings: net: fec: Fix indentation
Thread-Index: AQHXfPWQ7GmCRpRINUO0VyQw3NAluqtLNMyQ
Date:   Tue, 20 Jul 2021 04:20:20 +0000
Message-ID: <DB8PR04MB6795964A5094B68FEF242977E6E29@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20210719232639.3812285-1-festevam@gmail.com>
In-Reply-To: <20210719232639.3812285-1-festevam@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f69e5c7-4d15-44f6-fa07-08d94b35afab
x-ms-traffictypediagnostic: DB8PR04MB5884:
x-microsoft-antispam-prvs: <DB8PR04MB5884FB65BBAAEB4DFA3F2B91E6E29@DB8PR04MB5884.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bNOAwhKSj0wjFGhLe/cNstd+ZOwgO+oiwHLJQ10+icJV0JfLOI2I4nHHp2OhmRbLpXWQcGLoNRgukbrgwgT/3ik2sYm22OfL3irF9ov4c+/rVQl3UWveKegufzL5dUtpolaSGL+7IDz5cjhWSsSmtkMOY9IyPMvJ6Jpcha3vLhtUZUn1usze09iirP/2FT5hBALYVdFF/7ewsmj949dJhZXQhoZfFrHecZjRjnC9KOiemR4GR2XgusYPb7FShuH/UhnPvdIfa5BHe7QKp4YHcG7q7EcQsMWJf5yyV6mP/SJKWHuT4oOl6D4eVXe2TxWY+0wgFAsNlsPdGYIrwQe8ce7t4ekdoAajXLG396qgR3semj2xHq174i8vcYvq0LRDQ4syTw5pPFLhUY23XyKChnrgc3m5I5mu14hualTTkrLJkqvck9tdiiw+2v3lZA1Y0Ktzr/LlculowRtkUT366A4CYL+YZrBLketWbVih18zAlLqBfx+Te7ORjZQhBu9uUPGqUHxTHKeJpOuf0Q0BF4aEqGdj1w6Asyv6td18LxNC2OiPWDjbrYqTjSE1x2L/VEppTG0HqfS8xmxtwvGeaWj9k/Zt16iqRhle3gzVULXfPO0hHGU8Eq4ATFiIKPPR1hMV7IUNSAQqe/te4rSgBt+EOuiHlJgT8tB6GdvzgGjnB8ABN0dd4ajcr1SFvKjfJuez+XkDo6BE7/az2vCcBw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(86362001)(316002)(7696005)(6506007)(8936002)(4326008)(5660300002)(478600001)(52536014)(110136005)(33656002)(9686003)(55016002)(53546011)(54906003)(186003)(66446008)(66556008)(64756008)(66476007)(26005)(76116006)(83380400001)(38100700002)(66946007)(8676002)(71200400001)(122000001)(2906002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?MGhBSmt1em9WTHR2bnZlbTlOQVVkcHphdTNadEJnTkdyK25BSTJXR3d6ZS9h?=
 =?gb2312?B?d3l0MXJqYkN0MWprZ0dPSVZPN0gxTURCZHlCa2VkU3ZaazhFSXMzdVF4ZEl5?=
 =?gb2312?B?M3FFalIweXJmSG4wbFAyd3JTYUhrVjlpQ0swWTdsQ09SZzROc0VNd1ErTFdp?=
 =?gb2312?B?YzNTbEMzYjNZQ2p1MlRsNzRERmJXbFVEZ0FRUGFudFEyeXpGS2YycnorcVhP?=
 =?gb2312?B?OE9CWmhSUFpQb3pKcEFEaUJtK3pFd3lxalVCdlNnTFp4TGRzVzB0TnRLWnRM?=
 =?gb2312?B?RE9zNlZHZTVZZmgvdFcySVRoL09uNjlpTzd5emhId0xYbnlsbFAxdGlMbms5?=
 =?gb2312?B?ZEJVdlo2OHYxb25MbnNpendMWFBUdS9Tbkd5dGdTNzBqbC8xcW8yWUVONEZK?=
 =?gb2312?B?THdxMS9pTzIvRXZsc00yMHhiRTVRQ3VpOTFrQlAwLzVSVGJ4Yk1GSXZPY252?=
 =?gb2312?B?Sm1FYWx0YkVDbDI0MmFpWStsNFdDMWxVZzFhY0NKOHpUZnEvU2ZtWEdwalpK?=
 =?gb2312?B?aXZNaW9vK0FvRDBiVlVWbTNqaTErTWo0YzhQZG15Z0I3dGZReG9uRTltUGFa?=
 =?gb2312?B?blF6S3hIOU81MjIxYUFvV1IwTGhSM3I5QVJNUnpSUVVmZ0lnK3V3R0xaeXZN?=
 =?gb2312?B?bW5CYlhFZUpZVTYzSXJmS3phMmZ4WFNGSENGck41bXhGS0NldTFYL3c5bUFI?=
 =?gb2312?B?bHhvWlN2cy8xbjZaUEF4RVJwM1pzZU1PeGxoLzlQT0pvQUw0TXptYmkwRHVJ?=
 =?gb2312?B?QlgwZFJtelVCUXU4NzBhTjE1UGFUWFRWVzZsbWxtZTBySnlRYVdJaGdoU3VW?=
 =?gb2312?B?TndpVlJIR3JEUnl2UjU1TlZCM29wWnRzMzNadHU0dVlRK3VXbFdKdFRFcWVC?=
 =?gb2312?B?QlM2Qm5pYUlKU3hieGp1RG95bWJEVlhMTFdUdStkT0tMZVlDZUNUQjVQN0xM?=
 =?gb2312?B?cTQwc0RtNVU0UGcwVkFlVHU5OTlQVmdxQ1N1ZEpUbGFaczFIMEZtditMWFQ3?=
 =?gb2312?B?blUxQnZRb00vNHNwaGsyamRlZDB6S3hOekY3MThMZ1RUdy9WcG9BOFREcVNi?=
 =?gb2312?B?MlpUV0xyUXc0Z2c1OUxYRE5GTVRzbTJrZ2U3WkJWcEVQVFJWS1Nua3ZQR1lJ?=
 =?gb2312?B?VUlRWGduemI2dzlrRlNSZ29jOEJnMXRteDUvSHhyVjJmdnlpNU1hekR4eHFD?=
 =?gb2312?B?bHY0ak45UEJLcExSVG10WHkreHhPQWhBVkhBUC9PUGlxMm1VQU9EbndBMVUr?=
 =?gb2312?B?TE1kNEdPQXZCanhLNTM0TW00STQ3dWprY0hPSXIzRmw2YlVlNUxJeU9vSkFB?=
 =?gb2312?B?Q2grL0NueEQ1OEZoamtZSXdIaVRMWHpFOWRrOEJuSDJXT2F2c3I5YVlWTEdl?=
 =?gb2312?B?aWVZOUpaaFJaSC96UDlkQkwyUGtBMWtvenJEYXR6dXdTUEVuNDhlMHZ5aElD?=
 =?gb2312?B?MmpvZkdNQUUrUFhLbm1VRG1QeEx3UVZKRmNNMTVocnlRUCt6azRuYm9XUU9t?=
 =?gb2312?B?YU8xbXEvNFB3UDNXcGM0ZlF0Nk55Z2p6NGc2Nk03WDN1YzBqTkVhaTU1TWxP?=
 =?gb2312?B?YkEvb3Bta3ZlcTZPOWlGTU5pSFhqREJScXFyb2F4V1M4eTJjbXVwZytoNGR1?=
 =?gb2312?B?R2Rya3ZUTkl3OXNiN3ZDM3JOVEdOelZMdFlvN0gwbGxOaU5HdUhGb1lXd1JU?=
 =?gb2312?B?a0JxeHkvTTFCY2pKb0IzNGNxc2tVcFZCbWsreDRFa3FkOWpTcy9nWHJ2and5?=
 =?gb2312?Q?gr+lcM/2GGj5EVaKL2bBMFgqEmVYLVIJaXCkP27?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f69e5c7-4d15-44f6-fa07-08d94b35afab
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2021 04:20:20.1373
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EMw7k4oMbCnIMYsba7fm4aHovPF77EpRhe5Bfkj70maYbFevYtJy8ggvLyZjsH7csp1tGIkQAlkgAQlcxvg5rA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB5884
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBGYWJpbywNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBGYWJp
byBFc3RldmFtIDxmZXN0ZXZhbUBnbWFpbC5jb20+DQo+IFNlbnQ6IDIwMjHE6jfUwjIwyNUgNzoy
Nw0KPiBUbzogZGF2ZW1AZGF2ZW1sb2Z0Lm5ldA0KPiBDYzogSm9ha2ltIFpoYW5nIDxxaWFuZ3Fp
bmcuemhhbmdAbnhwLmNvbT47IHJvYmgrZHRAa2VybmVsLm9yZzsNCj4gbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IEZhYmlvIEVzdGV2YW0NCj4gPGZl
c3RldmFtQGdtYWlsLmNvbT4NCj4gU3ViamVjdDogW1BBVENIIG5ldC1uZXh0XSBkdC1iaW5kaW5n
czogbmV0OiBmZWM6IEZpeCBpbmRlbnRhdGlvbg0KPiANCj4gVGhlIGZvbGxvd2luZyB3YXJuaW5n
IGlzIG9ic2VydmVkIHdoZW4gcnVubmluZyAnbWFrZSBkdGJzX2NoZWNrJzoNCj4gRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9mc2wsZmVjLnlhbWw6ODU6NzogW3dhcm5pbmdd
IHdyb25nDQo+IGluZGVudGF0aW9uOiBleHBlY3RlZCA4IGJ1dCBmb3VuZCA2IChpbmRlbnRhdGlv
bikNCj4gDQo+IEZpeCB0aGUgaW5kZW50YXRpb24gYWNjb3JkaW5nbHkuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBGYWJpbyBFc3RldmFtIDxmZXN0ZXZhbUBnbWFpbC5jb20+DQo+IC0tLQ0KDQpTdHJh
bmdlLCB3aHkgbm90IHJlcG9ydGVkIHdoZW4gSSBkbyAibWFrZSBkdGJzX2NoZWNrIj8gTmVlZCB1
cGRhdGUgc29tZXRoaW5nPw0KUmV2aWV3ZWQtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpo
YW5nQG54cC5jb20+DQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiAgRG9jdW1lbnRh
dGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9mc2wsZmVjLnlhbWwgfCAxMCArKysrKy0tLS0t
DQo+ICAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZnNs
LGZlYy55YW1sDQo+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9mc2ws
ZmVjLnlhbWwNCj4gaW5kZXggN2ZhMTFmNjYyMmIxLi4wZjhjYTRlNTc0YzYgMTAwNjQ0DQo+IC0t
LSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZnNsLGZlYy55YW1sDQo+
ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZnNsLGZlYy55YW1s
DQo+IEBAIC04MiwxMSArODIsMTEgQEAgcHJvcGVydGllczoNCj4gICAgICBtYXhJdGVtczogNQ0K
PiAgICAgIGNvbnRhaW5zOg0KPiAgICAgICAgZW51bToNCj4gLSAgICAgIC0gaXBnDQo+IC0gICAg
ICAtIGFoYg0KPiAtICAgICAgLSBwdHANCj4gLSAgICAgIC0gZW5ldF9jbGtfcmVmDQo+IC0gICAg
ICAtIGVuZXRfb3V0DQo+ICsgICAgICAgIC0gaXBnDQo+ICsgICAgICAgIC0gYWhiDQo+ICsgICAg
ICAgIC0gcHRwDQo+ICsgICAgICAgIC0gZW5ldF9jbGtfcmVmDQo+ICsgICAgICAgIC0gZW5ldF9v
dXQNCj4gDQo+ICAgIHBoeS1tb2RlOiB0cnVlDQo+IA0KPiAtLQ0KPiAyLjI1LjENCg0K
