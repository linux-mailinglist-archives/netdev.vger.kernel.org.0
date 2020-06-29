Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E7220DC81
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 22:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgF2UQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:16:02 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:16193 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728153AbgF2UPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:15:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1593461733; x=1624997733;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=8ZS7IBi2vdydHtJiW0ph5emQev3EMVbkK/L/ZkjxV7U=;
  b=HbW8vYVOfXak687dE23pl50InLBtArLCsNKtgY5oYtSfkl0D6HTQz1cL
   eIEjfSAb3we/ct463bGEGgET1nH5C7Q1adgsJJ3BCS6FCh7OxWUV3wHV1
   4WcV3KsqG4AJBEeUjVk7QsVoGQws4i6QqC35NAPGzIf1LRRgaulGJjGcU
   YUtrCPfhPhnKK3s+SX+bnTq6DdE5t1YReFqNobSKGwaIsq4A0L8e+6Bi6
   OwGLXtEQysM2cyUxIa4m75DmA2i7sSW8nzadKcRVredto8VBKLjGBkSXz
   Ts/l/qc7SEjgDRidWlDzGY/1z4QvaHwfA4DIGLYRQm25SsToQEwUvKpJ7
   w==;
IronPort-SDR: OV3Fe8WDZ8UATpX0Ft0nq4b4Lc/iwyKlSw6cFqpWPt4tZr0imPEc+6R/S4YzN1G/TR8SjtsynY
 H0YZ/XHhZN+0mQF1sezo0pc5I3uI4D7QIfeSm0uWY0ff3Akt2ra2w3w37F0MiCQ0sH6hRIVRqR
 a8PPZZtE0WOubNVc9KECAih5/5m4ADzDF/AoX+/ykiFaPAfhlu8nAVbp5mXY3Gld6XJcBBFqFD
 /39IntrzLERpWK6asZ7UAlHed6MXr+sT1ffbMK8uwJWCsgM9OHbu4cAAkvU9wdB2QRRouTIpTl
 lOs=
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="81972655"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jun 2020 13:15:33 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 29 Jun 2020 13:15:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Mon, 29 Jun 2020 13:15:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRgdfqMmJFCZl73cAaSkyQ2gX794f7KhnB4zZzwr5K0bTULGWUXPtnIcbzyDBXH94O5R9FKK7pS+l1ZtOStsDBTJ2ZBYsC0Iq7Sirljx4Ry6UngRSTreloqXYxGui0tfgRqVpIlA0r9uL/A6uPbU7jqyDNY778An448KaELctaJuT0ooBcBbS6yepFIJSornesvoWe3iI0jTWUqqgOEYWshnaDHYU0IgPmFKaf/TqhReGQm+Mgxuc/3YILw/6/BGm8pbBLD8NG5HXU+hV5Uj51MODUUS7mxbP9IY+9cyIKSWrIS75mABIbpMQYaeyV1S6jQntLqh2JDxb2tCEJSnBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ZS7IBi2vdydHtJiW0ph5emQev3EMVbkK/L/ZkjxV7U=;
 b=BdIXBYm/9N2YyXqXqdLBzorUaALO7PoODUSG4Zlw80FkVzHxEh+uIgLmo8vOchfsrk0lrAqUXe1iZJFw8dwT/6RVp2EL3aHuav4cZWyR/ULaxDRrtyesn87/9tYBe3TF1XNqw/cGi/leB4vMCQU5UoQa7Q8q0mc+rNByWz0bEPK7FEaZdZmMq4JIjJAEBjTIHkNnlGL42TnsmEibJmUN0zAm/3U5jLBtWNtgdxAMCzCRxeIChJm0NYv98VAk9/b21E5a9W0p4L8S5Y2Xo2BDhB0ox6TR7HZ9+yg+8veQUvyosW9B+L2q5D1gKYbMBPvGT9RnwaIp/zIeWwRzNaP1Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ZS7IBi2vdydHtJiW0ph5emQev3EMVbkK/L/ZkjxV7U=;
 b=b+SCmnwJciFoABrcBgmQpY4Q2pdxNzHBdk9LQQv7u8cWulVnJ9IBTQw8TlyNkRTFOtAg3MhWCNOFAgLvMxmH0p7iap5DEpcByVDrUeN1D+9uihUUPbwS3VxBQgj+wWn67wD0Sx2q5U0aFZP4I/DDeEYIo7UJKOXXyfJ33221/h0=
Received: from BY5PR11MB3927.namprd11.prod.outlook.com (2603:10b6:a03:186::21)
 by BY5PR11MB4466.namprd11.prod.outlook.com (2603:10b6:a03:1c8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.24; Mon, 29 Jun
 2020 20:15:29 +0000
Received: from BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311]) by BY5PR11MB3927.namprd11.prod.outlook.com
 ([fe80::5993:d0ac:9849:d311%7]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 20:15:29 +0000
From:   <Andre.Edich@microchip.com>
To:     <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <steve.glendinning@shawell.net>
CC:     <Parthiban.Veerasooran@microchip.com>
Subject: [PATCH net-next 2/8] smsc95xx: avoid memory leak in smsc95xx_bind
Thread-Topic: [PATCH net-next 2/8] smsc95xx: avoid memory leak in
 smsc95xx_bind
Thread-Index: AQHWTlIInNRV7x1aBEiEfqQqaWbGvg==
Date:   Mon, 29 Jun 2020 20:15:29 +0000
Message-ID: <8ecd274f439e642d1510780a4a5722fc72be64b4.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microchip.com;
x-originating-ip: [93.202.178.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cfb27998-ba5f-4a1f-4eaf-08d81c692b5d
x-ms-traffictypediagnostic: BY5PR11MB4466:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB44660A0738D244327B76924BEC6E0@BY5PR11MB4466.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MdGImxrYTJxnZSZ+wzdLvQjj6is82fGyAgw4JqLv3E6hk2ButsmkM4uC3oEhGvBrfEnf1A0Nj4iqf3X0SvmWPVo1p5GoMZeS9q3AAjh0G7dz23Iud6SRe91yShR/vpdmcYLlDEikRpbvnS7GF/nuD8y/T8tz7xoPi+NQ/8OhfRAWQ61aL5ZMOkv8d9TLMO0kmlLArGN2pjs5SI/kqMAHB4sJczQrCW01JGnfgfr+jqXzH+pFreoIPqBYuJf2o+HSe5nrlOiLhkTl9TbIfgSfQZjmwHriaWjvnc++aj+CULgOXQKE/bQ/ZieazdoVJ8mE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB3927.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(366004)(136003)(396003)(39860400002)(376002)(2616005)(71200400001)(66476007)(66556008)(64756008)(83380400001)(66446008)(91956017)(66946007)(2906002)(4326008)(6512007)(86362001)(107886003)(6486002)(186003)(26005)(8676002)(5660300002)(36756003)(76116006)(4744005)(478600001)(316002)(6506007)(8936002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 8AuK0+4WEdlBBnntruhgrQft9emxJk9AUwsHlDYkKvTkXLUIaDbpp9mk5B4k0HJqr78rdU7KZYmobYCV9nVoj2t/slm8yqmvxyfCVuAsLBOWcSXyJ6BlG88BY8GcOF9hGntPO6XUYKODgpyXeUSNP4sKfrCwFV0fHqGokWKgGgJNQgZpEytZoRaKG80W+gArW7bfN+kRFibGeyX6TeSfTPZI/H5CbwosXnX5Jzw1etJAyCoA3ZuHyOpYXkZ7I6I58T8IQq0EeS2u0QiodzwEWJ/lnf1RBldR49UyE+E3kEKeahmN5fd7M82kHkIPzblew3H2jwkiOfELbSCFQRxcPhbwnuu4AO9S6fT2FWe/EXgoaG9+P7EcQn7A/QClQrMoDVwhLkU5mooIvGqq/+P1O/asDwpZ4kWH7WldR/pW0wh/GPLR2X24KRq5sqpNz2fQ6vrPk6+W7JKpuIvdg4+hwnuFAwJY0kzodkSHywlNKYuti0MTeN6uxNziispGWqdU
Content-Type: text/plain; charset="utf-8"
Content-ID: <831963690777924BAD7F4DDBE9983FFD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB3927.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfb27998-ba5f-4a1f-4eaf-08d81c692b5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 20:15:29.5315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZWZBPBvVFATyNbyBFkjNN7Z8arT0KczFDzykHwrf86aKNMmfSH/lt1OgM8SjwF8/mG+WnxiYGEsANjaLKTH49wRpig2lWDS5xig9+ZGrihg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4466
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SW4gYSBjYXNlIHdoZXJlIHRoZSBJRF9SRVYgcmVnaXN0ZXIgcmVhZCBpcyBmYWlsZWQsIHRoZSBt
ZW1vcnkgZm9yIGENCnByaXZhdGUgZGF0YSBzdHJ1Y3R1cmUgaGFzIHRvIGJlIGZyZWVkIGJlZm9y
ZSByZXR1cm5pbmcgZXJyb3IgZnJvbSB0aGUNCmZ1bmN0aW9uIHNtc2M5NXh4X3VuYmluZC4NCg0K
U2lnbmVkLW9mZi1ieTogQW5kcmUgRWRpY2ggPGFuZHJlLmVkaWNoQG1pY3JvY2hpcC5jb20+DQpT
aWduZWQtb2ZmLWJ5OiBQYXJ0aGliYW4gVmVlcmFzb29yYW4gPA0KUGFydGhpYmFuLlZlZXJhc29v
cmFuQG1pY3JvY2hpcC5jb20+DQotLS0NCiBkcml2ZXJzL25ldC91c2Ivc21zYzk1eHguYyB8IDMg
KystDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KDQpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvdXNiL3Ntc2M5NXh4LmMgYi9kcml2ZXJzL25ldC91c2Iv
c21zYzk1eHguYw0KaW5kZXggZWI0MDRiYjc0ZTE4Li5iYjRjY2JkYTAzMWEgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL25ldC91c2Ivc21zYzk1eHguYw0KKysrIGIvZHJpdmVycy9uZXQvdXNiL3Ntc2M5
NXh4LmMNCkBAIC0xMjkzLDcgKzEyOTMsOCBAQCBzdGF0aWMgaW50IHNtc2M5NXh4X2JpbmQoc3Ry
dWN0IHVzYm5ldCAqZGV2LA0Kc3RydWN0IHVzYl9pbnRlcmZhY2UgKmludGYpDQogCS8qIGRldGVj
dCBkZXZpY2UgcmV2aXNpb24gYXMgZGlmZmVyZW50IGZlYXR1cmVzIG1heSBiZQ0KYXZhaWxhYmxl
ICovDQogCXJldCA9IHNtc2M5NXh4X3JlYWRfcmVnKGRldiwgSURfUkVWLCAmdmFsKTsNCiAJaWYg
KHJldCA8IDApDQotCQlyZXR1cm4gcmV0Ow0KKwkJZ290byBmcmVlX3BkYXRhOw0KKw0KIAl2YWwg
Pj49IDE2Ow0KIAlwZGF0YS0+Y2hpcF9pZCA9IHZhbDsNCiAJcGRhdGEtPm1kaXhfY3RybCA9IGdl
dF9tZGl4X3N0YXR1cyhkZXYtPm5ldCk7DQo=
