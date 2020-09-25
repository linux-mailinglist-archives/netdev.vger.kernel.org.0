Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31C127839F
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 11:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727812AbgIYJLQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 05:11:16 -0400
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:8958
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727248AbgIYJLP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 05:11:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+U8N/oc7SYoIOzXULm82mp/Dt1jBKJAV6L/6aZ8ETsA1hbbCJpQ77j6oK8dG/WIXUqRIUnhZDOevvP+jYry3md5idanUib1IDCp8gJOAxoZ5PioAoC8VazWeA1F1eKp4wip4yPTUyXmiVmJ0Igr0C3BbisDV3hpli4AJ+SEvm+jU7MwewT+j/iYpBAUZrm1FSyuGIQ9L1pGRGKrRwOu5oAXZUQeKVXWL0aZLB33/9xlegOBtS92WtsFKBenw7kQZGzVNq3tyeM6o09XWTzmXluRINEiqk472Kj4OhtfHFS016MRu/U86IE9tJ4qFkED02l7PUmHV79CFZrfDLAzOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvKpgIO35dWPxBxkl6sKWgDAlsl/HFvdBC0quOZqIVo=;
 b=aLi6Vgbi6TE27PwXgWoCo72GUNmSiHixlZzgnCqqq39pj3Lzdi+Dnjso8Oog9kaqLrlJXxQ3TSQ9mU0uvyzjsn3UTMpqlMXu1zzhYmnb0J+ZfEIqVLiF1dzYSGN4vBhS99mec3TDT5tN6CNnfdtVUp4q6PU7Yo+vRy0MUTrmhZxWodqKXurOmQRwdIGt41G5vFwNdikhabMnjUpG7CHoJDqpmKNAj1GdFf3fZC1qBO2UIxTDcQJCgn4pdBYKBxrcy8MPp1ckjDEvFBXrBISph7M2bFvlVFZR5MfJmk9rzuYCfPs7bgT/wKDf7bFCjqznwZPLVedFMc7DQBTKddbYCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jvKpgIO35dWPxBxkl6sKWgDAlsl/HFvdBC0quOZqIVo=;
 b=e6lt/2Jc5igQvy2R/2iqe+ZKxcgr67Jt9WLcA6AzYxHzW43O6qDEMPcivaSv54csxfub4TEu+e2AZzyH98Hmc7k2WXWQ74jnAk7LjQYcUSHSVM9fb8s72UlTkidT3I1tw33G+0qe/8qCjsG0jOI80NIl8bqcwOychGLa/kp0B18=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5498.eurprd04.prod.outlook.com (2603:10a6:10:80::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Fri, 25 Sep
 2020 09:11:11 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 09:11:11 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-can-next/flexcan 2/4] can: flexcan: add flexcan
 driver for i.MX8MP
Thread-Topic: [PATCH linux-can-next/flexcan 2/4] can: flexcan: add flexcan
 driver for i.MX8MP
Thread-Index: AQHWkwryw5CNKh5rmUaMkhxmNi/0xql5D8uAgAABQbA=
Date:   Fri, 25 Sep 2020 09:11:10 +0000
Message-ID: <DB8PR04MB6795D438EB4D6C6F9CF4F096E6360@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
 <20200925151028.11004-3-qiangqing.zhang@nxp.com>
 <bdb05b08-b60c-c3f9-2b01-3a8606d304f9@pengutronix.de>
In-Reply-To: <bdb05b08-b60c-c3f9-2b01-3a8606d304f9@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a08560c4-c8ca-4a54-c165-08d86132f210
x-ms-traffictypediagnostic: DB7PR04MB5498:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB5498D4B555CFA0FB08B3CC1EE6360@DB7PR04MB5498.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AUdJDIXPmlsTizSWkeY1HTWiwkLBt23wrmjbBohZ2UX+A6W6Q1dnYmbmKAr/gaQ7FsEnnMm8i1nLf+czlvzQabZh7VbtxFGJlzUgJm+GIkNwaNap+mVQ2Oie5C9j3g2OwdMf26oYNPz934qjVKrf0OKkEwZr7NCKhVbpB4cD/McF4avW35nIWAEfBXT9nhF9AZeuNdpn9jWwydvP22VO8cwnVn4K5muAlVTKMkM3HVHCCTatzUMD8yNUZaE3JRG0LAQJy2EAab6oE/96Vnm8Faq0i+LZ4QCMWebqWlf2whQ0NvIJqM5k9fUzLLZ8W8Dj02hJADGo6EE+plvWmH7iGNGxfZepVcP7KQbZSQKVRyaZ8vAh8wpaT1aRBfdgrptP5zoPYWvUQ+sYXz+0wkT9Ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(396003)(39860400002)(5660300002)(71200400001)(186003)(26005)(316002)(7696005)(83380400001)(2906002)(4326008)(53546011)(966005)(33656002)(110136005)(83080400001)(478600001)(66946007)(66446008)(64756008)(66476007)(66556008)(54906003)(55016002)(6506007)(8676002)(52536014)(86362001)(8936002)(76116006)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Dxvir2ISjSjXYFusQvYfyp7BwH6rUtd+9NiqxWNqHK1q60XX9yGctzKlG6WXjJna75G9IY7DNtDiaHvLhMdYD2hWhmRdnvXDwT38LKeWkaVx7hwAUDhePS+9TaRMCUhP+lZlk0ZB8zn0So8fK0n4fpX9SaM3km6rnEu4GsseFZuz1fIe6BC6Sa3G68d6rwtNEqrd3UkhpKbGwzKfTzKFzo5X5sFZiRuhBcshVfSZ56eyqn7uDvRes+3rNSBTXXyIvjhDbgLdbx7a/QWHciocl70ZPwOIZ7VqCeatmXTBbzDuzC++iInxLumdAWZnvKPUeQDnr+tZ4gpEfzbryF++mwmkIlR3gWM2KbiNDZDzYITEwddg6FoJoPl5d18eVctQfr8P7sMuS/D8YO8TTZ+cmMyVgrLWvZjQZMQjH9/9QRnxriFzHoG6UPk2AZk/wyM+gR/V6yhXu9yd0LcVkOtpIzJzquXImGLzFfvOlvyDv9CRd2PPsH0h6fwLb6xQUbIj0/0Sz4eQZJM5NjFFEemcpSKyn3KNUR22IrRqSBh7ZIdEsz7XN9ijSr5qJPgXMQm/C/FaYfnokM4GongLADhE6uEKspxvMF399S5LMvP5TOG0jtmaVj9SfjDouZNNwnmCmFwyPbLopqkbotwPhajFIA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a08560c4-c8ca-4a54-c165-08d86132f210
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 09:11:10.9701
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O+iFMMPczGE/FokaE7GKF5d54/8obeuFITQKbHotE1EZdoHVaqHBYSgGPRtj4io+6UU+cgLSa2kYl4ZbRvrSFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5498
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjXml6UgMTc6MDUNCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnDQo+IENjOiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGxpbnV4LWNhbi1uZXh0
L2ZsZXhjYW4gMi80XSBjYW46IGZsZXhjYW46IGFkZCBmbGV4Y2FuIGRyaXZlcg0KPiBmb3IgaS5N
WDhNUA0KPiANCj4gT24gOS8yNS8yMCA1OjEwIFBNLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+ID4g
QWRkIGZsZXhjYW4gZHJpdmVyIGZvciBpLk1YOE1QLCB3aGljaCBzdXBwb3J0cyBDQU4gRkQgYW5k
IEVDQy4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpo
YW5nQG54cC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmMgfCA5
ICsrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyBiL2RyaXZlcnMvbmV0L2Nh
bi9mbGV4Y2FuLmMNCj4gPiBpbmRleCBmMDJmMWRlMmJiY2EuLjhjODc1M2Y3Nzc2NCAxMDA2NDQN
Cj4gPiAtLS0gYS9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+ID4gKysrIGIvZHJpdmVycy9u
ZXQvY2FuL2ZsZXhjYW4uYw0KPiA+IEBAIC0yMTQsNiArMjE0LDcgQEANCj4gPiAgICogICBNWDUz
ICBGbGV4Q0FOMiAgMDMuMDAuMDAuMDAgICAgeWVzICAgICAgICBubyAgICAgICAgbm8NCj4gbm8g
ICAgICAgIG5vICAgICAgICAgICBubw0KPiA+ICAgKiAgIE1YNnMgIEZsZXhDQU4zICAxMC4wMC4x
Mi4wMCAgICB5ZXMgICAgICAgeWVzICAgICAgICBubw0KPiBubyAgICAgICB5ZXMgICAgICAgICAg
IG5vDQo+ID4gICAqICBNWDhRTSAgRmxleENBTjMgIDAzLjAwLjIzLjAwICAgIHllcyAgICAgICB5
ZXMgICAgICAgIG5vDQo+IG5vICAgICAgIHllcyAgICAgICAgICB5ZXMNCj4gPiArICogIE1YOE1Q
ICBGbGV4Q0FOMyAgMDMuMDAuMTcuMDEgICAgeWVzICAgICAgIHllcyAgICAgICAgbm8NCj4geWVz
ICAgICAgIHllcyAgICAgICAgICB5ZXMNCj4gDQo+IFRoaXMgZG9lc24ndCBhcHBseSB0byBuZXQt
bmV4dC9tYXN0ZXIuIFRoZSBNWDhRTSBpbmRlbnRlZCBkaWZmZXJlbnRseS4NCg0KTmVlZCBJIHJl
YmFzZSBvbiBuZXQtbmV4dC9tYXN0ZXIgaW4gbmV4dCB2ZXJzaW9uPyBUaGlzIHBhdGNoIHNldCBp
cyBtYWRlIGZyb20gbGludXgtY2FuLW5leHQvZmxleGNhbiBicmFuY2guDQoNCkJlc3QgUmVnYXJk
cywNCkpvYWtpbSBaaGFuZw0KPiBNYXJjDQo+IA0KPiAtLQ0KPiBQZW5ndXRyb25peCBlLksuICAg
ICAgICAgICAgICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAgICAgICAgICB8DQo+IEVtYmVkZGVk
IExpbnV4ICAgICAgICAgICAgICAgICAgIHwgaHR0cHM6Ly93d3cucGVuZ3V0cm9uaXguZGUgIHwN
Cj4gVmVydHJldHVuZyBXZXN0L0RvcnRtdW5kICAgICAgICAgfCBQaG9uZTogKzQ5LTIzMS0yODI2
LTkyNCAgICAgfA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiB8IEZheDogICAr
NDktNTEyMS0yMDY5MTctNTU1NSB8DQoNCg==
