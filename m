Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 132F17E77F
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 03:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731008AbfHBBaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 21:30:10 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15948 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730890AbfHBBaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 21:30:10 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x721Sqev021610;
        Thu, 1 Aug 2019 18:29:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tGK/yCEXP7msXsiOMI52ZDRay48YmPY59K14taUs6ig=;
 b=TTwAH5/CTiTI3emEUbdA3NBRTXHJg79kAoMU3Hhnv9PNU+PcVxWKDFzNzk0eg72t+Ip/
 LHEPPwc3U8JNvro6wKkruBRasnwDPNVoyMt0nmuF+1wSVq8oVchQvZaQXwJSmwjzkrr7
 NqIg/F/qNshnRHuF7yxvH7RppZzuNZ9miqk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u44e2sgkm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 01 Aug 2019 18:29:53 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 1 Aug 2019 18:29:52 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 1 Aug 2019 18:29:52 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 1 Aug 2019 18:29:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1x+2lxq25LTtZBEtSB0apypZRGbKV4sBWj7g4SudgYq3KywuvQBqQV9qcQLPDhndcMy/SrvUsS/aBHhcsSBF+z8t3kd92lMSVsnnrI55NOdNw8uSdAxi+OLMP+0BEC9Y74hRCowwrCR3zvdX4+JrxM6G5gSoCJIB0uaMOaN2FKWoqPOwurlwHtHXZYEE19MeY3VD1MGtQIh4tU12BTVWZlUOaENuW2sMJo2dKpt+ZgXMQ687/e9LYhFMdBmxYzHGdBfccCvdJtdvnO/gG98Yh/Ob/KbzvDOz2kigu3jx7tDJSsn8bFq5yLO6ZUZmfRw3+F8no4vyK5j2iszlInWjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGK/yCEXP7msXsiOMI52ZDRay48YmPY59K14taUs6ig=;
 b=Q1blh/qdY8O0ZsCd7aS4xNFPY+gbFIxDmGGehmSvebLnZD6i83ZkpocVvCbb/pvFLcH92bppicagQaDPJsft3tOQaQQAd+1GbECzOaBnU6c0YsmT18YtHsuMsNbVfLe1EJasdL9ciRH+0U/yZyWhGybFqqchBED42ip8G56S3IbMc6eAZsESqAQgFMJTj5YJyDqhV8mjh17EiEpU9VpKKZF0GyAYhpK3lDKkR5VeFcOmOxwDI2oh1FRShOsBLYJ2/V8vRa/6DvRtV1zzfNd1K8Uw5CS60MnLfb/1qYMp4vQ+qJAKhUWNigEYB6JeE9aJw+olfYoCITMFUEhXaHPIbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tGK/yCEXP7msXsiOMI52ZDRay48YmPY59K14taUs6ig=;
 b=B6sfe1iwPnbCJFCpV5XFp/DlGmI2YchN+j1GMasa5qaPKyDOXR+y/MZy7WgUVJ0wf9bt4KX1XSNj9EWVNj1VeEcaCPy90fxNgnsIV1N5bavEBZdYldTCohXt3JfkSnaEcVHgH8q5DbbUld8BkEh7eStHUCI1ywRew207+LSpL4s=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1792.namprd15.prod.outlook.com (10.174.100.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Fri, 2 Aug 2019 01:29:36 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c%8]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 01:29:36 +0000
From:   Tao Ren <taoren@fb.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next 1/2] net: phy: broadcom: set features explicitly
 for BCM54616S
Thread-Topic: [PATCH net-next 1/2] net: phy: broadcom: set features explicitly
 for BCM54616S
Thread-Index: AQHVRm4tZSvvLl002ECU4Omi5U5C86bigvAA//+jr4CAAISsAIABMSsAgABfTQD//4x8gIABh1KAgAHHDQA=
Date:   Fri, 2 Aug 2019 01:29:36 +0000
Message-ID: <85331173-da14-5fcd-8c80-5bd2883061ec@fb.com>
References: <20190730002532.85509-1-taoren@fb.com>
 <20190730033558.GB20628@lunn.ch>
 <aff2728d-5db1-50fd-767c-29b355890323@fb.com>
 <bdfe07d3-66b4-061a-a149-aa2aef94b9b7@gmail.com>
 <f59c2ae9-ef44-1e1b-4ae2-216eb911e92e@fb.com>
 <41c1f898-aee8-d73a-386d-c3ce280c5a1b@gmail.com>
 <fd179662-b9f9-4813-b9b5-91dbd796596e@fb.com>
 <88f4d709-d9bb-943c-37a9-aeebe8ca0ebc@fb.com>
In-Reply-To: <88f4d709-d9bb-943c-37a9-aeebe8ca0ebc@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1301CA0001.namprd13.prod.outlook.com
 (2603:10b6:301:29::14) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:9fbd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c756234c-ba63-4aed-1a91-08d716e8e130
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1792;
x-ms-traffictypediagnostic: MWHPR15MB1792:
x-microsoft-antispam-prvs: <MWHPR15MB17920E3CE99974AB9E3E9550B2D90@MWHPR15MB1792.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(366004)(136003)(396003)(376002)(40764003)(199004)(189003)(6512007)(46003)(8936002)(256004)(6116002)(2906002)(36756003)(64126003)(65956001)(65806001)(476003)(446003)(14444005)(31686004)(186003)(478600001)(486006)(2616005)(25786009)(5660300002)(14454004)(86362001)(31696002)(7736002)(71190400001)(11346002)(4326008)(71200400001)(305945005)(53936002)(229853002)(66946007)(66446008)(7416002)(6436002)(6486002)(64756008)(53546011)(52116002)(66556008)(76176011)(102836004)(110136005)(65826007)(6246003)(316002)(8676002)(68736007)(58126008)(81166006)(54906003)(6506007)(386003)(66476007)(99286004)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1792;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tSAs3DQmKkYTJpmI+O7A1D4OAHaFXhTa/R72mfux0FA9uUtlc1EM2TMDWkn3rjXYtZPrc79KpfIJ6QGwxuLAyYTqNeTEU1cBTe8lOXM+V88wTNQI7Sfuc8CeYGwzeAnXR0PO9pz1aRrsNgWcK72Egj8B9Nt94Kx7R9J2OD6sfGGwmOMwkxTFL4RIzdB+a/mwL6tWP1BzLumfZqT/MEDmTpk2ImOh7e/9bUD2AeM1ojk6iD4D6gp5sdTtFK3eYxOvdFzTqKfhBqzCsqwunNlprrp3BHGLNx4S82zxCkl/buveMVeB+b9nsRjxIEsJlIYcG/hbbcNZR3DLJ8rPy8pwiM3pzwlXnZuIUPXIxbe2a3dQColRnGFcOeVLR2qVWl36yNzwIMa5LNWDvcqiNN0d0YuhydvXQFAvwi/HA4ySnew=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC94B0869F30584885E259B36B68B773@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c756234c-ba63-4aed-1a91-08d716e8e130
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 01:29:36.5026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: taoren@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1792
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-02_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908020012
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8zMS8xOSAxMDoyMCBQTSwgVGFvIFJlbiB3cm90ZToNCj4gT24gNy8zMC8xOSAxMTowMCBQ
TSwgVGFvIFJlbiB3cm90ZToNCj4+IE9uIDcvMzAvMTkgMTA6NTMgUE0sIEhlaW5lciBLYWxsd2Vp
dCB3cm90ZToNCj4+PiBPbiAzMS4wNy4yMDE5IDAyOjEyLCBUYW8gUmVuIHdyb3RlOg0KPj4+PiBP
biA3LzI5LzE5IDExOjAwIFBNLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6DQo+Pj4+PiBPbiAzMC4w
Ny4yMDE5IDA3OjA1LCBUYW8gUmVuIHdyb3RlOg0KPj4+Pj4+IE9uIDcvMjkvMTkgODozNSBQTSwg
QW5kcmV3IEx1bm4gd3JvdGU6DQo+Pj4+Pj4+IE9uIE1vbiwgSnVsIDI5LCAyMDE5IGF0IDA1OjI1
OjMyUE0gLTA3MDAsIFRhbyBSZW4gd3JvdGU6DQo+Pj4+Pj4+PiBCQ001NDYxNlMgZmVhdHVyZSAi
UEhZX0dCSVRfRkVBVFVSRVMiIHdhcyByZW1vdmVkIGJ5IGNvbW1pdCBkY2RlY2RjZmUxZmMNCj4+
Pj4+Pj4+ICgibmV0OiBwaHk6IHN3aXRjaCBkcml2ZXJzIHRvIHVzZSBkeW5hbWljIGZlYXR1cmUg
ZGV0ZWN0aW9uIikuIEFzIGR5bmFtaWMNCj4+Pj4+Pj4+IGZlYXR1cmUgZGV0ZWN0aW9uIGRvZXNu
J3Qgd29yayB3aGVuIEJDTTU0NjE2UyBpcyB3b3JraW5nIGluIFJHTUlJLUZpYmVyDQo+Pj4+Pj4+
PiBtb2RlIChkaWZmZXJlbnQgc2V0cyBvZiBNSUkgQ29udHJvbC9TdGF0dXMgcmVnaXN0ZXJzIGJl
aW5nIHVzZWQpLCBsZXQncw0KPj4+Pj4+Pj4gc2V0ICJQSFlfR0JJVF9GRUFUVVJFUyIgZm9yIEJD
TTU0NjE2UyBleHBsaWNpdGx5Lg0KPj4+Pj4+Pg0KPj4+Pj4+PiBIaSBUYW8NCj4+Pj4+Pj4NCj4+
Pj4+Pj4gV2hhdCBleGFjdGx5IGRvZXMgaXQgZ2V0IHdyb25nPw0KPj4+Pj4+Pg0KPj4+Pj4+PiAg
ICAgIFRoYW5rcw0KPj4+Pj4+PiAJQW5kcmV3DQo+Pj4+Pj4NCj4+Pj4+PiBIaSBBbmRyZXcsDQo+
Pj4+Pj4NCj4+Pj4+PiBCQ001NDYxNlMgaXMgc2V0IHRvIFJHTUlJLUZpYmVyICgxMDAwQmFzZS1Y
KSBtb2RlIG9uIG15IHBsYXRmb3JtLCBhbmQgbm9uZSBvZiB0aGUgZmVhdHVyZXMgKDEwMDBCYXNl
VC8xMDBCYXNlVC8xMEJhc2VUKSBjYW4gYmUgZGV0ZWN0ZWQgYnkgZ2VucGh5X3JlYWRfYWJpbGl0
aWVzKCksIGJlY2F1c2UgdGhlIFBIWSBvbmx5IHJlcG9ydHMgMTAwMEJhc2VYX0Z1bGx8SGFsZiBh
YmlsaXR5IGluIHRoaXMgbW9kZS4NCj4+Pj4+Pg0KPj4+Pj4gQXJlIHlvdSBnb2luZyB0byB1c2Ug
dGhlIFBIWSBpbiBjb3BwZXIgb3IgZmlicmUgbW9kZT8NCj4+Pj4+IEluIGNhc2UgeW91IHVzZSBm
aWJyZSBtb2RlLCB3aHkgZG8geW91IG5lZWQgdGhlIGNvcHBlciBtb2RlcyBzZXQgYXMgc3VwcG9y
dGVkPw0KPj4+Pj4gT3IgZG9lcyB0aGUgUEhZIGp1c3Qgc3RhcnQgaW4gZmlicmUgbW9kZSBhbmQg
eW91IHdhbnQgdG8gc3dpdGNoIGl0IHRvIGNvcHBlciBtb2RlPw0KPj4+Pg0KPj4+PiBIaSBIZWlu
ZXIsDQo+Pj4+DQo+Pj4+IFRoZSBwaHkgc3RhcnRzIGluIGZpYmVyIG1vZGUgYW5kIHRoYXQncyB0
aGUgbW9kZSBJIHdhbnQuDQo+Pj4+IE15IG9ic2VydmF0aW9uIGlzOiBwaHlkZXYtPmxpbmsgaXMg
YWx3YXlzIDAgKExpbmsgc3RhdHVzIGJpdCBpcyBuZXZlciBzZXQgaW4gTUlJX0JNU1IpIGJ5IHVz
aW5nIGR5bmFtaWMgYWJpbGl0eSBkZXRlY3Rpb24gb24gbXkgbWFjaGluZS4gSSBjaGVja2VkIHBo
eWRldi0+c3VwcG9ydGVkIGFuZCBpdCdzIHNldCB0byAiQXV0b05lZyB8IFRQIHwgTUlJIHwgUGF1
c2UgfCBBc3ltX1BhdXNlIiBieSBkeW5hbWljIGFiaWxpdHkgZGV0ZWN0aW9uLiBJcyBpdCBub3Jt
YWwvZXhwZWN0ZWQ/IE9yIG1heWJlIHRoZSBmaXggc2hvdWxkIGdvIHRvIGRpZmZlcmVudCBwbGFj
ZXM/IFRoYW5rIHlvdSBmb3IgeW91ciBoZWxwLg0KPj4+Pg0KPj4+DQo+Pj4gTm90IHN1cmUgd2hl
dGhlciB5b3Ugc3RhdGVkIGFscmVhZHkgd2hpY2gga2VybmVsIHZlcnNpb24geW91J3JlIHVzaW5n
Lg0KPj4+IFRoZXJlJ3MgYSBicmFuZC1uZXcgZXh0ZW5zaW9uIHRvIGF1dG8tZGV0ZWN0IDEwMDBC
YXNlWDoNCj4+PiBmMzBlMzNiY2RhYjkgKCJuZXQ6IHBoeTogQWRkIG1vcmUgMTAwMEJhc2VYIHN1
cHBvcnQgZGV0ZWN0aW9uIikNCj4+PiBJdCdzIGluY2x1ZGVkIGluIHRoZSA1LjMtcmMgc2VyaWVz
Lg0KPj4NCj4+IEknbSBydW5uaW5nIGtlcm5lbCA1LjIuMC4gVGhhbmsgeW91IGZvciB0aGUgc2hh
cmluZyBhbmQgSSBkaWRuJ3Qga25vdyB0aGUgcGF0Y2guIExldCBtZSBjaGVjayBpdCBvdXQuDQo+
IA0KPiBJIGFwcGxpZWQgYWJvdmUgcGF0Y2ggYW5kIGNhNzJlZmI2YmRjNyAoIm5ldDogcGh5OiBB
ZGQgZGV0ZWN0aW9uIG9mIDEwMDBCYXNlWCBsaW5rIG1vZGUgc3VwcG9ydCIpIHRvIG15IDUuMi4w
IHRyZWUgYnV0IGdvdCBmb2xsb3dpbmcgd2FybmluZyB3aGVuIGJvb3RpbmcgdXAgbXkgbWFjaGlu
ZToNCj4gDQo+ICJQSFkgYWR2ZXJ0aXNpbmcgKDAsMDAwMDAyMDAsMDAwMDYyYzApIG1vcmUgbW9k
ZXMgdGhhbiBnZW5waHkgc3VwcG9ydHMsIHNvbWUgbW9kZXMgbm90IGFkdmVydGlzZWQiLg0KPiAN
Cj4gVGhlIEJDTTU0NjE2UyBQSFkgb24gbXkgbWFjaGluZSBvbmx5IHJlcG9ydHMgMTAwMC1YIGZl
YXR1cmVzIGluIFJHTUlJLT4xMDAwQmFzZS1LWCBtb2RlLiBJcyBpdCBhIGtub3duIHByb2JsZW0/
DQo+IA0KPiBBbnl3YXlzIGxldCBtZSBzZWUgaWYgSSBtaXNzZWQgc29tZSBkZXBlbmRlbmN5L2Zv
bGxvdy11cCBwYXRjaGVzLi4NCg0KTGV0J3MgaWdub3JlIHRoZSBwYXRjaCAoIm5ldDogcGh5OiBi
cm9hZGNvbTogc2V0IGZlYXR1cmVzIGV4cGxpY2l0bHkgZm9yIEJDTTU0NjE2UyIpOiBhcyBIZWlu
ZXIgcG9pbnRlZCBvdXQsIGl0IGRvZXNuJ3QgbWFrZSBzZW5zZSB0byB0dXJuIG9uIGNvcHBlciBm
ZWF0dXJlcyBmb3IgZmliZXIgbW9kZSAoZXZlbiB0aG91Z2ggaXQgIndvcmtzIiBpbiBteSBlbnZp
cm9ubWVudCkuIEkgd2lsbCB3b3JrIG91dCBuZXcgcGF0Y2ggaWYgMTAwMGJ4LWF1dG8tZGV0ZWN0
aW9uIHBhdGNoZXMgY2Fubm90IHNvbHZlIG15IHByb2JsZW0uDQoNClRoYW5rIHlvdSBhbGwgZm9y
IHNwZW5kaW5nIHRpbWUgb24gdGhpcy4NCg0KDQpDaGVlcnMsDQoNClRhbw0K
