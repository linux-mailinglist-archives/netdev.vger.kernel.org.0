Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D25022D0F3
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 23:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfE1VYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 17:24:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38764 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726452AbfE1VYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 17:24:21 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SLCbqV008081;
        Tue, 28 May 2019 14:23:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dmx/kwE8O9B8YOJW72KkAJnsJqmFy+wlRxvwOZx6h3I=;
 b=YdEZ5Bu5sBHI5YvHq1golg+vIiivQK2vcrsW6ZqLKvfTR6xanNVvutmGxx/BgJgfyWtN
 P1gLlfJMUSnHjc/HT18gZiix8tsmNlML2+L84+mADT8Lf3UYOLtiMKWMcni19W89T4x5
 TZMGDsL/WO8JtoHRzhnUQxv/5tidC7KCQq8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ss90cgxs7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 28 May 2019 14:23:59 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 28 May 2019 14:23:58 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 28 May 2019 14:23:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dmx/kwE8O9B8YOJW72KkAJnsJqmFy+wlRxvwOZx6h3I=;
 b=JGPEFIWZLq7rp4JfM+rXb019neQMlm2ll+/D0iuqs8K0a3r8iqchPk6FsByRn8JPqjvTynU6rcVXNClQrKp9WP/aQVj5lsC6OoalmSDcc4jgbK/Swzh4k13p82vflvCiK3vK4KXaiCAv7zv9iS93+G3LTYdEH0yLv+yUfDIJ01c=
Received: from BYAPR15MB2311.namprd15.prod.outlook.com (52.135.197.145) by
 BYAPR15MB3430.namprd15.prod.outlook.com (20.179.59.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Tue, 28 May 2019 21:23:57 +0000
Received: from BYAPR15MB2311.namprd15.prod.outlook.com
 ([fe80::ec3f:7abc:c992:c497]) by BYAPR15MB2311.namprd15.prod.outlook.com
 ([fe80::ec3f:7abc:c992:c497%7]) with mapi id 15.20.1922.021; Tue, 28 May 2019
 21:23:57 +0000
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
Thread-Index: AQHVFQhXCMw0+TmTBkm37BdTo0TrZqaAjGyA///h1gCAAJOeAP//lgOA
Date:   Tue, 28 May 2019 21:23:56 +0000
Message-ID: <20950DF0-15BC-4F15-AD5E-503A323EC39A@fb.com>
References: <20190528034907.1957536-1-brakmo@fb.com>
 <20190528034907.1957536-2-brakmo@fb.com>
 <75cd4d0a-7cf8-ee63-2662-1664aedcd468@gmail.com>
 <B962F80F-FF37-4B96-A942-1C78E4D77A1C@fb.com>
 <bb4d491e-324a-a7b0-1e0c-a85d375f1d15@gmail.com>
In-Reply-To: <bb4d491e-324a-a7b0-1e0c-a85d375f1d15@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/10.19.0.190512
x-originating-ip: [2620:10d:c090:200::2:e0dc]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 305907b3-378a-4535-65da-08d6e3b2cb3e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3430;
x-ms-traffictypediagnostic: BYAPR15MB3430:
x-microsoft-antispam-prvs: <BYAPR15MB3430BFB338DC4FEF995888F6A91E0@BYAPR15MB3430.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00514A2FE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(396003)(39860400002)(366004)(189003)(199004)(6486002)(4326008)(256004)(6436002)(478600001)(6116002)(99286004)(110136005)(8676002)(102836004)(82746002)(33656002)(53936002)(71200400001)(71190400001)(54906003)(4744005)(305945005)(83716004)(14454004)(8936002)(5660300002)(36756003)(58126008)(73956011)(76176011)(86362001)(7736002)(446003)(486006)(11346002)(46003)(66446008)(81156014)(81166006)(6506007)(476003)(53546011)(316002)(2616005)(25786009)(6512007)(186003)(2906002)(64756008)(6246003)(76116006)(91956017)(66946007)(66476007)(66556008)(229853002)(68736007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3430;H:BYAPR15MB2311.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +C+iPSp62Wyjy0lqBIpeRefykUTWU1MJbO4YZ8VreQhu1QdCxNt3mEFYEfHZIdL1UAllpm700LYGqGY7Px2wuJszSOtuMRTN/GOT1NuqFgdtWuQ50JvkcEebyJhzl8ypiV2JEBp3/+PF0HgXEGwC6/cWpg0TSV5FQxFWgZYxo96OdqPi8OBRU77F29bQuEjoD6EVBCczaZI/zIYEHR0d/hgBZqSzsofS8cb/lwCvpek+x6OQl4Ij6pOfXi83RxNjIrlNxxda4lrSGj/PYYA/H/wlTwmkmxvgX4x5r2HN7jiRzNDHQYgZJ7OoDSSSX04YkNl0WhMwLAFWlFdvDaLraO+c1EFascV60kVvsLe1ZTqay2Mi3L6J91/1QIeJfKJM5CnPJ+YAoea7yBmdbmCl5N3pTFtZdxFmmgwVINYgepk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D7C7C13051587F47BB14A46040D11C56@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 305907b3-378a-4535-65da-08d6e3b2cb3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2019 21:23:57.1632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: brakmo@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3430
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQrvu79PbiA1LzI4LzE5LCAxOjQzIFBNLCAiRXJpYyBEdW1hemV0IiA8ZXJpYy5kdW1hemV0QGdt
YWlsLmNvbT4gd3JvdGU6DQoNCiAgICAgDQogICAgT24gNS8yOC8xOSAxMTo1NCBBTSwgTGF3cmVu
Y2UgQnJha21vIHdyb3RlOg0KICAgID4gT24gNS8yOC8xOSwgNjo0MyBBTSwgIm5ldGRldi1vd25l
ckB2Z2VyLmtlcm5lbC5vcmcgb24gYmVoYWxmIG9mIEVyaWMgRHVtYXpldCIgPG5ldGRldi1vd25l
ckB2Z2VyLmtlcm5lbC5vcmcgb24gYmVoYWxmIG9mIGVyaWMuZHVtYXpldEBnbWFpbC5jb20+IHdy
b3RlOg0KICAgID4gDQogICAgDQogICAgPiAgICAgV2h5IGFyZSB5b3UgdXNpbmcgcHJlZW1wdF9l
bmFibGVfbm9fcmVzY2hlZCgpIGhlcmUgPw0KICAgID4gDQogICAgPiBCZWNhdXNlIHRoYXQgaXMg
d2hhdCBfX0JQRl9QUk9HX1JVTl9BUlJBWSgpIGNhbGxzIGFuZCB0aGUgbWFjcm8NCiAgICA+IEJQ
Rl9QUk9HX0NHUk9VUF9JTkVUX0VHUkVTU19SVU5fQVJSQVkoKSBpcyBhbiBpbnN0YW50aWF0aW9u
IG9mIGl0DQogICAgPiAod2l0aCBtaW5vciBjaGFuZ2VzIGluIHRoZSByZXR1cm4gdmFsdWUpLg0K
ICAgIA0KICAgIEkgZG8gbm90IHNlZSB0aGlzIGluIG15IHRyZWUuDQogICAgDQogICAgUGxlYXNl
IHJlYmFzZSB5b3VyIHRyZWUsIGRvIG5vdCBicmluZyBiYWNrIGFuIGlzc3VlIHRoYXQgd2FzIHNv
bHZlZCBhbHJlYWR5Lg0KDQpNeSBtaXN0YWtlLiBNeSB0cmVlIGlzIHVwIHRvIGRhdGUsIEkgbG9v
a2VkIGluIHRoZSB3cm9uZyBwbGFjZSBhbmQgZGlkDQpub3QgcmVhbGl6ZWQgdGhlIGNhbGwgaGFk
IGNoYW5nZWQuIEkgd2lsbCBmaXggaXQgYW5kIHJlc3VibWl0IGFnYWluLg0KVGhhbmsgeW91IGZv
ciB0aGUgZmVlZGJhY2suDQogICAgDQogICAgDQogICAgDQogICAgDQoNCg==
