Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B105C28FE97
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 08:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394492AbgJPGwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 02:52:53 -0400
Received: from mail-eopbgr70045.outbound.protection.outlook.com ([40.107.7.45]:8214
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394252AbgJPGwx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 02:52:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GS87rbetMPwOvZkKzV6FJ/3eRl7dLs2PqKO1cR5zVEpQakRm7Vam4MT4Wko9MTUFwmqITXKp+cuo0HSmSDD2w1/qOjipF6uuXMdpJu9LVHs/Uo7hqVZsUL0norPN9zmXUtEpDMSOFzzcKiWsXFe2XN7M/G/6JcdwCR6bEVUrP6pGz7taH6+PVVivGlcbfLU7EcPe9ZEdQY6T6T/0vhCrp2I2lkhY+kKXYb0w1h8AAImDh2xawteo30a/tcBBIrLiWTpmlCrZcJJovbz6tHk/dgG5c1vUwQV0VMvBbbU4/x3ktkjzrNy3TU+RsRcSRubaTuHYPfGxuWaOIviBsbCoTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlSQwbNipP0pCGKJ0bCK7T3LDn7166EBFdLP+DC4e8o=;
 b=bVbK54O8zm84oFJhTC6Kys0UpCpjkc6PHVV+YXAG+ACM8pVPQIAzDTkp9RbtMuVkpPff4CT9S8scRaxg78VbsDjPAL5Lmo3+EFeumBv1dUaskcv/ObfWl1QgH1cvfuZOXEnE62+FDe9FsBq/KxFm4zKAbIUSO2eAjJ1sqgWUCShV+lyYKqkf0yOLHSk2B39BmQPAutcTUHUZ6B3tXqMSpueDyVFuNa067+QspgeuKOKD+3okTw3OalHXMHZ/3Vptb/OC5FnnMsS56UJjSQc7v3/+GER6OQ6qtsTI1iT13AiOhU+xIWS0OrxSvvWcH42iXBGz8S491rI0HT5aBzC23A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlSQwbNipP0pCGKJ0bCK7T3LDn7166EBFdLP+DC4e8o=;
 b=A05lDSUIY84V5hxQegVYkcxUkeppcjCtsmplyYaFx8m0DdMpEUI5kVZyJRFutk0SIrwewHtEkbHTy/6rCj0mWrwHdk7Sq+gM0WjRqxGQqGRJgki4cEGJ0STUdYmSd+Wy9KeE+M+xc+OghAh1Yy0RUIcY+eq/R44Ui+qXJIursPk=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2725.eurprd04.prod.outlook.com (2603:10a6:4:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 16 Oct
 2020 06:52:48 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 06:52:48 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Peng Fan <peng.fan@nxp.com>, Ying Liu <victor.liu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Oleksij Rempel <ore@pengutronix.de>
Subject: RE: [PATCH 2/6] dt-bindings: can: flexcan: fix fsl,clk-source
 property
Thread-Topic: [PATCH 2/6] dt-bindings: can: flexcan: fix fsl,clk-source
 property
Thread-Index: AQHWo384O2SW3CZx1UqCmPzJCauCkamZwk4AgAAIG0A=
Date:   Fri, 16 Oct 2020 06:52:48 +0000
Message-ID: <DB8PR04MB6795F7F8B2B72C738FC2433BE6030@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
 <20201016134320.20321-3-qiangqing.zhang@nxp.com>
 <5a70ac44-62cd-8f7e-d524-c2d738a07298@pengutronix.de>
In-Reply-To: <5a70ac44-62cd-8f7e-d524-c2d738a07298@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5c127bd3-a7c1-4774-ba68-08d871a017ff
x-ms-traffictypediagnostic: DB6PR0402MB2725:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB27253D1F5286CFB01CC9F136E6030@DB6PR0402MB2725.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /STxoTs6oYoafwxJf7MMOvjYOwb+Vh1VlFc0jwh/Dl11uoAWj2FPiJ6mLDjCNFdDRauxOkufsrJxO93sDn1P8A99+mXLqGaqyRzlYX1keTzCmSjFA2RHUqlkhm2dYdM3Iq0YCpnUzBfxLxL7GQTkIFbIAtgXZyFEQ697ZUs+4PmlhSyWOwTnbDpdZyqSGanS1ezwGQWAOoNnB2MPkSAGb45BFPWNCwuIHWWIJDyxcKEkEtagSUMFdxb1F80O7nU+FKxqdcsMVGh87COrzyMBwgttl9VvygpWT5QiLs99P6G9EKpgK1bYv5AWPJB+cUJa1akZrHviKo7lUGOGchAO6OnsE7wYwMgLyyX0Tyb1Oi0CFxws0tUkZysgCTaQFFRUDe7SCIrdRRs/zqYXCVxJYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(186003)(26005)(55016002)(86362001)(8676002)(83380400001)(966005)(66446008)(71200400001)(33656002)(7696005)(478600001)(64756008)(76116006)(8936002)(54906003)(6506007)(7416002)(53546011)(9686003)(52536014)(316002)(66476007)(2906002)(4326008)(5660300002)(66946007)(110136005)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: CS4UWqDzS4uMvtqtDD6oaYteiXmG0gqmnzLrPsyM7ln8D0ZGdZnP5FBGm6TPacp+YnVdv3ppTLo14qS5AAxwDpC3XqdGOccNo+koycurvIPp+1O2a5dwOHpkSmO8nEQfRFWRu+y1pZvjb8NG/fb8oPqVHrKutDq39IcKALfAu4YtZVF6WIYlXtybHTdnUr4Vbva5RWIEsDkIgzygdoLHbXSWwzSUzSh2bRMRbGgzfxhuqq0ZFMeZ+qK25tuyLRHWbKivzJbg3h/AjxumVVWR4XJnq4tclIaAfw7CBc0LLvFt51FrmKsrJ6pXuPRrBrZj3EXJmE5/bwOZhMSQcjGidJbyATSO2M46V/tHWAmxp13D+hHX4JbCdBbw0dpIluF4pKp315YuAjS9Ss9W+cZhnegfj7If1dctregDTqI/grLav2a5tk22Dk5Halch7lokHX2rJtH/bwpy7Wq4nNUxBKIn/SuV0jWj472ewEBn3k5GR1izc2l3A53PvGhx5+B96lfWdS4CRPpgt3RgcTu+xLLDFHPyWg4OvclMcZMYmpFIRh2y6AhVL79L+aOLdUCPATECGKmfZVESnAccLeMliBHcM3T138xe4LjhX1sjA4XhIpQ/JChwWHM1KKXNGUA/2f/XhxNgkyDX4vCcZMxozA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c127bd3-a7c1-4774-ba68-08d871a017ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 06:52:48.2783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wgghUDIvXLCZ9dX4jAH+w1nwQzkQ3Qjn8pQRKAHg5HKngNYtmWur+QLwXMRhzCcT8m99XTQnI/9uAJ82geFSVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBNYXJjLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMg
S2xlaW5lLUJ1ZGRlIDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQxMOaciDE2
5pelIDE0OjIyDQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPjsg
cm9iaCtkdEBrZXJuZWwub3JnOw0KPiBzaGF3bmd1b0BrZXJuZWwub3JnOyBzLmhhdWVyQHBlbmd1
dHJvbml4LmRlDQo+IENjOiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgUGVuZyBGYW4gPHBl
bmcuZmFuQG54cC5jb20+OyBZaW5nIExpdQ0KPiA8dmljdG9yLmxpdUBueHAuY29tPjsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgUGFua2FqIEJhbnNhbA0KPiA8cGFua2FqLmJhbnNhbEBueHAuY29t
PjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgtY2FuQHZnZXIua2VybmVs
Lm9yZzsgZGwtbGludXgtaW14IDxsaW51eC1pbXhAbnhwLmNvbT47DQo+IGtlcm5lbEBwZW5ndXRy
b25peC5kZTsgT2xla3NpaiBSZW1wZWwgPG9yZUBwZW5ndXRyb25peC5kZT4NCj4gU3ViamVjdDog
UmU6IFtQQVRDSCAyLzZdIGR0LWJpbmRpbmdzOiBjYW46IGZsZXhjYW46IGZpeCBmc2wsY2xrLXNv
dXJjZSBwcm9wZXJ0eQ0KPiANCj4gT24gMTAvMTYvMjAgMzo0MyBQTSwgSm9ha2ltIFpoYW5nIHdy
b3RlOg0KPiA+IENvcnJlY3QgZnNsLGNsay1zb3VyY2UgZXhhbXBsZSBzaW5jZSBmbGV4Y2FuIGRy
aXZlciB1c2VzDQo+ICJvZl9wcm9wZXJ0eV9yZWFkX3U4Ig0KPiA+IHRvIGdldCB0aGlzIHByb3Bl
cnR5Lg0KPiANCj4gSG9wZWZ1bGx5IHRvZGF5IE9sZWtzaWogd2lsbCBwb3N0IHRoZSBuZXh0IHJv
dW5kIG9mIHRoZSB5YW1sIGJpbmRpbmdzIGNvbnZlcnNpb24NCj4gcGF0Y2guIFBsZWFzZSByZXNw
aW5nIHdoZW4gT2xla3NpaidzIHBhdGNoIGlzIGFwcGxpZWQuDQoNCk9mIGNvdXJzZS4NCg0KQmVz
dCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IE1hcmMNCj4gDQo+IC0tDQo+IFBlbmd1dHJvbml4
IGUuSy4gICAgICAgICAgICAgICAgIHwgTWFyYyBLbGVpbmUtQnVkZGUgICAgICAgICAgIHwNCj4g
RW1iZWRkZWQgTGludXggICAgICAgICAgICAgICAgICAgfCBodHRwczovL3d3dy5wZW5ndXRyb25p
eC5kZSAgfA0KPiBWZXJ0cmV0dW5nIFdlc3QvRG9ydG11bmQgICAgICAgICB8IFBob25lOiArNDkt
MjMxLTI4MjYtOTI0ICAgICB8DQo+IEFtdHNnZXJpY2h0IEhpbGRlc2hlaW0sIEhSQSAyNjg2IHwg
RmF4OiAgICs0OS01MTIxLTIwNjkxNy01NTU1IHwNCg0K
