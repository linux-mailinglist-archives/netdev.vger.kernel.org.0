Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1DA3ED05B
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 10:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhHPIeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 04:34:24 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36372 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235014AbhHPIeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 04:34:23 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17G8WcFQ002932;
        Mon, 16 Aug 2021 08:33:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2021-07-09; bh=my+NVrFi3SMEh1O+1a7VE5Q2gtSPMN9s0XFCWqu01mk=;
 b=ulpd+rkNp3kQpi2sCNtBYRMVVzxznO0I85WInZN74+BnJJXTdU84MI67e6hAwQIezxcS
 Ai2xvid5w/Fhg6qvqMznVU7RIvmOvEuDAv1kNdMPR1DTM5SQer9fU2ftdgjPzPShI9EZ
 fKAMaAA37W93bj5gcAXfdiIdhS+j+9vw+Fxbr6Kkad2IehlKdFa0oA+EFCwhblu5Uxtw
 6p65iuFQwYO5d2VEKDR234cYtkcjhK9VmAdgjFstc4R0zVWtH1k7HFWqTwB1mjxadev+
 AFyYpyLWdl5sTY0nZ7t3JZYU/0tXHbHi+xQDXUxwOrH9Sj4pLoeBs/+7+0NgyzR5/uHR EA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : in-reply-to : mime-version;
 s=corp-2020-01-29; bh=my+NVrFi3SMEh1O+1a7VE5Q2gtSPMN9s0XFCWqu01mk=;
 b=wrzSfe8lMTZEYYZ/0vi4T7sVb2VJ94XBZqC5bV0FSmeCZDeeome0mt8vouGFBHoHqfCm
 2xq1o0EKkqsw4EHgd4+E6EeOll3f392IlUM6pUrzuGiUnXc5kxIAS+/GPhQPUxb9c2zf
 EP/86rWq7pbplE02UanvNzUXukIVipjzcBjNvunebXFIqarvCpMkw79O5xiCSzmW7XTr
 E/IkiJSJkIHXmyf0u4jzMnnGlL7uDm4JFhU6QoiW0Ero4/GjUua9n7mHu4xROpq2A+NR
 6Zs0N9WU45wFeg+4IozhFB/wNtpx31kJLjbelbLDWWWM3hpHk/dJxfsF3PUXrQvWBCzS uA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3af83013tp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 08:33:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17G8UrkL059819;
        Mon, 16 Aug 2021 08:33:45 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3020.oracle.com with ESMTP id 3aeqkrs4p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Aug 2021 08:33:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxoMp2JYOFzrZ+ftDKFNUY3Yr4IHwlg3Q3jJGSlVtw3oRSl/65477mfH8LdHF+sqZ6CESDtpBrCd5bgsoaT46cpyoe87fSV+QY6OGT9kAYCoqkTOq6mo9Wryqu2wPGoxWAz++zJGHbECaMuYZSzsetKd2U5mnAMLePqrQWY/jdQ4HBCbIvGa71KT3OnQU3Wf5j9QFb2AvDg8bOsvZNU2KNUIqEtQjFIDhTkSn7kNkA0AC0syQg2AgHbP4/Dr3QJEAa34Md1pNKbNJmRVuHAX+VoITGVQrPT7l3Bvr8hEfHxoapiUaqEMO24Mfpv4pf890DQ5HwOXMCnDUfzIH1EgnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=my+NVrFi3SMEh1O+1a7VE5Q2gtSPMN9s0XFCWqu01mk=;
 b=btIt6hDjbjGtCBFOmuIYW7aEl5jsTkjgIu882DDeq8ATntM02M8/L4GP4bBLXt+BaOcXHThTsCBIbfp21Ww1ov/5cLk0ljQIKmy7ZuuOU5iPG4v4dg9UbUzYTZbyGTqIW/5oox0Wg2INGuLAh3n7XFzAFsC2qKzpiyLjBWan+sU9E0m9+eKaXj6m8HMLUdwzPOo+a8k/5fY3o+OopSWiYhWm2yaZuW2qFMhM4ZLJ1VdwcDN8mIJITjbjwjjwg8ksI8m1WCWqvpoW0coFpX+pBbKsLgbFtvpKrm1s8RWxVmKCs6LaXOLkt+MJHYc9+SFsR5PYAQCiYFSz+2o0Xnb1eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=my+NVrFi3SMEh1O+1a7VE5Q2gtSPMN9s0XFCWqu01mk=;
 b=hPveWfUAjFy0NHFVBTL87XDWk5NBaqBwMbVqnmgpFPHh4BeUtQCt1x60cVdpkbCV9oUz2DcXeWb4+EhsUjQHI8kREgPryRuBuT4XZ1LS6GAs0481ZnJPlbHCP7QKkOIIPcG+54XEZw6SoInwhNv2XF123UqM9EuUUzIa+2FT0Jw=
Authentication-Results: lists.01.org; dkim=none (message not signed)
 header.d=none;lists.01.org; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by MWHPR10MB1951.namprd10.prod.outlook.com
 (2603:10b6:300:10a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Mon, 16 Aug
 2021 08:33:43 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5820:e42b:73d7:4268%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 08:33:42 +0000
Date:   Mon, 16 Aug 2021 11:33:26 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Nikolay Aleksandrov <razor@blackwall.org>,
        netdev@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net-next 4/6] net: bridge: mcast: dump ipv4 querier state
Message-ID: <202108140311.dorJxbPR-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813150002.673579-5-razor@blackwall.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JNAP275CA0033.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::14)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (62.8.83.99) by JNAP275CA0033.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:4d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Mon, 16 Aug 2021 08:33:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 18a1943d-a135-4327-4a45-08d960908e3c
X-MS-TrafficTypeDiagnostic: MWHPR10MB1951:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1951CA2457ADC372A273B61D8EFD9@MWHPR10MB1951.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 48meXcQ9VFLfBSuI6QbW+BrpeGLXLYLlBEn3cenXElxq3bLCULcwEhC+jo3gE+CpFEmxVlVldFkiADpASjOqn2vL2AaIKddCOmAiYvNn5hw92CGaght45XsNvMRjvF6qLs1IyM9rII9Sq3nrfhiisb63SOn/z+TYkUra33SB6vgvLhAUoBwuMR1V3G78j8eAhaOqFdxjf/DdwsJ/GZvEjzxS4MmmWAnQWA4q1g5bMQCeEWKPSbq0rZLZsYNbv1XOYvCTAxb3Uyxaa1vyRTiB0HHb9qp+ySHidAIq3VxExQkopJmAsKvEqnTvHaqLI/NMxNZNRkntuBEcKxNCuJqCEb5P4LIih7XVHbh9WeGPj8IcfigZaqRLG8qEKD6Wze/g1gtnM7xw3f74U8P9+zH+YrCAEK2UfvsXWg87rxYOLDUwzbqcNXDDiax46EOGST4hsmH36VJfqfwQ1Fk407rDYFvZZuWAc46vmRpTDtj9bmXnPPw/DY1uwrF6ZMediSwKcMjY0zj7Vk6VP+/3p0u4dylym5m2H1JezfkiYybKuvyX3xF73x9vI9j3rPXRmCpn2yDtPMr4ydlD+O6LF8B1ECxpEqh34zNlYXqZIQd92UHNavgABihurQQp2FjL4PDMg63B3LZBOkVqJhyBXQLbQ7BNNFc7EtsnivblTbhf7h7Esf/IJTp+z0iF3pXhVdcerayqOKALyfl9E2sRDUDXyq06aPLmhfHdo3jCDOOE/4DU3SNU6s8SqwYoGy1OYwsoPnY5lvgkl0XXsYEOHbLW2mBTXIF41UgRCAx7+SepIrkj0FKBiXOXWElooPdOBhrAmMF/mwPxZiPrKNuPfWHusg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(44832011)(66476007)(4326008)(6486002)(66556008)(8676002)(66946007)(6666004)(5660300002)(83380400001)(956004)(9686003)(1076003)(966005)(8936002)(52116002)(38100700002)(38350700002)(2906002)(316002)(6496006)(26005)(36756003)(508600001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kJwdOXvpwl6+4agHM9J8+URVRsX3oO4RGtX7e8JlV5yOCBNEs5KlfdO8gKnp?=
 =?us-ascii?Q?pgbHcWdEpg5fCKjLIR+JyG4ynAVUdKjeXosdJqq0b6gdQs/bll+QrJfrFkd+?=
 =?us-ascii?Q?3AaX0VmIfmfQWBTXgIH6BrGDEyJLzWP2TKUrd56hFUi3Yr4tJNNpwjPhMjCv?=
 =?us-ascii?Q?/S5SzYwaaQhdxEF31gi+zPlTDtEHpfLPkGZo9kKmfCcQi8SRoruV51V2bLVM?=
 =?us-ascii?Q?+/dL30mtx4N8D72UZ0+3dhARiIz+uZ6TksYY4KAn60sdTD61225JamIEQ7OX?=
 =?us-ascii?Q?L8+5g0wEx19Ge0fJz6KyrjOVyKXoEWL792ZuyIvX5LB4KeUR/uJ1rktI88v5?=
 =?us-ascii?Q?u8cGd2R7DRxYYgHOZyXMFx3zGu65lpOmGsNZ0uzXRyGJMfN3pZtTlIlwlnJa?=
 =?us-ascii?Q?hfpYAaChJ+P2pOTwP8CwEpcB3q5AqrEfLMvAavxXGx7iJruv6kPzs0Pyoe0X?=
 =?us-ascii?Q?3djnB1wl/sAT68hijWfDp0OxtD6ZQv9ahxXHYh+rbYhCk/pxK/6u0tEvCp+5?=
 =?us-ascii?Q?slWXhZLztV33YbTqSemoEzC39lRhuM3xmwOY4srkyPZoKu55AdqWleRz22HW?=
 =?us-ascii?Q?L1gkSekSRAqn/ImiBOz0jO8RNgtX7pzNaukR2yJO9YEVWc3aDVl5MRp74Fid?=
 =?us-ascii?Q?aaOL0lKMuVqEoW1U1Mv7+kywGEPmdjZeQu0I44R9bOaK6dC8VjnqTHFCJcPY?=
 =?us-ascii?Q?cCpfSHcvsQdbdKcDzB7/ACr5S9N6o93AUr1NJCZBaMKSiCmdJsV4ywP3lBrb?=
 =?us-ascii?Q?3OuXALVwQYuvyYnEAY3rpoHx43RlGd8plL7g119wZnhKw7Sv+WyBsaTEjfoe?=
 =?us-ascii?Q?lPb7oH7I2SpkA9l9a2LMdZkT0Gm4lEqsE6r4LIjlysdyYmYrHgo8b+zXFJl+?=
 =?us-ascii?Q?7xv9x8+bXQkmFGwdX9aEzKFDq7nqrOOmhT63t2bbFN6xm1QSm1R+bX/H2+Ua?=
 =?us-ascii?Q?bnEumwkZNzKJBHymFv8JSKalTokClVjGw4Is5ATFC2g9TIk/RWLW/L+RdspH?=
 =?us-ascii?Q?QF5UBS+TYmYXdtB+VzsRpHAtawm2INH4U2O4Nv9YDlHfb8bSoCaialVD3TDY?=
 =?us-ascii?Q?JRERSCG3rlCAztT6x+g/cWexO6i5PS8MLX0oi3iqnbTjuKtTUEJ1cdEaTGOh?=
 =?us-ascii?Q?psxms9Fc79ytQzLmWzuaQsGuyyknEVqmpHDWfT8L0GvefAYXVHZM8Q5vMMZw?=
 =?us-ascii?Q?QXVK1vk/vorO6uQD6B/ByfwdKZtw386md8Qnp+jIVbK8LxR9//dFEzH13t+s?=
 =?us-ascii?Q?jM6YDcnUUna3/3KubeAzmzW8wyoQyTO7h/G9ShxRAO6mr4DhepLEaY5M7wOb?=
 =?us-ascii?Q?ToikNl2I8GQbLrybI+NSS2z5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18a1943d-a135-4327-4a45-08d960908e3c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 08:33:42.9027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y0khcTqr52TH3M1zOsWetOyjNScCevW2mLgk2+vNsH3aI0z5nYJ+mvYlvrIUFE5/DA23F/+E7r8ce6JovjrmVs8BCx3TE8iwuog8QTII/XQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1951
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10077 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108160054
X-Proofpoint-ORIG-GUID: J64TnAsrMqYFzfwhYdW_k8Kq2DGm9UTG
X-Proofpoint-GUID: J64TnAsrMqYFzfwhYdW_k8Kq2DGm9UTG
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

url:    https://github.com/0day-ci/linux/commits/Nikolay-Aleksandrov/net-bridge-mcast-dump-querier-state/20210813-230258
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git b769cf44ed55f4b277b89cf53df6092f0c9082d0
config: x86_64-randconfig-m001-20210814 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
net/bridge/br_multicast.c:2931 br_multicast_querier_state_size() warn: sizeof(NUMBER)?

vim +2931 net/bridge/br_multicast.c

384d7e0455593b Nikolay Aleksandrov 2021-08-13  2929  size_t br_multicast_querier_state_size(void)
384d7e0455593b Nikolay Aleksandrov 2021-08-13  2930  {
384d7e0455593b Nikolay Aleksandrov 2021-08-13 @2931  	return nla_total_size(sizeof(0)) +      /* nest attribute */
                                                                              ^^^^^^^^^
This looks like it's probably intentional, but wouldn't it be more
readable to say sizeof(int) as it does below?

384d7e0455593b Nikolay Aleksandrov 2021-08-13  2932  	       nla_total_size(sizeof(__be32)) + /* BRIDGE_QUERIER_IP_ADDRESS */
384d7e0455593b Nikolay Aleksandrov 2021-08-13  2933  	       nla_total_size(sizeof(int)) +    /* BRIDGE_QUERIER_IP_PORT */
384d7e0455593b Nikolay Aleksandrov 2021-08-13  2934  	       nla_total_size_64bit(sizeof(u64)); /* BRIDGE_QUERIER_IP_OTHER_TIMER */
384d7e0455593b Nikolay Aleksandrov 2021-08-13  2935  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

