Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB4CC51FDD
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 02:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728582AbfFYAW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 20:22:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49462 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727736AbfFYAW2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 20:22:28 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5P08dTY018663;
        Mon, 24 Jun 2019 17:22:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=70P73znTU/9UuTbL6dU0mx21OjMmeBw3uJjvj5DXqfc=;
 b=kF5C4BmEL+0Y9vYTgHv6gWriPrfMJl/rbJRbUeDyUrdf+S9uNxxnrPyDPBKyppumogJj
 ZPfLkUC7UPX81UwidABIAOHzhtrevgI3E54RsqHDiBpYbhOx0jVr15etB68M1qo4Fn9Z
 uFSjl6U/BSwn1MQqohJyXM3CC6bNHPuct7U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tb3v017fx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 24 Jun 2019 17:22:03 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Jun 2019 17:21:59 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 24 Jun 2019 17:21:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70P73znTU/9UuTbL6dU0mx21OjMmeBw3uJjvj5DXqfc=;
 b=Yw3ysO8tpE+6XEOQ+GVCdnFqTDGYsCfWGMek67Wm2N5xlOcsfCeDQpeJpH6uKlmKz3ntjvOwNsjqmik9fE7lpOTr4qKq330WoHf6s5kVe3X2wdj9/Ek5EATksdRvmlFUiqysee2318Im7dOH4juWJRgcgZ1Dxg3lux0izf3ppxg=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2808.namprd15.prod.outlook.com (20.179.158.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 00:21:57 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::60a3:8bdd:1ea2:3702%7]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 00:21:57 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Andrey Ignatov <rdna@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Takshak Chahande <ctakshak@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Thread-Topic: [PATCH bpf-next] bpftool: Add BPF_F_QUERY_EFFECTIVE support in
 bpftool cgroup [show|tree]
Thread-Index: AQHVKIFy6hPwND0Mwky2apMHopnX+aaq33qAgAB9YoCAAAbxAIAAB5SAgAAPW4CAAArHgIAAAXUA
Date:   Tue, 25 Jun 2019 00:21:57 +0000
Message-ID: <6d44d265-7133-d191-beeb-c22dde73993f@fb.com>
References: <20190621223311.1380295-1-ctakshak@fb.com>
 <6fe292ee-fff0-119c-8524-e25783901167@iogearbox.net>
 <20190624145111.49176d8e@cakuba.netronome.com>
 <20190624221558.GA41600@rdna-mbp.dhcp.thefacebook.com>
 <20190624154309.5ef3357b@cakuba.netronome.com>
 <97b13eb6-43fb-8ee9-117d-a68f9825b866@fb.com>
 <20190624171641.73cd197d@cakuba.netronome.com>
In-Reply-To: <20190624171641.73cd197d@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0070.namprd16.prod.outlook.com
 (2603:10b6:907:1::47) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:d5ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e447be9e-147c-4524-a366-08d6f9032224
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2808;
x-ms-traffictypediagnostic: BYAPR15MB2808:
x-microsoft-antispam-prvs: <BYAPR15MB28083A2D3A832FEF6DF13F96D7E30@BYAPR15MB2808.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(396003)(366004)(39860400002)(199004)(189003)(316002)(66476007)(478600001)(305945005)(86362001)(7736002)(66556008)(71190400001)(71200400001)(54906003)(6916009)(8936002)(66446008)(81166006)(8676002)(81156014)(229853002)(99286004)(4744005)(6486002)(64756008)(68736007)(5660300002)(52116002)(76176011)(386003)(31686004)(53546011)(6506007)(186003)(6116002)(102836004)(2906002)(73956011)(25786009)(66946007)(31696002)(6436002)(14454004)(4326008)(476003)(2616005)(11346002)(486006)(6512007)(6246003)(446003)(46003)(36756003)(256004)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2808;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xCSIl6tpuNgDxcfrRk9qT/1ibAsOOXSwMgipFxiyWf0kKltltgEvtv1OOzu5IeIwpGGae3OQMKLGpHqBuSaJKiur56M9IX9gx678cjopcOjjYtCH0wp9KrCm1TGQsrLFbUrUnjz3jS9bMxaxFvWgtv0M3PRvSmamLobsE6y1tNhTSeLi2dcxqnQXIunbwENJbwA01fsEBHQzVXIvZBhXWzZI4QyKvMXXWc0OmbxoByalnbIGgzy7l/lJXg6wfSFoHC00o/mdo39O8WhjesuVEYr5iwKhRui7MeO5dKdK8Os1Imkvnm29HTUX7qg/4v+IP/iqSR10gUMKkxIIQHfR1VFHBZnpH+dZT7gQ9KnD+0dNjxHPKs7cOdRpblrncntAoDWhE4S8mdGi8E6HvmZ3SM6Pv2SCncqeBy4D6TsE2ho=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BDCB886823AEAB4D8C942C0949B035F8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e447be9e-147c-4524-a366-08d6f9032224
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 00:21:57.7115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2808
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-24_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=818 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906250000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8yNC8xOSA1OjE2IFBNLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gT24gTW9uLCAyNCBK
dW4gMjAxOSAyMzozODoxMSArMDAwMCwgQWxleGVpIFN0YXJvdm9pdG92IHdyb3RlOg0KPj4gSSBk
b24ndCB0aGluayB0aGlzIHBhdGNoIHNob3VsZCBiZSBwZW5hbGl6ZWQuDQo+PiBJJ2QgcmF0aGVy
IHNlZSB3ZSBmaXggdGhlbSBhbGwuDQo+IA0KPiBTbyB3ZSBhcmUgZ29pbmcgdG8gYWRkIHRoaXMg
YnJva2VuIG9wdGlvbiBqdXN0IHRvIHJlbW92ZSBpdD8NCj4gSSBkb24ndCB1bmRlcnN0YW5kLg0K
PiBJJ20gaGFwcHkgdG8gc3BlbmQgdGhlIDE1IG1pbnV0ZXMgcmV3cml0aW5nIHRoaXMgaWYgeW91
IGRvbid0DQo+IHdhbnQgdG8gcGVuYWxpemUgVGFrc2hhay4NCg0KaG1tLiBJIGRvbid0IHVuZGVy
c3RhbmQgdGhlICdicm9rZW4nIHBhcnQuDQpUaGUgb25seSBpc3N1ZSBJIHNlZSB0aGF0IGl0IGNv
dWxkIGhhdmUgYmVlbiBsb2NhbCB2cyBnbG9iYWwsDQpidXQgdGhleSBhbGwgc2hvdWxkIGhhdmUg
YmVlbiBsb2NhbC4NCg0KDQo=
