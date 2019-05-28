Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0110E2CEFC
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfE1SzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:55:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44344 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbfE1SzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:55:20 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SISNJJ001952;
        Tue, 28 May 2019 11:54:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vGiKlWkpxMdTb9qLhclKpTBvIMsjjZ8kj+tMVX39RU0=;
 b=IxsN2o2+wc0eyG2J6G9lY8JXtSkN2ir84DR+xd4bso5/hx1gJwls5YWN4P1eunoaVXw7
 GZY4LbwWxz9z/8C7XGNRMGWXbyoLei2VPLFF+9D1lMPYe2LRrd5T8EU5rrjpqxZE+ggY
 hCoDBRXUW43t6H2y2tenxWX/8+HO1ANQHHk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ss8220n6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 May 2019 11:54:58 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 May 2019 11:54:57 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 28 May 2019 11:54:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vGiKlWkpxMdTb9qLhclKpTBvIMsjjZ8kj+tMVX39RU0=;
 b=WIP47mSr59tAaJaFj6l8LtV1obeX2b3TnKOADwUM2lSH5Nj+ZsFsYiAeGV07pn2zKm3LY+kn5KdIAMevKYrKZ6A2aVey90Z66C1mOu+MlpSTh6zAlxhiwqvytyiNUCA7VQiar8DTuawk/ijzOOC58PrITXLZEzbTPoPy0Zw+rSU=
Received: from BYAPR15MB2311.namprd15.prod.outlook.com (52.135.197.145) by
 BYAPR15MB2792.namprd15.prod.outlook.com (20.179.158.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Tue, 28 May 2019 18:54:55 +0000
Received: from BYAPR15MB2311.namprd15.prod.outlook.com
 ([fe80::ec3f:7abc:c992:c497]) by BYAPR15MB2311.namprd15.prod.outlook.com
 ([fe80::ec3f:7abc:c992:c497%7]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 18:54:54 +0000
From:   Lawrence Brakmo <brakmo@fb.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Martin Lau <kafai@fb.com>, Alexei Starovoitov <ast@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 1/6] bpf: Create
 BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY
Thread-Topic: [PATCH v3 bpf-next 1/6] bpf: Create
 BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY
Thread-Index: AQHVFQhXCMw0+TmTBkm37BdTo0TrZqaAjGyA///h1gA=
Date:   Tue, 28 May 2019 18:54:54 +0000
Message-ID: <B962F80F-FF37-4B96-A942-1C78E4D77A1C@fb.com>
References: <20190528034907.1957536-1-brakmo@fb.com>
 <20190528034907.1957536-2-brakmo@fb.com>
 <75cd4d0a-7cf8-ee63-2662-1664aedcd468@gmail.com>
In-Reply-To: <75cd4d0a-7cf8-ee63-2662-1664aedcd468@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.19.0.190512
x-originating-ip: [2620:10d:c090:200::2:e0dc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78073f16-7ea5-471f-3ad3-08d6e39df936
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2792;
x-ms-traffictypediagnostic: BYAPR15MB2792:
x-microsoft-antispam-prvs: <BYAPR15MB279215CA57551C7EBFEC63ECA91E0@BYAPR15MB2792.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(376002)(396003)(346002)(366004)(189003)(199004)(102836004)(14454004)(7736002)(82746002)(478600001)(76116006)(8676002)(66946007)(64756008)(66556008)(110136005)(54906003)(66476007)(71190400001)(58126008)(5660300002)(66446008)(316002)(486006)(73956011)(305945005)(71200400001)(86362001)(91956017)(68736007)(83716004)(8936002)(6506007)(53546011)(6116002)(76176011)(14444005)(81156014)(81166006)(446003)(476003)(4326008)(229853002)(2906002)(2616005)(11346002)(25786009)(99286004)(53936002)(6486002)(36756003)(6246003)(186003)(6512007)(46003)(33656002)(256004)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2792;H:BYAPR15MB2311.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HY9r63uP6kNdDkmBRZZeiOEafG51xY0hQmPxJERqo5x7bWOwn5tnI9OfcSgu5i/ruCvK3OckJtAbtDCUdq5gdHYCWFStlK5pdShGguPoSb9aNLJzBmvisFmkb3xBAtyNUfPVxbn3g1NfMQV95SGZUU6QOeutzXKt0d2y3GTop2JeepNzmTsOuB8jV4MO1rJ4gdR3uJluRQKA7RCeOLFesyjZ/YfPVkMZ36RR/j96onNF9zhhRqL7o3GFU7Ciri0vLZz5M5TtA6K8k/31gzo9MAwwJ7k+GL8DCIadodDWpABZeEvMYuJwlj3EedLug8FyW4g5Eha5QC21CjIiu1INZep6DeoGshjrCbK9ee0T9+PExOxfK6Es+mM0itRsiCkn6BK1/dRaUkJXjiEK2eD2vUBgpgQQrmgTAhkfqzYNYRo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8320C215B11B874D8CB67474CD4F706B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 78073f16-7ea5-471f-3ad3-08d6e39df936
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 18:54:54.8646
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: brakmo@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2792
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280117
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNS8yOC8xOSwgNjo0MyBBTSwgIm5ldGRldi1vd25lckB2Z2VyLmtlcm5lbC5vcmcgb24gYmVo
YWxmIG9mIEVyaWMgRHVtYXpldCIgPG5ldGRldi1vd25lckB2Z2VyLmtlcm5lbC5vcmcgb24gYmVo
YWxmIG9mIGVyaWMuZHVtYXpldEBnbWFpbC5jb20+IHdyb3RlOg0KDQogICAgDQogICAgDQogICAg
T24gNS8yNy8xOSA4OjQ5IFBNLCBicmFrbW8gd3JvdGU6DQogICAgPiBDcmVhdGUgbmV3IG1hY3Jv
IEJQRl9QUk9HX0NHUk9VUF9JTkVUX0VHUkVTU19SVU5fQVJSQVkoKSB0byBiZSB1c2VkIGJ5DQog
ICAgPiBfX2Nncm91cF9icGZfcnVuX2ZpbHRlcl9za2IgZm9yIEVHUkVTUyBCUEYgcHJvZ3Mgc28g
QlBGIHByb2dyYW1zIGNhbg0KICAgID4gcmVxdWVzdCBjd3IgZm9yIFRDUCBwYWNrZXRzLg0KICAg
ID4gDQogICAgDQogICAgLi4uDQogICAgDQogICAgPiArI2RlZmluZSBCUEZfUFJPR19DR1JPVVBf
SU5FVF9FR1JFU1NfUlVOX0FSUkFZKGFycmF5LCBjdHgsIGZ1bmMpCQlcDQogICAgPiArCSh7CQkJ
CQkJXA0KICAgID4gKwkJc3RydWN0IGJwZl9wcm9nX2FycmF5X2l0ZW0gKl9pdGVtOwlcDQogICAg
PiArCQlzdHJ1Y3QgYnBmX3Byb2cgKl9wcm9nOwkJCVwNCiAgICA+ICsJCXN0cnVjdCBicGZfcHJv
Z19hcnJheSAqX2FycmF5OwkJXA0KICAgID4gKwkJdTMyIHJldDsJCQkJXA0KICAgID4gKwkJdTMy
IF9yZXQgPSAxOwkJCQlcDQogICAgPiArCQl1MzIgX2NuID0gMDsJCQkJXA0KICAgID4gKwkJcHJl
ZW1wdF9kaXNhYmxlKCk7CQkJXA0KICAgID4gKwkJcmN1X3JlYWRfbG9jaygpOwkJCVwNCiAgICA+
ICsJCV9hcnJheSA9IHJjdV9kZXJlZmVyZW5jZShhcnJheSk7CVwNCiAgICANCiAgICBXaHkgX2Fy
cmF5IGNhbiBub3QgYmUgTlVMTCBoZXJlID8NCg0KSSByZXBsYWNlZCB0aGUgY2FsbCBjaGFpbiAN
CiAgQlBGX0NHUk9VUF9SVU5fUFJPR19JTkVUX0VHUkVTUygpDQogICAgX19jZ3JvdXBfYnBmX3J1
bl9maWx0ZXJfc2tiKCkNCiAgICAgIEJQRl9QUk9HX1JVTl9BUlJBWSgpDQogICAgICAgIF9fQlBG
X1BST0dfUlVOX0FSUkFZKCAsICwgZmFsc2UpDQoNCldpdGgNCiAgQlBGX0NHUk9VUF9SVU5fUFJP
R19JTkVUX0VHUkVTUygpDQogICAgX19jZ3JvdXBfYnBmX3J1bl9maWx0ZXJfc2tiKCkNCiAgICAg
IEJQRl9QUk9HX0NHUk9VUF9JTkVUX0VHUkVTU19SVU5fQVJSQVkoKQ0KDQpCUEZfUFJPR19DR1JP
VVBfSU5FVF9FR1JFU1NfUlVOX0FSUkFZKCkgaXMgYSBpbnN0YW50aWF0aW9uIG9mDQpfX0JQRl9Q
Uk9HX1JVTl9BUlJBWSgpIHdpdGggdGhlIGFyZ3VtZW50ICJjaGVja19ub25fbnVsbCIgPSBmYWxz
ZQ0KSGVuY2UgSSByZW1vdmVkIHRoZSB0ZXN0ICJpZiAodW5saWtlbHkoY2hlY2tfbm9uX251bGwg
JiYgIV9hcnJheSkpIg0Kc2luY2UgaXQgYWx3YXlzIGZhaWxzLiBJIGhhdmUgYXNzdW1lZCB0aGUg
ZXhpc3RpbmcgY29kZSBpcyBjb3JyZWN0Lg0KDQogICAgDQogICAgPiArCQlfaXRlbSA9ICZfYXJy
YXktPml0ZW1zWzBdOwkJXA0KICAgID4gKwkJd2hpbGUgKChfcHJvZyA9IFJFQURfT05DRShfaXRl
bS0+cHJvZykpKSB7CQlcDQogICAgPiArCQkJYnBmX2Nncm91cF9zdG9yYWdlX3NldChfaXRlbS0+
Y2dyb3VwX3N0b3JhZ2UpOwlcDQogICAgPiArCQkJcmV0ID0gZnVuYyhfcHJvZywgY3R4KTsJCVwN
CiAgICA+ICsJCQlfcmV0ICY9IChyZXQgJiAxKTsJCVwNCiAgICA+ICsJCQlfY24gfD0gKHJldCAm
IDIpOwkJXA0KICAgID4gKwkJCV9pdGVtKys7CQkJXA0KICAgID4gKwkJfQkJCQkJXA0KICAgID4g
KwkJcmN1X3JlYWRfdW5sb2NrKCk7CQkJXA0KICAgID4gKwkJcHJlZW1wdF9lbmFibGVfbm9fcmVz
Y2hlZCgpOwkNCiAgICANCiAgICBXaHkgYXJlIHlvdSB1c2luZyBwcmVlbXB0X2VuYWJsZV9ub19y
ZXNjaGVkKCkgaGVyZSA/DQoNCkJlY2F1c2UgdGhhdCBpcyB3aGF0IF9fQlBGX1BST0dfUlVOX0FS
UkFZKCkgY2FsbHMgYW5kIHRoZSBtYWNybw0KQlBGX1BST0dfQ0dST1VQX0lORVRfRUdSRVNTX1JV
Tl9BUlJBWSgpIGlzIGFuIGluc3RhbnRpYXRpb24gb2YgaXQNCih3aXRoIG1pbm9yIGNoYW5nZXMg
aW4gdGhlIHJldHVybiB2YWx1ZSkuDQogICAgDQogICAgCVwNCiAgICA+ICsJCWlmIChfcmV0KQkJ
CQlcDQogICAgPiArCQkJX3JldCA9IChfY24gPyBORVRfWE1JVF9DTiA6IE5FVF9YTUlUX1NVQ0NF
U1MpOwlcDQogICAgPiArCQllbHNlCQkJCQlcDQogICAgPiArCQkJX3JldCA9IChfY24gPyBORVRf
WE1JVF9EUk9QIDogLUVQRVJNKTsJCVwNCiAgICA+ICsJCV9yZXQ7CQkJCQlcDQogICAgPiArCX0p
DQogICAgPiArDQogICAgPiAgI2RlZmluZSBCUEZfUFJPR19SVU5fQVJSQVkoYXJyYXksIGN0eCwg
ZnVuYykJCVwNCiAgICA+ICAJX19CUEZfUFJPR19SVU5fQVJSQVkoYXJyYXksIGN0eCwgZnVuYywg
ZmFsc2UpDQogICAgPiAgDQogICAgPiANCiAgICANCg0K
