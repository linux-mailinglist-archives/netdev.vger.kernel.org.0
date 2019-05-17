Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE7D21E41
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 21:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbfEQTak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 15:30:40 -0400
Received: from mx0b-00272701.pphosted.com ([208.86.201.61]:58842 "EHLO
        mx0b-00272701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728954AbfEQTak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 15:30:40 -0400
X-Greylist: delayed 1633 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 May 2019 15:30:39 EDT
Received: from pps.filterd (m0107987.ppops.net [127.0.0.1])
        by mx0b-00272701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4HIsTLQ011895;
        Fri, 17 May 2019 14:03:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ou.edu; h=from : to : subject :
 date : message-id : content-type : content-id : content-transfer-encoding
 : mime-version; s=domainkey;
 bh=O6Knoi7Hzj+qNVkjo+QZnzS31KehmcDr852n59NmP2Y=;
 b=H7yD7ixjaW64uUKgt1+Z4EUaV6Q4ogr57b9z99/axS26LT8yuN6fC5iwqnxctyPOTRDM
 CeaCaVWA450fY7vslz1+e6ZHOfGCK3xwk9mVOiwORgTbol98W6kRzWBzf4hnWPXz52G1
 N4KjlyxrtS8uwpuYJfV/G0LlnkRZvLibrf+81JsNU6OkfeDboOFIy8QKfySUmYUjiBk7
 EoZY17LK+owvm97sdwKxRnmUM2tLYbsg8w5t6uUHXcQtPBywrhPXUS3FIDPGS8HuLZ5c
 YnaHny5NQdJ7MzQieFw9QctuwmX0g2ewPR6j6ELLUYQkE6OmRTij1u1YbMQYLdgfJpY9 5Q== 
Received: from nam03-by2-obe.outbound.protection.outlook.com (mail-by2nam03lp2051.outbound.protection.outlook.com [104.47.42.51])
        by mx0b-00272701.pphosted.com with ESMTP id 2sj146rjf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 17 May 2019 14:03:21 -0500
Received: from SN6PR03MB4064.namprd03.prod.outlook.com (52.135.110.223) by
 SN6PR03MB4240.namprd03.prod.outlook.com (52.135.110.94) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Fri, 17 May 2019 19:03:19 +0000
Received: from SN6PR03MB4064.namprd03.prod.outlook.com
 ([fe80::b5da:c33c:a5cf:d867]) by SN6PR03MB4064.namprd03.prod.outlook.com
 ([fe80::b5da:c33c:a5cf:d867%7]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 19:03:19 +0000
From:   "Kenton, Stephen M." <skenton@ou.edu>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: ARCNET Contemporary Controls PCI20EX PCIe Card
Thread-Topic: ARCNET Contemporary Controls PCI20EX PCIe Card
Thread-Index: AQHVDOMw/tnFewnQY0iWkBmW3sFgUw==
Date:   Fri, 17 May 2019 19:03:19 +0000
Message-ID: <be572630-98e4-95bc-f50a-e711ded62526@ou.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [99.63.185.115]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
x-clientproxiedby: CY4PR19CA0042.namprd19.prod.outlook.com
 (2603:10b6:903:103::28) To SN6PR03MB4064.namprd03.prod.outlook.com
 (2603:10b6:805:bf::31)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ded0801-2948-4b1a-96d3-08d6dafa52fa
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:SN6PR03MB4240;
x-ms-traffictypediagnostic: SN6PR03MB4240:
x-microsoft-antispam-prvs: <SN6PR03MB42407F057144216DE5CCE3EEDC0B0@SN6PR03MB4240.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(376002)(136003)(366004)(199004)(189003)(256004)(478600001)(476003)(6116002)(3846002)(2906002)(71200400001)(53936002)(14454004)(2616005)(7736002)(26005)(25786009)(305945005)(65826007)(8936002)(2501003)(186003)(81156014)(81166006)(8676002)(88552002)(64126003)(71190400001)(6512007)(36756003)(486006)(6486002)(386003)(52116002)(6506007)(31696002)(99286004)(316002)(58126008)(68736007)(5660300002)(6436002)(86362001)(4744005)(75432002)(66946007)(73956011)(66446008)(64756008)(66556008)(66476007)(102836004)(31686004)(786003)(65806001)(65956001)(66066001)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR03MB4240;H:SN6PR03MB4064.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ou.edu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Bv17yCOQpu0CUCEsyC/grUgto0M9dCG3ePjd7AnnZUuRf98p8RR/Lq8HbPVb1knLxFLv4Xba3yA9nCG6o9q2yV6fsPB/H1LmhzgaMDFMNILwMOfkzpAztBq0BEVJmregFC1F2MMkRCluQ4K0q0MRTeAJG6HoUVeJodXoaDt3E1KzfTyHRg7i+bOMPtoXvEksJOJ454DdZ7YDwsGUk36KyyOE4vvUjDvRjTN3jN9PxuKHOCPZ0lqMvuSYK8dcumZ/p4Z4bWkCVyCSuBT+jYwkLvAq8UJZuhAYK73uTrYrTe2ydU9IiIQJyVcpokd/shRYkM3zJSiRwN+rJKn09vz9ZzLHyGclOFKcar1VeuM/mmDs9vC1NhabgnpciFb+1UbocA3metWA4t/LTYli70Mr2xidtyKbXFOXn5vLH6Kb3eA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F25A2E99B20B884E809661D764EABD13@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ou.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ded0801-2948-4b1a-96d3-08d6dafa52fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 19:03:19.1205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9c7de09d-9034-44c1-b462-c464fece204a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB4240
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-17_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=922 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905170111
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SSd2ZSBnb3Qgc29tZSBvbGQgb3B0aWNhbCAoYXMgaW4gZXllZ2xhc3NlcykgZXF1aXBtZW50IHRo
YXQgb25seSB0YWxrcyANCm92ZXIgQVJDTkVUIHRoYXQgSSB3YW50IHRvIGdldCB1cCBhbmQgcnVu
bmluZy4gVGhlIFBFWCBQQ0llLXRvLVBDSSANCmJyaWRnZSBpcyBvbiB0aGUgY2FyZCB3aXRoIHRo
ZSBTTUMgQ09NMjAwMjIgYW5kIGxzcGNpIHNlZXMgdGhlbQ0KDQowMjowMC4wIFBDSSBicmlkZ2Ug
WzA2MDRdOiBQTFggVGVjaG5vbG9neSwgSW5jLiBQRVggODExMSBQQ0kNCkV4cHJlc3MtdG8tUENJ
IEJyaWRnZSBbMTBiNTo4MTExXSAocmV2IDIxKQ0KMDM6MDQuMCBOZXR3b3JrIGNvbnRyb2xsZXIg
WzAyODBdOiBDb250ZW1wb3JhcnkgQ29udHJvbHMgRGV2aWNlDQpbMTU3MTphMGU0XSAocmV2IGFh
KQ0KICDCoMKgwqAgU3Vic3lzdGVtOiBDb250ZW1wb3JhcnkgQ29udHJvbHMgRGV2aWNlIFsxNTcx
OmEwZTRdDQoNCkkganVzdCBwdWxsZWQgdGhlIGN1cnJlbnQga2VybmVsIHNvdXJjZSBhbmQgMTU3
MTphMGU0IGRvZXMgbm90IHNlZW0gdG8gYmUgc3VwcG9ydGVkIGJ5IHRoZSBkcml2ZXIuDQoNCkJl
Zm9yZSBJIHN0YXJ0IHRyeWluZyB0byBpbnZlbnQgd2hlZWxzLCBpcy9oYXMgYW55b25lIGVsc2Ug
bG9va2luZyBpbiB0aGlzIGFyZWE/DQoNClRoYW5rcywNCg0KU3RldmUgS2VudG9uDQoNCg==
