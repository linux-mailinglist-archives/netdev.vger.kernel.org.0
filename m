Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 358FE2C16B
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 10:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfE1Ief (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 04:34:35 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:59488 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726557AbfE1Iee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 04:34:34 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4S8WjYr016093;
        Tue, 28 May 2019 01:34:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=IuklDDH21MYIVeuL01ZQnCZb5D6D3+lgcMFYhAzktGU=;
 b=RQkJJHu0RUNltlRbq01PXim+lWQ5jXleq1FaMlamvxMflKLzJqBBxegg51OoVUmiM+hl
 HMbuZ7cGD+ynTIWayj3XTqsN0cXui9FDfz6D8fjxNaKBzuoAkU2x9eCqPeaBk1GmoGci
 CA1pTnJjSBDswXQLkUvJWK48fyq4Eanm9CQssQF0f6EcISOh5yBRxKCrlu9D9WeO9RjV
 7ekA0r6szWSRYV6EwaANYZB+fXZ0uerY/yUwdwnXlkMYzUC4X2FTf8UfuBJPeEBHXP/m
 6Dsj9LU+lfjZhmy3a06I54CWHOlkS19f71Obg2SKGJuScQDW8LrXtQxbMEbVIVF+ZvGk qw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2sr7e4dg3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 May 2019 01:34:30 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 28 May
 2019 01:34:29 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (104.47.50.56) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 28 May 2019 01:34:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IuklDDH21MYIVeuL01ZQnCZb5D6D3+lgcMFYhAzktGU=;
 b=PQsAEkEJ+qsthEVy32wjb9RSuW3wNl/yyDrSisRfGFDO1CwaBa8Zl8tWsrRvquwxN9LLSJ1LMVbO3FVz1IZjRIEm4OGwljfS3Hk1565mzHLPU4TaWNX6ocr1huix1arw7K2ZBicqMPmW92jLlazR80vKRj5MFj3DIoVRPf+M5WI=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB2672.namprd18.prod.outlook.com (20.179.84.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Tue, 28 May 2019 08:34:23 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::9880:2b8b:52e5:b413]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::9880:2b8b:52e5:b413%3]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 08:34:23 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Colin King <colin.king@canonical.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH][next] qed: fix spelling mistake "inculde" ->
 "include"
Thread-Topic: [EXT] [PATCH][next] qed: fix spelling mistake "inculde" ->
 "include"
Thread-Index: AQHVFSHr8lMSvwYvE06Dm65I9JgLzaaANeoQ
Date:   Tue, 28 May 2019 08:34:23 +0000
Message-ID: <MN2PR18MB3182F2B217A519FA20F3427AA11E0@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190528065217.7311-1-colin.king@canonical.com>
In-Reply-To: <20190528065217.7311-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ee0233e-78de-48d5-d5df-08d6e34749c7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2672;
x-ms-traffictypediagnostic: MN2PR18MB2672:
x-microsoft-antispam-prvs: <MN2PR18MB2672AB82C128A3803B627620A11E0@MN2PR18MB2672.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(136003)(39850400004)(366004)(396003)(376002)(199004)(189003)(74316002)(7696005)(73956011)(81166006)(14454004)(2501003)(229853002)(6506007)(305945005)(186003)(26005)(14444005)(256004)(81156014)(25786009)(66066001)(53936002)(8936002)(76116006)(11346002)(102836004)(2906002)(7736002)(76176011)(478600001)(3846002)(99286004)(6116002)(5660300002)(71190400001)(6246003)(66476007)(486006)(6436002)(8676002)(71200400001)(9686003)(33656002)(4326008)(52536014)(66556008)(66446008)(64756008)(55016002)(446003)(66946007)(110136005)(86362001)(476003)(68736007)(54906003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2672;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GJ1SR5m/XZuS+I7l7qtd1XVnDAoe4P7hg4QHdHLxJ/zXDETULp6HZRJBWO7AMbq8wHou5csJ1/qkdu8GRBBJwA9Z/46X/v55FhkFXMmfHsAGZUnwhPVlSJvt/mCqa/VM8soEJfHp1eW23ZlFtflwRB/pW2fvm27H7vkqRsKw3tuVARMuhfN15ERxSkYawaON4F1XNmuRRuUJqQg71E7N7bckvsO/OynE5f0FcbvQBtlQ0Yrrx9AxxMX4CUIx+hCVzuHz49CJDRdwH8vy/lDPFNQ4aSEZjOTXw1CNes9rJaiFeSGSyh54ztMbxDpCm0o41VqJijyS3qJdekKsW181awUdCkwLszXy2W1CMLz6qDxAhZCOxh+PLlOmdVEGdUBla9MQL25JqwAtXFvju5NDz6iE3UZhKwxv44JEAueQpM8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ee0233e-78de-48d5-d5df-08d6e34749c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 08:34:23.8390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2672
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_04:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBDb2xpbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IFNlbnQ6IFR1
ZXNkYXksIE1heSAyOCwgMjAxOSA5OjUyIEFNDQo+IA0KPiBFeHRlcm5hbCBFbWFpbA0KPiANCj4g
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQ0KPiBGcm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmlj
YWwuY29tPg0KPiANCj4gVGhlcmUgaXMgYSBzcGVsbGluZyBtaXN0YWtlIGluIGEgRFBfSU5GTyBt
ZXNzYWdlLiBGaXggaXQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBDb2xpbiBJYW4gS2luZyA8Y29s
aW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L3Fs
b2dpYy9xZWQvcWVkX2Rldi5jIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvcWxvZ2ljL3FlZC9xZWRfZGV2LmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9xbG9naWMv
cWVkL3FlZF9kZXYuYw0KPiBpbmRleCA2MWNhNDlhOTY3ZGYuLmE5NzE0MTg3NTVlOSAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvcWxvZ2ljL3FlZC9xZWRfZGV2LmMNCj4gKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvcWxvZ2ljL3FlZC9xZWRfZGV2LmMNCj4gQEAgLTM4MzYs
NyArMzgzNiw3IEBAIHN0YXRpYyBpbnQgcWVkX2h3X2dldF9wcGZpZF9iaXRtYXAoc3RydWN0DQo+
IHFlZF9od2ZuICpwX2h3Zm4sDQo+IA0KPiAgCWlmICghKGNkZXYtPnBwZmlkX2JpdG1hcCAmICgw
eDEgPDwgbmF0aXZlX3BwZmlkX2lkeCkpKSB7DQo+ICAJCURQX0lORk8ocF9od2ZuLA0KPiAtCQkJ
IkZpeCB0aGUgUFBGSUQgYml0bWFwIHRvIGluY3VsZGUgdGhlIG5hdGl2ZSBQUEZJRA0KPiBbbmF0
aXZlX3BwZmlkX2lkeCAlaGhkLCBvcmlnX2JpdG1hcCAweCVoaHhdXG4iLA0KPiArCQkJIkZpeCB0
aGUgUFBGSUQgYml0bWFwIHRvIGluY2x1ZGUgdGhlIG5hdGl2ZSBQUEZJRA0KPiBbbmF0aXZlX3Bw
ZmlkX2lkeCAlaGhkLCBvcmlnX2JpdG1hcCAweCVoaHhdXG4iLA0KPiAgCQkJbmF0aXZlX3BwZmlk
X2lkeCwgY2Rldi0+cHBmaWRfYml0bWFwKTsNCj4gIAkJY2Rldi0+cHBmaWRfYml0bWFwID0gMHgx
IDw8IG5hdGl2ZV9wcGZpZF9pZHg7DQo+ICAJfQ0KPiAtLQ0KPiAyLjIwLjENCg0KVGhhbmtzLMKg
DQoNCkFja2VkLWJ5OiBNaWNoYWwgS2FsZGVyb27CoDxtaWNoYWwua2FsZGVyb25AbWFydmVsbC5j
b20+DQoNCg0K
