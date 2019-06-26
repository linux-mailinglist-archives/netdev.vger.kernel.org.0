Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCDE557423
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 00:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfFZWOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 18:14:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29468 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726239AbfFZWOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 18:14:15 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5QMDqjn022472;
        Wed, 26 Jun 2019 15:13:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=HfFgzxXqVyLtfFZteDNh7PLwoUIO4UJBoqT7rpRp8qE=;
 b=ROItScjC462FhsbaXQY/PPH+8Hk2eap8MHDmHKG8Sz4nEZYLUj0F7EYeQlEgZXCBbRE0
 Y4vuaPIkhLY1nlOeyKnSKrOQbj6FdpdVDhcTblNFzkSI3Tp/2BqYjvNywIEohcX2U9Wq
 j2oAIx7WjZM6hXfr8SkViiWL3+YJ/DAEChE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tca1vsu4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 26 Jun 2019 15:13:54 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 26 Jun 2019 15:13:53 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 26 Jun 2019 15:13:53 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 26 Jun 2019 15:13:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HfFgzxXqVyLtfFZteDNh7PLwoUIO4UJBoqT7rpRp8qE=;
 b=Xs121MI7hED3rcUfcV7PA0kfJxoQTuv+hCR3tco0w/g/9OUPV5K+jMHbwyo6XI2lg/xxD/dcWOAt9CnvX2Ns8c0lrTQ0o/zGD4Y+bs30/K7jjvZSUjJZUgbev78T/7+07L6EgQ2byIfmBSvcK8Z5aLPNxQOZ25GICp3rCm6ND0U=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB3330.namprd15.prod.outlook.com (20.179.74.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 22:13:51 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::e594:155f:a43:92ad]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::e594:155f:a43:92ad%6]) with mapi id 15.20.2008.018; Wed, 26 Jun 2019
 22:13:51 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Networking <netdev@vger.kernel.org>,
        "Linux Next Mailing List" <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the bpf tree
Thread-Topic: linux-next: Fixes tag needs some work in the bpf tree
Thread-Index: AQHVLGtWobJf9y3bFk6A9OxwhHLb36augAKA
Date:   Wed, 26 Jun 2019 22:13:51 +0000
Message-ID: <20190626221347.GA17762@tower.DHCP.thefacebook.com>
References: <20190627080521.5df8ccfc@canb.auug.org.au>
In-Reply-To: <20190627080521.5df8ccfc@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0044.namprd15.prod.outlook.com
 (2603:10b6:101:1f::12) To BN8PR15MB2626.namprd15.prod.outlook.com
 (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:8b85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 72111cdd-56f4-47ab-6326-08d6fa8391b7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN8PR15MB3330;
x-ms-traffictypediagnostic: BN8PR15MB3330:
x-microsoft-antispam-prvs: <BN8PR15MB3330F7124CA0A416279C41C6BEE20@BN8PR15MB3330.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:489;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(396003)(376002)(136003)(366004)(189003)(199004)(53754006)(486006)(6506007)(478600001)(66556008)(66476007)(66446008)(476003)(66946007)(73956011)(64756008)(2906002)(6246003)(386003)(81166006)(102836004)(68736007)(446003)(81156014)(11346002)(8936002)(86362001)(256004)(6916009)(7736002)(305945005)(186003)(6116002)(6436002)(54906003)(33656002)(52116002)(8676002)(14454004)(229853002)(4326008)(1076003)(6486002)(316002)(9686003)(4744005)(6512007)(25786009)(53936002)(46003)(99286004)(71190400001)(71200400001)(5660300002)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB3330;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: i2/n4erNij+37YbD9ewcJg7S4Z6e6rpagu2X2LYaysxj/AQ3p7wtmT+Sz1V9r87QULXH7m8riSYcbbkxggNBWR8NqbtD6dpCW55yqGxXbS/3q5oYmuBcCU3kgthxdzajycr/iSytDBaiP9tED7zbs7Wrg3IWkyTTe64V9hZ02VSmuurGa+liO0Lnmzv91IS0b8tAQm6IBupTc9FPLon8w21SanI/1SS2QsltxHhCX4rR3vCI56mBPDZn+8b7phKCMMmxdzopABMZccTOEYhT4bMftrdLOBJ93UH+CTs3eZdOiOImxTCn1fXfOAniirLIjcsPbEoHY/cygTa62U9QfvSs9fc+N8iDQGoLSwDWvt8md9DpZnEAbkTk4Rq7UlUYTDrLd0q0ktq+5UH1ojdx8QWCenSLksAjEhxlV1IQNe4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <851EF497B88AB4479B0ABD8A4CF51205@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 72111cdd-56f4-47ab-6326-08d6fa8391b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 22:13:51.4217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: guro@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3330
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-26_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=808 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906260254
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 08:05:21AM +1000, Stephen Rothwell wrote:
> Hi all,
>=20
> In commit
>=20
>   12771345a467 ("bpf: fix cgroup bpf release synchronization")
>=20
> Fixes tag
>=20
>   Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from
>=20
> has these problem(s):
>=20
>   - Subject has leading but no trailing parentheses
>   - Subject has leading but no trailing quotes
>=20
> Please don't split Fixes tags across more than one line.

Oops, sorry.

Alexei, can you fix this in place?
Or should I send an updated version?

Thanks.
