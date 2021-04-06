Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D20D3558A0
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 17:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346130AbhDFP6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 11:58:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55970 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232363AbhDFP6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 11:58:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 136FikU5174050;
        Tue, 6 Apr 2021 15:57:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1pavsEEs/JzmD8dDB3Gi/I/ERP26g6tLK2OvZYVY4as=;
 b=kej7xCxnVL5qR46T+DoS/ec7zZuP/39rSRlWjWUvVpEhU2m8gSSxUrfRKPxqxTfY/3ms
 1mj2yvXuoI3deVgwxP8B9V6P/fsWNXwHN1nzgetx2QYiGI5mTm+Zv2UZxqUVsxZIiqqi
 QWs0CA3bp7IRFSHF/aFKh4kqAgtb4i1LRSyIVttqMO/gcq1bGFIU5rQAo5umw+hrYpkv
 RCKzNZINNm1VKCRLl7Bb/Ip7tHWJnwbBggmf29AnLKLkmPgoY9AMVun26CLkiIVTHJA2
 34VLSUBxCidkkugjWnQJP3r+96xOnRfuL+DtIzLV1NSURrcUmEQiM59YYALQKFgUS5kZ 4g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37q3f2e2k3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 15:57:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 136Fk2GZ065244;
        Tue, 6 Apr 2021 15:57:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by aserp3030.oracle.com with ESMTP id 37q2pcpmy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 15:57:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kx2TnkCcfL1EUN4VFDzF5mwtsQv80Af3e/EVM6AFj9ayU9Ac4IJqLb/OcB3XLvZU6Id+90r67GNvnpVAhVeijOY0t43cYTSwXfkUx6gSF+yve40lA3PPyJ2t/h+iKuZwVg1HSJu6qiwpQXdbfDv/cB93YcV12MQXtHNQhBudZmIqNhr0ZGYYfHMoPwB1sshWglqsq8goBdR8Qa2pIoJ6pyEA7OoihP8APyUfMfqNx8VN9MjrWJfM4ONe15Th1S4+yKAT1gu6TCt2eU/TH3rIB+Z7+Sb2/UvvbphS+AESXTUVLSMA5sUb5w8z9C1dLjC/haLQkwuu9L7LXcDWymrpYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pavsEEs/JzmD8dDB3Gi/I/ERP26g6tLK2OvZYVY4as=;
 b=GZqA175HhAPIdEM+o82BNpwX9W3qpK/8+f2oGsJfbEjiWDh8e6yfW1mmg9JCpEx8/2iPdLQr+9MbxQ1JqLEUkUZ87v5lPbsljTEq3KDBXeLC/KK0z/XX8HV1ucc0zEoSm+xZG5y1iosJJwPGueONChW94vvwbafV1ajbLrgrx6yZNbOnYosvCUBKD3O5F3jFucDWLtClOCxxqTEM3wyifwBheNGUbo/QY0ZbQOyUSm8tTx9J0zdTysjhd1RowHP8zXieJuLrbvoIh4mhOcibPxCLGVG/2gO+jOu6rjG7xHG/FDFPCBuzFW9IHrrzv3sKL1LwCAzQBXcAqBgmp9iegw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pavsEEs/JzmD8dDB3Gi/I/ERP26g6tLK2OvZYVY4as=;
 b=yR285psVrAcDPfH01Zfb4PW7Za6/4n6/m19Me64pL7u/NlE7BwZuoY/oPcCq2aVLnSFILEScjpZ7vegO/4t7x8v+JhCMaO2FGXWmdTLpdVBdTmMEfMkVa5Q3gLRxLke8UFhsYzvy046yWv1jn/zQOMayqOzzSsApDWzrdXJhpKg=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB2693.namprd10.prod.outlook.com (2603:10b6:a02:b6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 6 Apr
 2021 15:57:47 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::50bf:7319:321c:96c9%4]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 15:57:47 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
CC:     Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sunrpc: Remove unused function ip_map_lookup
Thread-Topic: [PATCH] sunrpc: Remove unused function ip_map_lookup
Thread-Index: AQHXKpePGq/92dzR2EiqDsqwwKktAaqnpfwA
Date:   Tue, 6 Apr 2021 15:57:46 +0000
Message-ID: <3020346E-BD5C-45C6-8775-C791578FED0F@oracle.com>
References: <1617680819-9058-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1617680819-9058-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1bb93c93-5876-497a-20ae-08d8f914b8f6
x-ms-traffictypediagnostic: BYAPR10MB2693:
x-microsoft-antispam-prvs: <BYAPR10MB2693059F0091ABE1427D531F93769@BYAPR10MB2693.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dr2e8PqrD7krmjb5AGwWr45Vq8ZQgwaprBgGk+p2eoDmI0f9OqoUArAgT+lQE6BfpYlF9u9tUm8/PLtBr4UaWEPPni6+JvNwbFJKYlm26V6ClI5dmIGYJBOedFQi0aYCKNjcaJp+7DxJ2cTkAZ2HiKrkuJOfyBAJTgNEaOFetHoU3mbJ+Jnv3RGqg3/wKhsO2q7JGMJmYeX4OWCM8o1sDl2JCKdC0eSGUz3fR4QRxYTQojBaafUy5E5Dro0leDsUTLgvdbSA4LPhbCWGa07HBfaLuYqpCQs0ZzkB9YsiSpG7XRIZWiBJlG/TSp5KNXWqI/wuLh/gCaULaTbJq5s7ifoVxzzvKakPIJlgjuTY1d9znc6AiRTfuJSgCz/g6xS5w54BtmTnvBrBeHAizXoKDA2/YlLC66e62Yv/OSOUOS74jyIK90z85WDsxnXTt8GS05Oc944uJkaKLhUPRg28xyFSyApgsNQqFBTwoNHbZuiFnr5WRjBEhlReWJZLB2UV++VORCrk11I0VNv5n2Up/d+olO14G5by2R9JvPN9Mk5anQFbjJGFGGKpRh5hSa97wCkdpTq8KoCJzLm4Dh9IT5/n5dwjI/MsACVy9mm95huT28W1ReskOhVca5s9qcghTXgGr7XnW78M8w4wJKRFeP9my3AKddEKY3QFjgbdGgTRPLA9AkHBFVNF10kzaBpM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(39860400002)(396003)(366004)(4326008)(66446008)(478600001)(66556008)(66476007)(186003)(316002)(53546011)(83380400001)(6916009)(64756008)(33656002)(86362001)(66946007)(91956017)(6486002)(76116006)(6506007)(38100700001)(8676002)(2906002)(26005)(8936002)(2616005)(6512007)(36756003)(71200400001)(54906003)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Hhi7cEFW5hY1oHHQC/1CIIBzMP7Lwp27/0VZ2fTZaUv31YYO2tYB/jKShAmw?=
 =?us-ascii?Q?8qO2Gpe5v32Q58oMnk7brjbyThnL5Bx/rOs7KdJeNFIe8oKsj+1qNyGMmcVl?=
 =?us-ascii?Q?XBHgeLI82zLc1kTY/v/gEhS/9E7o1Lv9WCx/0HwGLuEQ8ebK0cDFpNcy2YpB?=
 =?us-ascii?Q?duVYC3Ade5R/wjGl0nQtoMidl+FYBiEgjcRJSG/uKC49VaSo68IUwb8EC1Uq?=
 =?us-ascii?Q?cZJuLHYXAxNdD0MtqB4l2wMbpqzq6ae8IxCmiqJxh01mqbKoQRmGOft6hSZA?=
 =?us-ascii?Q?W/J16611Kz5ZfP03vQal3N9RvOkXcV8FTDlCPXB/SHA3VUDtjbhl+joDzvNo?=
 =?us-ascii?Q?7kpt6VjslbjyrmzL0PXQ0/8ZZkxNMlOtBoTAfTIPRHSJkqXWPU/8pWAZagMm?=
 =?us-ascii?Q?WuzJbuoMmbzJExLqQQuC4VCudkpDQonDWqcTss7He4LPhJHX9KiOXn2OCQxM?=
 =?us-ascii?Q?MQeURhG+J9vgQNz6mNFQMB1mZmZl3P1cA2f5kEIv3Vkqs3tH6QNDnnbY2m+a?=
 =?us-ascii?Q?udFMoXTbxFgupuZKOIGU83Cw+EZszvRCUkhxfcCxTV1TrwA2yNHX7gEBInxW?=
 =?us-ascii?Q?9TU/SvQjPdv2N+wcIuvBFOE2HB7JekTLTr6FzJhZKaTaNaPODVh0b1fVAoim?=
 =?us-ascii?Q?K77PLb5h0oaGZGonm6EMnLhnk+D3+JmH3sHg74Icupm7pxjMsXyrt7CNo9qV?=
 =?us-ascii?Q?xGuSX+GAvibsbeGll/fYLvqeyymv8gZDAa0/kSghRVJaiK8H1snc2MV5AxGQ?=
 =?us-ascii?Q?EJGNEoWgReXPfNHdVIf1QzbfHh73t1vbkEpTgCleU8kbMEGBTa5yIMTI1U6g?=
 =?us-ascii?Q?ne8J8xv5Pub9cGq78GZOLtmf1Ou7toTodZbIegKdjCMNHpbJXyvmUv64o3+G?=
 =?us-ascii?Q?gAyReZ+bJaozjhfZ5g2ed2Hcg9D5aBLen/CgMA3ZdSrew7WeCgWnKE3B/5aF?=
 =?us-ascii?Q?78tTtItdiXe65Z3mfSdzmaySBaTJitVjeWrT9UydfsU+nRAfpT8IaI7CJ0Wr?=
 =?us-ascii?Q?ZEzT6fHgNITGgl1Loe0fxhLSS/HBcFSwwUGv0RSMbU/KjKV808Ebu4drJExZ?=
 =?us-ascii?Q?h1+subKFpSnJc4e0k4EGLrNpeVYP3WBdHLP6kBnma/XfErWvd2YwOAV453WX?=
 =?us-ascii?Q?XBaw2xG0+ozQIMg1Ef9kD98n0DwO4qbAZBV1kwMB2pOZjvHMt9r7PzMmheTN?=
 =?us-ascii?Q?TW6ZfyCQgyIVfSo8e7YE9E3K4TMJ86UJN2CY206XHyjjO/RV6lci6KYz+zkv?=
 =?us-ascii?Q?Mq8O1KpOf7Gs2bL7jbyiqKf2hWcyqByC0/4pDgB7ssez5k41YdLlIvs4PHpz?=
 =?us-ascii?Q?bdJoOU4mJYTMvruO2JhGw+6j?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6C57EEEE8673CD4FABF590AEEC61146B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bb93c93-5876-497a-20ae-08d8f914b8f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2021 15:57:46.9938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XN+uAoEh/qyMnPPN6qcA7epzQXpS75VeG/VVG7pKeT1y00XpO9efAe+DjHUhlkq6vhFYZT89MynJLMeG0FwxXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2693
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9946 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104060106
X-Proofpoint-GUID: XCb4G26lFvhjJ3vSm0NlFuWR4sK-TZVk
X-Proofpoint-ORIG-GUID: XCb4G26lFvhjJ3vSm0NlFuWR4sK-TZVk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9946 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 lowpriorityscore=0 clxscore=1011 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104060106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello-

> On Apr 5, 2021, at 11:46 PM, Jiapeng Chong <jiapeng.chong@linux.alibaba.c=
om> wrote:
>=20
> Fix the following clang warnings:
>=20
> net/sunrpc/svcauth_unix.c:306:30: warning: unused function
> 'ip_map_lookup' [-Wunused-function].
>=20
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

This has been pushed to the for-next topic branch in:

git://git.kernel.org/pub/scm/linux/kernel/git/cel/linux.git


> ---
> net/sunrpc/svcauth_unix.c | 9 ---------
> 1 file changed, 9 deletions(-)
>=20
> diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
> index 97c0bdd..35b7966 100644
> --- a/net/sunrpc/svcauth_unix.c
> +++ b/net/sunrpc/svcauth_unix.c
> @@ -303,15 +303,6 @@ static struct ip_map *__ip_map_lookup(struct cache_d=
etail *cd, char *class,
> 		return NULL;
> }
>=20
> -static inline struct ip_map *ip_map_lookup(struct net *net, char *class,
> -		struct in6_addr *addr)
> -{
> -	struct sunrpc_net *sn;
> -
> -	sn =3D net_generic(net, sunrpc_net_id);
> -	return __ip_map_lookup(sn->ip_map_cache, class, addr);
> -}
> -
> static int __ip_map_update(struct cache_detail *cd, struct ip_map *ipm,
> 		struct unix_domain *udom, time64_t expiry)
> {
> --=20
> 1.8.3.1
>=20

--
Chuck Lever



