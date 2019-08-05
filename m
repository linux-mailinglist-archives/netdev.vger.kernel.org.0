Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B43F581275
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 08:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbfHEGit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 02:38:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65142 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727534AbfHEGit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 02:38:49 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x756cQ9Z010013;
        Sun, 4 Aug 2019 23:38:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tUCRyEv+P35mnEc2tD1IEeJW64egfdDofRc+myBWQ6E=;
 b=XqRW1DXo+CW5STvEDrTWOu1KmtK42yBVhkLu3N9FGqG2QhkkNJ3iA6Rf0rtCyKPDV3fD
 cQnE3T/ljcZkiujRRw3rIB3/bAhLOu/CHbb2db1OMMSFFLVUBihNTjaXaVni4FqK0cuH
 JEHkMEZ+86I4/rpF24aXEyATaIKGyXyfTsg= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u583act1f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 04 Aug 2019 23:38:36 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 4 Aug 2019 23:38:18 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 4 Aug 2019 23:38:18 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sun, 4 Aug 2019 23:38:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guWJUzuMpOt3bnBbrBRpSA9QAvIr5jeDw/w3wMsOngcPwEKVI+8d0460o5rgrLGWu5LbCLFouZj+gbOWbZ2leSYdXJCjNyoveQPmCf6O0jKjDeslt2bdzf4Ql5eHk+5H0mitMRgJgponTroGhiAspxHbBrSgPCukXC4ERfPmi36dzWLEPcH2Au4rSs2u8If/UcGQyhhmWcdMFwkoTBYlu+alwL02KzQbRy35sxQije9Ew1IO1ttHwm+RFVa2eCRSmR05Y26pG952Mpx02wVnmBXzsYca3lLC6XPj4sZIhnq8+QjbIGtQdLwKyPKPuyiqUUE7B7vIGrfKgI6WFvpvBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUCRyEv+P35mnEc2tD1IEeJW64egfdDofRc+myBWQ6E=;
 b=Ib1CoGyo0lzSnxn8wdavdWVF07u0ecovMRe8NZ2gRLoEbcQcCdBY2PSz3pgPEv9tI+zfebVySIwXo3RIBt9ZXgAxS2qUQX1M4Fv+48pk09sZNBrILgoJAClwY5ovvBwp5bmJimzUzLuap+nYuVX1fxLMVcAqsfuK7wQ7iE9D22ICkRGNXYYnBpqAK1m5GuxATqwIG8f7/1okHQ7vYwfGfIVgyiBn6qwFQtI1oQwpSVi9aOgZMCYbUo+ZW4bFuMnQGgZ6Kz+c/syT0UMPdb+xMF4ZngaHQxTH4wsU9wmS+bvbZaEmmWfw3QbH3O43R0x7VVy9U5xDkcQs87LYi7Nx+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUCRyEv+P35mnEc2tD1IEeJW64egfdDofRc+myBWQ6E=;
 b=ioNLLJBp3rRRLExYw5iF0u5S/+7IFpP5OyhUBFBswBEzrr2flIfImOI97lbOIEbDeBY8/IxYkzAg4VpLeYZo2tVty0GlCw3laypxMuTo245j7FHNqGvB/VlUGehaCA62WqyAIEnBaanzcbBhNPFnYmeP5DOabXRjiya3ajr21qM=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1342.namprd15.prod.outlook.com (10.175.2.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Mon, 5 Aug 2019 06:38:17 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 06:38:16 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v3] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Topic: [PATCH net-next v3] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Index: AQHVSX02YDtqShAJZEiiuBTkPN0xlKbpcXQAgACF6gCAAR30AIABCGoA
Date:   Mon, 5 Aug 2019 06:38:16 +0000
Message-ID: <2dd073b2-8495-593f-cd56-c39fd1c38a42@fb.com>
References: <20190802215419.313512-1-taoren@fb.com>
 <CA+h21hrOEape89MTqCUyGFt=f6ba7Q-2KcOsN_Vw2Qv8iq86jw@mail.gmail.com>
 <53e18a01-3d08-3023-374f-2c712c4ee9ea@fb.com> <20190804145152.GA6800@lunn.ch>
In-Reply-To: <20190804145152.GA6800@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:300:117::19) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::7ac7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: daf527c2-3c0b-44e2-5881-08d7196f7f66
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1342;
x-ms-traffictypediagnostic: MWHPR15MB1342:
x-microsoft-antispam-prvs: <MWHPR15MB13427449352A672FFBA6805BB2DA0@MWHPR15MB1342.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(136003)(346002)(376002)(39860400002)(189003)(199004)(43544003)(65826007)(58126008)(54906003)(6916009)(52116002)(31696002)(36756003)(86362001)(4326008)(7416002)(25786009)(8936002)(76176011)(5660300002)(6246003)(68736007)(186003)(316002)(64126003)(99286004)(5024004)(71200400001)(53546011)(71190400001)(6116002)(386003)(478600001)(6436002)(81156014)(81166006)(102836004)(31686004)(6512007)(53936002)(2616005)(486006)(476003)(11346002)(6506007)(256004)(6486002)(65956001)(66446008)(305945005)(7736002)(446003)(2906002)(46003)(14454004)(66946007)(65806001)(64756008)(66556008)(66476007)(229853002)(8676002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1342;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: vESpQTtmt89C+d0PawFjzEuNit+5zsbq2ICjUTa5PvYSQf/NLGqYa2wuT+klkyr74TI/woEBT3tnWWqPr4SNGbYpJf9muVO9JZevnSsdQyUvpfTW9B1KNqXN7rp49daj9ZMhS1TGJecmNuZFXyKaN5H5NT6pj91yqGeOsEVRZylFfz9rOhYLAUdeDJGZHv2fgK7n2w10jKOyI0bxlvc0xqCLZDY/2w81hG/55dsqXVZVCvVRNQgSBVovR2FC8w93Fl5mnd9nA0qd+bS+MjTSVbTYOhlMEP8tVXEp1kDqgIh+/d8QzkmzGGp1NOZ2Mq12vaL/SMgJcBO+pX0rzGiaRdiZbNY8qwc4NM+DRdFdBEVdyrBmA2GVvHYj3m7a+d7Y0RWoBN+ybInDZRGWHDKL9K7Gl7oavZO6e/PNDcwcaqA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7BC76F03AD55CF4DB32C6CA97AB22868@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: daf527c2-3c0b-44e2-5881-08d7196f7f66
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 06:38:16.7631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: taoren@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1342
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-05_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908050075
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpPbiA4LzQvMTkgNzo1MSBBTSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+Pj4g
VGhlIHBhdGNoc2V0IGxvb2tzIGJldHRlciBub3cuIEJ1dCBpcyBpdCBvaywgSSB3b25kZXIsIHRv
IGtlZXANCj4+PiBQSFlfQkNNX0ZMQUdTX01PREVfMTAwMEJYIGluIHBoeWRldi0+ZGV2X2ZsYWdz
LCBjb25zaWRlcmluZyB0aGF0DQo+Pj4gcGh5X2F0dGFjaF9kaXJlY3QgaXMgb3ZlcndyaXRpbmcg
aXQ/DQo+Pg0KPiANCj4+IEkgY2hlY2tlZCBmdGdtYWMxMDAgZHJpdmVyICh1c2VkIG9uIG15IG1h
Y2hpbmUpIGFuZCBpdCBjYWxscw0KPj4gcGh5X2Nvbm5lY3RfZGlyZWN0IHdoaWNoIHBhc3NlcyBw
aHlkZXYtPmRldl9mbGFncyB3aGVuIGNhbGxpbmcNCj4+IHBoeV9hdHRhY2hfZGlyZWN0OiB0aGF0
IGV4cGxhaW5zIHdoeSB0aGUgZmxhZyBpcyBub3QgY2xlYXJlZCBpbiBteQ0KPj4gY2FzZS4NCj4g
DQo+IFllcywgdGhhdCBpcyB0aGUgd2F5IGl0IGlzIGludGVuZGVkIHRvIGJlIHVzZWQuIFRoZSBN
QUMgZHJpdmVyIGNhbg0KPiBwYXNzIGZsYWdzIHRvIHRoZSBQSFkuIEl0IGlzIGEgZnJhZ2lsZSBB
UEksIHNpbmNlIHRoZSBNQUMgbmVlZHMgdG8NCj4ga25vdyB3aGF0IFBIWSBpcyBiZWluZyB1c2Vk
LCBzaW5jZSB0aGUgZmxhZ3MgYXJlIGRyaXZlciBzcGVjaWZpYy4NCj4gDQo+IE9uZSBvcHRpb24g
d291bGQgYmUgdG8gbW9kaWZ5IHRoZSBhc3NpZ25tZW50IGluIHBoeV9hdHRhY2hfZGlyZWN0KCkg
dG8NCj4gT1IgaW4gdGhlIGZsYWdzIHBhc3NlZCB0byBpdCB3aXRoIGZsYWdzIHdoaWNoIGFyZSBh
bHJlYWR5IGluDQo+IHBoeWRldi0+ZGV2X2ZsYWdzLg0KDQpJdCBzb3VuZHMgbGlrZSBhIHJlYXNv
bmFibGUgZml4L2VuaGFuY2VtZW50IHRvIHJlcGxhY2Ugb3ZlcnJpZGluZyB3aXRoIE9SLCBubyBt
YXR0ZXIgd2hpY2ggZGlyZWN0aW9uIHdlIGFyZSBnb2luZyB0byAoZWl0aGVyIGFkZGluZyAxMDAw
YnggYW5lZyBpbiBnZW5waHkgb3IgcHJvdmlkaW5nIHBoeS1zcGVjaWZpYyBhbmVnIGNhbGxiYWNr
KS4NCg0KRG8geW91IHdhbnQgbWUgdG8gc2VuZCBvdXQgdGhlIHBhdGNoIChJIGZlZWwgaXQncyBi
ZXR0ZXIgdG8gYmUgaW4gYSBzZXBhcmF0ZSBwYXRjaD8pIG9yIHNvbWVvbmUgZWxzZSB3aWxsIHRh
a2UgY2FyZSBvZiBpdD8NCg0KDQpUaGFua3MsDQoNClRhbw0K
