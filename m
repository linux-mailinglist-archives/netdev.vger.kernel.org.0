Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75AB185980
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 06:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbfHHEvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 00:51:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45416 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbfHHEvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 00:51:32 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x784mAl7018664;
        Wed, 7 Aug 2019 21:51:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4Y5NEKMXHJP2OuSX2OMWJWArNFM5n9NjRtz7YtLdpsM=;
 b=BJi30jtyaFg3WZV2EE6IVSXSW9jvIFcT8KQjDAFchh+WYnUs+msVM5vh27GT0CnleBmA
 RHhs0yVY2i1JuAWycG7+VN/LK0F7pxWUmugedxhvpxjxSAOI82eOSbgh9d8YZtppz3Iv
 /Bz1oHdjLKJQefbq4mDqmlm8lKh13zx3LO4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u87ugrubs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 07 Aug 2019 21:51:18 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 7 Aug 2019 21:51:17 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 7 Aug 2019 21:51:17 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Aug 2019 21:51:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0EY13srKhjB+i+I0JZsXMfI8953JWCed8binJ+eXKVxMqDjGfjVHsBz9m3fGgoopYE8KLA4yV4EFm+QzZMWFAvAUqi8K228GoNbqGmQuHBY1CAJQV0B/wYVbvCPfl1zYJiFHeCj1psWtK8D+kG6Lcpul8GBjeTIl/eq9OiAYhkuHZrCH7pWvwL/l0+33NBr4AVxsP4JvoulaBUo2Zb2rqftPrlb9ZqHwMyzfwY/ZJoYfLswhXjwPGQY78ctwaqwIeEO7ZYXGAXwrj52B8Fn1wiU6P07w2zT5WtIvXkLasEpa++qQb4Rhxr4rjoRyf41tJ1iR4VDwON5tBl2W7bEhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Y5NEKMXHJP2OuSX2OMWJWArNFM5n9NjRtz7YtLdpsM=;
 b=RFl6LgoKPY/BwcS3pmfnsVUvIPrLL2SObVvNTTmRfbj7IQahoY5/grwge5uG+JuirO5cPEvJzSRNTExIRCWEvTHlm5rXxJVmwyS9u8Z7m0SE2NepEEQpsWJJDemMeVyJP57fPBvVvlBBCM/mJDDnDeNFRsihZH76yPl5Wmius5okyAZW/DOirm93/j7Tl7Y7gX5MLW0wxgivK6v9DyRCGujsJZY3dutIJNLA+SHGn1wv4FWrnmmYdFQhXu5IYpwNexvmyqpLyVdG+O1n+RA17UITEXuclOOMIsfzyra6L+pz6I2UwRY/dZtRogGkVbuWk0EAihn/jbiagEehUQZhqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Y5NEKMXHJP2OuSX2OMWJWArNFM5n9NjRtz7YtLdpsM=;
 b=j22I0Hk6nElYXmBFQ1pWeBrAooKSk+8+g80O2xWKBgup+9N2a2IjjwCRySPJSlmIK0zdji1jbCyd1MugKxFddG28zOZxuAKLzjUunw5GUPCEcWrOd866aB3t6LtOhVdbHj+pLL5CuxzCrzvwbB+DEBsz5qfFcul5Q5Swb/CL7GY=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1325.namprd15.prod.outlook.com (10.175.5.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Thu, 8 Aug 2019 04:51:16 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.011; Thu, 8 Aug 2019
 04:51:16 +0000
From:   Tao Ren <taoren@fb.com>
To:     Vijay Khemka <vijaykhemka@fb.com>,
        Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        William Kennington <wak@google.com>,
        Joel Stanley <joel@jms.id.au>
Subject: Re: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Thread-Topic: [PATCH net-next] net/ncsi: allow to customize BMC MAC Address
 offset
Thread-Index: AQHVTUaw7KvSLDhTGEGo9NvmPIPC2Kbwr0IA
Date:   Thu, 8 Aug 2019 04:51:16 +0000
Message-ID: <963cfe0f-521e-c687-dcb7-37ae5bef8eec@fb.com>
References: <75DDAF9A-DABC-4670-BEC0-320185017642@fb.com>
In-Reply-To: <75DDAF9A-DABC-4670-BEC0-320185017642@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0053.namprd22.prod.outlook.com
 (2603:10b6:301:16::27) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::f857]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1490f5f-218d-4e24-bf1d-08d71bbc0baa
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1325;
x-ms-traffictypediagnostic: MWHPR15MB1325:
x-microsoft-antispam-prvs: <MWHPR15MB1325FB13390916520396FD67B2D70@MWHPR15MB1325.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1284;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(376002)(39860400002)(366004)(396003)(199004)(189003)(8936002)(186003)(446003)(25786009)(53936002)(6512007)(36756003)(486006)(6486002)(11346002)(81156014)(2616005)(66476007)(6116002)(66946007)(66446008)(66556008)(64126003)(2906002)(5660300002)(64756008)(46003)(31696002)(86362001)(65826007)(102836004)(229853002)(305945005)(71200400001)(71190400001)(65806001)(478600001)(2201001)(58126008)(65956001)(476003)(2501003)(316002)(81166006)(256004)(110136005)(7736002)(76176011)(53546011)(8676002)(6246003)(6506007)(99286004)(52116002)(386003)(31686004)(14444005)(14454004)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1325;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: h1Kc44JUZWhPUKnvsE3LVUFcYaDKy1tVU1KhHmAPcqfuePO30/aHuLN6ockDAsFDL/AyEdXKGBESs87pw637IEGbiAYsmUNAQhUYgiG+ltnfKXK0WOj9laehkmkuc1NI8zzmVH2ArUoIlpk6fBuw37P7vhkrNng4TzMC9mR1n/kJR8z8xQMdCJFyqsaZRv2COPJ1W4FElh1oxJ62JKo/Cm8hivOMGocfNOmcbkzF10h7cjeVl71u3r+nZ40R7JFEybWncKJH4ogBUbC0vYBO5FZ7AqgYRfxehoJPWK1lVsjwlKRzHccqm6ltl1N1U8J1iGeorO6NQA2SPF0rlsGh4eQR6rYdvs/zs1hi5sSblhwRAsTB+lQq94Fl5EvH+c3RuFqUwL3dSzC19+ztethrlsLdg/K8tfFmHP3+RLTQVY0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2401785C2CCFB74EA67935A83BEA5CEA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a1490f5f-218d-4e24-bf1d-08d71bbc0baa
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 04:51:16.1764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nd36dkOy7oe/K/YnECsykGRxeQNsEn3hiqLaK96Eqx2xTN2A6Jg9AiTFFVL7qQ4N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1325
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-08_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908080052
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC83LzE5IDEwOjM2IEFNLCBWaWpheSBLaGVta2Egd3JvdGU6DQo+IExndG0gZXhjZXB0IG9u
ZSBzbWFsbCBjb21tZW50IGJlbG93Lg0KPiANCj4g77u/T24gOC82LzE5LCA1OjIyIFBNLCAib3Bl
bmJtYyBvbiBiZWhhbGYgb2YgVGFvIFJlbiIgPG9wZW5ibWMtYm91bmNlcyt2aWpheWtoZW1rYT1m
Yi5jb21AbGlzdHMub3psYWJzLm9yZyBvbiBiZWhhbGYgb2YgdGFvcmVuQGZiLmNvbT4gd3JvdGU6
DQo+IA0KPiAgICAgQ3VycmVudGx5IEJNQydzIE1BQyBhZGRyZXNzIGlzIGNhbGN1bGF0ZWQgYnkg
YWRkaW5nIDEgdG8gTkNTSSBOSUMncyBiYXNlDQo+ICAgICBNQUMgYWRkcmVzcyB3aGVuIENPTkZJ
R19OQ1NJX09FTV9DTURfR0VUX01BQyBvcHRpb24gaXMgZW5hYmxlZC4gVGhlIGxvZ2ljDQo+ICAg
ICBkb2Vzbid0IHdvcmsgZm9yIHBsYXRmb3JtcyB3aXRoIGRpZmZlcmVudCBCTUMgTUFDIG9mZnNl
dDogZm9yIGV4YW1wbGUsDQo+ICAgICBGYWNlYm9vayBZYW1wIEJNQydzIE1BQyBhZGRyZXNzIGlz
IGNhbGN1bGF0ZWQgYnkgYWRkaW5nIDIgdG8gTklDJ3MgYmFzZQ0KPiAgICAgTUFDIGFkZHJlc3Mg
KCJCYXNlTUFDICsgMSIgaXMgcmVzZXJ2ZWQgZm9yIEhvc3QgdXNlKS4NCj4gICAgIA0KPiAgICAg
VGhpcyBwYXRjaCBhZGRzIE5FVF9OQ1NJX01DX01BQ19PRkZTRVQgY29uZmlnIG9wdGlvbiB0byBj
dXN0b21pemUgb2Zmc2V0DQo+ICAgICBiZXR3ZWVuIE5JQydzIEJhc2UgTUFDIGFkZHJlc3MgYW5k
IEJNQydzIE1BQyBhZGRyZXNzLiBJdHMgZGVmYXVsdCB2YWx1ZSBpcw0KPiAgICAgc2V0IHRvIDEg
dG8gYXZvaWQgYnJlYWtpbmcgZXhpc3RpbmcgdXNlcnMuDQo+ICAgICANCj4gICAgIFNpZ25lZC1v
ZmYtYnk6IFRhbyBSZW4gPHRhb3JlbkBmYi5jb20+DQo+ICAgICAtLS0NCj4gICAgICBuZXQvbmNz
aS9LY29uZmlnICAgIHwgIDggKysrKysrKysNCj4gICAgICBuZXQvbmNzaS9uY3NpLXJzcC5jIHwg
MTUgKysrKysrKysrKysrKy0tDQo+ICAgICAgMiBmaWxlcyBjaGFuZ2VkLCAyMSBpbnNlcnRpb25z
KCspLCAyIGRlbGV0aW9ucygtKQ0KPiAgICAgDQo+ICAgICBkaWZmIC0tZ2l0IGEvbmV0L25jc2kv
S2NvbmZpZyBiL25ldC9uY3NpL0tjb25maWcNCj4gICAgIGluZGV4IDJmMWU1NzU2YzAzYS4uYmU4
ZWZlMWVkOTllIDEwMDY0NA0KPiAgICAgLS0tIGEvbmV0L25jc2kvS2NvbmZpZw0KPiAgICAgKysr
IGIvbmV0L25jc2kvS2NvbmZpZw0KPiAgICAgQEAgLTE3LDMgKzE3LDExIEBAIGNvbmZpZyBOQ1NJ
X09FTV9DTURfR0VUX01BQw0KPiAgICAgIAktLS1oZWxwLS0tDQo+ICAgICAgCSAgVGhpcyBhbGxv
d3MgdG8gZ2V0IE1BQyBhZGRyZXNzIGZyb20gTkNTSSBmaXJtd2FyZSBhbmQgc2V0IHRoZW0gYmFj
ayB0bw0KPiAgICAgIAkJY29udHJvbGxlci4NCj4gICAgICtjb25maWcgTkVUX05DU0lfTUNfTUFD
X09GRlNFVA0KPiAgICAgKwlpbnQNCj4gICAgICsJcHJvbXB0ICJPZmZzZXQgb2YgTWFuYWdlbWVu
dCBDb250cm9sbGVyJ3MgTUFDIEFkZHJlc3MiDQo+ICAgICArCWRlcGVuZHMgb24gTkNTSV9PRU1f
Q01EX0dFVF9NQUMNCj4gICAgICsJZGVmYXVsdCAxDQo+ICAgICArCWhlbHANCj4gICAgICsJICBU
aGlzIGRlZmluZXMgdGhlIG9mZnNldCBiZXR3ZWVuIE5ldHdvcmsgQ29udHJvbGxlcidzIChiYXNl
KSBNQUMNCj4gICAgICsJICBhZGRyZXNzIGFuZCBNYW5hZ2VtZW50IENvbnRyb2xsZXIncyBNQUMg
YWRkcmVzcy4NCj4gICAgIGRpZmYgLS1naXQgYS9uZXQvbmNzaS9uY3NpLXJzcC5jIGIvbmV0L25j
c2kvbmNzaS1yc3AuYw0KPiAgICAgaW5kZXggNzU4MWJmOTE5ODg1Li4yNGE3OTFmOWViZjUgMTAw
NjQ0DQo+ICAgICAtLS0gYS9uZXQvbmNzaS9uY3NpLXJzcC5jDQo+ICAgICArKysgYi9uZXQvbmNz
aS9uY3NpLXJzcC5jDQo+ICAgICBAQCAtNjU2LDYgKzY1NiwxMSBAQCBzdGF0aWMgaW50IG5jc2lf
cnNwX2hhbmRsZXJfb2VtX2JjbV9nbWEoc3RydWN0IG5jc2lfcmVxdWVzdCAqbnIpDQo+ICAgICAg
CXN0cnVjdCBuY3NpX3JzcF9vZW1fcGt0ICpyc3A7DQo+ICAgICAgCXN0cnVjdCBzb2NrYWRkciBz
YWRkcjsNCj4gICAgICAJaW50IHJldCA9IDA7DQo+ICAgICArI2lmZGVmIENPTkZJR19ORVRfTkNT
SV9NQ19NQUNfT0ZGU0VUDQo+ICAgICArCWludCBtYWNfb2Zmc2V0ID0gQ09ORklHX05FVF9OQ1NJ
X01DX01BQ19PRkZTRVQ7DQo+ICAgICArI2Vsc2UNCj4gICAgICsJaW50IG1hY19vZmZzZXQgPSAx
Ow0KPiAgICAgKyNlbmRpZg0KPiAgICAgIA0KPiAgICAgIAkvKiBHZXQgdGhlIHJlc3BvbnNlIGhl
YWRlciAqLw0KPiAgICAgIAlyc3AgPSAoc3RydWN0IG5jc2lfcnNwX29lbV9wa3QgKilza2JfbmV0
d29ya19oZWFkZXIobnItPnJzcCk7DQo+ICAgICBAQCAtNjYzLDggKzY2OCwxNCBAQCBzdGF0aWMg
aW50IG5jc2lfcnNwX2hhbmRsZXJfb2VtX2JjbV9nbWEoc3RydWN0IG5jc2lfcmVxdWVzdCAqbnIp
DQo+ICAgICAgCXNhZGRyLnNhX2ZhbWlseSA9IG5kZXYtPnR5cGU7DQo+ICAgICAgCW5kZXYtPnBy
aXZfZmxhZ3MgfD0gSUZGX0xJVkVfQUREUl9DSEFOR0U7DQo+ICAgICAgCW1lbWNweShzYWRkci5z
YV9kYXRhLCAmcnNwLT5kYXRhW0JDTV9NQUNfQUREUl9PRkZTRVRdLCBFVEhfQUxFTik7DQo+ICAg
ICAtCS8qIEluY3JlYXNlIG1hYyBhZGRyZXNzIGJ5IDEgZm9yIEJNQydzIGFkZHJlc3MgKi8NCj4g
ICAgIC0JZXRoX2FkZHJfaW5jKCh1OCAqKXNhZGRyLnNhX2RhdGEpOw0KPiAgICAgKw0KPiAgICAg
KwkvKiBNYW5hZ2VtZW50IENvbnRyb2xsZXIncyBNQUMgYWRkcmVzcyBpcyBjYWxjdWxhdGVkIGJ5
IGFkZGluZw0KPiAgICAgKwkgKiB0aGUgb2Zmc2V0IHRvIE5ldHdvcmsgQ29udHJvbGxlcidzIChi
YXNlKSBNQUMgYWRkcmVzcy4NCj4gICAgICsJICogTm90ZTogbmVnYXRpdmUgb2Zmc2V0IGlzICJp
Z25vcmVkIiwgYW5kIEJNQyB3aWxsIHVzZSB0aGUgQmFzZQ0KPiBKdXN0IG1lbnRpb24gbmVnYXRp
dmUgYW5kIHplcm8gb2Zmc2V0IGlzIGlnbm9yZWQuIEFzIHlvdSBhcmUgaWdub3JpbmcgMCBhcyB3
ZWxsLg0KDQpUaGFuayB5b3UgVmlqYXkgZm9yIHRoZSByZXZpZXcuDQoNClplcm8gb2Zmc2V0IGlz
IG5vdCBpZ25vcmVkOiB1c2VycyBnZXQgd2hhdCB0aGV5IHdhbnQgd2hlbiBzZXR0aW5nIG9mZnNl
dCB0byAwIChCTUMtTUFDID0gQmFzZS1NQUMpLg0KDQoNClRoYW5rcywNCg0KVGFvDQo=
