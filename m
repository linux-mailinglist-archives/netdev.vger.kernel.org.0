Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93C54713AF
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 10:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733079AbfGWIPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 04:15:13 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:34542 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726405AbfGWIPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 04:15:12 -0400
Received: from mailhost.synopsys.com (dc8-mailhost1.synopsys.com [10.13.135.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BBBE0C0BBC;
        Tue, 23 Jul 2019 08:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563869711; bh=RDHnLuXK1uZ9ij6RJMMQzzssqrjmVIDUreklGqjmkak=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=H7gp1jYxeMNAuolDDUDe/cAqXRl083HLI/uO9QkWZ1YBetc1S0OWlg7JENXlq1B3k
         hUliqgfoSQPiUfusnfw9LVjJZc6dQfhEbiHAWjDQ9o4X23NHm2196GxD9s8zzIvehB
         rpgoEmHkxz7KXhsCfFxnSyRFavWaS261MDaUsg2V1qFI30jCTau0Wx3O78nkxbonup
         GUb1v4jIl0k/0Ovh27E2MZrRRMBFau+P2Tt0vod54jmhsxIkvuEJCvy06po4makvtI
         hIBbz9azvJ+pSk2l62ukMNXE3bRUD0FXOK2QdYzKHu5COnDfP7ffn9uIO5p01ybf4s
         TLkpcRBMNQpBQ==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C4A2BA007B;
        Tue, 23 Jul 2019 08:15:08 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 23 Jul 2019 01:14:59 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Tue, 23 Jul 2019 01:14:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BlqoTYY6k6REzOmvvt5qUJpFN/HEGYnF5REoCXQcU+dwseHi0xrxUxN64T6qkN5HW/TGlt+1E4KljNj0ND5DPFgjii6C3ZZ9Dn0inzTf7XtlbYPOouqEy0BSU+IAI6+FjGe/ZPTkN/Cnm/OlvuJURjKYNjXMQw+PzLTFC9G6JFqpuNMgj4BvkjJQTc6y6s2M4VFPBqvPrq58VH9addYs+poo+CQTzxrO9BsAob6b+R6H/7Ba4ufvq1JzDNBNpZXwuB1ICV+JP3RjlinZY54DhigS6CDqYeujBVoP8lZoWj51VvhUjQLR+OPJJEqS+S+fpL+sqNtuPuhSXgZQRmf/wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDHnLuXK1uZ9ij6RJMMQzzssqrjmVIDUreklGqjmkak=;
 b=h16cKi2RAR2DIsfuOPdEJxMvSz8ThaJ4vn/HdmkX0/lTBsmWaedcd9VmRV5p060ZMDkQoX6c/N6eXdzxsIbY46DB+foqR9wahKQrH/2yreeXPHuUfxecWhIRWyAeVbmdDJAqwTc9mWvxlmnEKMyXVmpK8r7ZBpu0JpTXNduR1GvQmwH5YHkmoCwr20sEjbqquV/WuM57ti6z5ke4HuAy8b3nL9eG4ptS0N+U5IgYrNTWOT73wsYVpqr9y3ouVnKqa9Qbj1M6ISsHW+HGBsKv6R/sRXAKbwmPpzcFhKp+SMZd1te4J8T9Qi3fGnYsIQd1drtEtD0NdFVrm0KlHlqfgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RDHnLuXK1uZ9ij6RJMMQzzssqrjmVIDUreklGqjmkak=;
 b=ZsA4OxfPW5kdvzDm/VDlhRa2Z4DfPJAqwFqMV5c0Fhz2GsMqQk0F3CdWo0hiiChDCbudIjt77k7FGfA42OgnXFzRekQILAWXykjdd3qK7LGowm8O3DlAmMEK7mz1Flm++KbzsK+z59xZreecFHQuBuuESEXlJGlBMs5RGWoPzqM=
Received: from BYAPR12MB3269.namprd12.prod.outlook.com (20.179.93.146) by
 BYAPR12MB3014.namprd12.prod.outlook.com (20.178.53.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 23 Jul 2019 08:14:52 +0000
Received: from BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c]) by BYAPR12MB3269.namprd12.prod.outlook.com
 ([fe80::f5b8:ac6e:ea68:cb1c%4]) with mapi id 15.20.2094.013; Tue, 23 Jul 2019
 08:14:52 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Lars Persson <lists@bofh.nu>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Topic: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CABnZ9AIAADuYAgAAFQOCAAAnIAIAABLTAgAFMy7A=
Date:   Tue, 23 Jul 2019 08:14:52 +0000
Message-ID: <BYAPR12MB3269A725AFDDA21E92946558D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
 <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20190722101830.GA24948@apalos>
 <CADnJP=thexf2sWcVVOLWw14rpteEj0RrfDdY8ER90MpbNN4-oA@mail.gmail.com>
 <BN8PR12MB326661846D53AAEE315A7434D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <11557fe0-0cba-cb49-0fb6-ad24792d4a53@nvidia.com>
 <BN8PR12MB3266664ECA192E02C06061EED3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266664ECA192E02C06061EED3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9e27c6c-9962-4a2c-93b5-08d70f45d691
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR12MB3014;
x-ms-traffictypediagnostic: BYAPR12MB3014:
x-microsoft-antispam-prvs: <BYAPR12MB30147B7D4E97832A7A4DB5BDD3C70@BYAPR12MB3014.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0107098B6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(396003)(366004)(39860400002)(136003)(199004)(189003)(76176011)(8676002)(4326008)(110136005)(71190400001)(71200400001)(7736002)(8936002)(476003)(81166006)(53546011)(316002)(81156014)(7416002)(305945005)(33656002)(99286004)(486006)(11346002)(446003)(2906002)(7696005)(74316002)(102836004)(54906003)(186003)(26005)(6116002)(6506007)(68736007)(5024004)(3846002)(256004)(14444005)(14454004)(55016002)(478600001)(6436002)(6246003)(86362001)(5660300002)(66476007)(66946007)(64756008)(66446008)(229853002)(25786009)(66556008)(52536014)(9686003)(76116006)(53936002)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR12MB3014;H:BYAPR12MB3269.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ym365IrBkU9nTZ2ea/lZmJNwRX94TnWjJMXe0KWgMvwP6kdMuzxscxaMv02w20yDk7DfholtOT4KNHlr8pIVM5DnUsTqMwlj5LX4n5HwU3tRvj/rl5PAXzW8rPyr0bWdpCX9JUXgrwnux+NRVfZD3QQYFB0v0WeHNdGOsdnq8NQL4PWlyziV/ZgVUogmH0c9i8VAN2qhI07xCNRsnPByAXcUMOARW30xfwbckiTxJ+aGjajqHgMRwPL1Hyvd+At7XFo6tEdDzOzLmpYrh7uiOhtyZ0Bs3W86CUHwnuLbHGY3zFbWNvc+GSgYLMeZ2D/mTqeDYoh++28hkxCwhEU/lZeAliKjXRG8xoHUXSIFf50vRLL7F3rOoaUXVL6GnYeO+uvOcPCtZb7ozMbLoytNUJnly4Td/7wGlg5bEVpZzdE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f9e27c6c-9962-4a2c-93b5-08d70f45d691
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2019 08:14:52.1040
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3014
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSm9zZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+DQpEYXRlOiBKdWwvMjIvMjAx
OSwgMTU6MDQ6NDkgKFVUQyswMDowMCkNCg0KPiBGcm9tOiBKb24gSHVudGVyIDxqb25hdGhhbmhA
bnZpZGlhLmNvbT4NCj4gRGF0ZTogSnVsLzIyLzIwMTksIDEzOjA1OjM4IChVVEMrMDA6MDApDQo+
IA0KPiA+IA0KPiA+IE9uIDIyLzA3LzIwMTkgMTI6MzksIEpvc2UgQWJyZXUgd3JvdGU6DQo+ID4g
PiBGcm9tOiBMYXJzIFBlcnNzb24gPGxpc3RzQGJvZmgubnU+DQo+ID4gPiBEYXRlOiBKdWwvMjIv
MjAxOSwgMTI6MTE6NTAgKFVUQyswMDowMCkNCj4gPiA+IA0KPiA+ID4+IE9uIE1vbiwgSnVsIDIy
LCAyMDE5IGF0IDEyOjE4IFBNIElsaWFzIEFwYWxvZGltYXMNCj4gPiA+PiA8aWxpYXMuYXBhbG9k
aW1hc0BsaW5hcm8ub3JnPiB3cm90ZToNCj4gPiA+Pj4NCj4gPiA+Pj4gT24gVGh1LCBKdWwgMTgs
IDIwMTkgYXQgMDc6NDg6MDRBTSArMDAwMCwgSm9zZSBBYnJldSB3cm90ZToNCj4gPiA+Pj4+IEZy
b206IEpvbiBIdW50ZXIgPGpvbmF0aGFuaEBudmlkaWEuY29tPg0KPiA+ID4+Pj4gRGF0ZTogSnVs
LzE3LzIwMTksIDE5OjU4OjUzIChVVEMrMDA6MDApDQo+ID4gPj4+Pg0KPiA+ID4+Pj4+IExldCBt
ZSBrbm93IGlmIHlvdSBoYXZlIGFueSB0aG91Z2h0cy4NCj4gPiA+Pj4+DQo+ID4gPj4+PiBDYW4g
eW91IHRyeSBhdHRhY2hlZCBwYXRjaCA/DQo+ID4gPj4+Pg0KPiA+ID4+Pg0KPiA+ID4+PiBUaGUg
bG9nIHNheXMgIHNvbWVvbmUgY2FsbHMgcGFuaWMoKSByaWdodD8NCj4gPiA+Pj4gQ2FuIHdlIHRy
eWUgYW5kIGZpZ3VyZSB3ZXJlIHRoYXQgaGFwcGVucyBkdXJpbmcgdGhlIHN0bW1hYyBpbml0IHBo
YXNlPw0KPiA+ID4+Pg0KPiA+ID4+DQo+ID4gPj4gVGhlIHJlYXNvbiBmb3IgdGhlIHBhbmljIGlz
IGhpZGRlbiBpbiB0aGlzIG9uZSBsaW5lIG9mIHRoZSBrZXJuZWwgbG9nczoNCj4gPiA+PiBLZXJu
ZWwgcGFuaWMgLSBub3Qgc3luY2luZzogQXR0ZW1wdGVkIHRvIGtpbGwgaW5pdCEgZXhpdGNvZGU9
MHgwMDAwMDAwYg0KPiA+ID4+DQo+ID4gPj4gVGhlIGluaXQgcHJvY2VzcyBpcyBraWxsZWQgYnkg
U0lHU0VHViAoc2lnbmFsIDExID0gMHhiKS4NCj4gPiA+Pg0KPiA+ID4+IEkgd291bGQgc3VnZ2Vz
dCB5b3UgbG9vayBmb3IgZGF0YSBjb3JydXB0aW9uIGJ1Z3MgaW4gdGhlIFJYIHBhdGguIElmDQo+
ID4gPj4gdGhlIGNvZGUgaXMgZmV0Y2hlZCBmcm9tIHRoZSBORlMgbW91bnQgdGhlbiBhIGNvcnJ1
cHQgUlggYnVmZmVyIGNhbg0KPiA+ID4+IHRyaWdnZXIgYSBjcmFzaCBpbiB1c2Vyc3BhY2UuDQo+
ID4gPj4NCj4gPiA+PiAvTGFycw0KPiA+ID4gDQo+ID4gPiANCj4gPiA+IEpvbiwgSSdtIG5vdCBm
YW1pbGlhciB3aXRoIEFSTS4gQXJlIHRoZSBidWZmZXIgYWRkcmVzc2VzIGJlaW5nIGFsbG9jYXRl
ZCANCj4gPiA+IGluIGEgY29oZXJlbnQgcmVnaW9uID8gQ2FuIHlvdSB0cnkgYXR0YWNoZWQgcGF0
Y2ggd2hpY2ggYWRkcyBmdWxsIG1lbW9yeSANCj4gPiA+IGJhcnJpZXIgYmVmb3JlIHRoZSBzeW5j
ID8NCj4gPiANCj4gPiBUQkggSSBhbSBub3Qgc3VyZSBhYm91dCB0aGUgYnVmZmVyIGFkZHJlc3Nl
cyBlaXRoZXIuIFRoZSBhdHRhY2hlZCBwYXRjaA0KPiA+IGRpZCBub3QgaGVscC4gU2FtZSBwcm9i
bGVtIHBlcnNpc3RzLg0KPiANCj4gT0suIEknbSBqdXN0IGd1ZXNzaW5nIG5vdyBhdCB0aGlzIHN0
YWdlIGJ1dCBjYW4geW91IGRpc2FibGUgU01QID8NCj4gDQo+IFdlIGhhdmUgdG8gbmFycm93IGRv
d24gaWYgdGhpcyBpcyBjb2hlcmVuY3kgaXNzdWUgYnV0IHlvdSBzYWlkIHRoYXQgDQo+IGJvb3Rp
bmcgd2l0aG91dCBORlMgYW5kIHRoZW4gbW91bnRpbmcgbWFudWFsbHkgdGhlIHNoYXJlIHdvcmtz
IC4uLiBTbywgDQo+IGNhbiB5b3Ugc2hhcmUgbG9ncyB3aXRoIHNhbWUgZGVidWcgcHJpbnRzIGlu
IHRoaXMgY29uZGl0aW9uIGluIG9yZGVyIHRvIA0KPiBjb21wYXJlID8NCg0KSm9uLCBJIGhhdmUg
b25lIEFSTSBiYXNlZCBib2FyZCBhbmQgSSBjYW4ndCBmYWNlIHlvdXIgaXNzdWUgYnV0IEkgDQpu
b3RpY2VkIHRoYXQgbXkgYnVmZmVyIGFkZHJlc3NlcyBhcmUgYmVpbmcgbWFwcGVkIHVzaW5nIFNX
SU9UTEIuIENhbiB5b3UgDQpkaXNhYmxlIElPTU1VIHN1cHBvcnQgb24geW91ciBzZXR1cCBhbmQg
bGV0IG1lIGtub3cgaWYgdGhlIHByb2JsZW0gDQpwZXJzaXN0cyA/DQoNCi0tLQ0KVGhhbmtzLA0K
Sm9zZSBNaWd1ZWwgQWJyZXUNCg==
