Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17F51D9241
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 15:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393558AbfJPNTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 09:19:11 -0400
Received: from mail-eopbgr140085.outbound.protection.outlook.com ([40.107.14.85]:48806
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726530AbfJPNTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 09:19:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WS427jOMIuJlf3c0kwoIprmaO1N4RHLZVGIUqNB/SKjrsg1lbt4g+zi802dR2RF1KDp7THSY1C6C6hjq9PA6UDl6ft3gHv40JTmaxpzZYGS3Igp4cLqx1Ts7glcbjuufkyR+FwNDDepIq/kN6JNNN1DYOqA7FOM8jIgxR7a9J9jnUfgzqRUM7vQmrPVDEeMgyNFYxXNhSj4g8ddugdZUX3pIElcipwHkw+rBCdoGzV/iHiOeOxEUQ61bd3ehGN0b/Gp1oK6tYU0K2X52ocRsZ47Re6irJ4LXylu3Nr5ayn2+dpogiLnHhqD6b0DHxFJNtRfuynNd8y26wWAATec2Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1SgbFS5o+KJNhP05rWP8/UKyxwp1NZwQ6X6OlBKyCLE=;
 b=lD5LB6cVQZKh/1iIcMi8J0DWwdxY8eudKwHddUjtTsbK+djfrUYAlO+lhbzykkANYk9nx7oaRzn07iE3DBSUQuXdMLkCwVrPV1fhFM0vkVOgpgRSYvvXR3EOo6zlS7tqodtQ7e0JbFMIptrKHhcBz3b04z5w8Q2i8T8gElvmQmk4N2KsbsVNoBQVY4gVzYsCaYIr19K+tWhPHlPpBAnWgacZzxCitLBYl82683/8WNYtnrPXQ7lSc7gUbOcz6RfzeO6ZcwTakxMbYR5aUNFBZKzdf4gGUzMmeUGb0JGso0CbXsCyFhlp7r8xbbOjigEAYSYVL1h8CDEkGJKQxR1PAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1SgbFS5o+KJNhP05rWP8/UKyxwp1NZwQ6X6OlBKyCLE=;
 b=QN8Dk+0Wf8jMFwqbRIu5BLZ/98kIgU4NkSjuWK8rMZrSmNrhIv5x+Yzys95AIkrXtPuPu0ZLFiZkv65TjsflHPW1BmGUjl7vOOFP/0twiTrjl3z6w/X28KU68y2vqMH42tj9oYyvIRq1PV4IL6WyRXyxVKw/y9eiEjLBoOu24B4=
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com (52.133.29.29) by
 AM6PR0402MB3431.eurprd04.prod.outlook.com (52.133.23.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Wed, 16 Oct 2019 13:19:07 +0000
Received: from AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::41c6:84dd:815a:7fed]) by AM6PR0402MB3798.eurprd04.prod.outlook.com
 ([fe80::41c6:84dd:815a:7fed%2]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 13:19:07 +0000
From:   Christian Herber <christian.herber@nxp.com>
To:     Lucas Stach <l.stach@pengutronix.de>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
Thread-Topic: Re: [PATCH net-next 0/1] Add BASE-T1 PHY support
Thread-Index: AdWEJEhq7WLWRdOeSmCgG9/MWDe38A==
Date:   Wed, 16 Oct 2019 13:19:06 +0000
Message-ID: <AM6PR0402MB379820688ED6E8D3FA60D45C86920@AM6PR0402MB3798.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=christian.herber@nxp.com; 
x-originating-ip: [95.112.80.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 951f0523-f754-4c8e-a752-08d7523b6c62
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: AM6PR0402MB3431:
x-microsoft-antispam-prvs: <AM6PR0402MB3431597DF373B22E973C524786920@AM6PR0402MB3431.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(189003)(199004)(74316002)(66066001)(6246003)(7736002)(66946007)(53546011)(102836004)(26005)(9686003)(6506007)(186003)(2501003)(7696005)(486006)(476003)(44832011)(86362001)(76116006)(305945005)(66476007)(66446008)(64756008)(66556008)(229853002)(14454004)(52536014)(316002)(33656002)(81156014)(54906003)(81166006)(478600001)(8936002)(25786009)(6436002)(5660300002)(2906002)(3846002)(6116002)(4326008)(55016002)(99286004)(8676002)(71200400001)(71190400001)(256004)(110136005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR0402MB3431;H:AM6PR0402MB3798.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ktXDsWUpoP/ZvE1wEDpuCkXR/Ujw6Ctc61zqodZ1NgZ/UQZkw3RXz2QRC8JmtRrtL9JiK+HJOnfALGWlb9XxPBtJDXU6Epb0n1XkHr7WrjDKEqNl1HDjCHqQWeX+wysu5sSiCPJoySeKp9FNmWo5zFQrE9byUjIxVIJRqi53+3wBfGQfUh9zaZ/+JaLXWFOXvhWMhJa2d6wkMH5WIAU+kkQZ/T50o+LRb5jqsvR6GD5jW2FaHXy1Yc86YLG86YWqj7RXa7qXOHnlPdKlp8m+2qjiCHv9NL+WqQNbZpM+5hnQAZpCuIidydDsMxRk83C7yfL1DLzfUJgo2ZD8S/Xefilvq4+gNaPw4l0bqOq5tA+tI1WCWddM/OsAi7t6cyk4WTRA3s1KqHzpdgc8+5ONEhY0C67nZTRVdOwEkEYdqkE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 951f0523-f754-4c8e-a752-08d7523b6c62
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 13:19:06.7889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7YnXhC+gTVdea++jBdUrYszks+uHKKIF2vz0iEZmfZNrFwIL46/bCizLlX3vw1z7nPc6JaiGLeIXtIzQLuDqHSGbsi+q6cKkBD6lOzKBRFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3431
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gT2N0b2JlciAxNiwgMjAxOSAxMDozNzozMCBBTSBMdWNhcyBTdGFjaCA8bC5zdGFjaEBwZW5n
dXRyb25peC5kZT4gd3JvdGU6DQoNCj4gT24gRnIsIDIwMTktMDgtMTYgYXQgMjI6NTkgKzAyMDAs
IEhlaW5lciBLYWxsd2VpdCB3cm90ZToNCj4+IE9uIDE1LjA4LjIwMTkgMTc6MzIsIENocmlzdGlh
biBIZXJiZXIgd3JvdGU6DQo+PiA+IFRoaXMgcGF0Y2ggYWRkcyBiYXNpYyBzdXBwb3J0IGZvciBC
QVNFLVQxIFBIWXMgaW4gdGhlIGZyYW1ld29yay4NCj4+ID4gQkFTRS1UMSBQSFlzIG1haW4gYXJl
YSBvZiBhcHBsaWNhdGlvbiBhcmUgYXV0b21vdGl2ZSBhbmQgaW5kdXN0cmlhbC4NCj4+ID4gQkFT
RS1UMSBpcyBzdGFuZGFyZGl6ZWQgaW4gSUVFRSA4MDIuMywgbmFtZWx5DQo+PiA+IC0gSUVFRSA4
MDIuM2J3OiAxMDBCQVNFLVQxDQo+PiA+IC0gSUVFRSA4MDIuM2JwIDEwMDBCQVNFLVQxDQo+PiA+
IC0gSUVFRSA4MDIuM2NnOiAxMEJBU0UtVDFMIGFuZCAxMEJBU0UtVDFTDQo+PiA+DQo+PiA+IFRo
ZXJlIGFyZSBubyBwcm9kdWN0cyB3aGljaCBjb250YWluIEJBU0UtVDEgYW5kIGNvbnN1bWVyIHR5
cGUgUEhZcyBsaWtlDQo+PiA+IDEwMDBCQVNFLVQuIEhvd2V2ZXIsIGRldmljZXMgZXhpc3Qgd2hp
Y2ggY29tYmluZSAxMDBCQVNFLVQxIGFuZCAxMDAwQkFTRS1UMQ0KPj4gPiBQSFlzIHdpdGggYXV0
by1uZWdvdGlhdGlvbi4NCj4+DQo+PiBJcyB0aGlzIG1lYW50IGluIGEgd2F5IHRoYXQgKmN1cnJl
bnRseSogdGhlcmUgYXJlIG5vIFBIWSdzIGNvbWJpbmluZyBCYXNlLVQxDQo+PiB3aXRoIG5vcm1h
bCBCYXNlLVQgbW9kZXM/IE9yIGFyZSB0aGVyZSByZWFzb25zIHdoeSB0aGlzIGlzbid0IHBvc3Np
YmxlIGluDQo+PiBnZW5lcmFsPyBJJ20gYXNraW5nIGJlY2F1c2Ugd2UgaGF2ZSBQSFkncyBjb21i
aW5pbmcgY29wcGVyIGFuZCBmaWJlciwgYW5kIGUuZy4NCj4+IHRoZSBtZW50aW9uZWQgQXF1YW50
aWEgUEhZIHRoYXQgY29tYmluZXMgTkJhc2UtVCB3aXRoIDEwMDBCYXNlLVQyLg0KPg0KPiBUaGVy
ZSBhcmUgUEhZcyBjb21iaW5pbmcgYm90aCBCYXNlLVQxIGFuZCBvdGhlciBCYXNlLVQgY2FwYWJp
bGl0aWVzLg0KPiBFLmcuIHRoZSBCcm9hZGNvbSBCQ001NDgxMSBzdXBwb3J0IGJvdGggQmFzZS1U
MSwgYXMgd2VsbCBhcyAxMDAwQkFTRS1UDQo+IGFuZCAxMDBCQVNFLVRYLg0KPg0KPiBSZWdhcmRz
LA0KPiBMdWNhcw0KDQpJbnRlcmVzdGluZy4gVG8gYmUgcHJlY2lzZSwgdGhlIGRldmljZSBzdXBw
b3J0cyBCcm9hZFItUmVhY2ggYW5kIG5vdCAxMDBCQVNFLVQxIGFjY29yZGluZyB0byB0aGVpciBw
cm9kdWN0IGJyaWVmLiBUaGVyZWZvcmUgSSB3b3VsZCBhc3N1bWUgdGhhdCB0aGUgcmVnaXN0ZXJz
IGFsc28gZG8gbm90IGZvbGxvdyB0aGUgSUVFRSBkZWZpbmVkIENsYXVzZSA0NSBsYXlvdXQuIFdo
aWxlIHdlIGNhbm5vdCBsZWFybiBtdWNoIHRoZW4gaG93IHRvIGhhbmRsZSBzdWNoIGRldmljZXMg
aW4gYSBnZW5lcmljIGNsYXVzZSA0NSBkcml2ZXIsIHRoaXMgc3VnZ2VzdHMgdGhhdCBzdWNoIGRl
dmljZXMgY2FuIGFwcGVhci4NCg0KU3RpbGwsIElFRUUgODAyLjMgZG9lcyBub3QgcmVhbGx5IGRl
ZmluZSBhIHdheSB0aGF0IHRoZXNlIGRldmljZXMgd291bGQgY29leGlzdCwgc28gSSB3b3VsZCBh
c3N1bWUgaXQgaXMgcHJldHR5IG11Y2ggdHdvIFBIWXMgaW4gb25lIElDIGFuZCB5b3UgY2FuIGNo
b3NlIHdoaWNoIGZsYXZvciB5b3Ugd2FudC4gSXMgbXkgYXNzdW1wdGlvbiBvbiB0aGF0IGNvcnJl
Y3Q/DQoNCkluIHRoYXQgY2FzZSwgeW91IHdvdWxkIGhhdmUgdG8gc3RydWN0dXJlIHRoZSBkcml2
ZXJzIGluIGEgd2F5IHRoZSB5b3UgaGF2ZSBzZXBhcmF0ZSBmdW5jdGlvbnMgZm9yIHRoZSBzdGFu
ZGFsb25lIGZsYXZvcnMgb2YgQ2xhdXNlIDQ1IG1hbmFnZWQgUEhZcywgd2hpbGUgbWFraW5nIGFz
IG11Y2ggcmV1c2UgYXMgcG9zc2libGUgYmV0d2VlbiB0aGVtLg0K
