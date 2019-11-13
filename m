Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C24FB201
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 15:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727386AbfKMOAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 09:00:13 -0500
Received: from mail-eopbgr10053.outbound.protection.outlook.com ([40.107.1.53]:13838
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726010AbfKMOAM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 09:00:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FPswJ7e1jh3AnVvx8mkLyHNWNK9r+cRQjMeirLOs+bNXlsmXnShRcAIICezQMaZ8Msi1Mvnkkh1UDrddQsjyE7UWaJU2XqnXJ6gdSJmy8zwl9DdNy4pirVXNABF1xIFJ8kHkluLW3I1V0XdG+5YzWhtra57S3xAkYQCg+VkWwLpSdhRUgfBrLedAeqA9uX8mZnjSqG/2ohOQNcw4o7mV+/4quIKW5gRyxYf+dtdYho3hrsuLXug+yBqrjAV3lIREeb2dFcjC+d/Orv1daehuW5KhcvKx0Yl3bZP9pMMXb98KbPj3l3fF5Yy4L7ix0ZoZD5NkWs9OrwVCh2s/IEMERw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88KUplDbAnXbtL48WSNQn2DMO8FH5x5Ktbz9a9UhGsw=;
 b=S5rSoJJFwKq+tpkUmUX1dqYtdMynpevuvwGCoRDXH0Ixg9eyHMS4KsfvvHBMN8HMUPsXf7kgKXAp2sdIb8S4OMTCualPUMh7pBLAlwrYljoZP1BYAM/BaRYl0Jwq3+iJTqLqk3xRdbC/YcniqggtYq/QgQY+zggpJ8rAgX39kfX9dyirVqJUKU4B1Kjuow84RzD9wxqr8BlWeoGe2tgRdfZTSE88+gxRhJD4hVkEO5zm4zjQl9Dm1tgt/0eXbFHQBeuf1xkh52gZgkSKc4gDrVTKxNdZFN3InhAdTdW9lCppkAUDhLAP4bgzxQh+IgioZrZIey9sqzzTsxhZzJ9bGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=88KUplDbAnXbtL48WSNQn2DMO8FH5x5Ktbz9a9UhGsw=;
 b=QaLRGRVS9f2TJaMRoetQVPZAMimGZrHlDdAMqN8fcAXpfHOm04tB0bGM/XsUhielN/Rab8cxHtgdMHDpz2AhCnN7+yM8ujEBn8o7dSXgNueDGIbOVx5ziT8zoLxb3+if6hiyZfReXPkF1UJAmuvd5aIejlvNU0d+PQJrnkRX3Fw=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB4605.eurprd04.prod.outlook.com (20.177.53.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Wed, 13 Nov 2019 14:00:05 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::9470:d3aa:b0e0:9a9b]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::9470:d3aa:b0e0:9a9b%6]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 14:00:05 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "HEMANT RAMDASI (hramdasi)" <hramdasi@cisco.com>,
        "Daniel Walker (danielwa)" <danielwa@cisco.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sathish Jarugumalli -X (sjarugum - ARICENT TECHNOLOGIES HOLDINGS
        LIMITED at Cisco)" <sjarugum@cisco.com>
Subject: RE: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Topic: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Index: AQHVmWkzb/KVHeRA/ECvEdv93vqv/qeHvtCAgAACaQCAAAFWgIAAB7IAgAFH0xA=
Date:   Wed, 13 Nov 2019 14:00:05 +0000
Message-ID: <VI1PR04MB4880A48175A5FE0F08AB7B2196760@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <1573570511-32651-1-git-send-email-claudiu.manoil@nxp.com>
 <20191112164707.GQ18744@zorba>
 <E84DB6A8-AB7F-428C-8A90-46A7A982D4BF@cisco.com>
 <VI1PR04MB4880787A714A9E49A436AD2496770@VI1PR04MB4880.eurprd04.prod.outlook.com>
 <873EB68B-47CB-44D6-80BD-48DD3F65683B@cisco.com>
In-Reply-To: <873EB68B-47CB-44D6-80BD-48DD3F65683B@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5e2ac3d1-7850-455a-6014-08d76841c91b
x-ms-traffictypediagnostic: VI1PR04MB4605:
x-microsoft-antispam-prvs: <VI1PR04MB46053B84D4F8E8DD3C91DBD696760@VI1PR04MB4605.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(136003)(346002)(396003)(39860400002)(13464003)(199004)(189003)(102836004)(81156014)(14454004)(110136005)(26005)(316002)(7696005)(44832011)(81166006)(186003)(8936002)(305945005)(25786009)(486006)(7736002)(33656002)(76176011)(6246003)(2906002)(5660300002)(66066001)(54906003)(8676002)(6506007)(99286004)(74316002)(64756008)(6116002)(71190400001)(71200400001)(229853002)(446003)(14444005)(66946007)(66556008)(476003)(11346002)(478600001)(3846002)(4326008)(52536014)(76116006)(9686003)(86362001)(6436002)(66446008)(55016002)(256004)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4605;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dstC4/CyC4T6bjDwW+3gmaa2CYoUQnbWyKEMpJ/tf+oYNlP6Lo9t6Ynt7f1scbjoRAnS1GeOYoWCkPWb2SnCG3l0Rw+Yl3iNUCu3J44dPeCroupGSttyZU7HVNauHfFhsdE0Rz4o47MXKD5p3fSadJl3/jhj2AAy9dHE4R4FmYWfDXzwY+kjXCwQyi4cDZRBO849d82mVr0dSdnHsB8nLpvhsMD3v+ld4wQEviizdsw6DBQ93sPnQmLkaM0DPdOGwZi4xnLt5ucih0XLVa3GY1GZTKznuze9jCap4sxXf01esJ7x6PBwXVpJW/VcjDQlMmlSH1pImkkGvbwfoWfom5ffk92kwglIk4JZVKc3ecNeWygSzNtktVFQXqhZ/xtUxYgunD09lrhU1FwDpTYTWdrmIVd9nQhOZOntFsIOxcI+u2XjrkCinEXUp7fDD2/A
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e2ac3d1-7850-455a-6014-08d76841c91b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 14:00:05.1912
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M9XF1FtQC4jiw3UC32+DzFVvGAesX1YSpdwQT5+/PW8/LbxrWaTSNlbqYbYdXg5K8V3lIpa2Gbmdep0D9U9ZCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4605
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogSEVNQU5UIFJBTURBU0kgKGhyYW1k
YXNpKSA8aHJhbWRhc2lAY2lzY28uY29tPg0KWy4uLl0NCj4+IFRoaXMgYml0IG11c3QgYmUgc2V0
IHdoZW4gaW4gaGFsZi1kdXBsZXggbW9kZSAoTUFDQ0ZHMltGdWxsX0R1cGxleF0gaXMgY2xlYXJl
ZCkuDQo+DQo+IFNob3VsZCB0aGUgYml0IGJlIGNsZWFyIHdoZW4gaW4gZnVsbCBkdXBsZXggb3Ig
aXQgZG9lcyBub3QgbWF0dGVyPw0KPg0KDQpGcm9tIG15IHRlc3RzLCBpbiBmdWxsIGR1cGxleCBt
b2RlIHNtYWxsIGZyYW1lcyB3b24ndCBnZXQgcGFkZGVkIGlmIHRoaXMgYml0IGlzIGRpc2FibGVk
LA0KYW5kIHdpbGwgYmUgY291bnRlZCBhcyB1bmRlcnNpemUgZnJhbWVzIGFuZCBkcm9wcGVkLiBT
byB0aGlzIGJpdCBuZWVkcyB0byBiZSBzZXQNCmluIGZ1bGwgZHVwbGV4IG1vZGUgdG8gZ2V0IHBh
Y2tldHMgc21hbGxlciB0aGFuIDY0QiBwYXN0IHRoZSBNQUMgKHcvbyBzb2Z0d2FyZSBwYWRkaW5n
KS4NClRoZSBzdGF0ZW1lbnQgYWJvdmUgbGlrZWx5IG1lYW5zIHRoYXQgZm9yIGhhbGYtZHVwbGV4
IG1vZGUgcGFja2V0cyBjYW5ub3QgZWdyZXNzDQp0aGUgTUFDIHJlZ2FyZGxlc3Mgb2YgdGhlaXIg
c2l6ZSBpZiB0aGUgUEFEX0NSQyBiaXQgaXMgbm90IHNldC4gIEF0IGxlYXN0IHRoaXMgaXMgY29u
c2lzdGVudA0Kd2l0aCBteSBleHBlcmltZW50cy4NCg0KPj4gMCBGcmFtZXMgcHJlc2VudGVkIHRv
IHRoZSBNQUMgaGF2ZSBhIHZhbGlkIGxlbmd0aCBhbmQgY29udGFpbiBhIENSQy4NCj4+IDEgVGhl
IE1BQyBwYWRzIGFsbCB0cmFuc21pdHRlZCBzaG9ydCBmcmFtZXMgYW5kIGFwcGVuZHMgYSBDUkMg
dG8gZXZlcnkgZnJhbWUNCj4+IHJlZ2FyZGxlc3Mgb2YgcGFkZGluZyByZXF1aXJlbWVudC4iDQo+
Pg0KPj4gU28gdGhlIGRyaXZlciBzZXRzIHRoaXMgYml0IHRvIGhhdmUgc21hbGwgZnJhbWVzIHBh
ZGRlZC4gSXQgYWx3YXlzIHdvcmtlZA0KPj4gdGhpcyB3YXksIGFuZCBJIHJldGVzdGVkIG9uIFAy
MDIwUkRCIGFuZCBMUzEwMjFSREIgYW5kIHdvcmtzLg0KPj4gQXJlIHlvdSBzYXlpbmcgdGhhdCBw
YWRkaW5nIGRvZXMgbm90IHdvcmsgb24geW91ciBib2FyZCB3aXRoIHRoZSBjdXJyZW50DQo+PiB1
cHN0cmVhbSBjb2RlPw0KPg0KPkl0IHdvcmtzIGJ1dCB0aGUgc2V0dGluZ3MgZG9lcyBub3QgbWF0
Y2ggd2l0aCB3aGF0J3MgbWVudGlvbmVkIGluIHAyMDIwIHJtDQo+YW5kIHRoZSBiaXQgMjkgYmVj
b21lcyByZWR1bmRhbnQuDQo+DQoNClNvLCB0aGUgUEFEX0NSQyBiaXQgaXMgbm90IHJlZHVuZGFu
dCwgYW5kIGZvciBoYWxmLWR1cGxleCBtb2RlIGl0IGxvb2tzIGxpa2UgdGhpcyBiaXQgaXMNCmV2
ZW4gbWFuZGF0b3J5IHRvIGhhdmUgVHggdHJhZmZpYyBhdCBhbGwuDQoNClRoaXMgcGF0Y2ggaXMg
aG93ZXZlciBub3QgYWJvdXQgdGhlIFBBRF9DUkMgYml0LiBJdCdzIGFib3V0IGRlZmF1bHQgaW50
ZXJmYWNlIG1vZGUNCnNldHRpbmcgaW4gdGhlIE1BQ0NGRzIgcmVnaXN0ZXIuICBBbmQgSSBqdXN0
IG5vdGljZWQgdG8gbXkgc3VycHJpc2UgdGhhdCB3aXRoIHRoZSBkZWZhdWx0DQpyZXNldCB2YWx1
ZSBmb3IgaW50ZXJmYWNlIG1vZGUgKDAwYikgdGhlIFNHTUlJIGxpbmsgd29uJ3QgZ2V0IHVwIG9u
IG15IFAyMDIwUkRCLVBDDQpib2FyZCwgd2hpbGUgdGhlIFJHTUlJIGxpbmtzIGRvbid0IGhhdmUg
dGhpcyBwcm9ibGVtLiAgT24gdGhlIG5ld2VyIExTMTAyMUFUV1IgYm9hcmQNCnRoZXJlJ3Mgbm8g
c3VjaCBpc3N1ZSAoYm90aCBzZ21paSBhbmQgcmdtaWkgbGlua3Mgd29yayB3aXRoIGRlZmF1bHQg
SUZfTW9kZSBvZiAwMCkuDQpTbyBsb29rcyBsaWtlIElGX01vZGUgd2FzIGJlaW5nIGluaXRpYWxp
emVkIHRvICJieXRlIG1vZGUiICgxMGIsIGFrYSBSR01JSSAxRyBtb2RlKQ0Kd2l0aCBhIHJlYXNv
biwgc28gdGhhdCBvbGRlciBib2FyZHMgaGF2ZSBmdW5jdGlvbmFsIGxpbmtzIGluIGFsbCBjYXNl
cyAoaS5lLiBzZ21paSkuDQoNCkJldHRlciB0byBkcm9wIHRoaXMgcGF0Y2ggZm9yIG5vdyB0byBh
dm9pZCBzdWNoIHJlZ3Jlc3Npb25zIGZvciBvbGRlciBib2FyZHMuICBUaGlzIGlzIHdoYXQNCmhh
cHBlbnMgd2hlbiBsZWdhY3kgZHJpdmVyIGNvZGUgbGlrZSB0aGlzIGdldHMgY2hhbmdlZC4gIEkn
bGwgaGF2ZSB0byBhc2sgaC93IHBwbCBmb3INCmNsYXJpZmljYXRpb24gb24gdGhpcy4NCg0KVGhh
bmtzLA0KQ2xhdWRpdQ0KDQo=
