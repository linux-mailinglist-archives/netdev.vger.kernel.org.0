Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C604B13297
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 18:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbfECQ4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 12:56:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43736 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726289AbfECQ4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 12:56:42 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x43GoK1g026004;
        Fri, 3 May 2019 09:56:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=Bqub1FOrse2aWjsw6Y80GpTwC2df4Twuz56HK/Nymck=;
 b=lSGTG3JpMUW/+VS2nbmJQOko+r0bY5+kzcfqZlmgs1rG555p/lzZP11Qvi/tkmNIlTqz
 0k0NxtxvyU9ReavTDC5PjtOqRr+BQiJ/97jJaQ/Cb7qTAbviamTTPn9wjr2fmTOKiuac
 +d4ajMouHGk4eiMWKAdoj/kIChz1RvaftBo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2s86r1k49v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 03 May 2019 09:56:23 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 3 May 2019 09:56:22 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 3 May 2019 09:56:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bqub1FOrse2aWjsw6Y80GpTwC2df4Twuz56HK/Nymck=;
 b=jHEXnEGkaiQzY71jAf2SXK3jiVHSGHWUvIFLziZ2wPx6CwtqUiwmsum2gxCqGtsvqbsdVb3Rk6KIbiGySgj+O+dqa8OTnZyDm9LYjoUd06/+NHLqw2SiVgBCvi5yCd7K912NtnptXgCWw/bG35hxUtH+Ct3vr0v4GD0QXKz3uZ0=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3013.namprd15.prod.outlook.com (20.178.238.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Fri, 3 May 2019 16:56:20 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::750c:2d8e:bf62:4d0d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::750c:2d8e:bf62:4d0d%5]) with mapi id 15.20.1856.008; Fri, 3 May 2019
 16:56:20 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>,
        netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: bpftool doc man page build failure
Thread-Topic: bpftool doc man page build failure
Thread-Index: AQHVAcxB+ZLo09PUHkCRkk5C26pzvKZZnjuAgAAAbQA=
Date:   Fri, 3 May 2019 16:56:20 +0000
Message-ID: <4223a383-7731-0a4d-d807-1141b6fcbea8@fb.com>
References: <d84c162f-9ccf-18f5-6d99-d7c88eb61a89@fb.com>
 <1a2c2f20-ede9-61ae-564a-d44843983f73@netronome.com>
In-Reply-To: <1a2c2f20-ede9-61ae-564a-d44843983f73@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:104:3::16) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:35ed]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17e64f32-3685-4788-b320-08d6cfe8442e
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR15MB3013;
x-ms-traffictypediagnostic: BYAPR15MB3013:
x-microsoft-antispam-prvs: <BYAPR15MB3013780E35C46111CDAC0A79D3350@BYAPR15MB3013.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0026334A56
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(39860400002)(396003)(346002)(136003)(366004)(199004)(189003)(51914003)(478600001)(2501003)(14454004)(305945005)(66556008)(386003)(2906002)(66476007)(31696002)(7736002)(73956011)(446003)(2616005)(316002)(64756008)(46003)(476003)(11346002)(486006)(6116002)(8676002)(66446008)(66946007)(14444005)(8936002)(186003)(36756003)(6506007)(102836004)(76176011)(229853002)(31686004)(6486002)(53546011)(25786009)(81156014)(99286004)(81166006)(71190400001)(52116002)(6512007)(71200400001)(53936002)(5660300002)(86362001)(68736007)(6246003)(110136005)(6436002)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3013;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EF4HiCdBOFMETXQR2zfGoQ1AxtPcj+RICQihRJX7i5TCpaDGR48yiTZNagH5+0w506kGnCNhd5PtkQosDk3blBpVa4wAIyriNhmbkS4YvtAQ6++u2Jtzzq9W/QDU3JJj+ezdUSA4yT3hY1BxPpyzeZfVuOR+T3YbQK7MO2guhe6J72WQfNVc+1GHAbolrHddw3xyMMxoQ8IvO8Klb7SSjYioKDfYM6tLLgfOwZ4sRHmaLcuO5mV1BirRTf47At/8RB4alYINgDEQ/4TwcorJAnHmpkefTAtqi6mTeQ7IGIG+po671/4rDPdDCXhUdqlGhSKGUQ09V/4+MvOxuoAJDKZ+k9gvy7Do50UFshlvbgrThGahMeQjXIrZbH2pMejqWmkbuLzGRB4fIiPsMV57uTNUvoPiMbR08yrqHTcaRzY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36784B0BF0BDE946A6EFDBA42D68B448@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 17e64f32-3685-4788-b320-08d6cfe8442e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2019 16:56:20.5949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3013
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-03_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=813 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905030108
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMy8xOSA5OjU0IEFNLCBRdWVudGluIE1vbm5ldCB3cm90ZToNCj4gMjAxOS0wNS0w
MyAxNjoyMSBVVEMrMDAwMCB+IFlvbmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo+PiBRdWVudGlu
LA0KPj4NCj4+IEkgaGl0IHRoZSBmb2xsb3dpbmcgZXJyb3JzIHdpdGggbGF0ZXN0IGJwZi1uZXh0
Lg0KPj4NCj4+IC1iYXNoLTQuNCQgbWFrZSBtYW4NCj4+ICAgICBHRU4gICAgICBicGZ0b29sLXBl
cmYuOA0KPj4gICAgIEdFTiAgICAgIGJwZnRvb2wtbWFwLjgNCj4+ICAgICBHRU4gICAgICBicGZ0
b29sLjgNCj4+ICAgICBHRU4gICAgICBicGZ0b29sLW5ldC44DQo+PiAgICAgR0VOICAgICAgYnBm
dG9vbC1mZWF0dXJlLjgNCj4+ICAgICBHRU4gICAgICBicGZ0b29sLXByb2cuOA0KPj4gICAgIEdF
TiAgICAgIGJwZnRvb2wtY2dyb3VwLjgNCj4+ICAgICBHRU4gICAgICBicGZ0b29sLWJ0Zi44DQo+
PiAgICAgR0VOICAgICAgYnBmLWhlbHBlcnMucnN0DQo+PiBQYXJzZWQgZGVzY3JpcHRpb24gb2Yg
MTExIGhlbHBlciBmdW5jdGlvbihzKQ0KPj4gVHJhY2ViYWNrIChtb3N0IHJlY2VudCBjYWxsIGxh
c3QpOg0KPj4gICAgIEZpbGUgIi4uLy4uLy4uLy4uL3NjcmlwdHMvYnBmX2hlbHBlcnNfZG9jLnB5
IiwgbGluZSA0MjEsIGluIDxtb2R1bGU+DQo+PiAgICAgICBwcmludGVyLnByaW50X2FsbCgpDQo+
PiAgICAgRmlsZSAiLi4vLi4vLi4vLi4vc2NyaXB0cy9icGZfaGVscGVyc19kb2MucHkiLCBsaW5l
IDE4NywgaW4gcHJpbnRfYWxsDQo+PiAgICAgICBzZWxmLnByaW50X29uZShoZWxwZXIpDQo+PiAg
ICAgRmlsZSAiLi4vLi4vLi4vLi4vc2NyaXB0cy9icGZfaGVscGVyc19kb2MucHkiLCBsaW5lIDM3
OCwgaW4gcHJpbnRfb25lDQo+PiAgICAgICBzZWxmLnByaW50X3Byb3RvKGhlbHBlcikNCj4+ICAg
ICBGaWxlICIuLi8uLi8uLi8uLi9zY3JpcHRzL2JwZl9oZWxwZXJzX2RvYy5weSIsIGxpbmUgMzU2
LCBpbiBwcmludF9wcm90bw0KPj4gICAgICAgcHJvdG8gPSBoZWxwZXIucHJvdG9fYnJlYWtfZG93
bigpDQo+PiAgICAgRmlsZSAiLi4vLi4vLi4vLi4vc2NyaXB0cy9icGZfaGVscGVyc19kb2MucHki
LCBsaW5lIDU2LCBpbg0KPj4gcHJvdG9fYnJlYWtfZG93bg0KPj4gICAgICAgJ3R5cGUnIDogY2Fw
dHVyZS5ncm91cCgxKSwNCj4+IEF0dHJpYnV0ZUVycm9yOiAnTm9uZVR5cGUnIG9iamVjdCBoYXMg
bm8gYXR0cmlidXRlICdncm91cCcNCj4+IG1ha2U6ICoqKiBbYnBmLWhlbHBlcnMucnN0XSBFcnJv
ciAxDQo+PiAtYmFzaC00LjQkIHB3ZA0KPj4gL2hvbWUveWhzL3dvcmsvbmV0LW5leHQvdG9vbHMv
YnBmL2JwZnRvb2wvRG9jdW1lbnRhdGlvbg0KPj4gLWJhc2gtNC40JA0KPj4NCj4+IE1heWJlIGEg
Zm9ybWF0IGlzc3VlIGluIHRoZSBjb21tZW50cyB3aXRoIHNvbWUgcmVjZW50IGhlbHBlcnM/DQo+
Pg0KPj4gVGhhbmtzLA0KPj4NCj4+IFlvbmdob25nDQo+Pg0KPiANCj4gSGkgWW9uZ2hvbmcsDQo+
IA0KPiBUaGFua3MgZm9yIHRoZSBub3RpY2UhIFllcywgSSBvYnNlcnZlZCB0aGUgc2FtZSB0aGlu
ZyBub3QgbG9uZyBhZ28uIEl0DQo+IHNlZW1zIHRoYXQgdGhlIFB5dGhvbiBzY3JpcHQgYnJlYWtz
IG9uIHRoZSAidW5zaWduZWQgbG9uZyIgcG9pbnRlcg0KPiBhcmd1bWVudCBmb3Igc3RydG91bCgp
OiB0aGUgc2NyaXB0IG9ubHkgYWNjZXB0cyAiY29uc3QiIG9yICJzdHJ1Y3QiIGZvcg0KPiB0eXBl
cyBtYWRlIG9mIHNldmVyYWwgd29yZHMsIG5vdCAidW5zaWduZWQiLg0KPiANCj4gSSdsbCBmaXgg
dGhlIHNjcmlwdCBzbyBpdCBjYW4gdGFrZSBhbnkgd29yZCBhbmQgc2VuZCBhIHBhdGNoIG5leHQg
d2VlaywNCj4gYWxvbmcgd2l0aCBzb21lIG90aGVyIGNsZWFuLXVwIGZpeGVzIGZvciB0aGUgZG9j
Lg0KDQpUaGFua3MhDQoNCj4gDQo+IEJlc3QgcmVnYXJkcywNCj4gUXVlbnRpbg0KPiANCg==
