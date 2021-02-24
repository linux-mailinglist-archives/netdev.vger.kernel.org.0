Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26AE03235E2
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 03:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232965AbhBXCsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 21:48:39 -0500
Received: from mail-db8eur05on2066.outbound.protection.outlook.com ([40.107.20.66]:13537
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232473AbhBXCsY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 21:48:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mnrh2xD/5+jRYibT3JJJeuAe+upQTByvTCFoI7kDfmflsc4PmLUffxB8w8K7oVVQiFlzWHxa1W/yvq4Y1S4SnUcgBa1y0N6dqtxAwrevx3MSSCr90MS62DBKuSoWLlLHgmOxVk0TaStPoU4Ocjv0857lSyvQzfZLhc+rVp6QwqPwrvTbGQ6cQZ948aKE3xtHLXNiQkcs1MbyELF4mE9v9mao9C4AIC8+7oyt2bY3Cdr+tBJrGrnBG8HCycumGKqJX5cMiJhE+I3gZSkYSGIzGiJRosNceKOzh/7fNhAPuZpVanqqd0VZIPUFBO1CE5Wu7YWn9qJYE+A2AydvRV5WAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zk/0/WD3m6dLw8PKFKyQnsMCc0vN+q31oB2t9BshA/8=;
 b=M7eDpwVq5V4MZwr6FcDaOG4cXP3URhO4TiFY2f6uprhXrNrHXNXP9+4ToBtoWEsKvV/IlHJEtA5z1fHPDQp0x820glRXt+OiJmt1JiKZRE5oSOYbzhGzgQjQ+7XiLzKBWwUZmse/MDwvI/aHECVc3botFKfQrQLdcpiP+ayG1Z7cSL3dd94JZhE6VxYTeAJ1GQ21OdyvRL1riISAMGg5FRycIkiDt0vO7An0cDGzO3n3+2Pn4k9LX9h/IzaEN4cTFjOqx+0UvU+8aPhfg7q+GvGdgthTwMwDGH+/pYwFpzleQD+9NefktEoW4LeXYQ0hjazU2pQIJDTAeH7pJZrlSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zk/0/WD3m6dLw8PKFKyQnsMCc0vN+q31oB2t9BshA/8=;
 b=Dnz4GLYD8eNITZEwj6u5TK8w5MlMo4pzrAsOqQ0aqLFdU3NPdCYuTyn3oownytqMhn8U9zcsd1okIiV0ImBfNNhybyzbyuw0AUfqsPZNHlgN7l6vNrBNkMaenFJL3bUXf9NOHuSMWow3UuF/xApRYVwbalz+7MrSBLodW21FWMs=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6796.eurprd04.prod.outlook.com (2603:10a6:10:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Wed, 24 Feb
 2021 02:47:35 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Wed, 24 Feb 2021
 02:47:35 +0000
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
Thread-Index: AQHXCdFekWFqiRqYw0qX+7Ua7CCmtKpl8tSAgACRjMCAAAgFgIAAA1yAgAAHzQCAAANg8A==
Date:   Wed, 24 Feb 2021 02:47:35 +0000
Message-ID: <DB8PR04MB6795C1D02AAB9F01571AFED9E69F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: cdc76a6b-6698-463d-1c41-08d8d86e8a90
x-ms-traffictypediagnostic: DB8PR04MB6796:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB67962E662B37400199554CCEE69F9@DB8PR04MB6796.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dFWHh/hi8goMgkiQksNOEdQ7/xNoMal9br3qJ+12IHZOTGBPO9eQubVdSbpVjmp8RlQN+ro4RoPqZOP8upEdwao8dvI0hVQAAHZYpF22z7DyHdXwwtMIJ0S1nQzdqGI5cLyg436xFr4cKOB2BaNjjKq7gIV8UMpdRdLfVyHKogde2AFKdO60aOHgxB1K+nDidEVM2FPv9p2evufW1wqsdNMtT0V9yyPQ6/Hp1S9w648LY2cZfrLK7hyGx06MbvSOdw1+XLBKEByCA7RiFqxGjrQEaUtg5IrCl5NyNp2h6In1O4MbY465Iwzs/FIRVaEuONUnfjqrcX/zNDaG9BYkqRlhDJ1wFVx3f74H1w8KxAXUf5y+9EI/kbzhwmveE1cgfUSHctC5rz6bY3kXp6AGPi1DJ7qiNbdRJar4dBwlqDzsAbU8d5tUr9SCAizrYGI3vmNLgORazSfvAeVRXe6l/V3PxY0HJtuwgvPdvUdd6YZ7tVcMzcUS6WQ9m1F4y7a/tOPlOwaE3/YBi/LjT/PiKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(39850400004)(136003)(86362001)(4326008)(316002)(5660300002)(66476007)(76116006)(66946007)(33656002)(7696005)(66556008)(9686003)(71200400001)(83380400001)(54906003)(64756008)(66446008)(8676002)(52536014)(6506007)(186003)(8936002)(53546011)(55016002)(478600001)(6916009)(2906002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: fdwMzGqC45Hxwf8DC8psO/smuJ+1wTvyguFMaoHYGmNgqNE4qRB0iSQH0vt0fs2UG0Nf6QUpRrKIXfdz5qeVM/+RkIVUDlc1qhEaPmx+FdVRJjNzg9h5iW0iU0VQo7PrEEbVEXpoztyWdfqBLSg5H0ZNxj36krUoOM9U8Pp7MY7hgpX+fjIDPmktpXpVdmMynBG+BbZcY/Lp2L/PVcQpZ/aP/eiAl5a0H+L5g330BGmQED3K4Pr1G9suhMgwav5+/KboEo6FidLpMjQbVNmkhvdrAKCQ/T+jWz+Ylb17DoTTltkP3lN0/cfedwHAc0SG0nhI6e7oi3W9i+Ilyi+xj2tMkLkcDrB25yLYelEu/ESUbbGJHpBoFwHEmXhW8JBdaFH7YhrpJaKeXIhX4tYzVbMkSEoQLXtpSlquTENj1X3MnhSXvWDJA7wcLDvqvAskvgVKre8gDYtLBEt0dyXkYCdlP4WSQUhcCVtP9FzkBqo4aXuLOkp65S/FWPESAOAWvC9yiv/gfqG3MQ2TWjGJa3UJP2ILLVeL/HpXnkKiUumLOM+gotugBiDij3NtamP3A0qDXfthF6sMDVDgH2w0iBKv/EJb97xpHLbcPIMDNdOR+ElfUGSHtdAPzfNy0mYTEgLvvva4PU7IOHQAsY/um9Xu4hZRn8RmsFxwGisn94WNACB7TPeYSD0FfQFc5+UcNUgQWnaQuWJ9iLlO9N2teaBoniKKcLdPpITzxVaYGoo=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc76a6b-6698-463d-1c41-08d8d86e8a90
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2021 02:47:35.4034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0mUIC6sy32KPqSozXnxwU25IV6U4zmDZ8Z7pEX0lUJvAa+eTQCe+lcV/dJw51dU1RDk5snBo9boAO2sNkKZMpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6796
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
Y2tzIHN0bW1hYyBpbXBsZW1lbnRzLg0KDQpUaGFua3MgSmFrdWIsIEkgd2lsbCBjaGVjayB0aGVz
ZSBjYWxsYmFja3MuDQoNCkJlc3QgUmVnYXJkcywNCkpvYWtpbSBaaGFuZw0K
