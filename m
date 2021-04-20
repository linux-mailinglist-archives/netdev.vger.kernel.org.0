Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC5B365DD7
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 18:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233379AbhDTQvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 12:51:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56370 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233376AbhDTQvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 12:51:13 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13KGYwqT110562;
        Tue, 20 Apr 2021 16:50:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=oDHmLqAsgLS7mPsMg0BXUPLJw+J0W7W2uM1tHebWINQ=;
 b=OWx65MZVJICIfSodKnIOK8CX0Lq2KK8HwZQ8+hwvleQa48M7Iz/S3X9O0UUS4ozJsnFn
 Tv5Dwk0aLC2flAjZB5dlkFRENokgBul9nSZHo1XWtSQlRhazj781FP3VUuZveOY6Pgps
 4u9SeMGwjspECxV4RMJNxxmSRKUlOKhM14FXl+AAUqX+0aC1xKHoL138VnFlutZaS8h9
 QeTGYSq8Pi+tlIPv7XWK4RSORkJB74UNJB7qkzo4TxHekEVlK/YrXV8HmFrtNrpSUXkq
 rR7UzjqVz/RQ/S+NcVfQv5HO6bDo91JW43kh+bY9aUq9EZBd5Sjoeu/pzz+KhgGDhuSo qQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37yqmnfuw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 16:50:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13KGa7gM084073;
        Tue, 20 Apr 2021 16:50:17 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by aserp3020.oracle.com with ESMTP id 3809k0n3gx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 16:50:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BKaBacitNyl+gvqZa9QVaR07iNOa8oqSJOXBie5r33lv5ztlxtX41/15xEwhw1C2FZ6S4zcqmjFbw1HQfPZ+8Nvy4eGzScojKS5fcgxtUqwm+diZH2wRPvcEGSK4dlX7MxlaoxSs/PJg7LjYYGtF6ubXvOm/K8mWtv3yUAZEsChLwqkjI6a8sb2GBs5Zi9U4Q3+ikuV+pMzbDYPfAWhYGIo/erWcxYnnAb5IMKW8Z0E1MDBl4vpkXnwqFYwDNH7l313mXWkE6b66HEh1vfOrhfkPfeuKLiKYDID4C+rHFgA5hBHWwQqKNVgcLqzlGaJPfoUhp7oUB9zsjfCkST6P+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDHmLqAsgLS7mPsMg0BXUPLJw+J0W7W2uM1tHebWINQ=;
 b=dR/QX5EcpC7BEO0fy5u+mc/5s5jQXdb2Bspk8NJn9Sbs6xY/fsyi08C+OWSX44bCDu+/aa4BWIJ3rTzRg869l2WmgP2dJJjrl3dSreK22WWuaQbjITvCjmA1qb7Q2I2qCKFd8+oPYnlbvL7DwSffdV8SW/6E7WjER2y3jyfH/zSAjAf4hCpLjIyFvbZbA5qgyKMy4ad3/oyKf4FBKjxeVNOmf809Jix7/yHk29OcuPTDSvquk1aZPozy3xAVPg71wylgvZ2f4MvdRNiilaHvdQO1ZV9mtFJBl7HpwkDcNIvF7JBOCzbNxIbKOf/7/QzFjMQS7L3bFONJhiAsYmi1Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oDHmLqAsgLS7mPsMg0BXUPLJw+J0W7W2uM1tHebWINQ=;
 b=iXVcQRyfhEV8rBhfbndYrVclGMTbtn/4Mb3JGpMa6kvGeQl91CLVGeZpLa872sPWUkE3ranR1EfNmDJXdz4gZRWRkDo/BJddYB5ayApyPMTMbd99x4k6fL7lLhWL+xtxRNt5tr3XBZPWpzJo5Vb4Ipjp0IzFIiw2Hzsj68Nk4qE=
Received: from MWHPR10MB1582.namprd10.prod.outlook.com (2603:10b6:300:22::8)
 by MWHPR10MB1536.namprd10.prod.outlook.com (2603:10b6:300:24::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Tue, 20 Apr
 2021 16:50:14 +0000
Received: from MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811]) by MWHPR10MB1582.namprd10.prod.outlook.com
 ([fe80::353a:1802:6e91:1811%8]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 16:50:14 +0000
From:   Liam Howlett <liam.howlett@oracle.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Grall <julien.grall@arm.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Liam Howlett <liam.howlett@oracle.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: [PATCH 3/3] arch/arm64/kernel/traps: Use find_vma_intersection() in
 traps for setting si_code
Thread-Topic: [PATCH 3/3] arch/arm64/kernel/traps: Use find_vma_intersection()
 in traps for setting si_code
Thread-Index: AQHXNgU7TopVgzWGUEaUH9orR8DEdw==
Date:   Tue, 20 Apr 2021 16:50:13 +0000
Message-ID: <20210420165001.3790670-3-Liam.Howlett@Oracle.com>
References: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
In-Reply-To: <20210420165001.3790670-1-Liam.Howlett@Oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.30.2
authentication-results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [23.233.25.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d829fda-db64-4971-fc26-08d9041c5e94
x-ms-traffictypediagnostic: MWHPR10MB1536:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR10MB1536FCD172AACD1221C1F370FD489@MWHPR10MB1536.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aP6pqR/WIteaIsHeiV1f2v0xyugwQXhOjRqKqK7UIFRQB82k3tYaNwrkMD3ppauNs35h7pa0TXhL43Y4V6pBmhfCrou7o7VejVhO1/rzD1nfVbMjrFEQL/l1L5rEBTesn7tqIb9nWv1UAVVz4uVMq6Nh+7T0oD0W/sndF/GlUaJG3bQX+wsWormbhoayTABod9nu8+pyKiNm5S2HJwE5CVtgGR6T0r1PG95bZHJ6WycqljbcZqknJf05PYLXwWvsy+sOsRp03OOXoEM6zw55v9T1W9bSgxu9lMEp/jgBcarg4JxZFF9h/aADK03h8cWaGHOObEolZHoMcmJ79xovw7fY1JNdSiBmbGv7QVuW9cYGASzImu53Q2YVOLc9XTHrWkWlh2n2JOOlptYuvl0IZSR1CO4YqI8EKnZYUEppMxSuHKuqkGu/gyzsb0K6r5wVDi+5qsEI62YQZCanq/1FxIfBImEqwHRzL3PvFlvFAOIkU1HD1vumtRGRgKGEsfHZBgBpDJgNaoXWfmlA04I3FcY0HKrt3kWd80F9FsPk43wklOo2LGjlEmLu6QmzfPwkwSdSu88vhipDeenS0oxYWDeulBQT8z9OTVbSDXCkqYM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR10MB1582.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(396003)(136003)(376002)(83380400001)(64756008)(2906002)(5660300002)(44832011)(6506007)(186003)(71200400001)(66476007)(66946007)(316002)(7416002)(66556008)(91956017)(54906003)(8936002)(1076003)(26005)(76116006)(8676002)(110136005)(36756003)(2616005)(122000001)(86362001)(6512007)(66446008)(478600001)(6486002)(4326008)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?eAe8HF9r75jQP7W8UWVaznpVTMmd+vC2PenTlfXFf+0Bz99jfZg/mfItAl?=
 =?iso-8859-1?Q?6aXxzG9ynGfrHfLV0F696OHKinXPZFX4CLcmHCql/Skd7cF3d3fhjYlrKC?=
 =?iso-8859-1?Q?fMxF1iIskF93sc4ZH968Vfchk8quJR277BIV0nRDy4iIBJYt/XxQKiM3to?=
 =?iso-8859-1?Q?JvgAlYWnXcFCeuC8kKSGAQtu8B80sXVHVOnrQge1W6bb5WFYI0BXpxhuWK?=
 =?iso-8859-1?Q?80ISWk8ACgSUPgBQfPSHsFpJPuO5usQikf2cEumRKJDIkxIDmvAI8kS3XU?=
 =?iso-8859-1?Q?GpkyYXa/TVrVjQY7soDsE78UVO17ZtfJLQ1Rdd+bxd7XSAACxHn0F05JKM?=
 =?iso-8859-1?Q?6cp3u5MS4O9lQHIrY6dyvUGJpI7lbusrcC9RP7L70eRnc1YhmRXBCJbdHp?=
 =?iso-8859-1?Q?Q1+sBQRQdnrJ76dWUaNehzZwUeW2udAX1QVKf6riDuouGfPQgN3S1vU7i2?=
 =?iso-8859-1?Q?N7Hi0iujl5j1qrDryw3A+onFdHOXezSdCFxow4XM3DUKNODvU8QcIlvkif?=
 =?iso-8859-1?Q?UPftRj5PTqpQnu43TsQOhenwEQDQ5u5bS6Nzis3FwYy4d4m3xdfk29cZQ2?=
 =?iso-8859-1?Q?E47gB809/yyVYXe8nlyZUXLH++Yad8oqjZqVI29MELV8ESigKMfi9cKvNG?=
 =?iso-8859-1?Q?sWaYBKol8vPOvxdkNEwp+Fe42cJLZ20V9ZYUZKQfmvBo8wy73WPisnr+i7?=
 =?iso-8859-1?Q?b6qs3NRH3OvvFdwiTGbUOcq8wrjr/1EhHiwq/HaCOWidD3kI+wCkbFKVbn?=
 =?iso-8859-1?Q?UqEZFMWSFwZnO/2HfSFtYUH1f21CctVMeN9Z9oxicmDe3ndGtgGAA4gRzp?=
 =?iso-8859-1?Q?pz7ZR3C86Q9B8wDPLYvIFgzrLUMldFFbY+JAXGIAKLlc/i1kOG/W07WhuD?=
 =?iso-8859-1?Q?wzm5rFjnQRIgWRUwlLnERHRTcqrubRThOvuw9pR15AEtMD/wnStKJEjca+?=
 =?iso-8859-1?Q?cC7HU1sCGlT6fZ+A3bN37HDfRUB2K7b38HynRvGOIkYIPbwCXa3zaYWElq?=
 =?iso-8859-1?Q?ar7qCVV8bqRbKIGjLR4aPMKyb7AWi4IvgF30ZrlMyBiU6Uhh5w97gzUCxM?=
 =?iso-8859-1?Q?8dS5uonVtxCZMkqB7yMewnQHZVTkm4cFc9yHk3WKJk2euAILbuiBaUzEnU?=
 =?iso-8859-1?Q?wWp+OcHCZ9B/BmcfXMruJ3Rytsm8QbpuvtId+053ab+AVGHcOW9bwhlbB0?=
 =?iso-8859-1?Q?ZTROd75M2HTlupd6YcYYrIHbkMufbH0TTBRVt7GpB7/4u7WVAiHBf7A/LO?=
 =?iso-8859-1?Q?dL65i50M0XwXBWJyIZy9dKH7BaMZpW6oTuJazv9sN6SaUbcj3vstf3nxmW?=
 =?iso-8859-1?Q?Ktk3WwwZFrask/b+HND9XfBozQN59mhrE2VRmHcqrlAPnlViRAKc2/cAde?=
 =?iso-8859-1?Q?OizXF5wY8f?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR10MB1582.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d829fda-db64-4971-fc26-08d9041c5e94
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 16:50:13.8425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UHAnPyoKhs4auSck29MgX2MYyi9+gjr7bv21FIfbedFBxIOo+TRlU2Wdb8scM8HfztUFvHyqKOcaqz3H111xBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1536
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9960 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200117
X-Proofpoint-ORIG-GUID: DlUi-Rm3_w_lNpuqS41IgthNEHYqyDNw
X-Proofpoint-GUID: DlUi-Rm3_w_lNpuqS41IgthNEHYqyDNw
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9960 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104200117
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

find_vma() will continue to search upwards until the end of the virtual
memory space.  This means the si_code would almost never be set to
SEGV_MAPERR even when the address falls outside of any VMA.  The result
is that the si_code is not reliable as it may or may not be set to the
correct result, depending on where the address falls in the address
space.

Using find_vma_intersection() allows for what is intended by only
returning a VMA if it falls within the range provided, in this case a
window of 1.

Fixes: bd35a4adc413 (arm64: Port SWP/SWPB emulation support from arm)
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
---
 arch/arm64/kernel/traps.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index a05d34f0e82a..a44007904a64 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -383,9 +383,10 @@ void force_signal_inject(int signal, int code, unsigne=
d long address, unsigned i
 void arm64_notify_segfault(unsigned long addr)
 {
 	int code;
+	unsigned long ut_addr =3D untagged_addr(addr);
=20
 	mmap_read_lock(current->mm);
-	if (find_vma(current->mm, untagged_addr(addr)) =3D=3D NULL)
+	if (find_vma_intersection(current->mm, ut_addr, ut_addr + 1) =3D=3D NULL)
 		code =3D SEGV_MAPERR;
 	else
 		code =3D SEGV_ACCERR;
--=20
2.30.2
