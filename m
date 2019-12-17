Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39DCA1231A9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbfLQQQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:16:11 -0500
Received: from mail-dm6nam12on2072.outbound.protection.outlook.com ([40.107.243.72]:33729
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729143AbfLQQQH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:16:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i7vRipy14vfywrxmPySUuyYONoDMSf0v+iLQpZadMAoYoljN85Tbam7LomX+ydwl1M+DUc1hULP0KMRToSmypHu9VMf3mR+tTQ+uQQQiI3/Qgve8QI7SE+W4anbYpvvF5MX+PLsIeHPPrj0KqfnXB34JIxYJ0lUQKeVy4eS0dN1ccw07a/M00+zTNa5whBzEwGwUplQ6mdS6/OKX7+OYOtzlFORxWoWmvQed3T0C2gjHFJK4TNyF43jLnLWnUWqOvaNGfhM9A5y17G+jTQ9NzdkzsC8cbAdtqn4WjelHiLG3IbcSk7oxOwK7Xc/960FVrugJY6P6N1dU1kHBDVQHOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDlT1we7iUloIGeD2+QPkjZvQgP8SkCL4bnHISJpnvQ=;
 b=XrC0B31FDAmdpcr+j+kxrIyc8D3HUl8jZ8kra9VF1xHyUvlBMoVTxRsOd9/lC+7Rp1W2hpu45O4fDYsSYrh9K1grhIFX8Kg55t2H49vNrbxxRzeqnRnmOLo10bMTVon3mg/fuv3lRPVUF9GRtu0ly0cYaiFgfSrKASwP0ZhL2vq7XCfKxd/sBO+OOMGT5SMQmBuf5iy4PsMYVnEnis79N7jYMpjHDKKFp5BrAkwrBgt1/DK6XF9E39sAzzIECSOHgkvKaLp9jPCRUc4+3JfF1oSCfjRI+Mg+S2BOnnMKpGXabMaiFt+Ta8kEpLMiEOIXYdoyg8hlW5LJReH4zrOkzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kDlT1we7iUloIGeD2+QPkjZvQgP8SkCL4bnHISJpnvQ=;
 b=gcVj3wbANwXkewBloBMUF9EuSw1EFYLbHxlAXgdoSrwCSKE9fdvJ2nyhVgHPWNq0dBrfl7jAVZTkbvDAih/gFCrZKCCUaU12GMKmLFXa8GFgETt7LBUWP0SBvE/SHuzgo0yRstGrYHNywD60uHXajxoFvdGzMfjliQumgSwmHQE=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4477.namprd11.prod.outlook.com (52.135.36.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.17; Tue, 17 Dec 2019 16:15:56 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:56 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 48/55] staging: wfx: introduce update_probe_tmpl()
Thread-Topic: [PATCH v2 48/55] staging: wfx: introduce update_probe_tmpl()
Thread-Index: AQHVtPU1dd3K0gcNdECLeABwaV69EQ==
Date:   Tue, 17 Dec 2019 16:15:33 +0000
Message-ID: <20191217161318.31402-49-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 2fea9b41-b5f0-4122-8369-08d7830c57de
x-ms-traffictypediagnostic: MN2PR11MB4477:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB44778251143E83B67ACF57D493500@MN2PR11MB4477.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(396003)(136003)(366004)(39860400002)(199004)(189003)(1076003)(66574012)(186003)(107886003)(8676002)(6506007)(86362001)(478600001)(85182001)(5660300002)(81156014)(26005)(15650500001)(4326008)(6486002)(8936002)(316002)(110136005)(54906003)(64756008)(66446008)(66946007)(2616005)(66556008)(66476007)(85202003)(36756003)(6512007)(2906002)(52116002)(6666004)(71200400001)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4477;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3Os7X0pLblDRQ2Gk1X7kusWGlptHvRYX19BLcK81hl9yIVQ10C91YQJTZFoFG6Z0A4ziX6sR/4XnjB0SFUj5xI1buQfnTQn/Z6FPl8CksXb2c8Fs3d2YGGLGeNE/fvQUX1QDXCCsTo6p9qNr1Wo1pBWGrxJlq+UMUOf1xGR1qHGSLXRiFhjAYGTHfzUDmdSSGDvuzR6mLtKkGG3pD47Hab6ttQL3AtIm6z+IOZJat4F6TQfJmwK2NdyNmVdwnEGsUnUZ+5SpvPi+AkQ3Ew+nZTuuX6lQs3Zce8IP2KIou0n7Jwr/YgkBYE+95BF/IcDlCIHbLKVYHpzXNFb85n30BoYRo+WL4aWo1D7YlQbxY9zY2aI9iOf3FU8ZzN75edfpDzJwXDLhtbyvaZVKuuKmOyHIVak02arTMWrHcpbztrRgKGtCbLJbjN9H1pefJBmW
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAAF9278A6D4E1419A3FB6C8204FE599@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fea9b41-b5f0-4122-8369-08d7830c57de
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:33.4870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bfET/4ZuttNtER363muqfh/5qioEDwADxFVlK9So9w5pud00vL6EaLmTpiUmb8exhipySLK/QnyW5jmXW4qX9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4477
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2lt
cGxpZnkgd2Z4X2h3X3NjYW4oKSBieSBzcGxpdHRpbmcgb3V0IHRoZSB1cGRhdGUgb2YgdGhlIHBy
b2JlIHJlcXVlc3QuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBv
dWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgfCA1OSAr
KysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDMx
IGluc2VydGlvbnMoKyksIDI4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc2Nhbi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKaW5kZXggMTIyZGE4
N2JiZjkyLi44YjE4NGVmYWQwY2YgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nh
bi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCkBAIC00OSw2ICs0OSwyNyBAQCBz
dGF0aWMgaW50IHdmeF9zY2FuX3N0YXJ0KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCXJldHVybiAw
OwogfQogCitzdGF0aWMgaW50IHVwZGF0ZV9wcm9iZV90bXBsKHN0cnVjdCB3ZnhfdmlmICp3dmlm
LAorCQkJICAgICBzdHJ1Y3QgY2ZnODAyMTFfc2Nhbl9yZXF1ZXN0ICpyZXEpCit7CisJc3RydWN0
IGhpZl9taWJfdGVtcGxhdGVfZnJhbWUgKnRtcGw7CisJc3RydWN0IHNrX2J1ZmYgKnNrYjsKKwor
CXNrYiA9IGllZWU4MDIxMV9wcm9iZXJlcV9nZXQod3ZpZi0+d2Rldi0+aHcsIHd2aWYtPnZpZi0+
YWRkciwKKwkJCQkgICAgIE5VTEwsIDAsIHJlcS0+aWVfbGVuKTsKKwlpZiAoIXNrYikKKwkJcmV0
dXJuIC1FTk9NRU07CisKKwlza2JfcHV0X2RhdGEoc2tiLCByZXEtPmllLCByZXEtPmllX2xlbik7
CisJc2tiX3B1c2goc2tiLCA0KTsKKwl0bXBsID0gKHN0cnVjdCBoaWZfbWliX3RlbXBsYXRlX2Zy
YW1lICopc2tiLT5kYXRhOworCXRtcGwtPmZyYW1lX3R5cGUgPSBISUZfVE1QTFRfUFJCUkVROwor
CXRtcGwtPmZyYW1lX2xlbmd0aCA9IGNwdV90b19sZTE2KHNrYi0+bGVuIC0gNCk7CisJaGlmX3Nl
dF90ZW1wbGF0ZV9mcmFtZSh3dmlmLCB0bXBsKTsKKwlkZXZfa2ZyZWVfc2tiKHNrYik7CisJcmV0
dXJuIDA7Cit9CisKIGludCB3ZnhfaHdfc2NhbihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJ
ICAgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAkJICAgc3RydWN0IGllZWU4MDIxMV9zY2Fu
X3JlcXVlc3QgKmh3X3JlcSkKQEAgLTU2LDkgKzc3LDcgQEAgaW50IHdmeF9od19zY2FuKHN0cnVj
dCBpZWVlODAyMTFfaHcgKmh3LAogCXN0cnVjdCB3ZnhfZGV2ICp3ZGV2ID0gaHctPnByaXY7CiAJ
c3RydWN0IHdmeF92aWYgKnd2aWYgPSAoc3RydWN0IHdmeF92aWYgKikgdmlmLT5kcnZfcHJpdjsK
IAlzdHJ1Y3QgY2ZnODAyMTFfc2Nhbl9yZXF1ZXN0ICpyZXEgPSAmaHdfcmVxLT5yZXE7Ci0Jc3Ry
dWN0IHNrX2J1ZmYgKnNrYjsKIAlpbnQgaSwgcmV0OwotCXN0cnVjdCBoaWZfbWliX3RlbXBsYXRl
X2ZyYW1lICpwOwogCiAJaWYgKCF3dmlmKQogCQlyZXR1cm4gLUVJTlZBTDsKQEAgLTcyLDI5ICs5
MSwxNSBAQCBpbnQgd2Z4X2h3X3NjYW4oc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCiAJaWYgKHJl
cS0+bl9zc2lkcyA+IEhJRl9BUElfTUFYX05CX1NTSURTKQogCQlyZXR1cm4gLUVJTlZBTDsKIAot
CXNrYiA9IGllZWU4MDIxMV9wcm9iZXJlcV9nZXQoaHcsIHd2aWYtPnZpZi0+YWRkciwgTlVMTCwg
MCwgcmVxLT5pZV9sZW4pOwotCWlmICghc2tiKQotCQlyZXR1cm4gLUVOT01FTTsKLQotCWlmIChy
ZXEtPmllX2xlbikKLQkJbWVtY3B5KHNrYl9wdXQoc2tiLCByZXEtPmllX2xlbiksIHJlcS0+aWUs
IHJlcS0+aWVfbGVuKTsKLQogCW11dGV4X2xvY2soJndkZXYtPmNvbmZfbXV0ZXgpOwogCi0JcCA9
IChzdHJ1Y3QgaGlmX21pYl90ZW1wbGF0ZV9mcmFtZSAqKXNrYl9wdXNoKHNrYiwgNCk7Ci0JcC0+
ZnJhbWVfdHlwZSA9IEhJRl9UTVBMVF9QUkJSRVE7Ci0JcC0+ZnJhbWVfbGVuZ3RoID0gY3B1X3Rv
X2xlMTYoc2tiLT5sZW4gLSA0KTsKLQlyZXQgPSBoaWZfc2V0X3RlbXBsYXRlX2ZyYW1lKHd2aWYs
IHApOwotCXNrYl9wdWxsKHNrYiwgNCk7Ci0KLQlpZiAoIXJldCkKLQkJLyogSG9zdCB3YW50IHRv
IGJlIHRoZSBwcm9iZSByZXNwb25kZXIuICovCi0JCXJldCA9IHdmeF9md2RfcHJvYmVfcmVxKHd2
aWYsIHRydWUpOwotCWlmIChyZXQpIHsKLQkJbXV0ZXhfdW5sb2NrKCZ3ZGV2LT5jb25mX211dGV4
KTsKLQkJZGV2X2tmcmVlX3NrYihza2IpOwotCQlyZXR1cm4gcmV0OwotCX0KKwlyZXQgPSB1cGRh
dGVfcHJvYmVfdG1wbCh3dmlmLCByZXEpOworCWlmIChyZXQpCisJCWdvdG8gZmFpbGVkOworCisJ
cmV0ID0gd2Z4X2Z3ZF9wcm9iZV9yZXEod3ZpZiwgdHJ1ZSk7CisJaWYgKHJldCkKKwkJZ290byBm
YWlsZWQ7CiAKIAl3ZnhfdHhfbG9ja19mbHVzaCh3ZGV2KTsKIApAQCAtMTE0LDEzICsxMTksMTEg
QEAgaW50IHdmeF9od19zY2FuKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCQlkc3QtPnNzaWRf
bGVuZ3RoID0gcmVxLT5zc2lkc1tpXS5zc2lkX2xlbjsKIAkJKyt3dmlmLT5zY2FuLm5fc3NpZHM7
CiAJfQorCXNjaGVkdWxlX3dvcmsoJnd2aWYtPnNjYW4ud29yayk7CiAKK2ZhaWxlZDoKIAltdXRl
eF91bmxvY2soJndkZXYtPmNvbmZfbXV0ZXgpOwotCi0JaWYgKHNrYikKLQkJZGV2X2tmcmVlX3Nr
Yihza2IpOwotCXNjaGVkdWxlX3dvcmsoJnd2aWYtPnNjYW4ud29yayk7Ci0JcmV0dXJuIDA7CisJ
cmV0dXJuIHJldDsKIH0KIAogdm9pZCB3Znhfc2Nhbl93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAq
d29yaykKLS0gCjIuMjQuMAoK
