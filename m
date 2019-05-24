Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE5529B7A
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 17:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390114AbfEXPtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 11:49:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44762 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389079AbfEXPtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 11:49:11 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4OFm7O1005254;
        Fri, 24 May 2019 08:48:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=JEK3y/P09j0d5ABVPuD1zjsmFnIyNIyxowIG2BTVP3c=;
 b=oE1mClnLrR9tVeLlUV+ymK5HIhJecIcc5Dn+8zeF4xuSDzaYLa6rlpGYRzKpHxlUIxMA
 labu/OVg7inkQoEiDTMlx/b/FyrvoCF2qTBWpsNJwKTV9P3/PqyB/wsNhX91OFgx7mJm
 E4vqMQIUTV7ZLr7bSF97oOYKgVQe+DO/DTE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2spj2vgb97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 24 May 2019 08:48:48 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 May 2019 08:48:47 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 24 May 2019 08:48:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JEK3y/P09j0d5ABVPuD1zjsmFnIyNIyxowIG2BTVP3c=;
 b=N+/Deu5qaxvvvm6EnZdRrnx6ITy3/B0Axq9FTFpMlqHW4i2wUtrOEKG87F7dFPcqGlefOtr6IsTw39EiYQGc4w0nHC7cQHYygkIeSL2aIRIz3T9xhPMSh/u/ornWgmQDOT+ATHZzOyfo362QJZXtlzbovzvdIt/kPVGQP1jDsd0=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2920.namprd15.prod.outlook.com (20.178.236.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 24 May 2019 15:48:45 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::956e:28a4:f18d:b698%3]) with mapi id 15.20.1900.020; Fri, 24 May 2019
 15:48:45 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v3 0/3] tools: bpftool: add an option for debug
 output from libbpf and verifier
Thread-Topic: [PATCH bpf-next v3 0/3] tools: bpftool: add an option for debug
 output from libbpf and verifier
Thread-Index: AQHVEhyeHssM0Sx0K0O8JHsdRwJYPKZ6bA6A
Date:   Fri, 24 May 2019 15:48:45 +0000
Message-ID: <e8f85691-2a29-eeea-9149-ded6b5bf39bc@fb.com>
References: <20190524103648.15669-1-quentin.monnet@netronome.com>
In-Reply-To: <20190524103648.15669-1-quentin.monnet@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0002.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::15) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:f644]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81ddb419-349d-4c9e-10ce-08d6e05f4ddb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB2920;
x-ms-traffictypediagnostic: BYAPR15MB2920:
x-ms-exchange-purlcount: 2
x-microsoft-antispam-prvs: <BYAPR15MB292010A187C939C04D522732D3020@BYAPR15MB2920.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:792;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(376002)(366004)(39860400002)(396003)(136003)(199004)(189003)(99286004)(8676002)(6436002)(53936002)(81156014)(81166006)(14454004)(6506007)(6486002)(76176011)(53546011)(966005)(52116002)(229853002)(102836004)(25786009)(4326008)(31686004)(478600001)(8936002)(6246003)(110136005)(54906003)(36756003)(316002)(46003)(476003)(2616005)(11346002)(446003)(256004)(71190400001)(14444005)(71200400001)(5660300002)(86362001)(31696002)(386003)(6512007)(6306002)(7736002)(68736007)(6116002)(305945005)(186003)(66476007)(66556008)(64756008)(66446008)(66946007)(486006)(73956011)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2920;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GMrW+pIjvavDZbbydv1oJkn1Nuh72N/dQG9uVY4GD2liImrEYPmTdMmRPZ68jAQ8TvANVf2FAoNSgHSp1xyq84DF//Lyrkd8y3K5mqpLMR0oszDUcdfI4yikSr/f8UzrV9dXXnaBc7iAiEtFAVMu/cCqrLXNucrkYLBYdyvw7VRRk0iyX64MRgKd+A0BOjrS/y+/6WQ3WMkpbtCkbpGO4OF7JWXEl5UuycPOEPnwvPioFoHRK1MZh3jJYMO4fv4cRlnrXCHJS3FffLofF8o6aI2oWdHtqOAafUreUBLkQ/rHjR06cvh/43GxIyNXDCdUjtPWcuv140pRfOWBSVmH0O11zJbAatn9RUgQ7CZG7YB6pMC6VE7o1LpTCGrNynuZzFbcFoOrtBtlqL8zk5WlhgL7qLZInZmvA3qtj++mKu4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9ACC35801332E3418279F21DD9FE43BE@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ddb419-349d-4c9e-10ce-08d6e05f4ddb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 15:48:45.5769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2920
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-24_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=910 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905240104
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMjQvMTkgMzozNiBBTSwgUXVlbnRpbiBNb25uZXQgd3JvdGU6DQo+IEhpLA0KPiBU
aGlzIHNlcmllcyBhZGRzIGFuIG9wdGlvbiB0byBicGZ0b29sIHRvIG1ha2UgaXQgcHJpbnQgYWRk
aXRpb25hbA0KPiBpbmZvcm1hdGlvbiB2aWEgbGliYnBmIGFuZCB0aGUga2VybmVsIHZlcmlmaWVy
IHdoZW4gYXR0ZW1wdGluZyB0byBsb2FkDQo+IHByb2dyYW1zLg0KPiANCj4gQSBuZXcgQVBJIGZ1
bmN0aW9uIGlzIGFkZGVkIHRvIGxpYmJwZiBpbiBvcmRlciB0byBwYXNzIHRoZSBsb2dfbGV2ZWwg
ZnJvbQ0KPiBicGZ0b29sIHdpdGggdGhlIGJwZl9vYmplY3RfXyogcGFydCBvZiB0aGUgQVBJLg0K
PiANCj4gT3B0aW9ucyBmb3IgYSBmaW5lciBjb250cm9sIG92ZXIgdGhlIGxvZyBsZXZlbHMgdG8g
dXNlIGZvciBsaWJicGYgYW5kIHRoZQ0KPiB2ZXJpZmllciBjb3VsZCBiZSBhZGRlZCBpbiB0aGUg
ZnV0dXJlLCBpZiBkZXNpcmVkLg0KPiANCj4gdjM6DQo+IC0gRml4IGFuZCBjbGFyaWZ5IGNvbW1p
dCBsb2dzLg0KPiANCj4gdjI6DQo+IC0gRG8gbm90IGFkZCBkaXN0aW5jdCBvcHRpb25zIGZvciBs
aWJicGYgYW5kIHZlcmlmaWVyIGxvZ3MsIGp1c3Qga2VlcCB0aGUNCj4gICAgb25lIHRoYXQgc2V0
cyBhbGwgbG9nIGxldmVscyB0byB0aGVpciBtYXhpbXVtLiBSZW5hbWUgdGhlIG9wdGlvbi4NCj4g
LSBEbyBub3Qgb2ZmZXIgYSB3YXkgdG8gcGljayBkZXNpcmVkIGxvZyBsZXZlbHMuIFRoZSBjaG9p
Y2UgaXMgInVzZSB0aGUNCj4gICAgb3B0aW9uIHRvIHByaW50IGFsbCBsb2dzIiBvciAic3RpY2sg
d2l0aCB0aGUgZGVmYXVsdHMiLg0KPiAtIERvIG5vdCBleHBvcnQgQlBGX0xPR18qIGZsYWdzIHRv
IHVzZXIgaGVhZGVyLg0KPiAtIFVwZGF0ZSBhbGwgbWFuIHBhZ2VzIChtb3N0IGJwZnRvb2wgb3Bl
cmF0aW9ucyB1c2UgbGliYnBmIGFuZCBtYXkgcHJpbnQNCj4gICAgbGliYnBmIGxvZ3MpLiBWZXJp
ZmllciBsb2dzIGFyZSBvbmx5IHVzZWQgd2hlbiBhdHRlbXB0aW5nIHRvIGxvYWQNCj4gICAgcHJv
Z3JhbXMgZm9yIG5vdywgc28gYnBmdG9vbC1wcm9nLnJzdCBhbmQgYnBmdG9vbC5yc3QgcmVtYWlu
IHRoZSBvbmx5DQo+ICAgIHBhZ2VzIHVwZGF0ZWQgaW4gdGhhdCByZWdhcmQuDQo+IA0KPiBQcmV2
aW91cyBkaXNjdXNzaW9uIGF2YWlsYWJsZSBhdDoNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
YnBmLzIwMTkwNTIzMTA1NDI2LjM5MzgtMS1xdWVudGluLm1vbm5ldEBuZXRyb25vbWUuY29tLw0K
PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9icGYvMjAxOTA0MjkwOTUyMjcuOTc0NS0xLXF1ZW50
aW4ubW9ubmV0QG5ldHJvbm9tZS5jb20vDQoNClRoZSBzZXJpZXMgbG9va3MgZ29vZCB0byBtZS4N
CkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KDQo+IA0KPiBRdWVudGluIE1v
bm5ldCAoMyk6DQo+ICAgIHRvb2xzOiBicGZ0b29sOiBhZGQgLWQgb3B0aW9uIHRvIGdldCBkZWJ1
ZyBvdXRwdXQgZnJvbSBsaWJicGYNCj4gICAgbGliYnBmOiBhZGQgYnBmX29iamVjdF9fbG9hZF94
YXR0cigpIEFQSSBmdW5jdGlvbiB0byBwYXNzIGxvZ19sZXZlbA0KPiAgICB0b29sczogYnBmdG9v
bDogbWFrZSAtZCBvcHRpb24gcHJpbnQgZGVidWcgb3V0cHV0IGZyb20gdmVyaWZpZXINCj4gDQo+
ICAgLi4uL2JwZi9icGZ0b29sL0RvY3VtZW50YXRpb24vYnBmdG9vbC1idGYucnN0IHwgIDQgKysr
DQo+ICAgLi4uL2JwZnRvb2wvRG9jdW1lbnRhdGlvbi9icGZ0b29sLWNncm91cC5yc3QgIHwgIDQg
KysrDQo+ICAgLi4uL2JwZnRvb2wvRG9jdW1lbnRhdGlvbi9icGZ0b29sLWZlYXR1cmUucnN0IHwg
IDQgKysrDQo+ICAgLi4uL2JwZi9icGZ0b29sL0RvY3VtZW50YXRpb24vYnBmdG9vbC1tYXAucnN0
IHwgIDQgKysrDQo+ICAgLi4uL2JwZi9icGZ0b29sL0RvY3VtZW50YXRpb24vYnBmdG9vbC1uZXQu
cnN0IHwgIDQgKysrDQo+ICAgLi4uL2JwZnRvb2wvRG9jdW1lbnRhdGlvbi9icGZ0b29sLXBlcmYu
cnN0ICAgIHwgIDQgKysrDQo+ICAgLi4uL2JwZnRvb2wvRG9jdW1lbnRhdGlvbi9icGZ0b29sLXBy
b2cucnN0ICAgIHwgIDUgKysrKw0KPiAgIHRvb2xzL2JwZi9icGZ0b29sL0RvY3VtZW50YXRpb24v
YnBmdG9vbC5yc3QgICB8ICA0ICsrKw0KPiAgIHRvb2xzL2JwZi9icGZ0b29sL2Jhc2gtY29tcGxl
dGlvbi9icGZ0b29sICAgICB8ICAyICstDQo+ICAgdG9vbHMvYnBmL2JwZnRvb2wvbWFpbi5jICAg
ICAgICAgICAgICAgICAgICAgIHwgMTYgKysrKysrKysrKy0NCj4gICB0b29scy9icGYvYnBmdG9v
bC9tYWluLmggICAgICAgICAgICAgICAgICAgICAgfCAgMSArDQo+ICAgdG9vbHMvYnBmL2JwZnRv
b2wvcHJvZy5jICAgICAgICAgICAgICAgICAgICAgIHwgMjcgKysrKysrKysrKysrLS0tLS0tLQ0K
PiAgIHRvb2xzL2xpYi9icGYvTWFrZWZpbGUgICAgICAgICAgICAgICAgICAgICAgICB8ICAyICst
DQo+ICAgdG9vbHMvbGliL2JwZi9saWJicGYuYyAgICAgICAgICAgICAgICAgICAgICAgIHwgMjAg
KysrKysrKysrKystLS0NCj4gICB0b29scy9saWIvYnBmL2xpYmJwZi5oICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgNiArKysrKw0KPiAgIHRvb2xzL2xpYi9icGYvbGliYnBmLm1hcCAgICAgICAg
ICAgICAgICAgICAgICB8ICA1ICsrKysNCj4gICAxNiBmaWxlcyBjaGFuZ2VkLCA5NiBpbnNlcnRp
b25zKCspLCAxNiBkZWxldGlvbnMoLSkNCj4gDQo=
