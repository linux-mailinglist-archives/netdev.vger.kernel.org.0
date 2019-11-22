Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 548EA1075A7
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 17:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfKVQUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 11:20:49 -0500
Received: from mail-eopbgr130087.outbound.protection.outlook.com ([40.107.13.87]:43587
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726666AbfKVQUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 11:20:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hz0GjfrXHSbLnn0enlooOoAmU5XwZRHCJXNhawVX6u46y91HQc1y3dYJM1wDuOsah6ucrhHdaDkgr5QFizduvUn0Er2aOrvlJQEBVlu5vWLNTrU7qSa9J+9EPxYZjsQtuPpc9zZHVN3dEDOsOKl/LUSgqcRbJa2C9RUWr3ib+NRLVzBvMi6keo+tdBNxx1cWSnD13BKc3YKG0ivB4KFhmR3HUXWS4RZnKilLGkpbeM7vmAVTX9qgRzSIT5LR08WQOvcllTu6+5BqhOPE4chwoU/5sL0bn7quKzwzD8K07dtEz1E/aI/ChQladyd9vm+HYieczeR6ZL0TGHKJAyfJpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OV8biwzKnuliyVgpA7wYfPu0R46XBZbmbtOwED5Ncfg=;
 b=lYf984fJjxNKiRf15D1ymqmZpS2mriB5IvDfDIxN+F4d+Xz6Qr3YlkbK3AguQcvAsg265/L60yCdhWH7mZUVCSFMYy70eTqkjWpK6C9rhymPmVR3hb+sxD955QFlYBIJUMbupnosG0+TWTnLhhVm1haQFlfso2f4c/JbGrpU7+P4Yv49if4FY2wUi7iynn5mJ2C59sxvecaX7o8QUDotK7qy9pLR0nRYj6XbflwQC0EgOq9vXXeUYPqU3gKUhc74QN22W7LF0kFwRwj3mB+xav8eJS3miN26FpvH+BHfPXsiLCYlba3OHCEA3mgmC0RunRMHfuEHKLqHuSjQGWQnIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OV8biwzKnuliyVgpA7wYfPu0R46XBZbmbtOwED5Ncfg=;
 b=rehbSkgY2lwopjF9r+giWKDBNJtJLyMxwu3CY9BQHkOpJR/bZWq0SFFtv4drmm71r46Eu/eYGWzi/2ENl2lBD6KSRFtCy2cJLNGOIRlIAkzpLoMU3GDPtJwS23FB39IBYN6oI/4XFb9MZVgzpmvQJeZqMcClYPWeEE//gj2v+A0=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.83) by
 VI1PR04MB5693.eurprd04.prod.outlook.com (20.178.126.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Fri, 22 Nov 2019 16:20:42 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::64f5:d1f5:2356:bdcb]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::64f5:d1f5:2356:bdcb%6]) with mapi id 15.20.2474.021; Fri, 22 Nov 2019
 16:20:41 +0000
From:   Alexandru Marginean <alexandru.marginean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: binding for scanning a MDIO bus
Thread-Topic: binding for scanning a MDIO bus
Thread-Index: AQHVoTDE9xOhoRGcSEOsjw1fon1gC6eXS04AgAAT4AA=
Date:   Fri, 22 Nov 2019 16:20:41 +0000
Message-ID: <a6f797cf-956e-90d9-0bb3-11e752b8a818@nxp.com>
References: <7b6fc87b-b6d8-21e6-bd8d-74c72b3d63a7@nxp.com>
 <20191122150932.GC6602@lunn.ch>
In-Reply-To: <20191122150932.GC6602@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=alexandru.marginean@nxp.com; 
x-originating-ip: [178.199.190.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7c3b4771-aec7-4ce9-4549-08d76f67eb7a
x-ms-traffictypediagnostic: VI1PR04MB5693:
x-microsoft-antispam-prvs: <VI1PR04MB56931F887F9270A9E8A790DBF5490@VI1PR04MB5693.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02296943FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(53754006)(199004)(189003)(6506007)(3846002)(66476007)(66446008)(91956017)(66556008)(64756008)(66946007)(6116002)(76176011)(31686004)(66066001)(76116006)(36756003)(4326008)(6246003)(316002)(99286004)(54906003)(554214002)(81166006)(81156014)(229853002)(8676002)(71200400001)(71190400001)(256004)(6512007)(6486002)(2906002)(6436002)(8936002)(11346002)(7736002)(446003)(26005)(2616005)(44832011)(6916009)(305945005)(25786009)(478600001)(31696002)(14454004)(86362001)(53546011)(186003)(5660300002)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5693;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SB9NVU4cDxDRkLcfdvOvcsM2Qn973sG/ixBvGea4RT2AoKrNvA0dhz3nvCCFX36+iaXt8zjQTnEEizMmipyyGvdo66iJaq992cm14TH0szLTr814+ScL1mgwmyVQKikwcgez0VxJS3ubQTDMsz0+QYth4F+uImJ9SNqn/nLsAfUpn/p+kGspJ0ujB6sED/9bxr2rxguuIMo8Gf2zvMhR/ZOHxfCeajgn99qiJ8iAbWxnsoxYWFB9Q8Ea0B1oIi/ngIws4am+IodadRmMId/w48KwhzDONBaV9YMJTc/meXEC2VYW0lEl3OksvNksY4Jkb2EPmLS8haoUAk5Sq30yfgSerQjNPwO24xIlPB39YkuHdDwZCxIV9736YJU1wCobYZ+xDhuup+LHmYBZoL4ugLuibI1IRcwlH2e3oa8ClGU8YIp93mBmMVLgXRRMf/jW
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <0B5417C02B09F0438DDFBC958BF06420@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c3b4771-aec7-4ce9-4549-08d76f67eb7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2019 16:20:41.6949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0+yg/hjy29vIFsEznblF03NG9kiQxkNLKABAE7wScirvgsG1KmTxVj6YNy0JjUdpEchVfoYfYxl1M79jzFa27AiKDCCLhM0VJ+V6qjrz3l4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiAxMS8yMi8yMDE5IDQ6MDkgUE0sIEFuZHJldyBMdW5uIHdyb3RlOg0K
PiBPbiBGcmksIE5vdiAyMiwgMjAxOSBhdCAxMjozMTozMFBNICswMDAwLCBBbGV4YW5kcnUgTWFy
Z2luZWFuIHdyb3RlOg0KPj4gSGkgZXZlcnlvbmUsDQo+Pg0KPj4gSSBhbSBsb29raW5nIGZvciB0
aGUgcHJvcGVyIGJpbmRpbmcgdG8gc2NhbiBmb3IgYSBQSFkgb24gYW4gTURJTyBidXMNCj4+IHRo
YXQncyBub3QgYSBjaGlsZCBvZiB0aGUgRXRoZXJuZXQgZGV2aWNlIGJ1dCBvdGhlcndpc2UgaXMg
YXNzb2NpYXRlZA0KPj4gd2l0aCBpdC4gIFNjYW5uaW5nIHRoaXMgYnVzIHNob3VsZCBndWFyYW50
ZWUgZmluZGluZyB0aGUgY29ycmVjdCBQSFksIGlmDQo+PiBvbmUgZXhpc3RzLiAgQXMgZmFyIGFz
IEkgY2FuIHRlbGwgY3VycmVudCBiaW5kaW5ncyBkb24ndCBhbGxvdyBzdWNoDQo+PiBhc3NvY2lh
dGlvbiwgYWx0aG91Z2ggdGhlIGNvZGUgc2VlbXMgdG8gc3VwcG9ydCBpdC4NCj4+DQo+PiBUaGUg
aGFyZHdhcmUgdGhhdCBJJ20gdXNpbmcgYW5kIGNvdWxkIHVzZSBzdWNoIGEgYmluZGluZyBpcyBh
IE5YUCBRRFMNCj4+IGJvYXJkIHdpdGggUEhZIGNhcmRzLiAgSW4gcGFydGljdWxhciB0aGlzIGlz
IGEgTFMxMDI4QSwgYnV0IHRoZSBwcm9ibGVtDQo+PiBpcyBjb21tb24gdG8gdGhlIE5YUCBRRFMg
Ym9hcmRzLiAgVGhlc2UgY2FyZHMgd2lyZSBNRElPIHVwIHRvIHRoZSBDUFUNCj4+IHRocm91Z2gg
YSBtdXguICBUaGUgbXV4IHByYWN0aWNhbGx5IHNlbGVjdHMgb25lIG9mIHRoZSBzbG90cy9jYXJk
cyBzbw0KPj4gdGhlIE1ESU8gYnVzIHRoZSBQSFkgaXMgb24gaXMgcHJpdmF0ZSB0byB0aGUgc2xv
dC9jYXJkLg0KPj4gRWFjaCBzbG90IGlzIGFsc28gYXNzb2NpYXRlZCB3aXRoIGFuIEV0aGVybmV0
IGludGVyZmFjZSwgdGhpcyBpcyBzdWJqZWN0DQo+PiB0byBzZXJkZXMgY29uZmlndXJhdGlvbiBh
bmQgc3BlY2lmaWNhbGx5IGZvciB0aGF0IEknbSBsb29raW5nIHRvIGFwcGx5IGENCj4+IERUIG92
ZXJsYXkuICBPdmVybGF5cyBhcmUgcmVhbGx5IGltcHJhY3RpY2FsIHdpdGggdGhlIFBIWSBjYXJk
cyB0aG91Z2gsDQo+PiB0aGVyZSBhcmUgc2V2ZXJhbCB0eXBlcyBvZiBjYXJkcywgbnVtYmVyIG9m
IHNsb3RzIGNhbiBnbyB1cCB0byA4IG9yIHNvDQo+PiBvbiBzb21lIHR5cGVzIG9mIFFEUyBib2Fy
ZHMgYW5kIG51bWJlciBvZiBQSFkgY2FyZCBvdmVybGF5cyB0aGF0IHNob3VsZA0KPj4gYmUgZGVm
aW5lZCB3b3VsZCBibG93IHVwLiAgVGhlIG51bWJlciBvZiBvdmVybGF5cyB1c2VycyB3b3VsZCBu
ZWVkIHRvDQo+PiBhcHBseSBhdCBib290IHdvdWxkIGFsc28gZ28gdXAgdG8gbnVtYmVyIG9mIHNs
b3RzICsgMS4NCj4+DQo+PiBUaGUgZnVuY3Rpb24gb2ZfbWRpb2J1c19yZWdpc3RlciBkb2VzIHNj
YW4gZm9yIFBIWXMgaWYgJ3JlZycgaXMgbWlzc2luZw0KPj4gaW4gUEhZIG5vZGVzLCBpcyB0aGlz
IGNvZGUgY29uc2lkZXJlZCBvYnNvbGV0ZSwgaXMgaXQgT0sgdG8gdXNlIGl0IGlmDQo+PiBuZWVk
ZWQgYnV0IG90aGVyd2lzZSBkaXNjb3VyYWdlZD8gIEFueSB0aG91Z2h0cyBvbiBpbmNsdWRpbmcg
c3VwcG9ydCBmb3INCj4+IHNjYW5uaW5nIGluIHRoZSBiaW5kaW5nIGRvY3VtZW50LCBsaWtlIG1h
a2luZyAncmVnJyBwcm9wZXJ0eSBpbiBwaHkNCj4+IG5vZGVzIG9wdGlvbmFsPw0KPj4NCj4+IEZv
ciB3aGF0IGlzIHdvcnRoIHNjYW5uaW5nIGlzIGEgZ29vZCBzb2x1dGlvbiBpbiBzb21lIGNhc2Vz
LCBiZXR0ZXIgdGhhbg0KPj4gb3RoZXJzIGFueXdheS4gIEknbSBzdXJlIGl0J3Mgbm90IGp1c3Qg
cGVvcGxlIGJlaW5nIHRvbyBsYXp5IHRvIHNldCB1cA0KPj4gJ3JlZycgdGhhdCB1c2UgdGhpcyBj
b2RlLg0KPiANCj4gSGkgQWxleGFuZHJ1DQo+IA0KPiBZb3Ugb2Z0ZW4gc2VlIHRoZSBidXMgcmVn
aXN0ZXJlZCB1c2luZyBtZGlvYnVzX3JlZ2lzdGVyKCkuIFRoYXQgdGhlbg0KPiBtZWFucyBhIHNj
YW4gaXMgcGVyZm9ybWVkIGFuZCBhbGwgcGh5cyBvbiB0aGUgYnVzIGZvdW5kLiBUaGUgTUFDDQo+
IGRyaXZlciB0aGVuIHVzZXMgcGh5X2ZpbmRfZmlyc3QoKSB0byBmaW5kIHRoZSBmaXJzdCBQSFkg
b24gdGhlIGJ1cy4NCj4gVGhlIGRhbmdlciBoZXJlIGlzIHRoYXQgdGhlIGhhcmR3YXJlIGRlc2ln
biBjaGFuZ2VzLCBzb21lYm9keSBhZGRzIGENCj4gc2Vjb25kIFBIWSwgYW5kIGl0IGFsbCBzdG9w
cyB3b3JraW5nIGluIGludGVyZXN0aW5nIGFuZCBjb25mdXNpbmcNCj4gd2F5cy4NCj4gDQo+IFdv
dWxkIHRoaXMgd29yayBmb3IgeW91Pw0KPiANCj4gICAgICAgIEFuZHJldw0KPiANCg0KSG93IGRv
ZXMgdGhlIE1BQyBnZXQgYSByZWZlcmVuY2UgdG8gdGhlIG1kaW8gYnVzIHRob3VnaCwgaXMgdGhl
cmUgc29tZSANCndheSB0byBkZXNjcmliZSB0aGlzIHJlbGF0aW9uc2hpcCBpbiB0aGUgRFQ/ICBJ
IGRpZCBzYXkgdGhhdCBFdGggYW5kIA0KbWRpbyBhcmUgYXNzb2NpYXRlZCBhbmQgdGhleSBhcmUs
IGJ1dCBub3QgaW4gdGhlIHdheSBFdGggd291bGQganVzdCBrbm93IA0Kd2l0aG91dCBsb29raW5n
IGluIHRoZSBEVCB3aGF0IG1kaW8gdGhhdCBpcy4gIEl0J3Mgb25seSB0aGF0IG9uZSBzdWNoIA0K
bWRpbyBleGlzdHMgZm9yIGEgZ2l2ZW4gRXRoIGFuZCBpdCdzIHNhZmUgdG8gdXNlLCBidXQgRXRo
IG5lZWRzIHRvIGJlIA0KdG9sZCB3aGVyZSB0byBmaW5kIGl0IGFuZCB0aGF0IGluZm9ybWF0aW9u
IHNob3VsZCBjb21lIGZyb20gdGhlIERULg0KDQpNZGlvIGJ1c2VzIG9mIHNsb3RzL2NhcmRzIGFy
ZSBkZWZpbmVkIGluIERUIHVuZGVyIHRoZSBtZGlvIG11eC4gIFRoZSBtdXggDQppdHNlbGYgaXMg
YWNjZXNzZWQgb3ZlciBJMkMgYW5kIGl0cyBwYXJlbnQtbWRpbyBpcyBhIHN0YW5kLWFsb25lIGRl
dmljZSANCnRoYXQgaXMgbm90IGFzc29jaWF0ZWQgd2l0aCBhIHNwZWNpZmljIEV0aGVybmV0IGRl
dmljZS4gIEFuZCBvbiB0b3Agb2YgDQp0aGF0LCBiYXNlZCBvbiBzZXJkZXMgY29uZmlndXJhdGlv
biwgc29tZSBFdGggaW50ZXJmYWNlcyBtYXkgZW5kIHVwIG9uIGEgDQpkaWZmZXJlbnQgc2xvdCBh
bmQgZm9yIHRoYXQgSSB3YW50IHRvIGFwcGx5IGEgRFQgb3ZlcmxheSB0byBzZXQgdGhlIA0KcHJv
cGVyIEV0aC9tZGlvIGFzc29jaWF0aW9uLg0KDQpDdXJyZW50IGNvZGUgYWxsb3dzIG1lIHRvIGRv
IHNvbWV0aGluZyBsaWtlIHRoaXMsIGFzIHNlZW4gYnkgTGludXggb24gYm9vdDoNCi8gew0KLi4u
Lg0KCW1kaW8tbXV4IHsNCgkJLyogc2xvdCAxICovDQoJCW1kaW9ANCB7DQoJCQlzbG90MV9waHkw
OiBwaHkgew0KCQkJCS8qICdyZWcnIG1pc3Npbmcgb24gcHVycG9zZSAqLw0KCQkJfTsNCgkJfTsN
Cgl9Ow0KLi4uLg0KfTsNCg0KJmVuZXRjX3BvcnQwIHsNCglwaHktaGFuZGxlID0gPCZzbG90MV9w
aHkwPjsNCglwaHktbW9kZSA9ICJzZ21paSI7DQp9Ow0KDQpCdXQgdGhlIGJpbmRpbmcgZG9lcyBu
b3QgYWxsb3cgdGhpcywgJ3JlZycgaXMgYSByZXF1aXJlZCBwcm9wZXJ0eSBvZiANCnBoeXMuICBJ
cyB0aGlzIGtpbmQgb2YgRFQgc3RydWN0dXJlIGFjY2VwdGFibGUgZXZlbiBpZiBpdCdzIG5vdCAN
CmNvbXBsaWFudCB0byB0aGUgYmluZGluZz8gIEFzc3VtaW5nIGl0J3MgZmluZSwgYW55IHRob3Vn
aHRzIG9uIG1ha2luZyANCnRoaXMgb2ZmaWNpYWwgaW4gdGhlIGJpbmRpbmc/ICBJZiBpdCdzIG5v
dCwgYXJlIHRoZXJlIGFsdGVybmF0aXZlIA0Kb3B0aW9ucyBmb3Igc3VjaCBhIHNldC11cD8NCg0K
VGhhbmtzIQ0KQWxleA==
