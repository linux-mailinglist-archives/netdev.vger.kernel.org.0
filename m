Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACBCCBB2ED
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 13:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732226AbfIWLks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 07:40:48 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:16235 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbfIWLks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 07:40:48 -0400
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Claudiu.Beznea@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="Claudiu.Beznea@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Claudiu.Beznea@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: zNAHkk0iBkPWPaEZO10EZqbu+e74zyMOvocik9OQT0AFHF33luJDvOtb4+K6T0zT5vlwoEGSy8
 6Lrkpo5hLriC56A2XwdMyn/D9pu4idmwPTiHHiOUUnvLFBh2VDijmc5Xid6NX2qh5MdNe6nDrF
 EVteOwnYHnASSmZR4VDT/7gGTOR3DCamqa4/3HPFhhLO7oBH2Y3W1vyJyP+HjgQGcS/9tZZne0
 KMnhRlYpdHHZdWssMqXDc9ASRtaJXT6wYBGzmV7GumYxSsuqkhTPZ9mkWn1vyvQqeNyND+GxCf
 HPY=
X-IronPort-AV: E=Sophos;i="5.64,539,1559545200"; 
   d="scan'208";a="51488702"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Sep 2019 04:40:47 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 23 Sep 2019 04:40:46 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 23 Sep 2019 04:40:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuMN8+yaOSC4CF6fe4hsEU0UruFc1tRoLqw+ca1rdPDap2SAr/MKntRVPRydzq34Z6OOnKjI3SRtPIitm9L+F7zxJT6X/yUDiz09GX8x+chLWVQXMDWL3n5Fx7Ja3xG3l7wq/tGUmZAjXjilYhtaKrBGj9uvvfpSQuLblOhjjAG04iYZE0YQljXi0t1BRbhCC1U1P2yB9WfjR/TkMOwdZeo48k5Nm5RBx2BN9Dh+opjrTH2Yl3Q/pBsfcNsuUyr60d0ElouOKCq/+Zvs91Emn2A6HfbzSi209jTFVX06SXL6p2yReEzQAWqlZcABSKExsVBJldBmrWIcOSd342GpGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m46AK+IPX4fYP8M5BIupaDIvPALlTYNH7OrUqUg1sGU=;
 b=DQNOS00nLdEP/DIFjuS2W5VFJyEI1o999v9CGbWOHDFom3+jUPyaF3BxUtH+e+LJqBpzF3UEjnkfVaxjdY0z1Ggr/vShHG4iz7qk7isHCbUfzQF+WpY+FxGlqN1BkulMFLUBdq5F4LazohATo6zmWRqZIB7jyi6SNAIsZH9zVky5DGBAR7HQyrdtTYRuTsl0wOmgUthV/wiuORiHaLmiEx1jY6lzPB/nSRAXo2B638t0y69YKluIy/+9G49Y1rzwgNmeKyf2pqQMbg5uB1EK2gyX+7489wSOAvim87RWcVhBVucMr15jZ6g8GGq3Lj/xQrm+sTI/Ktte3lexcrS5Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m46AK+IPX4fYP8M5BIupaDIvPALlTYNH7OrUqUg1sGU=;
 b=pJRuuCxK+QfW5Ha2AsPtGAJaODBzEnurs4J4OQ5alZwbGKcRzQm/Kaa+9L6SehyL9gNluSTy7uPhgzQcVh8f85nhgHINV7h7up8SQN8b++sAjq0D5EbYIBlDvrhxoMkgbG9EF8T4mKt4wAn3Hp6gJgAunTGXINYhHmkKGHUi5oc=
Received: from MWHPR11MB1549.namprd11.prod.outlook.com (10.172.54.17) by
 MWHPR11MB1535.namprd11.prod.outlook.com (10.172.54.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2284.26; Mon, 23 Sep 2019 11:40:45 +0000
Received: from MWHPR11MB1549.namprd11.prod.outlook.com
 ([fe80::1c73:1329:a07:ab9a]) by MWHPR11MB1549.namprd11.prod.outlook.com
 ([fe80::1c73:1329:a07:ab9a%12]) with mapi id 15.20.2284.023; Mon, 23 Sep 2019
 11:40:45 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <shubhrajyoti.datta@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
CC:     <Nicolas.Ferre@microchip.com>, <shubhrajyoti.datta@xilinx.com>
Subject: Re: [PATCHv1] net: macb: Remove dead code
Thread-Topic: [PATCHv1] net: macb: Remove dead code
Thread-Index: AQHVcem6DZNXUVenGkO8J7oX5UQYnac5I5oA
Date:   Mon, 23 Sep 2019 11:40:45 +0000
Message-ID: <57bd88d3-95d8-56c0-67ca-1539e24313d2@microchip.com>
References: <1569227631-32617-1-git-send-email-shubhrajyoti.datta@gmail.com>
In-Reply-To: <1569227631-32617-1-git-send-email-shubhrajyoti.datta@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0501CA0048.eurprd05.prod.outlook.com
 (2603:10a6:800:60::34) To MWHPR11MB1549.namprd11.prod.outlook.com
 (2603:10b6:301:c::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-tagtoolbar-keys: D20190923144036348
x-originating-ip: [86.120.236.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1e9f32e-ebc9-4e42-1c8b-08d7401adefe
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1535;
x-ms-traffictypediagnostic: MWHPR11MB1535:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1535CB666F2C2DB33B7C605487850@MWHPR11MB1535.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 0169092318
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(366004)(376002)(39860400002)(136003)(199004)(189003)(2906002)(71190400001)(71200400001)(99286004)(14454004)(6486002)(6436002)(6512007)(229853002)(3846002)(305945005)(31696002)(5660300002)(7736002)(86362001)(478600001)(66946007)(66066001)(66446008)(66556008)(64756008)(66476007)(2501003)(316002)(52116002)(76176011)(36756003)(6116002)(110136005)(2201001)(102836004)(6246003)(31686004)(54906003)(186003)(81166006)(81156014)(6506007)(256004)(4326008)(486006)(26005)(446003)(476003)(8676002)(53546011)(386003)(8936002)(25786009)(11346002)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1535;H:MWHPR11MB1549.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9oKhluaGOZF+M/MlE0ubDH4FW7oakpZQWBxmeIm2bkm4MRFmmMG5pb20GE4Rmyt+1midk/XWgOz65xgB/iIcbhvYxQqsySbXIPl2JY6bUnIqE88iCZ/+en8a3ImkMKw00x/Me/2x2H56yVOs6yjPZu3zIeFhzfDqmpn8ciQaG157FzHfKXd+0Uq64SDo+Xe+DXVJJ6WWEar555QS2lc4JBK+d4AS6f5N+hTaiLBjospo7713BXtExqXAdbjOe5TCoqUcR7Vx4u3Ahs2aGRfMUUWd/hlUkl3Zgjo5XWRCJeT7Js1h796RVZ3UApNeKVjQ5Xn5h7ZHbYV5hCUyIfUPBwN3CgJZ8ZhrUu675PJZGAiYCp8m9G/HXmQU0GEAa5oNI9b5eCWtAOY6fBJwguaXPSbu3RMiPhcrkcOnpn3x4uQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C76ED88F8A2AEC48B88C6B1FD0577C60@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e9f32e-ebc9-4e42-1c8b-08d7401adefe
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2019 11:40:45.4415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bRJzUFZF1ZCkvEEiUgYOELcnMUKQ0gnGw61Bfmcl+Hfd4oOjz8qbeIRzzwXLqI6jQkJ7hJdh//REha2We01eUM/B+YlZFxqd/XGEdvq2rGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1535
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDIzLjA5LjIwMTkgMTE6MzMsIHNodWJocmFqeW90aS5kYXR0YUBnbWFpbC5jb20gd3Jv
dGU6DQo+IEZyb206IFNodWJocmFqeW90aSBEYXR0YSA8c2h1YmhyYWp5b3RpLmRhdHRhQHhpbGlu
eC5jb20+DQo+IA0KPiBtYWNiXzY0Yl9kZXNjIGlzIGFsd2F5cyBjYWxsZWQgd2hlbiBIV19ETUFf
Q0FQXzY0QiBpcyBkZWZpbmVkLg0KPiBTbyB0aGUgcmV0dXJuIE5VTEwgY2FuIG5ldmVyIGJlIHJl
YWNoZWQuIFJlbW92ZSB0aGUgZGVhZCBjb2RlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2h1Ymhy
YWp5b3RpIERhdHRhIDxzaHViaHJhanlvdGkuZGF0dGFAeGlsaW54LmNvbT4NCg0KUmV2aWV3ZWQt
Ynk6IENsYXVkaXUgQmV6bmVhIDxjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tPg0KDQo+IC0t
LQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8IDUgKystLS0N
Cj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0K
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gaW5kZXggMzViNTli
NS4uOGU4ZDU1NyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9t
YWNiX21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFp
bi5jDQo+IEBAIC0xNjUsOSArMTY1LDggQEAgc3RhdGljIHVuc2lnbmVkIGludCBtYWNiX2Fkal9k
bWFfZGVzY19pZHgoc3RydWN0IG1hY2IgKmJwLCB1bnNpZ25lZCBpbnQgZGVzY19pZHgNCj4gICNp
ZmRlZiBDT05GSUdfQVJDSF9ETUFfQUREUl9UXzY0QklUDQo+ICBzdGF0aWMgc3RydWN0IG1hY2Jf
ZG1hX2Rlc2NfNjQgKm1hY2JfNjRiX2Rlc2Moc3RydWN0IG1hY2IgKmJwLCBzdHJ1Y3QgbWFjYl9k
bWFfZGVzYyAqZGVzYykNCj4gIHsNCj4gLQlpZiAoYnAtPmh3X2RtYV9jYXAgJiBIV19ETUFfQ0FQ
XzY0QikNCj4gLQkJcmV0dXJuIChzdHJ1Y3QgbWFjYl9kbWFfZGVzY182NCAqKSgodm9pZCAqKWRl
c2MgKyBzaXplb2Yoc3RydWN0IG1hY2JfZG1hX2Rlc2MpKTsNCj4gLQlyZXR1cm4gTlVMTDsNCj4g
KwlyZXR1cm4gKHN0cnVjdCBtYWNiX2RtYV9kZXNjXzY0ICopKCh2b2lkICopZGVzYw0KPiArCQkr
IHNpemVvZihzdHJ1Y3QgbWFjYl9kbWFfZGVzYykpOw0KPiAgfQ0KPiAgI2VuZGlmDQo+ICANCj4g
DQo=
