Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 866CD2D0CFB
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 10:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbgLGJ1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 04:27:13 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:61782 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbgLGJ1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 04:27:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607333231; x=1638869231;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v2B/qt/DiajJ6h/C0MyjOdrgB8eM6BWn2725R7VvsYo=;
  b=b8mckZjV3s/Cy6nB526xb1zzdZE3vqAxbVb+fBgRR8lQY71q+qmHlOK3
   aw036CujytOG4esQ/uaSvnOjd5bPGVHwnP1NSsSkeFrMylVZfMu3P8w7e
   kdu+MXkJlTMv25I47ieSrFDjBG+sGLVrpl6qN8YndHmw4BwfrXB4m5e5R
   0rqinDRyGAr4SWb6n2dgLBzgy/d0hMwwNYTKvVrlYIjDgSs2DBNSek9ng
   910huMcz2HZGQylCxuYEopkH6ifLPS184+HXYg9+ZISGVS4gE55OWelRr
   3eEftNbJ05V0Ugf0Bq0OLSGbG9PdWoDFxsZsGAzWkSAeYdTFeYwBrp8qt
   w==;
IronPort-SDR: jnm9oKkFDdy5ZduAkSB8ndCY74Lys3ZdUAehd8QIxMTyfRi8O4CVxcyAnQCh63CTcGrMiq8TND
 M+Mq+/+8n9cOsTGhjI2Mc+SugW9VdayTvcdDn/4e10o+2sHM1jn98TEMKJrKGzeG+CyLKd7N4o
 HtubM2lnOnkZiiuUy+lOwWutS4aqmml1l2xg1BmfQgbfNv1bi4ULb1blAuAfPOErDuM7q/6CYK
 bNsxb+4MJh6TI6106VUt45C4X9m/ZFhsc5mjOWgBZjukQLswsLp3zPYVqxGwTQMPsiVIa2F7Vd
 jD0=
X-IronPort-AV: E=Sophos;i="5.78,399,1599548400"; 
   d="scan'208";a="36393121"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Dec 2020 02:26:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 02:26:05 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 7 Dec 2020 02:26:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7fUFIEMQMRx3AkTOxKlV8dMlNxbox1NPcQauec4sS0KxiJy8x/FIvRbUSgxl490QdPJuwp3k0kGx/Gmk1D2d4xHTxl/YG79hZmsEHC2NTUlh1CPVPL7py/FFcj9ZURLU46Tpm3xqIrJRndqvDPxlpRxKI/Os5dSii/cRM6f5DZ0iKNuCor1gq5DsF/pBKLeHtXjJZp3LBhAmRTDITfLHikkGW6jBhWwCOglq7L/UTcI0z7RHixEJqt/Zp1H2ee1iTK7QRkrTfpelMvvbbalRn3rFTk34v3Ix5kB05+TQp+aO+KR8KF7VxtoMLFSIMg5HhvwGETum6M7tjr29yxP9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2B/qt/DiajJ6h/C0MyjOdrgB8eM6BWn2725R7VvsYo=;
 b=eiMHescd/kppz33O94sduDppAhq26iwS4odz3OTxQ+lR8tpd9nc2wVlXd/9HkyuAR/Bj3KxAfQHjfITah4T8ZNZJets93nlUphyES6I0I5pB2p+NQZ5guTZ0MugBzuarFEfup4/o6mLuALAWTBuOWiNSwKJbWry06rm8fV6onx4mDX6AZfcLjG+6I1we549lR9PHB/t3jDKj3YAOBp5kD/xIaNuqAJl0icVyJvJ/tHSeneEI3q9H3byItvtMnlI/7LqRm3OCBLTvPgVJ//d1HKvoX6RvPEnjUmN2h8fRj0oqR0LLbtsNsT4uEjtOV6a/1yYweuDlMEwO505iHG8YWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v2B/qt/DiajJ6h/C0MyjOdrgB8eM6BWn2725R7VvsYo=;
 b=PCh+VYWd//5Ab7WXX/aoU4fssu0RRHofp17mhwaAPDcp9Mk1PMjcFww49m0z+jittn0+Y4bx2oogEV9gRwQ7tbYmOZB5dGwEYH8NuZdUvff3fzG7Nnnx0hN0wYn6kqWZevzHmjmI4sEttfn0BhxqQNk3RE/xns1TuJszaSgHdDI=
Received: from DM6PR11MB3420.namprd11.prod.outlook.com (2603:10b6:5:69::31) by
 DM6PR11MB3065.namprd11.prod.outlook.com (2603:10b6:5:72::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3632.19; Mon, 7 Dec 2020 09:26:02 +0000
Received: from DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::eded:bdb6:c6f1:eb3e]) by DM6PR11MB3420.namprd11.prod.outlook.com
 ([fe80::eded:bdb6:c6f1:eb3e%4]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 09:26:02 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <Nicolas.Ferre@microchip.com>, <linux@armlinux.org.uk>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH 3/7] net: macb: unprepare clocks in case of failure
Thread-Topic: [PATCH 3/7] net: macb: unprepare clocks in case of failure
Thread-Index: AQHWzHr5UjbMYFxWx0Kj6TG0yPX+aA==
Date:   Mon, 7 Dec 2020 09:26:01 +0000
Message-ID: <7d9bb653-5ea6-e2d3-d130-83a9cf2974f5@microchip.com>
References: <1607085261-25255-1-git-send-email-claudiu.beznea@microchip.com>
 <1607085261-25255-4-git-send-email-claudiu.beznea@microchip.com>
 <20201205143001.GC2420376@lunn.ch>
In-Reply-To: <20201205143001.GC2420376@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [86.124.22.247]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 11e40e99-e291-4534-69ed-08d89a921d4a
x-ms-traffictypediagnostic: DM6PR11MB3065:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB30651FFBF19BB75BCA1D7FE387CE0@DM6PR11MB3065.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6K2XHaqgLQ9OyGfJvsLnNVAo3lIufvzE83LDtYTxgMPM5toj99woXPq7h9LT9uUVCEnKYptbJH4WQwff2emM/0fMbpNkiM7x3idTptd2eAoyF2Ndua5WWrpI1H7Yar5wlLAQSEtss+h9Gl13sNdEm1n+Ef1wJ5DAZJsIR66UX/DqSPK0gd3EoOJIBxWLr+rwGfqNvNqGg229Wzklt7HBCcGM8Ws4857aUyQA9pJzIRarLo1DmY3QMeLbvuZgjzKlR/InLO870kFjBCTPv0jgmCRqCRrxXs8i3K4XYjRGIPDRiW+UFyX05cuF1+sAVy0KwOogXz888MJTAzJUnL/aSR7RT2s4TJQ3zgfUbSuULJsM+8YzSjr55NqNA49g8ou2ywzECZgxCqK0NsTiM6R42px4ekXIHTVrmy9aGzutcEA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3420.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(136003)(346002)(366004)(39860400002)(54906003)(91956017)(64756008)(76116006)(66446008)(31686004)(66556008)(6916009)(66476007)(5660300002)(66946007)(36756003)(7416002)(2906002)(26005)(478600001)(2616005)(8936002)(4326008)(186003)(6506007)(53546011)(6512007)(316002)(83380400001)(86362001)(31696002)(6486002)(8676002)(71200400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NDhId3BPYno4eUNjZmlMenMvTFRQL0pKd1hyWTBsVFRqMUdYbDBZOU9HZHEw?=
 =?utf-8?B?UjlJTXQwemdjRU9aNFFWbjh1cVFoRC81WHlLWlRENzdOdVZ0ZkdYaEdLYkNB?=
 =?utf-8?B?UGE1MEVJMHJUMTR6cDVUeWRRWGZmRlVZOGFRMHlKelRaTG9oU25sdHZhaWtl?=
 =?utf-8?B?cUdFeE1MRkF6RTU2T0E4NmxqOTVGbmxTait0S1ovdnFaaklnSFZoZFh5b2ow?=
 =?utf-8?B?Q2RJKzgrQlp6SXp1NmFxcmMvMnpGSm1qd3JZVE96YVB4MFhGd2RQUld2TVM3?=
 =?utf-8?B?Y0RES01qeEtYZG9GcHpFeFJOdzl4S3FRZWRaYi85YmFBNlpaMGJvcTZ6OUpY?=
 =?utf-8?B?NU85SnJlREdzL3lybHJhbzJ3dUVWY2RYbFZHRjN2aE1XdGoxVkNsZkdXU2NF?=
 =?utf-8?B?UW5XeDN4ZzZEM2FTaWZXVmx2bnpSZHJOOFFRU0F3cVhhTzNKTmhJZzFYNmhj?=
 =?utf-8?B?eEFBQndySUZIa002WFU2cG14QWhwTjNTSXlSbi9nZGQxbExnNVErdzFVdkEx?=
 =?utf-8?B?VWFYbW1hNlpraWc5V1hXZnBmZUh6VUUreFVPeDFNU1FTRHdmMS93VHRtdXdT?=
 =?utf-8?B?RWxmQWVaWGV6T0xGMTlzWWJ5THJKUDQ5bVBKanFGY2thZDArTFI3eDRYYjdE?=
 =?utf-8?B?bnZNVDVXUUpsdVhLM3pQdGRhWndIQTlvMUFmUElBQnFIWDVPbjhyclVSM2U3?=
 =?utf-8?B?TzZiSXBQVUZCYThnSU1hRlhVYWVSMGtlTURRdEdRaHlFZ2lVMkZ3bEsyUUhG?=
 =?utf-8?B?ek1UYzdyT3N4VTFzVW5idTVISTJPSWt2YWwyQmJPd0JQbHBLT1cxTFJCd0x3?=
 =?utf-8?B?d0lrNmRSeGRkSllSTStQQTFhWTdGNENyMkhiZWJVUmtmbVNJaEFBTk8rUjcr?=
 =?utf-8?B?clpuN2xpM1dLOEtSbTFLZUR4azkvZjM3Q1JjdW5PUDhGdmljK2F2UldOSDZ4?=
 =?utf-8?B?ODBYWWRpSE9pNnZkaTJtM0toTzIvOFBlNG4xQk05THFvZUxNcXpuOGJmTHRG?=
 =?utf-8?B?QWJVdmNwUElDYWxtM0JwMHB3aGNaYjVtcisveVRLVDI2akYwbjFvSG1iZ1cy?=
 =?utf-8?B?eDlDYll0am1kTDJrdEJlUTF1ZUM3b2pzeStzanRzTndmRnFneDZUeGhBZFh3?=
 =?utf-8?B?cHZmVloxd0NKSXlpWkJWR0toQXZmbmZSUi85Z2Q0YzllbkZXU2w0Mlo5WDk4?=
 =?utf-8?B?TG5ZYWlwQVlVUWUzS0dDNnErWFVMZENmRWtTd3gzVmJNT1B3MVJhLzB1OGRS?=
 =?utf-8?B?VVJsSGluL1V2U1dLM094NzFlalZmclRkY2lIRFp3dGtXMnY1MTRhZlhvV3JO?=
 =?utf-8?Q?dZKXGN20sv6FXGukjQnhKuZZLBYeeqgA6Q?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <108073B88C677944B78B44131EE55B56@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3420.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11e40e99-e291-4534-69ed-08d89a921d4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2020 09:26:01.9394
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nycrqniFEujetwnjN8Swv0iWpOQEJfYGJZoSPask4glW9VurmRS+6CPXsG2cgbCgExhmbufaPkV76rHR5K1L+3ZqCZI2/YfvrUQQe9u5YaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3065
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiAwNS4xMi4yMDIwIDE2OjMwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBGcmksIERlYyAwNCwg
MjAyMCBhdCAwMjozNDoxN1BNICswMjAwLCBDbGF1ZGl1IEJlem5lYSB3cm90ZToNCj4+IFVucHJl
cGFyZSBjbG9ja3MgaW4gY2FzZSBvZiBhbnkgZmFpbHVyZSBpbiBmdTU0MF9jMDAwX2Nsa19pbml0
KCkuDQo+IA0KPiBIaSBDbGF1ZGl1DQo+IA0KPiBOaWNlIHBhdGNoc2V0LiBTaW1wbGUgdG8gdW5k
ZXJzdGFuZC4NCj4+DQo+IA0KPj4gK2Vycl9kaXNhYmxlX2Nsb2NrczoNCj4+ICsgICAgIGNsa19k
aXNhYmxlX3VucHJlcGFyZSgqdHhfY2xrKTsNCj4gDQo+PiArICAgICBjbGtfZGlzYWJsZV91bnBy
ZXBhcmUoKmhjbGspOw0KPj4gKyAgICAgY2xrX2Rpc2FibGVfdW5wcmVwYXJlKCpwY2xrKTsNCj4+
ICsgICAgIGNsa19kaXNhYmxlX3VucHJlcGFyZSgqcnhfY2xrKTsNCj4+ICsgICAgIGNsa19kaXNh
YmxlX3VucHJlcGFyZSgqdHN1X2Nsayk7DQo+IA0KPiBUaGlzIGxvb2tzIGNvcnJlY3QsIGJ1dCBp
dCB3b3VsZCBiZSBtb3JlIHN5bW1ldHJpY2FsIHRvIGFkZCBhDQo+IA0KPiBtYWNiX2Nsa191bmlu
aXQoKQ0KPiANCj4gZnVuY3Rpb24gZm9yIHRoZSBmb3VyIG1haW4gY2xvY2tzLiBJJ20gc3VycHJp
c2VkIGl0IGRvZXMgbm90IGFscmVhZHkNCj4gZXhpc3QuDQoNCkkgd2FzIGluIGJhbGFuY2UgYi93
IGFkZGVkIGFuZCBub3QgYWRkZWQgaXQgdGFraW5nIGludG8gYWNjb3VudCB0aGF0IHRoZQ0KZGlz
YWJsZSB1bnByZXBhcmVzIGFyZSBub3QgdGFraW5nIGNhcmUgb2YgYWxsIHRoZSBjbG9ja3MsIGlu
IGFsbCB0aGUNCnBsYWNlcywgaW4gdGhlIHNhbWUgd2F5LiBBbnl3YXksIEkgd2lsbCBhZGQgb25l
IGZ1bmN0aW9uIGZvciB0aGUgbWFpbg0KY2xvY2tzLCBhcyB5b3UgcHJvcG9zZWQsIGluIHRoZSBu
ZXh0IHZlcnNpb24uDQoNClRoYW5rIHlvdSBmb3IgeW91ciByZXZpZXcsDQpDbGF1ZGl1DQoNCj4g
DQo+ICAgICAgICAgQW5kcmV3DQo+IA==
