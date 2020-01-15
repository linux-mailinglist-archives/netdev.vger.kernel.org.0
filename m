Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02CF813BF49
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbgAOMMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:31 -0500
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:24527
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730407AbgAOMMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XDv21aBzTsS7RsYVVHxWWwhk5WXM8toij2/+boZBZ6kBo2BibeDxqvwFdmsTgXEQat52ibSiSvaA7+BiSwtKAn4CM4Mimmz9O1nmPVJ0YeWbe+fmN42vyDfdkGuDMOMPhmNRRvS2OeDSUMtr2wzrH9WyICzvuBhDMMTNijN2EXkNl/fns++zkEDGSXFtwZl31npvCb/411agw6eAO569pjmcSniBoGbU1yq+hV717muxKxl8akafhS1XqmXB5ptXh43/MiqE5BaeingmItglhMp9SRysZ/ZvUHpMYoyaaD0bagaYkmYRDq9PC3Nyh6z5J4wYYZr/0cyawv010t4Psg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhQww9H4Ug/YZqWy3+tCxx6M/uj8urd6WRAAOKOSgfk=;
 b=BGHr8emZ1LheOjJufVIsWb/LjhnPUAg4R1SoQ7CNo0zg4MQeiSnFEsZ2OhbFVUqV9VjiNBFmWGkOXJe6dgVJu7CQAo0Nq+XkbfnAU0V3WeLHAk3V1bInqvir8pLIRvQW4bTaAHgZrBEecQGMOASSzPYnAoLFnrRMuKf9jY5zzOliPLdAMpPinKCMJrs4osgCV1t6MH58Ph9ivR8gmyQamTkNSC7yp79v3qtwhHXfEpDl6CdaqjsEr19yAcNiAYaT/I0lcgYMkNCXs4wkS3nNXthbuyr+2o2j5E3cXnEcNHd4Sbo1hO3cv6xaxM6M001gfsByZF3+p3aZb4lQoIO22A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fhQww9H4Ug/YZqWy3+tCxx6M/uj8urd6WRAAOKOSgfk=;
 b=NRkxrzOet4nAik84m5bqP/19zGskwiXV7U4YOZ1YxkF4NNkY5m395YnZVHoVFHLlHq4/yVKkPugk4XTu2sQydAQEJoVetIc2+urzEyj4FbNCSgSNJqAHDQX6GZeIwClSCRCbEm2uM4qspY/BXeOFDFEl3Swda7fQWRGBvOeUzoo=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:12:23 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:23 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:22 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 11/65] staging: wfx: retrieve ampdu_density from sta->ht_cap
Thread-Topic: [PATCH 11/65] staging: wfx: retrieve ampdu_density from
 sta->ht_cap
Thread-Index: AQHVy50LtkZjjwN3TU6ocwOSVEE0eg==
Date:   Wed, 15 Jan 2020 12:12:23 +0000
Message-ID: <20200115121041.10863-12-Jerome.Pouiller@silabs.com>
References: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:101:16::21) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b3701e95-c478-4a29-46af-08d799b42d72
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB409630A5C9EC389BBD3FECF393370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:222;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZVfgNNtPSMmdc6AKVptoSGZjdKYmJGCgP8ABezRxQcFWTJjkbC4y7ql+Bh5fkj2PQcv4ICMU8Djr5189GSFXCK/iU9/QbSSlUMzrqSYS81sajCMmC1nTDiyatrAccP+LSnSu2p+SgTxYLsckPUtowjFD8KvwXVrsMk51XcDodSFoi9icObTX+xMYT9NCOLq6NXR7a/DoWc2NqaM6dqGVpFQzwpCYfuz3YTlYiaq/MCvFnyOXBcSykHDKrDalOTb6se9x4756+DyB+AbAWgHtpOucpcLRNNkq6nupS/YTxTQbENlZSaIwjik51LYDO3JacUMoKOJk/0SX7HX1dkrIGzr3f/hBMW2kyihTSxDVHCeJg9bx4MrALRyN98J9/gmFiPY4IsfWputXvg8OMaXUC95MhOD84Eqson1zspZ2IxYWAesBWqRkHIz7x8faFboU
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D6BD7011FB07D4E986E06A336CDE004@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3701e95-c478-4a29-46af-08d799b42d72
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:23.3750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ro7gklOEQlLb502GJT4SME24Gr2yM1xji8Ihhc1ojV3wFo2+CIkhDqVOQH2vPXqJn/F6pFx+m9wGgbRU2Q4q0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd3Zp
Zi0+aHRfaW5mby5odF9jYXAgaXMgYSB1c2VsZXNzIGNvcHkgb2Ygc3RhLT5odF9jYXAuIEl0IG1h
a2VzIG5vIHNlbnNlCnRvIHJlbHkgb24gaXQuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3Vp
bGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYyB8IDEwICsrLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyks
IDggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggNjYwYTc1MDI0ZjRiLi5mMTNhNWI0MTcz
NWMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwpAQCAtODI1LDEzICs4MjUsNiBAQCBzdGF0aWMgaW50IHdmeF9odF9n
cmVlbmZpZWxkKGNvbnN0IHN0cnVjdCB3ZnhfaHRfaW5mbyAqaHRfaW5mbykKIAkJICBJRUVFODAy
MTFfSFRfT1BfTU9ERV9OT05fR0ZfU1RBX1BSU05UKTsKIH0KIAotc3RhdGljIGludCB3ZnhfaHRf
YW1wZHVfZGVuc2l0eShjb25zdCBzdHJ1Y3Qgd2Z4X2h0X2luZm8gKmh0X2luZm8pCi17Ci0JaWYg
KCF3ZnhfaXNfaHQoaHRfaW5mbykpCi0JCXJldHVybiAwOwotCXJldHVybiBodF9pbmZvLT5odF9j
YXAuYW1wZHVfZGVuc2l0eTsKLX0KLQogc3RhdGljIHZvaWQgd2Z4X2pvaW5fZmluYWxpemUoc3Ry
dWN0IHdmeF92aWYgKnd2aWYsCiAJCQkgICAgICBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25mICpp
bmZvKQogewpAQCAtODcwLDcgKzg2Myw4IEBAIHN0YXRpYyB2b2lkIHdmeF9qb2luX2ZpbmFsaXpl
KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCWFzc29jaWF0aW9uX21vZGUuc2hvcnRfcHJlYW1ibGUg
PSBpbmZvLT51c2Vfc2hvcnRfcHJlYW1ibGU7CiAJYXNzb2NpYXRpb25fbW9kZS5iYXNpY19yYXRl
X3NldCA9IGNwdV90b19sZTMyKHdmeF9yYXRlX21hc2tfdG9faHcod3ZpZi0+d2RldiwgaW5mby0+
YmFzaWNfcmF0ZXMpKTsKIAlhc3NvY2lhdGlvbl9tb2RlLmdyZWVuZmllbGQgPSB3ZnhfaHRfZ3Jl
ZW5maWVsZCgmd3ZpZi0+aHRfaW5mbyk7Ci0JYXNzb2NpYXRpb25fbW9kZS5tcGR1X3N0YXJ0X3Nw
YWNpbmcgPSB3ZnhfaHRfYW1wZHVfZGVuc2l0eSgmd3ZpZi0+aHRfaW5mbyk7CisJaWYgKHN0YSAm
JiBzdGEtPmh0X2NhcC5odF9zdXBwb3J0ZWQpCisJCWFzc29jaWF0aW9uX21vZGUubXBkdV9zdGFy
dF9zcGFjaW5nID0gc3RhLT5odF9jYXAuYW1wZHVfZGVuc2l0eTsKIAogCXdmeF9jcW1fYnNzbG9z
c19zbSh3dmlmLCAwLCAwLCAwKTsKIAljYW5jZWxfd29ya19zeW5jKCZ3dmlmLT51bmpvaW5fd29y
ayk7Ci0tIAoyLjI1LjAKCg==
