Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88DC56FD41
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 11:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728634AbfGVJ5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 05:57:25 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:48850 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727624AbfGVJ5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 05:57:25 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E4CD2C015C;
        Mon, 22 Jul 2019 09:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563789444; bh=+DBafzhXUF2nDVEfszHL5lxmgLmeaxFsgR8vljHH96E=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ChzHFh9ryCfHk+5M/32RdrZp+qwjRXrjOsPgnyXrtix5rCa+VJirwB5duyyaVK29Z
         NrXic925Fyf4AwjY1LSSddGe1BDVnNajiWhN5x+xgI2ICVXfrUnI8nV/sn1oxiL4EA
         lW7BkwcuRnaiePd/CsSMkUGtqipDarMuGqxRNTx94VXSRgcVgMmSs3p76e3C8D3eKV
         k6YxtJZ6cOsawsCkB5uO8gKVuL0pTGqPbizgZlYLGGtgmTJWD6TUj8b+9sGexzWL2+
         mDLoAQw8SnaCUbFpTGIlvyTm9ZwFnucu08xv5L1vIb0vpjouXeDnK0Mw9K2GpM+M9r
         6yRBeMwSf7oSg==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id CB96AA009B;
        Mon, 22 Jul 2019 09:57:23 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 22 Jul 2019 02:57:23 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 22 Jul 2019 02:57:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7werbFcK1xBa9U1+W+9ZDDkU9quuaRhVHbXLNkGzHAv5e7denPWDMzEPUbVwdweHE2sFxDeyYtmqbjpsj8ZikGsNYE06z73gAu5g9JE+dmsG4Qj5GRKXx4SDV95NAb2m618amKCJ0dky7IHZazJ4h1znnNA+mED1oUnuzarOEHqssyfcRLzKKdT/8tLsKwDtv0+EWrSNqb4Dx7h2E52/Ke43xMrgW+9DlODLkrV7j8zCG2kt2M17dPl4kogGyq6l9GmAmlv1XugCLN/+5ppKlNPHHOtu0N/tWcDb0CTDK+Em7MXLvmaz5H1N3Qb02fVpzLYic+jyNamcQWSTUV30w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsdFV7UU7JfcJmjwkQsra8yUI8itg88Ug7Vp9Y0v3ZQ=;
 b=IFsjPQIg35tbKWZBsanNUNFgNWmgt0LjSOS8y1ofM+I8w+JVNya+f2lEzDFOvuLMFy6reqN3N9VuqsieQ1sJCu/Zf/OiyIPq9QBwpxIr3ZD8ZnusdQJzdmu2azTCyvECdQFrXdIs6VpXoYjjkYP2u1Wq7PEZ4kcfEA+fhTpexngjDNXZPn1AYBu8w121KnxqYgU/chdZ15mBRFChLSsbYB0vTRQ8bp1uR42GRk8K5Fl5urnXdYV5xw3E7OkFPrh3ySAQvk0EpEHKZ/8d4tjnqNU8YdE0X9+vv6LdDNJJOzjH6vPXFttYf4qyw9OYBZSF9xwjkysgw8YOS51ldaFSvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wsdFV7UU7JfcJmjwkQsra8yUI8itg88Ug7Vp9Y0v3ZQ=;
 b=GFtn3wFtIUblPiUGH6wq3nvoJtPSKayqx1ZZxXAOyR+4ccPOoT+/whDDY9PSgRn9iPidbuV//jX/7HtW3yVWPli8rtY50Ncq4cos7JoBtITvcvCpOq6P84//ppVL7aG/GUBc69vee9iHf+9b1s76yNeqxEmwXqhZYnkveYi8kn4=
Received: from BN8PR12MB3266.namprd12.prod.outlook.com (20.179.66.159) by
 BN8PR12MB3281.namprd12.prod.outlook.com (20.179.67.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Mon, 22 Jul 2019 09:57:22 +0000
Received: from BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d]) by BN8PR12MB3266.namprd12.prod.outlook.com
 ([fe80::61ef:5598:59e0:fc9d%5]) with mapi id 15.20.2094.013; Mon, 22 Jul 2019
 09:57:22 +0000
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Jon Hunter <jonathanh@nvidia.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
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
Thread-Index: AQHVMYtq2Zx4WVoG/U2kL8GCK0bP/abPQEOAgADTx+CAABvLAIABeX5ggAAOFICAAAG4AIAAAXQAgAAaB/CAACO4AIAAAIsAgAAR0ACABE5q0IAAJe0AgAAA9wCAAANscA==
Date:   Mon, 22 Jul 2019 09:57:21 +0000
Message-ID: <BN8PR12MB326667E86622C3ABD5CDE642D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
 <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
 <6a6bac84-1d29-2740-1636-d3adb26b6bcc@nvidia.com>
 <BN8PR12MB3266960A104A7CDBB4E59192D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <bc9ab3c5-b1b9-26d4-7b73-01474328eafa@nvidia.com>
 <BN8PR12MB3266989D15E017A789E14282D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <4db855e4-1d59-d30b-154c-e7a2aa1c9047@nvidia.com>
 <BN8PR12MB3266FD9CF18691EDEF05A4B8D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <64e37224-6661-ddb0-4394-83a16e1ccb61@nvidia.com>
 <BN8PR12MB3266E1FAC5B7874EFA69DD7BD3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <25512348-5b98-aeb7-a6fb-f90376e66a84@nvidia.com>
 <BN8PR12MB32665C1A106D3DCBF89CEA54D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <49efad87-2f74-5804-af4c-33730f865c41@nvidia.com>
 <BN8PR12MB3266362102CCB6B4DDE4BEA0D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266362102CCB6B4DDE4BEA0D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=joabreu@synopsys.com; 
x-originating-ip: [83.174.63.141]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57dc0178-e373-401c-6d0c-08d70e8afdaf
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(49563074)(7193020);SRVR:BN8PR12MB3281;
x-ms-traffictypediagnostic: BN8PR12MB3281:
x-microsoft-antispam-prvs: <BN8PR12MB3281BA904642480755A553A6D3C40@BN8PR12MB3281.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01068D0A20
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(396003)(136003)(39860400002)(52314003)(199004)(189003)(4326008)(33656002)(99936001)(71200400001)(71190400001)(476003)(186003)(74316002)(66616009)(66476007)(66556008)(66946007)(76116006)(6436002)(5024004)(14444005)(256004)(2201001)(110136005)(64756008)(66446008)(66066001)(316002)(102836004)(25786009)(229853002)(8676002)(2501003)(53546011)(6506007)(478600001)(54906003)(52536014)(486006)(7416002)(26005)(99286004)(5660300002)(305945005)(14454004)(81166006)(7696005)(86362001)(55016002)(2906002)(81156014)(6116002)(3846002)(76176011)(9686003)(2940100002)(8936002)(6246003)(446003)(53936002)(11346002)(7736002)(68736007);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR12MB3281;H:BN8PR12MB3266.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uG8XL+YeNAiOfeXn+SQ083MJ17eYjY1fFs8QnsAjFNKFlvYkAHVVjU8LxC+Rdus+7jddikJfUe1JQFl7I+Aqy3LXWI4Sh8Aila5IvLVdXHJ9gD9x+YSsNjiaYhf3LGhyvO3QixAYM4LpP3mhgJtuFadulxesPaLk1HN5RhOiQTYQz1JbTjOpHnMbD9bztzVkE25SutslT42jy1neHwGdExwnS5uUse8PcgI4EV9Hpdq1OlxDN98SWxUOIfeixkhcUP5sVHt7frFU5fw34vKoXtNz1NSQqL0qsibFy6qnjRDImB0SwXzHvRVax8HHcYLJyYcC3xsSphi7VQiOZ4qZRhjUcFOPMGvIgTJooY0iaw7riJD6o//ZwA4fiZI7LVd67DzeGEsnPDfoHNxDa3PXL5RUnqLFhu1KdHKvJmAd3vE=
Content-Type: multipart/mixed;
        boundary="_002_BN8PR12MB326667E86622C3ABD5CDE642D3C40BN8PR12MB3266namp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 57dc0178-e373-401c-6d0c-08d70e8afdaf
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2019 09:57:21.9573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: joabreu@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3281
X-OriginatorOrg: synopsys.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_BN8PR12MB326667E86622C3ABD5CDE642D3C40BN8PR12MB3266namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

RnJvbTogSm9zZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+DQpEYXRlOiBKdWwvMjIvMjAx
OSwgMTA6NDc6NDQgKFVUQyswMDowMCkNCg0KPiBGcm9tOiBKb24gSHVudGVyIDxqb25hdGhhbmhA
bnZpZGlhLmNvbT4NCj4gRGF0ZTogSnVsLzIyLzIwMTksIDEwOjM3OjE4IChVVEMrMDA6MDApDQo+
IA0KPiA+IA0KPiA+IE9uIDIyLzA3LzIwMTkgMDg6MjMsIEpvc2UgQWJyZXUgd3JvdGU6DQo+ID4g
PiBGcm9tOiBKb24gSHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNvbT4NCj4gPiA+IERhdGU6IEp1
bC8xOS8yMDE5LCAxNDozNTo1MiAoVVRDKzAwOjAwKQ0KPiA+ID4gDQo+ID4gPj4NCj4gPiA+PiBP
biAxOS8wNy8yMDE5IDEzOjMyLCBKb3NlIEFicmV1IHdyb3RlOg0KPiA+ID4+PiBGcm9tOiBKb24g
SHVudGVyIDxqb25hdGhhbmhAbnZpZGlhLmNvbT4NCj4gPiA+Pj4gRGF0ZTogSnVsLzE5LzIwMTks
IDEzOjMwOjEwIChVVEMrMDA6MDApDQo+ID4gPj4+DQo+ID4gPj4+PiBJIGJvb3RlZCB0aGUgYm9h
cmQgd2l0aG91dCB1c2luZyBORlMgYW5kIHRoZW4gc3RhcnRlZCB1c2VkIGRoY2xpZW50IHRvDQo+
ID4gPj4+PiBicmluZyB1cCB0aGUgbmV0d29yayBpbnRlcmZhY2UgYW5kIGl0IGFwcGVhcnMgdG8g
YmUgd29ya2luZyBmaW5lLiBJIGNhbg0KPiA+ID4+Pj4gZXZlbiBtb3VudCB0aGUgTkZTIHNoYXJl
IGZpbmUuIFNvIGl0IGRvZXMgYXBwZWFyIHRvIGJlIHBhcnRpY3VsYXIgdG8NCj4gPiA+Pj4+IHVz
aW5nIE5GUyB0byBtb3VudCB0aGUgcm9vdGZzLg0KPiA+ID4+Pg0KPiA+ID4+PiBEYW1uLiBDYW4g
eW91IHNlbmQgbWUgeW91ciAuY29uZmlnID8NCj4gPiA+Pg0KPiA+ID4+IFllcyBubyBwcm9ibGVt
LiBBdHRhY2hlZC4NCj4gPiA+IA0KPiA+ID4gQ2FuIHlvdSBjb21waWxlIHlvdXIgaW1hZ2Ugd2l0
aG91dCBtb2R1bGVzIChpLmUuIGFsbCBidWlsdC1pbikgYW5kIGxldCANCj4gPiA+IG1lIGtub3cg
aWYgdGhlIGVycm9yIHN0aWxsIGhhcHBlbnMgPw0KPiA+IA0KPiA+IEkgc2ltcGx5IHJlbW92ZWQg
dGhlIC9saWIvbW9kdWxlcyBkaXJlY3RvcnkgZnJvbSB0aGUgTkZTIHNoYXJlIGFuZA0KPiA+IHZl
cmlmaWVkIHRoYXQgSSBzdGlsbCBzZWUgdGhlIHNhbWUgaXNzdWUuIFNvIGl0IGlzIG5vdCBsb2Fk
aW5nIHRoZQ0KPiA+IG1vZHVsZXMgdGhhdCBpcyBhIHByb2JsZW0uDQo+IA0KPiBXZWxsLCBJIG1l
YW50IHRoYXQgbG9hZGluZyBtb2R1bGVzIGNhbiBiZSBhbiBpc3N1ZSBidXQgdGhhdCdzIG5vdCB0
aGUgDQo+IHdheSB0byB2ZXJpZnkgdGhhdC4NCj4gDQo+IFlvdSBuZWVkIHRvIGhhdmUgYWxsIG1v
ZHVsZXMgYnVpbHQtaW4gc28gdGhhdCBpdCBwcm92ZXMgdGhhdCBubyBtb2R1bGUgDQo+IHdpbGwg
dHJ5IHRvIGJlIGxvYWRlZC4NCj4gDQo+IEFueXdheSwgdGhpcyBpcyBwcm9iYWJseSBub3QgdGhl
IGNhdXNlIGFzIHlvdSB3b3VsZG4ndCBldmVuIGJlIGFibGUgdG8gDQo+IGNvbXBpbGUga2VybmVs
IGlmIHlvdSBuZWVkIGEgc3ltYm9sIGZyb20gYSBtb2R1bGUgd2l0aCBzdG1tYWMgYnVpbHQtaW4u
IA0KPiBLY29uZmlnIHdvdWxkIGNvbXBsYWluIGFib3V0IHRoYXQuDQo+IA0KPiBUaGUgb3RoZXIg
Y2F1c2UgY291bGQgYmUgZGF0YSBjb3JydXB0aW9uIGluIHRoZSBSWCBwYXRoLiBBcmUgeW91IGFi
bGUgdG8gDQo+IHNlbmQgbWUgcGFja2V0IGR1bXAgYnkgcnVubmluZyB3aXJlc2hhcmsgZWl0aGVy
IGluIHRoZSB0cmFuc21pdHRlciBzaWRlIA0KPiAoaS5lLiBORlMgc2VydmVyKSwgb3IgdXNpbmcg
c29tZSBraW5kIG9mIHN3aXRjaCA/DQo+IA0KPiAtLS0NCj4gVGhhbmtzLA0KPiBKb3NlIE1pZ3Vl
bCBBYnJldQ0KDQpBbHNvLCBwbGVhc2UgYWRkIGF0dGFjaGVkIHBhdGNoLiBZb3UnbGwgZ2V0IGEg
Y29tcGlsZXIgd2FybmluZywganVzdCANCmRpc3JlZ2FyZCBpdC4NCg0KLS0tDQpUaGFua3MsDQpK
b3NlIE1pZ3VlbCBBYnJldQ0K

--_002_BN8PR12MB326667E86622C3ABD5CDE642D3C40BN8PR12MB3266namp_
Content-Type: application/octet-stream;
	name="0001-net-stmmac-Debug-print.patch"
Content-Description: 0001-net-stmmac-Debug-print.patch
Content-Disposition: attachment;
	filename="0001-net-stmmac-Debug-print.patch"; size=1514;
	creation-date="Mon, 22 Jul 2019 09:54:36 GMT";
	modification-date="Mon, 22 Jul 2019 09:56:27 GMT"
Content-Transfer-Encoding: base64

RnJvbSBiNzhiZTRmMTllNTdiNmE0ZDVmNjdiZGExYzUyYzkwZjZjZDkwMWFiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8Yjc4YmU0ZjE5ZTU3YjZhNGQ1ZjY3YmRhMWM1MmM5
MGY2Y2Q5MDFhYi4xNTYzNzg5Mzg3LmdpdC5qb2FicmV1QHN5bm9wc3lzLmNvbT4KRnJvbTogSm9z
ZSBBYnJldSA8am9hYnJldUBzeW5vcHN5cy5jb20+CkRhdGU6IE1vbiwgMjIgSnVsIDIwMTkgMTE6
NTI6MjggKzAyMDAKU3ViamVjdDogW1BBVENIIG5ldF0gbmV0OiBzdG1tYWM6IERlYnVnIHByaW50
CgpTaWduZWQtb2ZmLWJ5OiBKb3NlIEFicmV1IDxqb2FicmV1QHN5bm9wc3lzLmNvbT4KCi0tLQpD
YzogR2l1c2VwcGUgQ2F2YWxsYXJvIDxwZXBwZS5jYXZhbGxhcm9Ac3QuY29tPgpDYzogQWxleGFu
ZHJlIFRvcmd1ZSA8YWxleGFuZHJlLnRvcmd1ZUBzdC5jb20+CkNjOiBKb3NlIEFicmV1IDxqb2Fi
cmV1QHN5bm9wc3lzLmNvbT4KQ2M6ICJEYXZpZCBTLiBNaWxsZXIiIDxkYXZlbUBkYXZlbWxvZnQu
bmV0PgpDYzogTWF4aW1lIENvcXVlbGluIDxtY29xdWVsaW4uc3RtMzJAZ21haWwuY29tPgpDYzog
bmV0ZGV2QHZnZXIua2VybmVsLm9yZwpDYzogbGludXgtc3RtMzJAc3QtbWQtbWFpbG1hbi5zdG9y
bXJlcGx5LmNvbQpDYzogbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnCkNjOiBs
aW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnCi0tLQogZHJpdmVycy9uZXQvZXRoZXJuZXQvc3Rt
aWNyby9zdG1tYWMvc3RtbWFjX21haW4uYyB8IDQgKysrKwogMSBmaWxlIGNoYW5nZWQsIDQgaW5z
ZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3Rt
bWFjL3N0bW1hY19tYWluLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9z
dG1tYWNfbWFpbi5jCmluZGV4IDBhYzc5ZjNlMmNlZS4uN2E2OTIwMDk4ZGQwIDEwMDY0NAotLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9zdG1pY3JvL3N0bW1hYy9zdG1tYWNfbWFpbi5jCisrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L3N0bWljcm8vc3RtbWFjL3N0bW1hY19tYWluLmMKQEAgLTM0
MzMsNiArMzQzMywxMCBAQCBzdGF0aWMgaW50IHN0bW1hY19yeChzdHJ1Y3Qgc3RtbWFjX3ByaXYg
KnByaXYsIGludCBsaW1pdCwgdTMyIHF1ZXVlKQogCQkJZG1hX3N5bmNfc2luZ2xlX2Zvcl9kZXZp
Y2UocHJpdi0+ZGV2aWNlLCBidWYtPmFkZHIsCiAJCQkJCQkgICBmcmFtZV9sZW4sIERNQV9GUk9N
X0RFVklDRSk7CiAKKwkJCXByX2luZm8oIiVzOiBwYWRkcj0weCVsbHgsIHZhZGRyPTB4JWxseCwg
bGVuPSVkIiwgX19mdW5jX18sCisJCQkJCWJ1Zi0+YWRkciwgcGFnZV9hZGRyZXNzKGJ1Zi0+cGFn
ZSksCisJCQkJCWZyYW1lX2xlbik7CisKIAkJCWlmIChuZXRpZl9tc2dfcGt0ZGF0YShwcml2KSkg
ewogCQkJCW5ldGRldl9kYmcocHJpdi0+ZGV2LCAiZnJhbWUgcmVjZWl2ZWQgKCVkYnl0ZXMpIiwK
IAkJCQkJICAgZnJhbWVfbGVuKTsKLS0gCjIuNy40Cgo=

--_002_BN8PR12MB326667E86622C3ABD5CDE642D3C40BN8PR12MB3266namp_--
