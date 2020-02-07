Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D9D15592D
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 15:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727144AbgBGOVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 09:21:38 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:57976 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgBGOVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 09:21:37 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Codrin.Ciubotariu@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Codrin.Ciubotariu@microchip.com";
  x-sender="Codrin.Ciubotariu@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Codrin.Ciubotariu@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Codrin.Ciubotariu@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 7+/xT53pIfUeFXwb2sQDoBW6ZxdP3qgve3pCIi/yKohMwoW928jjHk9QBSaWVDosJdwGVJg2aV
 R+Ll+eF3qHVOsMtz+r/nbMcNMlir8flHD3rHglmJUarY+0aTeBJQWG45Am23jcKr7Cc0HPlH+N
 n+WmgRTUI2utpmPVsEy4i2jM6y0uR5rWMvnBawDfiOzmYVc/9KhwGzLTR+1zwE2Ms+Pm/hy+tw
 ryZQw7G25gdzU5Q28QNq/xlETfBvkQFjH0lNU/WGmm5C72w3kXRvaDc4I0YEHTLFNcOcQ3/l7Q
 0VI=
X-IronPort-AV: E=Sophos;i="5.70,413,1574146800"; 
   d="scan'208";a="63492528"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Feb 2020 07:21:36 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 7 Feb 2020 07:21:36 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Fri, 7 Feb 2020 07:21:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuBtBVG+kCOSz8faAmda6fgWYbHld8eXbA/yjfg9EUjeUmYnPoMJ9swatvpEYFqY1pu6Uo4/RYO+JvZ2eDyVJQ9l3WeKrhKkLT5yMHklEbqTFy8hEC1lmiSh4H6MMCu4aydA3z172ITvOnj7Mz7dwW5KvjNEZxXs4GK8IMouoFd6FTARkzQ/OfeEqBi0xj4OYiGWhnfz5HMw2TwPwCIJF7dyOmcVk8gBZjb1DSwHb/x4gsDjq6uXyGyDhSGIZkuAk+mnbnjDYb/ctCTyjOdiGT8CdZ1SFiCSp/h9h+c4sN531sK1Mvk3JZH+S3nSq6otFPw/UKXMov5LSdCJEmhRqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=feKy6DWz880UZc0ORCEU0sSn2dhidrRUlqPDHJj+B3k=;
 b=kV2kbj1AUHdmOQkuGGZJEnoUKa/sGTpnvFZbb0C9uN2wxyJ9DsBvJZrg27HjDD8UMm+c32bEyt/UuglwVMbD/E4jnZX8shsracYJJi0EGURD5uJx0ZYlPkRL2I+aSyzNO7A23Y0ln4NGDqIbJ6AEG9c1pHnqFzg3UrX0HJ9eykjw23NlU1C8hBiSw/sZk7RIgyXuQx54DkQlfZvSxDr4pj9LNXqu8WliLUhZopJ1DGtVYydG1IOE6kGOO8er6yZ18dpK2C/uldAsmZ0pBmUfRd87B1gtQ7mwVliqpvhDcEGMlt5JsONQRHVWNeL3GjlPTKHaM30fQNCmo0ws7mrsyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=feKy6DWz880UZc0ORCEU0sSn2dhidrRUlqPDHJj+B3k=;
 b=RgS7QA+Tsly7BoegklXyB9JYcQRfkP2BqJd9llKNuUwJAwWkKomsC7JJfVOkgf0cfsQWAPaLhz6nA0uEaZij3i+sx9d8emaHIlHuJyMH1Od6E3+k6fJ5qVyjxFfP0lc/Zpf5OUsBUZ4yDugJO7qgaVpZqtPXr6mJ8jvhbmDbjyA=
Received: from BY5PR11MB4497.namprd11.prod.outlook.com (52.132.255.220) by
 BY5PR11MB4136.namprd11.prod.outlook.com (10.255.163.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Fri, 7 Feb 2020 14:21:33 +0000
Received: from BY5PR11MB4497.namprd11.prod.outlook.com
 ([fe80::6189:c32:b55b:b3fd]) by BY5PR11MB4497.namprd11.prod.outlook.com
 ([fe80::6189:c32:b55b:b3fd%5]) with mapi id 15.20.2686.036; Fri, 7 Feb 2020
 14:21:33 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <davem@davemloft.net>, <razvan.stefanescu@microchip.com>
Subject: Re: [PATCH v2] net: dsa: microchip: enable module autoprobe
Thread-Topic: [PATCH v2] net: dsa: microchip: enable module autoprobe
Thread-Index: AQHV3aP1ewmfJeQmlEOtwOp6VPo6KagPurwAgAANxYA=
Date:   Fri, 7 Feb 2020 14:21:32 +0000
Message-ID: <479af7b8-fc94-2d01-744f-b93ed31388ce@microchip.com>
References: <20200207104643.1049-1-codrin.ciubotariu@microchip.com>
 <20200207133214.GB14393@lunn.ch>
In-Reply-To: <20200207133214.GB14393@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 687681ea-031a-4e10-952a-08d7abd90847
x-ms-traffictypediagnostic: BY5PR11MB4136:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB4136125C8D4B4F33B479DA9BE71C0@BY5PR11MB4136.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0306EE2ED4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(396003)(136003)(39860400002)(199004)(189003)(6486002)(36756003)(2616005)(4326008)(64756008)(66556008)(66446008)(66946007)(66476007)(31686004)(76116006)(31696002)(86362001)(6512007)(478600001)(5660300002)(8676002)(316002)(26005)(91956017)(8936002)(53546011)(81156014)(71200400001)(81166006)(6506007)(6916009)(54906003)(107886003)(186003)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY5PR11MB4136;H:BY5PR11MB4497.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bVbXGCwilBiw3jFd/g2hDllpRozV/PYRRJTgTMDLXldRH8DrPx10Hp0waPK3s4hE0iF5UG7HeZY8gC6Y3jwm0sJ9UPjFWxAcy8em7ge0Kr2f/yAJGqpA1PcInsEhVt/KtH5ghyOoUHJyTbC2GEsWkJSHdHslnY4SQgRSF0AVIzUD+BrLOyKWonDpiCsi/FZVIiOU8Z+wd5zoYdCGGawxjEkDfRqL5FWe5GZXSe0WsonfHPbaQJylXfRAy868uqw/t/7Q5D2IvB03iMpuMT7kV5i8NqRb4wmAdd1egbTD0IrwRg8ub8eNn/h6UT62QlatG7KliiwTOtVKuzFyGHxCyVfIi2mi+pN3/KfjJVcQv7TUYRoE9MfciGT1QSm7wjtNV8qnczHpVEvUqnPU71eypk1bPTk2Rm4meVtFHWjtTCemU+EW+84lhKVgvd4CuMw3
x-ms-exchange-antispam-messagedata: 12LIehlWrCKSo4zbDGsDSwaR458BAjgXbp0vrL/K6nL7kHrLdheyMEj+8I+MXbuUY3BmcjQjg5l9Cfy2/xm1E3vgUwPGhRTy12gIK0kCmPrT7VWZ5cxT9RV7KLkPfRTMuGUGKe+KNd4luaGFEU4hSw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <D1D0ECBD5E117748B4CD016B61A34149@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 687681ea-031a-4e10-952a-08d7abd90847
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2020 14:21:32.9957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W3ZGFjIPW7Q0QRsyCyfYG7v3G3MV5IaKMxjagghJbNgWFkLA7ZdbwqfSSrHgR89HKQ/wRhgkpo8IQOcdSdQqrQQqUlRWX27rN7boRQoKib0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDcuMDIuMjAyMCAxNTozMiwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IE9uIEZyaSwgRmViIDA3
LCAyMDIwIGF0IDEyOjQ2OjQzUE0gKzAyMDAsIENvZHJpbiBDaXVib3Rhcml1IHdyb3RlOg0KPj4g
RnJvbTogUmF6dmFuIFN0ZWZhbmVzY3UgPHJhenZhbi5zdGVmYW5lc2N1QG1pY3JvY2hpcC5jb20+
DQo+Pg0KPj4gVGhpcyBtYXRjaGVzIC9zeXMvZGV2aWNlcy8uLi4vc3BpMS4wL21vZGFsaWFzIGNv
bnRlbnQuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogUmF6dmFuIFN0ZWZhbmVzY3UgPHJhenZhbi5z
dGVmYW5lc2N1QG1pY3JvY2hpcC5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBDb2RyaW4gQ2l1Ym90
YXJpdSA8Y29kcmluLmNpdWJvdGFyaXVAbWljcm9jaGlwLmNvbT4NCj4+IC0tLQ0KPj4NCj4+IENo
YW5nZXMgaW4gdjI6DQo+PiAgIC0gYWRkZWQgYWxpYXMgZm9yIGFsbCB0aGUgdmFyaWFudHMgb2Yg
dGhpcyBkcml2ZXINCj4+DQo+PiAgIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3N19z
cGkuYyB8IDYgKysrKysrDQo+PiAgIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKykNCj4+
DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3X3NwaS5j
IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3X3NwaS5jDQo+PiBpbmRleCBjNWY2
NDk1OWExODQuLjExNDI3Njg5NjljMiAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9t
aWNyb2NoaXAva3N6OTQ3N19zcGkuYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hp
cC9rc3o5NDc3X3NwaS5jDQo+PiBAQCAtMTAxLDYgKzEwMSwxMiBAQCBzdGF0aWMgc3RydWN0IHNw
aV9kcml2ZXIga3N6OTQ3N19zcGlfZHJpdmVyID0gew0KPj4NCj4+ICAgbW9kdWxlX3NwaV9kcml2
ZXIoa3N6OTQ3N19zcGlfZHJpdmVyKTsNCj4+DQo+PiArTU9EVUxFX0FMSUFTKCJzcGk6a3N6OTQ3
NyIpOw0KPj4gK01PRFVMRV9BTElBUygic3BpOmtzejk4OTciKTsNCj4+ICtNT0RVTEVfQUxJQVMo
InNwaTprc3o5ODkzIik7DQo+PiArTU9EVUxFX0FMSUFTKCJzcGk6a3N6OTU2MyIpOw0KPj4gK01P
RFVMRV9BTElBUygic3BpOmtzejg1NjMiKTsNCj4+ICtNT0RVTEVfQUxJQVMoInNwaTprc3o5NTY3
Iik7DQo+PiAgIE1PRFVMRV9BVVRIT1IoIldvb2p1bmcgSHVoIDxXb29qdW5nLkh1aEBtaWNyb2No
aXAuY29tPiIpOw0KPj4gICBNT0RVTEVfREVTQ1JJUFRJT04oIk1pY3JvY2hpcCBLU1o5NDc3IFNl
cmllcyBTd2l0Y2ggU1BJIGFjY2VzcyBEcml2ZXIiKTsNCj4+ICAgTU9EVUxFX0xJQ0VOU0UoIkdQ
TCIpOw0KPiANCj4gSGkgQ29kcmluDQo+IA0KPiBZb3UgbWlnaHQgd2FudCB0byBjb25zaWRlciBh
ZGRpbmcgYSBGaXhlcyB0YWc/DQoNCkhpIEFuZHJldywNCg0KSSB0aG91Z2h0IGFib3V0IGl0LCBi
dXQgSSB3YXNuJ3Qgc3VyZSB0aGlzIHBhdGNoIGlzIGEgZml4LiAgQW5kIG5vdyB0aGF0IA0KaXQg
aW5jbHVkZXMgYWxpYXNlcyBmb3IgYWxsIHRoZSB2YXJpYW50cywgaXQgbWlnaHQgYmUgdHJpY2t5
IHRvIGFkZCBhIA0KRml4ZXMgdGFnIHNpbmNlIG5vdCBhbGwgdGhlIHZhcmlhbnRzIHdlcmUgYWRk
ZWQgYXQgdGhlIHNhbWUgdGltZS4gQnV0IEkgDQpjYW4gc3BsaXQgaXQgaW50byBtdWx0aXBsZSBw
YXRjaGVzLCBlYWNoIHdpdGggaXRzIEZpeGVzLCBpZiB5b3Ugd2FudCBtZSB0by4NCg0KPiANCj4g
UmV2aWV3ZWQtYnk6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gDQo+ICAgICAgQW5k
cmV3DQo+IA0KDQpUaGFua3MgYW5kIGJlc3QgcmVnYXJkcywNCkNvZHJpbg==
