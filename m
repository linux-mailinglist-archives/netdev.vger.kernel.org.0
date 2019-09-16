Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31811B37E0
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 12:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbfIPKQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 06:16:34 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:25301 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729112AbfIPKQe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 06:16:34 -0400
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
IronPort-SDR: hlzQydlFOdNWFpZp16vKarKOadfVBh+isseXB0ZasB8u9v7zPuDiU1wYwkbBXraF1zb1a9Olqw
 oOVQlSeLEH+Rs5JHJUGoXtJbip88hxFLBGztB46xRKIL15u+5Q/y6P/UqcNNgULWL+08RwfLA3
 8ztAHHfQYyWuG2xBAmgdVEpBEVBb9oHmnToh9Kre8nwU5aQin9+RG/uuuvaxmD+Klg/ujAqgsW
 0UearMBXunWI/xJwGAtBFr3LE2DmolrafxOSuC84pkwMRIZgXnonXBaUQWpUY6szwo7v8v0sOc
 Gl0=
X-IronPort-AV: E=Sophos;i="5.64,512,1559545200"; 
   d="scan'208";a="50601964"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Sep 2019 03:16:32 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Sep 2019 03:16:32 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Mon, 16 Sep 2019 03:16:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P2ARQ251Rvbdwn7kda+u0eDKIcQC65aK6LIbAyeaQvcnVUMw5gLcaQu+mJIorV9w5Stwe4+hZvTHkop/qSl3A0/9s8u2JY4MTtbVgMRGnUn+8OSYQ7D8oH0mkgOTXYy3h7RlZF5IFheaEpS8OqSKGC4s7fb8dQ2MbMjm3hcDgF1jCqQNbica8il99bf6RH3YF//15xN7Ftk+HlA3gvoLGF+MRcvlXS+KOa98fLkzTfUQAGOUaXqCVmJVGiRyqKvcdfDUwHEVfkoQv2ATUM77L4akH/T3LOuEGPpDFW3t6shkRoidDyR71MJAZkZtc8DEMNZtHayyjbX6dAcdXlObtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HCi9X0wNeVwrNjSBnQxXbaLuYlrBN9ofyLAKBC5hgZ8=;
 b=nSY2C3L9uQzdLcaVsiQbF5dyjUgNrhyBPhV32VXhl+9giLf+0qWwDG8oYh6F8bgxuETJw3dWXZ7ZJ6f6T1K5gcYc5aROP5bojBFtsXLwt2pveTGKjw+XCwuPlcg2VELLkcYgHuXLHS4vWqbUG347Q2pCFhFPAKCHu3CEh5D8f9Vu20A7NnLVTOk7tmqYrBV7mbpmTH6dMk0xyti+eqJWmhjCtWEjQ7p495rquxIrOei9421D/7ZzFNjENSBUV/zU6XJkDaBKXfdl5QF2gMXH/1nOd/urUvvKi3ruhQ7wH0CBHb1NIp/G2ozcO43D1CpveFw9pXj+ufiXTXIGxmHTbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HCi9X0wNeVwrNjSBnQxXbaLuYlrBN9ofyLAKBC5hgZ8=;
 b=PHnZGReNRHkFLgunXjD2nopu9V/hM6R+jAjh2x1HNAEQRWn8sqDTOiGO/1463xVgz7josJv5owfjkHCqcGKO8cUEaHkQqO6cgFTCeT5SNyaMouT7lAu1ubRfZOpFnB+sv6iXzS+D0VRwutc2czmxBZ79DWL++s+eGaDRFn9tk94=
Received: from MWHPR11MB1549.namprd11.prod.outlook.com (10.172.54.17) by
 MWHPR11MB1981.namprd11.prod.outlook.com (10.175.54.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Mon, 16 Sep 2019 10:16:31 +0000
Received: from MWHPR11MB1549.namprd11.prod.outlook.com
 ([fe80::e1f5:745f:84b4:7c7c]) by MWHPR11MB1549.namprd11.prod.outlook.com
 ([fe80::e1f5:745f:84b4:7c7c%12]) with mapi id 15.20.2263.023; Mon, 16 Sep
 2019 10:16:31 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <schwab@suse.de>
CC:     <Nicolas.Ferre@microchip.com>, <netdev@vger.kernel.org>
Subject: Re: macb: inconsistent Rx descriptor chain after OOM
Thread-Topic: macb: inconsistent Rx descriptor chain after OOM
Thread-Index: AQHVbGIsZPEARKNyhE2It7RNJ/kTNqcuElQAgAAECKOAAABzAA==
Date:   Mon, 16 Sep 2019 10:16:31 +0000
Message-ID: <379c59d0-e31b-96c1-8a5e-416b98583da0@microchip.com>
References: <mvm4l1chemx.fsf@suse.de>
 <51458d2e-69a5-2a30-2167-7f47a43d9a2f@microchip.com>
 <mvmmuf4fszw.fsf@suse.de>
In-Reply-To: <mvmmuf4fszw.fsf@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: VI1PR0302CA0006.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::16) To MWHPR11MB1549.namprd11.prod.outlook.com
 (2603:10b6:301:c::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-tagtoolbar-keys: D20190916131622096
x-originating-ip: [86.120.236.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b21fc85b-e9ea-45f3-bdc8-08d73a8ef1b5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600167)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR11MB1981;
x-ms-traffictypediagnostic: MWHPR11MB1981:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1981C0EFE12802DD118D4D2E878C0@MWHPR11MB1981.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0162ACCC24
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(396003)(136003)(376002)(39860400002)(366004)(346002)(189003)(199004)(36756003)(6436002)(86362001)(26005)(6916009)(71200400001)(8676002)(53546011)(386003)(6506007)(558084003)(186003)(4326008)(76176011)(31696002)(256004)(14444005)(486006)(5660300002)(52116002)(446003)(11346002)(71190400001)(14454004)(102836004)(25786009)(2616005)(7736002)(305945005)(476003)(478600001)(66476007)(64756008)(66446008)(6246003)(6116002)(66556008)(66946007)(66066001)(81166006)(81156014)(99286004)(2906002)(8936002)(6486002)(54906003)(53936002)(6512007)(31686004)(229853002)(316002)(3846002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1981;H:MWHPR11MB1549.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +5TnXqZDeMcJ7R9ar1cjshKmGzoljkhZfr8+m/paFYEBN8ZRrOWpDiT2gWdRZtUFWBiLLNUXC9b5C+TEhoFnsBkb4dF911fvflk/hChEFosyOvzCw+Q2yat/5l5/tvjWVFgUX+m3SkaUUm1IvXFUHKAnRe91oBwxoujUONfkKyASs2iCWC/Y0fxwfLUIv5h5x5aAsw+1cNVM/8bHVtOnh2fF3plLDzB/xE2GbsRqmFU5Ay1P4mlr+1zKTPc33EQjXBuoCmFWg6s3Nq3g07enTxRTig7xJsfm6cCrKlYolBsy5GUcaQMhO00wBW3Sx4HUhUSJK3ecIQioCqjAxCBO1gi+8LFKQLZy5i4coiaTA0Eu8LO0IVlEwoLHLYAiocPg4Qvd6X8lPzAwVkaCAGL8/wDk64g22UoE1IJnkQ0KlgY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAC18E295E593346BA81BAD9D7F60A3C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b21fc85b-e9ea-45f3-bdc8-08d73a8ef1b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2019 10:16:31.2790
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dc3L9Tu7Q/o0gR6QHiUs0Pk4UrpQTqu7bUA3Uo0+YCynbXm9ycusC7KRhqMfxF1V/mnU1sQswyV0I8wXlbBuHay2iNGj9Kv53El6f18qe8M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1981
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDE2LjA5LjIwMTkgMTM6MTQsIEFuZHJlYXMgU2Nod2FiIHdyb3RlOg0KPiBFeHRlcm5h
bCBFLU1haWwNCj4gDQo+IA0KPiBPbiBTZXAgMTYgMjAxOSwgPENsYXVkaXUuQmV6bmVhQG1pY3Jv
Y2hpcC5jb20+IHdyb3RlOg0KPiANCj4+IEkgd2lsbCBoYXZlIGEgbG9vayBvbiBpdC4gSXQgd291
bGQgYmUgZ29vZCBpZiB5b3UgY291bGQgZ2l2ZSBtZSBzb21lDQo+PiBkZXRhaWxzIGFib3V0IHRo
ZSBzdGVwcyB0byByZXByb2R1Y2UgaXQuDQo+IA0KPiBZb3UgbmVlZCB0byB0cmlnZ2VyIE9PTS4N
Cg0KT2ssIHRoYW5rIHlvdSENCg0KPiANCj4gQW5kcmVhcy4NCj4gDQo=
