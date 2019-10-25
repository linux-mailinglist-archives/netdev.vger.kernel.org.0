Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8188E4FCF
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 17:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440538AbfJYPGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 11:06:35 -0400
Received: from mail-eopbgr720055.outbound.protection.outlook.com ([40.107.72.55]:43104
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2436893AbfJYPGf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 11:06:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iT/6rP+CfS0LlcRyKbV+3a4mYUzOpZUlyB7D+nmdy4pDbrto9AQAa3e3ot7snwqgJSg6DDXFcKwKcAd1hhmaYXTcwly0Umc0cBpjpLRDMCYbStUxAyS65fiZUQnUcuHzw16yXriIle7NVXAQbKWraUuVO4nYOyd0AdKgUkoPWVhNOJsAi2GhIdq2V++F6GpxEMaODKUdylIOKoX+hGAhBRbuU4RDEzcgh81yxJJNVQfgS/TbXDGz2dtq2Pey90Vxdfl6065uhiKF4XlOpprcbsyQUrlSLqWhF5MOM3UUk/bbK5n27UgtllN/OpcH5NOmU90rf0sNHHbOuCmYMXHokQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlTzp2nm49mb+C+DlK45o+ydRrwDf97826K0GkDbsNk=;
 b=Og7nxL1AxNgyk7UO5CBSBMXy7P4nhxKnnAV1NlAUJeH2Gork8FwlBXbb8seFVXQsBiiunnyZRFYOPbGl/WWIcEcuwSOCK3aaqymQYT7BIJfmpob35vn7SilabU+B9+dtAtrWAoxGUZ8u0krTF7X9yL1tmAQGyniaY5kNOSZCSILEKkkfIqPIUVCbvQDa2BQYVEFTi29mT2C4T1GlkA8bWMuJp4uHb+DsUd2cOQ7pN3ToTCbUsPkYnRZtBjBoxCjFZQjkX0a+Ah4YWvnCNxBWbGPC05JLC43zCzFb+9iLNjuE7vS6J26vl8puqPgeA18LgOPYVSpPEAx8Cvsk8OmDQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DlTzp2nm49mb+C+DlK45o+ydRrwDf97826K0GkDbsNk=;
 b=OZJ96x4JvIWD6/H5Lqlm25PJUceEd9edlO0Cf7443nlPlZLrgeafkR4d/JhnzrmMvlZ3ghltqtOOG4C58drjm06mcU/kg2POTBJleEk3i95l2JPg2YV5ZMwtvRlm70UA6dwg4UGJo+JgKFJqiIy+RHKwnOM+Z1U6NKyk13TD2a4=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3731.namprd11.prod.outlook.com (20.178.220.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Fri, 25 Oct 2019 15:06:26 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2387.023; Fri, 25 Oct 2019
 15:06:26 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     YueHaibing <yuehaibing@huawei.com>,
        Egor Pomozov <epomozov@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] [PATCH net-next] net: aquantia: Fix build error wihtout
 CONFIG_PTP_1588_CLOCK
Thread-Topic: [EXT] [PATCH net-next] net: aquantia: Fix build error wihtout
 CONFIG_PTP_1588_CLOCK
Thread-Index: AQHVi0XB+OhMsSq30UWkt4i3ZpBEGg==
Date:   Fri, 25 Oct 2019 15:06:25 +0000
Message-ID: <cdef0123-89da-b9ff-1f52-6d838846ffc9@aquantia.com>
References: <20191025133726.31796-1-yuehaibing@huawei.com>
In-Reply-To: <20191025133726.31796-1-yuehaibing@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0044.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::32) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d98c9ea1-ac7f-4a04-a23b-08d7595ce7dd
x-ms-traffictypediagnostic: BN8PR11MB3731:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3731E1D0C7B27D3053E8EAA798650@BN8PR11MB3731.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(376002)(136003)(346002)(199004)(189003)(71200400001)(54906003)(99286004)(6636002)(6116002)(2501003)(66066001)(6246003)(3846002)(256004)(7736002)(8936002)(81166006)(81156014)(316002)(8676002)(186003)(26005)(110136005)(31696002)(229853002)(386003)(6506007)(76176011)(102836004)(52116002)(6512007)(6486002)(71190400001)(476003)(66476007)(86362001)(66556008)(4744005)(64756008)(446003)(36756003)(2616005)(66446008)(31686004)(508600001)(25786009)(4326008)(6436002)(14454004)(2906002)(5660300002)(44832011)(11346002)(66946007)(305945005)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3731;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RoYTf5M3Oh4aPXSPrcZqfI5vqoJtqpLbpOyN70IEQIVpJZKSNhva3gO400j7fWYJol1DqPwoos2pBB6qPxoRftWM+l/Cv+R9z+Ns+Fum2UckJ6PQRd9IPw8Lv6Shzx79OqbJEuY0z4X6WQO1fnjWty1tPxf7In+sc1l7rhtp7029cBTFjtQUlhEMJnOwajieedCd/KVXOrX8iDyUA4O8lf6LXvHlS3JhPcaK2B7nwZyTxN/epSiBN5cuj0m+hva7UN4VqjZ0VVMeoMes4YRLOGDblMAoa9f5+51CSbbvXw/cHRbg90vQ8q20nccDv/ihwc403lPYxZbvKefhO2GEyZm0Rmdwifh06x6jGwUu6T5Q5FDUjrx2/+UfOO95nLs/EWk6RSEZvAhbEuJA3sFtVeOifCfyES1yQZBSEf0w4qNQiOY1UG3KYhu6Wj1pqwCC
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE749B4AAE57FF498DA6F3A63793CE55@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d98c9ea1-ac7f-4a04-a23b-08d7595ce7dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 15:06:25.9259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xpk6ruTOCw/naSCWhUif1OSdrHi7UWr/YNng9ImOi96JlupMOrqtb/lJFH5ufVLOvYAsikYXMlaj/ierVdDSmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3731
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IElmIFBUUF8xNTg4X0NMT0NLIGlzIG4sIGJ1aWxkaW5nIGZhaWxzOg0KPiANCj4gZHJpdmVy
cy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfcHRwLmM6IEluIGZ1bmN0aW9uIGFx
X3B0cF9hZGpmaW5lOg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9h
cV9wdHAuYzoyNzk6MTE6DQo+ICBlcnJvcjogaW1wbGljaXQgZGVjbGFyYXRpb24gb2YgZnVuY3Rp
b24gc2NhbGVkX3BwbV90b19wcGIgWy1XZXJyb3I9aW1wbGljaXQtZnVuY3Rpb24tZGVjbGFyYXRp
b25dDQo+ICAgICAgICAgICAgc2NhbGVkX3BwbV90b19wcGIoc2NhbGVkX3BwbSkpOw0KDQpIaSBZ
dWUsDQoNClRoYW5rcyBmb3Igbm90aWNpbmcgdGhpcy4gSXQgc2VlbXMgSSd2ZSBhZGRlZCBzY2Fs
ZWRfcHBtX3RvX3BwYiB1c2FnZSBidXQgZGlkDQpub3QgY2hlY2tlZCBQVFBfMTU4OF9DTE9DSz1u
IGNhc2UgYWZ0ZXIgdGhhdC4NCg0KPiANCj4gSnVzdCBjcCBzY2FsZWRfcHBtX3RvX3BwYigpIGZy
b20gcHRwX2Nsb2NrLmMgdG8gZml4IHRoaXMuDQoNCkknbSBob25lc3RseSBub3Qgc3VyZSBpZiBk
dXBsaWNhdGluZyB0aGUgY29kZSBpcyBhIGdvb2Qgd2F5IGhlcmUuDQpJJ2xsIHRoaW5rIG9uIGhv
dyB0byBleGNsdWRlIGF0X3B0cCBhdCBhbGwgb24gc3VjaCBhIGNvbmZpZy4NCg0KUmVnYXJkcywN
CiAgSWdvcg0K
