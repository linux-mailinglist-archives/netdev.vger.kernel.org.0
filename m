Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B89B351E0D
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfFXWQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:16:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42228 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725916AbfFXWQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 18:16:40 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5OMCDVQ004402;
        Mon, 24 Jun 2019 15:16:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tby/aH4q1z8VNjhpowdjVrnJ80tibN/nbCyOOu8mnvY=;
 b=hXmx2QfgbPaam6uhyCBQFK+Oa8Y6slFKbAJ+dax/GLJQQ/m7+Qv/ayS38Zw30jC2EZrx
 N2LM0yvN+MsUgSYetQuFsNfctPwYVMQH7LqpwBSXtUbz0g4ue+UGJFHCrBGlGNizFFMI
 JE4ug6d1IXFsw0RA/k1dzxamhXP2vLSGfXA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2tb22xsbay-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 24 Jun 2019 15:16:16 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 24 Jun 2019 15:16:04 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 24 Jun 2019 15:16:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tby/aH4q1z8VNjhpowdjVrnJ80tibN/nbCyOOu8mnvY=;
 b=lmytBSnJc+VJ4T68JXqKDcIPTClOP0bgNt9BxV1kWJiCzqrmiLauPHZt69RlTp/IBiNw2SPZGVtAIMtva2C5Ghte5wkK2x6z7H6gFKzyH4EQJTW3u3KQsEEM5xsIAPunrRlf36zs8jJVqKZIBh1nRu3IkqtF4GJn2Sr30cDY1BU=
Received: from CY4PR15MB1366.namprd15.prod.outlook.com (10.172.157.148) by
 CY4PR15MB1927.namprd15.prod.outlook.com (10.172.79.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 22:16:02 +0000
Received: from CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::90e4:71c9:e7e9:43bb]) by CY4PR15MB1366.namprd15.prod.outlook.com
 ([fe80::90e4:71c9:e7e9:43bb%2]) with mapi id 15.20.2008.017; Mon, 24 Jun 2019
 22:16:02 +0000
From:   Andrey Ignatov <rdna@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Takshak Chahande <ctakshak@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Thread-Topic: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Thread-Index: AQHVKIFqRfJdPomhm0+km9FL+VLNGqaq33qAgAB9YoCAAAbugA==
Date:   Mon, 24 Jun 2019 22:16:02 +0000
Message-ID: <20190624221558.GA41600@rdna-mbp.dhcp.thefacebook.com>
References: <20190621223311.1380295-1-ctakshak@fb.com>
 <6fe292ee-fff0-119c-8524-e25783901167@iogearbox.net>
 <20190624145111.49176d8e@cakuba.netronome.com>
In-Reply-To: <20190624145111.49176d8e@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR16CA0016.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::29) To CY4PR15MB1366.namprd15.prod.outlook.com
 (2603:10b6:903:f7::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:662c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a0799119-19e7-4e52-6f38-08d6f8f18aff
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1927;
x-ms-traffictypediagnostic: CY4PR15MB1927:
x-microsoft-antispam-prvs: <CY4PR15MB1927C09898B6D2C53A26F5E8A8E00@CY4PR15MB1927.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(376002)(396003)(39860400002)(346002)(189003)(199004)(25786009)(66556008)(2906002)(53546011)(86362001)(76176011)(5660300002)(9686003)(6246003)(6916009)(386003)(6436002)(1076003)(478600001)(53936002)(6512007)(6486002)(6506007)(52116002)(229853002)(68736007)(54906003)(46003)(8676002)(81156014)(81166006)(73956011)(6116002)(71190400001)(66946007)(256004)(316002)(71200400001)(8936002)(14454004)(4326008)(5024004)(33656002)(476003)(7736002)(99286004)(446003)(11346002)(64756008)(66476007)(186003)(486006)(305945005)(102836004)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1927;H:CY4PR15MB1366.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PQ0AlIKvygo/7/AvjPk2xcnkggqO9zPFERcPGfIbmF7Uw4u3nGgeeEy+HStOBqvJFuKAGNkW+p8VBW366FM/J/ct90O6ZKlY8vG/DI0UsVwBlBAsXzwFbGPzIgmB3/pUcQEvMmiuVofhGgUjeUUd0VQk06lty2hbYk3kAe5rTbVG8cmkHina7kxO95qOU++XThmuDfN0QLVrnXA4EEmtPTMAR4pkEzPSHcmgyuQ9kG7cwLFBbBPwz7PJSJTEBliGS09QTyAQJxW0Tra+GGrzziKPaots3O845lI/mrZ7BiUUUj74ei3ZSuEn0TYKuj2YKL3EFeY9kv7bvzWDSpnDRL/jcbYfHTU7jjuC0W/qH/CVckkjYInpWwWb77rEVKei+ARR0i0On6AD6HJLszhjTipy6x3+O0LlgJSu3OLVmvY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5EBD93CA37E7941A357EECE901CEC36@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a0799119-19e7-4e52-6f38-08d6f8f18aff
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 22:16:02.6710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rdna@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1927
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=889 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906240175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SmFrdWIgS2ljaW5za2kgPGpha3ViLmtpY2luc2tpQG5ldHJvbm9tZS5jb20+IFtNb24sIDIwMTkt
MDYtMjQgMTQ6NTEgLTA3MDBdOg0KPiBPbiBNb24sIDI0IEp1biAyMDE5IDE2OjIyOjI1ICswMjAw
LCBEYW5pZWwgQm9ya21hbm4gd3JvdGU6DQo+ID4gT24gMDYvMjIvMjAxOSAxMjozMyBBTSwgVGFr
c2hhayBDaGFoYW5kZSB3cm90ZToNCj4gPiA+IFdpdGggZGlmZmVyZW50IGJwZiBhdHRhY2hfZmxh
Z3MgYXZhaWxhYmxlIHRvIGF0dGFjaCBicGYgcHJvZ3JhbXMgc3BlY2lhbGx5DQo+ID4gPiB3aXRo
IEJQRl9GX0FMTE9XX09WRVJSSURFIGFuZCBCUEZfRl9BTExPV19NVUxUSSwgdGhlIGxpc3Qgb2Yg
ZWZmZWN0aXZlDQo+ID4gPiBicGYtcHJvZ3JhbXMgYXZhaWxhYmxlIHRvIGFueSBzdWItY2dyb3Vw
cyByZWFsbHkgbmVlZHMgdG8gYmUgYXZhaWxhYmxlIGZvcg0KPiA+ID4gZWFzeSBkZWJ1Z2dpbmcu
DQo+ID4gPiANCj4gPiA+IFVzaW5nIEJQRl9GX1FVRVJZX0VGRkVDVElWRSBmbGFnLCBvbmUgY2Fu
IGdldCB0aGUgbGlzdCBvZiBub3Qgb25seSBhdHRhY2hlZA0KPiA+ID4gYnBmLXByb2dyYW1zIHRv
IGEgY2dyb3VwIGJ1dCBhbHNvIHRoZSBpbmhlcml0ZWQgb25lcyBmcm9tIHBhcmVudCBjZ3JvdXAu
DQo+ID4gPiANCj4gPiA+IFNvICItZSIgb3B0aW9uIGlzIGludHJvZHVjZWQgdG8gdXNlIEJQRl9G
X1FVRVJZX0VGRkVDVElWRSBxdWVyeSBmbGFnIGhlcmUgdG8NCj4gPiA+IGxpc3QgYWxsIHRoZSBl
ZmZlY3RpdmUgYnBmLXByb2dyYW1zIGF2YWlsYWJsZSBmb3IgZXhlY3V0aW9uIGF0IGEgc3BlY2lm
aWVkDQo+ID4gPiBjZ3JvdXAuDQo+ID4gPiANCj4gPiA+IFJldXNlZCBtb2RpZmllZCB0ZXN0IHBy
b2dyYW0gdGVzdF9jZ3JvdXBfYXR0YWNoIGZyb20gdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBm
Og0KPiA+ID4gICAjIC4vdGVzdF9jZ3JvdXBfYXR0YWNoDQo+ID4gPiANCj4gPiA+IFdpdGggb2xk
IGJwZnRvb2wgKHdpdGhvdXQgLWUgb3B0aW9uKToNCj4gPiA+IA0KPiA+ID4gICAjIGJwZnRvb2wg
Y2dyb3VwIHNob3cgL3N5cy9mcy9jZ3JvdXAvY2dyb3VwLXRlc3Qtd29yay1kaXIvY2cxLw0KPiA+
ID4gICBJRCAgICAgICBBdHRhY2hUeXBlICAgICAgQXR0YWNoRmxhZ3MgICAgIE5hbWUNCj4gPiA+
ICAgMjcxICAgICAgZWdyZXNzICAgICAgICAgIG11bHRpICAgICAgICAgICBwa3RfY250cl8xDQo+
ID4gPiAgIDI3MiAgICAgIGVncmVzcyAgICAgICAgICBtdWx0aSAgICAgICAgICAgcGt0X2NudHJf
Mg0KPiA+ID4gDQo+ID4gPiAgIEF0dGFjaGVkIG5ldyBwcm9ncmFtIHBrdF9jbnRyXzQgaW4gY2cy
IGdpdmVzIGZvbGxvd2luZzoNCj4gPiA+IA0KPiA+ID4gICAjIGJwZnRvb2wgY2dyb3VwIHNob3cg
L3N5cy9mcy9jZ3JvdXAvY2dyb3VwLXRlc3Qtd29yay1kaXIvY2cxL2NnMg0KPiA+ID4gICBJRCAg
ICAgICBBdHRhY2hUeXBlICAgICAgQXR0YWNoRmxhZ3MgICAgIE5hbWUNCj4gPiA+ICAgMjczICAg
ICAgZWdyZXNzICAgICAgICAgIG92ZXJyaWRlICAgICAgICBwa3RfY250cl80DQo+ID4gPiANCj4g
PiA+IEFuZCB3aXRoIG5ldyAiLWUiIG9wdGlvbiBpdCBzaG93cyBhbGwgZWZmZWN0aXZlIHByb2dy
YW1zIGZvciBjZzI6DQo+ID4gPiANCj4gPiA+ICAgIyBicGZ0b29sIC1lIGNncm91cCBzaG93IC9z
eXMvZnMvY2dyb3VwL2Nncm91cC10ZXN0LXdvcmstZGlyL2NnMS9jZzINCj4gPiA+ICAgSUQgICAg
ICAgQXR0YWNoVHlwZSAgICAgIEF0dGFjaEZsYWdzICAgICBOYW1lDQo+ID4gPiAgIDI3MyAgICAg
IGVncmVzcyAgICAgICAgICBvdmVycmlkZSAgICAgICAgcGt0X2NudHJfNA0KPiA+ID4gICAyNzEg
ICAgICBlZ3Jlc3MgICAgICAgICAgb3ZlcnJpZGUgICAgICAgIHBrdF9jbnRyXzENCj4gPiA+ICAg
MjcyICAgICAgZWdyZXNzICAgICAgICAgIG92ZXJyaWRlICAgICAgICBwa3RfY250cl8yDQo+ID4g
PiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFRha3NoYWsgQ2hhaGFuZGUgPGN0YWtzaGFrQGZiLmNv
bT4NCj4gPiA+IEFja2VkLWJ5OiBBbmRyZXkgSWduYXRvdiA8cmRuYUBmYi5jb20+ICANCj4gPiAN
Cj4gPiBBcHBsaWVkLCB0aGFua3MhDQo+IA0KPiBUaGlzIGlzIGEgY2dyb3VwLXNwZWNpZmljIGZs
YWcsIHJpZ2h0PyAgSXQgc2hvdWxkIGJlIGEgcGFyYW1ldGVyIA0KPiB0byBjZ3JvdXAgc2hvdywg
bm90IGEgZ2xvYmFsIGZsYWcuICBDYW4gd2UgcGxlYXNlIGRyb3AgdGhpcyBwYXRjaCANCj4gZnJv
bSB0aGUgdHJlZT8NCg0KSGV5IEpha3ViLA0KDQpJIGhhZCBzYW1lIHRob3VnaHQgYWJvdXQgY2dy
b3VwLXNwZWNpZmljIGZsYWcgd2hpbGUgcmV2aWV3aW5nIHRoZSBwYXRjaCwNCmJ1dCB0aGVuIGZv
dW5kIG91dCB0aGF0IGFsbCBmbGFncyBpbiBicGZ0b29sIGFyZSBub3cgZ2xvYmFsLCBubyBtYXRl
ciBpZg0KdGhleSdyZSBzdWItY29tbWFuZC1zcGVjaWZpYyBvciBub3QuDQoNCkZvciBleGFtcGxl
LCAtLW1hcGNvbXBhdCBpcyB1c2VkIG9ubHkgaW4gcHJvZy1zdWJjb21tYW5kLCBidXQgdGhlIG9w
dGlvbg0KaXMgZ2xvYmFsOyAtLWJwZmZzIGlzIHVzZWQgaW4gcHJvZy0gYW5kIG1hcC1zdWJjb21t
YW5kcywgYnV0IHRoZSBvcHRpb24NCmlzIGdsb2JhbCBhcyB3ZWxsLCBldGMgKHRoZXJlIGFyZSBt
b3JlIGV4YW1wbGVzKS4NCg0KSSBhZ3JlZSB0aGF0IGxpbWl0aW5nIHRoZSBzY29wZSBvZiBhbiBv
cHRpb24gaXMgYSBnb29kIGlkZWEgaW4gdGhlIGxvbmcNCnRlcm0gYW5kIGl0J2QgYmUgZ3JlYXQg
dG8gcmV3b3JrIGFsbCBleGlzdGluZyBvcHRpb25zIHRvIGJlIGF2YWlsYWJsZQ0Kb25seSBmb3Ig
Y29ycmVzcG9uZGluZyBzdWItY29tbWFuZHMsIGJ1dCBJIGRvbid0IHNlZSBob3cgdGhlIG5ldyBg
LWVgDQpvcHRpb25zIGlzIGRpZmZlcmVudCBmcm9tIGV4aXN0aW5nIG9wdGlvbnMgYW5kIHdoeSBp
dCBzaG91bGQgYmUgZHJvcHBlZC4NCg0KT3IgeW91IHdlcmUgY291bmZ1c2VkIGJ5IHRoZSBleGFt
cGxlIGluIHRoZSBjb21taXQgbG9nPyBTaW5jZSBhbGwNCm9wdGlvbnMgYXJlIGdsb2JhbCB0aGV5
IGNhbiBiZSBzcGVjaWZpYyBhbnl3aGVyZSBvbiB0aGUgY29tbWFuZCBsaW5lLA0KaS5lLiBpbnN0
ZWFkIG9mOg0KICAjIGJwZnRvb2wgLWUgY2dyb3VwIHNob3cgL3BhdGgvdG8vY2dyb3VwDQoNCml0
IGNhbiBiZToNCiAgIyBicGZ0b29sIGNncm91cCBzaG93IC1lIC9wYXRoL3RvL2Nncm91cA0KDQoN
Ci0tIA0KQW5kcmV5IElnbmF0b3YNCg==
