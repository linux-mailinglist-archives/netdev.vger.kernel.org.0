Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDC618D70
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 17:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfEIP4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 11:56:32 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36504 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726187AbfEIP4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 11:56:32 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x49Fqjxm013575;
        Thu, 9 May 2019 08:56:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : cc : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=o9rZxIUi9sTWfwwXpQggpRRur6p3Rn4x9DLgLuCyYVA=;
 b=f8ZSjQxHbhBwLoSaZlBtlOGfgJrUA+rvhT1LP/REHbaix1409gjt6iMciQu2FP4RdoLA
 F9/KLUFgQLLDEQ6wnGDVkatZ0LKyAx20jCqYoz4lLVCaq/Dl5JO9IWy+nO5Xs7TY5nF6
 qcyeeSJrdi13+dows/cJVoBjN0foQtbw72E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2scamua92m-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 09 May 2019 08:56:10 -0700
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 9 May 2019 08:56:09 -0700
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 9 May 2019 08:56:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o9rZxIUi9sTWfwwXpQggpRRur6p3Rn4x9DLgLuCyYVA=;
 b=Ev0jlJ/HHw48TO/llyvaW4ZvmJCTuUnhakKBswL3lMLwYtgbGMyyGe2aXkgDQtsrs9B7fDXn7EPVgMJSESqu5ExKoJGPNfiJeAfXGr36HtJB7gGiQ5pQjoJa6gDqeeh+N/qLtMLqb6XsrRfqUSGYbwR0uA7hDe+SQ6AR5gLG9/4=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.255.19) by
 MWHPR15MB1679.namprd15.prod.outlook.com (10.175.141.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Thu, 9 May 2019 15:56:08 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::c1c6:4833:1762:cf29%7]) with mapi id 15.20.1856.012; Thu, 9 May 2019
 15:56:08 +0000
From:   Martin Lau <kafai@fb.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf v2] selftests: bpf: initialize bpf_object pointers
 where needed
Thread-Topic: [PATCH bpf v2] selftests: bpf: initialize bpf_object pointers
 where needed
Thread-Index: AQHVBb4eqiQDNIICmU2K4snWKgFUPaZi8+gA
Date:   Thu, 9 May 2019 15:56:07 +0000
Message-ID: <20190509155600.4yypxncilarbayh4@kafai-mbp>
References: <20190502154932.14698-1-lmb@cloudflare.com>
 <20190508164932.28729-1-lmb@cloudflare.com>
In-Reply-To: <20190508164932.28729-1-lmb@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0027.namprd08.prod.outlook.com
 (2603:10b6:301:5f::40) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:4e::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:bd25]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b4e7511-0120-4898-7a95-08d6d496d8ee
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1679;
x-ms-traffictypediagnostic: MWHPR15MB1679:
x-microsoft-antispam-prvs: <MWHPR15MB16791D4640F497E4ED12C04DD5330@MWHPR15MB1679.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 003245E729
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(366004)(396003)(346002)(376002)(136003)(39860400002)(189003)(199004)(54906003)(68736007)(33716001)(5660300002)(76176011)(11346002)(476003)(316002)(81156014)(486006)(86362001)(9686003)(81166006)(53936002)(8676002)(6512007)(52116002)(8936002)(4326008)(25786009)(109986005)(6246003)(256004)(14444005)(99286004)(229853002)(1076003)(6116002)(558084003)(6486002)(14454004)(2906002)(1671002)(305945005)(71200400001)(71190400001)(46003)(186003)(7736002)(73956011)(59246006)(478600001)(66946007)(446003)(66446008)(64756008)(66556008)(66476007)(386003)(102836004)(6506007)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1679;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pxsQrXr5ZOWl5MuwXYVhtm466sHNwPiaREF6nwsbdriAYOPBoe6mxGg5WelPHbm10vZwhh9GohDQDQsKUrUB9bpk59uP6S7P74DJmAXQgxUfiFpMF4PXJi8Q9ysP+dxOtWZ9wu7Nf4OrZSHgCGd1Bt7zk6yxtBAGqsV5YblEU9DCl14RJ/FBYqzslVffji2IJ15SZu/FFWCbZH3h4w4CLDCLEcGLKk3XaQQlRmO2q9vsYslZXE9hXOgfi+ek/3oTpsJEDDvWXEryMTvG99ubeY+6uIcF9rUdRrZ1Z/nAyrbXu1IYd5ssXDzG+41MsZQWWH//Oq+aotpwXd4pL6QUJBtdDVh9tQ1DW/Ia/y41tQ30iaht6FI0mJGGnomc/PTX1C4lD29yNwJlCM8De16m1RuSh0aRWsU4OOp92XOx0Kw=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A281699AEFA8FE45B532A60829520F21@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b4e7511-0120-4898-7a95-08d6d496d8ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2019 15:56:07.8972
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1679
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-09_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=527 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905090091
X-FB-Internal: deliver
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 05:49:32PM +0100, Lorenz Bauer wrote:
> There are a few tests which call bpf_object__close on uninitialized
> bpf_object*, which may segfault. Explicitly zero-initialise these pointer=
s
> to avoid this.
Acked-by: Martin KaFai Lau <kafai@fb.com>
