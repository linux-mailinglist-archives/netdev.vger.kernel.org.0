Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A09E212321E
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfLQQU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:20:26 -0500
Received: from mail-eopbgr770085.outbound.protection.outlook.com ([40.107.77.85]:54665
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728470AbfLQQOx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:14:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxINZ1n0JyuzuZyI1OUfW6Oc4au4RZsJQBptRoi1gSWjAC+r5eZ2BN9TgABQ2jI5TCJu4YFCWp4JnkKuYmmSm5NXovvyFr2mpFFVwiLnMPN/EKx+2YKmfpYkvPcXLjdOfQEy+ePt1Qw3KE0aEjyD3QXAkLYGuqg3KfDon6gd/FsM6zqv8nEFXuk8xm+0iPYDz6IhztMEdGpWdbKsDAuJhdYYNZEwlb10xL7UEqeX/VZ82HWxv4pNWIsx9AMfO5CnTi9cHIYSox1FJviskC+7Amt50xsyqYMSGN9EmKWEeBZMk/zjSnEoRWiC5ruf2dmDzK0Jq/lcYMoosAFD5PQOuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oa7BZBcw7bkHfVUpfqTHHcmVDdCF4p/YDmQHY7qzc4Y=;
 b=eLpTijQpS/pUMoZDO95BXGIgANTuSJ4WJPh2G0waVC4VqZXrLrjpUHJC2Ud0XS5LViYvopO+FUljP3dcmigyxVsv31adygrcTs5NTtELOrbEA/h5tgDIcQHInDKSctY4mqmQdwUhlhmovFFHBRkZYn3X6j1wE4NCRynOTa+j2XvkNW/B7WlcLLodzwc7sM1drmLLzzCdw18YKCbzIQ0cLL5sLaFl9lMAoNaP+XTDzi6Rxdz4pelVsk1FLfy3rc/eYiIK2LPu9oc6oz/sQ4je9nWWz9REBHYqHGfJ4YtYbpcOf9zZixjD901aZHx/p7Zb6YYgYc9IkDv/PA3TX72Z6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oa7BZBcw7bkHfVUpfqTHHcmVDdCF4p/YDmQHY7qzc4Y=;
 b=lbJ9ubof0tJTVPgDnauDH15ztDV3lrzuhyM/QMNH3Ls337dM72mHsSocG5zuDhO5Y+D47hnfKRXECufY25VKR/J0jXbiLFSSjA2drUZaZKaWge7MvTsvfjIlDHSuU94Iut7gvWzrdhvr8lKzXfvj8/S436i2JCX225UFHFAD/IQ=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3678.namprd11.prod.outlook.com (20.178.254.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Tue, 17 Dec 2019 16:14:51 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:51 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 16/55] staging: wfx: uniformize naming rule
Thread-Topic: [PATCH v2 16/55] staging: wfx: uniformize naming rule
Thread-Index: AQHVtPUcWq+DZSowJk6hjAkDfGy0Tw==
Date:   Tue, 17 Dec 2019 16:14:51 +0000
Message-ID: <20191217161318.31402-17-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d134871-f295-4754-1bec-08d7830c3edc
x-ms-traffictypediagnostic: MN2PR11MB3678:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3678D76DF658EEBC8C89DDC293500@MN2PR11MB3678.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:446;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(366004)(39860400002)(136003)(199004)(189003)(6512007)(1076003)(478600001)(86362001)(8936002)(110136005)(316002)(2616005)(26005)(6506007)(5660300002)(36756003)(6486002)(66946007)(66476007)(66556008)(64756008)(66446008)(71200400001)(52116002)(85182001)(81166006)(81156014)(8676002)(54906003)(107886003)(2906002)(4326008)(186003)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3678;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Eg78OMQfPWz/FmdldoSqhGxvdWNaJe8ZVJYAG2dxZjvJ7HjuZoxCc1bO8FN7W1KJq7h7Qx9TRDH5um84rJPZ7ThmjDm5nHgLoJLaytJ6jS2APrOd3ki1RHXUZz8AXyECn7gSmrhB8J3XmQy6tawX7CAiN36xP6Vx0kIY4ke5Dv3pgXKXEUSgb+BVEi2EqeNj3Jkaq+twziATNUYR8jiBKuAQY2O5gCTMozpG/9Y+EHa1xrOv49bARYYHzlB6T8+o1Vg00X7VBFMkdo0YkIrMnkFBo/ftqCjvK8ziKCaFiD99VBNYerj/r3ad6o+rkn6fezB8jnqH5v4farOeKDsPhONa0muxQDUZONfrTQsq9ZWWvN4tQSihpwBBhepcsMgYKrJ3Rp2ks8XUSAtuHkZ6GDUOENo57MiFs1bU1yLBj45Ab9oeB/HXDXnUN9P7ppSg
Content-Type: text/plain; charset="utf-8"
Content-ID: <141BBAA6CE455340950FCF9ABAF158FE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d134871-f295-4754-1bec-08d7830c3edc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:51.5232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LV0Ns2yoZjDI5CdhGweoRWm+sPjm9NrwFrn87ab2ly/XFWOpllHz4ScFgv87ajkanOosfLQCOvDUKsjKsldIig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3678
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
d2Z4IGRyaXZlciwgd2hlbiBhIGZ1bmN0aW9uIGlzIHVzZWQgYXMgYSBzdHJ1Y3QgbWVtYmVyLCBp
dHMgbmFtZSBpcwp0aGUgbmFtZSBvZiB0aGUgbWVtYmVyIHByZWZpeGVkIHdpdGggIndmeF8iLgoK
VGhpcyBwYXRjaCBhcHBseSB0aGlzIHJ1bGUgdG8gd2Z4X3NwaV9yZW1vdmUoKS4KCkFsc28gcmVt
b3ZlIHRoZSB1c2VsZXNzIGNvbW1lbnQgYWJvdmUgdGhlIGZ1bmN0aW9uLgoKU2lnbmVkLW9mZi1i
eTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRy
aXZlcnMvc3RhZ2luZy93ZngvYnVzX3NwaS5jIHwgNSArKy0tLQogMSBmaWxlIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2J1c19zcGkuYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NwaS5jCmluZGV4IDQ0
ZmM0MmJiNDNhMC4uMGEwNTVjNDA0MWFmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2J1c19zcGkuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2J1c19zcGkuYwpAQCAtMjIzLDgg
KzIyMyw3IEBAIHN0YXRpYyBpbnQgd2Z4X3NwaV9wcm9iZShzdHJ1Y3Qgc3BpX2RldmljZSAqZnVu
YykKIAlyZXR1cm4gcmV0OwogfQogCi0vKiBEaXNjb25uZWN0IEZ1bmN0aW9uIHRvIGJlIGNhbGxl
ZCBieSBTUEkgc3RhY2sgd2hlbiBkZXZpY2UgaXMgZGlzY29ubmVjdGVkICovCi1zdGF0aWMgaW50
IHdmeF9zcGlfZGlzY29ubmVjdChzdHJ1Y3Qgc3BpX2RldmljZSAqZnVuYykKK3N0YXRpYyBpbnQg
d2Z4X3NwaV9yZW1vdmUoc3RydWN0IHNwaV9kZXZpY2UgKmZ1bmMpCiB7CiAJc3RydWN0IHdmeF9z
cGlfcHJpdiAqYnVzID0gc3BpX2dldF9kcnZkYXRhKGZ1bmMpOwogCkBAIC0yNjMsNSArMjYyLDUg
QEAgc3RydWN0IHNwaV9kcml2ZXIgd2Z4X3NwaV9kcml2ZXIgPSB7CiAJfSwKIAkuaWRfdGFibGUg
PSB3Znhfc3BpX2lkLAogCS5wcm9iZSA9IHdmeF9zcGlfcHJvYmUsCi0JLnJlbW92ZSA9IHdmeF9z
cGlfZGlzY29ubmVjdCwKKwkucmVtb3ZlID0gd2Z4X3NwaV9yZW1vdmUsCiB9OwotLSAKMi4yNC4w
Cgo=
